/******************************************************************************* 

	XML stream for reading and writing XML data.
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
	
	XML stream for reading and writing XML data.


	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/

module arc.xml.xmlstream;

import 
	std.stream,
	std.string,
	arc.xml.error,
	arc.xml.misc;

/// XML stream 
class XmlStream
{
private:
    Stream _stream;
    int _curLine;

public:
	/// init
	this(Stream s)
	{
		_stream = s;
		_curLine = 0;
	}

	/// getchar
	char getc()
	{
		char c = _stream.getc();
		if (c == '\n') _curLine++;
		return c;
	}

	/// unget char
	void ungetc(char c)
	{
		if (c == '\n') _curLine--;
		_stream.ungetc(c);
	}

	/// read string
	char[] readString(uint count)
	{
		char[] result = new char[count];
		int i;
		try
		{
			for (i = 0; i < count; i++)
				result[i] = getc();
			return result;
		}
		catch
		{
			return result[0 .. i];
		}
	}

	/// unread string
	void unReadString(char[] str)
	{
		for (int i = str.length - 1; i >= 0; i--)
			ungetc(str[i]);
	}

	/// eat white space
	void eatWhiteSpace()
	{
		char ch = getc();
		while (find(whitespace, ch) != -1)
			ch = getc();
		ungetc(ch);

		// Now to eat comments. (may as well make it as transparent as possible)
		char[] str = readString(4);
		if (str == "<!--")
		{
			char[] last = "   ";
			do
			{
				char c = getc();
				last = last[1..3];
				last ~= c;
				if (_stream.eof())
					throw new XmlError(lineNumber(), "Unexpected end of file while parsing comment.");
			} while (last != "-->");

			eatWhiteSpace();
		}
		else
		{
			unReadString(str);
		}
	}

	private char[] getToken()
	{
		char[] token;

		try
		{
			eatWhiteSpace();
			char ch = getc();
			if (isTokenChar(ch))
			{
				while (isTokenChar(ch)) // grab all alphanumeric characters until we hit nonalphanumeric
				{
					token ~= ch;
					ch = getc();
				}
				ungetc(ch);
			}
			else
				token ~= ch;

			return token;
		}
		catch
		{
			throw new XmlError(lineNumber(), "Unexpected end of file");
		}
	}

	/// expect
	void expect(char[] tok)
	{
		eatWhiteSpace();
		char[] s;
		for (int i = 0; i < tok.length; i++)
		{
			char ch = getc();
			s ~= ch;
			if (ch != tok[i])
				throw new XmlError(lineNumber(), "Expected: \"" ~ tok ~ "\".  Got: \"" ~ s ~ "\"");
		}
	}

	/// read until
	char[] readUntil(char end)
	{
		char[] s;
		char ch = getc();
		while (ch != end)
		{
			s ~= ch;
			ch = getc();
			if (_stream.eof())
				throw new XmlError(lineNumber(), "Unexpected end of file");
		}
		ungetc(ch); // put it back

		return s;
	}

	/// read node
	char[] readNode()
	{
		eatWhiteSpace();
		char ch = getc();

		if (ch == '<')                                 // data node
		{
			char[] nodeName = getToken();
			if (nodeName == "/")                        // closing tag
			{
				nodeName = getToken();
				expect(">");
				return "</" ~ nodeName ~ ">";
			}
			else
			{
				char[] attribs = strip(readUntil('>'));
				expect(">");
				return "<" ~ nodeName ~ " " ~ attribs ~ ">";
			}
		}
		else                                            // cdata
		{
			ungetc(ch);
			return readUntil('<');
		}
	}

	/// line number 
	int lineNumber() { return _curLine; }
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
