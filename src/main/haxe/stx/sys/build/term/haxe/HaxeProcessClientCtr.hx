package stx.sys.build.term.haxe;

/**
  Process Client Specification.
**/
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