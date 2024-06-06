# Simple example of tokenizing Jack code

source "[file normalize .]/utils/imports.tcl"

# Sample Jack code
set jack_code {
  class Main {
    function void main() {
      var int x;
      let x = 2 + 3;
      let y = "Hello, World!"
      do Output.printInt(x);
      do Output.printString(y);
      return;
    }
  }
}

set doc [::dom::DOMImplementation create]
set root [::dom::document createElement $doc tokens]

# Token generator
for {set token [coroutine token_gen tokenize_generator $jack_code]} {$token != "\0"} {set token [token_gen]} {
  token_to_xml_node $token $root
  puts "[dict get $token type]: [dict get $token value]"
}

puts "\nAnd now, the XML representation of the tokens:\n"
puts [::dom::DOMImplementation serialize $doc -indent 1]
