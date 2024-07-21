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

proc char_to_ascii {char} {
    # Check if the input is a single character
    if {[string length $char] != 1} {
        error "Input must be a single character"
    }
    
    # Convert the character to its ASCII value
    set ascii_value [scan $char %c]
    
    return $ascii_value
}