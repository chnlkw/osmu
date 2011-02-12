%include "addr.inc"

org AddrOfLoader + OffsetOfLoader
jmp Start

%include "fat12head.inc"

%include "pm.inc"
[section .gdt]
l_gdt:			Descriptor 0, 0, 0
l_desc_flat_c:		Descriptor 0, 0FFFFFh, DA_CR|DA_32|DA_LIMIT_4K
l_desc_flat_rw:		Descriptor 0, 0FFFFFh, DA_DRW|DA_32|DA_LIMIT_4K
l_desc_flat_c64:	Descriptor 0, 0FFFFFh, DA_CR|DA_64|DA_LIMIT_4K
l_desc_flat_rw64:	Descriptor 0, 0FFFFFh, DA_DRW|DA_64|DA_LIMIT_4K
l_desc_video:		Descriptor 0B8000h, 0ffffh, DA_DRW|DA_DPL3
l_desc_stack:	Descriptor 0, StackTop, DA_DRWA + DA_32

gdtlen		equ	$ - l_gdt
gdtptr		dw	gdtlen
			dd	l_gdt


gdtptr64	dw gdtlen - 8
			dq l_gdt


SelectorRW		equ l_desc_flat_rw - l_gdt
SelectorC		equ	l_desc_flat_c - l_gdt
SelectorRW64	equ l_desc_flat_rw64 - l_gdt
SelectorC64		equ	l_desc_flat_c64 - l_gdt
SelectorVideo	equ l_desc_video - l_gdt + SA_RPL3
SelectorStack	equ l_desc_stack - l_gdt

[section .16]
align 32
[bits 16]
Start:

	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, StackTop
	mov ax, 0B800h
	mov gs, ax

	mov ax, LoadMsg
	mov cx, LoadMsg_len
	inc dh
	call DispStr
	push dx
;Check Memory
	mov ebx, 0
	mov di, _MemChkBuf
.MemChkLoop:
	mov eax, 0E820h
	mov ecx, 20
	mov edx, 0534D4150h
	int 15h
	jc .MemChkFail
	add di, 20
	inc dword [_MemChkCnt]
	cmp ebx, 0
	jne .MemChkLoop
	jmp .MemChkOK
.MemChkFail:
	mov dword [_MemChkCnt], 0
.MemChkOK:

;	mov ah, 0Fh
;	mov al, 'L'
;	mov [gs:((80*0+29)*2)], ax

	mov bx, FileName
	call SearchFile

	cmp ax, 0FFFFh
	je NotFound

	mov bx, BaseOfKernelBin
	mov es, bx
	mov bp, 0
	call ReadFile

	call KillMotor

;Ready
	pop dx
	inc dh
	mov ax, ReadyMsg
	mov cx, ReadyMsg_len
	call DispStr
	
	lgdt [gdtptr]
	cli

	in al, 92h
	or al, 2
	out 92h, al
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp dword SelectorC:(PMstart)


NotFound:
	mov ax, NotFoundMsg
	mov cx, NotFoundMsg_len
	inc dh
	call DispStr
	jmp $

%include "fat12ctl.asm"


FileName	db "KERNEL  BIN"
LoadMsg	db "Loading"
LoadMsg_len	equ $-LoadMsg
NotFoundMsg db "NO KERNEL"
NotFoundMsg_len	equ $-NotFoundMsg
ReadyMsg db "Ready."
ReadyMsg_len equ $-ReadyMsg


[section .s32]

align 32

[bits 32]

%include "lib32.asm"


PMstart:
	mov ax, SelectorVideo
	mov gs, ax
	mov ax, SelectorRW
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov ss, ax
	mov esp, StackTop
	
	call DispMemInfo

	call Prepare64
	mov ax, SelectorRW64
	mov ss, ax
	jmp SelectorC64:(PM64start)

[section .s64]

align 64

[bits 64]

PM64start:


;lgdt [gdtptr64]
	call InitKernel
	mov rbx, [KernelEntry]

	jmp rbx

InitKernel:
	mov rbx, AddrOfKernelBin	
	mov rax, [rbx + e_entry]
	mov [KernelEntry], rax
	mov rcx, [rbx + e_phnum]
	and rcx, 0FFFFh
	mov rax, [rbx + e_phoff ]
	add rbx, rax

.LoopInitKernel:
	push rcx
	mov rcx, [rbx + p_filesz]
	mov rsi, [rbx + p_offset]
	add rsi, AddrOfKernelBin
	mov rdi, [rbx + p_vaddr]
	rep movsb
	pop rcx
	add rbx, 56
	loop .LoopInitKernel
	
	ret

KernelEntry	dq	0
e_entry	equ	0x18
e_phoff	equ	0x20
e_phnum equ 0x38
p_offset	equ	0x8
p_vaddr		equ 0x10
p_filesz	equ 0x20

_MemChkCnt:	dd 0
_MemChkBuf:	times 256 db 0
_MemSize:	dw 0
MemChkCnt 	equ _MemChkCnt
MemChkBuf	equ _MemChkBuf
MemSize		equ _MemSize

