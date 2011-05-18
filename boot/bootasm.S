#include "pm.h"

.set	AddrOfBoot,	0x7c00
.set	sel_code,	0x8
.set	sel_data,	0x10

.globl	_start

.globl	disp_str
.globl	inb
.globl	outb
.globl	insl
.globl	sleep

.text
.code16

_start:
	cli
	cld
	mov %cs, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %ss
	mov $_start, %sp
	mov $0xb800, %ax
	mov %ax, %gs

	inb $0x92, %al
	orb $2, %al
	outb %al, $0x92

	lgdt gdt_ptr

	mov %cr0, %eax
	or $1, %eax
	mov %eax, %cr0

	ljmp $sel_code, $pm_code

.code32

pm_code:
	mov $sel_data, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	jmp cstart
/*
inb:
	mov 0x4(%esp), %dx
	xor %eax, %eax
	inb %dx, %al
	ret

outb:
	mov 0x8(%esp), %eax
	mov 0x4(%esp), %edx
	outb %al, %dx
	ret

insl:
	mov 0x12(%esp), %ecx
	mov 0x4(%esp), %dx
	mov 0x8(%esp), %edi
	repnz insl %dx, %es:(%edi)
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

sleep:
	incw (0xb8000)
	incw (0xb8002)
	jmp sleep
	ret

.p2align 2

disp_pos:	.long	0
.equ disp_line, 160

gdt:		SEG_NULL
gdt_code:	SEG_CODE
gdt_data:	SEG_DATA

gdt_ptr:
	.word	. - gdt
	.long	gdt

