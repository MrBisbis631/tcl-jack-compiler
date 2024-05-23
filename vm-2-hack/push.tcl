proc hack_push_constant {arg} {
  return "
@$arg
D=A
@SP
A=M
M=D
@SP
M=M+1
"
}

proc hack_push_local {arg} {
  return "
@$arg
D=A
@LCL
A=M
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
"
}

proc hack_push_argument {arg} {
  return "
@$arg
D=A
@ARG
A=M
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
"
}

proc hack_push_this {arg} {
  return "
@$arg
D=A
@THIS
A=M
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
"
}

proc hack_push_that {arg} {
  return "
@$arg
D=A
@THAT
A=M
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
"
}

proc hack_push_temp {arg} {
  set base_address 5
  set temp_address [expr $base_address + $arg]
  return "
@$temp_address
D=M
@SP
A=M
M=D
@SP
M=M+1
"
}

proc hack_push_pointer {arg} {
  if { $arg == 0 } {
    return "
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
"
  } elseif { $arg == 1 } {
    return "
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
"
  } else {
    puts "WARNING: Invalid push operation: push pointer $arg"
    return ""
  }
}

proc hack_push_static {arg} {
  return "
@$arg
D=M
@SP
A=M
M=D
@SP
M=M+1
"
}

proc handle_hack_push {push_param arg} {
  switch $push_param {
    "constant" {
      return [hack_push_constant $arg]
    }
    "local" {
      return [hack_push_local $arg]
    }
    "argument" {
      return [hack_push_argument $arg]
    }
    "this" {
      return [hack_push_this $arg]
    }
    "that" {
      return [hack_push_that $arg]
    }
    "temp" {
      return [hack_push_temp $arg]
    }
    "pointer" {
      return [hack_push_pointer $arg]
    }
    "static" {
      return [hack_push_static $arg]
    }
    default {
      puts "WARNING: Invalid push operation: push $push_param $arg"
      return ""
    }
  }
}
