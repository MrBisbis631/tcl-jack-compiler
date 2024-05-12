# Utility functions for files IO

# Get the target directory - relative to the root directory
proc get_target_dir {dir} {
  return "[file normalize .]/target/$dir"
}

# Get the files nanme in a directory acording to specific extension
# set dir_relative_to_root empty string to get the files in the root directory
proc get_files_name_by_extention {dir_relative_to_root extension} {
  return [glob "[file normalize .]/$dir_relative_to_root/*$extension"]
}

# Generate lines from a file for coroutines
proc generate_lines {file_path} {
  set fd [open $file_path r]
  while {[gets $fd line] >= 0} {
    yield $line
  }
  close $fd
  yield "\0"
}
