#gdbinit for qemu

file kernel/kernel.bin
target remote | exec qemu-system-x86_64 -gdb stdio -hda osmu.img -cpu core2duo -smp 4
break _start
#continue
