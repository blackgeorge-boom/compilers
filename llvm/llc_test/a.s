	.text
	.file	"dana program"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$24, %rsp
.Lcfi0:
	.cfi_def_cfa_offset 32
	movl	$0, 4(%rsp)
	.p2align	4, 0x90
.LBB0_1:                                # %loop
                                        # =>This Inner Loop Header: Depth=1
	movl	$.Lstr, %edi
	callq	writeString
	movl	$.Lstr.3, %edi
	callq	writeString
	callq	readInteger
	movl	%eax, 4(%rsp)
	movl	$.Lstr.4, %edi
	callq	writeString
	callq	readInteger
	movl	%eax, 12(%rsp)
	movl	$.Lstr.5, %edi
	callq	writeString
	movl	$.Lstr.6, %edi
	callq	writeString
	callq	readInteger
	movl	%eax, 16(%rsp)
	movl	$.Lstr.7, %edi
	callq	writeString
	callq	readInteger
	movl	%eax, 20(%rsp)
	movl	4(%rsp), %edi
	movl	12(%rsp), %esi
	movl	16(%rsp), %edx
	movl	%eax, %ecx
	callq	length
	movl	%eax, 8(%rsp)
	movl	$.Lstr.8, %edi
	callq	writeString
	movl	8(%rsp), %edi
	callq	writeInteger
	movl	$.Lstr.9, %edi
	callq	writeString
	cmpl	$0, 8(%rsp)
	jg	.LBB0_1
# BB#2:                                 # %afterloop
	addq	$24, %rsp
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	length                  # -- Begin function length
	.p2align	4, 0x90
	.type	length,@function
length:                                 # @length
	.cfi_startproc
# BB#0:                                 # %entry
                                        # kill: %ESI<def> %ESI<kill> %RSI<def>
                                        # kill: %EDI<def> %EDI<kill> %RDI<def>
	movl	%edi, -24(%rsp)
	movl	%esi, -20(%rsp)
	movl	%edx, -16(%rsp)
	movl	%ecx, -12(%rsp)
	subl	%edx, %edi
	movl	%edi, -8(%rsp)
	subl	%ecx, %esi
	movl	%esi, -4(%rsp)
	leal	(%rsi,%rdi), %eax
	retq
.Lfunc_end1:
	.size	length, .Lfunc_end1-length
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.Lstr:
	.asciz	"Give the coordinates of the first point:\\n"
	.size	.Lstr, 43

	.type	.Lstr.3,@object         # @str.3
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr.3:
	.asciz	"x1 = "
	.size	.Lstr.3, 6

	.type	.Lstr.4,@object         # @str.4
.Lstr.4:
	.asciz	"y1 = "
	.size	.Lstr.4, 6

	.type	.Lstr.5,@object         # @str.5
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.Lstr.5:
	.asciz	"Give the coordinates of the second point:\\n"
	.size	.Lstr.5, 44

	.type	.Lstr.6,@object         # @str.6
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr.6:
	.asciz	"x2 = "
	.size	.Lstr.6, 6

	.type	.Lstr.7,@object         # @str.7
.Lstr.7:
	.asciz	"y2 = "
	.size	.Lstr.7, 6

	.type	.Lstr.8,@object         # @str.8
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.Lstr.8:
	.asciz	"The length of this segment is "
	.size	.Lstr.8, 31

	.type	.Lstr.9,@object         # @str.9
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr.9:
	.asciz	"\\n"
	.size	.Lstr.9, 3


	.section	".note.GNU-stack","",@progbits
