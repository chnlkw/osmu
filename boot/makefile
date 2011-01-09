#Makefile for boot

ASM			=	nasm
ASMFLAGS	=	-I include/

BOOTFILE	=	boot.bin loader.bin

vpath %	include/

all	:	${BOOTFILE}

boot.bin :	boot.asm addr.inc fat12head.inc fat12ctl.asm
	${ASM} ${ASMFLAGS} -o $@ $<

loader.bin :	loader.asm addr.inc fat12head.inc pm.inc fat12ctl.asm lib32.asm
	${ASM} ${ASMFLAGS} -o $@ $<

clean :
	-rm -r ${BOOTFILE}
