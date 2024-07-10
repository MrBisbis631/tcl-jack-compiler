# experiment with converting parsed code to VM code

source "[file normalize .]/utils/imports.tcl"

set file_path "[file normalize .]/target/ex4.2/Square/Square.xml"

set doc [xml_file_to_dom_doc $file_path]

set vm_code [jack_to_vm $doc]

puts $vm_code
