(indeces "stx.build.Test")
( "main" 
  include (
    (
      "stx.build.test.PmlLexTest" 
         include "test_path" 
    )
  )
)