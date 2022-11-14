package stx.build.term.haxe;

using stx.Parse;
import eu.ohmrun.pml.Extract.*;

final id = __.parse().id;

class Lexer{
  static public function main(){
    return imbibe(
      build(),
      'main'
    );
  }

  static public function buildI(){
    return imbibe(
      item().one_many().then(arr -> arr.flat_map(x -> x)),
      "buildI"
    );  
  }
  static public function build(){
    return imbibe(
      symbol('build')._and(
        item().one_many().then(arr -> arr.flat_map(x -> x))
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
  //TODO: leaning on Haxe compiler atm.
  static public function single_properties(){
    return [ '-main' ];
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
  static public function item():Parser<PExpr<Atom>,Cluster<Token>>{
    return 
      haxe_flag().then(x -> [x].imm())//.inspect(x -> trace(x),x -> trace(x))
      .or(haxe_property_list())
      .or(haxe_property().then(x -> [x].imm()))
      .or(section.cache().then(x -> [x].imm()));
      //.inspect(x -> trace(x),x -> trace(x));
  } 
}