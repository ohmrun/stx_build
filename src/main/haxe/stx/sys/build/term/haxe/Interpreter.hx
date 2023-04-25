package stx.sys.build.term.haxe;

using stx.Show;

private typedef AccumState = { tokens : Cluster<Token> , path : Cluster<String> };

class Interpreter{
  static public function apply(self:Cluster<Token>,path:Cluster<String>){
    return Iter.lift(Unfold.unfold(
      __.accept({ tokens : self, path : path }), 
      function ( obj : Upshot<AccumState,BuildFailure> ) : Option<Couple<Upshot<AccumState,BuildFailure>, Upshot<Args,BuildFailure>>> {
        return obj.fold(
          (ok:AccumState) -> {
            __.log().trace(__.show(ok.tokens));
            function get_tokens(){
              __.log().trace('${ok.tokens}');
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
                __.log().trace('level $node $then');
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
                __.log().trace('$tokens');
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
      (next:Upshot<Args,BuildFailure>,memo:Upshot<Args,BuildFailure>) -> {
        return memo.zip(next).map(
          __.decouple((x:Args,y:Args) -> x.concat(y))
        );
      },
      __.accept([])
    );
  }
}