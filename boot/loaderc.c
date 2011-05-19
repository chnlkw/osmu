#include "fs.h"
#include "ext2_fs.h"

#ifdef DEBUG

#include "string.h"

#endif

#define ADDR_OF_KERNEL		0x100000

#define EXT2_SB_OFF		0x400
#define EXT2_BG_OFF		0x800
#define EXT2_SUPER_MAGIC	0xEF53
#define	INODE_SIZE		sizeof( struct ext2_inode)

t_32	inode_table_off;
t_32	block_size;

void read_inode(struct ext2_inode *p, t_32 num)
{
	read(p, inode_table_off + (num - 1) * INODE_SIZE, INODE_SIZE);
}
/*
void read_data(struct ext2_inode *p, void* dst)
{
	register int i;
	for(i = 0; i < p->i_blocks && i < 12; i++)
	{
		read(dst, p->i_block[i] * block_size, block_size);
		dst += block_size;
	}
}
*/
void cmain()
{
#ifdef DEBUG
	disp_str("Loading....\n");
#endif
	struct ext2_super_block sb;
	struct ext2_group_desc	bg;
	struct ext2_inode	inode;
	read(&sb, EXT2_SB_OFF, sizeof sb);
	read(&bg, EXT2_BG_OFF, sizeof bg);
	
//	while(sb.s_magic != EXT2_SUPER_MAGIC);

	block_size = 1024 << sb.s_log_block_size;
	inode_table_off = bg.bg_inode_table * block_size;
	read_inode(&inode, EXT2_ROOT_INO);
//	read_data(&inode, ADDR_OF_KERNEL);
//	while(inode.i_mode | 0x4000);
#ifdef DEBUG
	disp_str("Done.\n");
#endif
	sleep();
	while(1);
}

