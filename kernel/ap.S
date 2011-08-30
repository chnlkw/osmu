#include "defs.h"
#include "pm.h"

.set	sel_code,	0x8
.set	sel_data,	0x10

.global AP_START_CODE
.global	AP_START_CODE_END

#.extern ap_start
#.extern sleep2
#.extern disp_int
#.extern	kern_stack

.text

AP_START_CODE:
.code16

	cli
	cld

	mov %cs, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %ss
	mov $0x0, %sp
	mov $0xB800, %ax
	mov %ax, %gs

#	inb $0x92, %al
#	orb $2, %al
#	outb %al, $0x92

	lgdt (gdt_ptr - AP_START_CODE)

	mov %cr0, %eax
	or $1, %eax
	mov %eax, %cr0

	ljmp $sel_code, $(AP_BOOT_ADDR + (pm_code -AP_START_CODE))
.code32

.p2align 2
pm_code:
	mov $sel_data, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs

#GET APIC_ID
	mov (0xFEE00020), %eax
#CALC AP StackTop
	shrl $24, %eax
	inc %eax
	mov $KERNEL_STACK_SIZE, %ecx
	mull %ecx
	add $kernel_stack, %eax
#SET SP
	mov %eax, %esp

#	mov $0x201000, %esp
#	push %eax
#	mov $disp_int, %eax
#	call *%eax

#	incw (0xB8000)
#	mov $ap_start, %eax
	mov $init64, %eax
	call *%eax
	hlt

.p2align 4

gdt:		SEG_NULL
gdt_code:	SEG_CODE
gdt_data:	SEG_DATA

gdt_ptr:
	.word	. - gdt -1
	.long	gdt - AP_START_CODE + AP_BOOT_ADDR

AP_START_CODE_END:
