.extern cmain

.code32

.text

.globl _start

start:
_start:
	jmp cmain

.globl sleep
sleep:
	incw (0xb8000)
	incw (0xb8002)
	jmp sleep
	ret

#define disp_line 160
.globl disp_str
disp_str:
	mov 0x4(%esp), %edi
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
	mov %ax, 0xb8000(%ebx)
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

disp_pos:	.long 0
