%include "protect64.inc" ; Same as "protect64.h"

%define K_STACK_BYTES 1024

extern cstart
extern gdt_ptr
extern idt_ptr
extern exception_handler

global _start
global divide_error
global single_step_exception
global nmi
global breakpoint_exception
global overflow
global bounds_check
global inval_opcode
global copr_not_available
global double_fault
global copr_seg_overrun
global inval_tss
global segment_not_present
global stack_exception
global general_protection
global page_fault
global copr_error
global align_fault
global machine_abort
global simd_fault
	
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

ud2
	mov rbx, 0
	div rbx

	jmp $

;exception handelers

divide_error:
	mov rdi, 0
	mov rsi, NON_ERR_CODE
	jmp exception

single_step_exception:
	mov rdi, 1
	mov rsi, NON_ERR_CODE
	jmp exception

nmi:
	mov rdi, 2
	mov rsi, NON_ERR_CODE
	jmp exception

breakpoint_exception:
	mov rdi, 3
	mov rsi, NON_ERR_CODE
	jmp exception

overflow:
	mov rdi, 4 
	mov rsi, NON_ERR_CODE
	jmp exception

bounds_check:
	mov rdi, 5
	mov rsi, NON_ERR_CODE
	jmp exception

inval_opcode:
	mov rdi, 6
	mov rsi, NON_ERR_CODE
	jmp exception

copr_not_available:
	mov rdi, 7
	mov rsi, NON_ERR_CODE
	jmp exception

double_fault:
	mov rdi, 8
	pop rsi
	jmp	exception

copr_seg_overrun:
	mov rdi, 9
	mov rsi, NON_ERR_CODE
	jmp exception

inval_tss:
	mov rdi, 10
	pop rsi
	jmp exception

segment_not_present:
	mov rdi, 11
	pop rsi
	jmp exception

stack_exception:
	mov rdi, 12
	pop rsi
	jmp exception

general_protection:
	mov rdi, 13
	pop rsi
	jmp exception

page_fault:
	mov rdi, 14
	pop rsi
	jmp exception

copr_error:
	mov rdi, 16
	mov rsi, NON_ERR_CODE
	jmp exception

align_fault:
	mov rdi, 17
	pop rsi
	jmp exception

machine_abort:
	mov rdi, 18
	mov rsi, NON_ERR_CODE
	jmp exception

simd_fault:
	mov rdi, 19
	mov rsi, NON_ERR_CODE
	jmp exception

exception:
	call exception_handler
	hlt

[section .bss]
	resb K_STACK_BYTES
StackTop:

