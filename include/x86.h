#include "type.h"

#ifndef _X86_H_

#define _X86_H_

static t_8 inb(t_port port)
{
	t_8 data;
	asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) );
	return data;
}

static t_8 outb(t_port port, t_8 data)
{
	asm volatile ("outb %0, %1" : : "a" (data), "d" (port) );
}

static void insl(t_port port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
                   "=D" (addr), "=c" (cnt)    :
                   "d" (port), "0" (addr), "1" (cnt)  :
                   "memory", "cc");
}

#endif
