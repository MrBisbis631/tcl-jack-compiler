# Function to handle expressions
proc handle_expression {root} {
    set skip_node 0
    set vm_code ""
    foreach current_node [$root childNodes] {
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
                append vm_code "push this [expr {$term_content eq "x" ? 0 : $term_content eq "y" ? 1 : 2}]\n"
            }
            return $vm_code
}

#source "[file normalize .]/utils/imports.tcl"
package require tdom
set filename [lindex $argv 0]
set xml_fd [open $filename r]
set xml_content [read $xml_fd]
close $xml_fd
set doc [dom parse $xml_content]
set root [$doc documentElement]
#set expr_node [::dom::selectNode $doc /expression]
set vm_code [handle_expression $root]
puts $vm_code




# proc term_to_vm {node scope_name} {
#     set vm_code ""
#     # todo : handle term
#     set term_content [[$node firstChild] text]
#     if {[string is integer $term_content]} {
#         #integerConstant
#         append vm_code "push constant $term_content\n"

#     } elseif {$term_content in {true false null this}} {
#         #keywordConstant
#         if {$term_content eq "this"}} {
            
#             append $vm_code "push argument 0\n"
        
#         } elseif {$term_content eq "null"} {
            
#             append vm_code "push constant 0\n"
        
#         } elseif {$term_content in {true false} {
            
#             append vm_code "push constant [expr {$term_content eq "true" ? 0 : 1}]\n"
            
#             if {$term_content eq "true"} {
#                 append vm_code "not\n"
#             }
        
#         } elseif {$term_content }
        
#     }
#     return $vm_code
# }
