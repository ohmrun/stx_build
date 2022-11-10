package stx.build.term.haxe;

class Execution{
  static public function upply(path:Cluster<String>){
    //Parse source file
    final arrow = Path.parse(__.bake().root.toString()).attempt(Raw._.toDirectory).map(
      (dir:Directory) -> dir.entry(Entry.make('stx','pml'))
    ).errate((e) -> (e:FsFailure))
     .arrange(
      __.arrange((arc:Archive) -> arc.val())
    ).errate(e -> (e:BuildFailure))
     .adjust(
      (str) -> {
        //Transform to Haxe tokens
        return __.pml().parseI()(str.reader())
                .toRes()
                .flat_map(
                  opt -> opt.fold(
                    ok -> __.accept(ok),
                    () -> __.reject(f -> f.of(E_Build_EmptyBuildFile))
                  )
                ).errate(e -> (e:BuildFailure))
                 .adjust(
                    r -> stx.build.term.haxe.Lexer.main().apply([r].reader()).toRes().errate(e -> (e:BuildFailure))
                 ).adjust(
                    opt -> opt.fold(
                      ok -> __.accept(ok),
                      () -> __.reject(f -> f.of(E_Build_EmptyBuildFile))
                    )
                 ).adjust(
                    x -> Interpreter.apply(x,path)
                 );
      }
    ).provide(__.asys().local())//Uses local Device
     .then(
      //Create ProcessServer
      Fletcher.Sync(
        (res:Res<Cluster<Couple<String,Option<String>>>,BuildFailure>) -> res.fold(
          ok -> ProcessServer.make(
            ['haxe'].imm().concat(
              ok.map(__.decouple((x:String,y:Option<String>) -> y.map(y -> '$x$y').defv(x))) 
            )
          ).errate(E_Build_Process),
          no -> __.ended(no)
        )
      )
     );
    final server  = 
      Server.lift(Server.lift(__.belay(arrow))
            //removes Noise as Result type
            .adjust(r -> __.reject(f -> f.of(E_Build_Fail))));
            
    final client  = 
      ProcessClientCat.Reply()
      //Integrate with library error type
      .then(x -> x.errate((e -> (e:BuildFailure))));

    final outlet  = server.connect(client);
    final agenda  = outlet.agenda(
      r -> {
        //show the result of the process.
        trace(r.toString());
      }
    );

    agenda.toExecute().environment(
      ()      -> {},
      report  -> report.raise()//throw error if exists
    ).submit();

    //__.belay
  }
}