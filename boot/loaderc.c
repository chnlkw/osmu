#include "type.h"

void cmain()
{
	disp_str("Loading....");
	disp_int(0xa23);
	while(1);
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


