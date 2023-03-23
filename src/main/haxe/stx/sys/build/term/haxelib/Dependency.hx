package stx.sys.build.term.haxelib;

using StringTools;

class Dependency{
  static public function source(str:String):Option<DependencySource>{
    return if(str.startsWith('git')){
      Some(DepGit);
    }else if(str.startsWith('hg')){
      Some(DepMercurial);
    }else{
      Some(DepHaxelib);
    }
  }
}