package stx.fail;

enum BuildFailureSum{
  E_Build_NoRequest;
  E_Build_Fail(?explanation:String);
  E_Build_EmptyBuildFile;
  E_Build_Parse(f:ParseFailure);
  E_Build_Fs(f:FsFailure);
  E_Build_NoSection(name:String);
  E_Build_Process(f:ProcessFailure);
  E_Build_Cli(f:CliFailure);
}
@:transitive abstract BuildFailure(BuildFailureSum) from BuildFailureSum to BuildFailureSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:BuildFailureSum):BuildFailure return new BuildFailure(self);

  public function prj():BuildFailureSum return this;
  private var self(get,never):BuildFailure;
  private function get_self():BuildFailure return lift(this);

  @:from static public function fromFsFailure(f){
    return lift(E_Build_Fs(f));
  }
  @:from static public function fromParseFailure(f){
    return lift(E_Build_Parse(f));
  }
  @:from static public function fromProcessFailure(f){
    return lift(E_Build_Process(f));
  }
  @:from static public function fromCliFailure(f){
    return lift(E_Build_Cli(f));
  }
}