# Experiment with reading Tokens from a file

source "[file normalize .]/utils/imports.tcl"

# input file
set file_path "[file normalize .]/data/ex4/ArrayTest/MainT.xml"

# read the file and convert it to a DOM document
set doc [xml_file_to_dom_doc $file_path]

# create a coroutine to generate tokens from the XML document
coroutine tokens_generator xml_to_tokens_generator $doc

# initialize the tokens generator
init_tokens_generator tokens_generator

# get the next token from the generator and print it
while {[set token [get_next_token]] != "\0"} {
  puts "[dict get $token type] : [dict get $token value]"
}
