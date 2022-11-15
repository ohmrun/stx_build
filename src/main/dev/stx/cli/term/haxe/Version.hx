package stx.sys.cli.term.haxe;

class Version extends OptionLongSpec{
  public function new(){
    super(
      'version',
      'print version and exit',
      FlagKind,
      false,
    );
  }
}