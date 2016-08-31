/* Public Domain */

/**
 * Support UTF-8 on Windows 95, 98 and ME systems.
 * Macros:
 *	WIKI = Phobos/StdWindowsCharset
 */

module rt.core.os.win.charset;

private import rt.core.os.windows;
private import rt.core.os.win.syserror;
private import std.utf;
private import std.string;
/////////////////////////////////////////////////////////
//МБТн расшифровывать как "Мультибайтный Текст с нулевым окончанием"
усим вМБТн(сим[] c, бцел кодСтр = 1);
//////////////////////////////////////////////////////////
сим[] изМБТн(усим c, цел кодСтр = 1);
/////////////////////////////////////////////////////////////
/******************************************
 * Преобразовать строку UTF-8 s в строку с нулевым окончанием в
 * 8-битном символьном наборе Windows.
 *
 * Параметры:
 * s = преобразуемая строка UTF-8.
 * codePage = номер целевой кодовой страницы, либо
 *   0 - ANSI,
 *   1 - OEM,
 *   2 - Mac
 *
 * Authors:
 *	yaneurao, Walter Bright, Stewart Gordon
 */

char* toMBSz(char[] s, uint codePage = 0)
{
    // Only need to do this if any chars have the high bit set
    foreach (char c; s)
    {
	if (c >= 0x80)
	{
	    char[] result;
	    int readLen;
	    wchar* ws = std.utf.toUTF16z(s);
	    result.length = WideCharToMultiByte(codePage, 0, ws, -1, null, 0,
		null, null);

	    if (result.length)
	    {
		readLen = WideCharToMultiByte(codePage, 0, ws, -1, result.ptr,
			result.length, null, null);
	    }

	    if (!readLen || readLen != result.length)
	    {
		throw new Exception("Couldn't convert string: " ~
			sysErrorString(GetLastError()));
	    }

	    return result.ptr;
	}
    }
    return std.string.toStringz(s);
}


/**********************************************
 * Converts the null-terminated string s from a Windows 8-bit character set
 * into a UTF-8 char array.
 *
 * Параметры:
 * s = UTF-8 string to convert.
 * codePage = is the number of the source codepage, or
 *   0 - ANSI,
 *   1 - OEM,
 *   2 - Mac
 * Authors: Stewart Gordon, Walter Bright
 */

char[] fromMBSz(char* s, int codePage = 0)
{
    char* c;

    for (c = s; *c != 0; c++)
    {
	if (*c >= 0x80)
	{
	    wchar[] result;
	    int readLen;

	    result.length = MultiByteToWideChar(codePage, 0, s, -1, null, 0);

	    if (result.length)
	    {
		readLen = MultiByteToWideChar(codePage, 0, s, -1, result.ptr,
			result.length);
	    }

	    if (!readLen || readLen != result.length)
	    {
		throw new Exception("Couldn't convert string: " ~
		    sysErrorString(GetLastError()));
	    }

	    return std.utf.toUTF8(result[0 .. result.length-1]); // omit trailing null
	}
    }
    return s[0 .. c-s];		// string is ASCII, no conversion necessary
}


