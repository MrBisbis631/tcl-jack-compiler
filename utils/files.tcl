# Utility functions for files IO

# Get the target directory - relative to the root directory
# If the directory does not exist, create it
proc get_target_dir {file_path} {
  set dir target/[string range [file tail $file_path] 0 [expr {[string last "." [file tail $file_path]] - 1}]]
  if {![file isdirectory $dir]} {
    file mkdir $dir
  }
  return "[file normalize .]/target/$file_path"
}

# Set up the target directory
proc set_up_target_dir {target_path} {
  set target_dir "[file normalize .]/target/$target_path"
  file delete -force $target_dir
  file mkdir $target_dir
  return $target_dir
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

#  Get the filename without the extention
proc filename_no_extention {file_path} {
  return [string range [file tail $file_path] 0 [expr {[string last "." [file tail $file_path]] - 1}]]
}

# Get the file xml content and return the XML doc object
proc xml_file_to_dom_doc {xml_file_path} {
  set xml_fd [open $xml_file_path r]
  set xml_content [read $xml_fd]
  close $xml_fd
  set doc [::dom::DOMImplementation parse $xml_content]
  return $doc
}

# get files name by the postfix 
proc get_files_name_by_postfix {dir_path postfix} {
  return [glob -nocomplain -directory $dir_path *$postfix]
}

# write the `doc` the spesified `file_path`
proc write_dom_doc_to_file {doc file_path} {
  set fd [open $file_path w]
  puts $fd [::dom::DOMImplementation serialize $doc -indent 1]
  close $fd
}

# Get the file <filename>T.xml => <filename>.xml
proc token_file_name_to_parsed_file_name {filepath} {
  set filename [filename_no_extention $filepath]
  return "[string range $filename 0 [expr [string last "T" $filename] - 1]].xml"
}

# inject jack-stdlib to directory
proc inject_jack_stdlib {dir_path} {
  set jack_stdlib_path "[file normalize .]/data/jack-stdlib"
  set jack_stdlib_files [glob -nocomplain -directory $jack_stdlib_path *]
  foreach lib_file $jack_stdlib_files {
    file copy -force $lib_file $dir_path
  }
}
