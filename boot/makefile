#Makefile for boot

INCDIRS	=	../include 

CC	=	cc
CFLAGS	+=	-c -fno-builtin -fno-stack-protector -nostdinc -m32 -I ${INCDIRS} -O1 -g

LD	=	ld
LDFLAGS	+=	-melf_i386	

TARGET	=	bootblock

BootLoader=boot loader

OBJ	=	*.o

vpath %	${INCDIRS}

all	:	${TARGET}

${TARGET}	:	boot loader 
	./add_magic.sh boot
	cat boot loader > ${TARGET} 

boot 	:	bl.o
	objcopy -j $@ -O binary $< $@

loader	:	bl.o
	objcopy -j $@ -O binary $< $@


bl.o	:	bootasm.o bootc.o loaderasm.o loaderc.o fs.o link.ld
	${LD} -T link.ld bootasm.o bootc.o fs.o loaderasm.o loaderc.o -o bl.o ${LDFLAGS}

bootasm.o	:	bootasm.S pm.h  
	${CC}  $< ${CFLAGS}

bootc.o		:	fs.h

loaderasm.o	:	loaderasm.S
	${CC}  $< ${CFLAGS}

loaderc.o	:	loaderc.c fs.h
	${CC} ${CFLAGS} $< 
	
clean :
	-rm -r ${TARGET} ${BootLoader} ${OBJ}
