# Jack language parser - Program Structure

# prossers the name of the indentifiers
proc name_parser {parent} {
  prossess_terminal $parent "identifier" [get_current_token_value]
}

proc class_parser {parent} {
  set node [create_xml_node $parent "class"]

  # class
  prossess_terminal $node "keyword" "class"
  # className
  name_parser $node
  # '{'
  prossess_terminal $node "symbol" "\{"

  # classVarDec*
  while {[class_var_dec_parser $node] != ""} {}

  # subroutineDec*
  while {[subroutine_dec_parser $node] != ""} {}

  # '}'
  prossess_terminal $node "symbol" "\}"

  return $node
}

# classVarDec
proc class_var_dec_parser {parent} {
  set token [get_current_token_value]
  if {![regexp {static|field} $token]} {
    return ""
  }

  set node [create_xml_node $parent "classVarDec"]

  # static | field
  prossess_terminal $node "keyword" $token
  # type
  type_parser $node
  # varName
  name_parser $node

  # (',' varName)*
  while {[string match "," [get_current_token_value]]} {
    # ','
    prossess_terminal $node "symbol" ","
    # varName
    name_parser $node
  }

  # ';'
  prossess_terminal $node "symbol" ";"

  return $node
}

# type
proc type_parser {parent} {
  # set node name to keyword if the token is int, char or boolean otherwise (class declaration) set it to identifier
  set node_type [expr {[regexp {int|char|boolean} [get_current_token_value]] ? "keyword" : "identifier"}]
  # node is flat - goes to the parent
  prossess_terminal $parent $node_type [get_current_token_value]
  return $parent
}

# subroutineDec
proc subroutine_dec_parser {parent} {
  set token [get_current_token_value]

  # finished the soubroutineDec
  if {![regexp {constructor|function|method} $token]} {
    return ""
  }

  set node [create_xml_node $parent "subroutineDec"]

  # constructor | function | method
  prossess_terminal $node "keyword" $token
  # void | type
  if {[string match "void" [get_current_token_value]]} {
    prossess_terminal $node "keyword" "void"
  } else {
    type_parser $node
  }
  # subroutineName
  name_parser $node
  # '('
  prossess_terminal $node "symbol" "("
  # parameterList
  parameter_list_parser $node
  # ')'
  prossess_terminal $node "symbol" ")"
  # subroutineBody
  subroutine_body_parser $node

  return $node
}

# parameterList
proc parameter_list_parser {parent} {
  set node [create_xml_node $parent "parameterList"]

  # if the next token is ')' therfore the parameter list is empty - return the node
  if {[get_current_token_value] == ")"} {
    return $node
  }

  # type
  type_parser $node
  # varName
  name_parser $node

  # (',' type varName)*
  while {[get_current_token_value] eq ","} {
    # ','
    prossess_terminal $node "symbol" ","
    # type
    type_parser $node
    # varName
    name_parser $node
  }

  return $node
}

# subroutineBody
proc subroutine_body_parser {parent} {
  set node [create_xml_node $parent "subroutineBody"]

  # '{'
  prossess_terminal $node "symbol" "\{"
  # varDec*
  while {[get_current_token_value] eq "var"} {
    var_dec_parser $node
  }
  # statements
  statements_parser $node
  # '}'
  prossess_terminal $node "symbol" "\}"

  return $node
}

# varDec
proc var_dec_parser {parent} {
  set node [create_xml_node $parent "varDec"]

  # 'var'
  prossess_terminal $node "keyword" "var"
  # type
  type_parser $node
  # varName
  name_parser $node

  # (',' varName)*
  while {[string match "," [get_current_token_value]]} {
    # ','
    prossess_terminal $node "symbol" ","
    # varName
    name_parser $node
  }

  # ';'
  prossess_terminal $node "symbol" ";"

  return $node
}

# className
proc class_name_parser {parent} {
  prossess_terminal $parent "identifier" [get_current_token_value]
}

# subroutineName
proc subroutine_name_parser {parent} {
  prossess_terminal $parent "identifier" [get_current_token_value]
}

# varName
proc var_name_parser {parent} {
  prossess_terminal $parent "identifier" [get_current_token_value]
}
