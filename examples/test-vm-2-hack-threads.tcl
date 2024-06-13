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

# for each vm file, create a thread to handle the transpiling
foreach vm_file $vm_files {
  # Create a new thread
  set thread_id [thread::create]
  # Load the procedure into the thread and its dependencies
  thread::send $thread_id $transpile_vm_file_to_hack_script
  # Start a procedure in the thread - with list [func_name $arg1 $arg2 ...]
  thread::send $thread_id [list transpile_vm_file_to_hack $vm_file $output_dir]
}

# # Optionally, wait for the thread to finish if needed
# # thread::wait $threadID

# # Clean up the thread after use
# thread::release $threadID
