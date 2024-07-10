# Test Jack to vm - creates <file>T.vm from <file>.jack
# using a thread pool

source "[file normalize .]/utils/imports.tcl"

set workers 3

# Exit if selected directory is missing
if {[llength $argv] == 0} {
  puts "Usage: tclsh [file tail [info script]] <project_dir>"
  exit 1
}

# set the output directory
set output_dir [set_up_target_dir "ex5/[lindex $argv 0]"]

# init a thread pool with scripts `jack_2_vm_file_script`, `tokenize_file_to_xml_script`, `parse_token_xml_file_script` 
set pool [create_thread_pool $workers \
    "$parse_token_xml_file_script\n$tokenize_file_to_xml_script\n$jack_2_vm_file_script\n"
  ]
# init a corutine that returns the workers in round-robin
coroutine round_robin_coroutine thread_round_robin_generator $pool

# -------------- Tokenize Jack files --------------

set jack_files [get_files_name_by_postfix "data/ex5/[lindex $argv 0]" ".jack"]

# send each file to a worker
foreach jack_file $jack_files {
  thread::send -async [round_robin_coroutine] [list tokenize_file_to_xml $jack_file $output_dir]
}

# wait for all workers to finish

wait_for_pool_to_finish $pool

# -------------- Parse token XML files --------------

set token_files [get_files_name_by_postfix "target/ex5/[lindex $argv 0]" "T.xml"]

# send each file to a worker
foreach token_file $token_files {
  thread::send -async [round_robin_coroutine] [list parse_token_xml_file $token_file $output_dir]
}

# wait for all workers to finish
wait_for_pool_to_finish $pool

# remove token files
foreach token_file $token_files {
  puts "Removing token file: $token_file"
  file delete -force $token_file
}

# wait for all workers to finish
wait_for_pool_to_finish $pool

# -------------- XML tree to VM code --------------

set tree_files [get_files_name_by_extention "target/ex5/[lindex $argv 0]" ".xml"]
foreach file $tree_files {
  puts "Parsing tree file: $file"
  
}
# send each file to a worker
foreach tree_file $tree_files {
  thread::send -async [round_robin_coroutine] [list jack_2_vm_file $tree_file $output_dir]
}

# -------------- Injecting jack-stdlib --------------

# # inject jack-stdlib to output directory
# inject_jack_stdlib $output_dir

# -------------- cleanup ----------------------------

# 
# wait_for_pool_to_finish $pool

# # remove files that are not .vm
# foreach file [glob -nocomplain -directory $output_dir -type f -tails *] {
#   if {[file extension $file] ne ".vm"} {
#     file delete -force [file join $output_dir $file]
#   }
# }

# wait for all workers to finish
wait_for_pool_to_finish $pool
