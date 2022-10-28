(
  ("-lib"      "stx_pico")
  ("-lib"      "stx_nano")
  ("-cp"       "src/main/haxe")
  ("-D"        ("key=val","key")
  (macro      "stx.build.Plugin.use()")
  (order
    (
      (main BOOT)
      (target js)
    )
    (
      (main Mump)
      (macro "stx.build.Plugin.use()")
    )
  )
)