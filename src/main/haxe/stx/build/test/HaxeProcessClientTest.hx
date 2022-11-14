package stx.build.test;

using stx.io.Process;
import stx.build.term.haxe.HaxeProcessClientCtr;

class HaxeProcessClientTest extends TestCase{
  @stx.test.async
  @timeout(10000)
  public function test(async:Async){
    final server = Server.lift(ProcessServer.make(['haxe','--help']));
    final client = HaxeProcessClientCtr.make();
    final proxy  = server.connect(
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
    );
    var done = false;
    proxy.agenda(
      (_) -> {
        trace('TEST DONE');       
      }
    ).toExecute()
     .environment(
      () -> {
        if(!done){
          trace ('done');
          async.done();
          done = true;
        }else{
          throw "pants";
        }
      },
      (e) -> {
        trace(e);
      }
     ).submit();
  }
}