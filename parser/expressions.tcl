# Analizer Expressions in Jake language

# expression -> term (op term)*
proc expression_parser {parent} {
  set node [create_xml_node $parent "expression"]

  # term
  term_parser $node
  # (op term)*
  while {[is_op [get_current_token_value]]} {
    op_parser $node
    term_parser $node
  }

  return $node
}

# term -> integerConstant | stringConstant | keywordConstant | varName | varName '[' expression ']' | subroutineCall | '(' expression ')' | unaryOp term
proc term_parser {parent} {
  global keywordToken symbolToken identifierToken integerConstantToken stringConstantToken

  set node [create_xml_node $parent "term"]

  set token [get_current_token]
  set value [dict get $token value]
  set type [dict get $token type]

  # integerConstant | stringConstant | keywordConstant
  if {[regexp "$keywordToken(name)|$symbolToken(name)|$identifierToken(name)|$integerConstantToken(name)|$stringConstantToken(name)" $type]} {
    prossess_terminal $node $value

  # varName | varName '[' expression ']' | subroutineCall
  } elseif {[is_identifier $value]} {
    name_parser $node
    # '[' expression ']'
    if {[get_current_token_value] == "\["} {
      prossess_terminal $node "\["
      expression_parser $node
      prossess_terminal $node "\]"
    # subroutineCall
    } elseif {[get_current_token_value] eq "(" || [get_current_token_value] eq "."} {
      subroutine_call_without_name_parser $node
    }

  # '(' expression ')'
  } elseif {$value eq "("} {
    prossess_terminal $node "("
    expression_parser $node
    prossess_terminal $node ")"

  # unaryOp term
  } elseif {[is_unary_op $value]} {
    unary_op_parser $node
    term_parser $node
  }

  return $node
}

# op -> '+' | '-' | '*' | '/' | '&' | '|' | '<' | '>' | '='
proc op_parser {parent} {
  set node [create_xml_node $parent "symbol"]
  prossess_terminal $node [get_current_token_value]
  return $node
}

# unaryOp -> '-' | '~'
proc unary_op_parser {parent} {
  set node [create_xml_node $parent "symbol"]
  prossess_terminal $node [get_current_token_value]
  return $node
}

# keywordConstant -> 'true' | 'false' | 'null' | 'this'
proc keyword_constant_parser {parent} {
  set node [create_xml_node $parent "keyword"]
  prossess_terminal $node [get_current_token_value]
  return $node
}

# expressionList -> (expression (',' expression)*)?
proc expression_list_parser {parent} {
  set node [create_xml_node $parent "expressionList"]

  # (expression (',' expression)*)?
  if {[is_expression [get_current_token_value]]} {
    expression_parser $node
    while {[get_current_token_value] eq ","} {
      prossess_terminal $node ","
      expression_parser $node
    }
  }

  return $node
}

# subroutineCall -> subroutineName '(' expressionList ')' | (className | varName) '.' subroutineName '(' expressionList ')'
proc subroutine_call_parser {parent} {
  set node [create_xml_node $parent "subroutineCall"]

  # subroutineName '(' expressionList ')'
  if {[is_identifier [get_current_token_value]]} {
    prossess_terminal $node [get_current_token_value]
    prossess_terminal $node "("
    expression_list_parser $node
    prossess_terminal $node ")"
  } else {
    # (className | varName) '.' subroutineName '(' expressionList ')'
    prossess_terminal $node [get_current_token_value]
    prossess_terminal $node "."
    prossess_terminal $node [get_current_token_value]
    prossess_terminal $node "("
    expression_list_parser $node
    prossess_terminal $node ")"
  }

  return $node
}

# subroutineCall -> '(' expressionList ')'
proc subroutine_call_without_name_parser {parent} {
  prossess_terminal $parent "("
  expression_list_parser $parent
  prossess_terminal $parent ")"

  return $parent
}
