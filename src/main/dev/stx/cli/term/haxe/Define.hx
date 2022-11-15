package stx.sys.cli.term.haxe;

class Define extends PropertyDefaultSpec{
  public function new(){
    super(
      'define',
      "define a conditional compilation flag",
      true,
      false,
      "D" 
    );
  }
}