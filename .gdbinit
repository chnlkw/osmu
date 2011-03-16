#gdbinit for qemu

file kernel/kernel.bin
target remote | exec qemu-system-x86_64 -gdb stdio -fda osmu.img
break _start
continue
