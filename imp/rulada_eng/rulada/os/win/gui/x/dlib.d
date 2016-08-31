﻿/*
	Copyright (C) 2007-2008 Christopher E. Miller
	
	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any damages
	arising from the use of this software.
	
	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:
	
	1. The origin of this software must not be misrepresented; you must not
	   claim that you wrote the original software. If you use this software
	   in a product, an acknowledgment in the product documentation would be
	   appreciated but is not required.
	2. Altered source versions must be plainly marked as such, and must not be
	   misrepresented as being the original software.
	3. This notice may not be removed or altered from any source distribution.
*/


module os.win.gui.x.dlib;


alias typeof(""c[]) Dstring;
alias typeof(""c.ptr) Dstringz;
alias typeof(" "c[0]) Dchar;
alias typeof(""w[]) Dwstring;
alias typeof(""w.ptr) Dwstringz;
alias typeof(" "w[0]) Dwchar;
alias typeof(""d[]) Ddstring;
alias typeof(""d.ptr) Ddstringz;
alias typeof(" "d[0]) Ddchar;


version(DFL_NO_D2_AND_ABOVE)
{
}
else
{
	version(D_Version2)
	{
		version = DFL_D2_AND_ABOVE;
	}
	else version(D_Version3)
	{
		version = DFL_D3_AND_ABOVE;
		version = DFL_D2_AND_ABOVE;
	}
}


version(DFL_DMD2020)
{
	version = DFL_USE_CORE_MEMORY;
	version = DFL_USE_CORE_EXCEPTION_OUTOFMEMORY;
}


version(DFL_USE_CORE_MEMORY)
{
	version = DFL_USE_CORE_EXCEPTION_OUTOFMEMORY;
}


version(Tango)
{
	version(DFL_TANGO097rc1)
	{
		version = DFL_TANGObefore099rc3;
		version = DFL_TANGObefore0994;
		version = DFL_TANGObefore0995;
		version = DFL_TANGObefore0996;
		version = DFL_TANGObefore0997;
	}
	else version(DFL_TANGO098rc2)
	{
		version = DFL_TANGObefore099rc3;
		version = DFL_TANGObefore0994;
		version = DFL_TANGObefore0995;
		version = DFL_TANGObefore0996;
		version = DFL_TANGObefore0997;
	}
	else version(DFL_TANGObefore099rc3)
	{
		version = DFL_TANGObefore0994;
		version = DFL_TANGObefore0995;
		version = DFL_TANGObefore0996;
		version = DFL_TANGObefore0997;
	}
	else version(DFL_TANGO0992)
	{
		version = DFL_TANGObefore0994;
		version = DFL_TANGObefore0995;
		version = DFL_TANGObefore0996;
		version = DFL_TANGObefore0997;
	}
	else version(DFL_TANGO0993)
	{
		version = DFL_TANGObefore0994;
		version = DFL_TANGObefore0995;
		version = DFL_TANGObefore0996;
		version = DFL_TANGObefore0997;
	}
	else version(DFL_TANGO_0994)
	{
		version = DFL_TANGObefore0995;
		version = DFL_TANGObefore0996;
		version = DFL_TANGObefore0997;
	}
	else version(DFL_TANGO_0995)
	{
		version = DFL_TANGObefore0996;
		version = DFL_TANGObefore0997;
	}
	else version(DFL_TANGO_0996)
	{
		version = DFL_TANGObefore0997;
	}
	else version(DFL_TANGO_0997)
	{
	}
	
	
	alias int Dequ;
	
	
	public import tango.core.Thread;
	
	public import tango.core.Traits;
		
	
	template PhobosTraits()
	{
		static if(!is(ParameterTypeTuple!(function() { })))
		{
			// Grabbed from std.traits since Tango's meta.Traits lacks these:
			
			template ParameterTypeTuple(alias dg)
			{
				alias ParameterTypeTuple!(typeof(dg)) ParameterTypeTuple;
			}
			
			/** ditto */
			template ParameterTypeTuple(dg)
			{
				static if (is(dg P == function))
					alias P ParameterTypeTuple;
				else static if (is(dg P == delegate))
					alias ParameterTypeTuple!(P) ParameterTypeTuple;
				else static if (is(dg P == P*))
					alias ParameterTypeTuple!(P) ParameterTypeTuple;
				else
					static assert(0, "argument has no parameters");
			}
		}
	}
	
	mixin PhobosTraits;
	
	
	Dstring getObjectString(Object o)
	{
		version(DFL_TANGObefore0994)
		{
			return o.toUtf8();
		}
		else
		{
			return o.toString();
		}
	}
	
	
	version(DFL_USE_CORE_MEMORY)
	{
		private import tango.core.memory;
		
		void gcPin(void* p) { }
		void gcUnpin(void* p) { }
		
		deprecated void gcGenCollect()
		{
			tango.core.memory.GC.collect();
		}
		
		void gcFullCollect()
		{
			tango.core.memory.GC.collect();
		}
	}
	else
	{
		private import tango.core.Memory;
		
		void gcPin(void* p) { }
		void gcUnpin(void* p) { }
		
		deprecated void gcGenCollect()
		{
			version(DFL_TANGObefore099rc3)
				gc.collect();
			else
				GC.collect();
		}
		
		void gcFullCollect()
		{
			version(DFL_TANGObefore099rc3)
				gc.collect();
			else
				GC.collect();
		}
	}
	
	
	private import tango.text.Ascii;
	
	alias tango.text.Ascii.icompare stringICmp;
	
	dchar utf32charToLower(dchar dch)
	{
		// TO-DO: fix; not just ASCII.
		if(dch >= 0x80)
			return dch;
		char[1] input, result;
		input[0] = dch;
		return tango.text.Ascii.toLower(input, result)[0];
	}
	
	
	private import tango.stdc.stringz;
	
	version(DFL_TANGObefore0995)
	{
		alias tango.stdc.stringz.fromUtf8z stringFromStringz;
	}
	else
	{
		alias tango.stdc.stringz.fromStringz stringFromStringz;
	}
	
	version(DFL_TANGObefore0994)
	{
		alias tango.stdc.stringz.toUtf8z stringToStringz;
	}
	else
	{
		alias tango.stdc.stringz.toStringz stringToStringz;
	}
	
	
	private import tango.io.FilePath;
	
	Dstring pathGetDirName(Dstring s)
	{
		scope mypath = new FilePath(s);
		return mypath.path();
	}
	
	Dstring pathJoin(Dstring p1, Dstring p2)
	{
		return FilePath.join(p1, p2);
	}
	
	
	version(DFL_USE_CORE_EXCEPTION_OUTOFMEMORY)
	{
		private import tango.core.exception;
		
		class OomException: tango.core.exception.OutOfMemoryException
		{
			this()
			{
				super(null, 0);
			}
		}
	}
	else
	{
		private import tango.core.Exception;
		
		class OomException: tango.core.Exception.OutOfMemoryException
		{
			this()
			{
				super(null, 0);
			}
		}
	}
	
	
	private import tango.text.convert.Utf;
	
	dchar utf8stringGetUtf32char(Dstring input, inout uint idx)
	{
		// Since the 'ate' (x) param is specified, the output (result) doesn't grow and returns when full.
		dchar[1] result;
		uint x;
		version(DFL_TANGObefore0994)
		{
			tango.text.convert.Utf.toUtf32(input[idx .. input.length], result, &x);
		}
		else
		{
			tango.text.convert.Utf.toString32(input[idx .. input.length], result, &x);
		}
		idx += x;
		return result[0];
	}
	
	version(DFL_TANGObefore0994)
	{
		alias tango.text.convert.Utf.toUtf8 utf16stringtoUtf8string;
	}
	else
	{
		alias tango.text.convert.Utf.toString utf16stringtoUtf8string;
	}
	
	version(DFL_TANGObefore0994)
	{
		alias tango.text.convert.Utf.toUtf16 utf8stringtoUtf16string;
	}
	else
	{
		alias tango.text.convert.Utf.toString16 utf8stringtoUtf16string;
	}
	
	Dwstringz utf8stringToUtf16stringz(Dstring s)
	{
		Dwstring ws;
		version(DFL_TANGObefore0994)
		{
			ws = tango.text.convert.Utf.toUtf16(s);
		}
		else
		{
			ws = tango.text.convert.Utf.toString16(s);
		}
		ws ~= '\0';
		return ws.ptr;
	}
	
	version(DFL_TANGObefore0994)
	{
		alias tango.text.convert.Utf.toUtf8 utf32stringtoUtf8string;
	}
	else
	{
		alias tango.text.convert.Utf.toString utf32stringtoUtf8string;
	}
	
	version(DFL_TANGObefore0994)
	{
		alias tango.text.convert.Utf.toUtf32 utf8stringtoUtf32string;
	}
	else
	{
		alias tango.text.convert.Utf.toString32 utf8stringtoUtf32string;
	}
	
	
	version(DFL_TANGObefore0997)
	{
		private import tango.io.FileConst;
		
		alias tango.io.FileConst.FileConst.NewlineString nativeLineSeparatorString;
		
		alias tango.io.FileConst.FileConst.PathSeparatorString nativePathSeparatorString;
	}
	else
	{
		private import tango.io.model.IFile;
		
		alias tango.io.model.IFile.FileConst.NewlineString nativeLineSeparatorString;
		
		alias tango.io.model.IFile.FileConst.PathSeparatorString nativePathSeparatorString;
	}
	
	
	private import tango.text.Util;
	
	alias tango.text.Util.delimit!(char) stringSplit;
	
	int charFindInString(Dstring str, dchar dch)
	{
		//uint locate(T, U=uint) (T[] source, T match, U start=0)
		uint loc;
		loc = tango.text.Util.locate!(char)(str, dch);
		if(loc == str.length)
			return -1;
		return cast(int)loc;
	}
	
	alias tango.text.Util.splitLines!(char) stringSplitLines;
	
	
	private import tango.text.convert.Integer;
	
	alias tango.text.convert.Integer.toInt!(char) stringToInt;
	
	version(DFL_TANGObefore0994)
	{
		alias tango.text.convert.Integer.toUtf8 stringToInt;
	}
	else
	{
		alias tango.text.convert.Integer.toString stringToInt;
	}
	
	Dstring uintToHexString(uint num)
	{
		version(DFL_TANGObefore0997)
		{
			char[16] buf;
			return tango.text.convert.Integer.format!(char, uint)(buf, num,
				tango.text.convert.Integer.Style.HexUpper).dup;
		}
		else
		{
			char[16] buf;
			return tango.text.convert.Integer.format(buf, num, "X").dup;
		}
	}
	
	Dstring intToString(int num)
	{
		
		version(DFL_TANGObefore0997)
		{
			char[16] buf;
			return tango.text.convert.Integer.format!(char, uint)(buf, num).dup;
		}
		else
		{
			char[16] buf;
			return tango.text.convert.Integer.format(buf, num, "d").dup;
		}
	}
	
	
	private import tango.stdc.ctype;
	
	int charIsHexDigit(dchar dch)
	{
		return dch < 0x80 && tango.stdc.ctype.isxdigit(cast(char)dch);
	}
	
	
	private import tango.io.model.IConduit;
	
	version(DFL_DSTREAM_ICONDUIT) // Disabled by default.
	{
		alias tango.io.model.IConduit.IConduit DStream; // Requires writability.
	}
	else
	{
		alias tango.io.model.IConduit.InputStream DStream;
	}
	
	alias tango.io.model.IConduit.OutputStream DOutputStream;
	
	alias tango.io.model.IConduit.IConduit.Seek DSeekStream;
	
	alias tango.core.Exception.IOException DStreamException; // Note: from tango.core.Exception.
	
	
	class DObject
	{
		version(DFL_TANGObefore0994)
		{
			//alias toUtf8 toString; // Doesn't let you override.
			Dstring toString() { return super.toUtf8(); }
			override Dstring toUtf8() { return toString(); }
		}
		else
		{
			// No need to override.
		}
	}
}
else // Phobos
{
	public import std.traits;
	
	
	alias ReturnType!(Object.opEquals) Dequ; // Since D2 changes mid-stream.
	
	
	Dstring getObjectString(Object o)
	{
		return o.toString();
	}
	
	
	version(DFL_USE_CORE_MEMORY)
	{
		private import tango.core.memory;
		
		void gcPin(void* p) { }
		void gcUnpin(void* p) { }
		
		deprecated void gcGenCollect()
		{
			tango.core.memory.GC.collect();
		}
		
		void gcFullCollect()
		{
			tango.core.memory.GC.collect();
		}
	}
	else
	{
		private import std.gc; // If you get "module gc cannot read file 'std\gc.d'" then use -version=DFL_USE_CORE_MEMORY <http://wiki.dprogramming.com/Dfl/CompileVersions>
		
		void gcPin(void* p) { }
		void gcUnpin(void* p) { }
		
		deprecated alias std.gc.genCollect gcGenCollect;
		
		alias std.gc.fullCollect gcFullCollect;
	}
	
	
	private import std.string;
	
	alias std.string.icmp stringICmp;
	
	alias std.string.toString stringFromStringz;
	
	alias std.string.split stringSplit;
	
	alias std.string.toString intToString;
	
	alias std.string.find charFindInString;
	
	alias std.string.toStringz stringToStringz;
	
	Dstring uintToHexString(uint num)
	{
		return std.string.format("%X", num);
	}
	
	alias std.string.splitlines stringSplitLines;
	
	
	private import std.path;
	
	alias std.path.getDirName pathGetDirName;
	
	alias std.path.linesep nativeLineSeparatorString;
	
	alias std.path.join pathJoin;
	
	alias std.path.pathsep nativePathSeparatorString;
	
	
	version(DFL_USE_CORE_EXCEPTION_OUTOFMEMORY)
	{
		private import tango.core.Exception;
		
		class OomException: tango.core.Exception.OutOfMemoryException
		{
			this()
			{
				super(null, 0);
			}
		}
	}
	else
	{
		private import std.exception;
		
		alias std.exception.OutOfMemoryException OomException;
	}
	
	
	private import std.utf;
	
	alias std.utf.decode utf8stringGetUtf32char;
	
	alias std.utf.toUTF8 utf16stringtoUtf8string;
	
	alias std.utf.toUTF16 utf8stringtoUtf16string;
	
	alias std.utf.toUTF16z utf8stringToUtf16stringz;
	
	alias std.utf.toUTF8 utf32stringtoUtf8string;
	
	alias std.utf.toUTF32 utf8stringtoUtf32string;
	
	
	private import std.uni;
	
	alias std.uni.toUniLower utf32charToLower;
	
	
	private import std.conv;
	
	alias std.conv.toInt stringToInt;
	
	
	private import std.ctype;
	
	alias std.ctype.isxdigit charIsHexDigit;
	
	
	private import std.stream;
	
	alias std.stream.Stream DStream;
	
	alias std.stream.OutputStream DOutputStream;
	
	alias std.stream.StreamException DStreamException;
	
	
	alias Object DObject;
}


char* unsafeToStringz(Dstring s)
{
	// This is intentionally unsafe, hence the name.
	if(!s.ptr[s.length])
		//return s.ptr;
		return cast(char*)s.ptr; // Needed in D2.
	//return stringToStringz(s);
	return cast(char*)stringToStringz(s); // Needed in D2.
}

