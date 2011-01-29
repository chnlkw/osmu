#include "type.h"
#include "protect64.h"

void cstart()
{
	init_gdt();
	init_8259A();
}
