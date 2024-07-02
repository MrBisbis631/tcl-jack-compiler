# Program Structure XML to VM code

# Convert a class node to VM code
proc class_node_to_vm {class_node} {
  set class_vm_code ""
  
  set class_name [first_node_value $class_node identifier]

  # classVarDec*
  set class_var_dec_nodes [::dom::selectNode $class_node classVarDec]

  foreach var_dec_node $class_var_dec_nodes {
    set vm_code [class_var_dec_node_to_vm $var_dec_node $class_name]
    append class_vm_code $vm_code
  }

  # subroutineDec*
  set subroutine_dec_nodes [::dom::selectNode $class_node subroutineDec]

  foreach subroutine_dec_node $subroutine_dec_nodes {
    set vm_code [subroutine_dec_node_to_vm $subroutine_dec_node $class_name]
    append class_vm_code $vm_code
  }

  return $class_vm_code
}

proc class_var_dec_node_to_vm {node class_name} {
  set vm_code ""

  set var_kind [first_node_value $node keyword]
  set var_type [first_node_value $node type]
  set var_name [first_node_value $node identifier]

  set vm_code "push constant 0\n"
  if {$var_kind == "field"} {
    append vm_code "this push constant 0\n"
    append vm_code "this pop pointer 0\n"
  } else {
    append vm_code "pop static $class_name.$var_name\n"
  }

  return $vm_code
}


proc subroutine_dec_node_to_vm {node class_name} {
  set vm_code ""

  set subroutine_kind [first_node_value $node keyword]
  set subroutine_type [first_node_value $node type]
  set subroutine_name [first_node_value $node identifier]

  set vm_code "function $class_name.$subroutine_name 0\n"

  return $vm_code
}
