package stx.sys.build.term.run;

final s = __.cli().spec();

class Spec{
  static public function reply(){
    return s.Make(
      CliConfigCtr.unit(),
      'run',
      'command runner',
      [],
      [
        s.Argument('run section',"selector for command runner",true)
      ],
      None
    );
  }
}