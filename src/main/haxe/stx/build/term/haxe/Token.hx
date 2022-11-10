package stx.build.term.haxe;

enum Token{
  HTArg(key:String,val:Option<String>);
  HTSec(name:String,tks:Cluster<Token>);
}