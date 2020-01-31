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
	subq	$32, %rsp
.Lcfi1:
	.cfi_def_cfa_offset 48
.Lcfi2:
	.cfi_offset %rbx, -16
	movq	%rsp, %rbx
	movl	$.Lstr, %esi
	movq	%rbx, %rdi
	callq	reverse
	movq	%rbx, %rdi
	callq	writeString
	addq	$32, %rsp
	popq	%rbx
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	reverse                 # -- Begin function reverse
	.p2align	4, 0x90
	.type	reverse,@function
reverse:                                # @reverse
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Lcfi3:
	.cfi_def_cfa_offset 32
	movq	%rdi, (%rsp)
	movq	%rsi, 8(%rsp)
	movq	%rsi, %rdi
	callq	strlen
	movl	%eax, 20(%rsp)
	movl	$0, 16(%rsp)
	jmp	.LBB1_1
	.p2align	4, 0x90
.LBB1_2:                                # %then
                                        #   in Loop: Header=BB1_1 Depth=1
	movslq	16(%rsp), %rax
	movl	20(%rsp), %ecx
	subl	%eax, %ecx
	decl	%ecx
	movq	(%rsp), %rdx
	movq	8(%rsp), %rsi
	movslq	%ecx, %rcx
	movzbl	(%rsi,%rcx), %ecx
	movb	%cl, (%rdx,%rax)
	incl	16(%rsp)
.LBB1_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	16(%rsp), %eax
	cmpl	20(%rsp), %eax
	jl	.LBB1_2
# BB#3:                                 # %afterloop
	movq	(%rsp), %rax
	movslq	16(%rsp), %rcx
	movb	$0, (%rax,%rcx)
	addq	$24, %rsp
	retq
.Lfunc_end1:
	.size	reverse, .Lfunc_end1-reverse
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"\n!dlrow olleH"
	.size	.Lstr, 14


	.section	".note.GNU-stack","",@progbits
