INCDIRS	=	../include 

KERNEL	=	kernel.bin
KOBJ	=	kernel.o
OBJ	=	start.o main.o

CFLAGS	+=	-fno-builtin -fno-stack-protector -nostdinc -m32 -g -I ${INCDIRS} 
ASFLAGS	+=	-m32 -g

LDFLAGS	+=	-melf_i386	

all	:	${KERNEL} 

${KERNEL}	:	${KOBJ}
	objcopy -O binary $< $@

${KOBJ}	:	${OBJ} link.ld
	${LD} -T link.ld ${OBJ} -o $@ ${LDFLAGS}

start.o	:	start.S defs.h

main.o	:	main.c apic.h

.PHONY :	clean

clean	:
	-rm -r ${KOBJ} ${OBJ} ${KERNEL}
