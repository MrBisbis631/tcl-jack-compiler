# Test kokenizer - creates <file>T.xml with tokens from <file>.jack
# using a thread pool

source "[file normalize .]/utils/imports.tcl"

set workers 2

# Exit if selected directory is missing
if {[llength $argv] == 0} {
  puts "Usage: tclsh [file tail [info script]] <project_dir>"
  exit 1
}

set token_files [get_files_name_by_postfix "data/ex4/[lindex $argv 0]" "T.xml"]
set output_dir [set_up_target_dir "ex4.2/[lindex $argv 0]"]

# init a thread pool thith thread ids and send the `parse_token_xml_file_script` to each worker
set pool [create_thread_pool $workers $parse_token_xml_file_script]
# init a corutine that returns the workers in round-robin
coroutine round_robin_coroutine thread_round_robin_generator $pool

# send each file to a worker
foreach token_file $token_files {
  thread::send -async [round_robin_coroutine] [list parse_token_xml_file $token_file $output_dir]
}

# wait for all workers to finish
wait_for_pool_to_finish $pool
