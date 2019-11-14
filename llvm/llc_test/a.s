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
	movl	$.Lstr, %edi
	callq	writeString
	callq	readInteger
	movl	%eax, (%rsp)
	movl	$.Lstr.5, %edi
	callq	writeString
	movl	$0, 8(%rsp)
	cmpl	$2, (%rsp)
	jl	.LBB0_2
# BB#1:                                 # %then
	incl	8(%rsp)
	movl	$2, %edi
	callq	writeInteger
	movl	$.Lstr.6, %edi
	callq	writeString
.LBB0_2:                                # %ifcont
	cmpl	$3, (%rsp)
	jl	.LBB0_4
# BB#3:                                 # %then7
	incl	8(%rsp)
	movl	$3, %edi
	callq	writeInteger
	movl	$.Lstr.7, %edi
	callq	writeString
.LBB0_4:                                # %ifcont12
	movl	$5, 4(%rsp)
	movq	%rsp, %rbx
	jmp	.LBB0_5
	.p2align	4, 0x90
.LBB0_11:                               # %ifcont44
                                        #   in Loop: Header=BB0_5 Depth=1
	addl	$4, 4(%rsp)
.LBB0_5:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	4(%rsp), %eax
	cmpl	(%rsp), %eax
	jg	.LBB0_12
# BB#6:                                 # %elif17
                                        #   in Loop: Header=BB0_5 Depth=1
	movl	4(%rsp), %esi
	movq	%rbx, %rdi
	callq	prime
	testb	%al, %al
	je	.LBB0_8
# BB#7:                                 # %elifthen
                                        #   in Loop: Header=BB0_5 Depth=1
	incl	8(%rsp)
	movl	4(%rsp), %edi
	callq	writeInteger
	movl	$.Lstr.8, %edi
	callq	writeString
.LBB0_8:                                # %ifcont25
                                        #   in Loop: Header=BB0_5 Depth=1
	movl	4(%rsp), %eax
	addl	$2, %eax
	movl	%eax, 4(%rsp)
	cmpl	(%rsp), %eax
	jg	.LBB0_12
# BB#9:                                 # %elif33
                                        #   in Loop: Header=BB0_5 Depth=1
	movl	4(%rsp), %esi
	movq	%rbx, %rdi
	callq	prime
	testb	%al, %al
	je	.LBB0_11
# BB#10:                                # %elifthen37
                                        #   in Loop: Header=BB0_5 Depth=1
	incl	8(%rsp)
	movl	4(%rsp), %edi
	callq	writeInteger
	movl	$.Lstr.9, %edi
	callq	writeString
	jmp	.LBB0_11
.LBB0_12:                               # %afterloop
	movl	$.Lstr.10, %edi
	callq	writeString
	movl	8(%rsp), %edi
	callq	writeInteger
	movl	$.Lstr.11, %edi
	callq	writeString
	addq	$16, %rsp
	popq	%rbx
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	prime                   # -- Begin function prime
	.p2align	4, 0x90
	.type	prime,@function
prime:                                  # @prime
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Lcfi3:
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	movl	%esi, 16(%rsp)
	testl	%esi, %esi
	jns	.LBB1_1
# BB#8:                                 # %then
	movq	8(%rsp), %rdi
	xorl	%esi, %esi
	subl	16(%rsp), %esi
	callq	prime
	addq	$24, %rsp
	retq
.LBB1_1:                                # %elif
	cmpl	$1, 16(%rsp)
	jg	.LBB1_2
.LBB1_9:                                # %elifthen
	xorl	%eax, %eax
	addq	$24, %rsp
	retq
.LBB1_2:                                # %elif4
	cmpl	$2, 16(%rsp)
	jne	.LBB1_3
.LBB1_10:                               # %elifthen7
	movb	$1, %al
	addq	$24, %rsp
	retq
.LBB1_3:                                # %elif8
	movl	16(%rsp), %eax
	movl	%eax, %ecx
	shrl	$31, %ecx
	addl	%eax, %ecx
	andl	$-2, %ecx
	cmpl	%ecx, %eax
	je	.LBB1_9
# BB#4:                                 # %else
	movl	$3, 20(%rsp)
	jmp	.LBB1_5
	.p2align	4, 0x90
.LBB1_7:                                # %ifcont
                                        #   in Loop: Header=BB1_5 Depth=1
	addl	$2, 20(%rsp)
.LBB1_5:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	16(%rsp), %eax
	movl	%eax, %ecx
	shrl	$31, %ecx
	addl	%eax, %ecx
	sarl	%ecx
	cmpl	%ecx, 20(%rsp)
	jg	.LBB1_10
# BB#6:                                 # %elif20
                                        #   in Loop: Header=BB1_5 Depth=1
	movl	16(%rsp), %eax
	cltd
	idivl	20(%rsp)
	testl	%edx, %edx
	jne	.LBB1_7
	jmp	.LBB1_9
.Lfunc_end1:
	.size	prime, .Lfunc_end1-prime
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"Limit: "
	.size	.Lstr, 8

	.type	.Lstr.5,@object         # @str.5
.Lstr.5:
	.asciz	"Primes:\n"
	.size	.Lstr.5, 9

	.type	.Lstr.6,@object         # @str.6
.Lstr.6:
	.asciz	"\n"
	.size	.Lstr.6, 2

	.type	.Lstr.7,@object         # @str.7
.Lstr.7:
	.asciz	"\n"
	.size	.Lstr.7, 2

	.type	.Lstr.8,@object         # @str.8
.Lstr.8:
	.asciz	"\n"
	.size	.Lstr.8, 2

	.type	.Lstr.9,@object         # @str.9
.Lstr.9:
	.asciz	"\n"
	.size	.Lstr.9, 2

	.type	.Lstr.10,@object        # @str.10
.Lstr.10:
	.asciz	"\nTotal: "
	.size	.Lstr.10, 9

	.type	.Lstr.11,@object        # @str.11
.Lstr.11:
	.asciz	"\n"
	.size	.Lstr.11, 2


	.section	".note.GNU-stack","",@progbits
