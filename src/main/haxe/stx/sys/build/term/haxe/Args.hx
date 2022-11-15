package stx.sys.build.term.haxe;

@:using(stx.sys.build.term.haxe.Args.ArgsLift)
typedef Args   = Cluster<Couple<String,Option<String>>>;

class ArgsLift{
  static public function toArgs(self:Args):Cluster<String>{
    return self.map(
      __.decouple(
        (l:String,r:Option<String>) -> r.fold(
          ok -> [l,ok],
          () -> [l]
        )
      )
    ).flat_map(x -> x);
  }
}