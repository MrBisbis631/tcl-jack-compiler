proc hack_pop_local {arg} {
  return "
@$arg
D=A
@LCL
D=M+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D
"
}

proc hack_pop_argument {arg} {
  return "
@$arg
D=A
@ARG
D=M+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D
"
}

proc hack_pop_this {arg} {
  return "
@$arg
D=A
@THIS
D=M+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D
"
}

proc hack_pop_that {arg} {
  return "
@$arg
D=A
@THAT
D=M+D
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D
"
}

proc hack_pop_temp {arg} {
  set base_address 5
  set temp_address [expr $base_address + $arg]
  return "
@SP
AM=M-1
D=M
@$temp_address
M=D
"
}

proc hack_pop_pointer {arg} {
  if { $arg == 0 } {
    return "
@SP
AM=M-1
D=M
@THIS
M=D
"
  } elseif { $arg == 1 } {
    return "
@SP
AM=M-1
D=M
@THAT
M=D
"
  } else {
    puts "WARNING: Invalid pop operation: pop pointer $arg"
    return ""
  }
}

proc hack_pop_static {arg} {
  return "
@SP
AM=M-1
D=M
@$arg
M=D
"
}

proc handle_hack_pop {pop_param arg} {
  switch $pop_param {
    "local" {
      return [hack_pop_local $arg]
    }
    "argument" {
      return [hack_pop_argument $arg]
    }
    "this" {
      return [hack_pop_this $arg]
    }
    "that" {
      return [hack_pop_that $arg]
    }
    "temp" {
      return [hack_pop_temp $arg]
    }
    "pointer" {
      return [hack_pop_pointer $arg]
    }
    "static" {
      return [hack_pop_static $arg]
    }
    default {
      puts "WARNING: Invalid pop operation: pop $pop_param $arg"
      return ""
    }
  }
}