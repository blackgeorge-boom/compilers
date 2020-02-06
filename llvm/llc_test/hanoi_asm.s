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
	movl	$.Lstr.3, %edi
	callq	writeString
	callq	readInteger
	movl	%eax, (%rsp)
	movq	%rsp, %rdi
	movl	$.Lstr.4, %edx
	movl	$.Lstr.5, %ecx
	movl	$.Lstr.6, %r8d
	movl	%eax, %esi
	callq	hanoi
	popq	%rax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	hanoi                   # -- Begin function hanoi
	.p2align	4, 0x90
	.type	hanoi,@function
hanoi:                                  # @hanoi
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$40, %rsp
.Lcfi1:
	.cfi_def_cfa_offset 48
	movq	%rdi, (%rsp)
	movl	%esi, 8(%rsp)
	movq	%rdx, 16(%rsp)
	movq	%rcx, 24(%rsp)
	movq	%r8, 32(%rsp)
	testl	%esi, %esi
	jle	.LBB1_2
# BB#1:                                 # %then
	movq	(%rsp), %rdi
	movl	8(%rsp), %esi
	decl	%esi
	movq	16(%rsp), %rdx
	movq	32(%rsp), %rcx
	movq	24(%rsp), %r8
	callq	hanoi
	movq	16(%rsp), %rsi
	movq	24(%rsp), %rdx
	movq	%rsp, %rdi
	callq	move
	movq	(%rsp), %rdi
	movl	8(%rsp), %esi
	decl	%esi
	movq	32(%rsp), %rdx
	movq	24(%rsp), %rcx
	movq	16(%rsp), %r8
	callq	hanoi
.LBB1_2:                                # %ifcont
	addq	$40, %rsp
	retq
.Lfunc_end1:
	.size	hanoi, .Lfunc_end1-hanoi
	.cfi_endproc
                                        # -- End function
	.globl	move                    # -- Begin function move
	.p2align	4, 0x90
	.type	move,@function
move:                                   # @move
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Lcfi2:
	.cfi_def_cfa_offset 32
	movq	%rdi, (%rsp)
	movq	%rsi, 8(%rsp)
	movq	%rdx, 16(%rsp)
	movl	$.Lstr, %edi
	callq	writeString
	movq	8(%rsp), %rdi
	callq	writeString
	movl	$.Lstr.1, %edi
	callq	writeString
	movq	16(%rsp), %rdi
	callq	writeString
	movl	$.Lstr.2, %edi
	callq	writeString
	addq	$24, %rsp
	retq
.Lfunc_end2:
	.size	move, .Lfunc_end2-move
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"Moving from "
	.size	.Lstr, 13

	.type	.Lstr.1,@object         # @str.1
.Lstr.1:
	.asciz	" to "
	.size	.Lstr.1, 5

	.type	.Lstr.2,@object         # @str.2
.Lstr.2:
	.asciz	".\n"
	.size	.Lstr.2, 3

	.type	.Lstr.3,@object         # @str.3
.Lstr.3:
	.asciz	"Rings: "
	.size	.Lstr.3, 8

	.type	.Lstr.4,@object         # @str.4
.Lstr.4:
	.asciz	"left"
	.size	.Lstr.4, 5

	.type	.Lstr.5,@object         # @str.5
.Lstr.5:
	.asciz	"right"
	.size	.Lstr.5, 6

	.type	.Lstr.6,@object         # @str.6
.Lstr.6:
	.asciz	"middle"
	.size	.Lstr.6, 7


	.section	".note.GNU-stack","",@progbits
