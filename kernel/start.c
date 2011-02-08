#include "type.h"
#include "protect64.h"

void cstart()
{
	disp_str("cstart begin\n");
	init_gdt();
	init_8259A();
	init_idt();
	disp_str("cstart finish\n");
}
