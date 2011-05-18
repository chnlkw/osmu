#ifndef _FILE_SYSTEM_H_

#define _FILE_SYSTEM_H_

#define SECTSIZE 512

//code from xv6

static inline char inb(short port)
{
  char data;
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  return data;
}

static inline void outb(short port, char data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}


static inline void insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
                   "=D" (addr), "=c" (cnt)    :
                   "d" (port), "0" (addr), "1" (cnt)  :
                   "memory", "cc");
}

static inline void waitdisk()
{
	while((inb(0x1F7)&0xC0)!=0x40);
}

void readsect(void *dst, t_32 offset)
{
	// Issue command.
	waitdisk();
	outb(0x1F2, 1);   // count = 1
	outb(0x1F3, offset);
	outb(0x1F4, offset >> 8);
	outb(0x1F5, offset >> 16);
	outb(0x1F6, (offset >> 24) | 0xE0);
	outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

	// Read data.
	waitdisk();
	insl(0x1F0, dst, SECTSIZE>>2);
}

#endif
