package stx.build.term.haxe;

class HaxeProcessClientCtr{
  static public function make():ProcessClientDef<Noise>{
    return ProcessClient.Timer(ProcessClient.NotErrored(__.ended(Tap)),100);
  }
}