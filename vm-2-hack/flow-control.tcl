# Translation VM Flow control commands to HACK assembly

# Generates a label in the format "(file_name.label)".
proc hack_label {label file_name} {
  return "($file_name.$label)"
}

# Generates a unique label in the format "(file_name.label)".
proc hack_uniq_label {label file_name} {
  return "($file_name.[uniq_label $label])"
}

# Generates an assembly jump command to a specified label.
proc hack_goto {label file_name} {
  return "@$file_name.$label\n0;JMP\n"
}

# Generates a conditional jump command, pops the stack, and jumps if non-zero.
proc hack_if_goto {label file_name} {
  return "@SP\nM=M-1\nA=M\nD=M\n@$file_name.$label\nD; JNE\n"
}
