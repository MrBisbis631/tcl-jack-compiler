source "[file normalize .]/vm-2-hack/stack-ops.tcl"
source "[file normalize .]/vm-2-hack/flow-control.tcl"
source "[file normalize .]/vm-2-hack/functions-call.tcl"
source "[file normalize .]/vm-2-hack/pop.tcl"
source "[file normalize .]/vm-2-hack/push.tcl"

# convert a VM line to HACK assembly
proc vm_to_hack {line} {
  # ignore empty lines and comments
  if {[string is space $line] || [string match "//*" $line]} {
    return ""
  }

  # trim and remove comments from the line
  set line_without_comment [
    string trim [
    lindex [split [string trim $line] "//"] 0
    ]
  ]
  set instruction_components_list [split $line_without_comment]
  # get the instruction from the line
  set instruction [lindex $instruction_components_list 0]
  # handle the operation by number of arguments in the line
  switch $instruction {
    "add" {
      return [hack_add]
    }
    "sub" {
      return [hack_sub]
    }
    "and" {
      return [hack_and]
    }
    "or" {
      return [hack_or]
    }
    "not" {
      return [hack_not]
    }
    "neg" {
      return [hack_neg]
    }
    "eq" {
      return [hack_eq]
    }
    "gt" {
      return [hack_gt]
    }
    "lt" {
      return [hack_lt]
    }
    "return" {
      return [hack_return]
    }
    "label" {
      return [hack_label [lindex $instruction_components_list 1]]
    }
    "goto" {
      return [hack_goto [lindex $instruction_components_list 1]]
    }
    "if-goto" {
      return [hack_if_goto [lindex $instruction_components_list 1]]
    }
    "function" {
      return [hack_function [lindex $instruction_components_list 1] [lindex $instruction_components_list 2]]
    }
    "call" {
      return [hack_call [lindex $instruction_components_list 1] [lindex $instruction_components_list 2]]
    }
    "push" {
      return [handle_hack_push [lindex $instruction_components_list 1] [lindex $instruction_components_list 2]]
    }
    "pop" {
      return [handle_hack_pop [lindex $instruction_components_list 1] [lindex $instruction_components_list 2]]
    }
    default {
      puts "WARNING: unknown operation: $instruction_components_list"
      return ""
    }
  }
}
