//============================================================================
// SR_types.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   Helper Functions for binary reading / writing
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

module auxd.OpenMesh.Core.IO.SR_types;

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;


//=============================================================================


/** \name Handling binary input/output.
    These functions take care of swapping bytes to get the right Endian.
*/
//@{

//-----------------------------------------------------------------------------

alias byte           int8_t;  alias ubyte      uint8_t;
alias short          int16_t; alias ushort     uint16_t;
alias int            int32_t; alias uint       uint32_t;
alias long           int64_t; alias ulong      uint64_t;

alias float          float32_t;
alias double         float64_t;

alias uint8_t        rgb_t[3];
alias uint8_t        rgba_t[4];
   
//@}

unittest {
    rgb_t x;
    rgba_t y;
    x[0] = 1;
    x[1] = 2;
    x[2] = 3;
    y[0] = 1;
    y[1] = 2;
    y[2] = 3;
    y[3] = 4;

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
