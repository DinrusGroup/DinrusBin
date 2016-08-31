/+
	SmallXML
	Copyright (C) 2008, 2009  Moritz Maxeiner
	Email: <moritzmaxeiner@gmail.com>

	This file (file.d) is part of the SmallXML package.

	SmallXML is distributed as free software: you can redistribute it
	and/or modify it under the terms of the GNU General Public License
	version 3, as published by the Free Software Foundation.

	This program is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	General Public License for more details.

	You should have received a copy of the GNU General Public License
	version 3 along with this program. If not, see
	http://www.gnu.org/licenses/ .
+/

module amigos.smallxml.file;

private
{
	import std.stdio;
	import std.stream;
	import std.file;
	
	import amigos.smallxml.buffer;
}

final class SXML_File : SXML_Buffer
{
	protected char[] Name;
	
	this(char[] n)
	{
		if(n !is null)
			if(exists(n))
			{
				Name = n;
				File XMLFile = new File(Name, FileMode.In);
				parse(XMLFile.toString());
				XMLFile.close();
				RootElement.cleanTexts();
			}
			else
				throw new Exception("Failed to create SXML_File " ~ n ~ "; file not found");
		else
			throw new Exception("Failed to create SXML_File; no name specified");
	}
	
	this(char[] n, SXML_Buffer buf)
	{
		if(n !is null)
		{
			Name = n;
			
			this.StartInst = buf.StartInst;
			this.RootElement = buf.RootElement;
			this.CurrentElement = buf.CurrentElement;
		}
		else
			throw new Exception("Failed to convert SXML_Buffer to SXML_File; no name specified");
	}
	
	void save()
	{
		File XMLFile = new File(Name, FileMode.Out);
		try
			XMLFile.writef(toString());
		catch(Exception  e)
		{
			writefln(e.msg);
			throw new Exception("Failed to save file " ~ Name ~ "; for the cause see the message above this one");
		}
		finally
		XMLFile.close();
	}
	
	void saveto(char[] File = null)
	{
		if(File !is null)
			Name = File;
		save();
	}
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
