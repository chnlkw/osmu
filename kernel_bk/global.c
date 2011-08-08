#define	GLOBAL_VARIABLES_HERE

#include "proc.h"
#include "protect64.h"
#include "global.h"

TASK task_table[NR_TASKS]=
{
	{proc_A, STACK_SIZE_PROCA},
	{proc_B, STACK_SIZE_PROCB},
};

