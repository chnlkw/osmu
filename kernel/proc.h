#include "type.h"
#include "protect64.h"

#ifndef _PROC_H_

#define _PROC_H_

typedef struct s_regs
{
	t_64	rax;
	t_64	rbx;
	t_64	rcx;
	t_64	rdx;
	t_64	rbp;
	t_64	rsi;
	t_64	rdi;
	t_64	r8;
	t_64	r9;
	t_64	r10;
	t_64	r11;
	t_64	r12;
	t_64	r13;
	t_64	r14;
	t_64	r15;
	t_64	fs;
	t_64	gs;
	t_64	rip;
	t_64	cs;
	t_64	rflags;
	t_64	rsp;
	t_64	ss;
}REGS;

typedef struct s_proc
{
	t_64		ldt_sel;
	REGS		regs;
	DESCRIPTOR	ldt[LDT_SIZE];
}PROCESS;

#endif
