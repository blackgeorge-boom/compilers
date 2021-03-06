#!/bin/bash

Oflag=0
file=""
indent_flag=false
asm_out=false
ir_out=false

while [[ $# -gt 0 ]];
do
    case "$1" in
        -O0)  Oflag=0;;
        -O1)  Oflag=1;;
        -O2)  Oflag=2;;
        -O3)  Oflag=3;;
        -indent) indent_flag=true;;
        -i)   ir_out=true;;
        -f)   asm_out=true;;
        -*)   ;;
        *)    file="$1"
    esac
    shift
done

compiler=dana_compiler
if [[ ${indent_flag} = true ]]; then
    compiler=dana_compiler_indent
fi

opt_flag=""
if [[ ${Oflag} -ne 0 ]]; then
    opt_flag=-O${Oflag}
fi

if [[ ${file} != "" ]]; then

	echo "Compiling ${file}"

    t=${file%.*}
    name=${t##*/}

	echo "Compiling ${name}"

	../cmake-build-debug/${compiler} < ${file} 2> "${name}"_ir.ll || exit 1
	opt-3.9 ${opt_flag} "${name}"_ir.ll -S -o ${name}_ir_opt.ll
	llc-3.9 ${opt_flag} "${name}"_ir_opt.ll -o ${name}_asm.s
	clang-3.9 -Wall -Wextra -Werror "${name}"_asm.s lib.a our_libs.a -o ${name}.out -ll

    if [[ ${ir_out} = true ]]; then
        cat "${name}"_ir_opt.ll
    fi

    if [[ ${asm_out} = true ]]; then
        cat ${name}_asm.s
    fi

    rm ${name}_ir.ll
    rm ${name}_ir_opt.ll
    rm ${name}_asm.s

	./${name}.out
fi
