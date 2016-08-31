/+
	SmallXML
	Copyright (C) 2008, 2009  Moritz Maxeiner
	Email: <duronthedark@gmail.com>

	This file (all.d) is part of the SmallXML package.

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

module amigos.smallxml.all;

public
{
	import amigos.smallxml.node;
	import amigos.smallxml.buffer;
	import amigos.smallxml.file;
}

alias SXML_Comment SmallXML_Comment;
alias SXML_Attribute SmallXML_Attribute;
alias SXML_Element SmallXML_Element;
alias SXML_ProcInst SmallXML_ProcInst;
alias SXML_Buffer SmallXML_Buffer;
alias SXML_File SmallXML_File;

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
