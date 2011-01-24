%include 'addr.inc'

[bits 64]

[section .text]

global _start
extern stop

_start:
	mov rsp, AddrOfKernel - 1
	call stop
	mov ah, 0Fh
	mov al, 'K'
	mov [gs:((80*22+39)*2)], ax;
	jmp $

