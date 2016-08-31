//============================================================================
// CmdOption.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 28 Aug 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License:
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

module Utils.CmdOption;

private import std.conv;

T convert(T)(string s)
{
    static if(is(T:bool)) {
        return cast(bool)std.conv.toInt(s);
    }
    else static if(is(T:byte)) {
        return cast(T)std.conv.toByte(s);
    }
    else static if(is(T:ubyte)) {
        return cast(T)std.conv.toUbyte(s);
    }
    else static if(is(T:short)) {
        return cast(T)std.conv.toShort(s);
    }
    else static if(is(T:ushort)) {
        return cast(T)std.conv.toUshort(s);
    }
    static if(is(T:int)) {
        return cast(T)std.conv.toInt(s);
    }
    else static if(is(T:uint)) {
        return cast(T)std.conv.toUint(s);
    }
    else static if(is(T:long)) {
        return cast(T)std.conv.toLong(s);
    }
    else static if(is(T:ulong)) {
        return cast(T)std.conv.toUlong(s);
    }
    else static if(is(T:float)) {
        return cast(T)std.conv.toFloat(s);
    }
    else static if(is(T:double)) {
        return cast(T)std.conv.toDouble(s);
    }
    else static if(is(T:real)) {
        return cast(T)std.conv.toReal(s);
    }
    else static if(is(string:T)) {
        return s;
    }
}



struct CmdOption(T)
{
public:

    alias T value_type;

    static CmdOption opCall(/*const ref*/ T _val) {
        CmdOption M; with (M) {
            val_ = _val; 
            valid_ = true;
        }  return M;
    }
    static CmdOption opCall() {
        CmdOption M; with (M) {
            //val_ = _val;
            valid_ = false;
            enabled_ = false;
        }  return M;
    }

    // has been set and has a value
    bool is_valid()   { return valid_;   }
    bool has_value()  { return is_valid(); }

    // has been set and may have an value (check with is_valid())
    bool is_enabled() { return enabled_; }

    void enable() { enabled_ = true; }

    void opAssign ( /*const ref*/ T _val ) 
    { 
        val_ = _val;
        valid_=true; 
        enable();
    }

    T val() { return val_; }

    T* ptr() { return is_valid() ? &val_ : null; }

    char[] toString() {
        return std.string.format(val_);
    }

private:

    T    val_;
    bool valid_;
    bool enabled_;
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
