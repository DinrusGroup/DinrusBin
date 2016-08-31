//============================================================================
// SR_binary.d -
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description:
 *  Helper Functions for binary reading / writing
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 28 Aug 2007
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

module auxd.OpenMesh.Core.IO.SR_binary;
version(Tango) import std.compat;


//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.Exceptions;
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.IO.SR_types;
import auxd.OpenMesh.Core.Geometry.VectorTypes;
import auxd.OpenMesh.Core.Mesh.Status;

static import std.string;

//=============================================================================


//-----------------------------------------------------------------------------

const static size_t  UnknownSize = cast(size_t)(-1);


//-----------------------------------------------------------------------------
// struct binary, helper for storing/restoring

private const string X =
    "string msg = std.string.format(\"Type not supported: \", value_type.stringof);\n"
    "throw new logic_error(msg);\n";

/// \struct binary SR_binary.hh <OpenMesh/Core/IO/SR_binary.hh>
///
/// The struct defines how to store and restore the type T.
/// It's used by the OM reader/writer modules.
///
/// The following specialization are provided:
/// - Fundamental types except \c long \c double
/// - %OpenMesh vector types
/// - %auxd.OpenMesh.StatusInfo
/// - std.string (max. length 65535)
///
/// \todo Complete documentation of members
struct binary(T)
{
    alias T     value_type;

    static const bool is_streamable = false;

    static size_t size_of() { return UnknownSize; }
    static size_t size_of(/*const*/ ref value_type) { return UnknownSize; }

    static size_t store(ostream _os, /*const ref*/ value_type _v, bool _swap=false)
    { mixin(X); return 0; }

    static
    size_t restore(istream _is, ref value_type _v, bool _swap=false)
    { mixin(X); return 0; }
}


//------------------SPECIALIZATIONS--------------------------------------------


//-----------------------------------------------------------------------------
// struct binary, helper for storing/restoring
template SIMPLE_BINARY( T ) {
    struct binary( _S:T ) {
        alias T value_type;
        static /*const*/ bool is_streamable = true;
        static size_t size_of(/*const*/ ref value_type) { return value_type.sizeof; }
        static size_t size_of() { return value_type.sizeof; }
        static size_t store( ostream _os, /*const*/ ref value_type _val,
                             bool _swap=false) {
            value_type tmp = _val;
            if (_swap) reverse_byte_order(tmp);
            _os.write( cast(/*const*/ char*)&tmp, value_type.sizeof );
            return _os.good() ? value_type.sizeof : 0;
        }

        static size_t restore( istream _is, ref value_type _val,
                               bool _swap=false) {
            _is.read( cast(char*)&_val, value_type.sizeof );
            if (_swap) reverse_byte_order(_val);
            return _is.good() ? value_type.sizeof : 0;
        }
    }

}
mixin SIMPLE_BINARY!(bool);
mixin SIMPLE_BINARY!(int);
mixin SIMPLE_BINARY!(uint);
mixin SIMPLE_BINARY!(float);
mixin SIMPLE_BINARY!(double);
mixin SIMPLE_BINARY!(real);

mixin SIMPLE_BINARY!(int8_t);
mixin SIMPLE_BINARY!(int16_t);
mixin SIMPLE_BINARY!(int32_t);
mixin SIMPLE_BINARY!(int64_t);
mixin SIMPLE_BINARY!(uint8_t);
mixin SIMPLE_BINARY!(uint16_t);
mixin SIMPLE_BINARY!(uint32_t);
mixin SIMPLE_BINARY!(uint64_t);

template VECTORT_BINARY( T ) {
    struct binary(_S:T) {
        alias T value_type;
        static /*const*/ bool is_streamable = true;
        static size_t size_of(void) { return value_type.sizeof; }
        static size_t size_of(/*const*/ ref value_type) { return size_of(); }
        static size_t store( ostream _os, /*const*/ ref value_type _val,
                             bool _swap=false) {
            value_type tmp = _val;
            size_t i, b = size_of(_val), N = value_type.size_;
            if (_swap) for (i=0; i<N; ++i)
                           reverse_byte_order( tmp[i] );
            _os.write( cast(/*const*/ char*)&tmp[0], b );
            return _os.good() ? b : 0;
        }

        static size_t restore( istream _is, ref value_type _val,
                               bool _swap=false) {
            size_t i, N=value_type.size_;
            size_t b = N * value_type.value_type.sizeof;
            _is.read( cast(char*)&_val[0], b );
            if (_swap) for (i=0; i<N; ++i)
                           reverse_byte_order( _val[i] );
            return _is.good() ? b : 0;
        }
    }
}


mixin VECTORT_BINARY!( Vec1b  );
mixin VECTORT_BINARY!( Vec1ub );
mixin VECTORT_BINARY!( Vec1s  );
mixin VECTORT_BINARY!( Vec1us );
mixin VECTORT_BINARY!( Vec1i  );
mixin VECTORT_BINARY!( Vec1ui );
mixin VECTORT_BINARY!( Vec1f  );
mixin VECTORT_BINARY!( Vec1d  );

mixin VECTORT_BINARY!( Vec2b  );
mixin VECTORT_BINARY!( Vec2ub );
mixin VECTORT_BINARY!( Vec2s  );
mixin VECTORT_BINARY!( Vec2us );
mixin VECTORT_BINARY!( Vec2i  );
mixin VECTORT_BINARY!( Vec2ui );
mixin VECTORT_BINARY!( Vec2f  );
mixin VECTORT_BINARY!( Vec2d  );

mixin VECTORT_BINARY!( Vec3b  );
mixin VECTORT_BINARY!( Vec3ub );
mixin VECTORT_BINARY!( Vec3s  );
mixin VECTORT_BINARY!( Vec3us );
mixin VECTORT_BINARY!( Vec3i  );
mixin VECTORT_BINARY!( Vec3ui );
mixin VECTORT_BINARY!( Vec3f  );
mixin VECTORT_BINARY!( Vec3d  );

mixin VECTORT_BINARY!( Vec4b  );
mixin VECTORT_BINARY!( Vec4ub );
mixin VECTORT_BINARY!( Vec4s  );
mixin VECTORT_BINARY!( Vec4us );
mixin VECTORT_BINARY!( Vec4i  );
mixin VECTORT_BINARY!( Vec4ui );
mixin VECTORT_BINARY!( Vec4f  );
mixin VECTORT_BINARY!( Vec4d  );

mixin VECTORT_BINARY!( Vec6b  );
mixin VECTORT_BINARY!( Vec6ub );
mixin VECTORT_BINARY!( Vec6s  );
mixin VECTORT_BINARY!( Vec6us );
mixin VECTORT_BINARY!( Vec6i  );
mixin VECTORT_BINARY!( Vec6ui );
mixin VECTORT_BINARY!( Vec6f  );
mixin VECTORT_BINARY!( Vec6d  );




/+
struct binary( T:string ) {
    alias T value_type;
    alias uint16_t    length_t;

    static /*const*/ bool is_streamable = true;

    static size_t size_of() { return UnknownSize; }
    static size_t size_of(/*const*/ ref value_type _v)
    { return length_t.sizeof + _v.length; }

    static
    size_t store(ostream _os, /*const*/ ref value_type _v, bool _swap=false)
    {
        if (_v.length < length_t.max )
        {
            length_t len = _v.length;

            if (_swap) reverse_byte_order(len);

            size_t bytes = binary!(length_t).store( _os, len, _swap );
            _os.write( _v.data(), len );
            return _os.good() ? len+bytes : 0;
        }
        throw std.runtime_error("Cannot store string longer than 64Kb");
    }

    static
    size_t restore(istream _is, ref value_type _val, bool _swap=false)
    {
        length_t len;
        size_t   bytes = binary!(length_t).restore( _is, len, _swap );
        if (_swap)
            reverse_byte_order(len);
        _val.resize(len);
        _is.read( cast(char*)(_val.data()), len );

        return _is.good() ? (len+bytes) : 0;
    }
}
+/

struct binary(T:auxd.OpenMesh.Core.Mesh.Status.StatusInfo)
{
    alias  auxd.OpenMesh.Core.Mesh.Status.StatusInfo value_type;
    alias value_type.value_type           status_t;

    static /*const*/ bool is_streamable = true;

    static size_t size_of() { return status_t.sizeof; }
    static size_t size_of(/*const*/ ref value_type) { return size_of(); }

    static size_t n_bytes(size_t _n_elem)
    { return _n_elem*status_t.sizeof; }

    static
    size_t store(ostream _os, /*const*/ ref value_type _v, bool _swap=false)
    {
        status_t v=_v.bits();
        return binary!(status_t).store(_os, v, _swap);
    }

    static
    size_t restore( istream _os, ref value_type _v, bool _swap=false)
    {
        status_t v;
        size_t   b = binary!(status_t).restore(_os, v, _swap);
        _v.set_bits(v);
        return b;
    }
}


//-----------------------------------------------------------------------------
// std.vector<T> specializations for struct binary<>

struct FunctorStore(T) {
    static FunctorStore opCall( ostream _is, bool _swap) {
        FunctorStore M; with(M) {
            os_=(_os), swap_=(_swap);
        } return M;
    }
    size_t operator () ( size_t _v1, /*const*/ ref T _s2 )
    { return _v1+binary!(T).store(os_, _s2, swap_ ); }

    ostream os_;
    bool    swap_;
}


struct FunctorRestore(T) {
    static FunctorRestore opCall( istream _is, bool _swap) {
        FunctorRestore M; with(M) {
            is_=(_is), swap_=(_swap);
        } return M;
    }
    size_t operator () ( size_t _v1, ref T _s2 )
    {
        return _v1+binary!(T).restore(is_, _s2, swap_ );
    }
    istream is_;
    bool    swap_;
}

template BINARY_VECTOR( T ) {
    struct binary(T: T[]) {
        alias T[]       value_type;
        alias T         elem_type;

        static /*const*/ bool is_streamable = true;

        static size_t size_of(void)
        { return IO.UnknownSize; }

        static size_t size_of(/*const*/ ref value_type _v)
        { return elem_type.sizeof * _v.size(); }

        static
        size_t store(ostream _os, /*const*/ ref value_type _v, bool _swap=false) {
            size_t bytes=0;

            if (_swap)
                bytes = std.accumulate( _v.begin(), _v.end(), bytes,
                                        FunctorStore!(elem_type)(_os,_swap) );
            else {
                bytes = size_of(_v);
                _os.write( cast(/*const*/ char*)(&_v[0]), bytes );
            }
            return _os.good() ? bytes : 0;
        }

        static size_t restore(istream _is, ref value_type _v, bool _swap=false) {
            size_t bytes=0;

            if ( _swap)
                bytes = std.accumulate( _v.begin(), _v.end(), 0,
                                        FunctorRestore!(elem_type)(_is, _swap) );
            else
            {
                bytes = size_of(_v);
                _is.read( cast(char*)(&_v[0]), bytes );
            }
            return _is.good() ? bytes : 0;
        }
    }
}

mixin BINARY_VECTOR!( short  );
mixin BINARY_VECTOR!( ushort  );
mixin BINARY_VECTOR!( int  );
mixin BINARY_VECTOR!( uint  );
mixin BINARY_VECTOR!( long );
mixin BINARY_VECTOR!( ulong );
mixin BINARY_VECTOR!( float  );
mixin BINARY_VECTOR!( double );


struct binary(T: string[])
{
    // struct binary interface

    alias string[] value_type;
    alias string    elem_type;

    static /*const*/ bool is_streamable = true;

    // Helper

    struct Sum
    {
        size_t operator() ( size_t _v1, /*const*/ ref elem_type _s2 )
        { return _v1 + binary!(elem_type).size_of(_s2); }
    };

    // struct binary interface

    static size_t size_of(void) { return UnknownSize; }

    static size_t size_of(/*const*/ ref value_type _v)
    { return std.accumulate( _v.begin(), _v.end(), 0u, Sum() ); }

    static
        size_t store(ostream _os, /*const*/ ref value_type _v, bool _swap=false)
    {
        return std.accumulate( _v.begin(), _v.end(), 0,
                               FunctorStore!(elem_type)(_os, _swap) );
    }

    static
        size_t restore(istream _is, ref value_type _v, bool _swap=false)
    {
        return std.accumulate( _v.begin(), _v.end(), 0,
                               FunctorRestore!(elem_type)(_is, _swap) );
    }
}


struct binary(T: bool[])
{

    alias bool[]    value_type;
    alias bool      elem_type;

    static /*const*/ bool is_streamable = true;

    static size_t size_of() { return UnknownSize; }
    static size_t size_of(/*const*/ ref value_type _v)
    {
        return _v.length / 8 + ((_v.length % 8)!=0);
    }

    static
    size_t store( ostream _ostr, /*const*/ ref value_type _v, bool )
    {
        size_t bytes = 0;

        size_t N = _v.length / 8;
        size_t R = _v.length % 8;

        size_t        idx;      // element index
        ubyte bits; // bitset

        for (idx=0; idx < N; ++idx)
        {
            bits = 0;
            bits = bits |  (_v[idx+0] ? 1 : 0);
            bits = bits | ((_v[idx+1] ? 1 : 0) << 1);
            bits = bits | ((_v[idx+2] ? 1 : 0) << 2);
            bits = bits | ((_v[idx+3] ? 1 : 0) << 3);
            bits = bits | ((_v[idx+4] ? 1 : 0) << 4);
            bits = bits | ((_v[idx+5] ? 1 : 0) << 5);
            bits = bits | ((_v[idx+6] ? 1 : 0) << 6);
            bits = bits | ((_v[idx+7] ? 1 : 0) << 7);
            _ostr.write(bits);
        }
        bytes = N;

        if (R)
        {
            bits = 0;
            switch(R)
            {
            case 7: bits = bits | ((_v[idx+6] ? 1 : 0) << 6);
            case 6: bits = bits | ((_v[idx+5] ? 1 : 0) << 5);
            case 5: bits = bits | ((_v[idx+4] ? 1 : 0) << 4);
            case 4: bits = bits | ((_v[idx+3] ? 1 : 0) << 3);
            case 3: bits = bits | ((_v[idx+2] ? 1 : 0) << 2);
            case 2: bits = bits | ((_v[idx+1] ? 1 : 0) << 1);
            case 1: bits = bits |  (_v[idx+0] ? 1 : 0);
            }
            _ostr.write(bits);
            ++bytes;
        }

        assert( bytes == size_of(_v) );

        return bytes;
    }

    static
    size_t restore( istream _istr, ref value_type _v, bool )
    {
        size_t bytes = 0;

        size_t N = _v.length / 8;
        size_t R = _v.length % 8;

        size_t        idx;  // element index
        ubyte         bits; // bitset

        for (idx=0; idx < N; ++idx)
        {
            _istr.read(bits);
            _v[idx+0] = ((bits & 0x01)!=0);
            _v[idx+1] = ((bits & 0x02)!=0);
            _v[idx+2] = ((bits & 0x04)!=0);
            _v[idx+3] = ((bits & 0x08)!=0);
            _v[idx+4] = ((bits & 0x10)!=0);
            _v[idx+5] = ((bits & 0x20)!=0);
            _v[idx+6] = ((bits & 0x40)!=0);
            _v[idx+7] = ((bits & 0x80)!=0);
        }
        bytes = N;

        if (R)
        {
            _istr.read(bits);
            for(; idx < _v.length; ++idx)
                _v[idx] = (bits & (1 << (idx%8)))!=0;
            ++bytes;
        }

        return bytes;
    }
}


//=============================================================================

unittest {
    binary!(float) bfloat;
    bool caught = false;
    try {
        bfloat.store(dout, 2.3f);
    }
    catch (logic_error e) {
        // expected
        caught = true;
    }
    assert(caught, "operation should have raised a logic_error");
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
