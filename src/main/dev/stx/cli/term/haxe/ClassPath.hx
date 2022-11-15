package stx.sys.cli.term.haxe;

class ClassPath extends PropertyDefaultSpec{
  public function new(){
    super(
      'classpath',
      'add a directory to find source files',
      true,
      false
      'p'
    );
  }
}