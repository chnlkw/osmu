#ifndef _ASM_LIB_H_

#define _ASM_LIB_H_

#include "type.h"

//t_8 in_byte(t_port port);

//void out_byte(t_port port, t_8 value);

t_32 get_cpuid(t_32, void *, void *, void *);
t_64 rdmsr(t_32)

void memcpy(void* dest, void* src, t_32 size);

#endif
