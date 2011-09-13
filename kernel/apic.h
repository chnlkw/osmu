#ifndef __APIC_H__

#define __APIC_H__

#define APIC_BASE_ADDR	0xFEE00000
#define APIC_ID		0x20
#define	APIC_SIVR	0xF0
#define	APIC_ENABLED	0x100
#define	APIC_LVT3	0x370
#define APIC_ICR_L	0x300
#define APIC_ICR_H	0x310

static inline u32 apic_read(u64 reg)
{
        return *((volatile u32 *)(APIC_BASE_ADDR + reg));
}

static inline void apic_write(u32 reg, u32 val)
{
        *((volatile u32 *)(APIC_BASE_ADDR + reg)) = val;
}

#endif
