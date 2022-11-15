package stx.sys.build;

using stx.Parse;

class Execution{
  static public function comply(assemblies:Cluster<Assembly>,path:Cluster<String>){
    __.log().debug('execution');
    return path.head().fold(
      ok -> {
        return assemblies.lfold(
          (next:Assembly,memo:Option<PExpr<Atom>->Cluster<String> -> Execute<BuildFailure>>) -> {
            return switch(memo){
              case None     : next(ok);
              case Some(v)  : Some(v);
            }
          },
          None
        ).resolve(f -> f.of(E_Build_NoRequest))
        .fold(
          (assembly_ctr) -> {
            trace('assembly_ctr');
            return Execute.fromFunXExecute(
              () -> {
                __.log().debug('assembly_ctr');
                return content()
                  .adjust(expression)
                  .adjust(
                    (expr:PExpr<Atom>) -> {
                      __.log().trace(_ -> _.thunk(() -> expr));
                      return switch(expr){
                        case PGroup(xs) : xs.lfold(
                          (next,memo) -> switch(memo){
                              case Some(v)  : Some(v);
                              default       : 
                                switch(next){
                                  case PGroup(Cons(PValue(AnSym(x)),_)) if (x == ok): 
                                    Some(assembly_ctr(expr,path));
                                  default : 
                                    None;//Execute.pure(__.fault().of(E_Build_Fail('$xs')));
                                }
                          },
                          None
                        ).resolve(f -> f.of(E_Build_NoSection(ok)));
                        default : 
                          __.reject(__.fault().of(E_Build_Fail('expr: $expr')));
                      };
                    }
                  ).provide(__.asys().local())
                  .point(e -> e);
              }
            );
          },
          e -> Execute.pure(e)
        );
      },
      () -> Execute.pure(__.fault().of(E_Build_NoRequest))
    );
  }
  
  static public function content(){
    __.log().trace('content');
    return Path.parse(__.bake().root.toString())
    .attempt(Raw._.toDirectory)
    .map((dir:Directory) -> dir.entry(Entry.make('stx','pml'))).errate((e) -> (e:FsFailure))
    .arrange(__.arrange((arc:Archive) -> arc.val())).errate(e -> (e:BuildFailure));
  }
  static public function expression(str:String){
    __.log().trace(str);
    return                 
    __.pml().parseI()(str.reader()).toRes()
      .flat_map(
        opt -> opt.fold(
          ok -> __.accept(ok),
          () -> __.reject(f -> f.of(E_Build_EmptyBuildFile))
        )
      ).errate(e -> (e:BuildFailure));
  }
}