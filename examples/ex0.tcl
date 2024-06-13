source "[file normalize .]/utils/imports.tcl"

set input_files_path "data/ex0"
set output_dir "ex0"
set output_file_path "$output_dir/ex0.asm"

set dolars "\$\$\$"

set total_buy 0
set total_sall 0

proc handle_bay {product_name amaunt price} {
  global total_buy dolars
  set current_price [expr $amaunt*$price]
  set total_buy [expr $total_buy + $current_price]
  return "$dolars BUY $product_name $dolars\n[format "%.1f" $current_price]"
}

proc handle_sall {product_name amaunt price} {
  global total_sall
  set current_price [expr $amaunt * $price]
  set total_sall [expr $total_sall + $current_price]
  return "### BUY $product_name ###\n[format "%.1f" $current_price]"
}

proc handle_total {} {
  global total_buy total_sall
  return "TOTAL BUY: [format "%.1f" $total_buy]\nTOTAL SALL: [format "%.1f" $total_sall]"
}

set input_files [get_files_name_by_extention $input_files_path ".vm"]
set o_fd [open [get_target_dir $output_file_path] a]

try {
  foreach file_name $input_files {
    puts $o_fd "[string range [file tail $file_name] 0 [expr {[string last "." [file tail $file_name]] - 1}]]"
    for {set line [coroutine line_generator generate_lines $file_name]} {$line != "\0"} {set line [line_generator]} {
      set line_items [split $line " "]
      if {[lindex $line_items 0] == "buy"} {
        puts $o_fd [handle_bay [lindex $line_items 1] [lindex $line_items 2] [lindex $line_items 3]]
      } elseif {[lindex $line_items 0] == "cell"} {
        puts $o_fd [handle_sall [lindex $line_items 1] [lindex $line_items 2] [lindex $line_items 3]]
      }
    }
    puts $o_fd [handle_total]
    set total_buy 0
    set total_sall 0  
  }
} finally {
  close $o_fd
}
