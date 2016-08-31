// Written in the D programming language

/**
 * Boilerplate:
 *	$(std_boilerplate.html)
 * Macros:
 *	WIKI = Phobos/StdOutbuffer
 * Copyright:
 *	Copyright (c) 2001-2005 by Digital Mars
 *	All Rights Reserved
 *	www.digitalmars.com
 */


// Written by Walter Bright

module std.outbuffer;

private
{
    import std.string;
    import std.gc;
    import std.c;    
}

/*********************************************
 * OutBuffer provides a way to build up an array of bytes out
 * of raw data. It is useful for things like preparing an
 * array of bytes to write out to a file.
 * OutBuffer's byte order is the format c to the computer.
 * To control the byte order (endianness), use a class derived
 * from OutBuffer.
 */

class OutBuffer
{
    ubyte data[];
	alias data данные;
	
    uint offset;
	alias offset смещение;

   // invariant
   // {
	//printf("this = %p, offset = %x, data.length = %u\n", this, offset, data.length);
	//assert(offset <= data.length);
	//assert(data.length <= std.gc.capacity(data.ptr));
   //}

    this();

    /*********************************
     * Convert to array of bytes.
     */

    ubyte[] toBytes();
alias toBytes вБайты;
    /***********************************
     * Preallocate nbytes more to the size of the internal buffer.
     *
     * This is a
     * speed optimization, a good guess at the maximum size of the resulting
     * buffer will improve performance by eliminating reallocations and copying.
     */


    void reserve(uint nbytes);
alias reserve врезерв;

    /*************************************
     * Append data to the internal buffer.
     */

    void write(ubyte[] bytes);

    void write(ubyte b);

    void write(byte b);
    void write(char c);

    void write(ushort w);

    void write(short s);

    void write(wchar c);

    void write(uint w);

    void write(int i);

    void write(ulong l);

    void write(long l);

    void write(float f);

    void write(double f)	;

    void write(real f)	;

    void write(string s)	;

    void write(OutBuffer buf)	;
	
	alias write пиши;
    /****************************************
     * Append nbytes of 0 to the internal buffer.
     */

    void fill0(uint nbytes);
	alias fill0 занули;

    /**********************************
     * 0-fill to align on power of 2 boundary.
     */

    void alignSize(uint alignsize);
alias alignSize раскладиРазм;
    /****************************************
     * Optimize common special case alignSize(2)
     */

    void align2();
alias align2 расклад2;
    /****************************************
     * Optimize common special case alignSize(4)
     */

    void align4();
alias align4 расклад4;
    /**************************************
     * Convert internal buffer to array of chars.
     */

    override char[] toString();
alias toString вТкст;
    /*****************************************
     * Append output of C's vprintf() to internal buffer.
     */

    void vprintf(string format, std.c.va_list args);
alias vprintf ввыводф;
    /*****************************************
     * Append output of C's printf() to internal buffer.
     */

    void printf(string format, ...);
alias printf выводф;
    /*****************************************
     * At offset index into buffer, create nbytes of space by shifting upwards
     * all data past index.
     */

    void spread(uint index, uint nbytes);
	alias spread простели;
}
alias OutBuffer БуферВывода;
unittest
{
    //printf("Starting OutBuffer test\n");

    БуферВывода буф = new БуферВывода();

    //printf("buf = %p\n", buf);
    //printf("buf.offset = %x\n", buf.offset);
    assert(буф.смещение == 0);
    буф.пиши("hello");
    буф.пиши(cast(байт)0x20);
    буф.пиши("world");
    буф.выводф(" %d", 6);
    //printf("buf = '%.*s'\n", buf.toString());
    assert(сравни(буф.вТкст(), "hello world 6") == 0);
	выводф ("ОК");
}
