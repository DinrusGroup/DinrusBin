
/*
 * Placed in public domain.
 * Written by Hauke Duden and Walter Bright
 */

/* This is for use with variable argument lists with extern(D) linkage. */

module std.stdarg;
//import std.c.stdarg;
//import std.stdarg;
 public import std.c: va_list, va_arg;

extern(C) template va_arg_d(T)
{
    T va_arg(inout va_list _argptr)
    {
	T arg = *cast(T*)_argptr;
	_argptr = _argptr + ((T.sizeof + int.sizeof - 1) & ~(int.sizeof - 1));
	return arg;
    }
}

