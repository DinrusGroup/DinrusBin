module std.zlib;

private import stdrus;

enum
{
	Z_NO_FLUSH      = 0,
	Z_SYNC_FLUSH    = 2,
	Z_FULL_FLUSH    = 3,
	Z_FINISH        = 4,
}

enum
{
	З_БЕЗ_СЛИВА      = 0,
	З_СИНХ_СЛИВ    = 2,
	З_ПОЛН_СЛИВ    = 3,
	З_ФИНИШ       = 4,
}

alias stdrus.адлер32 adler32;
alias stdrus.цпи32 crc32;
alias stdrus.сожмиЗлиб compress;
alias stdrus.разожмиЗлиб uncompress;

class Compress:stdrus.СжатиеЗлиб
{
    this(int level)
    in
    {
	assert(1 <= level && level <= 9);
    }
    body
    {
	super(level);
    }

    this() {super(); }
    ~this() {}	

    void[] compress(void[] buf)
    {	
	return super.сжать(buf);
    }

    void[] flush(int mode = Z_FINISH)
    in
    {
	assert(mode == Z_FINISH || mode == Z_SYNC_FLUSH || mode == Z_FULL_FLUSH);
    }
    body
    {	
	return super.слей(mode);
    }
}


class UnCompress:stdrus.РасжатиеЗлиб
{
    this(uint destbufsize)   {	super(destbufsize); }
    this()    {	super(); }
    ~this()    {}

    void[] uncompress(void[] buf)
    {	
	return super.расжать(buf);
    }

    void[] flush()
    {
	return super.слей();
    }
}
/+
/* ========================== unittest ========================= */

private import std.io;
private import std.random;

unittest // by Dave
{
    debug(zlib) printf("std.zlib.unittest\n");

    bool CompressThenUncompress (ubyte[] src)
    {
      try {
	ubyte[] dst = cast(ubyte[])std.zlib.compress(cast(void[])src);
	double ratio = (dst.length / cast(double)src.length);
	debug(zlib) writef("src.length:  ", src.length, ", dst: ", dst.length, ", Ratio = ", ratio);
	ubyte[] uncompressedBuf;
	uncompressedBuf = cast(ubyte[])std.zlib.uncompress(cast(void[])dst);
	assert(src.length == uncompressedBuf.length);
	assert(src == uncompressedBuf);
      }
      catch {
	debug(zlib) writefln(" ... Exception thrown when src.length = ", src.length, ".");
	return false;
      }
      return true;
    }


    // smallish buffers
    for(int idx = 0; idx < 25; idx++) {
        char[] buf = new char[rand() % 100];

        // Alternate between more & less compressible
        foreach(inout char c; buf) c = ' ' + (rand() % (idx % 2 ? 91 : 2));

        if(CompressThenUncompress(cast(ubyte[])buf)) {
            debug(zlib) printf("; Success.\n");
        } else {
            return;
        }
    }

    // larger buffers
    for(int idx = 0; idx < 25; idx++) {
        char[] buf = new char[rand() % 1000/*0000*/];

        // Alternate between more & less compressible
        foreach(inout char c; buf) c = ' ' + (rand() % (idx % 2 ? 91 : 10));

        if(CompressThenUncompress(cast(ubyte[])buf)) {
            debug(zlib) printf("; Success.\n");
        } else {
            return;
        }
    }

    debug(zlib) printf("PASSED std.zlib.unittest\n");
}


unittest // by Artem Rebrov
{
    Compress cmp = new Compress;
    UnCompress decmp = new UnCompress;

    void[] input;
    input = "tesatdffadf";

    void[] buf = cmp.compress(input);
    buf ~= cmp.flush();
    void[] output = decmp.uncompress(buf);

    //writefln("input = '%s'", cast(char[])input);
    //writefln("output = '%s'", cast(char[])output);
    assert( output[] == input[] );
}
+/
