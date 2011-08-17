#include "type.h"
#include "apic.h"
#include "mp.h"
#include "defs.h"

void AP_START_CODE();
void AP_START_CODE_END();

void init_mp()
{
	register u32 bb,i;
	memcpy(AP_BOOT_ADDR,  AP_START_CODE, AP_START_CODE_END - AP_START_CODE);
	bb = apic_read(APIC_SIVR);
	apic_write(APIC_SIVR, bb | APIC_ENABLED );
	bb = apic_read(APIC_LVT3);
	bb &= 0xFFFFFF00;
	bb |= 0;
	apic_write(APIC_LVT3, bb);
	for(i=0;i<=1000000;i++);
	apic_write(APIC_ICR_L, 0xC4500);
	for(i=0;i<=1000000;i++);
	bb = 0xC4600 | (AP_BOOT_ADDR >> 12);
	apic_write(APIC_ICR_L, bb);
	for(i=0;i<=1000000;i++);
	apic_write(APIC_ICR_L, bb);
}
