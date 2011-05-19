.extern cmain

.code32

.text

.globl _start

start:
_start:
	mov _start, %sp
	cli
	cld
	jmp cmain

.globl sleep
sleep:
	incw (0xb8000)
	incw (0xb8002)
	jmp sleep
	ret

