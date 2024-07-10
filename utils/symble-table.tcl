# Symbol Table Utils for scope management in Jack Compiler

set __symble_table_doc [dom createDocument scops]
set scops [$__symble_table_doc documentElement]

# Create a scope
proc create_scope {name} {
  global scops __symble_table_doc
  set scope [$__symble_table_doc createElement $name]
  $scope setAttribute static_count 0
  $scope setAttribute field_count 0
  $scope setAttribute argument_count 0
  $scope setAttribute local_count 0
  $scope setAttribute var_count 0
  $scops appendChild $scope
  return $scope
}

# get scope node
proc get_scope_records {name} {
  global __symble_table_doc
  set scope [$__symble_table_doc selectNodes /scops/$name]

  set records_list {}

  foreach record [$scope selectNodes *] {
    set type [$record getAttribute type]
    set kind [$record getAttribute kind]
    set index [$record getAttribute index]

    lappend records_list [list $type $kind $index]
  }

  return $records_list
}

# Create a record in a scope
proc create_record {scope_name name type kind} {
  global __symble_table_doc
  set scope [$__symble_table_doc selectNodes /scops/$scope_name]
  set record [$__symble_table_doc createElement $name]

  # get count set the index  on record and increment it on scope
  set count 0
  switch $kind {
    "static" {
      set count [$scope getAttribute static_count]
      $scope setAttribute static_count [expr $count + 1]
    }
    "field" {
      set count [$scope getAttribute field_count]
      $scope setAttribute field_count [expr $count + 1]
    }
    "argument" {
      set count [$scope getAttribute argument_count]
      $scope setAttribute argument_count [expr $count + 1]
    }
    "local" {
      set count [$scope getAttribute local_count]
      $scope setAttribute local_count [expr $count + 1]
    }
    "var" {
      set count [$scope getAttribute var_count]
      $scope setAttribute var_count [expr $count + 1]
    }
  }
  # set attributes
  $record setAttribute index $count
  $record setAttribute type $type
  $record setAttribute kind $kind

  # append record to scope
  $scope appendChild $record

  return $record
}

# Get a record from a scope in the format {type kind index}
proc get_record {scope_name name} {
  global __symble_table_doc
  # fetch the record from the scope
  set record [$__symble_table_doc selectNodes /scops/$scope_name/$name]
  # gets the attributes of the record
  set type [$record getAttribute type]
  set kind [$record getAttribute kind]
  set index [$record getAttribute index]

  return [list $type $kind $index]
}


# Dump the symble table - used for debugging
proc dump_symble_table {} {
  global __symble_table_doc
  puts "---- symble Table -----"
  puts [$__symble_table_doc asXML]
  puts "--- end ymble Table ---"
}
