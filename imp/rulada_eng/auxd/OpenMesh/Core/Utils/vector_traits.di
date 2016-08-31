//============================================================================
// vector_traits.d - 
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 28 Aug 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================
// $Id:$
//============================================================================

module auxd.OpenMesh.Core.Utils.vector_traits;

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
//   $Date: 2007-05-18 15:17:50 $
//                                                                            
//=============================================================================


//=============================================================================
//
//  Helper Functions for binary reading / writing
//
//=============================================================================


//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.GenProg;

//=============================================================================


/** \name Provide a standardized access to relevant information about a
     vector type.
*/
//@{

//-----------------------------------------------------------------------------

/** Helper class providing information about a vector type.
 *
 * If want to use a different vector type than the one provided %OpenMesh
 * you need to supply a specialization of this class for the new vector type.
 */
struct vector_traits(T)
{
    /// Type of the vector class
    alias T.vector_type vector_type;

    /// Type of the scalar value
    alias T.value_type  value_type;

    /// size/dimension of the vector
    static const size_t size_ = T.size_;

    /// size/dimension of the vector
    static size_t size() { return size_; }
}

//@}




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
