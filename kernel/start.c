#include "global.h"
#include "type.h"
#include "protect64.h"

void cs_init()
{
//	main();
	while(1);
}
/*
void _starl1t()
{
	register void* StackTop = task_stack + sizeof task_stack;
	asm volatile ("mov %0, %%rsp" : : "r"(StackTop));
	disp_str("cstart begin\n");
	init_gdt();
	init_8259A();
	init_idt();
	asm volatile ("lgdt (%0)" : : "r" (gdt_ptr) );
	asm volatile ("lidt (%0)" : : "r" (idt_ptr) );
	asm volatile ("ltr %%ax" : : "a"(SELECTOR_TSS)  );

	asm volatile (	"movw %%ax, %%ds \n"
			"movw %%ax, %%es \n"
			"movw %%ax, %%fs \n"
			"movw %%dx, %%gs \n"
			:
			: "a"(SELECTOR_NULL), "d"(SELECTOR_GS)	);
	asm volatile (	"push %0	\n"
			"push $0x212440	\n"
			"pushf		\n"
			"push %2	\n"
			"push %3	\n"
			"iretq"
			:
			: "i"(SELECTOR_NULL),
			  "r"(StackTop),
			  "i"(SELECTOR_CS),
			  "r"(&cs_init)
			 );
	disp_str("cstart finish\n");
//	asm volatile ("sti");
	main();
        while(1);
}
*/

void cpuid(t_32 id)
{
	t_64 rax=0,rbx=0,rcx=0,rdx=0;
	rax=get_cpuid(id, &rbx, &rcx, &rdx);
	disp_str("cpuid");
	disp_int(id);
	disp_str(" EAX=");
	disp_int(rax);
	disp_str(" EBX=");
	disp_int(rbx);
	disp_str(" ECX=");
	disp_int(rcx);
	disp_str(" EDX=");
	disp_int(rdx);
	disp_str("\n");
}

void cpu_info()
{
	char basic_info[15];
	get_cpuid(0, basic_info, basic_info + 4, basic_info + 8);
	basic_info[12] = '\n';
	basic_info[13] = '\0';
	disp_str(basic_info);
}

void cstart()
{
	disp_str("cstart begin\n");
//	init_gdt();
//	init_8259A();
//	init_idt();
	cpu_info();
	cpuid(1);
	disp_int(rdmsr(0x1B));disp_str("\n");
	init_mp();
	disp_str("cstart finish\n");
	while(1);
}
