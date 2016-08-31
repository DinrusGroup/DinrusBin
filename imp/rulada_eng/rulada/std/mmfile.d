// Written in the D programming language

/* Copyright 2004-2008 by Digital Mars
 * Written by Walter Bright and Matthew Wilson
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, in both source and binary form, subject to the following
 * restrictions:
 *
 * -  The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * -  Altered source versions must be plainly marked as such, and must not
 *    be misrepresented as being the original software.
 * -  This notice may not be removed or altered from any source
 *    distribution.
 *
 */

/**
 * Read and write memory mapped files.
 * Macros:
 *	WIKI=Phobos/StdMmfile
 */

module std.mmfile;

private import std.file;
private import std.c;
private import std.path;
private import std.string;

//debug = MMFILE;

version (Win32)
{
	private import os.windows;
	private import std.utf;
	
	private uint dwVersion;
	
	static this()
	{	// http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/base/getversion.asp
		dwVersion = GetVersion();
	}
}
else version (Posix)
{
	private import os.posix;
}
else
{
	static assert(0);
}

/**
 * Объекты MmFile контролируют файловые ресурсы, размещенные в памяти.
 */
alias MmFile РПФайл;
class MmFile
{

alias flush слей;
alias length длина;
alias mode режим;
alias opSlice опСрез;
alias opIndex опИндекс;
alias opIndexAssign опПрисвоитьИндекс;

    /**
     * Режим, в котором открывается файл, размещаемый в памяти (ФРП).
     */
  enum Mode
    {	Read,		/// read existing file
	ReadWriteNew,	/// delete existing file, write new file
	ReadWrite,	/// read/write existing file, create if not existing
	ReadCopyOnWrite, /// read/write existing file, copy on write
	Чтение = Read,
	ЧтенЗапНов = ReadWriteNew,
	ЧтенЗап = ReadWrite,
	ЧтенКопирПриЗап = ReadCopyOnWrite,
    }
	alias Mode Режим;
    
	/*enum Mode Режим
    {
	Чтение = Mode.Read,		/// read existing file
	ЧтенЗапНов = Mode.ReadWriteNew,	/// delete existing file, write new file
	ЧтенЗап = Mode.ReadWrite,	/// read/write existing file, create if not existing
	ЧтенКопирПриЗап = Mode.ReadCopyOnWrite, /// read/write existing file, copy on write
    }*/
	
    /**
     * Открыть ФРП filename для чтения.
     * Файл закрывается при удалении экземпляра объекта.
     * Выводит исключение:
     *	std.file.FileException
     */
    this(string filename);
    
    /**
     * Открыть ФРП filename в каком-то режиме.
     * Файл закрывается при удалении экземпляра объекта.
     * Параметры:
     *	filename = название файла.
     *		Если null, то создается анонимный мэппинг файла.
     *	mode = апределенный ранее режим доступа.
     *	size =  размер файла. Если 0, то принимается за размер
     *		существующего файла.
     *	address = предпочтительный адрес для мэппинга файла,
     *		хотя система не обязательно к этому прислушивается.
     *		Если null, то система выберет наиболее удобный ей адрес.
     *	window = предпочтительный размер блока данных, которые переносятся в память за один приём,
     *		причём 0 означает поместить целиком весь файл.  The window size must be a
     *		multiple of the memory allocation page size. 
     * Выводит исключение:
     *	std.file.FileException
     */
    this(string filename, Mode mode, ulong size, void* address,
			size_t window = 0);

	/**
	 * Flushes pending output and closes the memory mapped file.
	 */
	~this();

	/* Flush any pending output.
	*/
	void flush();

	/**
	 * Gives size in bytes of the memory mapped file.
	 */
	ulong length();

	/**
	 * Read-only property returning the file mode.
	 */
	Mode mode();
	/**
	 * Returns entire file contents as an array.
	 */
	void[] opSlice();
	/**
	 * Returns slice of file contents as an array.
	 */
	void[] opSlice(ulong i1, ulong i2);
	/**
	 * Returns byte at index i in file.
	 */
	ubyte opIndex(ulong i);
	/**
	 * Sets and returns byte at index i in file to value.
	 */
	ubyte opIndexAssign(ubyte value, ulong i);

	// return true if the given position is currently mapped
	private int mapped(ulong i) ;
	// unmap the current range
	private void unmap() ;

	// map range
	private void map(ulong start, size_t len) ;
	// ensure a given position is mapped
	private void ensureMapped(ulong i) ;
	// ensure a given range is mapped
	private void ensureMapped(ulong i, ulong j) ;
	private:
	string filename;
	void[] data;
	ulong  start;
	size_t window;
	ulong  size;
	Mode   mMode;
	void*  address;

	version (Win32)
	{
		HANDLE hFile = INVALID_HANDLE_VALUE;
		HANDLE hFileMap = null;
		uint dwDesiredAccess;
	}
	else version (Posix)
	{
		int fd;
		int prot;
		int flags;
		int fmode;
	}
	else
	{
		static assert(0);
	}

	// Report error, where errno gives the error number
	void ErrNo();
}

unittest {
	const size_t K = 1024;
	size_t win = 64*K; // assume the page size is 64K
	version(Win32) {
		/+ these aren't defined in windows so let's use the default
         SYSTEM_INFO sysinfo;
         GetSystemInfo(&sysinfo);
         win = sysinfo.dwAllocationGranularity;
		+/
	} else version (Posix) {
		// getpagesize() is not defined in the unix D headers so use the guess
	}
	MmFile mf = new MmFile("testing.txt",MmFile.Mode.ReadWriteNew,100*K,null,win);
	ubyte[] str = cast(ubyte[])"1234567890";
	ubyte[] data = cast(ubyte[])mf[0 .. 10];
	data[] = str[];
	assert( mf[0 .. 10] == str );
	data = cast(ubyte[])mf[50 .. 60];
	data[] = str[];
	assert( mf[50 .. 60] == str );
	ubyte[] data2 = cast(ubyte[])mf[20*K .. 60*K];
	assert( data2.length == 40*K );
	assert( data2[length-1] == 0 );
	mf[100*K-1] = cast(ubyte)'b';
	data2 = cast(ubyte[])mf[21*K .. 100*K];
	assert( data2.length == 79*K );
	assert( data2[length-1] == 'b' );
	delete mf;
	std.file.remove("testing.txt");

	// Create anonymous mapping
	auto test = new MmFile(null, MmFile.Mode.ReadWriteNew, 1024*1024, null);
}
