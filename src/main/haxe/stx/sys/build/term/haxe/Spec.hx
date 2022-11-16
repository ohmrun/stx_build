package stx.sys.build.term.haxe;

using stx.sys.Cli;

final s = __.cli().spec();

class Spec{
  static public function reply(){
    return s.Make(
      CliConfigCtr.unit(),
      'build',
      'haxe compiler section',
      [],
      [
        s.Argument('build section',"selector for build incantation",true)
      ],
      None
    );
  }
}