#include "global.h"

void clock_handler()
{
	disp_str("%");
	if( ++p_proc_ready >= proc_table + NR_TASKS)
		p_proc_ready = proc_table;
}
