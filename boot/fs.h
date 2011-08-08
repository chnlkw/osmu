#ifndef _FILE_SYSTEM_H_

#define _FILE_SYSTEM_H_

#include "type.h"

#define SECTSIZE 512

//code from xv6

inline char inb(short port);

inline void outb(short port, char data);

inline void insl(int port, void *addr, int cnt);

inline void waitdisk();

void readsect(void *dst, t_32 offset);	// 512Bytes per sect

void read(void *dst, t_32 offset, t_32 count)
;

#endif
