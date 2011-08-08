KERNEL	=	kernel.bin
KOBJ	=	kernel.o
OBJ	=	start.o

all	:	${KERNEL}

${KERNEL}	:	${KOBJ}
	objcopy -O binary $< $@

${KOBJ}	:	${OBJ} link.ld
	${LD} -T link.ld ${OBJ} -o $@

start.o	:	start.S

.PHONY :	clean

clean	:
	-rm -r ${KOBJ} ${OBJ} ${KERNEL}
