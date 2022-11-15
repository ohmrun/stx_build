package stx.sys.build.test;

import stx.sys.build.term.haxe.AssemblyCtr;

class AssemblyTest extends TestCase{
  @stx.test.async
  public function test(async:Async){
    Execution.comply(
      [
        AssemblyCtr.unit()
      ],
      ["build","test","interp"]
    ).environment(
      () -> {
        trace('done');
      },
      (e) -> {
        trace(e);
        __.raise(e);
      }
    ).submit();
    async.done();
  }
}