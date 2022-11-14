package stx.build.term.haxe;

class HaxeProcessClientCtr{
  static public function make():ProcessClientDef<Noise>{
    return ProcessClient.NotErrored(ProcessClient.Reply().adjust(
      x -> {
        trace(x);
        return __.accept(Noise); 
      }
    ));
  }
}