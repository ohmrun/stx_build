package stx.sys.build;

class AssemblyContext{
  public final cli  : CliContext;
  public final expr : PExpr<Atom>; 
  public final spec : SpecValue;

  public function new(cli,expr,spec){
    this.cli  = cli;
    this.expr = expr;
    this.spec = spec;
  }
}