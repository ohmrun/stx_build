package stx.sys.build.term.haxe;

class Assembly extends stx.sys.build.Assembly{
  public function apply(str:String){
    return switch(str == 'build'){
      case true  : 
        Some(
          (expr:PExpr<Atom>,path:Cluster<String>) -> {
            __.log().trace('$expr');
            final result = stx.sys.build.term.haxe.Lexer.main().apply([expr].reader());
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
                        final args      = (out:Args).toArgs();
                        final agenda    = HaxeProcessProxyCtr.make(args);
                        return agenda.toExecute();
                      }
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