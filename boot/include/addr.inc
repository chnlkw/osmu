StackTop			equ 7bFFh
AddrOfBoot			equ	7c00h
AddrOfFAT			equ	AddrOfBoot + 512
BaseOfFAT			equ AddrOfFAT >> 4
AddrOfRootDir		equ AddrOfFAT + 2 * 9 * 512
BaseOfRootDir		equ AddrOfRootDir >> 4
BaseOfKernelBin		equ 8000h
OffsetOfKernelBin	equ 0
AddrOfLoader		equ 90000h
BaseOfLoader		equ	AddrOfLoader >> 4
OffsetOfLoader		equ 100h

OffsetOfData		equ	31

AddrOfPML4E	equ 100000h
AddrOfPDPTE	equ 101000h
AddrOfPDE	equ 102000h
AddrOfPTE	equ 103000h
	LONG_MODE_PTE_BASE   equ  0x123000
    LONG_MODE_PDE_BASE    equ 0x122000
    LONG_MODE_PDPE_BASE    equ 0x121000
    LONG_MODE_PML4E_BASE equ  0x120000

