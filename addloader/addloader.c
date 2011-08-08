#include <stdio.h>
#include <ext2fs/ext2fs.h>


errcode_t	err;
io_manager	manager;
ext2_filsys	fs;
struct ext2_inode	root_ino, loader_ino;
ext2_ino_t	loader_ino_t;
char		*image_name, *loader_name;

int main(int argc, char *argv[])
{
	if(argc!=3)
	{
		printf("usage: %s ext2image loadername\n",argv[0]);
		return 1;
	}
	image_name = argv[1];
	loader_name = argv[2];
	if(err = ext2fs_open(image_name, EXT2_FLAG_FORCE | EXT2_FLAG_RW, 0, 0, unix_io_manager, &fs))
	{
		fprintf(stderr, "ERROR: open image %s failed  CODE:%x %x\n", image_name, (int)err, ENOENT);
		return 1;
	}
/*	if(err = ext2fs_read_inode(fs, EXT2_ROOT_INO, &root_ino))
	{
		fprintf(stderr, "ERROR: root inode read failed\n");
	}*/
	if(err = ext2fs_namei_follow(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, loader_name, &loader_ino_t))
	{
		fprintf(stderr, "ERROR: loader file %s not found CODE: %x\n", loader_name, (int)err);
		return 1;
	}
	//printf("loader_ino %d\n",loader_ino_t);
	if(err = ext2fs_read_inode(fs, loader_ino_t, &loader_ino) )
	{
		fprintf(stderr, "ERROR: read inode %d failed.\n", loader_ino_t);
		return 1;
	}
	if(err = ext2fs_write_inode(fs, EXT2_BOOT_LOADER_INO, &loader_ino))
	{
		fprintf(stderr, "ERROR: write bootloader inode failed. CODE: %d\n", (int)err);
		return 1;
	}
	if(err = ext2fs_close(fs))
	{
		fprintf(stderr, "ERROR: close image failed. CODE: %d\n", (int)err);
		return 1;
	}
	fprintf(stderr, "Done.\n");
	return 0;
}
