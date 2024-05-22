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


# Define the procedure as a string for the thread
set script {
  # Load the dependencies for the thread
  source "[file normalize .]/utils/imports.tcl"

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
}

# for each vm file, create a thread to handle the transpiling
foreach vm_file $vm_files {
  # Create a new thread
  set thread_id [thread::create]
  # Load the procedure into the thread and its dependencies
  thread::send $thread_id $script
  # Start a procedure in the thread
  thread::send $thread_id [list handle_vm_file_to_hack_transpiling $vm_file $output_dir]
}

# # Optionally, wait for the thread to finish if needed
# # thread::wait $threadID

# # Clean up the thread after use
# thread::release $threadID