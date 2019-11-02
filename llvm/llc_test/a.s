	.text
	.file	"dana program"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbx
.Lcfi0:
	.cfi_def_cfa_offset 16
	subq	$48, %rsp
.Lcfi1:
	.cfi_def_cfa_offset 64
.Lcfi2:
	.cfi_offset %rbx, -16
	movl	$0, 4(%rsp)
	leaq	40(%rsp), %rbx
	movl	$1, 40(%rsp)
	xorl	%edi, %edi
	callq	writeInteger
	movl	40(%rsp), %edi
	callq	writeInteger
	movq	%rsp, %rdi
	movq	%rdi, %rsi
	movq	%rbx, %rdx
	callq	loc
	movl	4(%rsp), %edi
	callq	writeInteger
	movl	40(%rsp), %edi
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	addq	$48, %rsp
	popq	%rbx
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	loc                     # -- Begin function loc
	.p2align	4, 0x90
	.type	loc,@function
loc:                                    # @loc
	.cfi_startproc
# BB#0:                                 # %entry
	movq	%rdi, -24(%rsp)
	movq	%rsi, -16(%rsp)
	movq	%rdx, -8(%rsp)
	movl	$3, (%rdx)
	movq	-16(%rsp), %rax
	movl	$5, 4(%rax)
	retq
.Lfunc_end1:
	.size	loc, .Lfunc_end1-loc
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"yoooooooooooooo"
	.size	.Lstr, 16


	.section	".note.GNU-stack","",@progbits
