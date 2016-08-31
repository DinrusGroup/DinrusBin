//============================================================================
// Attributes.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *    This file provides some macros containing attribute usage.
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 30 Aug 2007
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

module auxd.OpenMesh.Core.Mesh.Attributes;

//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Mesh.Status;


//== CLASS DEFINITION  ========================================================

/** Attribute bits
 * 
 *  Use the bits to define a standard property at compile time using traits.
 *
 *  \include traits5.cc
 *
 *  See_Also: \ref mesh_type
 */
enum AttributeBits : uint
{ 
  None          = 0,  ///< Clear all attribute bits
  Normal        = 1,  ///< Add normals to mesh item (vertices/faces)
  Color         = 2,  ///< Add colors to mesh item (vertices/faces)
  PrevHalfedge  = 4,  ///< Add storage for previous halfedge (halfedges). The bit is set by default in the DefaultTraits.
  Status        = 8,  ///< Add status to mesh item (all items)
  TexCoord1D    = 16, ///< Add 1D texture coordinates (vertices)
  TexCoord2D    = 32, ///< Add 2D texture coordinates (vertices)
  TexCoord3D    = 64  ///< Add 3D texture coordinates (vertices)
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
