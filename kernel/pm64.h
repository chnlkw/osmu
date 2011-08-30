#define SEG(base, limit, type)	\
	.word	limit & 0xFFFF;		\
	.word	base & 0xFFFF;		\
	.byte	(base >> 16) & 0xFF;	\
	.word	(type & 0xF0FF) | ((limit >> 8) & 0x0F00);	\
	.byte	(base >> 24) & 0xFF;


#define	SEG_A	0x1
#define	SEG_W	0x2
#define	SEG_E	0x4
#define	SEG_X	0x8

#define SEG_S	0x10

#define DPL_0	(0x0 << 5)
#define DPL_1	(0x1 << 5)
#define DPL_2	(0x2 << 5)
#define DPL_3	(0x3 << 5)

#define SEG_P	0x80

#define SEG_L	0x2000
#define SEG_D	0x4000
#define SEG_B	0
#define SEG_G	0x8000

#define SEG_NULL	SEG(0, 0, 0)
#define SEG_CODE32	SEG(0, 0xFFFFF, SEG_G | SEG_D | SEG_P | SEG_S | SEG_W | SEG_X )
#define SEG_DATA32	SEG(0, 0xFFFFF, SEG_G | SEG_D | SEG_P | SEG_S | SEG_W )
#define SEG_CODE64	SEG(0, 0xFFFFF, SEG_G | SEG_L | SEG_P | SEG_S | SEG_W | SEG_X )
#define SEG_DATA64	SEG(0, 0xFFFFF,         SEG_L | SEG_P | SEG_S | SEG_W         )
