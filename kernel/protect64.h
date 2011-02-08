#ifndef PROTECT_64_H

#define PROTECT_64_H

#define CS_INDEX 1
#define DS_INDEX 2
#define GS_INDEX 3
#define GDT_SIZE 4

#define SELECTOR_C	0x10

#define	INT_VECTOR_DIVIDE		0x0
#define	INT_VECTOR_DEBUG		0x1
#define	INT_VECTOR_NMI			0x2
#define	INT_VECTOR_BREAKPOINT	0x3
#define	INT_VECTOR_OVERFLOW		0x4
#define	INT_VECTOR_BOUNDS		0x5
#define	INT_VECTOR_INVAL_OP		0x6
#define	INT_VECTOR_COPROC_NOT	0x7
#define	INT_VECTOR_DOUBLE_FAULT	0x8
#define	INT_VECTOR_COPROC_SEG	0x9
#define	INT_VECTOR_INVAL_TSS	0xA
#define	INT_VECTOR_SEG_NOT		0xB
#define	INT_VECTOR_STACK_FAULT	0xC
#define	INT_VECTOR_PROTECTION	0xD
#define	INT_VECTOR_PAGE_FAULT	0xE
#define	INT_VECTOR_COPROC_ERR	0x10


#define IDT_SIZE 256

#define DESC_CODE_ACCESS 0x98
#define DESC_CODE_64 0x20	

#define DESC_DATA_ACCESS 0x90

#define GATE_ACCESS	0x8E00


#define DPL_SHIFT 5

#define PRIVILEGE_KRNL	0

struct descriptor
{
	t_16	limit_1;
	t_16	base_1;
	t_8		base_2;
	t_8		access;
	t_8		limit_2;
	t_8		base_3;
	t_32	base_4;
	t_32	ignored;
};

struct gate
{
	t_16	off_1;
	t_16	selector;
	t_16	access;
	t_16	off_2;
	t_32	off_3;
	t_32	reserved;
};

typedef t_16 desc_ptr[5];


#endif
