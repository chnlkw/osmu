#Makefile for Kernel

AS		=	nasm
ASFLAGS	=	-f elf64 -I include/

LDFLAGS	=	-s -z max-page-size=0x1000

TARGET	=	kernel.bin
OBJ	=	kernel.o start.o

AddrOfKernel	=	0x30000

vpath %.inc	include/

all	:	kernel.bin

kernel.bin	:	${OBJ}	
	ld ${LDFLAGS} -Ttext-segment=${AddrOfKernel} -o $@ ${OBJ} 

kernel.o	:	kernel.s
#	nasm ${ASMFLAGS} -o $@ $<

start.o		:	start.c


clean :
	-rm ${OBJ} ${TARGET}
