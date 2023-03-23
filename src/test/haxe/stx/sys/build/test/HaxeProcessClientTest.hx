package stx.sys.build.test;

using stx.io.Process;
import stx.sys.build.term.haxe.HaxeProcessClientCtr;
import stx.sys.build.term.haxe.HaxeProcessProxyCtr;

class HaxeProcessClientTest extends TestCase{
  @stx.test.async
  @timeout(10000)
  public function test(async:Async){
    final proxy  = HaxeProcessProxyCtr.make(['--help']);
    var done = false;
    proxy.toExecute().environment(
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