#ifndef PROTECT_64_H

#define PROTECT_64_H

#define CS_INDEX 1
#define DS_INDEX 2
#define GS_INDEX 3
#define GDT_SIZE 4

#define SELECTOR_C	0x10

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

#define DESC_CODE_ACCESS 0x98
#define DESC_CODE_64 0x20	

#define DESC_DATA_ACCESS 0x90

#define GATE_ACCESS	0x8E00

#define DPL_SHIFT 5

#define PRIVILEGE_KRNL	0
#define PRIVILEGE_USER	3

struct descriptor
{
	t_16	limit_1;
	t_16	base_1;
	t_8	base_2;
	t_8	access;
	t_8	limit_2;
	t_8	base_3;
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
