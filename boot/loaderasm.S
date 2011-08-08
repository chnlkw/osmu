.extern cmain

.code32

.section loader.head

start:
	mov start, %sp
	cli
	cld
	jmp cmain

.globl sleep
sleep:
	incw (0xb8000)
	incw (0xb8002)
	jmp sleep
	ret

