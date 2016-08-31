/**
 * Compress/decompress data using the $(LINK2 http://www._zlib.net, zlib library).
 *
 * Ссылки:
 *	$(LINK2 http://en.wikipedia.org/wiki/Zlib, Wikipedia)
 * License:
 *	Public Domain
 *
 * Macros:
 *	WIKI = Phobos/StdZlib
 */


module std.zlib;

//debug=zlib;		// uncomment to turn on debugging printf's

private import auxc.zlib;

// Values for 'mode'

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
/*************************************
 * Errors throw a ZlibException.
 */

class ZlibException : Exception
{
    this(int errnum);
}
alias ZlibException ИсклЗлиб;
/**************************************************
 * Compute the Adler32 checksum of the data in buf[]. adler is the starting
 * value when computing a cumulative checksum.
 */

uint adler32(uint adler, void[] buf);
alias adler32 адлер32;
unittest
{
    static ubyte[] data = [1,2,3,4,5,6,7,8,9,10];

    uint adler;

    debug(zlib) printf("D.zlib.adler32.unittest\n");
    adler = adler32(0u, cast(void[])data);
    debug(zlib) printf("adler = %x\n", adler);
    assert(adler == 0xdc0037);
}

/*********************************
 * Compute the CRC32 checksum of the data in buf[]. crc is the starting value
 * when computing a cumulative checksum.
 */

uint crc32(uint crc, void[] buf);
alias crc32 кс32;
unittest
{
    static ubyte[] data = [1,2,3,4,5,6,7,8,9,10];

    uint crc;

    debug(zlib) printf("D.zlib.crc32.unittest\n");
    crc = crc32(0u, cast(void[])data);
    debug(zlib) printf("crc = %x\n", crc);
    assert(crc == 0x2520577b);
}

/*********************************************
 * Compresses the data in srcbuf[] using compression _level level.
 * The default value
 * for level is 6, legal values are 1..9, with 1 being the least compression
 * and 9 being the most.
 * Returns the compressed data.
 */
alias compress сжать;

void[] compress(void[] srcbuf, int level);

/*********************************************
 * ditto
 */

void[] compress(void[] buf);
/*********************************************
 * Decompresses the data in srcbuf[].
 * Параметры: destlen = size of the uncompressed data.
 * It need not be accurate, but the decompression will be faster if the exact
 * size is supplied.
 * Возвращает: the decompressed data. */
 
alias uncompress расжать;
void[] uncompress(void[] srcbuf, uint destlen = 0u, int winbits = 15);

	

unittest
{
    ubyte[] src = cast(ubyte[])
"the quick brown fox jumps over the lazy dog\r
the quick brown fox jumps over the lazy dog\r
";
    ubyte[] dst;
    ubyte[] result;

    //arrayPrint(src);
    dst = cast(ubyte[])compress(cast(void[])src);
    //arrayPrint(dst);
    result = cast(ubyte[])uncompress(cast(void[])dst);
    //arrayPrint(result);
    assert(result == src);
}

/+
void arrayPrint(ubyte[] array);
+/

/*********************************************
 * Used when the data to be compressed is not all in one buffer.
 */
alias Compress Сжатие;

class Compress
{
  private:
    z_stream zs;
    int level = Z_DEFAULT_COMPRESSION;
	alias level уровень;
    int inited;

    void error(int err);

  public:

    /**
     * Construct. level то же самое, что for D.zlib.compress().
     */
    this(int level);

    /// ditto
    this();
    ~this();

    /**
     * Compress the data in buf and return the compressed data.
     * The buffers
     * returned from successive calls to this should be concatenated together.
     */
    void[] compress(void[] buf);
	alias compress сжать;
    /***
     * Compress and return any remaining data.
     * The returned data should be appended to that returned by compress().
     * Параметры:
     *	mode = one of the following: 
     *		$(DL
		    $(DT Z_SYNC_FLUSH )
		    $(DD Syncs up flushing to the next byte boundary.
			Used when more data is to be compressed later on.)
		    $(DT Z_FULL_FLUSH )
		    $(DD Syncs up flushing to the next byte boundary.
			Used when more data is to be compressed later on,
			and the decompressor needs to be restartable at this
			point.)
		    $(DT Z_FINISH)
		    $(DD (default) Used when finished compressing the data. )
		)
     */
    void[] flush(int mode = Z_FINISH);
	alias flush слить;
}
/******
 * Used when the data to be decompressed is not all in one buffer.
 */
alias UnCompress Расжатие;
class UnCompress
{
  private:
    z_stream zs;
    int inited;
    int done;
    uint destbufsize;

    void error(int err);

  public:

    /**
     * Construct. destbufsize то же самое, что for D.zlib.uncompress().
     */
    this(uint destbufsize);

    /** ditto */
    this();

    ~this();

    /**
     * Decompress the data in buf and return the decompressed data.
     * The buffers returned from successive calls to this should be concatenated
     * together.
     */
    void[] uncompress(void[] buf);
	alias uncompress расжать;

    /**
     * Decompress and return any remaining data.
     * The returned data should be appended to that returned by uncompress().
     * The UnCompress object cannot be used further.
     */
    void[] flush();
	alias flush слить;
}

/* ========================== unittest ========================= */

private import std.io;
private import std.random;

unittest // by Dave
{
    printf("std.zlib.unittest\n");

    бул СжатьРасжать (ббайт[] src)
    {
      try {
	ббайт[] dst = cast(ббайт[])сжать(cast(проц[])src);
	дво ratio = (dst.length / cast(дво)src.length);
	writef("src.length:  ", src.length, ", dst: ", dst.length, ", Ratio = ", ratio);
	ббайт[] uncompressedBuf;
	uncompressedBuf = cast(ббайт[])расжать(cast(проц[])dst);
	assert(src.length == uncompressedBuf.length);
	assert(src == uncompressedBuf);
      }
      catch {
	writefln(" ... Exception thrown when src.length = ", src.length, ".");
	return false;
      }
      return true;
    }


    // smallish buffers
    for(int idx = 0; idx < 25; idx++) {
        сим[] buf = new сим[rand() % 100];

        // Alternate between more & less compressible
        foreach(inout сим c; buf) c = ' ' + (rand() % (idx % 2 ? 91 : 2));

        if(СжатьРасжать(cast(ббайт[])buf)) {
            printf("; Success.\n");
        } else {
            return;
        }
    }

    // larger buffers
    for(int idx = 0; idx < 25; idx++) {
        сим[] buf = new сим[rand() % 1000/*0000*/];

        // Alternate between more & less compressible
        foreach(inout сим c; buf) c = ' ' + (rand() % (idx % 2 ? 91 : 10));

        if(СжатьРасжать(cast(ббайт[])buf)) {
            printf("; Success.\n");
        } else {
            return;
        }
    }

    printf("PASSED std.zlib.unittest\n");
}


unittest // by Artem Rebrov
{
    Сжатие cmp = new Сжатие;
    Расжатие decmp = new Расжатие;

    проц[] ввод;
    ввод = "tesatdffadf";

    проц[] буф= сжать(ввод);
    буф~= cmp.слить();
    проц[] вывод = decmp.расжать(буф);

    //writefln("ввод = '%s'", cast(сим[])ввод);
    //writefln("output = '%s'", cast(сим[])output);
    assert( вывод[] == ввод[] );
}

