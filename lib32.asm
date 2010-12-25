DispAL: ; Show al in hex mode
	push ebx
	push ecx
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
	pop ecx
	pop ebx
	ret

DispEAX:
	push ecx
	mov ecx, 4
.3:
	rol eax, 8
	call DispAL
	loop .3
	mov cx, 0c00h + 'h'
	mov [gs:edi], cx
	add edi, 4
	pop ecx
	ret

DispMemInfo:
	mov edi, 160*6
	mov ecx, [MemChkCnt]
	mov esi, MemChkBuf
.ShowEach:
	mov eax, [esi]
	add eax, [esi+8]
	cmp eax, [MemSize]
	jng .noupdate
	mov [MemSize], eax
.noupdate:
	mov eax, [esi]
	add esi, 4
	call DispEAX
	mov eax, [esi]
	add esi, 4
	call DispEAX
	mov eax, [esi]
	add esi, 4
	call DispEAX
	mov eax, [esi]
	add esi, 4
	call DispEAX
	mov eax, [esi]
	add esi, 4
	call DispEAX
	add edi, 60
	loop .ShowEach
	
	mov eax,[MemSize]
	call DispEAX
	ret

SetupPaging:
	mov edx, 0
	mov eax, [MemSize]
	mov ebx, 400000h ;SizePerPDE = 4M
	mov edx, 0
	div ebx
	cmp edx, 0
	je .no_remain
	inc eax
.no_remain:
	push eax
	mov ecx, eax
	mov ax, SelectorRW
	mov es, ax
	mov edi, AddrOfPDE
	mov eax, 0
	mov eax, AddrOfPTE | PG_P | PG_USU | PG_RWW
.1:
	stosd
	add eax, 4096
	loop .1

	pop eax
	mov ebx, 1024
	mul ebx
	mov ecx, eax
	mov edi, AddrOfPTE
	mov eax, 0
	mov eax, PG_P | PG_USU | PG_RWW
.2:
	stosd
	add eax, 4096
	loop .2
	
	mov eax, AddrOfPDE
	mov cr3, eax
	mov eax, cr0
	or eax, 80000000h
	mov cr0, eax
	ret

io_delay:
	nop
	nop
	nop
	nop
	ret

; Init8259A ---------------------------------
Init8259A:
	mov	al, 011h
	out	020h, al	; 主8259, ICW1.
	call	io_delay

	out	0A0h, al	; 从8259, ICW1.
	call	io_delay

	mov	al, 020h	; IRQ0 对应中断向量 0x20
	out	021h, al	; 主8259, ICW2.
	call	io_delay

	mov	al, 028h	; IRQ8 对应中断向量 0x28
	out	0A1h, al	; 从8259, ICW2.
	call	io_delay

	mov	al, 004h	; IR2 对应从8259
	out	021h, al	; 主8259, ICW3.
	call	io_delay

	mov	al, 002h	; 对应主8259的 IR2
	out	0A1h, al	; 从8259, ICW3.
	call	io_delay

	mov	al, 001h
	out	021h, al	; 主8259, ICW4.
	call	io_delay

	out	0A1h, al	; 从8259, ICW4.
	call	io_delay

	mov	al, 11111110b	; 仅仅开启定时器中断
	;mov	al, 11111111b	; 屏蔽主8259所有中断
	out	021h, al	; 主8259, OCW1.
	call	io_delay

	mov	al, 11111111b	; 屏蔽从8259所有中断
	out	0A1h, al	; 从8259, OCW1.
	call	io_delay

	ret
; Init8259A ------------------------------------------

Prepare64:
	;CR0.PG=0
	mov eax, cr0
	and eax, 07FFFFFFFh
	mov cr0, eax
	
SetPML4E:	
	mov edi, AddrOfPML4E
	mov eax, AddrOfPDPTE | PG_P | PG_USU | PG_RWW
	mov [edi], eax
	mov ecx, 1023
.LoopPML:
	add edi, 4
	mov [edi], dword 0
	loop .LoopPML

SetPDPTE:
	mov edi, AddrOfPDPTE
;	mov eax, 0 | PG_P | PG_USU | PG_RWW | PG_PS
	mov eax, AddrOfPDE | PG_P | PG_USU | PG_RWW ; | PG_PS
	mov [edi], eax
	mov ecx, 1023
.LoopPDPTE:
	add edi, 4
	mov [edi], dword 0
	loop .LoopPDPTE

SetPDE:
	mov edi, AddrOfPDE
	mov eax, [MemSize]
	mov ebx, 200000h
	div ebx
	push eax
	mov ecx, eax
	mov eax, AddrOfPTE | PG_P | PG_USU | PG_RWW
.LoopPDE:
	stosd
	add eax, 4096
	mov [edi], dword 0
	add edi, 4
	loop .LoopPDE

SetPTE:
	pop eax,
	mov ebx, 512
	mul ebx
	mov ecx, eax
	mov edi, AddrOfPTE
	mov eax,0 | PG_P | PG_USU | PG_RWW
.LoopPTE:
	stosd
	add eax, 4096
	mov [edi], dword 0
	add edi, 4
	loop .LoopPTE
	
mov edi, 160*16+ 40
;CR4.PAE=1
	mov eax, cr4
	or eax, 1<<5
	mov cr4, eax
;CR3 := Address of PML4E
	mov eax, AddrOfPML4E
	mov cr3, eax
;IA32_EFER.LME=1
	mov ecx, 0c0000080h
	rdmsr 
	or eax, 1<<8
	wrmsr
;CR0.PG=1
	mov eax, cr0
	;and eax,    1FFFFFFFh
	or eax, 80000000h
call DispEAX
	mov cr0, eax
call DispEAX
mov eax, cr0
call DispEAX
	ret
;
;DEAD:jmp $
Prepare64_2:
	mov edi,LONG_MODE_PML4E_BASE
    mov [edi],dword LONG_MODE_PDPE_BASE+7
    add edi,4
    xor ebx,ebx
    mov [edi],ebx
    add edi,4
    mov ecx,511
.npml:    
    mov [edi],ebx
    add edi,4
    mov [edi],ebx
    add edi,4
    loop .npml

;初始化PDPE    
    mov [edi],dword LONG_MODE_PDE_BASE+7
    add edi,4
    mov [edi],ebx
    add edi,4
    mov ecx,511
.NPDE:
    mov [edi],ebx
    add edi,4
    mov [edi],ebx
    add edi,4
    loop .NPDE        
    
;初始化PDE    
    mov eax,LONG_MODE_PTE_BASE+7
    mov [edi],eax
    add edi,4
    mov edi,ebx
    add edi,4
    mov ecx,15
.NPTE:
    add eax,0x1000
    mov [edi],eax
    add edi,4
    mov edi,ebx
    add edi,4   
    loop .NPTE
    mov ecx,512-16
.NPTE1:    
    mov [edi],ebx
    add edi,4
    mov [edi],ebx
    add edi,4
    loop .NPTE1
 
;初始化PTE    
   mov edi,LONG_MODE_PTE_BASE
   mov eax, 1
   mov ecx,512*16
.NPP:   
   mov [edi],eax
   add edi,4
   mov [edi],ebx
   add edi,4
   add eax,0x1000
   loop .NPP 
   
   ;保留前32k内存，开放32K以后到C0000之前的内存给ring3
   mov edi,LONG_MODE_PTE_BASE+0x8*8
   mov eax, 0x8*0x1000+7
   mov ecx, 183
.NP2:   
   mov [edi],dword eax
   add eax,0x1000
   add edi,8    
   loop .NP2 

 	mov eax, cr0
	and eax, 07FFFFFFFh
	mov cr0, eax
	
mov edi, 160*16+ 40
;CR4.PAE=1
	mov eax, cr4
	or eax, 1<<5
	mov cr4, eax
;CR3 := Address of PML4E
	mov eax, LONG_MODE_PML4E_BASE
	mov cr3, eax
;IA32_EFER.LME=1
	mov ecx, 0c0000080h
	rdmsr 
	or eax, 1<<8
	wrmsr
;CR0.PG=1
	mov eax, cr0
	;and eax,    1FFFFFFFh
	or eax, 80000000h
call DispEAX
	mov cr0, eax
call DispEAX
mov eax, cr0
call DispEAX
jmp $	
 	;CR0.PG=0
	mov eax, cr0
	and eax, 07FFFFFFFh
	mov cr0, eax
	
   
    mov eax, cr4
    bts eax, 5
    mov cr4, eax

    mov eax, LONG_MODE_PML4E_BASE
    mov cr3, eax
    
    mov ecx, 0xC0000080
    rdmsr
    bts eax, 8
    wrmsr

    mov eax, cr0
    and eax, 0x1FFFFFFF
    bts eax, 31
    mov cr0, eax
	jmp $
