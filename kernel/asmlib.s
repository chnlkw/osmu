.globl in_byte
.globl out_byte
.globl disp_str

.equ disp_line, 160

//disp_pos:
//	.long	0
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
