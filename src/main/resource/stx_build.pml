(
  build 
  ( test
    ("-lib" ("stx_pico" "stx_nano" "stx_test"))
    ("-main" "Main")
    ( interp
      ("--resource" "tests.pml@tests")
      "--interp"
      ("-D" "no-deprecation-warnings")
    )
  )
)