package require xml

proc create_xml_example {} {
  set doc [::dom::DOMImplementation create]
  set top [::dom::document createElement $doc Root]
  set node [::dom::document createElement $top First]
  ::dom::document createElement $node Second
  ::dom::document createElement $top First
  ::dom::document createElement $node Third
  ::dom::document createElement $top Second
  ::dom::document createElement $top Third
  return [::dom::DOMImplementation serialize $doc -indent 1]
  ::dom::document createElement $top Fourth
  ::dom::document createElement $top Fifth
}

# Define the XML content
set xml_content {<?xml version="1.0" encoding="UTF-8"?>
  <root>
  <person>
  <name>John</name>
  <age>30</age>
  <city>New York</city>
  </person>
  <person>
  <name>Alice</name>
  <age>25</age>
  <city>London</city>
  </person>
  </root>
}

proc parse_xml_example {xml_content} {
  set doc [::dom::DOMImplementation parse $xml_content]
  set people [::dom::selectNode $doc /root/person]
  # puts is $people a node => 0
  puts [::dom::isNode $people]  
  foreach person $people {
    set name [::dom::selectNode $person name]
    set age [::dom::selectNode $person age]
    set city [::dom::selectNode $person city]

    puts "Name: [$name stringValue], Age: [$age stringValue], City: [$city stringValue]"
  }
}

puts "XML content:\n [create_xml_example]" 
parse_xml_example $xml_content
