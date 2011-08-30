#include "type.h"
#include "string.h"
#include "mm.h"
#include "mp.h"


void sleep();

void init64()
{
	disp_pos=0;
	mm_fill_page_table_32(&pt_flat);
}

void cmain()
{

	//disp_pos=0;
	disp_str("1 CPU(s) found.\n");
//	disp_int(sizeof(struct page_table)>> 10);
	disp_int(&pt_flat.pml4e);disp_str("\n");
	disp_int(&pt_flat.pdpte);disp_str("\n");
	disp_int(&pt_flat.pde);disp_str("\n");
	disp_int(&pt_flat.pte);disp_str("\n");
	init_mp();
//	ap_start();
//	for( i=0; ;i++)disp_int(i);
//	sleep();
//	while(1);
}

