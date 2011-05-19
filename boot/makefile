#Makefile for boot

INCDIRS	=	../include include

CC	=	cc
CFLAGS	=	-c -fno-builtin -fno-stack-protector -nostdinc -m32 -I ${INCDIRS} -O1

LD	=	ld
LDFLAGS	=	-melf_i386	

TARGET	=	bootblock

BootLoader=boot loader

OBJ	=	*.o

vpath %	${INCDIRS}

all	:	${TARGET}

${TARGET}	:	boot loader
	cat boot loader > bootblock

boot	:	bootasm.o bootc.o
	${LD} -Ttext 0x7c00 -o $@.o bootasm.o bootc.o ${LDFLAGS}
	objdump -S $@.o > $@.asm
	objcopy -O binary $@.o $@
	./add_magic.sh boot

bootasm.o	:	bootasm.S pm.h  
	${CC} -c -m32 $< 

loader	:	loaderasm.o loaderc.o
	${LD} -Ttext 0x96c00 -o $@.o loaderasm.o loaderc.o ${LDFLAGS}
	objdump -S $@.o > $@.asm
	objcopy -O binary $@.o $@

loaderasm.o	:	loaderasm.S
	${CC} -c -m32 $< 

loaderc.o	:	loaderc.c string.h fs.h
	${CC} ${CFLAGS} $< 
	
clean :
	-rm -r ${TARGET} ${BootLoader} ${OBJ}
