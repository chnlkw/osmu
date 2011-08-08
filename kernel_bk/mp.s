
.extern ap_start_code
.extern ap_start_code_end
.extern memcpy

.globl init_mp

.equ AP_INIT_CODE_ADDR, 0x40000
.equ APIC_ID, 0x0FEE0000000000020

.extern disp_int

init_mp:
	mov $AP_INIT_CODE_ADDR, %rdi
	mov $ap_start_code, %rsi
	mov $ap_start_code_end, %rax
	mov $ap_start_code, %rcx
	sub %rcx, %rax
	mov %rax, %rdx
	call memcpy

	
	mov $APIC_ID, %rdi
	mov (%rdi), %rax
	call disp_int


	ret
