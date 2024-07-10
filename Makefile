run:
	tclsh main.tcl

xml-example:
	tclsh ./examples/tclxml.tcl

test-vm-2-hack-stack:
	tclsh ./examples/test-vm-2-hack-stack.tcl

thread-pool:
	tclsh ./examples/thread-pool.tcl

tokenize-simple:
	tclsh ./examples/simple-tokenize-example.tcl

file-tokenizing:
	tclsh ./examples/test-file-tokenizing.tcl

read-tokens:
	tclsh ./examples/read-tokens.tcl

inject-stdlib:
	tclsh ./examples/inject-stdlib.tcl

test-parsed-to-vm:
	tclsh ./examples/test-parsed-to-vm.tcl

test-tymble-table:
	tclsh ./examples/test-symble-table.tcl

# Exeersises

ex0:
	tclsh ./examples/ex0.tcl

ex1: test-vm-2-hack-stack

ex2:
	-@echo "Choose directory to transpile:"
	-@ls data/ex2 | awk '{print "  " NR ": " $$0}'
	-@read -p "Enter number: " dir_number; \
		dir=$$(ls data/ex2 | sed -n "$$dir_number p"); \
		if [ -z "$$dir" ]; then echo "Invalid choice"; exit 1; fi; \
		echo "You chose: $$dir"; \
		tclsh ./examples/test-vm-2-hack-threads.tcl $$dir

ex4.1: 
	-@echo "Choose directory to transpile:"
	-@ls data/ex4 | awk '{print "  " NR ": " $$0}'
	-@read -p "Enter number: " dir_number; \
		dir=$$(ls data/ex4 | sed -n "$$dir_number p"); \
		if [ -z "$$dir" ]; then echo "Invalid choice"; exit 1; fi; \
		echo "You chose: $$dir"; \
		tclsh ./examples/test-file-tokenizing.tcl $$dir

ex4.2: 
	-@echo "Choose directory to parse:"
	-@ls data/ex4 | awk '{print "  " NR ": " $$0}'
	-@read -p "Enter number: " dir_number; \
		dir=$$(ls data/ex4 | sed -n "$$dir_number p"); \
		if [ -z "$$dir" ]; then echo "Invalid choice"; exit 1; fi; \
		echo "You chose: $$dir"; \
		tclsh ./examples/parser-example.tcl $$dir

ex5: 
	-@echo "Choose directory to compile:"
	-@ls data/ex5 | awk '{print "  " NR ": " $$0}'
	-@read -p "Enter number: " dir_number; \
		dir=$$(ls data/ex5 | sed -n "$$dir_number p"); \
		if [ -z "$$dir" ]; then echo "Invalid choice"; exit 1; fi; \
		echo "You chose: $$dir"; \
		tclsh ./examples/parsed-tree-to-vm.tcl $$dir
