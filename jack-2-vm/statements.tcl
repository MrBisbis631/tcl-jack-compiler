# Parsed Jack statments to VM code

# Convert a Statements node to VM code
proc statements_to_vm {node scope_name} {
  set vm_code ""
  foreach statement_node [::dom::selectNode $node *] {
    set statement_type [$statement_node cget -nodeName]
    switch $statement_type {
      "letStatement" {
        append vm_code [let_statement_to_vm $statement_node $scope_name]
      }
      "ifStatement" {
        append vm_code [if_statement_to_vm $statement_node $scope_name]
      }
      "whileStatement" {
        append vm_code [while_statement_to_vm $statement_node $scope_name]
      }
      "doStatement" {
        append vm_code [do_statement_to_vm $statement_node $scope_name]
      }
      "returnStatement" {
        append vm_code [return_statement_to_vm $statement_node $scope_name]
      }
    }
  }
  return $vm_code
}

# Convert a LetStatement node to VM code
proc let_statement_to_vm {node scope_name} {
  set vm_code ""
  set variable_record [get_record_as_dict $scope_name [first_node_value $node "identifier"]]

  # handle array index
  if {$variable_record(kind) eq "Array"} {
    set expressions [::dom::selectNode $node expression]

    set vm_index_expression [expression_to_vm [lindex $expressions 0] $scope_name]
    set vm_assignment_expression [expression_to_vm [lindex $expressions 1] $scope_name]

    append vm_code "push ${variable_record(type)} ${variable_record(index)}\n"
    append vm_code $vm_index_expression
    append vm_code "add\n"
    append vm_code $vm_assignment_expression
    append vm_code "pop temp 0\n"
    append vm_code "pop pointer 1\n"
    append vm_code "push temp 0\n"
    append vm_code "pop that 0\n"
  } else {
    append vm_code [expression_to_vm [::dom::selectNode $node expression] $scope_name]
    append vm_code "pop ${variable_record(type)} ${variable_record(index)}\n"
  }

  return $vm_code
}

# Convert an IfStatement node to VM code
proc if_statement_to_vm {node scope_name} {
  set vm_code ""
  set else_label [uniq_label "ELSE"]
  set end_label [uniq_label "END"]
  set expression [::dom::selectNode $node expression]
  set statements [::dom::selectNode $node statements]
  set has_else [expr {[llength $statements] == 2}]

  # evaluate the if expression
  append vm_code [expression_to_vm [::dom::selectNode $node expression] $scope_name]
  append vm_code "not\n"

  if {$has_else} {
    append vm_code "if-goto $else_label\n"
    append vm_code [statements_to_vm [lindex $statements 0] $scope_name]
    append vm_code "goto $end_label\n"
    append vm_code "label $else_label\n"
    append vm_code [statements_to_vm [lindex $statements 1] $scope_name]
  } else {
    append vm_code "if-goto $end_label\n"
    append vm_code [statements_to_vm $statements $scope_name]
  }

  append vm_code "label $end_label\n"

  return $vm_code
}

# Convert a WhileStatement node to VM code
proc while_statement_to_vm {node scope_name} {
  set vm_code ""
  set start_label [uniq_label "START"]
  set end_label [uniq_label "END"]
  set expression [::dom::selectNode $node expression]
  set statements [::dom::selectNode $node statements]

  append vm_code "label $start_label\n"
  append vm_code [expression_to_vm $expression $scope_name]
  append vm_code "not\n"
  append vm_code "if-goto $end_label\n"
  append vm_code [statements_to_vm $statements $scope_name]
  append vm_code "goto $start_label\n"
  append vm_code "label $end_label\n"

  return $vm_code
}

# Convert a DoStatement node to VM code
proc do_statement_to_vm {node scope_name} {
  set vm_code ""

  # remove `do` and `;` tokens from the node => only the subroutine call remains
  foreach child [::dom::selectNode $node *] {
    set child_val [$child stringValue]
    if {$child_val eq "do" || $child_val eq ";"} {
      $node removeChild $child
    }
  }

  append vm_code [subroutine_call_to_vm $node $scope_name]
  append vm_code "pop temp 0\n"

  return $vm_code
}

# Convert a ReturnStatement node to VM code
proc return_statement_to_vm {node scope_name} {
  set vm_code ""
  set expression [::dom::selectNode $node expression]

  if {[llength $expression] > 0} {
    append vm_code [expression_to_vm [lindex $expression 0] $scope_name]
  } else {
    # vouid return
    append vm_code "push constant 0\n"
  }

  append vm_code "return\n"

  return $vm_code
}
