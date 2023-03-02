package stx;

// typedef Assembly  = stx.sys.build.Assembly;
// typedef Execution = stx.sys.build.Execution;

class Build{
  static public function build(wildcard:Wildcard){
    return new stx.sys.build.Module();
  }
}
