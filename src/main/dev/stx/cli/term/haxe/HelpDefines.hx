package stx.sys.cli.term.haxe;

class HelpDefines extends OptionLongSpec{
  public function new(){
    super(
      'help-defines',
      'print help for all compiler specific defines',
      FlagKind,
      false,
      'help-defines'
    );
  }
}