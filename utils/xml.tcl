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
proc create_xml_node {parent name {attributes {}}} {
  set node [::dom::document createElement $parent $name]
  if {$attributes != ""} {
    foreach {key value} $attributes {
      ::dom::element setAttribute $node $key $value
    }
  }

  return $node
}

# Return the tokens of an XML document
proc xml_to_tokens_generator {doc} {
  # yield empty forr init
  yield ""
  foreach token [::dom::selectNode $doc /tokens/*] {
    set value [string trim [$token stringValue]]
    set type [$token cget -nodeName]
    yield [dict create type $type value $value]
  }

  yield "\0"
}

# returns the value of the first node with a given name
proc first_node_value {node name} {
  set first_node [::dom::selectNode $node $name]
  if {[llength $first_node] == 0} {
    return ""
  }
  return [[lindex $first_node 0] stringValue]
}

# Return the nodes of an XML document as a generator
proc xml_nodes_generator {nodes} {
  yield ""
  foreach node $nodes {
    yield $node
  }
  yield "\0"
}

# Add attributes to an XML node from an associative list
proc add_attributes {node list} {
  foreach {key value} [array get $list] {
    ::dom::element setAttribute $node $key $value
  }
}
