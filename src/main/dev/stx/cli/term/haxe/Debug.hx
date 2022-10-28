package stx.cli.term.haxe;

class Debug extends OptionLongSpec{
  public function new(){
    super(
      'debug',
      'add debug information to the compiled code',
      false,
      FlagKind,
      'debug'
    );
  }
}