source "[file normalize .]/vm-2-hack/stack-ops.tcl"

# convert a VM line to HACK assembly
proc vm_to_hack {line} {
  # ignore empty lines & comments
  if {[regexp {^\s*//} $line] || [string is space $line]} {
    return ""
  } elseif {[string match "push constant*" $line]} {
    return [hack_push_constant [lindex [split $line " "] end]]
  } elseif {[string match "pop*" $line]} {
    return [hack_pop]
  } elseif {[string match "add*" $line]} {
    return [hack_add]
  } elseif {[string match "sub*" $line]} {
    return [hack_sub]
  } elseif {[string match "and*" $line]} {
    return [hack_and]
  } elseif {[string match "or*" $line]} {
    return [hack_or]
  } elseif {[string match "not*" $line]} {
    return [hack_not]
  } elseif {[string match "neg*" $line]} {
    return [hack_neg]
  } elseif {[string match "eq*" $line]} {
    return [hack_eq]
  } elseif {[string match "gt*" $line]} {
    return [hack_gt]
  } elseif {[string match "lt*" $line]} {
    return [hack_lt]
  } else {
    puts "WARNING: unknown operation: $line"
    return ""
  }
}
