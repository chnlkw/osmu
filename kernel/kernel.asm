[bits 64]
db 'STAR'
[section .text]

global _start

_start:
	mov ah, 0Fh
	mov al, 'K'
	mov [gs:((80*22+39)*2)], ax;
	jmp $

	db 'EndOFKernel'

[section .data]
	db '@@data@@'
