# Test kokenizer - creates <file>T.xml with tokens from <file>.jack
# using a thread pool

source "[file normalize .]/utils/imports.tcl"

set workers 2

# Exit if selected directory is missing
if {[llength $argv] == 0} {
  puts "Usage: tclsh [file tail [info script]] <vm_file_name>"
  exit 1
}

set jack_files [get_files_name_by_extention "data/ex4/[lindex $argv 0]" "jack"]
set output_dir [set_up_target_dir "ex4.1/[lindex $argv 0]"]

# init a thread pool thith thread ids and send the `tokenize_file_to_xml_script` to each worker
set pool [create_thread_pool $workers $tokenize_file_to_xml_script]
# init a corutine that returns the workers in round-robin
coroutine round_robin_coroutine thread_round_robin_generator $pool

# send each file to a worker
foreach jack_file $jack_files {
  thread::send -async [round_robin_coroutine] [list tokenize_file_to_xml $jack_file $output_dir]
}

# wait for all workers to finish
wait_for_pool_to_finish $pool
