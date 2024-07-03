# Transpile parsed XML doc to vm code

source "[file normalize .]/jack-2-vm/program-structure.tcl"
source "[file normalize .]/jack-2-vm/statements.tcl"
source "[file normalize .]/jack-2-vm/expressions.tcl"

# Transpile a single jack file to vm code
proc jack_to_vm {doc} {
  set class_node [::dom::selectNode $doc /class]
  return [class_node_to_vm $class_node]
}

# Transpile a jack file to vm code in a generator style using a XML parser
proc jack_to_vm_generator {xml_parser} {
  # TODO implement
}
