#include "proc.h"
#include "protect64.h"

#ifndef _GLOBAL_H_

#define _GLOBAL_H_

#ifdef GLOBAL_VARIABLES_HERE

#define EXTERN

#else

#define EXTERN extern

#endif

EXTERN	DESCRIPTOR	gdt[GDT_SIZE];
EXTERN	GATE		idt[IDT_SIZE];
EXTERN	TSS		tss;

EXTERN	PROCESS	proc_table[NR_TASKS];

EXTERN	t_8	task_stack[STACK_SIZE_TOTAL];

EXTERN	PROCESS *p_proc_ready;

extern	TASK	task_table[NR_TASKS];

#endif
