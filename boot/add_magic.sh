#!/bin/bash
test -z "$1" && exit 1
size=`du -b "$1" | cut -f1 `
test $size -gt 510 && echo "Block too big" && exit 1
count=` echo " 510 - $size" | bc `
dd if=/dev/zero of="$1" bs=1 seek=$size count=$count
echo -en "\x55\xaa">> boot
