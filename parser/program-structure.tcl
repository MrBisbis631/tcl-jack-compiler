
# prossers the name of the indentifiers
proc name_parser {parent} {
  prossess_terminal $parent "identifier" [get_current_token_value]
}
