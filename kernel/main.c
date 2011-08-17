#include "type.h"
#include "mp.h"

void sleep();

void cmain()
{
	disp_str("10 cmain started.\n");
	init_mp();
//	for( i=0; ;i++)disp_int(i);
//	sleep();
//	while(1);
}

void ap_start()
{
	disp_str("Im AP!!!\n");
	while(1);
}
