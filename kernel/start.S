#include "defs.h"

.global _start
.global sleep
.global AP_START_CODE
.global	AP_START_CODE_END

.extern cmain


.text

.code32

_start:
	cli
	cld
	movl $KERNEL_STACK_TOP, %esp
	movl $0x1B, %ecx
	rdmsr
	jmp cmain
	hlt

sleep:
	incw (0xB8050)
	jmp sleep
	ret

.code16
AP_START_CODE:
	cli
	cld
	movw $0xb800, %ax
	movw %ax, %gs
	incw %gs:0x0
	jmp .
	jmp AP_START_CODE
AP_START_CODE_END:

.string "aaaaa"
