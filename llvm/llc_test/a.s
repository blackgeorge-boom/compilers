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
	subq	$16, %rsp
.Lcfi1:
	.cfi_def_cfa_offset 32
.Lcfi2:
	.cfi_offset %rbx, -16
	leaq	8(%rsp), %rbx
	movl	$3, %esi
	movq	%rbx, %rdi
	callq	foo
	movl	$5, %esi
	movq	%rbx, %rdi
	callq	bar
	movl	8(%rsp), %edi
	callq	writeInteger
	addq	$16, %rsp
	popq	%rbx
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	foo                     # -- Begin function foo
	.p2align	4, 0x90
	.type	foo,@function
foo:                                    # @foo
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Lcfi3:
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	movl	%esi, 16(%rsp)
	movl	%esi, %edi
	callq	writeInteger
	movq	8(%rsp), %rdi
	movl	$1, %esi
	callq	bar
	addq	$24, %rsp
	retq
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
	.cfi_endproc
                                        # -- End function
	.globl	bar                     # -- Begin function bar
	.p2align	4, 0x90
	.type	bar,@function
bar:                                    # @bar
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Lcfi4:
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	movl	%esi, 16(%rsp)
	movl	$9, (%rdi)
	movq	8(%rsp), %rdi
	movl	16(%rsp), %esi
	callq	foo
	addq	$24, %rsp
	retq
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
