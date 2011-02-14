#include "const.h"
#include "protect64.h"
#include "proc.h"

#ifndef _KERNEL_GLOBEL_H_

#define _KERNEL_GLOBEL_H_

#define EXTERN

#else

#define EXTERN extern

#endif

EXTERN	DESCRIPTOR	gdt[GDT_SIZE];
EXTERN	GATE		idt[IDT_SIZE];
EXTERN	TSS		tss;

EXTERN	PROCESS	proc_table[NR_TASKS];

EXTERN	t_8	task_stack[TASK_STACK_SIZE];

EXTERN	t_64	p_proc_ready;

