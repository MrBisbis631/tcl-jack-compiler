# parser for Jack language

source "[file normalize .]/parser/statements.tcl"
source "[file normalize .]/parser/program-structure.tcl"
source "[file normalize .]/parser/expressions.tcl"

# parse a .jack file, entry point is `class`, which is the root of the parse tree
# returns a parse tree in the form of a DOM tree
proc parse {} {
  set parsed_doc [::dom::DOMImplementation create]
  set parsed_tree [class_parser $parsed_doc]
  return $parsed_tree
}
