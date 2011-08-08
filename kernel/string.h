#include "type.h"

#ifndef _STRING_H_

#define _STRING_H_

#define CHAR_PER_LINE	80

extern	t_32	disp_pos __attribute__ ((section("loader.data")));

void disp_str(char *str)__attribute__ ((section("loader.text")));

void itoa(char *str, t_32 num)__attribute__ ((section("loader.text")));

void disp_int(t_32 num)__attribute__ ((section("loader.text")));

#endif
