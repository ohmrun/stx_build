package stx.build;

typedef AssemblyDef = String -> (Option<PExpr<Atom> -> Cluster<String> -> Execute<BuildFailure>>);

@:callable abstract Assembly(AssemblyDef) from AssemblyDef to AssemblyDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:AssemblyDef):Assembly return new Assembly(self);

  public function prj():AssemblyDef return this;
  private var self(get,never):Assembly;
  private function get_self():Assembly return lift(this);
}