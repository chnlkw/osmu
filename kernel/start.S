#include "defs.h"

.global _start
.global sleep
.global sleep2

.extern cmain
.extern	kernel_stack

.text

.code32

_start:
	cli
	cld
	movl $(kernel_stack + KERNEL_STACK_SIZE), %esp
#	call a2
#a2:
#	pop %eax
#	movl $(sleep - a2) , %ecx
#	addl %ecx, %eax

	call cmain
	hlt

sleep:
	incw (0xB8050)
	jmp sleep
	ret

sleep2:
	incw (0xB8070)
	jmp sleep
	ret

