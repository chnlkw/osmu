#include "type.h"
#include "fs.h"

void cstart()
{
	register void (*entry) (void) = (void(*)(void))(0x7e00);
	readsect(0x7e00, 1);
	entry();
}

