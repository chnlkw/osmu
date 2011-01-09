%include "addr.inc"

org AddrOfBoot
	jmp short Start
%include "fat12head.inc"


Start:
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, AddrOfBoot
	mov ax, 0B800h
	mov gs, ax

	call ClearScreen
	
	mov ax, BootMsg
	mov cx, BootMsg_len
	mov dx, 00000h
	call DispStr 

	mov ah, 0	;Reset Floppy
	mov dl, 0
	int 13h

	mov bx, BaseOfFAT
	mov es, bx
	mov bx, 0
	mov ax, 1	;Read FATs and RootDirs
	mov cl, 32	;equ 9 * 2 + 224 * 32 / 512
	call ReadSector

	mov bx, FileName
	call SearchFile

	cmp ax, 0FFFFh
	je NotFound

	mov bx, BaseOfLoader
	mov es, bx
	mov bp, OffsetOfLoader
	Call ReadFile

StartLoader:
	inc dh
	jmp BaseOfLoader:OffsetOfLoader

NotFound:
	mov ax, NotFoundMsg
	mov cx, NotFoundMsg_len
	inc dh
	call DispStr
	jmp $

FileName	db "LOADER  BIN"
BootMsg		db "Booting"
BootMsg_len	equ $-BootMsg
NotFoundMsg db "loader.bin not found"
NotFoundMsg_len	equ $-NotFoundMsg

%include "fat12ctl.asm"

	times 510-($-$$)	db 0
	dw	0xaa55
