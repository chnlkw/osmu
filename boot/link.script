SECTIONS
{
	boot 0x7c00 :
	{
		*(.text)
	}
	loader 0x96c00 :
	{
		*(loader.head)
		*(loader.text)
		*(loader.data)
	}
}
