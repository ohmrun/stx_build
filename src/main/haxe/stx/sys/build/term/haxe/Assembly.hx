package stx.sys.build.term.haxe;

class Assembly implements stx.sys.build.AssemblyApi{
  public final name     : String;
  public final spec     : Spec;
    
  public function new(){
    this.name     = 'build';
    this.spec     = stx.sys.build.term.haxe.Spec.reply();
  }
  public function apply(ctx:AssemblyContext):Agenda<CliFailure>{
    final result  = stx.sys.build.term.haxe.Lexer.main().apply([ctx.expr].reader());
    final scope   = ctx.spec.rest;
    final path    = scope.flat_map(spec -> spec.args.head()).flat_map(opt -> opt.data).map(str -> str.split("/")).defv([]);
    final output  = 
      result.toUpshot().errate(e -> (e:BuildFailure))
            .adjust(
              opt -> opt.fold(
                ok -> __.accept(ok),
                () -> __.reject(f -> f.of(E_Build_EmptyBuildFile))
              )
            ).adjust(Interpreter.apply.bind(_,path.tail())
            ).map(
              (out:Cluster<Couple<String,Option<String>>>) -> {
                final args      = (out:Args).toArgs();
                final agenda    = HaxeProcessProxyCtr.make(args);
                return agenda;
              }
             ).fold(
              ok -> ok,
              no -> {
                __.log().error('$no');
                return Agenda.lift(__.ended(End(__.fault().of(E_Build_NoRequest))));
              }
             ).errata(e -> e.errate(x -> E_Cli_Embed(() -> throw(e))));
    return Agenda.lift(output);
  }
}