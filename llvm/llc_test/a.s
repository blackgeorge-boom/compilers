	.text
	.file	"dana program"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	subq	$808, %rsp              # imm = 0x328
.Lcfi0:
	.cfi_def_cfa_offset 816
	movl	$2, 128(%rsp)
	movl	$2, %edi
	callq	writeInteger
	leaq	8(%rsp), %rdi
	callq	hello
	movzbl	.Lstr+2(%rip), %edi
	callq	writeChar
	addq	$808, %rsp              # imm = 0x328
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	hello                   # -- Begin function hello
	.p2align	4, 0x90
	.type	hello,@function
hello:                                  # @hello
	.cfi_startproc
# BB#0:                                 # %entry
	movl	$1, 120(%rdi)
	retq
.Lfunc_end1:
	.size	hello, .Lfunc_end1-hello
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"makaris"
	.size	.Lstr, 8


	.section	".note.GNU-stack","",@progbits
