/******************************************************************************* 

	Utilities for input/output.
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
	Utilities for input/output.

	Examples:      
	---------------------
	import std.string;
	import arc.text.format

	int main() 
	{
	   // format vararg text
	   void mywritef(...)
	   {
		  dchar[] text = arc.text.formatString(_arguments, _argptr); 
		  printf("%s\n", std.string.toString(text));
	   }
	   
	   mywritef("Hello ", 10, " Worlds");

	   return 0;
	}
	---------------------

*******************************************************************************/

module arc.text.format;

import 
	std.io, 
	std.format,
	std.stdarg; 

/// format vardic arguments and returns it as a string
dchar[] formatString(TypeInfo[] arguments, va_list argptr) 
{
   dchar[] message = null; 
   
   void putc(dchar c)
   {
      message ~= c; 
   }
   
   std.format.doFormat(&putc, arguments, argptr);
   
   return message; 
} 


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
