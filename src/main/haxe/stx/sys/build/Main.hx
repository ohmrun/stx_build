package stx.sys.build;

using stx.Log;

import stx.sys.build.Program;

class Main{
  static public function main(){
    __.log().configure(
      log -> log.with_filter(
        logic -> logic.or(
          logic.tags(
            [
              "stx/sys/build",
              "stx/sys/cli",
              "stx/stream",
              "eu/ohmrun/fletcher"
            ]
          ).and(
            logic.level(INFO)
          )
        )
      )
    );
    final log = __.log().global;
          log.includes.push("stx/sys/build");
          log.includes.push("stx/sys/cli");
          log.includes.push("stx/stream");
          log.includes.push("eu/ohmrun/fletcher");
          log.level = INFO;
    react();
  }
  static public function react(){
    __.log().trace('react');
    stx.sys.cli.Run.handlers.add(
      { data : stx.sys.build.Program.unit() }
    );
    stx.sys.cli.Run.react();
  }
}