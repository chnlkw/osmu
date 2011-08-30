#include "type.h"
#include "string.h"
#include "mm.h"
#include "mp.h"

void sleep();

extern u8 lock;

void cmain()
{
	if(lock)
	{
		ap_start();
		return;
	}
	lock=1;
	disp_pos=0;
	disp_str("1 CPU(s) found.\n");
//	disp_int(sizeof(struct page_table)>> 10);
//	disp_int(&pt_flat.pml4e);disp_str("\n");
//	disp_int(&pt_flat.pdpte);disp_str("\n");
//	disp_int(&pt_flat.pde);disp_str("\n");
//	disp_int(&pt_flat.pte);disp_str("\n");
	init_mp();
	//for( i=0; ;i++)disp_int(i);
	ap_start();
//	sleep64();
//	while(1);
}

