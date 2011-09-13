KERNEL	=	kernel.bin
KOBJ	=	kernel.o
OBJ	=	start.o ap.o main.o string.o mp.o mm.o mm32.o

CFLAGS	+=	-fno-builtin -fno-stack-protector -nostdinc  -g -m64
#CFLAGS	+=	-fno-builtin -fno-stack-protector -nostdinc -m64 -g   //bug    make 32-bit files
ASFLAGS	+=	-m64 -g

#LDFLAGS	+=	-melf_i386	
LDFLAGS	+=	-melf_x86_64	

all	:	${KERNEL} 

${KERNEL}	:	${KOBJ}
	objcopy -O binary $< $@

${KOBJ}	:	${OBJ} link.ld
	${LD} -T link.ld ${OBJ} -o $@ ${LDFLAGS}

${OBJ}	:	type.h defs.h

start.o	:	start.S pm64.h

main.o	:	main.c mm.h

mp.o	:	mp.c apic.h mp.h

string.o	:	string.c

ap.o	:	ap.S pm.h

mm.o	:	mm.h

mm32.o	:	mm32.c mm32.h mm.h
	${CC} mm32.c -c -fno-builtin -fno-stack-protector -nostdinc -m32 -g
	objcopy -O elf64-x86-64 mm32.o

.PHONY :	clean

clean	:
	-rm -rf ${KOBJ} ${OBJ} ${KERNEL}
