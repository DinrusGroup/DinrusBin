//============================================================================
// Endian.d - 
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 30 Aug 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================

module auxd.OpenMesh.Core.Utils.Endian;

//=============================================================================
//                                                                            
//                               OpenMesh                                     
//        Copyright (C) 2003 by Computer Graphics Group, RWTH Aachen          
//                           www.openmesh.org                                 
//                                                                            
//-----------------------------------------------------------------------------
//                                                                            
//                                License                                     
//                                                                            
//   This library is free software; you can redistribute it and/or modify it 
//   under the terms of the GNU Lesser General Public License as published   
//   by the Free Software Foundation, version 2.1.                           
//                                                                             
//   This library is distributed in the hope that it will be useful, but       
//   WITHOUT ANY WARRANTY; without even the implied warranty of                
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU         
//   Lesser General Public License for more details.                           
//                                                                            
//   You should have received a copy of the GNU Lesser General Public          
//   License along with this library; if not, write to the Free Software       
//   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.                 
//                                                                            
//-----------------------------------------------------------------------------
//                                                                            
//   $Revision: 1.2 $
//   $Date: 2007-05-18 15:17:49 $
//                                                                            
//=============================================================================

//=============================================================================
//
//  Helper Functions for binary reading / writing
//
//=============================================================================


//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;

//== IMPLEMENTATION ===========================================================

//-----------------------------------------------------------------------------

enum EndianType {
    LSB = 1, ///< Little endian (Intel family and clones)
    MSB      ///< big endian (Motorola's 68x family, DEC Alpha, MIPS)
}
  

/**  Determine byte order of host system.
 */
struct Endian
{
public:
   
    alias EndianType.LSB LSB;
    alias EndianType.MSB MSB;

    /// Return endian type of host system.
    static EndianType local() { return local_; }

    /// Return type _t as string.
    static /*const*/ string as_string(EndianType _t) 
    {
        return _t == EndianType.LSB ? "LSB" : "MSB";
    }
   
private:
    version(LittleEndian) {
        const EndianType local_ = EndianType.LSB;
    }
    else {
        const EndianType local_ = EndianType.MSB;
    }
}

version (LittleEndian) {
    bool is_little_endian() { return true; }
    bool is_big_endian() { return false; }
} else {
    bool is_big_endian() { return true; }
    bool is_little_endian() { return false; }
}

static import std.io;
unittest {
    std.io.writefln("Local Endian type is ", Endian.as_string(Endian.local));
    assert((Endian.local == EndianType.LSB && Endian.as_string(Endian.local) == "LSB")||
           (Endian.local == EndianType.MSB && Endian.as_string(Endian.local) == "MSB"));
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
