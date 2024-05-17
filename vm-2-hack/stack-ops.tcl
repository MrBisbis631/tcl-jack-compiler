# Translation VM arithmetics to HACK assembly language - Stack operations

# perform `op` on top two elements of stack
proc stack_operation {op} {
  return "@SP\nAM=M-1\nD=M\nA=A-1\nM=M${op}D\n"
}

# perform `op` on top element of stack
proc logical_operation {op} {
  return "@SP\nM=M-1\nA=M\nD=M\nA=A-1\nM=D${op}M\n"
}

proc hack_push_constant {const} {
  return "@${const}\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
}

proc hack_pop {} {
  return "@SP\nM=M-1\nA=M\nD=M\n"
}

proc hack_add {} {
  return [stack_operation "+"]
}

proc hack_sub {} {
  return [stack_operation "-"]
}

proc hack_and {} {
  return [logical_operation "&"]
}

proc hack_or {} {
  return [logical_operation "|"]
}

proc hack_not {} {
  return "@SP\nA=M-1\nM=!M\n"
}

proc hack_neg {} {
  return "@SP\nA=M-1\nM=-M\n"
}

proc hack_eq {} {
  set if_true_label [uniq_label "IF_TRUE"]
  set if_false_label [uniq_label "IF_FALSE"]
  return "@SP\nA=M-1\nD=M\nA=A-1\nD=M-D\n@${if_true_label}\nD;JEQ\n@SP\nA=M-1\nA=A-1\nM=0\n@${if_false_label}\n0;JMP\n(${if_true_label})\n@SP\nA=M-1\nA=A-1\nM=-1\n(${if_false_label})\n@SP\nM=M-1\n"
}

proc hack_gt {} {
  set if_true_label [uniq_label "IF_TRUE"]
  set if_false_label [uniq_label "IF_FALSE"]
  return "@SP\nA=M-1\nD=M\nA=A-1\nD=M-D\n@${if_true_label}\nD;JGT\n@SP\nA=M-1\nA=A-1\nM=0\n@${if_false_label}\n0;JMP\n(${if_true_label})\n@SP\nA=M-1\nA=A-1\nM=-1\n(${if_false_label})\n@SP\nM=M-1\n"
}

proc hack_lt {} {
  set if_true_label [uniq_label "IF_TRUE"]
  set if_false_label [uniq_label "IF_FALSE"]
  return "@SP\nA=M-1\nD=M\nA=A-1\nD=M-D\n@${if_true_label}\nD;JLT\n@SP\nA=M-1\nA=A-1\nM=0\n@${if_false_label}\n0;JMP\n(${if_true_label})\n@SP\nA=M-1\nA=A-1\nM=-1\n(${if_false_label})\n@SP\nM=M-1\n"
}
