#include "type.h"
#include "string.h"
#include "mm.h"
#include "mp.h"

void sleep();

void cmain()
{
	disp_pos=0;
	disp_str("1 CPU(s) found.\n");
//	disp_int(sizeof(struct page_table)>> 10);
	init_mp();
//	ap_start();
//	for( i=0; ;i++)disp_int(i);
//	sleep();
//	while(1);
}

