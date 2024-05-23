# translate VM call function to HACK assembly
proc hack_call {func_name args_count} {
  set return_label "RETURN_${func_name}_[clock seconds]"
  return "
@$return_label
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
D=M
@$args_count
D=D-A
@5
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@$func_name
0;JMP
($return_label)
"
}

# translate VM function declaration to HACK assembly
proc hack_function {function_name argument_count} {
  set result "($function_name)\n"

  # Initialize local variables to 0
  for {set i 0} {$i < $argument_count} {incr i} {
    append result "@SP\nA=M\nM=0\n@SP\nM=M+1\n"
  }

  return $result
}

# push to stack function resoult and clean up
proc hack_return {} {
  return "
@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@R13
AM=M-1
D=M
@THAT
M=D
@R13
AM=M-1
D=M
@THIS
M=D
@R13
AM=M-1
D=M
@ARG
M=D
@R13
AM=M-1
D=M
@LCL
M=D
@R14
A=M
0;JMP
"
}
