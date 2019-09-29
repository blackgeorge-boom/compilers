	.text
	.file	"dana program"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rax
.Lcfi0:
	.cfi_def_cfa_offset 16
	movl	$2, %edi
	callq	hello
	movl	$-1, %edi
	callq	hello
	movl	$1, %edi
	callq	hello
	popq	%rax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	hello                   # -- Begin function hello
	.p2align	4, 0x90
	.type	hello,@function
hello:                                  # @hello
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rax
.Lcfi1:
	.cfi_def_cfa_offset 16
	movl	%edi, 4(%rsp)
	callq	writeInteger
	cmpl	$-1, 4(%rsp)
	jne	.LBB1_2
# BB#1:                                 # %then
	movzbl	.Lstr+3(%rip), %edi
	jmp	.LBB1_3
.LBB1_2:                                # %else
	movl	$99, %edi
.LBB1_3:                                # %ifcont
	callq	writeChar
	popq	%rax
	retq
.Lfunc_end1:
	.size	hello, .Lfunc_end1-hello
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"abc\\n"
	.size	.Lstr, 6


	.section	".note.GNU-stack","",@progbits
