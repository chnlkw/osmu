#include "type.h"

#define SECTSIZE 512

#define	KERNEL_BASE_ADDR 0x100000

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
	insl(0x1F0, dst, SECTSIZE/4);
}

void cstart()
{
	register void (*entry) (void) = (void(*)(void))(0x7e00);;
	readsect(0x7e00, 1);
	entry();
}
/*
void itoa(char *str, t_64 num)
{
	char *p=str;
	char ch;
	int i, flag=0;
	*p++='0';
	*p++='x';
	for(i=60;i>=0;i-=4)
	{
		ch=((num>>i)&0xF);
		if(ch || flag)
		{
			flag=1;
			ch+='0';
			if(ch>'9')
				ch+='A'-'0'-10;
			*p++=ch;
		}
	}
	if(!flag)
		*p++='0';
	*p='\0';
}

void disp_int(t_64 num)
{
	char str[20];
	itoa(str, num);
	disp_str(str);
}
*/

