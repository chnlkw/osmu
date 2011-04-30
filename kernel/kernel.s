.extern cstart

.globl _start
.globl ap_start_code
.globl ap_start_code_end
.globl ap_start_code_size

.code64

_start:
	mov $1, %rax
	cpuid
	call cstart
	jmp .

.code16
ap_start_code:
	cli
	cld
	mov %cs, %ax
	mov %ax, %ss
	mov $0, %sp
	mov $0xb800, %ax
	mov %ax, %gs
	incb %gs:0
.size ap_start_code_size, .-ap_start_code
ap_start_code_end:
