#include "type.h"

#ifndef _STRING_H_

#define _STRING_H_

#define CHAR_PER_LINE	80
#define LINE_PER_SCREEN	25

extern volatile	u32	disp_pos;

void disp_str(char*);

void itoa(char*, u64);

void disp_int(u64);

void memcpy(char*, char*, u64);

#endif
