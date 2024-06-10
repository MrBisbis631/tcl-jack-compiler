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

# insert a leaf into the xml persed tree
proc prossess_terminal {parent type value} {
  if {[get_current_token_value] != $value} {
    error "PARSER ERROR: expected $value but got [get_current_token_value]"
  }
  create_xml_leaf $parent $type $value
  get_next_token
}
