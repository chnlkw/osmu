.global _start

.text

_start:
	jmp sleep

sleep:
	incw (0xB8050)
	jmp sleep
	ret

.string "aaaaa"
