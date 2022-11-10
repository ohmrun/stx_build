package stx.build.test;

using stx.io.Process;
import stx.build.term.haxe.HaxeProcessClientCtr;

class HaxeProcessClientTest extends TestCase{
  @stx.test.async
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
    // function handler(x){
    //   trace(x);
    //   switch(x){
    //     case Defer(x) : 
    //       x.prj().environment(
    //         Noise,
    //         handler,
    //         (_) -> {}
    //       ).submit();
    //     default : trace(x);
    //   }
    // }
    // final agenda = proxy.agenda(
    //   (_) -> {
    //     trace('TEST DONE');       
    //   }
    // );
    //handler(agenda);
    proxy.agenda(
      (_) -> {
        trace('TEST DONE');       
      }
    ).toExecute()
     .environment(
      () -> {
        if(!done){
          pass();
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