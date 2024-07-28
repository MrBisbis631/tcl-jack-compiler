set __num 0

# generate a number and increment it each time
proc number_gen {} {
  global __num
  incr __num
  return $__num
}

# return a unique label
proc uniq_label {label} {
  return "${label}_[number_gen]"
}

# generate resoults from a generator and pipe them to a command
proc pipe_coroutine_generator {command generator} {
  set gen_res [$generator]
  yield [$command $gen_res]
}

# gets argument count from expression list node
proc get_argument_count {expression_list_node} {
  set argument_count 0
  foreach args_item [::dom::selectNode $expression_list_node *] {
    if {[$args_item cget -nodeName] != "symbol"} {
      incr argument_count
    }
  }
  return $argument_count
}
