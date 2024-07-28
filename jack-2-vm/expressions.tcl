# expression node to vm code
proc expression_to_vm {node scope} {
    set vm_code ""
    set children [::dom::selectNode $node *]

    # term
    append vm_code [term_to_vm [lindex $children 0] $scope]

    # (op term)*
    for {set i 1} {$i < [llength $children]} {set i [expr {$i + 2}]} {
        set op_node [lindex $children $i]
        append vm_code [term_to_vm [lindex $children [expr {$i + 1}]] $scope]
        append vm_code [op_to_vm $op_node]
    }

    return $vm_code
}


proc term_to_vm {node scope_name} {
    set vm_code ""
    set children [::dom::selectNode $node *]

    set first_node [lindex $children 0]
    set first_node_type [$first_node cget -nodeName]

    switch $first_node_type {
        "integerConstant" {
            set val [$first_node stringValue]
            append vm_code "push constant $val\n"
        }
        "stringConstant" {
            set string_constant [$first_node stringValue]
            set string_length [string length $string_constant]

            append vm_code "push constant $string_length\n"
            append vm_code "call String.new 1\n"

            foreach char [split $string_constant ""] {
                append vm_code "push constant [scan $char %c]\n"
                append vm_code "call String.appendChar 2\n"
            }
        }
        "keyword" {
            append vm_code [keyword_to_vm $first_node]
        }
        "symbol" {
            switch [$first_node stringValue] {
                "(" {
                    append vm_code [expression_to_vm [lindex $children 1] $scope_name]
                }
                "-" {
                    append vm_code [term_to_vm [lindex $children 1] $scope_name]
                    append vm_code "neg\n"
                }
                "~" {
                    append vm_code [term_to_vm [lindex $children 1] $scope_name]
                    append vm_code "not\n"
                }
            }
        }
        "identifier" {
            set next_node [lindex $children 1]


            # varName
            if {[llength $children] == 1} {
                set var_record [get_record_as_dict $scope_name [$first_node stringValue]]
                append vm_code "push [dict get $var_record kind] [dict get $var_record index]\n"

                # varName[expression]
            } elseif {[$next_node stringValue] == "\["} {
                # puts "varName [lindex children 1]"

                set var_record [get_record_as_dict $scope_name [$first_node stringValue]]
                append vm_code "push [dict get $var_record kind] [dict get $var_record index]\n"
                append vm_code [expression_to_vm [lindex $children 2] $scope_name]
                append vm_code "add\n"
                append vm_code "pop pointer 1\n"
                append vm_code "push that 0\n"

                # subroutineCall
            } else {
                append vm_code [subroutine_call_to_vm $node $scope_name]
            }
        }
    }

    return $vm_code
}

proc subroutine_call_to_vm {node scope_name} {
    set vm_code ""
    set children [::dom::selectNode $node *]

    set first_node [lindex $children 0]
    set first_node_name [$first_node stringValue]
    set first_node_type [$first_node cget -nodeName]
    set next_node [lindex $children 1]

    # subroutineName(expressionList)
    if {[$next_node stringValue] == "("} {
        append vm_code "push pointer 0\n"
        append vm_code [expression_list_to_vm [lindex $children 2] $scope_name]

        set argument_count [get_argument_count [lindex $children 2]]
        incr argument_count ;# add this pointer
        append vm_code "call [get_scops_class].$first_node_name $argument_count\n"

    # (varName | className).subroutineName(expressionList)
    } elseif {[$next_node stringValue] == "."} {

        set var_record [get_record_as_dict $scope_name [$first_node stringValue]]
        set subroutine_name [[lindex $children 2] stringValue]
        set expression_list [lindex $children 4]
        set argument_count [get_argument_count $expression_list]

        # loccal var method call
        if {$var_record != ""} {
            incr argument_count ;# add this pointer
            append vm_code "push [dict get $var_record kind] [dict get $var_record index]\n"
            append vm_code [expression_list_to_vm $expression_list $scope_name]
            append vm_code "call [dict get $var_record type].$subroutine_name $argument_count\n"
        # static call  
        } elseif {$first_node_name == [get_scops_class]} {
            append vm_code [expression_list_to_vm $expression_list $scope_name]
            append vm_code "call [get_scops_class].$subroutine_name $argument_count\n"
        } else {
            # static on other class
            append vm_code [expression_list_to_vm $expression_list $scope_name]
            append vm_code "call $first_node_name.$subroutine_name $argument_count\n"
        }
    }

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

# keywordConstant node to vm code
proc keyword_to_vm {node} {
    switch [$node stringValue] {
        "true" {return "push constant 0\nnot\n"}
        "false" {return "push constant 0\n"}
        "null" {return "push constant 0\n"}
        "this" {return "push pointer 0\n"}
    }
}
