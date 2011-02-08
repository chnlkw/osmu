global in_byte
global out_byte
global disp_str

%define disp_line 160

disp_pos	dd	0

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

disp_str:
	mov ebx, [disp_pos]
.disp_str_loop:
	mov al, 0
	cmp al, byte [edi]
	je .disp_str_end
	mov al, 10
	cmp al, byte [edi]
	je .disp_enter
	mov al, byte [edi]
	mov ah, 0Fh
	mov [gs:ebx], ax
	inc ebx
	inc ebx
	inc edi
	jmp .disp_str_loop
.disp_enter:
	mov eax, ebx
	mov ebx, disp_line
	mov edx, 0
	div ebx
	inc eax
	mul ebx
	mov ebx, eax
	inc edi
	jmp .disp_str_loop
.disp_str_end:
	mov [disp_pos], ebx
	ret
