#!/bin/bash

Oflag=0
file=""
asm_out=false
ir_out=false

while [[ $# -gt 0 ]];
do
    case "$1" in
        -O0)  Oflag=0;;
        -O1)  Oflag=1;;
        -O2)  Oflag=2;;
        -O3)  Oflag=3;;
        -i)   ir_out=true;;
        -f)   asm_out=true;;
        -*)   ;;
        *)    file="$1"
    esac
    shift
done

optf=""
if [[ ${Oflag} -ne 0 ]]; then
    optf=-O${Oflag}
fi

if [[ ${file} != "" ]]; then
	echo "Compiling ${file}"
	../cmake-build-debug/parser_i < ${file} 2> ir.ll || exit 1
	opt-5.0 ${optf} ir.ll -S -o ir_opt.ll
	llc-5.0 ${optf} ir_opt.ll -o a.s
	clang-5.0 a.s lib.a -o a.out
	./a.out
fi
