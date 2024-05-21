# Translation VM Flow control commands to HACK assembly

# Generates a label in the format "(label)".
proc hack_label {label} {
  return "($label)\n"
}

# Generates a unique label in the format "(label)".
proc hack_uniq_label {label} {
  return "([uniq_label $label])\n"
}

# Generates an assembly jump command to a specified label.
proc hack_goto {label} {
  return "@$label\n0;JMP\n"
}

# Generates a conditional jump command, pops the stack, and jumps if non-zero.
proc hack_if_goto {label} {
  return "@SP\nM=M-1\nA=M\nD=M\n@$label\nD; JNE\n"
}
