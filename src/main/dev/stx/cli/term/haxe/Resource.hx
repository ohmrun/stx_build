package stx.sys.cli.term.haxe;

class Resource extends OptionLongSpec{
  public function new(){
    super(
      'resource',
      'add a named resource file',
      FlagKind,
      false,
      'help-defines'
    );
  }
}