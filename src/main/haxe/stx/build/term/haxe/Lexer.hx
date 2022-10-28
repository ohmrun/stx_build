package stx.build.term.haxe;

using eu.ohmrun.Pml;
using stx.Parse;
import eu.ohmrun.pml.Extract.*;

enum HaxeBuildToken{
  HTArg(key:String,val:Option<String>);
  HTSec(name:String,tks:Cluster<HaxeBuildToken>);
}
private typedef AccumState = { tokens : Cluster<HaxeBuildToken> , path : Cluster<String> };
private typedef OutState   = Cluster<Couple<String,Option<String>>>;
class HaxeBuildTokenLift{
  static public function apply(self:Cluster<HaxeBuildToken>,path:Cluster<String>){
    return Iter.lift(Unfold.unfold(
      __.accept({ tokens : self, path : path }), 
      function ( obj : Res<AccumState,BuildFailure> ) : Option<Couple<Res<AccumState,BuildFailure>, Res<OutState,BuildFailure>>> {
        return obj.fold(
          (ok:AccumState) -> {
            function get_tokens(){
              return ok.tokens.map_filter(
                x -> switch((x)){
                  case HTArg(k,v)   : Some(__.couple(k,v));
                  default           : None;
                }
              );
            }
            function get_level(next){
              return ok.tokens.search(
                (x) -> switch(x){
                  case HTSec(name,_) if (name == next) : true;
                  default                              : false;
                }
              ).resolve(f -> f.of(E_Build_NoSection(next)))
               .map(
                x -> switch((x)){
                  case HTSec(_,xs)  : xs;
                  default           : [].imm();
                }
              );
            }
            return ok.path.head().fold(
              node -> {
                final then = get_level(node);
                return then.map(
                  level -> {
                    tokens : level,
                    path   : ok.path.tail() 
                  }
                ).fold(
                  ok -> Some(__.couple(__.accept(ok),__.accept(get_tokens()))),
                  no -> Some(__.couple(__.reject(no),__.reject(no)))
                );
              },
              () -> {
                final tokens = get_tokens();
                return if(ok.tokens.is_defined()){
                  Some(__.couple(__.accept({ path : [].imm(), tokens : [].imm() }), __.accept(tokens)));
                }else{
                  None;
                }
              }
            );
          },
          no -> None
        );
      }
    )).lfold(
      (next:Res<OutState,BuildFailure>,memo:Res<OutState,BuildFailure>) -> {
        return memo.zip(next).map(
          __.decouple((x:OutState,y:OutState) -> x.concat(y))
        );
      },
      __.accept([])
    );
  }
  static public function invoke(){

  }
}
typedef HaxeContext = {
  final args : Cluster<Couple<String,Option<String>>>;
  final rest : Ensemble<HaxeContext>;
}
final id = __.parse().id;

class Lexer{
  static public function main(){
    return imbibe(
      build(),
      'main'
    );
  }
  static public function build(){
    return imbibe(
      symbol('build')._and(
        section().one_many()
      ),
      "build"
    );  
  }
  static public function flags(){
    return [
      '--no-traces','--no-output','--no-inline','--no-opt',
      '--interp',
      '--next','--each',
      '--display',
      '--flash-strict',
      '--verbose','-v',
      '-h','--help','--help-defines','--help-metas', 
      '--version'
    ];
  }
  static public function single_properties(){
    return [
      '-main'
    ];
  }
  static public function haxe_flag_filter(){
    return __.parse().alts(flags().map(x -> text(x)));
  }
  static public function haxe_arg_name(){
    return matches(
      id("--").or(id("-")).and(Parse.word).and_(Parsers.Eof()).then(__.decouple((x,y) -> '$x$y'))
    );
  }
  static public function haxe_flag(){
    return haxe_flag_filter().then(x -> HTArg(x,None));
  }
  static public function haxe_property(){
    return imbibe(
      haxe_arg_name().and(wordish()).then(__.decouple((x,y) -> HTArg(x,Some(y)))),
      "haxe_property"
    );
  }
  static public function haxe_property_list(){
    return imbibe(
      haxe_arg_name().and(imbibe(wordish().one_many(),'haxe_property_list#1')).then(
        __.decouple(
          (x,y:Cluster<String>) -> {
            return __.option(y).defv([]).map(
              y -> HTArg(x,Some(y))
            );
          }
        )
      ),
      "haxe_property_list"
    ).tag_error('haxe_property_list');
  }
  static public function section(){
    return imbibe(
      wordish()
      .and(item().many())
          .then(tp -> tp.map(arr -> arr.flat_map(x -> x)))
          .then(__.decouple((x,y) -> HTSec(x,y))),
      "section"
    );
  }
  static public function item(){
    return 
      haxe_flag().then(x -> [x].imm())
      .or(haxe_property_list())
      .or(haxe_property().then(x -> [x].imm()))
      .or(section.cache().then(x -> [x].imm()));
      //.inspect(x -> trace(x),x -> trace(x));
  } 
}