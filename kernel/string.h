#include "type.h"

#ifndef _STRING_H_

#define _STRING_H_

#define CHAR_PER_LINE	80
#define LINE_PER_SCREEN	25

extern	u32	disp_pos;

void disp_str(char*);

void itoa(char*, u32);

void disp_int(u32);

void memcpy(char*, char*, u32);

#endif
