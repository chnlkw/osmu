#Makefile for Kernel

INCDIRS	=	../include

#AS	=	nasm
#ASFLAGS	=	-f elf64 -g

AS	=	as
ASFLAGS	=	-g #--64

CC	=	gcc
CFLAGS	=	-c -fno-builtin -fno-stack-protector -g -nostdinc -I ${INCDIRS}

LDFLAGS	=	-z max-page-size=0x1000 -m elf_x86_64 #-s

TARGET	=	kernel.bin
OBJ	=	kernel.o start.o asmlib.o clib.o mp.o #protect64.o i8259.o main.o global.o clock.o

INCDIRS	=	../include

AddrOfKernel	=	0x200000

vpath %	../include/

all	:	kernel.bin

kernel.bin	:	${OBJ}	
	ld ${LDFLAGS} -Ttext-segment=${AddrOfKernel} -o $@ ${OBJ} 

kernel.o	:	kernel.s protect64.inc

protect64.inc:	protect64.h
	sed protect64.h -e 's/^#/%/' | grep % > protect64.inc

clib.o		: clib.c type.h

i8259.o		: i8259.c type.h i8259.h asmlib.h

main.o		: main.c type.h proc.h protect64.h global.h const.h

protect64.o	: protect64.c type.h i8259.h protect64.h global.h const.h proc.h

start.o		: start.c type.h protect64.h

global.o	: global.h

#asmlib.o	: asmlib.s
#	as --64 $< -o $@ -g

clean :
	-rm ${OBJ} ${TARGET}
