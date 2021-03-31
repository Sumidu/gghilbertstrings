


# test if submittable to Windows DEVEL
{
  rhub::check(
    platform = "windows-x86_64-devel",
    env_vars = c(R_COMPILE_AND_INSTALL_PACKAGES = "always")
  )
  rhub::check(
    platform = "windows-x86_64-oldrel",
    env_vars = c(R_COMPILE_AND_INSTALL_PACKAGES = "always")
  )
  rhub::check(
    platform = "windows-x86_64-release",
    env_vars = c(R_COMPILE_AND_INSTALL_PACKAGES = "always")
  )

  # test if works on solaris
  rhub::check(platform = "solaris-x86-patched-ods")
  #rhub::check_on_solaris()
  rhub::check(platform = "solaris-x86-patched")

  beepr::beep(sound = 1)
}


if (FALSE) {
  devtools::submit_cran()
}
