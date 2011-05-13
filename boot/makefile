#Makefile for boot


CC	=	cc
CFLAGS	=	-c -fno-builtin -fno-stack-protector -nostdinc

LD	=	ld
LDFLAGS	=	

BootLoader=boot loader

OBJ	=	bootasm.o bootc.o

vpath %	include/

all	:	${BootLoader}

boot	:	bootasm.o bootc.o
	ld -Ttext 0x7c00 -o $@ bootasm.o bootc.o
	objdump -S $@ > $@.asm
	objcopy -O binary $@
	./add_magic.sh boot

bootasm.o	:	bootasm.S pm.h  
	${CC} -c $< 

loader	:	loader.o
	ld -Ttext 0x7c00 -o $@ $@.o
	objdump -S $@.o > $@.asm
	objcopy -O binary $@


clean :
	-rm -r ${BootLoader} ${OBJ}
