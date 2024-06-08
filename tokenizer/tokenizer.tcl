# Tokenizer for Jack

source "[file normalize .]/tokenizer/tokens.tcl"

# General pattern for Jack tokens, including keywords, symbols, integers, and strings
set jack_pattern {("[^"]*"|[\d]+|[\w]+|[{}()\[\];.,+\-*/&|<>=~])}

# gets jack code and returns a list of tokens
proc tokenize {code} {
  global jack_pattern

  set tokens {}
  set pos 0


  # remove comments
  set code [regsub -all {//.*|/\*\*.*\*/} $code {}]

  while {[regexp -indices -start $pos $jack_pattern $code match]} {
    # extract token with the general pattren
    set start [lindex $match 0]
    set end [lindex $match 1]
    set token_str [string range $code $start $end]

    # add token as asositive array with `type` and `value` keys
    # array set token {type [get_token_type $token_str] value [get_token_value $token_str]}
    set type [get_token_type $token_str]
    set value [get_token_value $token_str]

    set token [dict create type $type value $value]
    lappend tokens $token

    set pos [expr {$end + 1}]
  }

  return $tokens
}

# gets jack code and returns a generator of tokens
proc tokenize_generator {code} {
  global jack_pattern

  set pos 0

  # remove comments
  set code [regsub -all {//.*|/\*\*.*\*/} $code {}]

  while {[regexp -indices -start $pos $jack_pattern $code match]} {
    # extract token with the general pattren
    set start [lindex $match 0]
    set end [lindex $match 1]
    set token [string range $code $start $end]

    # add token as asositive array with `type` and `value` keys
    set token [dict create type [get_token_type $token] value [get_token_value $token]]

    yield $token
    set pos [expr {$end + 1}]
  }

  # yield unpresentable character to indicate the end of the tokens
  yield "\0"
}
