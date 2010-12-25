

 USE16
    org 0x8000
       REAL_MODE_STACK_TOP EQU 0x7C00 - 1
    CODE_SEL EQU CODE_DSCR - DUMMY_DSCR   ; code segment selector
    DATA_SEL EQU DATA_DSCR - DUMMY_DSCR   ; data segment selector
    
    LONG_MODE_RSP3   EQU    0xA0000 - 1
    LONG_MODE_RSP31    EQU    0xA0000 - 1 - 4 * 1024
    LONG_MODE_RSP0    EQU    0x120000 - 1 
    LONG_MODE_RSP1    EQU    0x120000 - 1 - 4 * 1024
    LONG_MODE_RSP2   EQU    0x120000 - 1 - 8 * 1024
    LONG_MODE_PTE_BASE   equ  0x123000
    LONG_MODE_PDE_BASE    equ 0x122000
    LONG_MODE_PDPE_BASE    equ 0x121000
    LONG_MODE_PML4E_BASE equ  0x120000
    
jmp 0x0:CODE16    ; jump to 16 bit code, initialize base enviroment
ALIGN 4
GDTR32    dw GDT_END - GDT - 1
        dd GDT
ALIGN 4
        
PRINT_16:
    push ax
    push bx
    push si
 .NEW_CHAR:
    lodsb
    or  al, al
    jz  short .EXIT_PRINT_16
    mov ah, 0x0E
    mov bx, 0x0007
    int 0x10
    jmp short .NEW_CHAR
 .EXIT_PRINT_16:
    pop si
    pop bx
    pop ax
    ret

MSG_NO_LONG_MODE db 'Current CPU dose not support LONG mode',13,10,0
NO_LONG_MODE:
    cli
    mov si,MSG_NO_LONG_MODE
    call PRINT_16
    hlt
    jmp $   ; halt here

        
; 16 bit main start
CODE16:
    ; initialize 16 bit registers
    cli
    mov ax, cs
    mov ds, ax
    mov es, ax
    xor ax, ax
    mov ss, ax
    mov sp, REAL_MODE_STACK_TOP

    ; check if x64 long mode is supported
    ; AMD document for details about this check
    ; NOTE: I suppose CPU is 386+, maybe I should
    ;   do another check
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000000
    jbe NO_LONG_MODE
    mov eax, 0x80000001
    cpuid
    bt  edx, 29
    jnc NO_LONG_MODE
      
    ; prepare for protect mode
    ; load gdtr
    ; enable cr0.pe
    cli
    ; enable A20 gate
    
    in      al,92h
    or      al,00000010b
    out     92h,al
               
    mov  eax, cr0
    or   eax, 1
    mov  cr0, eax

    mov bx, DATA_SEL
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    mov ss, bx
    mov esp, 0x7C00 - 1
    
    ; make a far jump to enter protect mode
    db 0xEA
    dw CODE32
    dw CODE_SEL

;--------------- PROTECT MODE ----------
;................  FOR protect mode  ...................    
ALIGN 16
GDT:
DUMMY_DSCR    dw 0
            dw 0
            dw 0
            dw 0    ; reserved by i386 CPU

CODE_DSCR    dw 0xFFFF
            dw 0x0000
            db 0x00
            db 0x9A
            db 0xCF
            db 0x00

DATA_DSCR    dw 0xFFFF
            dw 0x0000
            db 0x00
            db 0x92
            db 0xCF
            db 0x00
                        
    CODE64_SELECTOR        equ  .CODE_DESCRIPTOR - GDT
    .CODE_DESCRIPTOR    dw 0xFFFF
                        dw 0x0000
                        db 0x00
                        db 0x9A
                        db 0x20
                        db 0x00
                        
    DATA64_SELECTOR        equ    .DATA_DESCRIPTOR - GDT
    .DATA_DESCRIPTOR    dw 0xFFFF
                        dw 0x0000
                        db 0x00
                        db 0x92
                        db 0xCF
                        db 0x00
                        
    TSS64_SELECTOR        equ    .TSS_DESCRIPTOR - GDT
    .TSS_DESCRIPTOR        dw TSS64_END - TSS64 - 1
                        dw TSS64
                        db 0x00
                        db 0x89        ; available TSS
                        db 0x80
                        db 0x00
                        dd 0x00000000
                        dd 0x00000000
   CODE64_SELECTOR3        equ    .CODE_DESCRIPTOR3 - GDT+3
    .CODE_DESCRIPTOR3    dw 0xFFFF
                        dw 0x0000
                        db 0x00
                        db 0xfA  ;3级代码段
                        db 0x20
                        db 0x00                     

DATA64_SELECTOR3        equ    .DATA_DESCRIPTOR3 - GDT+3
    .DATA_DESCRIPTOR3    dw 0xFFFF
                        dw 0x0000
                        db 0x00
                        db 0xf2
                        db 0xCF
                        db 0x00                        
GDT_END:
;---------- FOR LONG MODE -----------
ALIGN 4
GDTR64    dw GDT_END - GDT - 1
        dq GDT
        

ALIGN 16
TSS64:
    dd 0    ; reserved, ingore
    dq LONG_MODE_RSP0
    dq LONG_MODE_RSP1
    dq LONG_MODE_RSP2
    dq 0    ; reserved
    times 7 dq LONG_MODE_RSP0
    dq 0
    dw 0
    dw $ + 2
    db 0xff
TSS64_END:
USE32

CODE32:
;初始化PML4E
    mov edi,LONG_MODE_PML4E_BASE
    mov [edi],dword LONG_MODE_PDPE_BASE+7
    add edi,4
    xor ebx,ebx
    mov [edi],ebx
    add edi,4
    mov ecx,511
.NPML:    
    mov [edi],ebx
    add edi,4
    mov [edi],ebx
    add edi,4
    loop .NPML

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
    db 0xEA
    dd CODE64
    dw CODE64_SELECTOR
                   
PROTECT_MODE_EXCEPTION_HANDLE:
    iretd
    
; Dump eax to screen
HEX_TABLE    db '0', '1', '2', '3', '4', '5', '6', '7'
            db '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'

    
USE64
LONG_MODE_EXCEPTION_HANDLE1:
    iretq

CODE64:
    mov rax, DATA64_SELECTOR
    mov ds, ax
    mov es, ax
    xor ax,ax
    mov ss, ax
    mov fs, ax
    mov gs, ax
    mov rsp, LONG_MODE_PML4E_BASE - 1
    mov rbx, GDTR64
    lgdt [rbx]
         
    mov ax, TSS64_SELECTOR
    ltr ax
   
    mov rax, LONG_MODE_PML4E_BASE
    mov cr3, rax
    
    mov [0xB8050], byte 'L'
    mov [0xB8051], byte 13
    
    mov [0xB8060], byte '0'
    mov [0xB8061], byte 13
	jmp $
