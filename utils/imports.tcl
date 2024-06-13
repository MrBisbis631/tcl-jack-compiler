# This file contains the imports for all utility files, packages and modules

# packages
package require xml 3.2
package require Thread 2.8
package require Ttrace

# modules
source "[file normalize .]/vm-2-hack/vm-2-hack.tcl"
source "[file normalize .]/tokenizer/tokenizer.tcl"
source "[file normalize .]/parser/parser.tcl"
source "[file normalize .]/jack-2-vm/jack-2-vm.tcl"

#  utilities
source "[file normalize .]/utils/files.tcl"
source "[file normalize .]/utils/helpers.tcl"
source "[file normalize .]/utils/scripts.tcl"
source "[file normalize .]/utils/thread-pool.tcl"
source "[file normalize .]/utils/xml.tcl"
source "[file normalize .]/utils/tokens.tcl"
