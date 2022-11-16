package stx.sys.build;

final s = __.cli().spec();

class Spec{
  static public function reply(){
    return s.Make(
      CliConfigCtr.unit(),
      'root',
      'build any project',
      [],
      [],
      None
    );
  }
}