#include "proc.h"
#include "const.h"
#include "protect64.h"

#ifndef _GLOBAL_H_

#define _GLOBAL_H_

#ifdef GLOBAL_VARIABLES_HERE

#define EXTERN

#else

#define EXTERN extern

#endif

EXTERN	t_8	kern_stack[STACK_SIZE_TOTAL];

EXTERN	t_32		disp_pos;

EXTERN	DESCRIPTOR	gdt[GDT_SIZE];
EXTERN	GATE		idt[IDT_SIZE];
EXTERN	TSS		tss;

EXTERN	PROCESS *p_proc_ready;
EXTERN	PROCESS	proc_table[NR_TASKS];


EXTERN	t_8	task_stack[STACK_SIZE_TASK_TOTAL];

extern	TASK	task_table[NR_TASKS];

#endif
