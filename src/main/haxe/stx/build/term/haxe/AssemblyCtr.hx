package stx.build.term.haxe;

class AssemblyCtr{
  static public function unit():Assembly{
    return (str:String) -> {
      __.log().trace(str);
      return switch(str == 'build'){
        case true  : 
          Some(
            (expr:PExpr<Atom>,path:Cluster<String>) -> {
              __.log().trace('$expr');
              final result = stx.build.term.haxe.Lexer.main().apply([expr].reader());
              final output = 
                result.toRes()
                      .errate(e -> (e:BuildFailure))
                      .adjust(
                        opt -> opt.fold(
                          ok -> __.accept(ok),
                          () -> __.reject(f -> f.of(E_Build_EmptyBuildFile))
                        )
                      ).adjust(Interpreter.apply.bind(_,path.tail()))
                       .map(
                        (out:Cluster<Couple<String,Option<String>>>) -> {
                          final args = 
                            out.map(
                              __.decouple(
                                (x:String,y:Option<String>) -> y.map(y -> [x, y]).defv([x])
                              )
                            ).flat_map(x -> x);
                          trace(args);
                          return ProcessServer.make(
                            ['haxe'].imm().concat(
                              args
                            )
                          ).errate((e) -> (e:BuildFailure));
                        }
                       ).map(
                          server -> Server.lift(server)
                           .connect(
                            function(res:ProcessResponse){
                              return ProcessClient.Reply()
                                .errate((e -> (e:BuildFailure)))
                                .adjust((r) -> { trace(r); return __.accept(Noise);});
                              }
                            ).agenda(r -> {})
                             .toExecute()
                       ).fold(
                          ok -> ok,
                          no -> {
                            __.log().error('$no');
                            return Execute.pure(__.fault().of(E_Build_NoRequest));
                          }
                       );
              return output;
            }
          );
        case false : None;
      }
    }
  }
}