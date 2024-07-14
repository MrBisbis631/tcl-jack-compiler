# Function to handle expressions
proc expression_to_vm {node scope} {
    set skip_node 0
    set vm_code ""
    foreach current_node [$node childNodes] {
        if {$skip_node == 1} {
            set $skip_node 0
            continue
        }
        set current_node_name [$current_node nodeName]
        puts $current_node_name
        if {[$current_node nodeName] eq "term"} {
            append vm_code [handle_term $current_node]
        } elseif {[$current_node nodeName] eq "expression"} {

            append vm_code [handle_expression $current_node]
        } elseif {[$current_node text] in {+ - & | < > =}} {
            set next_node [$current_node nextSibling]
            set next_node_code [handle_term $next_node]
            set next_node_name [$next_node nodeName]
            puts "next node:"
            puts $next_node_name
            set symbol_expr ""
            switch [$current_node text] {
                "+" {set symbol_expr "add\n"}
                "-" {set symbol_expr "sub\n"}
                "&" {set symbol_expr "and\n"}
                "|" {set symbol_expr "or\n"}
                "<" {set symbol_expr "lt\n"}
                ">" {set symbol_expr "gt\n"}
                "=" {set symbol_expr "eq\n"}
            }
            append vm_code $next_node_code
            append vm_code $symbol_expr
            set skip_node 1
        }
    }
    return $vm_code
}

proc handle_term {term} {
    set vm_code ""
    set term_first_child [[$term firstChild] nodeName]
    puts $term_first_child
    set term_content [[$term firstChild] text]
    puts $term_content
    if {[string is integer $term_content]} {
        append vm_code "push constant $term_content\n"
    } elseif {$term_content in {true false}} {
        append vm_code "push constant [expr {$term_content eq "true" ? 0 : 1}]\n"
        if {$term_content eq "true"} {
            append vm_code "not\n"
        }
    } elseif {$term_content in {this that}} {
        append vm_code "push $term_content 0\n"
    } else {
        # Assume it's a variable or field
        #TODO :need to look for it in symbol table
        set variable_record [get_record_as_dict $scope_name [first_node_value $node "identifier"]]
        append vm_code "push this [expr {$term_content eq "x" ? 0 : $term_content eq "y" ? 1 : 2}]\n"
    }
    return $vm_code
}

# expression node to vm code
proc expression_to_vm {node scope} {
    set vm_code ""
    set children [::dom::selectNode $node *]

    switch [llength $children] {
        # term
        1 {
            append vm_code [term_to_vm [lindex $children 0] $scope]
        }
        # unaryOp term
        2 {
            append vm_code [term_to_vm [lindex $children 1] $scope]
            append vm_code [unary_op_to_vm [lindex $children 0]]
        }
        # term op term
        3 {
            append vm_code [term_to_vm [lindex $children 0] $scope]
            append vm_code [term_to_vm [lindex $children 2] $scope]
            append vm_code [op_to_vm [lindex $children 1]]
        }
    }

    return $vm_code
}


proc term_to_vm {node scope_name} {
    set vm_code ""
    # todo : handle term
    return $vm_code
}

proc subroutine_call_to_vm {node scope_name} {
    set vm_code ""
    # todo : handle subroutine call
    return $vm_code
}

# expressionList node to vm code
proc expression_list_to_vm {node scope_name} {
    set vm_code ""

    foreach expression_node [::dom::selectNode $node expression] {
        append vm_code [expression_to_vm $expression_node $scope_name]
    }

    return $vm_code
}

# operator node to vm code
proc op_to_vm {node} {
    switch [$node stringValue] {
        "+" {return "add\n"}
        "-" {return "sub\n"}
        "*" {return "call Math.multiply 2\n"}
        "/" {return "call Math.divide 2\n"}
        "&" {return "and\n"}
        "|" {return "or\n"}
        "<" {return "lt\n"}
        ">" {return "gt\n"}
        "=" {return "eq\n"}
    }
}

# unaryOp node to vm code
proc unary_op_to_vm {node} {
    switch [$node stringValue] {
        "-" {return "neg\n"}
        "~" {return "not\n"}
    }
}

# keywordConstant node to vm code
proc keyword_to_vm {node} {
    switch [$node stringValue] {
        "true" {return "push constant 0\nnot\n"}
        "false" {return "push constant 0\n"}
        "null" {return "push constant 0\n"}
        "this" {return "push pointer 0\n"}
    }
}
