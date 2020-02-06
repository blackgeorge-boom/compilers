	.text
	.file	"dana program"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%r14
.Lcfi0:
	.cfi_def_cfa_offset 16
	pushq	%rbx
.Lcfi1:
	.cfi_def_cfa_offset 24
	subq	$72, %rsp
.Lcfi2:
	.cfi_def_cfa_offset 96
.Lcfi3:
	.cfi_offset %rbx, -24
.Lcfi4:
	.cfi_offset %r14, -16
	movq	$65, (%rsp)
	cmpl	$15, 4(%rsp)
	jg	.LBB0_3
	.p2align	4, 0x90
.LBB0_2:                                # %then
                                        # =>This Inner Loop Header: Depth=1
	imull	$137, (%rsp), %eax
	movl	4(%rsp), %ecx
	leal	220(%rax,%rcx), %eax
	cltq
	imulq	$680390859, %rax, %rcx  # imm = 0x288DF0CB
	movq	%rcx, %rdx
	shrq	$63, %rdx
	sarq	$36, %rcx
	addl	%edx, %ecx
	imull	$101, %ecx, %ecx
	subl	%ecx, %eax
	movl	%eax, (%rsp)
	movslq	4(%rsp), %rcx
	movl	%eax, 8(%rsp,%rcx,4)
	incl	4(%rsp)
	cmpl	$15, 4(%rsp)
	jle	.LBB0_2
.LBB0_3:                                # %afterloop
	leaq	8(%rsp), %r14
	movq	%rsp, %rbx
	movl	$.Lstr.2, %esi
	movl	$16, %edx
	movq	%rbx, %rdi
	movq	%r14, %rcx
	callq	writeArray
	movl	$16, %esi
	movq	%rbx, %rdi
	movq	%r14, %rdx
	callq	bsort
	movl	$.Lstr.3, %esi
	movl	$16, %edx
	movq	%rbx, %rdi
	movq	%r14, %rcx
	callq	writeArray
	addq	$72, %rsp
	popq	%rbx
	popq	%r14
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	bsort                   # -- Begin function bsort
	.p2align	4, 0x90
	.type	bsort,@function
bsort:                                  # @bsort
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbx
.Lcfi5:
	.cfi_def_cfa_offset 16
	subq	$32, %rsp
.Lcfi6:
	.cfi_def_cfa_offset 48
.Lcfi7:
	.cfi_offset %rbx, -16
	movq	%rdi, (%rsp)
	movl	%esi, 8(%rsp)
	movq	%rdx, 16(%rsp)
	movq	%rsp, %rbx
	.p2align	4, 0x90
.LBB1_1:                                # %loop
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	movb	$0, 24(%rsp)
	movl	$0, 28(%rsp)
	jmp	.LBB1_2
	.p2align	4, 0x90
.LBB1_5:                                # %ifcont
                                        #   in Loop: Header=BB1_2 Depth=2
	incl	28(%rsp)
.LBB1_2:                                # %loop1
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	8(%rsp), %eax
	decl	%eax
	cmpl	%eax, 28(%rsp)
	jge	.LBB1_6
# BB#3:                                 # %then
                                        #   in Loop: Header=BB1_2 Depth=2
	movslq	28(%rsp), %rax
	movq	16(%rsp), %rcx
	movl	(%rcx,%rax,4), %edx
	leal	1(%rax), %eax
	cltq
	cmpl	(%rcx,%rax,4), %edx
	jle	.LBB1_5
# BB#4:                                 # %then10
                                        #   in Loop: Header=BB1_2 Depth=2
	movslq	28(%rsp), %rax
	movq	16(%rsp), %rcx
	leaq	(%rcx,%rax,4), %rsi
	leal	1(%rax), %eax
	cltq
	leaq	(%rcx,%rax,4), %rdx
	movq	%rbx, %rdi
	callq	swap
	movb	$1, 24(%rsp)
	jmp	.LBB1_5
	.p2align	4, 0x90
.LBB1_6:                                # %afterloop
                                        #   in Loop: Header=BB1_1 Depth=1
	cmpb	$0, 24(%rsp)
	jne	.LBB1_1
# BB#7:                                 # %afterloop27
	addq	$32, %rsp
	popq	%rbx
	retq
.Lfunc_end1:
	.size	bsort, .Lfunc_end1-bsort
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
.Lfunc_end2:
	.size	swap, .Lfunc_end2-swap
	.cfi_endproc
                                        # -- End function
	.globl	writeArray              # -- Begin function writeArray
	.p2align	4, 0x90
	.type	writeArray,@function
writeArray:                             # @writeArray
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$40, %rsp
.Lcfi8:
	.cfi_def_cfa_offset 48
	movq	%rdi, (%rsp)
	movq	%rsi, 8(%rsp)
	movl	%edx, 16(%rsp)
	movq	%rcx, 24(%rsp)
	movq	%rsi, %rdi
	callq	writeString
	movl	$0, 32(%rsp)
	jmp	.LBB3_1
	.p2align	4, 0x90
.LBB3_4:                                # %ifcont
                                        #   in Loop: Header=BB3_1 Depth=1
	movq	24(%rsp), %rax
	movslq	32(%rsp), %rcx
	movl	(%rax,%rcx,4), %edi
	callq	writeInteger
	incl	32(%rsp)
.LBB3_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	32(%rsp), %eax
	cmpl	16(%rsp), %eax
	jge	.LBB3_5
# BB#2:                                 # %then
                                        #   in Loop: Header=BB3_1 Depth=1
	cmpl	$0, 32(%rsp)
	jle	.LBB3_4
# BB#3:                                 # %then5
                                        #   in Loop: Header=BB3_1 Depth=1
	movl	$.Lstr, %edi
	callq	writeString
	jmp	.LBB3_4
.LBB3_5:                                # %afterloop
	movl	$.Lstr.1, %edi
	callq	writeString
	addq	$40, %rsp
	retq
.Lfunc_end3:
	.size	writeArray, .Lfunc_end3-writeArray
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	", "
	.size	.Lstr, 3

	.type	.Lstr.1,@object         # @str.1
.Lstr.1:
	.asciz	"\n"
	.size	.Lstr.1, 2

	.type	.Lstr.2,@object         # @str.2
.Lstr.2:
	.asciz	"Initial array: "
	.size	.Lstr.2, 16

	.type	.Lstr.3,@object         # @str.3
.Lstr.3:
	.asciz	"Sorted array: "
	.size	.Lstr.3, 15


	.section	".note.GNU-stack","",@progbits
