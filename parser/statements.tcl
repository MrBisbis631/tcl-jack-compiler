# Analizer for statments in Jake language

# parse a single a list of statments
proc statments_parser {parent} {
  set node [create_xml_node $parent "statements"]

  # (let | if | while | do | return)*
  while {token != "\0"} {
    set child {}

    switch [get_current_token_value] {
      case "let" {
        set child [let_statement_parser $node]
      }
      case "if" {
        set child [if_statement_parser $node]
      }
      case "while" {
        set child [while_statement_parser $node]
      }
      case "do" {
        set child [do_statement_parser $node]
      }
      case "return" {
        set child [return_statement_parser $node]
      }
      default {
        break
      }
    }
  }

  return $node
}

# parse an if statement
proc let_statement_parser {parent} {
  set node [create_xml_node $parent "letStatement"]

  # let keyword
  prossess_terminal $node "keyword" "let"
  # varName statement
  var_name_parser $node
  # optional array index
  if {[get_current_token_value] == "\[" } {
    prossess_terminal $node "symbol" "\["
    expression_parser $node
    prossess_terminal $node "symbol" "\]"
  }
  # equal symbol
  prossess_terminal $node "symbol" "="
  # expression
  expression_parser $node
  # semicolon
  prossess_terminal $node "symbol" ";"

  return $node
}

# parse an if statement
proc if_statement_parser {parent} {
  set node [create_xml_node $parent "ifStatement"]

  # if keyword
  prossess_terminal $node "keyword" "if"
  # open parenthesis
  prossess_terminal $node "symbol" "("
  # expression
  expression_parser $node
  # close parenthesis
  prossess_terminal $node "symbol" ")"
  # open curly braces
  prossess_terminal $node "symbol" "\{"
  # statements
  statments_parser $node
  # close curly braces
  prossess_terminal $node "symbol" "\}"
  # optional else statement
  if {[get_current_token_value] == "else" } {
    prossess_terminal $node "keyword" "else"
    prossess_terminal $node "symbol" "\{"
    statments_parser $node
    prossess_terminal $node "symbol" "\}"
  }

  return $node
}

# parse a while statement
proc while_statement_parser {parent} {
  set node [create_xml_node $parent "whileStatement"]

  # while keyword
  prossess_terminal $node "keyword" "while"
  # open parenthesis
  prossess_terminal $node "symbol" "("
  # expression
  expression_parser $node
  # close parenthesis
  prossess_terminal $node "symbol" ")"
  # open curly braces
  prossess_terminal $node "symbol" "\{"
  # statements
  statments_parser $node
  # close curly braces
  prossess_terminal $node "symbol" "\}"

  return $node
}

# parse a do statement
proc do_statement_parser {parent} {
  set node [create_xml_node $parent "doStatement"]

  # do keyword
  prossess_terminal $node "keyword" "do"
  # subroutine call
  subroutine_call_parser $node
  # semicolon
  prossess_terminal $node "symbol" ";"

  return $node
}

# parse a return statement
proc return_statement_parser {parent} {
  set node [create_xml_node $parent "returnStatement"]

  # return keyword
  prossess_terminal $node "keyword" "return"
  # optional expression
  if {[get_current_token_value] != ";" } {
    expression_parser $node
  }
  # semicolon
  prossess_terminal $node "symbol" ";"

  return $node
}
