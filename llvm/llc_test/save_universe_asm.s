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
	callq	main2
	popq	%rax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	work                    # -- Begin function work
	.p2align	4, 0x90
	.type	work,@function
work:                                   # @work
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbx
.Lcfi1:
	.cfi_def_cfa_offset 16
	subq	$64, %rsp
.Lcfi2:
	.cfi_def_cfa_offset 80
.Lcfi3:
	.cfi_offset %rbx, -16
	movq	%rdi, (%rsp)
	movq	%rsi, 8(%rsp)
	movl	%edx, 16(%rsp)
	movq	%rcx, 24(%rsp)
	movl	%r8d, 32(%rsp)
	movl	$-1, 40(%rsp)
	movq	$0, 48(%rsp)
	movq	%rsp, %rbx
	jmp	.LBB1_1
	.p2align	4, 0x90
.LBB1_9:                                # %afterloop
                                        #   in Loop: Header=BB1_1 Depth=1
	movl	40(%rsp), %eax
	movl	%eax, 48(%rsp)
	incl	52(%rsp)
.LBB1_1:                                # %loop
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
	movl	40(%rsp), %eax
	cmpl	32(%rsp), %eax
	jg	.LBB1_10
# BB#2:                                 # %ifcont
                                        #   in Loop: Header=BB1_1 Depth=1
	movl	$-1, 44(%rsp)
	movl	$0, 56(%rsp)
	jmp	.LBB1_3
	.p2align	4, 0x90
.LBB1_8:                                # %ifcont30
                                        #   in Loop: Header=BB1_3 Depth=2
	incl	56(%rsp)
.LBB1_3:                                # %loop3
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	56(%rsp), %eax
	cmpl	16(%rsp), %eax
	je	.LBB1_9
# BB#4:                                 # %ifcont9
                                        #   in Loop: Header=BB1_3 Depth=2
	movq	24(%rsp), %rsi
	movl	32(%rsp), %edx
	movslq	56(%rsp), %rax
	imulq	$101, %rax, %rcx
	addq	8(%rsp), %rcx
	movl	48(%rsp), %r8d
	movq	%rbx, %rdi
	callq	ArrayIndexOf
	movl	%eax, 36(%rsp)
	cmpl	$-1, %eax
	jne	.LBB1_6
# BB#5:                                 # %then18
                                        #   in Loop: Header=BB1_3 Depth=2
	movl	32(%rsp), %eax
	incl	%eax
	movl	%eax, 36(%rsp)
.LBB1_6:                                # %ifcont21
                                        #   in Loop: Header=BB1_3 Depth=2
	movl	36(%rsp), %eax
	cmpl	40(%rsp), %eax
	jle	.LBB1_8
# BB#7:                                 # %then26
                                        #   in Loop: Header=BB1_3 Depth=2
	movl	36(%rsp), %eax
	movl	56(%rsp), %ecx
	movl	%eax, 40(%rsp)
	movl	%ecx, 44(%rsp)
	jmp	.LBB1_8
.LBB1_10:                               # %afterloop36
	movl	52(%rsp), %eax
	decl	%eax
	addq	$64, %rsp
	popq	%rbx
	retq
.Lfunc_end1:
	.size	work, .Lfunc_end1-work
	.cfi_endproc
                                        # -- End function
	.globl	ArrayIndexOf            # -- Begin function ArrayIndexOf
	.p2align	4, 0x90
	.type	ArrayIndexOf,@function
ArrayIndexOf:                           # @ArrayIndexOf
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$56, %rsp
.Lcfi4:
	.cfi_def_cfa_offset 64
	movq	%rdi, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movl	%edx, 24(%rsp)
	movq	%rcx, 32(%rsp)
	movl	%r8d, 40(%rsp)
	movl	%r8d, 44(%rsp)
	jmp	.LBB2_1
	.p2align	4, 0x90
.LBB2_3:                                # %ifcont12
                                        #   in Loop: Header=BB2_1 Depth=1
	incl	44(%rsp)
.LBB2_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	44(%rsp), %eax
	cmpl	24(%rsp), %eax
	je	.LBB2_4
# BB#2:                                 # %ifcont
                                        #   in Loop: Header=BB2_1 Depth=1
	movslq	44(%rsp), %rax
	imulq	$101, %rax, %rdi
	addq	16(%rsp), %rdi
	movq	32(%rsp), %rsi
	callq	strcmp
	testl	%eax, %eax
	jne	.LBB2_3
# BB#5:                                 # %then9
	movl	44(%rsp), %eax
	addq	$56, %rsp
	retq
.LBB2_4:                                # %then
	movl	$-1, %eax
	addq	$56, %rsp
	retq
.Lfunc_end2:
	.size	ArrayIndexOf, .Lfunc_end2-ArrayIndexOf
	.cfi_endproc
                                        # -- End function
	.globl	main2                   # -- Begin function main2
	.p2align	4, 0x90
	.type	main2,@function
main2:                                  # @main2
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%r14
.Lcfi5:
	.cfi_def_cfa_offset 16
	pushq	%rbx
.Lcfi6:
	.cfi_def_cfa_offset 24
	subq	$111144, %rsp           # imm = 0x1B228
.Lcfi7:
	.cfi_def_cfa_offset 111168
.Lcfi8:
	.cfi_offset %rbx, -24
.Lcfi9:
	.cfi_offset %r14, -16
	movq	%rdi, 8(%rsp)
	callq	readInteger
	movl	%eax, 16(%rsp)
	movl	$0, 20(%rsp)
	leaq	40(%rsp), %r14
	leaq	10140(%rsp), %rbx
	jmp	.LBB3_1
	.p2align	4, 0x90
.LBB3_8:                                # %afterloop28
                                        #   in Loop: Header=BB3_1 Depth=1
	movq	8(%rsp), %rdi
	movl	24(%rsp), %edx
	movl	32(%rsp), %r8d
	movq	%r14, %rsi
	movq	%rbx, %rcx
	callq	work
	movl	%eax, 36(%rsp)
	movl	$.Lstr, %edi
	callq	writeString
	movl	20(%rsp), %edi
	incl	%edi
	callq	writeInteger
	movl	$.Lstr.1, %edi
	callq	writeString
	movl	36(%rsp), %edi
	callq	writeInteger
	movl	$.Lstr.2, %edi
	callq	writeString
	incl	20(%rsp)
.LBB3_1:                                # %loop
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_3 Depth 2
                                        #     Child Loop BB3_6 Depth 2
	movl	20(%rsp), %eax
	cmpl	16(%rsp), %eax
	je	.LBB3_9
# BB#2:                                 # %ifcont
                                        #   in Loop: Header=BB3_1 Depth=1
	callq	readInteger
	movl	%eax, 24(%rsp)
	movl	$0, 28(%rsp)
	jmp	.LBB3_3
	.p2align	4, 0x90
.LBB3_4:                                # %ifcont10
                                        #   in Loop: Header=BB3_3 Depth=2
	movslq	28(%rsp), %rax
	imulq	$101, %rax, %rax
	leaq	40(%rsp,%rax), %rsi
	movl	$101, %edi
	callq	readString
	incl	28(%rsp)
.LBB3_3:                                # %loop3
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	28(%rsp), %eax
	cmpl	24(%rsp), %eax
	jne	.LBB3_4
# BB#5:                                 # %afterloop
                                        #   in Loop: Header=BB3_1 Depth=1
	callq	readInteger
	movl	%eax, 32(%rsp)
	movl	$0, 28(%rsp)
	jmp	.LBB3_6
	.p2align	4, 0x90
.LBB3_7:                                # %ifcont22
                                        #   in Loop: Header=BB3_6 Depth=2
	movslq	28(%rsp), %rax
	imulq	$101, %rax, %rax
	leaq	10140(%rsp,%rax), %rsi
	movl	$101, %edi
	callq	readString
	incl	28(%rsp)
.LBB3_6:                                # %loop15
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	28(%rsp), %eax
	cmpl	32(%rsp), %eax
	jne	.LBB3_7
	jmp	.LBB3_8
.LBB3_9:                                # %afterloop41
	addq	$111144, %rsp           # imm = 0x1B228
	popq	%rbx
	popq	%r14
	retq
.Lfunc_end3:
	.size	main2, .Lfunc_end3-main2
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"Case #"
	.size	.Lstr, 7

	.type	.Lstr.1,@object         # @str.1
.Lstr.1:
	.asciz	": "
	.size	.Lstr.1, 3

	.type	.Lstr.2,@object         # @str.2
.Lstr.2:
	.asciz	"\n"
	.size	.Lstr.2, 2


	.section	".note.GNU-stack","",@progbits
