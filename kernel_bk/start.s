	.file	"start.c"
	.comm	gdt_ptr,10,2
	.comm	idt_ptr,10,2
	.text
.globl cs_init
	.type	cs_init, @function
cs_init:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
.L2:
	jmp	.L2
	.cfi_endproc
.LFE0:
	.size	cs_init, .-cs_init
.globl cpu_info
	.type	cpu_info, @function
cpu_info:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	8(%rax), %rcx
	leaq	-32(%rbp), %rax
	leaq	4(%rax), %rdx
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	movl	$0, %eax
	call	get_cpuid
	movb	$0, -20(%rbp)
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	disp_str
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L6
	call	__stack_chk_fail
.L6:
	leave
	ret
	.cfi_endproc
.LFE1:
	.size	cpu_info, .-cpu_info
	.section	.rodata
.LC0:
	.string	"cstart begin\n"
.LC1:
	.string	"cstart finish\n"
	.text
.globl cstart
	.type	cstart, @function
cstart:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	movl	$.LC0, %edi
	movl	$0, %eax
	call	disp_str
	movl	$0, %eax
	call	cpu_info
	movl	$.LC1, %edi
	movl	$0, %eax
	call	disp_str
	leave
	ret
	.cfi_endproc
.LFE2:
	.size	cstart, .-cstart
	.ident	"GCC: (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5"
	.section	.note.GNU-stack,"",@progbits
