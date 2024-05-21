source "[file normalize .]/vm-2-hack/stack-ops.tcl"
source "[file normalize .]/vm-2-hack/flow-control.tcl"
source "[file normalize .]/vm-2-hack/functions-call.tcl"

# convert a VM line to HACK assembly
proc vm_to_hack {line} {
  # trim the line, remove comments and return the components of the line
  set line_components_list [split [string first "//" [string trim $line]]]

  # if emply -> comment => skip
  if {[string is space $line_components_list]} {
    return ""
  }

  # get the instruction from the line
  set instruction [lindex $line_components_list 0]

  # handle the operation by number of arguments in the line
  switch [lindex $line_components_list] {
    3 {
      return [handle_0_args_instruction $instruction]
    }
    2 {
      set arg1 [lindex $line_components_list 1]
      return [handle_1_args_instruction $instruction $arg1]
    }
    1 {
      set arg1 [lindex $line_components_list 1]
      set arg2 [lindex $line_components_list 2]
      return [handle_2_args_instruction $instruction $arg1 $arg2]
    }
    default {
      puts "WARNING: unknown operation: $line"
      return ""
    }
  }
}

# handle instructions with 0 arguments
proc handle_0_args_instruction {instruction} {
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
    default {
      puts "WARNING: unknown operation: $instruction"
      return ""
    }
  }
}

# handle instructions with 1 argument
proc handle_1_args_instruction {instruction arg1} {
  switch $instruction {
    "push" {
      return [hack_push $arg1]
    }
    "pop" {
      return [hack_pop $arg1]
    }
    "label" {
      return [hack_label $arg1]
    }
    "goto" {
      return [hack_goto $arg1]
    }
    "if-goto" {
      return [hack_if_goto $arg1]
    }
    default {
      puts "WARNING: unknown operation: $instruction"
      return ""
    }
  }
}

# handle instructions with 2 arguments
proc handle_2_args_instruction {instruction arg1 arg2} {
  switch $instruction {
    "push" {
      return [hack_push $arg1 $arg2]
    }
    "pop" {
      if {$arg1 == "local"} {
        return [hack_pop_local $arg2]
      } else {
        puts "WARNING: unknown operation: $instruction"
        return ""                
      }
    }
    "function" {
      return [hack_function $arg1 $arg2]
    }
    "call" {
      return [hack_call $arg1 $arg2]
    }
    default {
      puts "WARNING: unknown operation: $instruction"
      return ""
    }
  }
}
