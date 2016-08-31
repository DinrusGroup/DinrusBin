//============================================================================
// Options.d -
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description:
 *    Options struct for reader and writer modules.
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

module auxd.OpenMesh.Core.IO.Options;

//=== INCLUDES ================================================================

// OpenMesh
import auxd.OpenMesh.Core.System.config;


//=== IMPLEMENTATION ==========================================================


/** \name Mesh Reading / Writing
    Option for reader and writer modules.
*/
//@{


//-----------------------------------------------------------------------------

/** \brief Set options for reader/writer modules.
 *
 *  The class is used in a twofold way.
 *  -# In combination with reader modules the class is used
 *     - to pass hints to the reading module, whether the input is
 *     binary and what byte ordering the binary data has
 *     - to retrieve information about the file contents after
 *     succesful reading.
 *  -# In combination with write modules the class gives directions to
 *     the writer module, whether to
 *     - use binary mode or not and what byte order to use
 *     - store one of the standard properties.
 *
 */
struct IO_Options
{
public:
    alias int       enum_type;
    alias enum_type value_type;

    /// Definitions of %Options for reading and writing. The options can be
    /// or'ed.
    enum : enum_type {
        None           = 0x0000, ///< Nothing flagged
        Binary         = 0x0001, ///< Set binary mode for r/w
        MSB            = 0x0002, ///< Assume big endian byte ordering
        LSB            = 0x0004, ///< Assume little endian byte ordering
        Swap           = 0x0006, ///< Swap byte order in binary mode
        VertexNormal   = 0x0010, ///< Has (r) / store (w) vertex normals
        VertexColor    = 0x0020, ///< Has (r) / store (w) vertex colors
        VertexTexCoord = 0x0040, ///< Has (r) / store (w) texture coordinates
        FaceNormal     = 0x0100, ///< Has (r) / store (w) face normals
        FaceColor      = 0x0200,  ///< Has (r) / store (w) face colors

        AllProperties = VertexNormal|VertexColor|VertexTexCoord
                        |FaceNormal|FaceColor, /// Every vertex or face property
        All = Binary|AllProperties, /// All properties + binary
        Default = AllProperties, ///< All properties is the default
    }

public:

    /// Default constructor
    static IO_Options opCall() { IO_Options M; return M; }


    /// Initializing constructor setting a single option
    static IO_Options opCall(enum_type _flg)
    {
        IO_Options M; M.flags_ = _flg;
        return M;
    }

    void opAssign( enum_type flags ) {
        flags_ = flags;
    }

    /// Restore state after default constructor.
    void cleanup()
    { flags_ = Default; }

    /// Clear all bits.
    void clear()
    { flags_ = 0; }

    /// Returns true if all bits are zero.
    bool is_empty() /*const*/ { return cast(int)flags_ == 0; }

public:

    /// Unset options defined in _rhs.
    void opSubAssign( /*const*/ value_type _rhs )
    { flags_ &= ~_rhs; /*return *this;*/ }

    /// ditto
    void unset( /*const*/ value_type _rhs)
    { /*return*/ (*this -= _rhs); }



    /// Set options defined in _rhs

    void opAddAssign ( /*const*/ value_type _rhs )
    { flags_ |= _rhs; /*return *this;*/ }

    /// ditto
    void set( /*const*/ value_type _rhs)
    { /*return*/ (*this += _rhs); }

    /// Set a particular flag on or off
    void set_flag( /*const*/ value_type _flag, bool _onOff=true)
    { 
        if (_onOff) *this += _flag; 
        else        *this -= _flag;
    }

public:

    int opEquals(IO_Options flags) {
        return (flags.flags_ == flags_);
    }
    int opEquals(enum_type flags) {
        return (flags == flags_);
    }


    // Check if an option or several options are set.
    bool check(/*const*/ value_type _rhs) /*const*/
    {
        return (flags_ & _rhs)==_rhs;
    }

    value_type flags() {
        return flags_;
    }

    bool vertex_has_normal()   /*const*/ { return check(VertexNormal); }
    bool vertex_has_color()    /*const*/ { return check(VertexColor); }
    bool vertex_has_texcoord() /*const*/ { return check(VertexTexCoord); }
    bool face_has_normal()     /*const*/ { return check(FaceNormal); }
    bool face_has_color()      /*const*/ { return check(FaceColor); }

    string toString() {
        string ret = "IO_Options(";
        if (check(Binary)) ret ~= "Binary|";
        if (check(MSB)) ret ~= "MSB|";
        if (check(LSB)) ret ~= "LSB|";
        if (check(Swap)) ret ~= "Swap|";
        if (check(VertexNormal)) ret ~= "VertexNormal|";
        if (check(VertexColor)) ret ~= "VertexColor|";
        if (check(VertexTexCoord)) ret ~= "VertexTexCoord|";
        if (check(FaceNormal)) ret ~= "FaceNormal|";
        if (check(FaceColor)) ret ~= "FaceColor|";
        if (ret[$-1]=='|') ret[$-1]=')';
        else ret ~= ")";
        return ret;
    }

private:

    //bool operator && (/*const*/ value_type _rhs) /*const*/;

    value_type flags_ = Default;
}

alias IO_Options Options;

//-----------------------------------------------------------------------------




//@}

unittest {
    IO_Options opts = IO_Options.VertexNormal | IO_Options.VertexColor;
    opts -= IO_Options.VertexColor;
    opts.unset(IO_Options.VertexNormal);
    opts+=IO_Options.FaceNormal;
    opts.set(IO_Options.FaceColor);

    assert(opts == IO_Options(IO_Options.FaceColor|IO_Options.FaceNormal));
    assert(opts == IO_Options.FaceColor|IO_Options.FaceNormal);
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
