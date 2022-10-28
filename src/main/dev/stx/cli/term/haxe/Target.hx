package stx.cli.term.haxe;

class Target implements OptionSpecApi extends OptionSpecCls{
  public function new(){
    super(
      'target',
      'build target',
      PropertyKind(false),
      false
    );
  }
  override public function matches(string:String){
    return CompilerTarget.fromString(string.substr(2)).is_defined();
  }
}