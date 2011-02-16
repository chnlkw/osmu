#include "type.h"
#include "proc.h"
#include "protect64.h"
#include "global.h"
#include "const.h"

void main()
{
	register PROCESS *rp;
	disp_str("---- Welcome to OSMU! ----\n");
	
	rp = proc_table;

	rp->ldt_sel=SELECTOR_LDT_H;

	init_sys_seg(gdt + LDT_INDEX, &rp->ldt, sizeof(rp->ldt) - 1, DESC_LDT_ACCESS);
	init_CS(rp->ldt + CS_INDEX, 1);
	init_DS(rp->ldt + GS_INDEX, GS_BASE_ADDR);

	rp->regs.cs = SELECTOR_CS | TI_LDT | RPL1;
	rp->regs.gs = SELECTOR_GS | TI_LDT | RPL1;
	rp->regs.fs = SELECTOR_DS ;
	rp->regs.ss = SELECTOR_DS ;
	rp->regs.rip = (t_64)proc_A;
	rp->regs.rsp = (t_64)task_stack + STACK_SIZE_TOTAL;
	rp->regs.rflags = DEFAULT_RFLAGS;

	p_proc_ready = (t_64)proc_table;
//	disp_int(sizeof(REGS)+8);
//	disp_str("\n");
//	disp_int(proc_table);
//	disp_str("\n");
	restart();

	while(1);
}

void proc_A()
{
	int i=0;
	while(1)
	{
		disp_str("A");
		disp_int(i++);
		disp_str(".");
		delay(1);
	}
}

void proc_B()
{
	int i=0;
	while(1)
	{
		disp_str("B");
		disp_int(i++);
		disp_str(";");
		delay(1);
	}
}
