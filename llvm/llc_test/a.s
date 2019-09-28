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
	movzbl	.Lstr+7(%rip), %eax
	movl	%eax, 8(%rsp)
	movzbl	.Lstr+6(%rip), %eax
	movl	%eax, (%rsp)
	movzbl	.Lstr(%rip), %edi
	movzbl	.Lstr+1(%rip), %esi
	movzbl	.Lstr+2(%rip), %edx
	movzbl	.Lstr+3(%rip), %ecx
	movzbl	.Lstr+4(%rip), %r8d
	movzbl	.Lstr+5(%rip), %r9d
	callq	writeString
	addq	$24, %rsp
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.type	.Lstr,@object           # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"makaris"
	.size	.Lstr, 8


	.section	".note.GNU-stack","",@progbits
