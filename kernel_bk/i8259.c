#include "type.h"
#include "asmlib.h"
#include "i8259.h"

void init_8259A()
{
	outb(INT_M_CTL,	0x11);			// Master 8259, ICW1.
	outb(INT_S_CTL,	0x11);			// Slave  8259, ICW1.
	outb(INT_M_CTLMASK,	INT_VECTOR_IRQ0);	// Master 8259, ICW2. 设置 '主8259' 的中断入口地址为 0x20.
	outb(INT_S_CTLMASK,	INT_VECTOR_IRQ8);	// Slave  8259, ICW2. 设置 '从8259' 的中断入口地址为 0x28
	outb(INT_M_CTLMASK,	0x4);			// Master 8259, ICW3. IR2 对应 '从8259'.
	outb(INT_S_CTLMASK,	0x2);			// Slave  8259, ICW3. 对应 '主8259' 的 IR2.
	outb(INT_M_CTLMASK,	0x1);			// Master 8259, ICW4.
	outb(INT_S_CTLMASK,	0x1);			// Slave  8259, ICW4.

	outb(INT_M_CTLMASK,	0xFE);	// Master 8259, OCW1. 
	outb(INT_S_CTLMASK,	0xFF);	// Slave  8259, OCW1. 
}
