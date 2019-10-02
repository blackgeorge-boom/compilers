	.text
	.file	"dana program"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$40, %rsp
.Lcfi0:
	.cfi_def_cfa_offset 48
	movl	$2, (%rsp)
	movl	$2, %edi
	callq	writeInteger
	movq	%rsp, %rdi
	callq	hello
	movl	(%rsp), %edi
	callq	writeInteger
	addq	$40, %rsp
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
	movl	$1, (%rdi)
	retq
.Lfunc_end1:
	.size	hello, .Lfunc_end1-hello
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
