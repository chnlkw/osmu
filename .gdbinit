#gdbinit for qemu

#file boot/bl.o
target remote | exec qemu-system-x86_64 -gdb stdio -hda osmu.img -boot once=c -smp 8 -m 128M 
file kernel/kernel.o
continue
break start64
