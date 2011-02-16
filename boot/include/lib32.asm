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

Prepare64:
	;CR0.PG=0
	;mov eax, cr0
	;and eax, 07FFFFFFFh
	;mov cr0, eax
SetPML4E:	
	mov edi, AddrOfPML4E
	mov eax, AddrOfPDPTE | PG_P | PG_USS | PG_RWR
	mov [edi], eax
	mov ecx, 1023
.LoopPML:
	add edi, 4
	mov [edi], dword 0
	loop .LoopPML

SetPDPTE:
	mov edi, AddrOfPDPTE
	mov eax, AddrOfPDE | PG_P | PG_USS | PG_RWR
	mov [edi], eax
	mov ecx, 1023
.LoopPDPTE:
	add edi, 4
	mov [edi], dword 0
	loop .LoopPDPTE
SetPDE:
	mov edi, AddrOfPDE
	mov eax, [MemSize]
	mov edx, 0
	mov ebx, 200000h
	div ebx
	push eax
	mov ecx, eax
	mov eax, AddrOfPTE | PG_P | PG_USS | PG_RWR
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
	mov eax,0 | PG_P | PG_USS | PG_RWR
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
	or eax, 80000000h
	mov cr0, eax
	ret

