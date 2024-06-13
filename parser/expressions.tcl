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
  global keywordToken integerConstantToken stringConstantToken

  set node [create_xml_node $parent "term"]

  set token [get_current_token]
  set value [dict get $token value]
  set type [dict get $token type]

  # integerConstant | stringConstant | keywordConstant
  if {[regexp "$keywordToken(name)|$integerConstantToken(name)|$stringConstantToken(name)" $type]} {
    prossess_terminal $node $type $value

    # varName | varName '[' expression ']' | subroutineCall
  } elseif {[is_identifier $value]} {
    name_parser $node
    # '[' expression ']'
    if {[get_current_token_value] == "\["} {
      prossess_terminal $node "symbol" "\["
      expression_parser $node
      prossess_terminal $node "symbol" "\]"
      # subroutineCall
    } elseif {[get_current_token_value] eq "("} {
      subroutine_call_without_name_parser $node
    } elseif {[get_current_token_value] eq "."} {
      prossess_terminal $node "symbol" "."
      name_parser $node
      subroutine_call_without_name_parser $node
    }

    # '(' expression ')'
  } elseif {$value eq "("} {
    prossess_terminal $node "symbol" "("
    expression_parser $node
    prossess_terminal $node "symbol" ")"

    # unaryOp term
  } elseif {[is_unary_op $value]} {
    unary_op_parser $node
    term_parser $node
  }

  return $node
}

# op -> '+' | '-' | '*' | '/' | '&' | '|' | '<' | '>' | '='
proc op_parser {parent} {
  prossess_terminal $parent "symbol" [get_current_token_value]
  return $parent
}

# unaryOp -> '-' | '~'
proc unary_op_parser {parent} {
  prossess_terminal $parent "symbol" [get_current_token_value]
  return $parent
}

# keywordConstant -> 'true' | 'false' | 'null' | 'this'
proc keyword_constant_parser {parent} {
  prossess_terminal $parent "keyword" [get_current_token_value]
  return $parent
}

# expressionList -> (expression (',' expression)*)?
proc expression_list_parser {parent} {
  set node [create_xml_node $parent "expressionList"]

  # (expression (',' expression)*)?
  if {[is_expression [get_current_token]]} {
    expression_parser $node
    while {[get_current_token_value] eq ","} {
      prossess_terminal $node "symbol" ","
      expression_parser $node
    }
  }

  return $node
}

# subroutineCall -> subroutineName '(' expressionList ')' | (className | varName) '.' subroutineName '(' expressionList ')'
proc subroutine_call_parser {parent} {
  # subroutineName | (className | varName)
  name_parser $parent

  # . subroutineName
  if {[get_current_token_value] eq "."} {
    prossess_terminal $parent "symbol" "."
    name_parser $parent
  }

  # '(' expressionList ')'
  prossess_terminal $parent "symbol" "("
  expression_list_parser $parent
  prossess_terminal $parent "symbol" ")"

  return $parent
}

# subroutineCall -> '(' expressionList ')'
proc subroutine_call_without_name_parser {parent} {
  prossess_terminal $parent "symbol" "("
  expression_list_parser $parent
  prossess_terminal $parent "symbol" ")"

  return $parent
}
