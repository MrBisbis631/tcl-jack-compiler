# Test VM to HACK transpiling - with all VM commends
# Experimenting with threads

source "[file normalize .]/utils/imports.tcl"

# Exit if selected directory is missing
if {[llength $argv] == 0} {
  puts "Usage: tclsh [file tail [info script]] <vm_file_name>"
  exit 1
}

set vm_files [get_files_name_by_extention "data/ex2/[lindex $argv 0]" "vm"]
set output_dir [set_up_target_dir "ex2/[lindex $argv 0]"]

# gets the .vm file path of the VM file and create the transpiled .asm file
# make sure `output_dir` exists
proc handle_vm_file_to_hack_transpiling {vm_file_path output_dir} {
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

# foreach file $vm_files {
#   handle_vm_file_to_hack_transpiling $file $output_dir
# }


# for {set index 0} {$index < 10} {incr index} {
#   # create a thread that puts the line in the console
#   thread create {
#     puts "index: $index"
#   }
# }