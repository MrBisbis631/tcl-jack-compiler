# scripts for threads

# keep the following convention:
# name:  `<handler_name>_script`
# The only function in the  script is the handler, named <handler_name>, where `<handler_name>_script` is the script name
# don't forget to add add the import `source "[file normalize .]/utils/imports.tcl"` to each script


# script for the thread that transpiles a VM file to a Hack assembly file
set transpile_vm_file_to_hack_script {
  # Load the dependencies for the thread
  source "[file normalize .]/utils/imports.tcl"

  # gets the .vm file path of the VM file and create the transpiled .asm file
  # make sure `output_dir` exists
  proc transpile_vm_file_to_hack {vm_file_path output_dir} {
    set o_fd [open "$output_dir/[filename_no_extention $vm_file_path].asm" "w"]
    puts $o_fd "// TRANSPILED FILE: $vm_file_path\n"

    # add the bootstrap code if the file is a Main.vm file and inject Sys.vm
    if {[string match "*Main.vm" $vm_file_path]} {
      puts $o_fd [hack_bootstrap]

      # inject Sys.vm
      puts $o_fd "// INJECTING Sys.vm\n"
      set sys_vm_path [file join [file dirname $vm_file_path] "Sys.vm"]
      for {set line [coroutine line_generator generate_lines $sys_vm_path]} {$line != "\0"} {set line [line_generator]} {
        # skip empty lines and comments
        if {[string is space $line] || [string match "//*" $line]} {
          continue
        }

        puts $o_fd "// CMD: $line"
        puts $o_fd [vm_to_hack $line]
      }
    }

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

# script for the thread that tokenizes a jack file
set tokenize_file_to_xml_script {
  source "[file normalize .]/utils/imports.tcl"

  proc tokenize_file_to_xml {jack_file_path output_dir} {
    set o_fd [open "$output_dir/[filename_no_extention $jack_file_path]T.xml" "w"]
    puts "TOKENIZING FILE: $jack_file_path\n"
    try {
      # xml file
      set doc [::dom::DOMImplementation create]
      set root [::dom::document createElement $doc "tokens"]

      # tokenize each line of the file
      for {set line [coroutine line_generator jack_code_generator $jack_file_path]} {$line != "\0"} {set line [line_generator]} {
        # append every token to the xml file
        foreach token [tokenize $line] {
          token_to_xml_node $token $root
        }

      }
      # finaly append the root to the document
      puts $o_fd [::dom::DOMImplementation serialize $doc -indent 1]
    } finally {
      close $o_fd
    }
  }
}

# parse token xml file to xml tree
set parse_token_xml_file_script {
  source "[file normalize .]/utils/imports.tcl"

  proc parse_token_xml_file {token_xml_file_path output_dir} {
    puts "PARSING TOKEN XML FILE: $token_xml_file_path\n"

    # gets the tokens from the xml file
    set tokens_doc [xml_file_to_dom_doc $token_xml_file_path]

    # create a coroutine to generate tokens from the XML document
    coroutine tokens_generator xml_to_tokens_generator $tokens_doc
    # initialize the tokens generator - usesed in parers
    init_tokens_generator tokens_generator

    set doc [::dom::DOMImplementation create]
    # parse file to doc
    parse $doc

    # write to output file
    write_dom_doc_to_file $doc "$output_dir/[token_file_name_to_parsed_file_name $token_xml_file_path]"
  }
}
