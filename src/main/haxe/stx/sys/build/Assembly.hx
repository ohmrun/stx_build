package stx.sys.build;

abstract class Assembly{
  static public function apply(name:String):Option<PExpr<Atom> -> Cluster<String> -> Execute<BuildFailure>>;
}