# Translation VM functions call to HACK assembly

# return label for starting a function block
proc start_function_label {func_name} {
  return "START__$func_name"
}

# return label for caller of a function
proc end_call_function_label {func_name} {
  return "END_CALL__${func_name}_[number_gen]"
}

# push address to stack by address - used for known addresses like LCL, ARG, THIS, THAT etc.
proc hack_push_address_by_ref {ref} {
  return "@$ref\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
}

# translate VM call function to HACK assembly
proc hack_call {func_name args_count} {
  set end_coller_label [end_call_function_label $func_name]
  return "// START CALL: $func_name\n@$end_coller_label\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n [hack_push_address_by_ref "LCL"][hack_push_address_by_ref "ARG"][hack_push_address_by_ref "THIS"][hack_push_address_by_ref "THAT"]@SP\nD=M\n@$args_count\nD=D-A\n@ARG\nM=D\n@SP\nD=M\n@LCL\nM=D\n@[start_function_label $func_name]\n0;JMP\n($end_coller_label)\n// END CALL: $func_name\n"
}

# translate VM function declaration to HACK assembly
proc hack_function {func_name args_count} {
  return "// FUNCTION DEFINITION: $func_name\n([start_function_label $func_name])\n@$args_count\nD=A\n(LOOP.ADD_LOCALS.$func_name)\n@NO_LOCALS.$func_name\nD;JEQ\n@SP\nA=M\nM=0\n@SP\nM=M+1\nD=D-1\n@LOOP.ADD_LOCALS.$func_name\nD;JNE\n(NO_LOCALS.$func_name)\n@2\nD=M\n@SP\nD=D+A\nA=D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
}

# push to stack function resoult and clean up
proc hack_return {} {
  return "@LCL\nD=M\n@R13\nM=D\n@5\nD=A\n@R13\nA=M-D\nD=M\n@R14\nM=D\n@SP\nAM=M-1\nD=M\n@ARG\nA=M\nM=D\n@ARG\nD=M+1\n@SP\nM=D\n@1\nD=A\n@R13\nA=M-D\nD=M\n@THAT\nM=D\n@2\nD=A\n@R13\nA=M-D\nD=M\n@THIS\nM=D\n@3\nD=A\n@R13\nA=M-D\nD=M\n@ARG\nM=D\n@4\nD=A\n@R13\nA=M-D\nD=M\n@LCL\nM=D\n"
}

# pop local variable
proc hack_pop_local {arg} {
  return "@SP\nAM=M-1\nD=M\n@$arg\nD=D+A\n@R13\nM=D\n@SP\nA=M\nD=M\n@R13\nA=M\nM=D\n"
}

# pop argument
proc hack_pop_argument {arg} {
  return "@SP\nAM=M-1\nD=M\n@$arg\nD=D+A\n@R13\nM=D\n@SP\nA=M\nD=M\n@R13\nA=M\nM=D\n"
}

# push local variable
proc hack_push_local {arg} {
  return "@$arg\nD=A\n@LCL\nA=M\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
}

# push argument
proc hack_push_argument {arg} {
  return "@$arg\nD=A\n@ARG\nA=M\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
}

# bootstrap code - set up stack and call Sys.init
proc bootstrap {} {
  return "// bootstarp\n@256\nD=A\n@SP\nM=D\n@Sys.init.ReturnAddress0\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n@LCL\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n@ARG\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n@THIS\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n@THAT\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n@SP\nD=M\n@SP\nD=D-A\n@5\nD=D-A\n@ARG\nM=D\n@SP\nD=M\n@LCL\nM=D\n@Sys.init.ReturnAddress0\n0;JMP\n(Sys.init.ReturnAddress0)\n"
}
