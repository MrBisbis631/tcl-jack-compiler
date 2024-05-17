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
