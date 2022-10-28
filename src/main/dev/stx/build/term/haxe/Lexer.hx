package eu.ohmrun.pml.test;

import eu.ohmrun.pml.Extract.*;

/**
  Lexer from pml expressions to haxe compiler tokens
**/
class Lexer extends TestCase{
  public function e(){
    return Extract;
  }
  public function hx_compile(){
    return imbibe(
      Extract.symbol('hx.Compiler')._and(
        context().or(order()).one_many()
      ),
      "hx_compile"
    );
  }
  public function lib1(){
    return symbol('lib')._and(wordish()).then(x -> Lib.make(x)).then(HxLib);
  }
  public function lib2(){
    return symbol('lib')._and(wordish()).and(wordish())
    .then(x -> Lib.make(x.fst(),x.snd())).then(HxLib);
  }
  public function lib(){
    return lib2().or(lib1());
  }

  public function cp(){
    return symbol('cp')._and(wordish()).then(HxCp);
  }
  public function define2(){
    return symbol('define')._and(wordish()).and(wordish()).then(__.decouple((x,y) -> HxDefine(x,y)));
  }
  public function define1(){
    return symbol('define')._and(wordish()).then(x -> HxDefine(x,""));
  }
  public function define(){
    return define2().or(define1());
  }
  public function makro(){
    return symbol('macro')._and(wordish()).then(HxMacro);
  }
  public function context(){
    return imbibe(define(),'define').or(
      imbibe(makro(),'makro')
    ).or(
      imbibe(cp(),'cp')
    ).or(
      imbibe(lib(),'lib')
    );
  }
  public function main(){
    return symbol('main')._and(wordish()).then(HxMain);
  }
  public function target(){
    return symbol('target')._and(wordish()).then(HxTarget);
  }
  public function order_item(){
    return imbibe(
      main().or(target()),'main_or_target'
    ).or(context());
  }
  public function order(){
    return imbibe(
        symbol('order')._and(
          imbibe(
            order_item().one_many(),
            "order item"
          ).one_many()
      ),'order').then(
        x -> HxOrder(x)
      );
  }
}