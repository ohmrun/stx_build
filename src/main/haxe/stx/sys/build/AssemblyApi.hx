package stx.sys.build;

interface AssemblyApi{
  public final name     : String;
  public final spec     : Spec;

  public function apply(ctx:AssemblyContext):Agenda<CliFailure>;
}