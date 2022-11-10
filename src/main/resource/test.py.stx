(build 
    (test
      ("-lib" ("stx_pico" "stx_nano" "stx_test"))
      ("-main" "Main")
      (interp
        ("--resource" "tests.pml@tests")
        "--interp"
        ("-D" ("no-deprecation-warnings" "debug"))
      )
    )
    (unit
      ("--macro" "include('stx.build',true)")
    )
)