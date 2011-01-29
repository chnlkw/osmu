global in_byte
global out_byte

in_byte:
	mov	edx, [esp+4]
	xor	eax, eax
	in	al, dx
	nop
	nop
	ret

out_byte:
	mov edx, [esp+4]
	mov al, [esp+8];
	out dx, al
	nop
	nop
	ret

