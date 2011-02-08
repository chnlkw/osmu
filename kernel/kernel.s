%include "protect64.inc" ; Same as "protect64.h"

%define K_STACK_BYTES 1024

extern cstart
extern gdt_ptr
extern idt_ptr
extern exception_handler

global _start
global divide_error

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
	lidt [idt_ptr]

	mov rbx, 0
	div rbx

	jmp $

;exception handelers

divide_error:
	mov rdi, INT_VECTOR_DIVIDE
	jmp exception

exception:
mov al, '!'
mov ah, 0Ch
mov [gs:0], ax
	call exception_handler
	jmp $
	hlt

[section .bss]
	resb K_STACK_BYTES
StackTop:

