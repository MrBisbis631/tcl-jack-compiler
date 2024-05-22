# scripts for threads

# keep the following convention:
# name:  `<handler_name>_script`
# The only function in the  script is the handler, named <handler_name>, where `<handler_name>_script` is the script name
# don't forget to add add the import `source "[file normalize .]/utils/imports.tcl"` to each script 


# script for the thread that transpiles a VM file to a Hack assembly file
set transpile_vm_file_to_hack_script {
  # Load the dependencies for the thread
  source "[file normalize .]/utils/imports.tcl"

  # gets the .vm file path of the VM file and create the transpiled .asm file
  # make sure `output_dir` exists
  proc transpile_vm_file_to_hack {vm_file_path output_dir} {
    set o_fd [open "$output_dir/[filename_no_extention $vm_file_path].asm" "w"]
    puts $o_fd "// TRANSPILED FILE: $vm_file_path\n"
    try {
      for {set line [coroutine line_generator generate_lines $vm_file_path]} {$line != "\0"} {set line [line_generator]} {
        # skip empty lines and comments
        if {[string is space $line] || [string match "//*" $line]} {
          continue
        }

        puts $o_fd "// CMD: $line"
        puts $o_fd [vm_to_hack $line]
      }
    } finally {
      close $o_fd
    }
  }
}
