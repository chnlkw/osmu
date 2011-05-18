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

.p2align 2

disp_pos:	.long	0
.equ disp_line, 160

gdt:		SEG_NULL
gdt_code:	SEG_CODE
gdt_data:	SEG_DATA

gdt_ptr:
	.word	. - gdt
	.long	gdt

