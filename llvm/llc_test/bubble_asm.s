	.text
	.file	"dana program"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbp
.Lcfi0:
	.cfi_def_cfa_offset 16
	pushq	%r15
.Lcfi1:
	.cfi_def_cfa_offset 24
	pushq	%r14
.Lcfi2:
	.cfi_def_cfa_offset 32
	pushq	%r13
.Lcfi3:
	.cfi_def_cfa_offset 40
	pushq	%r12
.Lcfi4:
	.cfi_def_cfa_offset 48
	pushq	%rbx
.Lcfi5:
	.cfi_def_cfa_offset 56
	subq	$280, %rsp              # imm = 0x118
.Lcfi6:
	.cfi_def_cfa_offset 336
.Lcfi7:
	.cfi_offset %rbx, -56
.Lcfi8:
	.cfi_offset %r12, -48
.Lcfi9:
	.cfi_offset %r13, -40
.Lcfi10:
	.cfi_offset %r14, -32
.Lcfi11:
	.cfi_offset %r15, -24
.Lcfi12:
	.cfi_offset %rbp, -16
	movabsq	$4294967331, %rax       # imm = 0x100000023
	movq	%rax, 120(%rsp)
	movl	$35, 128(%rsp)
	movl	$1, %eax
	.p2align	4, 0x90
.LBB0_1:                                # %then.then_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	imull	$137, 120(%rsp), %ecx
	leal	220(%rax,%rcx), %ecx
	movslq	%ecx, %rcx
	imulq	$680390859, %rcx, %rdx  # imm = 0x288DF0CB
	movq	%rdx, %rsi
	shrq	$63, %rsi
	sarq	$36, %rdx
	addl	%esi, %edx
	imull	$101, %edx, %edx
	subl	%edx, %ecx
	movl	%ecx, 120(%rsp)
	cltq
	movl	%ecx, 128(%rsp,%rax,4)
	movl	124(%rsp), %eax
	incl	%eax
	movl	%eax, 124(%rsp)
	cmpl	$16, %eax
	jl	.LBB0_1
# BB#2:                                 # %ifcont.i.15
	movl	$.Lstr.2, %edi
	callq	writeString
	movl	128(%rsp), %edi
	movl	%edi, 116(%rsp)         # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	132(%rsp), %edi
	movl	%edi, 112(%rsp)         # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	136(%rsp), %edi
	movl	%edi, 108(%rsp)         # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	140(%rsp), %edi
	movl	%edi, 104(%rsp)         # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	144(%rsp), %edi
	movl	%edi, 100(%rsp)         # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	148(%rsp), %edi
	movl	%edi, 96(%rsp)          # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	152(%rsp), %edi
	movl	%edi, 92(%rsp)          # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	156(%rsp), %edi
	movl	%edi, 88(%rsp)          # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	160(%rsp), %edi
	movl	%edi, 84(%rsp)          # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	164(%rsp), %edi
	movl	%edi, 80(%rsp)          # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	168(%rsp), %edi
	movl	%edi, 76(%rsp)          # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	172(%rsp), %edi
	movl	%edi, 72(%rsp)          # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	176(%rsp), %edi
	movl	%edi, 68(%rsp)          # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	180(%rsp), %edi
	movl	%edi, 8(%rsp)           # 4-byte Spill
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	184(%rsp), %ebx
	movl	%ebx, %edi
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	188(%rsp), %r15d
	movl	%r15d, %edi
	callq	writeInteger
	movl	$.Lstr.1, %edi
	callq	writeString
	movl	128(%rsp), %eax
	movl	%eax, 16(%rsp)          # 4-byte Spill
	movl	132(%rsp), %eax
	movl	%eax, 20(%rsp)          # 4-byte Spill
	movl	136(%rsp), %eax
	movl	%eax, 24(%rsp)          # 4-byte Spill
	movl	140(%rsp), %eax
	movl	%eax, 28(%rsp)          # 4-byte Spill
	movl	144(%rsp), %eax
	movl	%eax, 32(%rsp)          # 4-byte Spill
	movl	148(%rsp), %eax
	movl	%eax, 36(%rsp)          # 4-byte Spill
	movl	152(%rsp), %eax
	movl	%eax, 40(%rsp)          # 4-byte Spill
	movl	156(%rsp), %eax
	movl	%eax, 44(%rsp)          # 4-byte Spill
	movl	160(%rsp), %eax
	movl	%eax, 48(%rsp)          # 4-byte Spill
	movl	164(%rsp), %eax
	movl	%eax, 52(%rsp)          # 4-byte Spill
	movl	168(%rsp), %eax
	movl	%eax, 12(%rsp)          # 4-byte Spill
	movl	172(%rsp), %eax
	movl	%eax, 56(%rsp)          # 4-byte Spill
	movl	176(%rsp), %eax
	movl	%eax, 60(%rsp)          # 4-byte Spill
	movl	180(%rsp), %eax
	movl	%eax, 64(%rsp)          # 4-byte Spill
	movl	184(%rsp), %eax
	movl	%eax, (%rsp)            # 4-byte Spill
	movl	188(%rsp), %eax
	movl	%eax, 196(%rsp)         # 4-byte Spill
	movl	%r15d, %eax
	jmp	.LBB0_5
	.p2align	4, 0x90
.LBB0_6:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	movl	%edx, (%rsp)            # 4-byte Spill
	cmpl	%r13d, %r14d
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#7:                                 # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	cmpl	%esi, %ebx
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#8:                                 # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	cmpl	%edi, %r12d
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#9:                                 # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	cmpl	264(%rsp), %ebp         # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#10:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	cmpl	260(%rsp), %r11d        # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#11:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	cmpl	256(%rsp), %r10d        # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#12:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	cmpl	252(%rsp), %r8d         # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#13:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	cmpl	248(%rsp), %r9d         # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#14:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	movl	200(%rsp), %edx         # 4-byte Reload
	cmpl	208(%rsp), %edx         # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#15:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	movl	204(%rsp), %edx         # 4-byte Reload
	cmpl	216(%rsp), %edx         # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#16:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	movl	212(%rsp), %edx         # 4-byte Reload
	cmpl	224(%rsp), %edx         # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#17:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	movl	220(%rsp), %edx         # 4-byte Reload
	cmpl	232(%rsp), %edx         # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#18:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	movl	228(%rsp), %esi         # 4-byte Reload
	cmpl	236(%rsp), %esi         # 4-byte Folded Reload
	movl	%eax, %ecx
	jg	.LBB0_3
# BB#19:                                # %ifcont.us.i.14
                                        #   in Loop: Header=BB0_3 Depth=2
	movl	240(%rsp), %esi         # 4-byte Reload
	cmpl	%esi, 244(%rsp)         # 4-byte Folded Reload
	movl	%eax, %ecx
	jle	.LBB0_20
	jmp	.LBB0_3
	.p2align	4, 0x90
.LBB0_4:                                #   in Loop: Header=BB0_5 Depth=1
	movl	%eax, 196(%rsp)         # 4-byte Spill
	movl	4(%rsp), %ebx           # 4-byte Reload
	movl	%ebx, (%rsp)            # 4-byte Spill
.LBB0_5:                                # %loop.us.i.outer
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	movl	%ebx, %ecx
	movl	%eax, 4(%rsp)           # 4-byte Spill
	.p2align	4, 0x90
.LBB0_3:                                # %loop.us.i
                                        #   Parent Loop BB0_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	%ecx, 276(%rsp)         # 4-byte Spill
	movl	116(%rsp), %edx         # 4-byte Reload
	movl	%edx, %esi
	movl	112(%rsp), %edi         # 4-byte Reload
	movl	108(%rsp), %ebp         # 4-byte Reload
	movl	104(%rsp), %ebx         # 4-byte Reload
	movl	100(%rsp), %r8d         # 4-byte Reload
	movl	96(%rsp), %r9d          # 4-byte Reload
	movl	92(%rsp), %r10d         # 4-byte Reload
	movl	88(%rsp), %r11d         # 4-byte Reload
	movl	84(%rsp), %r15d         # 4-byte Reload
	movl	80(%rsp), %r13d         # 4-byte Reload
	movl	76(%rsp), %r14d         # 4-byte Reload
	movl	72(%rsp), %r12d         # 4-byte Reload
	movl	68(%rsp), %eax          # 4-byte Reload
	movl	%eax, 272(%rsp)         # 4-byte Spill
	movl	8(%rsp), %eax           # 4-byte Reload
	movl	%eax, 268(%rsp)         # 4-byte Spill
	cmpl	%edi, %esi
	movl	20(%rsp), %eax          # 4-byte Reload
	cmovgl	%esi, %eax
	movl	16(%rsp), %ecx          # 4-byte Reload
	cmovgl	%edi, %ecx
	movl	%ecx, 16(%rsp)          # 4-byte Spill
	cmovgl	%edi, %edx
	movl	%edx, 116(%rsp)         # 4-byte Spill
	movl	%edi, 240(%rsp)         # 4-byte Spill
	movl	%esi, 244(%rsp)         # 4-byte Spill
	cmovgel	%esi, %edi
	cmpl	%ebp, %edi
	movl	24(%rsp), %ecx          # 4-byte Reload
	cmovgl	%edi, %ecx
	cmovgl	%ebp, %eax
	movl	%eax, 20(%rsp)          # 4-byte Spill
	movl	%edi, %eax
	cmovgl	%ebp, %eax
	movl	%eax, 112(%rsp)         # 4-byte Spill
	movl	%ebp, 236(%rsp)         # 4-byte Spill
	movl	%edi, 228(%rsp)         # 4-byte Spill
	cmovgel	%edi, %ebp
	cmpl	%ebx, %ebp
	movl	28(%rsp), %esi          # 4-byte Reload
	cmovgl	%ebp, %esi
	cmovgl	%ebx, %ecx
	movl	%ecx, 24(%rsp)          # 4-byte Spill
	movl	%ebp, %ecx
	cmovgl	%ebx, %ecx
	movl	%ecx, 108(%rsp)         # 4-byte Spill
	movl	%ebx, 232(%rsp)         # 4-byte Spill
	movl	%ebp, 220(%rsp)         # 4-byte Spill
	cmovgel	%ebp, %ebx
	cmpl	%r8d, %ebx
	movl	32(%rsp), %eax          # 4-byte Reload
	cmovgl	%ebx, %eax
	cmovgl	%r8d, %esi
	movl	%esi, 28(%rsp)          # 4-byte Spill
	movl	%ebx, %ecx
	cmovgl	%r8d, %ecx
	movl	%ecx, 104(%rsp)         # 4-byte Spill
	movl	%r8d, 224(%rsp)         # 4-byte Spill
	movl	%ebx, 212(%rsp)         # 4-byte Spill
	cmovgel	%ebx, %r8d
	cmpl	%r9d, %r8d
	movl	36(%rsp), %esi          # 4-byte Reload
	cmovgl	%r8d, %esi
	cmovgl	%r9d, %eax
	movl	%eax, 32(%rsp)          # 4-byte Spill
	movl	%r8d, %ecx
	cmovgl	%r9d, %ecx
	movl	%ecx, 100(%rsp)         # 4-byte Spill
	movl	%r9d, 216(%rsp)         # 4-byte Spill
	movl	%r9d, %edx
	movl	%r8d, 204(%rsp)         # 4-byte Spill
	cmovgel	%r8d, %edx
	cmpl	%r10d, %edx
	movl	40(%rsp), %eax          # 4-byte Reload
	cmovgl	%edx, %eax
	cmovgl	%r10d, %esi
	movl	%esi, 36(%rsp)          # 4-byte Spill
	movl	%edx, %ecx
	cmovgl	%r10d, %ecx
	movl	%ecx, 96(%rsp)          # 4-byte Spill
	movl	%r10d, 208(%rsp)        # 4-byte Spill
	movl	%r10d, %r9d
	movl	%edx, 200(%rsp)         # 4-byte Spill
	cmovgel	%edx, %r9d
	cmpl	%r11d, %r9d
	movl	44(%rsp), %ebp          # 4-byte Reload
	cmovgl	%r9d, %ebp
	cmovgl	%r11d, %eax
	movl	%eax, 40(%rsp)          # 4-byte Spill
	movl	%r9d, %ecx
	cmovgl	%r11d, %ecx
	movl	%ecx, 92(%rsp)          # 4-byte Spill
	movl	%r11d, 248(%rsp)        # 4-byte Spill
	movl	%r11d, %r8d
	cmovgel	%r9d, %r8d
	cmpl	%r15d, %r8d
	movl	48(%rsp), %eax          # 4-byte Reload
	cmovgl	%r8d, %eax
	cmovgl	%r15d, %ebp
	movl	%ebp, 44(%rsp)          # 4-byte Spill
	movl	%r8d, %ecx
	cmovgl	%r15d, %ecx
	movl	%ecx, 88(%rsp)          # 4-byte Spill
	movl	%r15d, 252(%rsp)        # 4-byte Spill
	movl	%r15d, %r10d
	cmovgel	%r8d, %r10d
	cmpl	%r13d, %r10d
	movl	52(%rsp), %edi          # 4-byte Reload
	cmovgl	%r10d, %edi
	cmovgl	%r13d, %eax
	movl	%eax, 48(%rsp)          # 4-byte Spill
	movl	%r10d, %ecx
	cmovgl	%r13d, %ecx
	movl	%ecx, 84(%rsp)          # 4-byte Spill
	movl	%r13d, 256(%rsp)        # 4-byte Spill
	movl	%r13d, %r11d
	cmovgel	%r10d, %r11d
	cmpl	%r14d, %r11d
	movl	12(%rsp), %edx          # 4-byte Reload
	cmovgl	%r11d, %edx
	cmovgl	%r14d, %edi
	movl	%edi, 52(%rsp)          # 4-byte Spill
	movl	%r11d, %ecx
	cmovgl	%r14d, %ecx
	movl	%ecx, 80(%rsp)          # 4-byte Spill
	movl	%r14d, 260(%rsp)        # 4-byte Spill
	movl	%r14d, %ebp
	cmovgel	%r11d, %ebp
	cmpl	%r12d, %ebp
	movl	56(%rsp), %eax          # 4-byte Reload
	cmovgl	%ebp, %eax
	cmovgl	%r12d, %edx
	movl	%edx, 12(%rsp)          # 4-byte Spill
	movl	%ebp, %ecx
	cmovgl	%r12d, %ecx
	movl	%ecx, 76(%rsp)          # 4-byte Spill
	movl	%r12d, 264(%rsp)        # 4-byte Spill
	movl	268(%rsp), %esi         # 4-byte Reload
	movl	272(%rsp), %edi         # 4-byte Reload
	cmovgel	%ebp, %r12d
	cmpl	%edi, %r12d
	movl	60(%rsp), %edx          # 4-byte Reload
	cmovgl	%r12d, %edx
	cmovgl	%edi, %eax
	movl	%eax, 56(%rsp)          # 4-byte Spill
	movl	%r12d, %ecx
	cmovgl	%edi, %ecx
	movl	%ecx, 72(%rsp)          # 4-byte Spill
	movl	%edi, %ebx
	cmovgel	%r12d, %ebx
	cmpl	%esi, %ebx
	movl	64(%rsp), %eax          # 4-byte Reload
	cmovgl	%ebx, %eax
	cmovgl	%esi, %edx
	movl	%edx, 60(%rsp)          # 4-byte Spill
	movl	%ebx, %ecx
	cmovgl	%esi, %ecx
	movl	%ecx, 68(%rsp)          # 4-byte Spill
	movl	%esi, %r14d
	cmovgel	%ebx, %r14d
	movl	276(%rsp), %ecx         # 4-byte Reload
	cmpl	%ecx, %r14d
	movl	(%rsp), %edx            # 4-byte Reload
	cmovgl	%r14d, %edx
	cmovgl	%ecx, %eax
	movl	%eax, 64(%rsp)          # 4-byte Spill
	movl	%r14d, %eax
	cmovgl	%ecx, %eax
	movl	%eax, 8(%rsp)           # 4-byte Spill
	movl	%ecx, %r13d
	movl	%ecx, %eax
	cmovgel	%r14d, %eax
	cmpl	4(%rsp), %eax           # 4-byte Folded Reload
	jle	.LBB0_6
	jmp	.LBB0_4
.LBB0_20:                               # %ifcont.i9.15
	movl	%eax, %ebp
	movl	196(%rsp), %eax         # 4-byte Reload
	movl	%eax, 188(%rsp)
	movl	16(%rsp), %eax          # 4-byte Reload
	movl	%eax, 128(%rsp)
	movl	20(%rsp), %eax          # 4-byte Reload
	movl	%eax, 132(%rsp)
	movl	24(%rsp), %eax          # 4-byte Reload
	movl	%eax, 136(%rsp)
	movl	28(%rsp), %eax          # 4-byte Reload
	movl	%eax, 140(%rsp)
	movl	32(%rsp), %eax          # 4-byte Reload
	movl	%eax, 144(%rsp)
	movl	36(%rsp), %eax          # 4-byte Reload
	movl	%eax, 148(%rsp)
	movl	40(%rsp), %eax          # 4-byte Reload
	movl	%eax, 152(%rsp)
	movl	44(%rsp), %eax          # 4-byte Reload
	movl	%eax, 156(%rsp)
	movl	48(%rsp), %eax          # 4-byte Reload
	movl	%eax, 160(%rsp)
	movl	52(%rsp), %eax          # 4-byte Reload
	movl	%eax, 164(%rsp)
	movl	12(%rsp), %eax          # 4-byte Reload
	movl	%eax, 168(%rsp)
	movl	56(%rsp), %eax          # 4-byte Reload
	movl	%eax, 172(%rsp)
	movl	60(%rsp), %eax          # 4-byte Reload
	movl	%eax, 176(%rsp)
	movl	64(%rsp), %eax          # 4-byte Reload
	movl	%eax, 180(%rsp)
	movl	(%rsp), %eax            # 4-byte Reload
	movl	%eax, 184(%rsp)
	movl	$.Lstr.3, %edi
	callq	writeString
	movl	116(%rsp), %edi         # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	112(%rsp), %edi         # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	108(%rsp), %edi         # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	104(%rsp), %edi         # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	100(%rsp), %edi         # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	96(%rsp), %edi          # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	92(%rsp), %edi          # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	88(%rsp), %edi          # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	84(%rsp), %edi          # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	80(%rsp), %edi          # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	76(%rsp), %edi          # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	72(%rsp), %edi          # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	68(%rsp), %edi          # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	8(%rsp), %edi           # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	%ebp, %edi
	callq	writeInteger
	movl	$.Lstr, %edi
	callq	writeString
	movl	4(%rsp), %edi           # 4-byte Reload
	callq	writeInteger
	movl	$.Lstr.1, %edi
	addq	$280, %rsp              # imm = 0x118
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	jmp	writeString             # TAILCALL
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	bsort                   # -- Begin function bsort
	.p2align	4, 0x90
	.type	bsort,@function
bsort:                                  # @bsort
# BB#0:                                 # %entry
	decl	%esi
	testl	%esi, %esi
	jle	.LBB1_7
	.p2align	4, 0x90
.LBB1_1:                                # %loop.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	movl	(%rdx), %edi
	xorl	%eax, %eax
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB1_2:                                # %then.us
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	4(%rdx,%rax,4), %ecx
	cmpl	%ecx, %edi
	jle	.LBB1_3
# BB#4:                                 # %then10.us
                                        #   in Loop: Header=BB1_2 Depth=2
	movl	%ecx, (%rdx,%rax,4)
	movl	%edi, 4(%rdx,%rax,4)
	movb	$1, %r8b
	incq	%rax
	cmpl	%esi, %eax
	jl	.LBB1_2
	jmp	.LBB1_6
	.p2align	4, 0x90
.LBB1_3:                                #   in Loop: Header=BB1_2 Depth=2
	movl	%ecx, %edi
	incq	%rax
	cmpl	%esi, %eax
	jl	.LBB1_2
.LBB1_6:                                # %loop1.afterloop_crit_edge.us
                                        #   in Loop: Header=BB1_1 Depth=1
	testb	%r8b, %r8b
	jne	.LBB1_1
.LBB1_7:                                # %afterloop27
	retq
.Lfunc_end1:
	.size	bsort, .Lfunc_end1-bsort
                                        # -- End function
	.globl	swap                    # -- Begin function swap
	.p2align	4, 0x90
	.type	swap,@function
swap:                                   # @swap
# BB#0:                                 # %entry
	movl	(%rsi), %eax
	movl	(%rdx), %ecx
	movl	%ecx, (%rsi)
	movl	%eax, (%rdx)
	retq
.Lfunc_end2:
	.size	swap, .Lfunc_end2-swap
                                        # -- End function
	.globl	writeArray              # -- Begin function writeArray
	.p2align	4, 0x90
	.type	writeArray,@function
writeArray:                             # @writeArray
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbp
.Lcfi13:
	.cfi_def_cfa_offset 16
	pushq	%r14
.Lcfi14:
	.cfi_def_cfa_offset 24
	pushq	%rbx
.Lcfi15:
	.cfi_def_cfa_offset 32
.Lcfi16:
	.cfi_offset %rbx, -32
.Lcfi17:
	.cfi_offset %r14, -24
.Lcfi18:
	.cfi_offset %rbp, -16
	movq	%rcx, %r14
	movl	%edx, %ebp
	movq	%rsi, %rdi
	callq	writeString
	testl	%ebp, %ebp
	jle	.LBB3_5
# BB#1:                                 # %then.preheader
	xorl	%ebx, %ebx
	.p2align	4, 0x90
.LBB3_2:                                # %then
                                        # =>This Inner Loop Header: Depth=1
	testl	%ebx, %ebx
	je	.LBB3_4
# BB#3:                                 # %then5
                                        #   in Loop: Header=BB3_2 Depth=1
	movl	$.Lstr, %edi
	callq	writeString
.LBB3_4:                                # %ifcont
                                        #   in Loop: Header=BB3_2 Depth=1
	movl	(%r14,%rbx,4), %edi
	callq	writeInteger
	incq	%rbx
	cmpl	%ebp, %ebx
	jl	.LBB3_2
.LBB3_5:                                # %afterloop
	movl	$.Lstr.1, %edi
	popq	%rbx
	popq	%r14
	popq	%rbp
	jmp	writeString             # TAILCALL
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
