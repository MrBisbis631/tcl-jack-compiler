### Project structure
**File Structure**

The project directory is organized as follows:

- `data/`: Contains various example directories (`ex0/`, `ex1/`, `ex2/`, `ex4/`, `ex5/`) and the `jack-stdlib/` directory which holds the standard library for the Jack language.

- `examples/`: Includes example Tcl scripts demonstrating different functionalities such as `ex0.tcl`, `inject-stdlib.tcl`, `parsed-tree-to-vm.tcl`, `parser-example.tcl`, `read-tokens.tcl`, `simple-tokenize-example.tcl`, `tclxml.tcl`, `test-file-tokenizing.tcl`, `test-parsed-to-vm.tcl`, `test-symbol-table.tcl`, `test-vm-2-hack-stack.tcl`, `test-vm-2-hack-threads.tcl`, and `thread-pool.tcl`.

- `jack-2-vm/`: Contains scripts related to converting Jack language to VM code, such as `expressions.tcl`, `jack-2-vm.tcl`, and `program-structure.tcl`.

- `packages/`: Placeholder for additional packages required by the project.

- `parser/`: Contains scripts related to parsing functionality.

- `target/`: Directory for storing generated output files.

- `tokenizer/`: Contains scripts related to tokenizing functionality.

- `tools/`: Contains utility scripts and tools for the project.

- `utils/`: Contains utility scripts, such as `files.tcl` for file operations.

- `vm-2-hack/`: Contains scripts related to converting VM code to Hack assembly language.

This file structure helps in organizing the project files and scripts based on their functionality and usage.

### TCL installation

From Ubuntu 20.04 **and not latest** versions - You can't install TclXML 3.2 on Ubuntu 22._ or 24._.
run `sudo apt install tcl-dev`, test the installation using `tclsh` command.

**note** `sudo apt install tcl` won't let you install packages.

In addition, the following packages via the command below:

```bash
sudo apt-get install -y tcllib
sudo apt-get install libxml2-dev
sudo apt-get install libxslt-dev
```

### Parsing Strategy

We use LR with RD and iteration eliminations parsing strategy, we use the `tclxml` package as the tree data structure, in every call to the next parsing rule we send the `parent` or the current `node`. In the end we return the root node of the tree.
The conversion to an xml file is done by the `xml` package.


## Packages

### TclXML 3.2

#### Description

TclXML is a package that provides XML parsing for the Tcl scripting language. It is based on the Expat XML parser, but provides a higher-level, more Tcl-friendly interface.

See documentation at `./packages/tclxml-3.2/README.html` or at https://tclxml.sourceforge.net/tclxml/3.2/README.html

#### Installation

- download the package at https://sourceforge.net/projects/tclxml/ (already done).
- extract the package using.
  ```bash
  cd ./packages/
  unzip tclxml-3.2.zip
  ```
  - **note** if you don't have unzip installed, you can install it using `sudo apt install unzip`.
- activate the package using.
  ```bash
  cd tclxml-3.2
  ./configure
  make
  sudo make install
  ```
- test the installation using `tclsh` command.
  ```tcl
  package require xml
  ```
  - **note** if you get an error, see installation docs at `./packages/tclxml-3.2/README.html`

#### Example & Usage

See `./packages/tclxml-3.2/examples/` for examples,
or `./examples/tclxml.tcl` for a simple example, and run `make xml-example` to test it.

### Thread 2.8.\*

#### Description

Thread is a package that provides a script-level implementation of threads in the Tcl scripting language. It is modelled after the Java thread model, and provides a scripting language interface to the POSIX threads (pthreads) that are available in most modern operating systems.

#### Usage

Usually you'll create a thread with `set $thread_id [thread::create]`, then you initialize it with the command `[thread::send] $thread_id $script` - `$script` is a string containing a handler and `$thread_id` is from the thread created previously, then you can send tasks to its event-loop using the commend `[thread::send] $thread_id [list handler $arg1 $arg2 ...]` `handler` is defined in `script` and `arg1 arg2 ...` are the parameters of handler `handler`.

#### Docs

See https://www.tcl-lang.org/man/tcl/ThreadCmd/thread.htm and https://wiki.tcl-lang.org/page/thread
You have an example at `./examples/test-vm-2-threads.tcl` and `./examples/thread-pool.tcl` for the use of pool.

#### Installation

run:

```bash
sudo apt-get update
sudo apt-get install tcl-thread
```

and test the installation using `tclsh` command.

```tcl
 package require Thread
```

### TDOM 0.9.1

#### Description

**Note** We didn't use this package in our project, due to conflicts with the `TclXML` package. We choose to use `TclXML` over `TDOM` because in `TlXML` you don't have to pass the `document` as a parameter to the `xml` commands.

````tcl

TDOM is a package that provides a DOM (Document Object Model) for the Tcl scripting language. It is based on the Expat XML parser, but provides a higher-level, more Tcl-friendly interface.

#### Installation

run the following commands:

```bash
sudo apt install tcllib tdom
````

#### Example & Usage

```tcl
package require tdom

# Create a new XML document with a root element
set doc [dom createDocument root]

# Access the root element
set root [$doc documentElement]

# Create a child element with attributes
set child [$doc createElement child]

# Add attributes to the child element
$child setAttribute attr1 "value1"
$child setAttribute attr2 "value2"

# Append the child element to the root element
$root appendChild $child

# Create another child element with attributes
set anotherChild [$doc createElement anotherChild]
$anotherChild setAttribute id "1234"
$anotherChild setAttribute name "example"

# Append the new child element to the root element
$root appendChild $anotherChild

# Serialize the document to a string
set xmlString [$doc asXML]

# Print the XML string
puts $xmlString
```
