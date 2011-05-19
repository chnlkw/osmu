#Makefile for boot

INCDIRS	=	../include 

CC	=	cc
CFLAGS	=	-c -fno-builtin -fno-stack-protector -nostdinc -m32 -I ${INCDIRS} -O1 -g

LD	=	ld
LDFLAGS	=	-melf_i386	

TARGET	=	bootblock

BootLoader=boot loader

OBJ	=	*.o

vpath %	${INCDIRS}

all	:	${TARGET}

${TARGET}	:	boot loader 
	./add_magic.sh boot
	cat boot loader > ${TARGET} 

boot loader	:	bl.o
	objcopy -j $@ -O binary $< $@
	objdump -j $@ -S $< > $@.asm


bl.o	:	bootasm.o bootc.o loaderasm.o loaderc.o fs.o
	${LD} -T link.script bootasm.o bootc.o fs.o loaderasm.o loaderc.o -o bl.o ${LDFLAGS}

bootasm.o	:	bootasm.S pm.h  
	${CC}  $< ${CFLAGS}

bootc.o		:	fs.h

loaderasm.o	:	loaderasm.S
	${CC}  $< ${CFLAGS}

loaderc.o	:	loaderc.c string.h fs.h
	${CC} ${CFLAGS} $< 
	
clean :
	-rm -r ${TARGET} ${BootLoader} ${OBJ}
