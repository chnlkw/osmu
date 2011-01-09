MntPos=/tmp/osmu_img
BuiltinFiles=boot/loader.bin kernel/kernel.bin
TARGET=osmu.img

#all : lkwix.img
all	: makesubdir ${TARGET}

${TARGET}	:	boot/boot.bin ${BuiltinFiles} 
	dd if=boot/boot.bin of=${TARGET} bs=512 count=1
	dd if=/dev/zero of=${TARGET} seek=1 bs=512 count=2879
	sudo mkdir -p $(MntPos)
	sudo mount -o loop -t msdos -o loop ${TARGET} $(MntPos)
	-sudo cp $(BuiltinFiles) $(MntPos)
	sudo umount $(MntPos)
	sudo rm -rf $(MntPos)

makesubdir	:
	${MAKE} -C boot

.PHONY : clean debug
clean	:
	-rm ${TARGET}
	${MAKE} clean -C boot

debug	:
	bochs -f boch.bxrc

run		:
	virtualbox --startvm Lkwix
