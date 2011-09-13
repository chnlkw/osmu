#include "type.h"
#include "apic.h"
#include "mp.h"
#include "defs.h"

void AP_START_CODE();
void AP_START_CODE_END();

void init_mp()
{
	u64 bb,i;
	memcpy(AP_BOOT_ADDR,  AP_START_CODE, AP_START_CODE_END - AP_START_CODE);
	bb = apic_read(APIC_SIVR);
	apic_write(APIC_SIVR, bb | APIC_ENABLED );
	bb = apic_read(APIC_LVT3);
	bb &= 0xFFFFFF00;
	bb |= 0;
	apic_write(APIC_LVT3, bb);
	apic_write(APIC_ICR_L, 0xC4500);
//	for(i=0;i<=10000000;i++);
	bb = 0xC4600 | (AP_BOOT_ADDR >> 12);
	apic_write(APIC_ICR_L, bb);
//	for(i=0;i<=10000;i++);
	apic_write(APIC_ICR_L, bb);
//	for(i=0;i<=10000;i++);
}

void ap_start()
{
	register u32 ap_num, cur=0;
	ap_num = apic_read(APIC_ID) >> 24;
while(1)	
{
	disp_str("AP ");
	disp_int(ap_num);
	disp_str(":");
	disp_int(cur);
	cur++;
	disp_str("\n");
}	
	//while(1);
}
