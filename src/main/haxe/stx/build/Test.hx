package stx.build;

using stx.Test;

import stx.build.test.*;

class Test{
  static public function tests(){
    return [
      new PmlLexTest()
    ];
  }
  static public function main(){
    __.test().auto();
  }
}