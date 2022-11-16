package stx.sys.build;

import stx.sys.build.Program;

class Run{
  static public function reply(){
    stx.sys.cli.Run.handlers.add(
      { data : stx.sys.build.Program.unit() }
    );
    stx.sys.cli.Run.react();
  }
}