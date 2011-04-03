#include "global.h"
#include "type.h"
#include "protect64.h"

void cs_init()
{
	main();
	while(1);
}

void _start1()
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
			"push %1	\n"
			"pushf		\n"
			"push %2	\n"
			"push %3	\n"
			"iretq"
			:
			: "i"(SELECTOR_NULL),
			  "r"(StackTop),
			  "i"(SELECTOR_CS),
			  "r"(&cs_init)		);
	disp_str("cstart finish\n");
//	asm volatile ("sti");
	main();
        while(1);
}


void cstart()
{
	disp_str("cstart begin\n");
	init_gdt();
	init_8259A();
	init_idt();
	disp_str("cstart finish\n");
}
