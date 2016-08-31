
// Written in the D programming language.

/* Written by Walter Bright and Andrei Alexandrescu
 * http://www.digitalmars.com/d
 * Placed in the Public Domain.
 */

/********************************
 * Стандартные функции I/O, расширяющие $(B c).
 * $(B c) импортируется автоматически при импорте
 * $(B std.io).
 * Макрос:
 *	WIKI=Phobos/StdStdio
 */

module std.io;

import std.c;
import std.format;
import std.utf;
import std.string;
import std.gc;
public import std.console;


version (DigitalMars)
{
    version (Windows)
    {
	// Specific to the way Digital Mars C does stdio
	version = DIGITAL_MARS_STDIO;
    }
}

version (linux)
{
    // Specific to the way Gnu C does stdio
    version = GCC_IO;
    import os.linux;
}

version (OSX)
{
    version = GENERIC_IO;
}

version (FreeBSD)
{
    version = GENERIC_IO;
}

version (Solaris)
{
    version = GENERIC_IO;
}

version (DIGITAL_MARS_STDIO)
{
     extern  (C) 
	 
    {
	;
	/* **
	 * Digital Mars under-the-hood C I/O functions
	 */
	int _fputc_nlock(int, FILE*);
	int _fputwc_nlock(int, FILE*);
	int _fgetc_nlock(FILE*);
	int _fgetwc_nlock(FILE*);
	int __fp_lock(FILE*);
	void __fp_unlock(FILE*);
    }
    alias _fputc_nlock FPUTC;
    alias _fputwc_nlock FPUTWC;
    alias _fgetc_nlock FGETC;
    alias _fgetwc_nlock FGETWC;

    alias __fp_lock FLOCK;
    alias __fp_unlock FUNLOCK;
	
	alias FPUTC ФПОМЕСТС;
	alias FPUTWC ФПОМЕСТШ;
	alias FGETC ФИЗВЛС;
	alias FGETWC ФИЗВЛШ;
	alias FLOCK ФБЛОК;
	alias FUNLOCK ФРБЛОК;
}
else version (GCC_IO)
{
    /* **
     * Gnu under-the-hood C I/O functions; see
     * http://www.gnu.org/software/libc/manual/html_node/I_002fO-on-Streams.html#I_002fO-on-Streams
     */
    extern  (C)
    {
	int fputc_unlocked(int, FILE*);
	int fputwc_unlocked(wchar_t, FILE*);
	int fgetc_unlocked(FILE*);
	int fgetwc_unlocked(FILE*);
	void flockfile(FILE*);
	void funlockfile(FILE*);
	ssize_t getline(char**, size_t*, FILE*);
	ssize_t getdelim (char**, size_t*, int, FILE*);
    }

    alias fputc_unlocked FPUTC;
    alias fputwc_unlocked FPUTWC;
    alias fgetc_unlocked FGETC;
    alias fgetwc_unlocked FGETWC;

    alias flockfile FLOCK;
    alias funlockfile FUNLOCK;
}
else version (GENERIC_IO)
{
    extern  (C)
    {
	void flockfile(FILE*);
	void funlockfile(FILE*);
    }

    alias fputc FPUTC;
    alias fputwc FPUTWC;
    alias fgetc FGETC;
    alias fgetwc FGETWC;

    alias flockfile FLOCK;
    alias funlockfile FUNLOCK;
}
else
{
    static assert(0, "unsupported C I/O system");
}

alias readln читайнс;
alias fwritefln фпишифнс;
alias fwritef фпишиф;
alias writefln пишифнс;
alias writef пишиф;
alias StdioException ВВИскл;

/*********************
 * Выводится при ошибке I/O.
 */
class StdioException : Exception
{
    uint errno;			// operating system error code

    this(string msg);
    this(uint errno);
    static void opCall(string msg);

    static void opCall();
}

//private
void writefx(FILE* fp, TypeInfo[] arguments, void* argptr, int newline=false);


/***********************************
 * Arguments are formatted per the
 * $(LINK2 std_format.html#format-string, format strings)
 * and written to $(B stdout).
 */

void writef(...);

/***********************************
 * То же, что и $(B writef), но к выводу добавляется
 * символ новой строки.
 */

void writefln(...);
/***********************************
 * Same as $(B writef), but output is sent to the
 * stream fp instead of $(B stdout).
 */

void fwritef(FILE* fp, ...);
/***********************************
 * Same as $(B writefln), but output is sent to the
 * stream fp instead of $(B stdout).
 */

void fwritefln(FILE* fp, ...);

/**********************************
 * Read line from stream fp.
 * Возвращает:
 *	null for end of file,
 *	char[] for line read from fp, including terminating '\n'
 * Параметры:
 *	fp = input stream
 * Выводит исключение:
 *	$(B StdioException) on error
 * Пример:
 *	Reads $(B stdin) and writes it to $(B stdout).
---
import std.io;

int main()
{
    char[] buf;
    while ((buf = readln()) != null)
	writef("%s", buf);
    return 0;
}
---
 */
string readln(FILE* fp = stdin);

/**********************************
 * Read line from stream fp and write it to buf[],
 * including terminating '\n'.
 *
 * This is often faster than readln(FILE*) because the buffer
 * is reused each call. Note that reusing the buffer means that
 * the previous contents of it need to be copied if needed.
 * Параметры:
 *	fp = input stream
 *	buf = buffer used to store the resulting line data. buf
 *		is resized as necessary.
 * Возвращает:
 *	0 for end of file, otherwise
 *	number of characters read
 * Выводит исключение:
 *	$(B StdioException) on error
 * Пример:
 *	Reads $(B stdin) and writes it to $(B stdout).
---
import std.io;

int main()
{
    char[] buf;
    while (readln(stdin, buf))
	writef("%s", buf);
    return 0;
}
---
 */
size_t readln(FILE* fp, inout char[] buf);

/** ditto */
size_t readln(inout char[] buf)
{
    return readln(stdin, buf);
}

