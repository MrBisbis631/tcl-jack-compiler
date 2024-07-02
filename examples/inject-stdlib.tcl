# injects the stdlib package into the selected directory

source "[file normalize .]/utils/imports.tcl"

set target_dir [set_up_target_dir "inject-stdlib"]

# inject the stdlib package
inject_jack_stdlib $target_dir
