	.text
	.file	"dana program"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Lcfi0:
	.cfi_def_cfa_offset 32
	movl	$0, 12(%rsp)
	xorl	%edi, %edi
	callq	writeInteger
	leaq	16(%rsp), %rdi
	leaq	12(%rsp), %rdx
	movl	$3, %esi
	callq	loc
	movl	12(%rsp), %edi
	callq	writeInteger
	addq	$24, %rsp
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
	movl	%esi, -28(%rsp)
	movl	$1, (%rdx)
	retq
.Lfunc_end1:
	.size	loc, .Lfunc_end1-loc
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
