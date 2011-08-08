#ifndef PROTECT_64_H

#define PROTECT_64_H

#define	CS_INDEX	1
#define DS_INDEX	2
#define	GS_INDEX	3
#define LDT_SIZE	4
#define	TSS_INDEX	4
#define LDT_INDEX	5
#define	GDT_SIZE	256

#define SELECTOR_NULL	0x0
#define SELECTOR_CS	0x10
#define SELECTOR_SS	0x20
#define SELECTOR_GS	0x30
#define SELECTOR_TSS	0x40
#define SELECTOR_LDT_H	0x50

#define TI_LDT	4
#define TI_GDT	0

#define RPL0	0
#define RPL1	1
#define RPL2	2
#define RPL3	3


#define	INT_VECTOR_DIVIDE	0
#define	INT_VECTOR_DEBUG	1
#define	INT_VECTOR_NMI		2
#define	INT_VECTOR_BREAKPOINT	3
#define	INT_VECTOR_OVERFLOW	4
#define	INT_VECTOR_BOUNDS	5
#define	INT_VECTOR_INVAL_OP	6
#define	INT_VECTOR_COPROC_NOT	7
#define	INT_VECTOR_DOUBLE_FAULT	8
#define	INT_VECTOR_COPROC_SEG	9
#define	INT_VECTOR_INVAL_TSS	10
#define	INT_VECTOR_SEG_NOT	11
#define	INT_VECTOR_STACK_FAULT	12
#define	INT_VECTOR_PROTECTION	13
#define	INT_VECTOR_PAGE_FAULT	14
#define	INT_VECTOR_COPROC_ERR	16
#define INT_VECTOR_ALIGN_FAULT	17
#define INT_VECTOR_MACHINE_NOT	18
#define INT_VECTOR_SIMD_FAULT	19

#define NON_ERR_CODE	0xFFFFFFFFFFFFFFFF

#define IDT_SIZE 256

#define	DESC_LIMIT_G	0x80

#define DESC_CODE_ACCESS 0x98
#define DESC_CODE_64 0x20	

#define DESC_DATA_ACCESS 0x92
#define DESC_TSS_ACCESS 0x89
#define DESC_LDT_ACCESS 0x82

#define GATE_ACCESS	0x8E00

#define DPL_SHIFT 5

#define	DPL0	(0<<DPL_SHIFT)
#define	DPL1	(1<<DPL_SHIFT)
#define	DPL2	(2<<DPL_SHIFT)
#define	DPL3	(3<<DPL_SHIFT)

#define PRIVILEGE_KRNL	0
#define PRIVILEGE_USER	3

#define ADDR_RSP0 0x201000
#define ADDR_RSP1 0x202000
#define ADDR_RSP2 0x203000

#define ADDR_IST1 0x204000
#define ADDR_IST2 0x205000
#define ADDR_IST3 0x206000
#define ADDR_IST4 0x207000
#define ADDR_IST5 0x208000
#define ADDR_IST6 0x209000
#define ADDR_IST7 0x210000

#define GS_BASE_ADDR 0xB8000

typedef struct s_desc
{
	t_16	limit_1;
	t_16	base_1;
	t_8	base_2;
	t_8	access;
	t_8	limit_2;
	t_8	base_3;
	t_32	base_4;
	t_32	ignored;
}DESCRIPTOR;

typedef struct s_gate
{
	t_16	off_1;
	t_16	selector;
	t_16	access;
	t_16	off_2;
	t_32	off_3;
	t_32	reserved;
}GATE;

typedef t_16 desc_ptr[5];

desc_ptr gdt_ptr;
desc_ptr idt_ptr;

typedef struct s_tss
{
	t_64	rev1;
	t_64	rsp0;
	t_64	rsp1;
	t_64	rsp2;
	t_64	rev2;
	t_64	ist1;
	t_64	ist2;
	t_64	ist3;
	t_64	ist4;
	t_64	ist5;
	t_64	ist6;
	t_64	ist7;
	t_64	rev3;
	t_16	rev4;
	t_16	iomap;
}TSS;

#endif
