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
	movl	$0, 44(%rsp)
	movabsq	$17179869850, %rax      # imm = 0x40000029A
	movq	%rax, 4(%rsp)
	movl	12(%rsp), %edx
	movl	16(%rsp), %ecx
	movl	20(%rsp), %r8d
	movl	24(%rsp), %r9d
	movl	28(%rsp), %r10d
	movl	32(%rsp), %r11d
	movl	36(%rsp), %eax
	movl	40(%rsp), %ebx
	movl	$666, %edi              # imm = 0x29A
	movl	$4, %esi
	pushq	%rbx
.Lcfi3:
	.cfi_adjust_cfa_offset 8
	pushq	%rax
.Lcfi4:
	.cfi_adjust_cfa_offset 8
	pushq	%r11
.Lcfi5:
	.cfi_adjust_cfa_offset 8
	pushq	%r10
.Lcfi6:
	.cfi_adjust_cfa_offset 8
	callq	hello
	addq	$32, %rsp
.Lcfi7:
	.cfi_adjust_cfa_offset -32
	movl	8(%rsp), %edi
	callq	writeInteger
	addq	$48, %rsp
	popq	%rbx
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
	subq	$40, %rsp
.Lcfi8:
	.cfi_def_cfa_offset 48
	movl	48(%rsp), %r10d
	movl	56(%rsp), %r11d
	movl	64(%rsp), %eax
	movl	72(%rsp), %esi
	movl	%esi, 36(%rsp)
	movl	%eax, 32(%rsp)
	movl	%r11d, 28(%rsp)
	movl	%r10d, 24(%rsp)
	movl	%r9d, 20(%rsp)
	movl	%r8d, 16(%rsp)
	movl	%ecx, 12(%rsp)
	movl	%edx, 8(%rsp)
	movl	%edi, (%rsp)
	movl	$1, 4(%rsp)
	callq	writeInteger
	addq	$40, %rsp
	retq
.Lfunc_end1:
	.size	hello, .Lfunc_end1-hello
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
