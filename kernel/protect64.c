#include "type.h"
#include "i8259.h"
#include "protect64.h"

struct	descriptor	gdt[GDT_SIZE];
struct	gate		idt[IDT_SIZE];
struct	TSS		tss;

void divide_error();
void single_step_exception();
void nmi();
void breakpoint_exception();
void overflow();
void bounds_check();
void inval_opcode();
void copr_not_available();
void double_fault();
void copr_seg_overrun();
void inval_tss();
void segment_not_present();
void stack_exception();
void general_protection();
void page_fault();
void copr_error();
void align_fault();
void machine_abort();
void simd_fault();
void hwint0();
void hwint1();
void hwint2();
void hwint3();
void hwint4();
void hwint5();
void hwint6();
void hwint7();
void hwint8();
void hwint9();
void hwint10();
void hwint11();
void hwint12();
void hwint13();
void hwint14();
void hwint15();

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

void init_TSS(struct descriptor* desc, struct TSS *tss_ptr)
{
	desc->limit_1 = sizeof (struct TSS) -1;
	desc->base_1 = (t_64)tss_ptr & 0xFFFF;
	desc->base_2 = ((t_64)tss_ptr >> 16) & 0xFF;
	desc->base_3 = ((t_64)tss_ptr >> 24) & 0xFF;
	desc->base_4 = ((t_64)tss_ptr >> 32) & 0xFFFFFFFF;
	desc->access = DESC_TSS_ACCESS;
	desc->limit_2= DESC_LIMIT_G;

}

void init_gdt()
{
	gdt_ptr[0]=sizeof gdt;
	*(t_64*)(gdt_ptr+1)=(t_64)&gdt;
	init_CS(gdt+CS_INDEX, 0);
	init_DS(gdt+DS_INDEX);
	init_TSS(gdt+TSS_INDEX, &tss);
	tss.rsp0=ADDR_RSP0;
	tss.rsp1=ADDR_RSP1;
	tss.rsp2=ADDR_RSP2;
}

void init_gate(t_8 vec_no, void* handler, t_8 priv)
{
	t_64 offset=(t_64)handler;
	struct gate *p=idt+vec_no;
	p->off_1=offset & 0xFFFF;
	p->off_2=(offset >> 16) & 0xFFFF;
	p->off_3=(offset >> 32);
	p->selector=SELECTOR_CS;
	p->access=GATE_ACCESS | ((t_16)priv<<(DPL_SHIFT+8));
}

void init_idt()
{
	int i;
	idt_ptr[0]=sizeof idt;
	*(t_64*)(idt_ptr+1)=(t_64)&idt;
	init_gate(INT_VECTOR_DIVIDE,		divide_error,		PRIVILEGE_KRNL); 
	init_gate(INT_VECTOR_DEBUG,		single_step_exception,	PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_NMI,		nmi,			PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_BREAKPOINT,	breakpoint_exception,	PRIVILEGE_USER);
	init_gate(INT_VECTOR_OVERFLOW,		overflow,		PRIVILEGE_USER);
	init_gate(INT_VECTOR_BOUNDS,		bounds_check,		PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_INVAL_OP,		inval_opcode,		PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_COPROC_NOT,	copr_not_available,	PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_DOUBLE_FAULT,	double_fault,		PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_COPROC_SEG,	copr_seg_overrun,	PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_INVAL_TSS,		inval_tss,		PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_SEG_NOT,		segment_not_present,	PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_STACK_FAULT,	stack_exception,	PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_PROTECTION,	general_protection,	PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_PAGE_FAULT,	page_fault,		PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_COPROC_ERR,	copr_error,		PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_ALIGN_FAULT,	align_fault,		PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_MACHINE_NOT,	machine_abort,		PRIVILEGE_KRNL);
	init_gate(INT_VECTOR_SIMD_FAULT	,	simd_fault,		PRIVILEGE_KRNL);


	init_gate(INT_VECTOR_IRQ0 + 0,	hwint0,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ0 + 1,	hwint1,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ0 + 2,	hwint2,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ0 + 3,	hwint3,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ0 + 4,	hwint4,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ0 + 5,	hwint5,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ0 + 6,	hwint6,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ0 + 7,	hwint7,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ8 + 0,	hwint8,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ8 + 1,	hwint9,		PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ8 + 2,	hwint10,	PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ8 + 3,	hwint11,	PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ8 + 4,	hwint12,	PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ8 + 5,	hwint13,	PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ8 + 6,	hwint14,	PRIVILEGE_KRNL);	
	init_gate(INT_VECTOR_IRQ8 + 7,	hwint15,	PRIVILEGE_KRNL);	
}

void exception_handler(t_64 vector_no, t_64 err_code, t_64 rev1, t_64 rev2, t_64 rev3, t_64 rev4, t_64 rip, t_64 cs, t_64 rflags, t_64 rsp, t_64 ss)
{
	char err_string[][64]={
		"#DE Divide Error",
		"#DB RESERVED",
		"―  NMI Interrupt",
		"#BP Breakpoint",
		"#OF Overflow",
		"#BR BOUND Range Exceeded",
		"#UD Invalid Opcode (Undefined Opcode)",
		"#NM Device Not Available (No Math Coprocessor)",
		"#DF Double Fault",
		"    Coprocessor Segment Overrun (reserved)",
		"#TS Invalid TSS",
		"#NP Segment Not Present",
		"#SS Stack-Segment Fault",
		"#GP General Protection",
		"#PF Page Fault",
		"―  (Intel reserved. Do not use.)",
		"#MF x87 FPU Floating-Point Error (Math Fault)",
		"#AC Alignment Check",
		"#MC Machine Check",
		"#XF SIMD Floating-Point Exception"
	};

	disp_str(err_string[vector_no]);
	disp_str("\n");
	if(err_code!=NON_ERR_CODE)
	{
		disp_str("ERROR CODE:");
		disp_int(err_code);
	}
	disp_str("  CS:RIP=");
	disp_int(cs);
	disp_str(":");
	disp_int(rip);
	disp_str("  SS:RSP=");
	disp_int(ss);
	disp_str(":");
	disp_int(rsp);
	disp_str("  RFLAGS:");
	disp_int(rflags);
}

void spurious_irq(t_64 irq)
{
	disp_str("spurious_irq:");
	disp_int(irq);
}
