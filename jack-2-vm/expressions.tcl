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
    foreach child_node [::dom::selectNode $node *] {
        set child_node_type [$child_node cget -nodeName]

        switch $child_node_type {

                "integerConstant" {

                    set val [$child_node stringValue]
                    append vm_code "push constant $val\n"

                }
                #TODO 
                  "symbol" {

                }

                "stringConstant" {
                    foreach ch in [$child_node stringValue] {
                        set ascii_val [char_to_ascii $ch]
                        append vm_code "push constant $ascii_val\n"
                    }
                }

            #TODO IMPLIMANTION
                "identifier" {
                    set variable_record [get_record_as_dict $scope_name [first_node_value $node "identifier"]]
                    append vm_code "push ...\n"
                }

                 "expressionList" {

                    append vm_code [expression_list_to_vm $node $scope_name]

                }
        }
    }
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
