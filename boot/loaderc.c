#include "fs.h"
#include "ext2_fs.h"


#define ADDR_OF_KERNEL		0x100000

#define EXT2_SB_OFF		0x400
#define EXT2_BG_OFF		0x800
#define EXT2_SUPER_MAGIC	0xEF53
#define	INODE_SIZE		sizeof ( struct ext2_inode )

void read_inode(struct ext2_inode *p, t_32 num)	__attribute__ ((section("loader.text")));
void read_data(struct ext2_inode *p, void* dst) __attribute__ ((section("loader.text")));
void cmain()					__attribute__ ((section("loader.text")));

t_32	inode_table_off				__attribute__ ((section("loader.data")));
t_32	block_size				__attribute__ ((section("loader.data")));
struct ext2_dir_entry_2	*dir			__attribute__ ((section("loader.data")));
extern	char	kern_name[]			__attribute__ ((section("loader.data"))); 


char kern_name[]="kernel.bin";
#define KERNEL_NAME_LEN 10

void read_inode(struct ext2_inode *p, t_32 num) 
{
	read(p, inode_table_off + (num - 1) * INODE_SIZE, INODE_SIZE);
}

void read_data(struct ext2_inode *p, void* dst)
{
	register int i;
	for(i = 0; i < p->i_blocks && i < 12; i++)
	{
		read(dst, p->i_block[i] * block_size, block_size);
		dst += block_size;
	}
}

void cmain()
{
	register void (*kern_entry) () = (void(*) ()) ADDR_OF_KERNEL;
	struct ext2_super_block sb;
	struct ext2_group_desc	bg;
	struct ext2_inode	inode;

	read(&sb, EXT2_SB_OFF, sizeof sb);
	read(&bg, EXT2_BG_OFF, sizeof bg);
	
	block_size = 1024 << sb.s_log_block_size;
	inode_table_off = bg.bg_inode_table * block_size;

	read_inode(&inode, EXT2_BOOT_LOADER_INO);
	read_data(&inode, (void *)ADDR_OF_KERNEL);

	kern_entry();
}

