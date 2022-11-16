package stx.sys.build.term.run;

class Assembly implements stx.sys.build.AssemblyApi{
  public final name     : String;
  public final spec     : Spec;
    
  public function new(){
    this.name     = 'run';
    this.spec     = stx.sys.build.term.run.Spec.reply();
  }
  public function apply(ctx:AssemblyContext){
    return Agenda.lift(__.ended(End(__.fault().of(E_Cli_NoImplementation))));
  }
}