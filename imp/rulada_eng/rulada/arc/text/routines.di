/******************************************************************************* 

	Different routines that can be performed on text.
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
	Different routines that can be performed on text.

	This code originally written by h3r3tic. 

	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/

module arc.text.routines; 

import
	arc.memory.routines,
	std.utf,
	std.string;

///
char* toStringzFast(char[] str) 
{
	static char[]	buffer;
	if (buffer.length < str.length + 1) {
		buffer.realloc(str.length + 1, false);
	}
	buffer[0 .. str.length] = str[];
	buffer[str.length] = 0;
	return buffer.ptr;
}

///
char[] toUTF8Fast(dchar[] s)
{
    static char[] r;
    size_t i;
    size_t slen = s.length;

	r.realloc(slen);

    for (i = 0; i < slen; i++)
    {	dchar c = s[i];

	if (c <= 0x7F)
	    r[i] = c;		// fast path for ascii
	else
	{
		r.realloc(i);
	    foreach (dchar cc; s[i .. slen])
	    {
		encodeFast(r, cc);
	    }
	    break;
	}
    }
    return r;
}

///
void encodeFast(inout char[] s, dchar c)
in
{
	assert(isValidDchar(c));
}
body
{
	char[] r = s;

	if (c <= 0x7F)
	{
		//r ~= cast(char) c;
		r.append(cast(char)c);
	}
	else
	{
		char[4] buf;
		uint L;

		if (c <= 0x7FF)
		{
		buf[0] = cast(char)(0xC0 | (c >> 6));
		buf[1] = cast(char)(0x80 | (c & 0x3F));
		L = 2;
		}
		else if (c <= 0xFFFF)
		{
		buf[0] = cast(char)(0xE0 | (c >> 12));
		buf[1] = cast(char)(0x80 | ((c >> 6) & 0x3F));
		buf[2] = cast(char)(0x80 | (c & 0x3F));
		L = 3;
		}
		else if (c <= 0x10FFFF)
		{
		buf[0] = cast(char)(0xF0 | (c >> 18));
		buf[1] = cast(char)(0x80 | ((c >> 12) & 0x3F));
		buf[2] = cast(char)(0x80 | ((c >> 6) & 0x3F));
		buf[3] = cast(char)(0x80 | (c & 0x3F));
		L = 4;
		}
		else
		{
		assert(0);
		}
		r.realloc(r.length + L);
		r[length - L .. length] = buf[0 .. L];
		//r ~= buf[0 .. L];
	}
	s = r;
}

/// split lines template func
charType[][] splitlines(charType)(charType[] s)
{
    uint i;
    uint istart;
    uint nlines;
    charType[][] lines;

    nlines = 0;
    for (i = 0; i < s.length; i++)
    {	
		charType c;

		c = s[i];
		if (c == '\r' || c == '\n')
		{
			nlines++;
			istart = i + 1;
			if (c == '\r' && i + 1 < s.length && s[i + 1] == '\n')
			{
			i++;
			istart++;
			}
		}
	}
	if (istart != i)
	nlines++;

	lines = new charType[][nlines];
	nlines = 0;
	istart = 0;

    for (i = 0; i < s.length; i++)
    {	
		charType c;

		c = s[i];
		if (c == '\r' || c == '\n')
		{
			lines[nlines] = s[istart .. i];
			nlines++;
			istart = i + 1;

			if (c == '\r' && i + 1 < s.length && s[i + 1] == '\n')
			{
				i++;
				istart++;
			}
		}
    }
    if (istart != i)
    {	
		lines[nlines] = s[istart .. i];
		nlines++;
    }

    assert(nlines == lines.length);
    return lines;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
