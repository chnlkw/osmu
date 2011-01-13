#Makefile for Kernel

ASM			=	nasm
ASMFLAGS	=	-f elf64 -I include/

LDFLAGS	=	-s -z max-page-size=0x1000

TARGET	=	kernel.bin
OBJ	=	kernel.o

AddrOfKernel	=	0x30000

vpath %	include/

all	:	kernel.bin

kernel.bin	:	${OBJ}	
	ld ${LDFLAGS} -Ttext-segment=${AddrOfKernel} -o $@ $<

kernel.o	:	kernel.asm
	nasm ${ASMFLAGS} -o $@ $<

clean :
	-rm ${OBJ} ${TARGET}
