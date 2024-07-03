# Experiment with the symbol table API

source "[file normalize .]/utils/imports.tcl"

# Create multiple scopes with multiple records
set scope1 [create_scope "scope1"]
set record1_1 [create_record "scope1" "record1_1" "int" "static"]
set record1_2 [create_record "scope1" "record1_2" "string" "field"]
# Create another scope with records
set scope2 [create_scope "scope2"]
set record2_1 [create_record "scope2" "record2_1" "boolean" "argument"]
set record2_2 [create_record "scope2" "record2_2" "char" "local"]
set record2_3 [create_record "scope2" "record2_3" "float" "var"]
# Create another scope with records
set scope3 [create_scope "scope3"]
set record3_1 [create_record "scope3" "record3_1" "int" "static"]
set record3_2 [create_record "scope3" "record3_2" "string" "field"]
set record3_3 [create_record "scope3" "record3_3" "boolean" "argument"]
set record3_4 [create_record "scope3" "record3_4" "char" "local"]
set record3_5 [create_record "scope3" "record3_5" "float" "var"]
# Create more records of the same kind in the existing scope
set record3_6 [create_record "scope3" "record3_6" "int" "static"]
set record3_7 [create_record "scope3" "record3_7" "string" "field"]
set record3_8 [create_record "scope3" "record3_8" "boolean" "argument"]
set record3_9 [create_record "scope3" "record3_9" "char" "local"]
set record3_10 [create_record "scope3" "record3_10" "float" "var"]

# Print the XML representation of the document
puts "XML representation of the document:\n"
puts [$doc asXML]

# Print the records created in the scopes
puts "\nRecords created in the scopes:\n"
puts [get_record "scope1" "record1_1"]
puts [get_record "scope1" "record1_2"]
puts [get_record "scope2" "record2_1"]
