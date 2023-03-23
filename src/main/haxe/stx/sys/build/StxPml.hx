package stx.sys.build;

using stx.Parse;

class StxPml{
  static public function reply(){
    return (content().adjust(expression));
  }
  static public function content():Attempt<HasDevice,String,BuildFailure>{
    __.log().trace('content');
    return (Path.parse(__.bake().root.toString())
    .attempt(Raw._.toDirectory)
    .map((dir:Directory) -> dir.entry(Entry.make('stx','pml'))).errate((e) -> (e:FsFailure))
    .arrange(__.arrange((arc:Archive) -> arc.val())).errate(e -> (e:BuildFailure)));
  }
  static public function expression(str:String){
    __.log().trace(str);
    return                 
    __.pml().parseI()(str.reader()).toRes()
      .errate(e -> (e:BuildFailure))
      .flat_map(
        opt -> opt.fold(
          ok -> __.accept(ok).errate(e -> (e:BuildFailure)),
          () -> __.reject(f -> f.of(E_Build_EmptyBuildFile))
        )
      );
  }
}