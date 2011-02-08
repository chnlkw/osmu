#include "type.h"
#include "protect64.h"

struct	descriptor	gdt[GDT_SIZE];
struct	gate		idt[IDT_SIZE];

void divide_error();

desc_ptr gdt_ptr;
desc_ptr idt_ptr;

void init_CS(struct descriptor* desc, int priv)
{
	desc->access=DESC_CODE_ACCESS | (priv<<DPL_SHIFT);
	desc->limit_2=DESC_CODE_64;
}

void init_DS(struct descriptor* desc)
{
	desc->access=DESC_DATA_ACCESS;
}

void init_gdt()
{
	gdt_ptr[0]=sizeof gdt;
	*(t_64*)(gdt_ptr+1)=(t_64)&gdt;
	init_CS(gdt+CS_INDEX, 0);
	init_DS(gdt+DS_INDEX);
}

void init_gate(t_8 vec_no, void* handler, t_8 priv)
{
	t_64 offset=(t_64)handler;
	struct gate *p=idt+vec_no;
	p->off_1=offset & 0xFFFF;
	p->off_2=(offset >> 16) & 0xFFFF;
	p->off_3=(offset >> 32);
	p->selector=SELECTOR_C;
	p->access=GATE_ACCESS | ((t_16)priv<<(DPL_SHIFT+8));
}

void init_idt()
{
	int i;
	idt_ptr[0]=sizeof idt;
	*(t_64*)(idt_ptr+1)=(t_64)&idt;
	for(i=0;i<32;i++)
	{
		init_gate(i, divide_error, PRIVILEGE_KRNL);
	}
}

char err_string[][32]={
	"Divide error"
};

void exception_handler(t_64 vector_no, t_64 rev1, t_64 rev2, t_64 rev3, t_64 rev4, t_64 rev5, t_64 err_code, t_64 rip, t_64 cs, t_64 rflags, t_64 rsp, t_64 ss)
{
	disp_str(err_string[vector_no]);
}
