package stx.sys.build;

using stx.Coroutine;
using stx.Proxy;

class Program implements ProgramApi extends ProgramCls{
  public final spec       : Spec;
  public final assemblies : Cluster<AssemblyApi>;

  static public function unit(){
    return new stx.sys.build.Program(
      stx.sys.build.Spec.reply(),
      [
        new stx.sys.build.term.haxe.Assembly(),
        new stx.sys.build.term.run.Assembly()
      ]
    );
  }
  public function new(spec:Spec,assemblies:Cluster<AssemblyApi>){
    this.spec         = spec;
    this.assemblies   = assemblies;
  }
  public function apply(res:Upshot<CliContext,CliFailure>):Agenda<CliFailure>{
    /**Get the specs from the assemblies.**/
    final next_spec = assemblies.lfold(
      (next:AssemblyApi,memo:Spec) -> memo.with_rest(map -> map.set(next.name,next.spec)),
      spec
    );
    /**Apply the context**/
    return res.fold(
      comply.bind(next_spec),
      e -> Agenda.lift(__.ended(End(e)))
    );
  }
  private function comply(spec:Spec,ctx:CliContext):Agenda<CliFailure>{
    final spec_value = (ctx.apply(spec).toUpshot())
    .errate(e -> (e:CliFailure))
    .fold(
      opt -> opt.fold(
        ok -> __.accept(ok),
        () -> __.reject(f -> f.of(E_Cli_NoSpec))
      ),
      e -> __.reject(e)
    ).errate(e -> (e:BuildFailure));
    
    final expr       = stx.sys.build.StxPml.reply().provide(__.asys().local());
    final ass_ctx    = expr.adjust(
      expr -> spec_value.map(
        spec -> new AssemblyContext(ctx,expr,spec)
      )
    );
    final sass       = (x:String) -> assemblies.search(
      ass -> ass.name == x
    );
    final assembly = spec_value.adjust(
      x -> x.args.head().resolve(
        f -> f.of(E_Build_NoRequest)
      ).flat_map(
        opt -> opt.data.resolve(
          f -> f.of(E_Build_NoRequest)
        ).flat_map(
          str -> sass(str).resolve(
            f -> f.of(E_Build_NoSection(str))
          )
        )
      )
    );
    
    //$type(assembly);
    //$type(ass_ctx);
    //$type(expr);
    final assembled = 
      ass_ctx.adjust((ctx:AssemblyContext) -> assembly.map(a -> a.apply(ctx)))
             .errate(e -> (e:BuildFailure));

    //$type(assembled);
    final result    = Agenda.lift(__.belay(Belay.lift(Provide.lift(assembled.prj().map(
      res -> res.fold(
        ok  -> ok,
        e   -> Agenda.lift(__.ended(e.errata(eI -> eI.errate(eII -> E_Cli_Embed(() -> throw(e))))))
      ).prj()
    )))));
    return result;
  }
}