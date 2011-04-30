MntPos=/tmp/osmu_img
BuiltinFiles=boot/loader.bin kernel/kernel.bin
TARGET=osmu.img
KERNEL=kernel/kernel.bin

QEMU=qemu-system-x86_64

#all : lkwix.img
all	: ${TARGET}

${TARGET}	:	makesubdir boot/boot.bin ${BuiltinFiles} 
	dd if=boot/boot.bin of=${TARGET} bs=512 count=1
	dd if=/dev/zero of=${TARGET} seek=1 bs=512 count=2879
	sudo mkdir -p $(MntPos)
	sudo mount -o loop -t msdos -o loop ${TARGET} $(MntPos)
	-sudo cp $(BuiltinFiles) $(MntPos)
	sudo umount $(MntPos)
	sudo rm -rf $(MntPos)

.PHONY : clean debug makesubdir	

makesubdir	:
	${MAKE} -C boot
	${MAKE} -C kernel

clean	:
	-rm ${TARGET}
	${MAKE} clean -C boot
	${MAKE} clean -C kernel

debug	: ${TARGET}
#	${QEMU} -S -s -fda $< &
	gnome-terminal -e "gdb --quiet"
	
run	: ${TARGET}
	virtualbox --startvm osmu
#	${QEMU} -fda $<
