# collection of tokens with thier patterns and names

# keywords in the Jack language
array set keywordToken {
  pattern {class constructor function method field static var int char boolean void true false null this let do if else while return}
  name "keyword"
}

# symbols in the Jack language
array set symbolToken {
  pattern {^[{}()\[\];.,+\-*/&|<>=~]$}
  name "symbol"
}

# identifiers in the Jack language
array set identifierToken {
  pattern {^[A-Za-z_][\w]*$}
  name "identifier"
}

# integer constants in the Jack language
array set integerConstantToken {
  pattern {^[\d]+$}
  name "integerConstant"
}

# string constants in the Jack language
array set stringConstantToken {
  pattern {^"[^"]*"$}
  name "stringConstant"
}

# gets a string token and returns its type
proc get_token_type {token_str} {
  global keywordToken symbolToken identifierToken integerConstantToken stringConstantToken

  if {[string index $token_str 0] eq "\"" && [string index $token_str end] eq "\""} {
    return $stringConstantToken(name)
  } elseif {[llength [regexp -inline $integerConstantToken(pattern) $token_str]] == 1} {
    return $integerConstantToken(name)
  } elseif {[lsearch -exact $keywordToken(pattern) $token_str] != -1} {
    return $keywordToken(name)
  } elseif {[regexp $identifierToken(pattern) $token_str]} {
    return $identifierToken(name)
  } elseif {[regexp $symbolToken(pattern) $token_str]} {
    return $symbolToken(name)
  } else {
    puts "WARNING: unknown token: $token_str"
    return "unknown"
  }
}

# gets a string token and returns its value, without the quotes for string constants
proc get_token_value {token_str} {
  if {[string index $token_str 0] eq "\"" && [string index $token_str end] eq "\""} {
    return [string range $token_str 1 end-1]
  }
  return $token_str
}
