module std.io;

import cidrus;
import std.format;
import std.utf;
import std.string;
import gc;
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

