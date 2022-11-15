package stx.sys.build.term.haxe;

class HaxeProcessProxyCtr{
  static public function make(args:Cluster<String>):Agenda<BuildFailure>{
    final server = Server.lift(ProcessServer.make(['haxe'].imm().concat(args)));
    final client = HaxeProcessClientCtr.make();

    final proxy  = Agenda.lift(server.connect(
      (function rec(client,y:ProcessResponse){ 
        trace(y);
        return switch(__.tracer()(client)){
          case Await(a,nx)  : 
            trace(a);
            nx(y);
          case Defer(x)     : 
            trace(x);
            __.belay(
              x.mod(y -> {
                trace(y);
                return client;
              })
            );
          default           :
            __.ended(__.fault().of(E_Process_Unsupported('UNIMPLEMENTED')));
        }
      }).bind(client)
    ).agenda(
      (x) -> {}
    ).errate(E_Build_Process));
    return $type(proxy);
  }
}