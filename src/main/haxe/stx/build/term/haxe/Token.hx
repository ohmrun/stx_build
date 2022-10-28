package stx.build.term.haxe;

enum Token{
  HxLib(lib:Lib);
  HxCp(str:String);
  HxDefine(key:String,val:String);
  HxMacro(str:String);
  HxMain(main:String);
  HxTarget(tgt:String);
  HxOrder(builds:Cluster<Cluster<Token>>);
}