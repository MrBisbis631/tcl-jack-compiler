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
or `./tcl-examples/tclxml.tcl` for a simple example, and run `make xml-example` to test it.

### Thread 2.8.\*

#### Description

Thread is a package that provides a script-level implementation of threads in the Tcl scripting language. It is modelled after the Java thread model, and provides a scripting language interface to the POSIX threads (pthreads) that are available in most modern operating systems.

#### Docs

See https://www.tcl-lang.org/man/tcl/ThreadCmd/thread.htm and https://wiki.tcl-lang.org/page/thread
You have an example at `./tcl-examples/thread.tcl` as well.

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
