#include "type.h"
#include "mm32.h"

void mm_fill_page_table_32(PT *pt)
{
	u64 *p1=pt->pml4e;
	u64 *p2=pt->pdpte;
	u64 *p3=pt->pde;
	u64 *p4=pt->pte;
	register u64 addr;
	
	for(addr = 0; addr < (1LL << MAXPHYADDR); addr += 0x1000)
	{
		if((addr & ((1LL<<39)-1)) == 0)
		{
			*p1=(u32)p2 | PG_P | PG_W | PG_S;
			p1++;
		}
		if((addr & ((1LL<<30)-1)) == 0)
		{
			*p2=(u32)p3 | PG_P | PG_W | PG_S;
			p2++;
		}
		if((addr & ((1LL<<21)-1)) == 0)
		{
			*p3=(u32)p4 | PG_P | PG_W | PG_S;
			p3++;
		}
		if((addr & ((1LL<<12)-1)) == 0)
		{
			*p4=addr | PG_P | PG_W | PG_S;
			p4++;
		}
	}
//	disp_int(p1);disp_str(" ");disp_int((u32)pt->pml4e + sizeof pt->pml4e);disp_str("\n");
//	disp_int(p2);disp_str(" ");disp_int((u32)pt->pdpte + sizeof pt->pdpte);disp_str("\n");
//	disp_int(p3);disp_str(" ");disp_int((u32)pt->pde + sizeof pt->pde);disp_str("\n");
//	disp_int(p4);disp_str(" ");disp_int((u32)pt->pte + sizeof pt->pte);disp_str("\n");
}
