ImageSize=1 # in Mbytes

CFLAGS += -g

MntPos=/tmp/osmu_img
BootBlock	=	boot/bootblock
BuiltinFiles	=	kernel/kernel.bin #boot/loader 
OSMU	=	osmu.img
SRCIMG	=	ext2.img
KERNEL	=	kernel/kernel.bin
ADDLOADER	=	addloader/addloader 

QEMU=qemu-system-x86_64

#all : lkwix.img
all	: ${OSMU}

${OSMU}	:	makesubdir ${BootBlock} ${BuiltinFiles} ${SRCIMG}
	dd if=${BootBlock} of=${OSMU} bs=1K count=1
	dd if=${SRCIMG} of=${OSMU} skip=1 seek=1 bs=1K
	sudo mkdir -p $(MntPos)
	sudo mount -o loop -t ext2 ${OSMU} $(MntPos)
	-sudo cp $(BuiltinFiles) $(MntPos)
	sudo umount $(MntPos)
	sudo rm -rf $(MntPos)
	${ADDLOADER} ${OSMU} kernel.bin

ext2.img	:	
	dd if=/dev/zero of=$@ bs=1M count=${ImageSize}
	yes | mke2fs -c $@

.PHONY : clean debug makesubdir	

makesubdir	:
	${MAKE} -C boot
	${MAKE} -C kernel
	${MAKE} -C addloader

clean	:
	-rm ${TARGET} ${SRCIMG} ${OSMU}
	${MAKE} clean -C boot
	${MAKE} clean -C kernel
	${MAKE} clean -C addloader

debug	: ${TARGET}
#	${QEMU} -S -s -fda $< &
	gnome-terminal -e "gdb --quiet"
	
run	: ${TARGET}
	virtualbox --startvm osmu
#	${QEMU} -fda $<

