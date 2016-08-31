//============================================================================
// BinaryHelper.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Helper Functions for binary reading / writing
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 01 Sep 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License: LGPL 2.1
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation, version 2.1.
 *                                                                           
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *                                                                           
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
//============================================================================

module auxd.OpenMesh.Core.IO.BinaryHelper;

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.IO.Streams;
import util = auxd.OpenMesh.Core.Utils.Std;


import std.c;
import std.cstream;

//=============================================================================


/** \name Handling binary input/output.
    These functions take care of swapping bytes to get the right Endian.
*/
//@{

//-----------------------------------------------------------------------------

private {
    union SC { short s;      ubyte[2] c; }
    union IC { int i;        ubyte[4] c; }
    union LC { long l;       ubyte[8] c; }
    union FC { float f;      ubyte[4] c; }
    union DC { double d;     ubyte[8] c; }
}

//------------------ Stream interface -----------------------------

/** Binary read a \c short from \c _is and perform byte swapping if
    \c _swap is true */
short read_short(InputStream _in, bool _swap=false)
{
    SC sc;
    uint got = _in.read(sc.c);
    assert(got==sc.c.length);
    if (_swap) util.swap(sc.c[0], sc.c[1]);
    return sc.s;
}

/** Binary read an \c int from \c _is and perform byte swapping if
    \c _swap is true */
int read_int(InputStream _in, bool _swap=false)
{
    IC ic;
    uint got = _in.read(ic.c);
    assert(got==ic.c.length);
    if (_swap) {
        util.swap(ic.c[0], ic.c[3]);
        util.swap(ic.c[1], ic.c[2]);
    }
    return ic.i;
}

/** Binary read a \c long from \c _in and perform byte swapping if
    \c _swap is true */
long read_long(InputStream _in, bool _swap=false)
{
    LC ic;
    uint got = _in.read(ic.c);
    assert(got==ic.c.length);
    if (_swap) {
        util.swap(ic.c[0], ic.c[7]);
        util.swap(ic.c[1], ic.c[6]);
        util.swap(ic.c[2], ic.c[5]);
        util.swap(ic.c[3], ic.c[4]);
    }
    return ic.l;
}

/** Binary read a \c float from \c _is and perform byte swapping if
    \c _swap is true */
float read_float(InputStream _in, bool _swap=false)
{
    FC fc;
    uint got = _in.read(fc.c);
    assert(got==fc.c.length);
    if (_swap) {
        util.swap(fc.c[0], fc.c[3]);
        util.swap(fc.c[1], fc.c[2]);
    }
    return fc.f;
}

/** Binary read a \c double from \c _is and perform byte swapping if
    \c _swap is true */
double read_double(InputStream _in, bool _swap=false) 
{
    DC dc;
    uint got = _in.read(dc.c);
    assert(got==dc.c.length);
    if (_swap) {
        util.swap(dc.c[0], dc.c[7]);
        util.swap(dc.c[1], dc.c[6]);
        util.swap(dc.c[2], dc.c[5]);
        util.swap(dc.c[3], dc.c[4]);
    }
    return dc.d;
}


/** Binary write a \c short to \c _os and perform byte swapping if
    \c _swap is true */
void write_short(short _i, OutputStream _out, bool _swap=false)
{
    SC sc;
    sc.s = _i;
    if (_swap) util.swap(sc.c[0], sc.c[1]);
    uint wrote = _out.write(sc.c);
    assert(wrote == sc.c.length);
}

/** Binary write an \c int to \c _os and perform byte swapping if
    \c _swap is true */
void write_int(int _i, OutputStream _out, bool _swap=false)
{
    IC ic;
    ic.i = _i;
    if (_swap) {
        util.swap(ic.c[0], ic.c[3]);
        util.swap(ic.c[1], ic.c[2]);
    }
    uint wrote = _out.write(ic.c);
    assert(wrote == ic.c.length);
}

/** Binary write a \c long to \c _out and perform byte swapping if
    \c _swap is true */
void write_long(long _l, OutputStream _out, bool _swap=false)
{
    LC ic;
    ic.l = _l;
    if (_swap) {
        util.swap(ic.c[0], ic.c[7]);
        util.swap(ic.c[1], ic.c[6]);
        util.swap(ic.c[2], ic.c[5]);
        util.swap(ic.c[3], ic.c[4]);
    }
    uint wrote = _out.write(ic.c);
    assert(wrote == ic.c.length);
}

/** Binary write a \c float to \c _os and perform byte swapping if
    \c _swap is true */
void write_float(float _f, OutputStream _out, bool _swap=false)
{
    FC fc;
    fc.f = _f;
    if (_swap) {
        util.swap(fc.c[0], fc.c[3]);
        util.swap(fc.c[1], fc.c[2]);
    }
    uint wrote = _out.write(fc.c);
    assert(wrote == fc.c.length);
}

/** Binary write a \c double to \c _os and perform byte swapping if
    \c _swap is true */
void write_double(double _d, OutputStream _out, bool _swap=false)
{
    DC dc;
    dc.d = _d;
    if (_swap) {
        util.swap(dc.c[0], dc.c[7]);
        util.swap(dc.c[1], dc.c[6]);
        util.swap(dc.c[2], dc.c[5]);
        util.swap(dc.c[3], dc.c[4]);
    }
    uint wrote = _out.write(dc.c);
    assert(wrote == dc.c.length);
}


/** Binary rean an elementary value from _in and perform byte swapping if
    _swap is true */
void read_binary(T)(ref T _v, inputStream _in, bool _swap=false)
{
    static      if(is(T == ubyte)) { _in.read(_v); }
    else static if(is(T ==  byte)) { _in.read(_v); }
    else static if(is(T ==  bool)) { ubyte b; _in.read(b); _v=b; }
    else static if(is(T == short)||is(T==ushort)) { _v = cast(T)read_short(_in,_swap); }
    else static if(is(T ==   int)||is(T==uint))   { _v = cast(T)read_int(_in,_swap); }
    else static if(is(T ==  long)||is(T==ulong))  { _v = cast(T)read_long(_in,_swap); }
    else static if(is(T == float)) { _v = read_float(_in,_swap); }
    else static if(is(T == double)) { _v = read_double(_in,_swap); }
    else {
        static assert(false, "read_binary: Unsupported type: "~T.stringof);
    }
}

/** Binary write an elementary value to _out and perform byte swapping if
    _swap is true */
void write_binary(T)(T _v, OutputStream _out, bool _swap=false)
{
    static      if(is(T == ubyte)) { _out.write(_v); }
    else static if(is(T ==  byte)) { _out.write(_v); }
    else static if(is(T ==  bool)) { _out.write(cast(ubyte)_v); }
    else static if(is(T == short)||is(T==ushort)) { write_short(cast(short)_v,_out,_swap); }
    else static if(is(T ==   int)||is(T==uint)) { write_int(cast(int)_v,_out,_swap); }
    else static if(is(T ==  long)||is(T==ulong)) { write_long(cast(long)_v,_out,_swap); }
    else static if(is(T == float)) { write_float(_v,_out,_swap); }
    else static if(is(T == double)) { write_double(_v,_out,_swap); }
    else {
        static assert(false, "write_binary: Unsupported type: "~T.stringof);
    }
}


//------------------ FILE* interface -----------------------------

/** Binary read a \c short from \c _is and perform byte swapping if
    \c _swap is true */
short read_short(FILE* _in, bool _swap=false)
{
    scope _cin = new CFile(_in,FileMode.In);
    scope(exit) _cin.file=null;
    return read_short(_cin, _swap);
}

/** Binary read an \c int from \c _is and perform byte swapping if
    \c _swap is true */
int read_int(FILE* _in, bool _swap=false)
{
    scope _cin = new CFile(_in,FileMode.In);
    scope(exit) _cin.file=null;
    return read_int(_cin, _swap);
}

/** Binary read a \c long from \c _is and perform byte swapping if
    \c _swap is true */
long read_long(FILE* _in, bool _swap=false)
{
    scope _cin = new CFile(_in,FileMode.In);
    scope(exit) _cin.file=null;
    return read_long(_cin, _swap);
}

/** Binary read a \c float from \c _is and perform byte swapping if
    \c _swap is true */
float read_float(FILE* _in, bool _swap=false)
{
    scope _cin = new CFile(_in,FileMode.In);
    scope(exit) _cin.file=null;
    return read_float(_cin, _swap);
}

/** Binary read a \c double from \c _is and perform byte swapping if
    \c _swap is true */
double read_double(FILE* _in, bool _swap=false) 
{
    scope _cin = new CFile(_in,FileMode.In);
    scope(exit) _cin.file=null;
    return read_double(_cin, _swap);
}


/** Binary write a \c short to \c _os and perform byte swapping if
    \c _swap is true */
void write_short(short _i, FILE* _out, bool _swap=false)
{
    scope _cout = new CFile(_out,FileMode.Out);
    scope(exit) _cout.file=null;
    write_short(_i, _cout, _swap);
}

/** Binary write an \c int to \c _os and perform byte swapping if
    \c _swap is true */
void write_int(int _i, FILE* _out, bool _swap=false)
{
    scope _cout = new CFile(_out,FileMode.Out);
    scope(exit) _cout.file=null;
    write_int(_i, _cout, _swap);
}

/** Binary write a \c long to \c _os and perform byte swapping if
    \c _swap is true */
void write_long(long _i, FILE* _out, bool _swap=false)
{
    scope _cout = new CFile(_out,FileMode.Out);
    scope(exit) _cout.file=null;
    write_long(_i, _cout, _swap);
}

/** Binary write a \c float to \c _os and perform byte swapping if
    \c _swap is true */
void write_float(float _f, FILE* _out, bool _swap=false)
{
    scope _cout = new CFile(_out,FileMode.Out);
    scope(exit) _cout.file=null;
    write_float(_f, _cout, _swap);
}

/** Binary write a \c double to \c _os and perform byte swapping if
    \c _swap is true */
void write_double(double _d, FILE* _out, bool _swap=false)
{
    scope _cout = new CFile(_out,FileMode.Out);
    scope(exit) _cout.file=null;
    write_double(_d, _cout, _swap);
}

/** Swap the endian-ness of the data v */
void swap_endian(T)(ref T v)
{
    const uint N = T.sizeof;
    const uint N_2 = N/2;
    for (uint i=0; i<N/2; i++) {
        util.swap((cast(byte*)&v)[i], (cast(byte*)&v)[N-i-1]);
    }
}


//@}

unittest {

    int i = 1;
    swap_endian(i);
    assert(i == 0x01_00_00_00, "int swapped incorrectly");
    long l = 1;
    swap_endian(l);
    assert(l == 0x01_00_00_00__00_00_00_00L, "long swapped incorrectly");
    l = 0x01_02_03_04__05_06_07_08L;
    swap_endian(l);
    assert(l == 0x08_07_06_05__04_03_02_01L, "long swapped incorrectly");

}


//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
