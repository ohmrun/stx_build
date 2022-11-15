package stx.sys.build.term.run;

class Assembly extends stx.sys.build.Assembly{
  static public function apply(name:String){
    return switch(name == 'run'){
      case true  : Some(
        function(expr:PExpr<Atom>,path:Cluster<String>):Execute<BuildFailure>>{
          
        }
      );
      case false : None;
    }
  }
}