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
	movq	%rsp, %rdi
	movl	$100, %esi
	callq	fact
	movl	%eax, %edi
	callq	writeInteger
	popq	%rax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	fact                    # -- Begin function fact
	.p2align	4, 0x90
	.type	fact,@function
fact:                                   # @fact
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbx
.Lcfi1:
	.cfi_def_cfa_offset 16
	subq	$16, %rsp
.Lcfi2:
	.cfi_def_cfa_offset 32
.Lcfi3:
	.cfi_offset %rbx, -16
	movq	%rdi, (%rsp)
	movl	%esi, 8(%rsp)
	cmpl	$1, %esi
	jne	.LBB1_3
# BB#1:                                 # %then
	movl	$1, %eax
	jmp	.LBB1_2
.LBB1_3:                                # %else
	movl	8(%rsp), %ebx
	movq	(%rsp), %rdi
	leal	-1(%rbx), %esi
	callq	fact
	imull	%ebx, %eax
.LBB1_2:                                # %then
	addq	$16, %rsp
	popq	%rbx
	retq
.Lfunc_end1:
	.size	fact, .Lfunc_end1-fact
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
