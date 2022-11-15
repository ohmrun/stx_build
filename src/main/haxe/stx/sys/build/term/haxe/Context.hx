package stx.sys.build.term.haxe;

typedef Context = {
  final args : Cluster<Couple<String,Option<String>>>;
  final rest : Ensemble<Context>;
}