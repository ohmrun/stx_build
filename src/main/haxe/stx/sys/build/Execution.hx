package stx.sys.build;

using stx.Parse;

class Execution{
  // static public function comply(assemblies:Cluster<Assembly>,path:Cluster<String>){
  //   __.log().debug('execution');
  //   return path.head().fold(
  //     ok -> {
  //       return assemblies.lfold(
  //         (next:Assembly,memo:Option<PExpr<Atom>->Cluster<String> -> Execute<BuildFailure>>) -> {
  //           return switch(memo){
  //             case None     : next(ok);
  //             case Some(v)  : Some(v);
  //           }
  //         },
  //         None
  //       ).resolve(f -> f.of(E_Build_NoRequest))
  //       .fold(
  //         (assembly_ctr) -> {
  //           trace('assembly_ctr');
  //           return Execute.fromFunXExecute(
  //             () -> {
  //               __.log().debug('assembly_ctr');
  //               return content()
  //                 .adjust(expression)
  //                 .adjust(
  //                   (expr:PExpr<Atom>) -> {
  //                     __.log().trace(_ -> _.thunk(() -> expr));
  //                     return switch(expr){
  //                       case PGroup(xs) : xs.lfold(
  //                         (next,memo) -> switch(memo){
  //                             case Some(v)  : Some(v);
  //                             default       : 
  //                               switch(next){
  //                                 case PGroup(Cons(PValue(AnSym(x)),_)) if (x == ok): 
  //                                   Some(assembly_ctr(expr,path));
  //                                 default : 
  //                                   None;//Execute.pure(__.fault().of(E_Build_Fail('$xs')));
  //                               }
  //                         },
  //                         None
  //                       ).resolve(f -> f.of(E_Build_NoSection(ok)));
  //                       default : 
  //                         __.reject(__.fault().of(E_Build_Fail('expr: $expr')));
  //                     };
  //                   }
  //                 ).provide(__.asys().local())
  //                 .point(e -> e);
  //             }
  //           );
  //         },
  //         e -> Execute.pure(e)
  //       );
  //     },
  //     () -> Execute.pure(__.fault().of(E_Build_NoRequest))
  //   );
// }
  function get_something(cli_ctx:CliContext){
    final args = cli_ctx.args;
    final path = args.search(
      x -> switch(x){
        case Arg(_) : true;
        default     : false;
      }
    ).resolve(f -> f.of(E_Build_Fail('no arguments'))).flat_map(
      x -> switch(x){
        case Arg(x) : __.accept(x.split("/"));
        default     : __.reject(f -> f.of(E_Build_Fail('wrong option type')));
      }
    );
  } 
}