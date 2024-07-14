# Program Structure XML to VM code

# Convert a class node to VM code
proc class_node_to_vm {class_node} {
  set class_vm_code ""

  # init class scope
  clear_symble_table
  set class_name [first_node_value $class_node identifier]
  set_scops_class $class_name
  set class_scope [create_scope $class_name "class"]

  # classVarDec*
  foreach class_var_dec_node [::dom::selectNode $class_node classVarDec] {
    class_var_dec_to_vm $class_var_dec_node
  }

  # subroutineDec*
  foreach subroutine_dec_node [::dom::selectNode $class_node subroutineDec] {
    append class_vm_code [subroutine_dec_to_vm $subroutine_dec_node]
  }

  dump_symble_table

  return $class_vm_code
}

# populate the symble table with the class variables
proc class_var_dec_to_vm {node} {
  coroutine class_var_dec_gen xml_nodes_generator [::dom::selectNode $node *]

  set class_name [get_scops_class]
  # static | field
  set kind [[class_var_dec_gen] stringValue]
  # type
  set type [[class_var_dec_gen] stringValue]
  # varName
  set name [[class_var_dec_gen] stringValue]
  create_record $class_name $name $type $kind

  # (, varName)*
  while {[set node [class_var_dec_gen]] != "\0"} {
    set tok_value [$node stringValue]
    set tok_type [$node cget -nodeName]
    if {$tok_type == "identifier"} {
      create_record $class_name $tok_value $type $kind
    }
  }
}

# Convert a subroutineDec node to VM code
proc subroutine_dec_to_vm {node} {
  coroutine subroutine_dec_gen xml_nodes_generator [::dom::selectNode $node *]

  # constructor | function | method
  set subroutine_type [[subroutine_dec_gen] stringValue]
  # void | type
  set returns [[subroutine_dec_gen] stringValue]
  # subroutineName
  set subroutine_name [[subroutine_dec_gen] stringValue]

  # create subroutine scope
  set subroutine_scope [create_scope $subroutine_name $subroutine_type $returns]

  # method has an argument this
  if {$subroutine_type == "method"} {
    create_record $subroutine_name "this" [get_scops_class] "argument"
  }

  # parameterList
  set parameter_list_node [::dom::selectNode $node parameterList/*]
  # update symble table with the parameters
  for {set param_node [coroutine nodes_gen xml_nodes_generator $parameter_list_node]} \
  {$param_node != "\0"} \
  {set param_node [nodes_gen]} {
    if {$param_node == "" || [$param_node cget -nodeName] == "symbol"} {
      continue
    }
    set type [$param_node stringValue]
    set value [[nodes_gen] stringValue]
    create_record $subroutine_name $value $type "argument"
  }

  # subroutineBody
  # varDec*
  foreach var_dec_node [::dom::selectNode $node subroutineBody/varDec] {
    var_dec_to_vm $var_dec_node $subroutine_name
  }

  set args_count [llength [::dom::selectNode $subroutine_scope *]]
  set function_name "[get_scops_class].$subroutine_name $args_count"
  set statments_vm_code [statements_to_vm [::dom::selectNode $node subroutineBody/statements] $subroutine_name]

  return "function $function_name $args_count\n$statments_vm_code\n"
}

# Populate the symble table with the parameters
proc var_dec_to_vm {node subroutine_name} {
  coroutine var_dec_gen xml_nodes_generator [::dom::selectNode $node *]
  var_dec_gen
  # var
  set kind "var"
  # type
  set type [[var_dec_gen] stringValue]
  # varName
  set name [[var_dec_gen] stringValue]
  create_record $subroutine_name $name $type $kind

  # (, varName)*
  while {[set node [var_dec_gen]] != "\0"} {
    if {$node == "" || [$node cget -nodeName] == "symbol"} {
      continue
    }
    set tok_value [$node stringValue]
    set tok_type [$node cget -nodeName]
    create_record $subroutine_name $tok_value $type $kind
  }
}
