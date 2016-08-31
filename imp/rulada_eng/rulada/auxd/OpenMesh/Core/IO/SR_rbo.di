//============================================================================
// SR_rbo.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Helper Functions for binary reading / writing
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

module auxd.OpenMesh.Core.IO.SR_rbo;

//== INCLUDES =================================================================

// -------------------- OpenMesh
import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.IO.Streams;
import util = auxd.OpenMesh.Core.Utils.Std;
import auxd.OpenMesh.Core.IO.SR_types;
import auxd.OpenMesh.Core.Utils.GenProg;

//=============================================================================


/** \name Handling binary input/output.
    These functions take care of swapping bytes to get the right Endian.
*/
//@{


//-----------------------------------------------------------------------------

/** this does not compile for g++3.4 and higher, hence we comment the 
function body which will result in a linker error */

private {
void _reverse_byte_order_N(size_t N)(ubyte* _val)
{
    static if(N==1) {

    }
    else static if(N==2) {
            _val[0] ^= _val[1]; _val[1] ^= _val[0]; _val[0] ^= _val[1];
    }
    else static if(N==4) {
            _val[0] ^= _val[3]; _val[3] ^= _val[0]; _val[0] ^= _val[3]; // 0 <-> 3
            _val[1] ^= _val[2]; _val[2] ^= _val[1]; _val[1] ^= _val[2]; // 1 <-> 2
    }
    else static if(N==8) {
            _val[0] ^= _val[7]; _val[7] ^= _val[0]; _val[0] ^= _val[7]; // 0 <-> 7
            _val[1] ^= _val[6]; _val[6] ^= _val[1]; _val[1] ^= _val[6]; // 1 <-> 6
            _val[2] ^= _val[5]; _val[5] ^= _val[2]; _val[2] ^= _val[5]; // 2 <-> 5
            _val[3] ^= _val[4]; _val[4] ^= _val[3]; _val[3] ^= _val[4]; // 3 <-> 4
    }
    else static if(N==12) {
            _val[0] ^= _val[11]; _val[11] ^= _val[0]; _val[0] ^= _val[11]; // 0 <-> 11
            _val[1] ^= _val[10]; _val[10] ^= _val[1]; _val[1] ^= _val[10]; // 1 <-> 10
            _val[2] ^= _val[ 9]; _val[ 9] ^= _val[2]; _val[2] ^= _val[ 9]; // 2 <->  9
            _val[3] ^= _val[ 8]; _val[ 8] ^= _val[3]; _val[3] ^= _val[ 8]; // 3 <->  8
            _val[4] ^= _val[ 7]; _val[ 7] ^= _val[4]; _val[4] ^= _val[ 7]; // 4 <->  7
            _val[5] ^= _val[ 6]; _val[ 6] ^= _val[5]; _val[5] ^= _val[ 6]; // 5 <->  6
    }
    else static if(N==16) {
            _reverse_byte_order_N!(8)(_val);
            _reverse_byte_order_N!(8)(_val+8);
            util.swap(*cast(uint64_t*)_val, *((cast(uint64_t*)_val)+1));
    }
    else {
        static assert(false, "We can't handle this number of bytes");
    }
}
}

void reverse_byte_order(T)( ref T _t ) {
    static if (is(T U == U*)) {
        // reversing pointers makes no sense, hence forbid it.
        static assert(false, "You cannot reverse byte order of a pointer" );
    }
    else {
        _reverse_byte_order_N!(T.sizeof)( cast(ubyte*)(&_t) );
    }
}



/+
T reverse_byte_order(T)(const ref T a)
{
    static assert(false, "Cannot reverse byte order of const data");
    return a;
}
+/
   
//@}


import std.io;
unittest {
    int i = 1;
    writefln("i was ", (cast(ubyte*)&i)[0..4]);
    reverse_byte_order(i);
    writefln("reverse i now ", (cast(ubyte*)&i)[0..4]);
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
