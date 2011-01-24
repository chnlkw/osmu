%include "addr.inc"

org AddrOfLoader + OffsetOfLoader
jmp Start

%include "fat12head.inc"

%include "pm.inc"
[section .gdt]
l_gdt:			Descriptor 0, 0, 0
l_desc_flat_rw:		Descriptor 0, 0FFFFFh, DA_DRW|DA_32|DA_LIMIT_4K
l_desc_flat_c:		Descriptor 0, 0FFFFFh, DA_CR|DA_32|DA_LIMIT_4K
l_desc_flat_rw64:	Descriptor 0, 0FFFFFh, DA_DRW|DA_64|DA_LIMIT_4K
l_desc_flat_c64:	Descriptor 0, 0FFFFFh, DA_CR|DA_64|DA_LIMIT_4K
l_desc_video:		Descriptor 0B8000h, 0ffffh, DA_DRW|DA_DPL3
l_desc_tss:			Descriptor 0, TSSLen - 1, DA_386TSS
l_desc_stack:	Descriptor 0, StackTop, DA_DRWA + DA_32
l_desc_idt:		Descriptor 0,0FFFFFh, DA_CR|DA_32|DA_LIMIT_4K

gdtlen		equ	$ - l_gdt
gdtptr		dw	gdtlen
			dd	l_gdt
gdtptr64	dw	gdtlen
			dq	l_gdt

SelectorRW		equ l_desc_flat_rw - l_gdt
SelectorC		equ	l_desc_flat_c - l_gdt
SelectorRW64	equ l_desc_flat_rw64 - l_gdt
SelectorC64		equ	l_desc_flat_c64 - l_gdt
SelectorVideo	equ l_desc_video - l_gdt + SA_RPL3
SelectorTSS		equ l_desc_tss - l_gdt
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
	
;	mov ah, 2Eh
;	mov al, 'P'
;	mov edi, (80*3+39)*2
;	mov [gs:edi], ax

;	call Init8259A
	call DispMemInfo
;	call SetupPaging

;Install TSS
;	mov eax, LABEL_TSS
;	mov [l_desc_tss + 2], ax
;	shr eax, 16
;	mov [l_desc_tss + 4], al
;	mov [l_desc_tss + 7], ah
;	mov ax, SelectorTSS
;	ltr ax
	
mov edi, 160*13+40
	call Prepare64
;mov eax, 0FFFFFFFFh
;mov ecx, 0c0000080h
;rdmsr 
;	jmp SelectorC:(PM64start-256)
	jmp SelectorC64:(PM64start)
db 0xEA 
dd PM64start 
dw SelectorC64


;jmp PM64start
[section .s64]

align 64

[bits 64]

PM64start:
;	mov rsp, StackTop
;	lgdt [gdtptr64]
;	mov rax, 122
;	mul rax
;	mov cx, 0e00h + 'R'
;	mov [gs:100], cx
;	mov eax, 09740974h
;	mov [gs:102], eax
;mov rbx, 0967096609650964h 
;mov [gs:104], rbx
;shl rbx, 32
;shr rbx, 32
;mov rax, 0
;mov [gs:112], rbx
	
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

[section .tss]
align 32
[bits 32]
LABEL_TSS:
	DD	0			; Back
	DD	StackTop	; 0 级堆栈
	DD	SelectorStack	; 
	DD	0			; 1 级堆栈
	DD	0			; 
	DD	0			; 2 级堆栈
	DD	0			; 
	DD	0			; CR3
	DD	0			; EIP
	DD	0			; EFLAGS
	DD	0			; EAX
	DD	0			; ECX
	DD	0			; EDX
	DD	0			; EBX
	DD	0			; ESP
	DD	0			; EBP
	DD	0			; ESI
	DD	0			; EDI
	DD	0			; ES
	DD	0			; CS
	DD	0			; SS
	DD	0			; DS
	DD	0			; FS
	DD	0			; GS
	DD	0			; LDT
	DW	0			; 调试陷阱标志
	DW	$ - LABEL_TSS + 2	; I/O位图基址
	DB	0ffh			; I/O位图结束标志
	TSSLen	equ	$ - LABEL_TSS


