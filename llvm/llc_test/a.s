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
	subq	$80, %rsp
.Lcfi1:
	.cfi_def_cfa_offset 96
.Lcfi2:
	.cfi_offset %rbx, -16
	movl	$.Lstr.18, %edi
	callq	writeString
	movq	%rsp, %rbx
	movl	$80, %edi
	movq	%rbx, %rsi
	callq	readString
	movl	$.Lstr.19, %esi
	movq	%rbx, %rdi
	callq	strcmp
	testl	%eax, %eax
	je	.LBB0_3
# BB#1:                                 # %ifcont.preheader
	movq	%rsp, %rbx
	.p2align	4, 0x90
.LBB0_2:                                # %ifcont
                                        # =>This Inner Loop Header: Depth=1
	movq	%rbx, %rsi
	callq	printBoxed
	movl	$.Lstr.18, %edi
	callq	writeString
	movl	$80, %edi
	movq	%rbx, %rsi
	callq	readString
	movl	$.Lstr.19, %esi
	movq	%rbx, %rdi
	callq	strcmp
	testl	%eax, %eax
	jne	.LBB0_2
.LBB0_3:                                # %afterloop
	addq	$80, %rsp
	popq	%rbx
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	printBoxed              # -- Begin function printBoxed
	.p2align	4, 0x90
	.type	printBoxed,@function
printBoxed:                             # @printBoxed
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbp
.Lcfi3:
	.cfi_def_cfa_offset 16
	pushq	%r14
.Lcfi4:
	.cfi_def_cfa_offset 24
	pushq	%rbx
.Lcfi5:
	.cfi_def_cfa_offset 32
.Lcfi6:
	.cfi_offset %rbx, -32
.Lcfi7:
	.cfi_offset %r14, -24
.Lcfi8:
	.cfi_offset %rbp, -16
	movq	%rsi, %r14
	movq	%r14, %rdi
	callq	strlen
	movl	%eax, %ebp
	movl	$.Lstr, %edi
	callq	writeString
	xorl	%ebx, %ebx
	.p2align	4, 0x90
.LBB1_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	$.Lstr.16, %edi
	callq	writeString
	incl	%ebx
	cmpl	%ebp, %ebx
	jl	.LBB1_1
# BB#2:                                 # %afterloop
	movl	$.Lstr.15, %edi
	callq	writeString
	xorl	%ebx, %ebx
	.p2align	4, 0x90
.LBB1_3:                                # %loop5
                                        # =>This Inner Loop Header: Depth=1
	movl	$.Lstr.13, %edi
	callq	writeString
	movzbl	(%r14,%rbx), %eax
	cmpb	$90, %al
	jbe	.LBB1_6
# BB#4:                                 # %elif22
                                        #   in Loop: Header=BB1_3 Depth=1
	cmpb	$122, %al
	ja	.LBB1_7
# BB#5:                                 # %elifthen
                                        #   in Loop: Header=BB1_3 Depth=1
	addb	$-32, %al
.LBB1_6:                                # %ifcont45
                                        #   in Loop: Header=BB1_3 Depth=1
	movzbl	%al, %edi
	callq	writeChar
.LBB1_7:                                # %ifcont45
                                        #   in Loop: Header=BB1_3 Depth=1
	movl	$.Lstr.14, %edi
	callq	writeString
	incq	%rbx
	cmpl	%ebp, %ebx
	jl	.LBB1_3
# BB#8:                                 # %afterloop56
	movl	$.Lstr.15, %edi
	callq	writeString
	xorl	%ebx, %ebx
	.p2align	4, 0x90
.LBB1_9:                                # %loop58
                                        # =>This Inner Loop Header: Depth=1
	movl	$.Lstr.16, %edi
	callq	writeString
	incl	%ebx
	cmpl	%ebp, %ebx
	jl	.LBB1_9
# BB#10:                                # %afterloop69
	movl	$.Lstr.17, %edi
	popq	%rbx
	popq	%r14
	popq	%rbp
	jmp	writeString             # TAILCALL
.Lfunc_end1:
	.size	printBoxed, .Lfunc_end1-printBoxed
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"\n"
	.size	.Lstr, 2

	.type	.Lstr.13,@object        # @str.13
.Lstr.13:
	.asciz	"* "
	.size	.Lstr.13, 3

	.type	.Lstr.14,@object        # @str.14
.Lstr.14:
	.asciz	" "
	.size	.Lstr.14, 2

	.type	.Lstr.15,@object        # @str.15
.Lstr.15:
	.asciz	"*\n"
	.size	.Lstr.15, 3

	.type	.Lstr.16,@object        # @str.16
.Lstr.16:
	.asciz	"****"
	.size	.Lstr.16, 5

	.type	.Lstr.17,@object        # @str.17
.Lstr.17:
	.asciz	"*\n\n"
	.size	.Lstr.17, 4

	.type	.Lstr.18,@object        # @str.18
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.Lstr.18:
	.asciz	"Please, give a word: "
	.size	.Lstr.18, 22

	.type	.Lstr.19,@object        # @str.19
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr.19:
	.asciz	"peace"
	.size	.Lstr.19, 6


	.section	".note.GNU-stack","",@progbits
