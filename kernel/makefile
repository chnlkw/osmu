KERNEL	=	kernel.bin
KOBJ	=	kernel.o
OBJ	=	start.o ap.o main.o string.o mp.o 

CFLAGS	+=	-fno-builtin -fno-stack-protector -nostdinc -m32 -g
ASFLAGS	+=	-m32 -g

LDFLAGS	+=	-melf_i386	

all	:	${KERNEL} 

${KERNEL}	:	${KOBJ}
	objcopy -O binary $< $@

${KOBJ}	:	${OBJ} link.ld
	${LD} -T link.ld ${OBJ} -o $@ ${LDFLAGS}

${OBJ}	:	type.h

start.o	:	start.S defs.h

main.o	:	main.c

mp.o	:	mp.c apic.h mp.h

string.o	:	string.c

ap.o	:	ap.S pm.h defs.h

.PHONY :	clean

clean	:
	-rm -r ${KOBJ} ${OBJ} ${KERNEL}
