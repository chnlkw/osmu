#include "defs.h"
#include "pm64.h"

.global _start
.global sleep
.global sleep64
.global init64

.extern cmain
.extern	kernel_stack

.global lock

.set	sel_code32,	0x08	
.set	sel_code64,	0x10	
.set	sel_data32,	0x18
.set	sel_data64,	0x20

.text

.code32

_start:
	cli
	cld
	movl $(kernel_stack + KERNEL_STACK_SIZE), %esp
	movl $0, disp_pos
#	call a2
#a2:
#	pop %eax
#	movl $(sleep - a2) , %ecx
#	addl %ecx, %eax
	jmp init64
#	call cmain
	hlt

sleep:
	incw (0xB8050)
	jmp sleep
	ret

init64:
	push %ebp
	mov %esp, %ebp

	mov %cr0, %eax
	and $0x7FFFFFFF, %eax
	mov %eax, %cr0

	sub $0x4, %esp
	movl $0x102000, (%esp)
	call mm_fill_page_table_32

	mov %cr4, %eax
	or $1<<5, %eax
	mov %eax, %cr4

	mov $0x102000, %eax
	mov %eax, %cr3

	mov $0xc0000080, %ecx
	rdmsr
	or $1<<8, %eax
	wrmsr

	mov %cr0, %eax
	or $0x80000000, %eax
	mov %eax, %cr0

	lgdt gdt_ptr
	ljmp $sel_code64, $start64

	hlt
#	leave
#	ret

.code64
start64:
	incw (0xb8000)
	call cmain
	hlt
	jmp start64

sleep64:
	incw (0xB8090)
	jmp sleep64
	ret
.data


.p2align 2


gdt:		SEG_NULL
gdt_code32:	SEG_CODE32
gdt_code64:	SEG_CODE64
gdt_data32:	SEG_DATA32
gdt_data64:	SEG_DATA64

gdt_ptr:
	.word	. - gdt
	.long	gdt
	.long	0x0

lock: .byte 0
