package stx.cli.term;

using stx.sys.Cli;

final s = __.cli().spec();

class Spec{
  static public function reply(){
    return s.Make(
      'root',
      'build any project',
      [],
      [],
      [build(),run()]
    );
  }
  static function build(){
    return s.Make(
      'build',
      'haxe compiler section',
      [],
      [
        s.Argument('build section',"selector for build incantation",true)
      ],
      []
    );
  }
  static function run(){
    return s.Make(
      'run',
      'command runner',
      [],
      [
        s.Argument('run section',"selector for command runner",true)
      ],
      []
    );
  }
}