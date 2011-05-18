ImageSize=1 # in Mbytes


MntPos=/tmp/osmu_img
BootBlock=boot/bootblock
BuiltinFiles=kernel/kernel.bin #boot/loader 
TARGET=osmu.img
SRCIMG=ext2.img
KERNEL=kernel/kernel.bin

QEMU=qemu-system-x86_64

#all : lkwix.img
all	: ${TARGET}

${TARGET}	:	makesubdir ${BootBlock} ${BuiltinFiles} ${SRCIMG}
	dd if=${BootBlock} of=${TARGET} bs=1K count=1
	dd if=${SRCIMG} of=${TARGET} skip=1 seek=1 bs=1K
	sudo mkdir -p $(MntPos)
	sudo mount -o loop -t ext2 ${TARGET} $(MntPos)
	-sudo cp $(BuiltinFiles) $(MntPos)
	sudo umount $(MntPos)
	sudo rm -rf $(MntPos)

ext2.img	:	
	dd if=/dev/zero of=$@ bs=1M count=${ImageSize}
	yes | mke2fs -c $@

.PHONY : clean debug makesubdir	

makesubdir	:
	${MAKE} -C boot
	${MAKE} -C kernel

clean	:
	-rm ${TARGET} ${SRCIMG}
	${MAKE} clean -C boot
	${MAKE} clean -C kernel

debug	: ${TARGET}
#	${QEMU} -S -s -fda $< &
	gnome-terminal -e "gdb --quiet"
	
run	: ${TARGET}
	virtualbox --startvm osmu
#	${QEMU} -fda $<

