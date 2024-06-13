# Test Jack parser

source "[file normalize .]/utils/imports.tcl"

# Exit if selected directory is missing
if {[llength $argv] == 0} {
  puts "Usage: tclsh [file tail [info script]] <vm_file_name>"
  exit 1
}

set token_xml_files [get_files_name_by_postfix "data/ex4/[lindex $argv 0]" "T.xml"]
set output_dir [set_up_target_dir "ex4.2/[lindex $argv 0]"]

# convert each <name>T.xml file to <name>.xml file
foreach token_xml_file $token_xml_files {
  # convert token file to xml tree
  set tokens_doc [xml_file_to_dom_doc $token_xml_file]

  # create a coroutine to generate tokens from the XML document
  coroutine tokens_generator xml_to_tokens_generator $tokens_doc
  # initialize the tokens generator - usesed in parers
  init_tokens_generator tokens_generator

  # parse file to doc
  set parsed_doc [parse]

  # write to output file
  write_dom_doc_to_file $parsed_doc "$output_dir/[filename_no_extention $token_xml_file].xml"
}
