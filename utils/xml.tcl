# Utilities for xml parsing and generation

# Convert a token (dict with `type` and `value`) to an XML node
proc token_to_xml_node {token parent} {
  # ensure token is a dict with `type` and `value` keys
  if {![dict exists $token type] || ![dict exists $token value]} {
    error "Token $token must contain 'type' and 'value' keys"
  }

  # create node named after token type
  set node [::dom::document createElement $parent [dict get $token type]]
  # insert text node with token value
  ::dom::document createTextNode $node [dict get $token value]
}

# Create an XML node with a given name and value
proc create_xml_leaf {parent name value} {
  set node [::dom::document createElement $parent $name]
  ::dom::document createTextNode $node $value
  return $node
}

# Create an XML node with a given name
proc create_xml_node {parent name} {
  set node [::dom::document createElement $parent $name]
  return $node
}

# Return the tokens of an XML document
proc xml_to_tokens_generator {doc} {
  foreach token [::dom::selectNode $doc /tokens/*] {
    set value [string trim [$token stringValue]]
    set type [$token cget -nodeName]
    yield [dict create type $type value $value]
  }

  yield "\0"
}
