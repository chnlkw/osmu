%include 'addr.inc'

[bits 64]

[section .text]

global _start

_start:
	mov rsp, AddrOfKernel - 1
	mov ah, 0Fh
	mov al, 'K'
	mov [gs:((80*22+39)*2)], ax;
	jmp $


