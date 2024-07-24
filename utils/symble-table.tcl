# Symbol Table Utils for scope management in Jack Compiler

set __symble_table_doc [::dom::DOMImplementation create]
set scops [::dom::document createElement $__symble_table_doc scops]
set __class_name ""

# clear the symble table
proc clear_symble_table {} {
  global __symble_table_doc scops __class_name
  set __symble_table_doc [::dom::DOMImplementation create]
  set scops [::dom::document createElement $__symble_table_doc scops]
  set __class_name ""
}

# Set the class of the scops element
proc set_scops_class {class_name} {
  global scops __class_name
  set __class_name $class_name
  ::dom::element setAttribute $scops class $class_name
}

# Get the class of the scops element
proc get_scops_class {} {
  global scops
  return [::dom::element getAttribute $scops class]
}

# Create a scope
proc create_scope {name {type "none"} {returns "none"}} {
  global scops
  set scope [::dom::document createElement $scops $name]
  ::dom::element setAttribute $scope type $type
  ::dom::element setAttribute $scope returns $returns
  ::dom::element setAttribute $scope static_count 0
  ::dom::element setAttribute $scope field_count 0
  ::dom::element setAttribute $scope argument_count 0
  ::dom::element setAttribute $scope local_count 0
  ::dom::element setAttribute $scope var_count 0
  return $scope
}

# Create a record in a scope
proc create_record {scope_name name type kind} {
  global scops __symble_table_doc

  set scope [::dom::selectNode $__symble_table_doc /scops/$scope_name]
  set record [::dom::document createElement $scope $name]

  # get count set the index  on record and increment it on scope
  set count 0
  switch $kind {
    "static" {
      set count [::dom::element getAttribute $scope static_count]
      ::dom::element setAttribute $scope static_count [expr $count + 1]
    }
    "field" {
      set count [::dom::element getAttribute $scope field_count]
      ::dom::element setAttribute $scope field_count [expr $count + 1]
    }
    "argument" {
      set count [::dom::element getAttribute $scope argument_count]
      ::dom::element setAttribute $scope argument_count [expr $count + 1]
    }
    "local" {
      set count [::dom::element getAttribute $scope local_count]
      ::dom::element setAttribute $scope local_count [expr $count + 1]
    }
    "var" {
      set count [::dom::element getAttribute $scope var_count]
      ::dom::element setAttribute $scope var_count [expr $count + 1]
    }
  }
  # set attributes
  ::dom::element setAttribute $record index $count
  ::dom::element setAttribute $record type $type
  ::dom::element setAttribute $record kind $kind

  return $record
}

# Get a record from a scope in the format {type kind index}
proc get_record {scope_name name} {
  global __symble_table_doc
  # fetch the record from the scope
  set record [::dom::selectNode $__symble_table_doc /scops/$scope_name/$name]

  # gets the attributes of the record
  set type [::dom::element getAttribute $record type]
  set kind [::dom::element getAttribute $record kind]
  set index [::dom::element getAttribute $record index]

  return [list $type $kind $index]
}

# Get a record from a class scope in the format {type kind index}
proc get_class_record {name} {
  global __symble_table_doc
  # fetch the record from the scope
  set record [::dom::selectNode $__symble_table_doc /scops/$__class_name/$name]

  # gets the attributes of the record
  set type [::dom::element getAttribute $record type]
  set kind [::dom::element getAttribute $record kind]
  set index [::dom::element getAttribute $record index]

  return [list $type $kind $index]
}


# Get a record from a scope in the format {type kind index}
proc get_record_as_dict {scope_name name} {
  global __symble_table_doc
  # fetch the record from the scope
  set record [::dom::selectNode $__symble_table_doc /scops/$scope_name/$name]

  # gets the attributes of the record
  set type [::dom::element getAttribute $record type]
  set kind [::dom::element getAttribute $record kind]
  set index [::dom::element getAttribute $record index]

  return [dict create type $type kind $kind index $index]
}

# Get the scope as a dict
proc get_scope_as_dict {scope_name} {
  global __symble_table_doc
  # fetch the record from the scope
  set scope [::dom::selectNode $__symble_table_doc /scops/$scope_name]

  # gets the attributes of the record
  set type [::dom::element getAttribute $scope type]
  set returns [::dom::element getAttribute $scope returns]
  set static_count [::dom::element getAttribute $scope static_count]
  set field_count [::dom::element getAttribute $scope field_count]
  set argument_count [::dom::element getAttribute $scope argument_count]
  set local_count [::dom::element getAttribute $scope local_count]
  set var_count [::dom::element getAttribute $scope var_count]

  return [dict create type $type returns $returns static_count $static_count field_count $field_count argument_count $argument_count local_count $local_count var_count $var_count]
}

# Dump the symble table - used for debugging
proc dump_symble_table {} {
  global __symble_table_doc
  puts "---- symble Table -----"
  puts [::dom::DOMImplementation serialize $__symble_table_doc -indent 1]
  puts "--- end ymble Table ---"
}
