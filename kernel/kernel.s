%include "protect64.inc" ; Same as "protect64.h"

%define K_STACK_BYTES 1024

extern cstart
extern gdt_ptr

global _start

[bits 64]

[section .text]

_start:
	mov rsp, StackTop
	mov rbp, rsp
	mov ah, 0Fh
	mov al, 'K'
	mov [gs:((80*22+39)*2)], ax

	call cstart

	lgdt [gdt_ptr]

	jmp $

[section .bss]
	resb K_STACK_BYTES
StackTop:

