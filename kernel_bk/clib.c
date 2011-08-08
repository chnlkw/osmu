#include "type.h"

inline t_8 inb(t_port port)
{
	t_8 data;
	asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) );
	return data;
}

inline t_8 outb(t_port port, t_8 data)
{
	asm volatile ("outb %0, %1" : : "a" (data), "d" (port) );
}

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

void delay(t_64 t)
{
	int i;
	while(t-->0)
	{
		for(i=0;i<50000000;i++);
	}
}
