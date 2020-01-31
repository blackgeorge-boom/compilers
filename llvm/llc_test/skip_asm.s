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
	leaq	8(%rsp), %rdi
	callq	bar
	movl	%eax, %edi
	callq	writeInteger
	callq	readChar
	movb	%al, 16(%rsp)
	movl	16(%rsp), %edi
	callq	writeChar
	addq	$24, %rsp
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
	movq	%rdi, -8(%rsp)
	movl	$1, %eax
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
	pushq	%rax
.Lcfi1:
	.cfi_def_cfa_offset 16
	movq	%rdi, (%rsp)
	callq	foo
	popq	%rcx
	retq
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
