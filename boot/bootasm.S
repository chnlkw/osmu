#include "pm.h"

.set	AddrOfBoot,	0x7c00
.set	sel_code,	0x8
.set	sel_data,	0x10

.globl	_start

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
//	call readsect
_loop:
	incw %ds:(0xb8000)
	jmp _loop
/*
readsect: 
	push %bp
	mov %sp, %bp
	mov $0x1F7, %dx
_waitdisk:
	inb %dx, %al
	test %al, 0x40
	jne _waitdisk

	mov $0x1F2, %dx
	mov (%bp+12), %ax
	outb %al, %dx

	inc dx
	mov (%bp+4), %ax
	outb %al, %dx

	inc dx
	shr $8, %ax
	outb %al, %dx

	inc dx
	shr $8, %ax
	outb %al, %dx

	inc dx
	shr $8, %ax
	or $0xE0, %al
	outb %al, %dx
*/
	ret


.p2align 2

gdt:		SEG_NULL
gdt_code:	SEG_CODE
gdt_data:	SEG_DATA

gdt_ptr:
	.word	. - gdt
	.long	gdt


//.space	510 - ( . - _start )

//.word	0xaa55
