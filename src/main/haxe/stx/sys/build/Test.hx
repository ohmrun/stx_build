package stx.sys.build;

using stx.Test;

import stx.sys.build.test.*;

class Test{
  static public function tests(){
    return [
      new PmlLexTest(),
      new AssemblyTest(),
      new HaxeProcessClientTest()
    ];
  }
  static public function main(){
    tink.RunLoop.current.onError = (e,t,w,s) -> {
      trace(e);
      haxe.MainLoop.runInMainThread(
        () -> throw(e)
      );
    }
    final log = __.log().global; 
          log.includes.push("stx/asys");
          //log.includes.push("stx/stream");
          //log.includes.push("stx/test");
          //log.includes.push("stx/pico");
          //log.includes.push("stx/logging");
          log.includes.push('stx/build');
          log.includes.push('stx/io');
          //log.includes.push('eu/ohmrun/fletcher');
          //log.includes.push('stx/proxy');
          //log.includes.push('stx/pico');
          //log.includes.push("**/*");
        log.level = DEBUG;
    __.test().auto();
  }
}