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
	movq	%rsp, %rbx
	jmp	.LBB0_1
	.p2align	4, 0x90
.LBB0_2:                                # %ifcont
                                        #   in Loop: Header=BB0_1 Depth=1
	movq	%rbx, %rdi
	movq	%rbx, %rsi
	callq	printBoxed
.LBB0_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	$.Lstr.17, %edi
	callq	writeString
	movl	$80, %edi
	movq	%rbx, %rsi
	callq	readString
	movl	$.Lstr.18, %esi
	movq	%rbx, %rdi
	callq	strcmp
	testl	%eax, %eax
	jne	.LBB0_2
# BB#3:                                 # %afterloop
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
	subq	$24, %rsp
.Lcfi3:
	.cfi_def_cfa_offset 32
	movq	%rdi, (%rsp)
	movq	%rsi, 8(%rsp)
	movq	%rsi, %rdi
	callq	strlen
	movl	%eax, 16(%rsp)
	movl	$.Lstr, %edi
	callq	writeString
	movl	$0, 20(%rsp)
	jmp	.LBB1_1
	.p2align	4, 0x90
.LBB1_2:                                # %ifcont
                                        #   in Loop: Header=BB1_1 Depth=1
	movl	$.Lstr.11, %edi
	callq	writeString
.LBB1_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	$.Lstr.10, %edi
	callq	writeString
	movl	20(%rsp), %eax
	incl	%eax
	movl	%eax, 20(%rsp)
	cmpl	16(%rsp), %eax
	jl	.LBB1_2
# BB#3:                                 # %afterloop
	movl	$0, 20(%rsp)
	jmp	.LBB1_4
	.p2align	4, 0x90
.LBB1_13:                               # %ifcont55
                                        #   in Loop: Header=BB1_4 Depth=1
	movl	$.Lstr.14, %edi
	callq	writeString
.LBB1_4:                                # %loop5
                                        # =>This Inner Loop Header: Depth=1
	movl	$.Lstr.12, %edi
	callq	writeString
	movq	8(%rsp), %rax
	movslq	20(%rsp), %rcx
	cmpb	$65, (%rax,%rcx)
	setb	%al
	jb	.LBB1_6
# BB#5:                                 # %andsecond
                                        #   in Loop: Header=BB1_4 Depth=1
	movq	8(%rsp), %rax
	movslq	20(%rsp), %rcx
	cmpb	$91, (%rax,%rcx)
	setb	%al
.LBB1_6:                                # %andcont
                                        #   in Loop: Header=BB1_4 Depth=1
	testb	%al, %al
	je	.LBB1_8
# BB#7:                                 # %then17
                                        #   in Loop: Header=BB1_4 Depth=1
	movq	8(%rsp), %rax
	movslq	20(%rsp), %rcx
	movzbl	(%rax,%rcx), %edi
	callq	writeChar
	jmp	.LBB1_12
	.p2align	4, 0x90
.LBB1_8:                                # %elif22
                                        #   in Loop: Header=BB1_4 Depth=1
	movq	8(%rsp), %rax
	movslq	20(%rsp), %rcx
	cmpb	$97, (%rax,%rcx)
	setb	%al
	jb	.LBB1_10
# BB#9:                                 # %andsecond30
                                        #   in Loop: Header=BB1_4 Depth=1
	movq	8(%rsp), %rax
	movslq	20(%rsp), %rcx
	cmpb	$123, (%rax,%rcx)
	setb	%al
.LBB1_10:                               # %andcont37
                                        #   in Loop: Header=BB1_4 Depth=1
	testb	%al, %al
	je	.LBB1_12
# BB#11:                                # %elifthen
                                        #   in Loop: Header=BB1_4 Depth=1
	movq	8(%rsp), %rax
	movslq	20(%rsp), %rcx
	movzbl	(%rax,%rcx), %eax
	addb	$-32, %al
	movzbl	%al, %edi
	callq	writeChar
	movl	$.Lstr.13, %edi
	callq	writeString
.LBB1_12:                               # %ifcont46
                                        #   in Loop: Header=BB1_4 Depth=1
	movl	20(%rsp), %eax
	incl	%eax
	movl	%eax, 20(%rsp)
	cmpl	16(%rsp), %eax
	jl	.LBB1_13
# BB#14:                                # %afterloop57
	movl	$0, 20(%rsp)
	jmp	.LBB1_15
	.p2align	4, 0x90
.LBB1_16:                               # %ifcont68
                                        #   in Loop: Header=BB1_15 Depth=1
	movl	$.Lstr.16, %edi
	callq	writeString
.LBB1_15:                               # %loop58
                                        # =>This Inner Loop Header: Depth=1
	movl	$.Lstr.15, %edi
	callq	writeString
	movl	20(%rsp), %eax
	incl	%eax
	movl	%eax, 20(%rsp)
	cmpl	16(%rsp), %eax
	jl	.LBB1_16
# BB#17:                                # %afterloop70
	addq	$24, %rsp
	retq
.Lfunc_end1:
	.size	printBoxed, .Lfunc_end1-printBoxed
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"\\n"
	.size	.Lstr, 3

	.type	.Lstr.10,@object        # @str.10
.Lstr.10:
	.asciz	"****"
	.size	.Lstr.10, 5

	.type	.Lstr.11,@object        # @str.11
.Lstr.11:
	.asciz	"*\\n"
	.size	.Lstr.11, 4

	.type	.Lstr.12,@object        # @str.12
.Lstr.12:
	.asciz	"* "
	.size	.Lstr.12, 3

	.type	.Lstr.13,@object        # @str.13
.Lstr.13:
	.asciz	" "
	.size	.Lstr.13, 2

	.type	.Lstr.14,@object        # @str.14
.Lstr.14:
	.asciz	"*\\n"
	.size	.Lstr.14, 4

	.type	.Lstr.15,@object        # @str.15
.Lstr.15:
	.asciz	"****"
	.size	.Lstr.15, 5

	.type	.Lstr.16,@object        # @str.16
.Lstr.16:
	.asciz	"*\\n\\n"
	.size	.Lstr.16, 6

	.type	.Lstr.17,@object        # @str.17
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.Lstr.17:
	.asciz	"Please, give a word: "
	.size	.Lstr.17, 22

	.type	.Lstr.18,@object        # @str.18
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr.18:
	.asciz	"peace"
	.size	.Lstr.18, 6


	.section	".note.GNU-stack","",@progbits
