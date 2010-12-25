MntPos=/tmp/lkwix_img
BuiltinFiles=loader.bin dummy.txt boot.bin kernel.bin ldr64.bin
bootinc=fat12ctl.asm addr.inc fat12head.inc

all : lkwix.img

lkwix.img :	boot.bin ${BuiltinFiles}
	dd if=boot.bin of=lkwix.img bs=512 count=1
	dd if=/dev/zero of=lkwix.img seek=1 bs=512 count=2879
	sudo mkdir -p $(MntPos)
	sudo mount -o loop -t msdos -o loop lkwix.img $(MntPos)
	-sudo cp $(BuiltinFiles) $(MntPos)
	sudo umount $(MntPos)
	sudo rm -rf $(MntPos)

boot.bin :	boot.asm ${bootinc}
	nasm boot.asm -o boot.bin

loader.bin :	loader.asm ${bootinc} lib32.asm pm.inc
	nasm loader.asm -o loader.bin

ldr64.bin : ldr64.asm ${bootinc} lib64.asm pm.inc
	nasm ldr64.asm -o ldr64.bin

kernel.bin :	kernel.asm
	nasm -f elf64 -o kernel.o kernel.asm
	ld -s -o kernel.bin kernel.o

copy	:
	-sudo mkdir -p $(MntPos)
	-sudo mount -o loop -t msdos -o loop lkwix.img $(MntPos)
	-sudo cp loader.bin dummy.txt ldr64.bin $(MntPos)
	-sudo umount $(MntPos)
	-sudo rm -rf $(MntPos)
#	cp lkwix.img $(ShareFloder)

.PHONY : clean debug
clean	:
	-rm lkwix.img boot.bin loader.bin kernel.bin kernel.o

debug	:
	bochs -f boch.bxrc

run		:
	virtualbox --startvm Lkwix
