package stx.sys.cli.term.haxe;

class HelpMetas extends OptionLongSpec{
  public function new(){
    super(
      'help-metas',
      'print help for all compiler metadatas',
      FlagKind,
      false,
      'help-metas'
    );
  }
}