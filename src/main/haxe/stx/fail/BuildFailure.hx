package stx.fail;

enum BuildFailureSum{
  E_Build_NoSection(name:String);
}
abstract BuildFailure(BuildFailureSum) from BuildFailureSum to BuildFailureSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:BuildFailureSum):BuildFailure return new BuildFailure(self);

  public function prj():BuildFailureSum return this;
  private var self(get,never):BuildFailure;
  private function get_self():BuildFailure return lift(this);
}