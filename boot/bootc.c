#include "type.h"
#include "fs.h"

#define ADDR_OF_LOADER 0x96c00

void cstart()
{
	register void (*entry) () = (void(*) () ) ADDR_OF_LOADER ;
	readsect( (void *)ADDR_OF_LOADER, 1);
	entry();
	while(1);
}

