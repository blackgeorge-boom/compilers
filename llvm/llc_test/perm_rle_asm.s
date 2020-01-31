	.text
	.file	"dana program"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$1096, %rsp             # imm = 0x448
.Lcfi0:
	.cfi_def_cfa_offset 1104
	leaq	8(%rsp), %rdi
	callq	main2
	addq	$1096, %rsp             # imm = 0x448
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
	subq	$24, %rsp
.Lcfi1:
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	movl	%esi, 16(%rsp)
	movl	$1073741823, (%rdi)     # imm = 0x3FFFFFFF
	movq	8(%rsp), %rdi
	addq	$84, %rdi
	callq	strlen
	movl	%eax, 20(%rsp)
	leaq	8(%rsp), %rdi
	xorl	%esi, %esi
	callq	go
	movq	8(%rsp), %rax
	movl	(%rax), %eax
	addq	$24, %rsp
	retq
.Lfunc_end1:
	.size	work, .Lfunc_end1-work
	.cfi_endproc
                                        # -- End function
	.globl	compress                # -- Begin function compress
	.p2align	4, 0x90
	.type	compress,@function
compress:                               # @compress
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$1048, %rsp             # imm = 0x418
.Lcfi2:
	.cfi_def_cfa_offset 1056
	movq	%rdi, (%rsp)
	movq	%rsi, 8(%rsp)
	movq	%rdx, 16(%rsp)
	movl	$-1, %edi
	callq	shrink
	movb	%al, 1044(%rsp)
	movq	$0, 1028(%rsp)
	movq	$0, 1036(%rsp)
	jmp	.LBB2_1
	.p2align	4, 0x90
.LBB2_6:                                # %ifcont35
                                        #   in Loop: Header=BB2_1 Depth=1
	incl	1040(%rsp)
.LBB2_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	1040(%rsp), %eax
	movq	(%rsp), %rcx
	cmpl	12(%rcx), %eax
	je	.LBB2_7
# BB#2:                                 # %ifcont
                                        #   in Loop: Header=BB2_1 Depth=1
	movslq	1040(%rsp), %rax
	movl	1036(%rsp), %ecx
	movslq	1032(%rsp), %rdx
	movq	8(%rsp), %rsi
	movq	16(%rsp), %rdi
	addl	(%rsi,%rdx,4), %ecx
	movslq	%ecx, %rcx
	movzbl	(%rdi,%rcx), %ecx
	movb	%cl, 24(%rsp,%rax)
	movl	1032(%rsp), %eax
	incl	%eax
	movl	%eax, 1032(%rsp)
	movq	(%rsp), %rcx
	cmpl	8(%rcx), %eax
	jne	.LBB2_4
# BB#3:                                 # %then17
                                        #   in Loop: Header=BB2_1 Depth=1
	movl	$0, 1032(%rsp)
	movq	(%rsp), %rax
	movl	8(%rax), %eax
	addl	%eax, 1036(%rsp)
.LBB2_4:                                # %ifcont22
                                        #   in Loop: Header=BB2_1 Depth=1
	movslq	1040(%rsp), %rax
	movzbl	24(%rsp,%rax), %eax
	cmpb	1044(%rsp), %al
	je	.LBB2_6
# BB#5:                                 # %then28
                                        #   in Loop: Header=BB2_1 Depth=1
	incl	1028(%rsp)
	movslq	1040(%rsp), %rax
	movzbl	24(%rsp,%rax), %eax
	movb	%al, 1044(%rsp)
	jmp	.LBB2_6
.LBB2_7:                                # %afterloop
	movl	1028(%rsp), %eax
	addq	$1048, %rsp             # imm = 0x418
	retq
.Lfunc_end2:
	.size	compress, .Lfunc_end2-compress
	.cfi_endproc
                                        # -- End function
	.globl	go                      # -- Begin function go
	.p2align	4, 0x90
	.type	go,@function
go:                                     # @go
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbp
.Lcfi3:
	.cfi_def_cfa_offset 16
	pushq	%rbx
.Lcfi4:
	.cfi_def_cfa_offset 24
	subq	$24, %rsp
.Lcfi5:
	.cfi_def_cfa_offset 48
.Lcfi6:
	.cfi_offset %rbx, -24
.Lcfi7:
	.cfi_offset %rbp, -16
	movq	%rdi, 8(%rsp)
	movl	%esi, 16(%rsp)
	cmpl	8(%rdi), %esi
	jne	.LBB3_3
# BB#1:                                 # %then
	movq	8(%rsp), %rdi
	movq	(%rdi), %rbx
	movl	(%rbx), %ebp
	leaq	4(%rbx), %rsi
	leaq	84(%rbx), %rdx
	callq	compress
	leaq	8(%rsp), %rdi
	movl	%ebp, %esi
	movl	%eax, %edx
	callq	MathMin
	movl	%eax, (%rbx)
	jmp	.LBB3_2
.LBB3_3:                                # %ifcont
	movl	$0, 20(%rsp)
	jmp	.LBB3_4
	.p2align	4, 0x90
.LBB3_6:                                # %then16
                                        #   in Loop: Header=BB3_4 Depth=1
	incl	20(%rsp)
.LBB3_4:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	20(%rsp), %eax
	movq	8(%rsp), %rcx
	cmpl	8(%rcx), %eax
	je	.LBB3_2
# BB#5:                                 # %ifcont11
                                        #   in Loop: Header=BB3_4 Depth=1
	movq	8(%rsp), %rax
	movq	(%rax), %rax
	movslq	20(%rsp), %rcx
	cmpb	$0, 68(%rax,%rcx)
	jne	.LBB3_6
# BB#7:                                 # %ifcont19
                                        #   in Loop: Header=BB3_4 Depth=1
	movq	8(%rsp), %rax
	movq	(%rax), %rax
	movslq	20(%rsp), %rcx
	movb	$1, 68(%rax,%rcx)
	movq	8(%rsp), %rax
	movq	(%rax), %rax
	movslq	16(%rsp), %rcx
	movl	20(%rsp), %edx
	movl	%edx, 4(%rax,%rcx,4)
	movq	8(%rsp), %rdi
	movl	16(%rsp), %esi
	incl	%esi
	callq	go
	movq	8(%rsp), %rax
	movq	(%rax), %rax
	movslq	20(%rsp), %rcx
	movb	$0, 68(%rax,%rcx)
	incl	20(%rsp)
	jmp	.LBB3_4
.LBB3_2:                                # %afterloop
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	retq
.Lfunc_end3:
	.size	go, .Lfunc_end3-go
	.cfi_endproc
                                        # -- End function
	.globl	MathMin                 # -- Begin function MathMin
	.p2align	4, 0x90
	.type	MathMin,@function
MathMin:                                # @MathMin
	.cfi_startproc
# BB#0:                                 # %entry
	movq	%rdi, -16(%rsp)
	movl	%esi, -8(%rsp)
	movl	%edx, -4(%rsp)
	cmpl	%edx, %esi
	jge	.LBB4_2
# BB#1:                                 # %then
	movl	-8(%rsp), %eax
	retq
.LBB4_2:                                # %else
	movl	-4(%rsp), %eax
	retq
.Lfunc_end4:
	.size	MathMin, .Lfunc_end4-MathMin
	.cfi_endproc
                                        # -- End function
	.globl	main2                   # -- Begin function main2
	.p2align	4, 0x90
	.type	main2,@function
main2:                                  # @main2
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Lcfi8:
	.cfi_def_cfa_offset 32
	movq	%rdi, (%rsp)
	callq	readInteger
	movl	%eax, 8(%rsp)
	movl	$0, 12(%rsp)
	jmp	.LBB5_1
	.p2align	4, 0x90
.LBB5_2:                                # %ifcont
                                        #   in Loop: Header=BB5_1 Depth=1
	callq	readInteger
	movl	%eax, 16(%rsp)
	movq	(%rsp), %rsi
	addq	$84, %rsi
	movl	$1001, %edi             # imm = 0x3E9
	callq	readString
	movq	(%rsp), %rdi
	movl	16(%rsp), %esi
	callq	work
	movl	%eax, 20(%rsp)
	movl	$.Lstr, %edi
	callq	writeString
	movl	12(%rsp), %edi
	incl	%edi
	callq	writeInteger
	movl	$.Lstr.1, %edi
	callq	writeString
	movl	20(%rsp), %edi
	callq	writeInteger
	movl	$.Lstr.2, %edi
	callq	writeString
	incl	12(%rsp)
.LBB5_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	12(%rsp), %eax
	cmpl	8(%rsp), %eax
	jne	.LBB5_2
# BB#3:                                 # %afterloop
	addq	$24, %rsp
	retq
.Lfunc_end5:
	.size	main2, .Lfunc_end5-main2
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
