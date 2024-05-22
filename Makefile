run:
	tclsh main.tcl

xml-example:
	tclsh ./tcl-examples/tclxml.tcl

test-vm-2-hack-stack:
	tclsh ./tcl-examples/test-vm-2-hack-stack.tcl

# Exeersises

ex0:
	tclsh ./tcl-examples/ex0.tcl

ex1: test-vm-2-hack-stack

ex2:
	-@echo "Choose directory to transpile:"
	-@ls data/ex2 | awk '{print "  " NR ": " $$0}'
	-@read -p "Enter number: " dir_number; \
		dir=$$(ls data/ex2 | sed -n "$$dir_number p"); \
		if [ -z "$$dir" ]; then echo "Invalid choice"; exit 1; fi; \
		echo "You chose: $$dir"; \
		tclsh ./tcl-examples/test-vm-2-hack-threads.tcl $$dir
