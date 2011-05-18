.globl in_byte
.globl out_byte
.globl disp_str
.globl get_cpuid
.globl rdmsr
.globl memcpy

.equ disp_line, 160

disp_pos:
	.long	0

memcpy:
	pushf
	cld
	mov %edx, %ecx
	rep movsb 
	popf
	ret

/*
in_byte:
	mov %di, %dx
	xor %eax, %eax
	inb %dx, %al
	nop
	nop
	ret

out_byte:
	mov %esi, %eax
	mov %edi, %edx
	outb %al, %dx
	nop
	nop
	ret
*/
disp_str:
	movl (disp_pos), %ebx	
disp_str_loop:
	mov $0, %al
	cmpb %al, (%edi)
	je disp_str_end
	mov $10, %al
	cmp (%edi), %al
	je disp_enter
	mov (%edi), %al
	mov $0x0F, %ah
	mov %ax, %gs:(%ebx)
	inc %ebx
	inc %ebx
	inc %edi
	jmp disp_str_loop
disp_enter:
	mov %ebx,%eax
	mov $disp_line, %ebx
	mov $0, %edx
	div %ebx
	inc %eax
	mul %ebx
	mov %eax, %ebx
	inc %edi
	jmp disp_str_loop
disp_str_end:
	movl %ebx, (disp_pos)
	ret

get_cpuid:
	push %rcx
	push %rdx
	push %rsi
	mov %edi, %eax
	cpuid
	pop %rdi
	mov %ebx, (%edi)
	pop %rdi
	mov %ecx, (%edi)
	pop %rdi
	mov %edx, (%edi)
	ret

rdmsr:
	mov %edi, %ecx
	rdmsr
	shlq $32, %rdx
	or %rdx, %rax
	ret
