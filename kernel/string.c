#include "type.h"
#include "string.h"

volatile u32	disp_pos = 0;

void disp_str(char *str)
{
	register u16 *gs=(void*)0xB8000;
	register u16 *p,*q;
	while(*str)
	{
		if(*str=='\n')
			disp_pos=(disp_pos / CHAR_PER_LINE + 1) * CHAR_PER_LINE;
		else
			gs[disp_pos++]=*str | 0x0F00;
		str++;
		if(disp_pos >= CHAR_PER_LINE * LINE_PER_SCREEN)	
		{
			for(p=gs,q=gs+CHAR_PER_LINE; q < gs + CHAR_PER_LINE * LINE_PER_SCREEN; p++,q++)
				*p=*q;
			for(;p<q;p++)*p=0x0;
			disp_pos -= CHAR_PER_LINE;
		}
	}
}

void itoa(char *str, u64 num)
{
	char *p=str;
	char ch;
	int i, flag=0;
//	*p++='0';
//	*p++='x';
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

void disp_int(u64 num)
{
	char str[20];
	itoa(str, num);
	disp_str(str);
}

void memcpy(char *dst, char *src, u64 cnt)
{
	while(cnt--) *dst++ = *src++;
}


