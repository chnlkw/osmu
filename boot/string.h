#include "type.h"

#ifndef _STRING_H_

#define _STRING_H_

#define CHAR_PER_LINE	80

t_32	disp_pos = 0;
void disp_str(char *str)
{
	t_16 *gs=(void*)0xb8000;
	while(*str)
	{
		if(*str=='\n')
			disp_pos=(disp_pos / CHAR_PER_LINE + 1) * CHAR_PER_LINE;
		else
			gs[disp_pos++]=*str | 0x0f00;
		str++;
	}
}

void itoa(char *str, t_32 num)
{
	char *p=str;
	char ch;
	int i, flag=0;
	*p++='0';
	*p++='x';
	for(i=28;i>=0;i-=4)
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

void disp_int(t_32 num)
{
	char str[20];
	itoa(str, num);
	disp_str(str);
}

#endif
