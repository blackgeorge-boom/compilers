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
	subq	$48, %rsp
.Lcfi2:
	.cfi_def_cfa_offset 64
.Lcfi3:
	.cfi_offset %rbx, -16
	movq	%rdi, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdx, 24(%rsp)
	movl	%ecx, 32(%rsp)
	leaq	8(%rsp), %rbx
	movq	%rbx, %rdi
	movl	%ecx, %edx
	callq	ArraySort
	movq	24(%rsp), %rsi
	movl	32(%rsp), %edx
	movq	%rbx, %rdi
	callq	ArraySort
	movq	$0, 36(%rsp)
	jmp	.LBB1_1
	.p2align	4, 0x90
.LBB1_2:                                # %ifcont
                                        #   in Loop: Header=BB1_1 Depth=1
	movslq	40(%rsp), %rax
	movq	16(%rsp), %rcx
	movq	24(%rsp), %rdx
	movl	(%rcx,%rax,4), %ecx
	movl	32(%rsp), %esi
	subl	%eax, %esi
	decl	%esi
	movslq	%esi, %rsi
	imull	(%rdx,%rsi,4), %ecx
	addl	%ecx, 36(%rsp)
	leal	1(%rax), %eax
	movl	%eax, 40(%rsp)
.LBB1_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	40(%rsp), %eax
	cmpl	32(%rsp), %eax
	jne	.LBB1_2
# BB#3:                                 # %afterloop
	movl	36(%rsp), %eax
	addq	$48, %rsp
	popq	%rbx
	retq
.Lfunc_end1:
	.size	work, .Lfunc_end1-work
	.cfi_endproc
                                        # -- End function
	.globl	ArraySort               # -- Begin function ArraySort
	.p2align	4, 0x90
	.type	ArraySort,@function
ArraySort:                              # @ArraySort
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbx
.Lcfi4:
	.cfi_def_cfa_offset 16
	subq	$32, %rsp
.Lcfi5:
	.cfi_def_cfa_offset 48
.Lcfi6:
	.cfi_offset %rbx, -16
	movq	%rdi, (%rsp)
	movq	%rsi, 8(%rsp)
	movl	%edx, 16(%rsp)
	movq	%rsp, %rbx
	.p2align	4, 0x90
.LBB2_1:                                # %loop
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
	movb	$0, 20(%rsp)
	movl	$0, 24(%rsp)
	jmp	.LBB2_2
	.p2align	4, 0x90
.LBB2_5:                                # %ifcont
                                        #   in Loop: Header=BB2_2 Depth=2
	incl	24(%rsp)
.LBB2_2:                                # %loop1
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	16(%rsp), %eax
	decl	%eax
	cmpl	%eax, 24(%rsp)
	jge	.LBB2_6
# BB#3:                                 # %then
                                        #   in Loop: Header=BB2_2 Depth=2
	movslq	24(%rsp), %rax
	movq	8(%rsp), %rcx
	movl	(%rcx,%rax,4), %edx
	leal	1(%rax), %eax
	cltq
	cmpl	(%rcx,%rax,4), %edx
	jle	.LBB2_5
# BB#4:                                 # %then10
                                        #   in Loop: Header=BB2_2 Depth=2
	movslq	24(%rsp), %rax
	movq	8(%rsp), %rcx
	leaq	(%rcx,%rax,4), %rsi
	leal	1(%rax), %eax
	cltq
	leaq	(%rcx,%rax,4), %rdx
	movq	%rbx, %rdi
	callq	swap
	movb	$1, 20(%rsp)
	jmp	.LBB2_5
	.p2align	4, 0x90
.LBB2_6:                                # %afterloop
                                        #   in Loop: Header=BB2_1 Depth=1
	cmpb	$0, 20(%rsp)
	jne	.LBB2_1
# BB#7:                                 # %afterloop27
	addq	$32, %rsp
	popq	%rbx
	retq
.Lfunc_end2:
	.size	ArraySort, .Lfunc_end2-ArraySort
	.cfi_endproc
                                        # -- End function
	.globl	swap                    # -- Begin function swap
	.p2align	4, 0x90
	.type	swap,@function
swap:                                   # @swap
	.cfi_startproc
# BB#0:                                 # %entry
	movq	%rdi, -32(%rsp)
	movq	%rsi, -24(%rsp)
	movq	%rdx, -16(%rsp)
	movl	(%rsi), %eax
	movl	%eax, -8(%rsp)
	movl	(%rdx), %eax
	movl	%eax, (%rsi)
	movq	-16(%rsp), %rax
	movl	-8(%rsp), %ecx
	movl	%ecx, (%rax)
	retq
.Lfunc_end3:
	.size	swap, .Lfunc_end3-swap
	.cfi_endproc
                                        # -- End function
	.globl	main2                   # -- Begin function main2
	.p2align	4, 0x90
	.type	main2,@function
main2:                                  # @main2
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%r15
.Lcfi7:
	.cfi_def_cfa_offset 16
	pushq	%r14
.Lcfi8:
	.cfi_def_cfa_offset 24
	pushq	%rbx
.Lcfi9:
	.cfi_def_cfa_offset 32
	subq	$96, %rsp
.Lcfi10:
	.cfi_def_cfa_offset 128
.Lcfi11:
	.cfi_offset %rbx, -32
.Lcfi12:
	.cfi_offset %r14, -24
.Lcfi13:
	.cfi_offset %r15, -16
	movq	%rdi, (%rsp)
	callq	readInteger
	movl	%eax, 8(%rsp)
	movl	$0, 12(%rsp)
	leaq	28(%rsp), %r14
	leaq	60(%rsp), %r15
	jmp	.LBB4_1
	.p2align	4, 0x90
.LBB4_8:                                # %afterloop27
                                        #   in Loop: Header=BB4_1 Depth=1
	movq	(%rsp), %rdi
	movl	16(%rsp), %ecx
	movq	%r14, %rsi
	movq	%r15, %rdx
	callq	work
	movl	%eax, 24(%rsp)
	movl	$.Lstr, %edi
	callq	writeString
	movl	12(%rsp), %edi
	incl	%edi
	callq	writeInteger
	movl	$.Lstr.1, %edi
	callq	writeString
	movl	24(%rsp), %edi
	callq	writeInteger
	movl	$.Lstr.2, %edi
	callq	writeString
	incl	12(%rsp)
.LBB4_1:                                # %loop
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB4_3 Depth 2
                                        #     Child Loop BB4_6 Depth 2
	movl	12(%rsp), %eax
	cmpl	8(%rsp), %eax
	je	.LBB4_9
# BB#2:                                 # %ifcont
                                        #   in Loop: Header=BB4_1 Depth=1
	callq	readInteger
	movl	%eax, 16(%rsp)
	movl	$0, 20(%rsp)
	jmp	.LBB4_3
	.p2align	4, 0x90
.LBB4_4:                                # %ifcont10
                                        #   in Loop: Header=BB4_3 Depth=2
	movslq	20(%rsp), %rbx
	callq	readInteger
	movl	%eax, 28(%rsp,%rbx,4)
	incl	20(%rsp)
.LBB4_3:                                # %loop3
                                        #   Parent Loop BB4_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	20(%rsp), %eax
	cmpl	16(%rsp), %eax
	jne	.LBB4_4
# BB#5:                                 # %afterloop
                                        #   in Loop: Header=BB4_1 Depth=1
	movl	$0, 20(%rsp)
	jmp	.LBB4_6
	.p2align	4, 0x90
.LBB4_7:                                # %ifcont21
                                        #   in Loop: Header=BB4_6 Depth=2
	movslq	20(%rsp), %rbx
	callq	readInteger
	movl	%eax, 60(%rsp,%rbx,4)
	incl	20(%rsp)
.LBB4_6:                                # %loop14
                                        #   Parent Loop BB4_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	20(%rsp), %eax
	cmpl	16(%rsp), %eax
	jne	.LBB4_7
	jmp	.LBB4_8
.LBB4_9:                                # %afterloop39
	addq	$96, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
.Lfunc_end4:
	.size	main2, .Lfunc_end4-main2
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
