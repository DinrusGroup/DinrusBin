/******************************************************************************* 

	XML error class.
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
	XML error class.


	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/

module arc.xml.error;

import std.string;

/// XML Error class 
class XmlError : Exception
{
    this(uint lineNumber, char[] what)
    {
        super("(" ~ std.string.toString(lineNumber) ~ ")" ~ what);
    }
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
