#include "type.h"
#include "protect64.h"

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

struct descriptor gdt[GDT_Size];

typedef t_16 desc_ptr[5];

desc_ptr gdt_ptr;

void init_CS(struct descriptor* desc, int DPL)
{
	desc->access=DESC_CODE_ACCESS | (DPL<<DPL_SHIFT);
	desc->limit_2=DESC_CODE_64;
}

void init_DS(struct descriptor* desc)
{
	desc->access=DESC_DATA_ACCESS;
}

t_64 init_gdt()
{
	init_CS(gdt+CS_INDEX, 0);
	init_DS(gdt+DS_INDEX);
	gdt_ptr[0]=sizeof gdt;
	*(t_64*)(gdt_ptr+1)=(t_64)&gdt;
	return (t_64)&gdt_ptr;
}

