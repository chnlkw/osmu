#Makefile for Kernel

AS		=	nasm
ASFLAGS	=	-f elf64 -I ../include/

CC		=	gcc
CFLAGS	=	-I ../include/ -c

LDFLAGS	=	-s -z max-page-size=0x1000

TARGET	=	kernel.bin
OBJ	=	kernel.o start.o protect64.o asmlib.o i8259.o

AddrOfKernel	=	0x30000

vpath %.h	../include/

all	:	kernel.bin

kernel.bin	:	${OBJ}	
	ld ${LDFLAGS} -Ttext-segment=${AddrOfKernel} -o $@ ${OBJ} 

kernel.o	:	kernel.s protect64.inc
#	nasm ${ASMFLAGS} -o $@ $<

start.o		:	type.h protect64.h

protect64.inc:	protect64.h
	sed protect64.h -e 's/^#/%/' > protect64.inc

protect64.o	:	type.h

i8259.o		:	type.h asmlib.h

clean :
	-rm ${OBJ} ${TARGET}
