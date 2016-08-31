/*
	Template Library to support compile-time symbol demangling.  
	This is put to good use by the DynamicLibrary class.

	Authors: Eric Anderton, Don Clugston
	License: BSD Derivative (see source for details)
	Copyright: 2005 Eric Anderton
*/
module ddl.Mangle;

import meta.conv;

import mango.convert.Integer;

/*  char [] mangleSymbolName!(char [] name);
 *  Convert a name of the form "module.func" to the form
 *  "6module4func".
 */
template mangleSymbolName(char[] text, char [] latestword="")
{
  static if (text.length<1)  {
     static if (latestword.length==0)
            const char[] mangleSymbolName = "";
     else const char[] mangleSymbolName = itoa!(latestword.length) ~ latestword;
  } else static if (text[0]=='.') {
      const char[] mangleSymbolName =
      itoa!(latestword.length) ~ latestword ~ .mangleSymbolName!(text[1..(text.length)], "");
  } else
     const char[] mangleSymbolName = .mangleSymbolName!( text[1..(text.length)], latestword ~ text[0..(1)]);
}

/*
	Runtime function that converts a name of the form "module.func" to the form "6module4func" per
	the D ABI name-mangling specification.
*/
char[] mangleNamespace(char[] text);
