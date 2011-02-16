%include "protect64.inc" ; Same as "protect64.h"

%define K_STACK_BYTES 1024

extern	cstart
extern	main
extern	gdt_ptr
extern	idt_ptr
extern	exception_handler
extern	spurious_irq
extern	p_proc_ready
extern	clock_handler
extern	disp_int
extern	disp_str

global	_start
global	restart
global	divide_error
global	single_step_exception
global	nmi
global	breakpoint_exception
global	overflow
global	bounds_check
global	inval_opcode
global	copr_not_available
global	double_fault
global	copr_seg_overrun
global	inval_tss
global	segment_not_present
global	stack_exception
global	general_protection
global	page_fault
global	copr_error
global	align_fault
global	machine_abort
global	simd_fault
global	hwint00
global	hwint01
global	hwint02
global	hwint03
global	hwint04
global	hwint05
global	hwint06
global	hwint07
global	hwint08
global	hwint09
global	hwint10
global	hwint11
global	hwint12
global	hwint13
global	hwint14
global	hwint15

REGS_TOP	equ	23*8

[bits 64]

[section .text]

_start:
	mov rsp, StackTop
	mov rbp, rsp
;	mov ah, 0Fh
;	mov al, 'K'
;	mov [gs:((80*22+39)*2)], ax
	call cstart

	lgdt [gdt_ptr]
	lidt [idt_ptr]
	mov ax, SELECTOR_TSS
	ltr ax
	mov ax, SELECTOR_DS
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov ax, SELECTOR_GS
	mov gs, ax
	push SELECTOR_DS
	push StackTop
	pushf
	push SELECTOR_CS
	push cs_init
	iretq
cs_init:
	sti
	jmp main
	hlt

restart:
	mov	rsp, [p_proc_ready]	
	pop	rax
	lldt	ax
	pop	rax
	pop	rbx
	pop	rcx
	pop	rdx
	pop	rbp
	pop	rsi
	pop	rdi
	pop	r8
	pop	r9
	pop	r10
	pop	r11
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	fs
	pop	gs
	iretq

	
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
	jmp exception

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
	mov ax, SELECTOR_GS
	mov gs, ax
	call exception_handler
	jmp $


%macro	hwint_master	1
	mov	rdi, %1
	call	spurious_irq
	hlt
%endmacro


ALIGN	16
hwint00:		; Interrupt routine for irq 0 (the clock).
	mov rsp, [p_proc_ready]
	add rsp, REGS_TOP - 5*8
	push gs
	push fs
	push r15
	push r14
	push r13
	push r12
	push r11
	push r10
	push r9
	push r8
	push rdi
	push rsi
	push rbp
	push rdx
	push rcx
	push rbx
	push rax

	lea rsp, [ADDR_IST2 - 5*8]
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	mov rsp, [p_proc_ready]
	add rsp, REGS_TOP
	push r10
	push r11
	push r12
	push r13
	push r14

	mov rsp, ADDR_IST2

	mov ax, [gs:158]
	inc ah
	mov [gs:158], ax
	

	mov al, 0x20
	out 0x20, al

	call clock_handler

	mov	rsp, [p_proc_ready]	
	pop	rax
	lldt	ax
	pop	rax
	pop	rbx
	pop	rcx
	pop	rdx
	pop	rbp
	pop	rsi
	pop	rdi
	pop	r8
	pop	r9
	pop	r10
	pop	r11
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	fs
	pop	gs
	iretq

ALIGN	16
hwint01:		; Interrupt routine for irq 1 (keyboard)
	hwint_master	1

ALIGN	16
hwint02:		; Interrupt routine for irq 2 (cascade!)
	hwint_master	2

ALIGN	16
hwint03:		; Interrupt routine for irq 3 (second serial)
	hwint_master	3

ALIGN	16
hwint04:		; Interrupt routine for irq 4 (first serial)
	hwint_master	4

ALIGN	16
hwint05:		; Interrupt routine for irq 5 (XT winchester)
	hwint_master	5

ALIGN	16
hwint06:		; Interrupt routine for irq 6 (floppy)
	hwint_master	6

ALIGN	16
hwint07:		; Interrupt routine for irq 7 (printer)
	hwint_master	7

; ---------------------------------
%macro	hwint_slave	1
	mov	rdi, %1
	call	spurious_irq
	add	esp, 4
	hlt
%endmacro
; ---------------------------------

ALIGN	16
hwint08:		; Interrupt routine for irq 8 (realtime clock).
	hwint_slave	8

ALIGN	16
hwint09:		; Interrupt routine for irq 9 (irq 2 redirected)
	hwint_slave	9

ALIGN	16
hwint10:		; Interrupt routine for irq 10
	hwint_slave	10

ALIGN	16
hwint11:		; Interrupt routine for irq 11
	hwint_slave	11

ALIGN	16
hwint12:		; Interrupt routine for irq 12
	hwint_slave	12

ALIGN	16
hwint13:		; Interrupt routine for irq 13 (FPU exception)
	hwint_slave	13

ALIGN	16
hwint14:		; Interrupt routine for irq 14 (AT winchester)
	hwint_slave	14

ALIGN	16
hwint15:		; Interrupt routine for irq 15
	hwint_slave	15


[section .bss]
	resb K_STACK_BYTES
StackTop:

