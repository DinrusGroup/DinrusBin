/******************************************************************************* 

	XML miscellaneous functions
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
	XML miscellaneous functions


	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/

module arc.xml.misc;

import std.string;

/// char is a letter
bit isLetter(char c)
{   return find(letters, c) != -1;
}

/// char is a number
bit isNumber(char c)
{   return find(digits, c) != -1;
}

/// char is whitespace
bit isWhiteSpace(char c)
{   return find(whitespace, c) != -1;
}

/// char is alpha numeric
bit isAlphaNumeric(char c)
{   return isLetter(c) || isNumber(c);
}

/// char is a token
bit isTokenChar(char c)
{   static const char[] tokenChars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_";
    return find(tokenChars, c) != -1;
}

/// encode string special chars
char[] encodeSpecialChars(char[] src)
{
    // Convert sensitive characters to code thingies so that the XML isn't butchered by the cdata.
    // This probably isn't the most efficient way to do this.
    char[] tempStr;
    tempStr = replace(src    , "&", "&amp;");
    tempStr = replace(tempStr, "<", "&lt;");
    tempStr = replace(tempStr, ">", "&gt;");
    return tempStr;
}

/// decode string special chars
char[] decodeSpecialChars(char[] src)
{
    // undoes what encodeSpecialChars does
    char[] tempStr;
    tempStr = replace(src    , "&amp;", "&");
    tempStr = replace(tempStr, "&lt;",  "<");
    tempStr = replace(tempStr, "&gt;",  ">");

    return tempStr;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
