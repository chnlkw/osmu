#include "mp.h"
#include "asmlib.h"

void init_mp()
{
	disp_str(" from ");
	disp_int(ap_start_code);
	disp_str(" to ");
	disp_int(AP_INIT_CODE_ADDR);
	disp_str(" size ");
	disp_int(ap_start_code_end );
	disp_str("\n");
	
	memcpy(AP_INIT_CODE_ADDR, ap_start_code, ap_start_code_end - ap_start_code);
}
