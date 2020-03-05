## Compiler for the Dana Programming Language

### Main features of Dana

* Simple Python-like structure

* Supports integers and bytes, as well as arrays

* Pass by value or by reference

* Low level programming

* Pascal-like scope of variables and nested functions

* Static type safety

* Library of functions

### Technology used

* Flex/Bison for the AST (in C)
* LLVM for the IR code

### Dependencies

* flex
* bison
* llvm-3.9
* clang-3.9/clang++-3.9

### Build

```shell script
cd llvm
mkdir cmake-build-debug
cmake ..
make
```

### Run

```shell script
cd llvm
./dana [-indent] [-Olevel] [-i] [-f] inputfile

-indent   Offside rule trigger
-Olevel   O[0-3] optimisation flag
-i        Output LLVM code
-f        Output assembly code
```

### For the [compiler class](https://courses.softlab.ntua.gr/compilers/2017a/) of NTUA

## Authors

[Makaris Nikolaos](https://github.com/Maknikolas) - 03113108

[Mavrogeorgis Nikolaos](https://github.com/blackgeorge-boom) - 03113087
