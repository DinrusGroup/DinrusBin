/*
 *  Copyright (C) 2005-2006 by Digital Mars, www.digitalmars.com
 *  Written by Walter Bright
 *
 *  This software is provided 'as-is', without any express or implied
 *  warranty. In no event will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, in both source and binary form, subject to the following
 *  restrictions:
 *
 *  o  The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *  o  Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *  o  This notice may not be removed or altered from any source
 *     distribution.
 */

/**
 * Code coverage analyzer.
 * Bugs:
 *	$(UL
 *	$(LI the execution counters are 32 bits in size, and can overflow)
 *	$(LI inline asm statements are not counted)
 *	)
 * Macros:
 *	WIKI = Phobos/StdCover
 */

module std.cover;

private import std.io;
private import std.file;
private import std.bitarray;
private import std.c;
private
{
    struct Cover
    {
	string filename;
	BitArray valid;
	uint[] data;
    }

    Cover[] gdata;
    string srcpath;
    string dstpath;
    bool merge;
}

/***********************************
 * Установить путь, по которому расположениы файлы-исходники.
 */

void setSourceDir(string pathname)
{
    srcpath = pathname;
}
alias setSourceDir устИсходнПапку;
/***********************************
 * Указать путь, по которому будут записаны файлы листинга.
 */

void setDestDir(string pathname);
alias setDestDir устПриёмнПапку;

/***********************************
 * Set merge mode.
 * Параметры:
 *	flag = true means new data is summed with existing data in the
 *		listing file; false means a new listing file is always
 *		created.
 */

void setMerge(bool flag);

extern (C) void _d_cover_register(string filename, BitArray valid, uint[] data);

static ~this();
	


