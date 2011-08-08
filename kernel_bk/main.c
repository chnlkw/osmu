#include "const.h"
#include "type.h"
#include "proc.h"
#include "protect64.h"
#include "global.h"

//PROCESS *p_proc_ready;

void main()
{
	register PROCESS	*p_proc;
	register TASK		*p_task;
	register t_64		stack_top;
	register t_64		i;
	register PROCESS	*rp;

	disp_str("---- Welcome to OSMU! ----\n");

	stack_top = (t_64)task_stack + STACK_SIZE_TOTAL;

	for(i = 0, p_proc = proc_table, p_task = task_table; i != NR_TASKS; i++, p_proc++, p_task++) 
	{

		p_proc->ldt_sel=SELECTOR_LDT_H + i * 0x10;

		init_sys_seg(gdt + LDT_INDEX + i, &p_proc->ldt, sizeof(p_proc->ldt) - 1, DESC_LDT_ACCESS);
		init_CS(p_proc->ldt + CS_INDEX, DPL1);
		init_DS(p_proc->ldt + DS_INDEX, 0, DPL1);
		init_DS(p_proc->ldt + GS_INDEX, GS_BASE_ADDR, DPL1);

		p_proc->regs.cs = SELECTOR_CS | TI_LDT | RPL1;
		p_proc->regs.gs = SELECTOR_GS | TI_LDT | RPL1;
		p_proc->regs.fs = SELECTOR_NULL;
		p_proc->regs.ss = SELECTOR_SS | TI_LDT | RPL1;
		p_proc->regs.rflags = DEFAULT_RFLAGS;
		p_proc->regs.rip = (t_64)p_task->entry;
		p_proc->regs.rsp = stack_top;
		stack_top -= p_task->stack_size;

	}

	p_proc_ready = proc_table;
	disp_int(proc_table);
	disp_int(&proc_table);
	disp_int(p_proc_ready);
//	while(1);
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
		delay(3);
	}
}
