ReadSector: ;sector ax count cl putinto es:bx
	push dx
	push bp
	mov bp, sp
	sub esp, 2
	mov byte [bp-2], cl
	push bx

	mov bl, [BPB_SecPerTrk]

	div bl

	inc ah
	mov cl, ah
	mov dh, al
	shr al, 1

	mov ch, al
	and dh, 1
	pop bx

	mov dl, [BS_DrvNum] ;
.GoOnReading :
	mov ah, 2
	mov al, byte [bp-2]
	int 13h
	jc .GoOnReading

	add esp, 2
	pop bp
	pop dx
	ret

SearchFile:	;	FileName bx  Return ax as SectorNum, 0FFFFh on error 
;mov ax, 0FFFFh
;ret
	mov cx, [BPB_RootEntCnt]
	dec cx
	cld
	mov di, BaseOfRootDir
	mov es, di
	mov di, 0
.NextDir:
mov ax, di
	mov si, bx
	push cx
	mov cx, 11
	repe cmpsb
	je .Found
	mov ax, di
	and ax, 0xFFE0
	add ax, 32
	mov di, ax
	pop cx
;mov ax, cx
;call Show
	loop .NextDir
.NotFound:
	mov ax, 0FFFFh
	ret
	
.Found:
	;mov ax, LoadMsg
	;mov cx, LoadMsg_len
	;inc dh
	;call DispStr
	pop cx
	and di, 0xFFE0
	mov ax, [es:di+0x1A]
	ret

ReadFile:		;ax StartSector	es:bp BaseOfFile:OffsetOfFile
	mov bx, BaseOfFAT
	mov fs, bx
	mov cl, 1
.GoOnReading:
	cmp ax, 0FFFh
	je .ReadFinish 
	push ax
	add ax, OffsetOfData
	mov bx, bp
	add bp, 512
	call ReadSector
	pop ax

	mov bl, 2
	div bl
	mov ch, ah
	mov bl, 3
	mul bl
	mov bx, ax
	;mov bh, 0
	cmp ch, 1
	je .1
.0:
	mov ax, [fs:bx]
	and ax, 0FFFh
	jmp .GoOnReading
.1:
	mov ax, [fs:bx+1]
	shr ax, 4
	jmp .GoOnReading
.ReadFinish:
	ret

Show: ;Show ax
	push ax
	push bx
	push cx
	mov cx, ax
	mov bx, [CurLine]
	mov ah, 0Fh
	mov al, ch
	add al, '0'
	mov [gs:bx+80], ax
	mov al, cl
	add al, '0'
	mov [gs:bx+82], ax
	add bx, 160
	mov [CurLine], bx
	pop cx
	pop bx
	pop ax
	ret

CurLine dw 0

ClearScreen:
	mov ax, 600h	;Clear
	mov bx, 700h
	mov cx, 0
	mov dx, 184Fh
	int 10h
	ret

DispStr:	;ax String  cx Length

	push es
	push bp
	mov bp, ax
	mov ax, ds
	mov es, ax
	mov ax, 1301h
	mov bx, 0007h
	int 10h
	pop bp
	pop es
	ret

KillMotor:
	push dx
	mov dx, 03F2h
	mov al, 0
	out dx, al
	pop dx
	ret
