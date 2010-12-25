DispAL: ; Show al in hex mode
	push rbx
	push rcx
	mov ecx, 2
.1:
	rol al, 4
	mov bl, al
	and bl, 0Fh
	cmp bl, 10
	js .2
	add bl, 'A'-'0'-10
.2:
	add bl, '0'
	mov bh, 0ch
	mov [gs:edi], bx
	add edi, 2
	loop .1
	pop rcx
	pop rbx
	ret

DispEAX:
	push rcx
	mov ecx, 4
.3:
	rol eax, 8
	call DispAL
	loop .3
	mov cx, 0c00h + 'h'
	mov [gs:edi], cx
	add edi, 4
	pop rcx
	ret
