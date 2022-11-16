package stx.sys.build.test;

using stx.Show;
import eu.ohmrun.pml.Extract;
import eu.ohmrun.pml.Extract.*;
using stx.Parse;
using eu.ohmrun.Pml;

import stx.sys.build.term.haxe.Token;
import stx.sys.build.term.haxe.*;


class PmlLexTest extends TestCase{
  public function test(){
    final value   = __.pml().parseI()(__.resource("stx_key_val").string().reader());
    final result  = value.value.defv(PEmpty);
    final parse   = Lexer.haxe_property();
    final out     = parse.apply([result].reader());
    same(HTArg("-main",Some("Main")),out.value.defv(null));
  }
  public function test_flag(){
    final value   = __.pml().parseI()(__.resource("stx_flag").string().reader());
    final result  = value.value.defv(PEmpty);
    final parse   = Extract.imbibe(Lexer.haxe_flag(),"haxe_flag#1");
    final out     = parse.apply([result].reader());
    same(HTArg("--interp",None),out.value.defv(null));
  }
  public function test_flag_fail(){
    final value   = __.pml().parseI()(__.resource("stx_flag_fail").string().reader());
    final result  = value.value.defv(PEmpty);
    final parse   = Extract.imbibe(Lexer.haxe_flag(),"haxe_flag#1");
    final out     = parse.apply([result].reader());
    is_false(out.is_ok());
  }
  public function test_build_section(){
    final value   = __.pml().parseI()(__.resource("stx_build_section").string().reader());
    final result  = value.value.defv(PEmpty);
    final parse   = Lexer.section();
    try{
      final out     = parse.apply([result].reader());
      is_true(out.is_ok());
    }catch(e){
      trace(e);
    }
  }
  public function test_build(){
    final value   = __.pml().parseI()(__.resource("stx_build").string().reader());
    final result  = value.value.defv(PEmpty);
    final parse   = Lexer.build();
    try{
      final out     = parse.apply([result].reader());
      trace(__.show(out.value.defv(null)));
    }catch(e){
      trace(e);
    }
  }
  public function test_path(){
    final value   = __.pml().parseI()(__.resource("stx").string().reader());
    final result  = value.value.defv(PEmpty);
    final parse   = stx.sys.build.term.haxe.Lexer.main();
    try{
      final out     = parse.apply([result].reader());
      final a       = out.value.defv([].imm());
      trace(__.show(a));
      final b       = Interpreter.apply(a,["unit"]);
      for(o in b){
        for( x in o ){
          x.decouple(
            (key,val) -> trace('$key => $val')
          );
        }
      }
    }catch(e){
      trace(e);
    }
  }
  public function test_whole(){
    //Execution.upply(["unit"])
  }
}