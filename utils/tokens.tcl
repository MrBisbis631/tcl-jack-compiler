# Utoilities for streaming tokens from a corutine

# `__tokens_generator` is the corutine that generates tokens
set __tokens_generator {}
# `__current_token` is the current token
set __current_token {}

# initialize the tokens generator
proc init_tokens_generator {tokens_corutine_name} {
  global __tokens_generator __current_token
  set __tokens_generator $tokens_corutine_name
  set __current_token [$tokens_corutine_name]
}

# get the current token
proc get_current_token {} {
  global __current_token
  return $__current_token
}

# get the current token value
proc get_current_token_value {} {
  set token [get_current_token]
  set value [dict get $token value]
  return $value
}

# get the next token value
proc get_next_token_value {} {
  set token [get_next_token]
  if {__current_token == "\0"} {
    return ""
  }
  set value [dict get $token vaule]
  return $value
}

# advance to the next token and return it
proc get_next_token {} {
  global __tokens_generator __current_token
  set __current_token [$__tokens_generator]
  return $__current_token
}

# insert a leaf into the xml persed tree
proc prossess_terminal {parent type value} {
  set token_value [get_current_token_value]
  if {$token_value != $value} {
    error "PARSER ERROR: expected $value but got $token_value"
  }
  set leaf [create_xml_leaf $parent $type $value]
  get_next_token
  return $leaf
}

# check if the current token is an operator
proc is_op {value} {
  return [regexp {[+\-*/<>|&=]} $value]
}

# check if the current token is a unary operator
proc is_unary_op {value} {
  return [regexp {^[-~]$} $value]
}

proc is_expression {token} {
  set value [dict get $token value]
  set type [dict get $token type]
  
  # any constant is an expression
  if {$type == "integerConstant" || $type == "stringConstant" || $type == "keywordConstant" || $type == "identifier"} {
    return 1
  }

  set number_regex {^[0-9]+$}
  set string_regex {^".*"$}
  set keyword_regex {^(true|false|null|this)$}
  set variable_regex {^[a-zA-Z_][a-zA-Z0-9_]*$}
  set unary_op_regex {^[-~]$}
  set open_parenthesis_regex {^\($}
  return [regexp "$number_regex|$string_regex|$keyword_regex|$variable_regex|$unary_op_regex|$open_parenthesis_regex" $value]
}

# check if the current token is a indntifier
proc is_identifier {value} {
  return [regexp {^[a-zA-Z_][a-zA-Z0-9_]*$} $value]
}

# check whether the current token is a type
proc is_type {value} {
  if {[regexp {^(int|char|boolean)$} $value] || [is_identifier $value]} {
    return 1
  } 
  return 0
}
