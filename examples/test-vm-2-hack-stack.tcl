# Testing translation of VM code to Hack assembly code - Stack operations

source "[file normalize .]/utils/imports.tcl"

set vm_files [get_files_name_by_extention "data/ex1" "vm"]
set output_dir [set_up_target_dir "ex1"]

foreach file $vm_files {
  set o_fd [open "$output_dir/[filename_no_extention $file].asm" "w"]
  try {
    puts $o_fd "// TRANSPILED FILE: $file"
    for {set line [coroutine line_generator generate_lines $file]} {$line != "\0"} {set line [line_generator]} {
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
