package stx.sys.build.term.haxe;

class Lib{
  final name    : String;
  final version : String;
  public function new(name,version){
    this.name     = name;
    this.version  = version;
  }
  static public function make(name,version=""){
    return new Lib(name,version);
  }
  public function toString(){
    return '($name $version)';
  }
}