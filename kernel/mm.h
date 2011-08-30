#include "type.h"
#include "defs.h"

#ifndef __MEMORY_MANAGE__

#define __MEMORY_MANAGE__ 

#define	PG_P	0x1
#define	PG_R	0x0
#define	PG_W	0x2
#define	PG_U	0x0
#define	PG_S	0x4
#define	PG_PWT	0x8
#define	PG_PCD	0x10
#define	PG_A	0x20
#define	PG_D	0x40
#define PG_PAT	0x80
#define PG_G	0x100

#define	MM_COUNT_ENTRYS(x) ( (1LL<<(MAXPHYADDR-x>0?MAXPHYADDR-x:0))+1 )

struct page_table
{
	u64	pml4e[MM_COUNT_ENTRYS(39)]	__attribute__((aligned(1<<12)));
	u64	pdpte[MM_COUNT_ENTRYS(30)]	__attribute__((aligned(1<<12)));
	u64	pde[MM_COUNT_ENTRYS(21)]	__attribute__((aligned(1<<12)));
	u64	pte[MM_COUNT_ENTRYS(12)]	__attribute__((aligned(1<<12)));
};

typedef struct page_table PT;

extern	PT	pt_flat;

extern	u8	kernel_stack[MAX_CPU_AMOUNT][KERNEL_STACK_SIZE];

#endif
