//============================================================================
// vector_cast.d - 
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

module auxd.OpenMesh.Core.Utils.vector_cast;

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
public import auxd.OpenMesh.Core.Geometry.VectorT;


//=============================================================================


/** \name Cast vector type to another vector type.
*/
//@{

//-----------------------------------------------------------------------------

void vector_copy(src_t,dst_t,uint N, uint i=0)(ref src_t s, ref dst_t d)
{
    static if(i<N) {
        d[i] = cast(typeof(d[0])) s[i];
        vector_copy!(src_t,dst_t,N,i+1)(s,d);
    }
}


//-----------------------------------------------------------------------------


template vector_cast(dst_t) {
    dst_t vector_cast(src_t)(ref src_t src) { 
        static if (is(dst_t==src_t)) {
            //pragma(msg, "trivial branch");
            return src; 
        }
        else {
            //pragma(msg, "different types branch");
            static assert(src_t.length == dst_t.length, 
                          "Length of vector types do not match");
            dst_t tmp;
            vector_copy!(src_t, dst_t, src_t.length)(src, tmp);
            return tmp;
        }
    }
}



//@}

version(Unittest) {
    import auxd.OpenMesh.Core.Geometry.VectorT;
}

unittest {
    version(Unittest) {
        Vec3f v1; v1 = [.1f,.2,.3];
        Vec3d v2; v2 = [1.,2.,3.];
        //Vec3f vc = vector_cast!(Vec3f,Vec3d)(v2);
        Vec3f v3 = v1 + vector_cast!(Vec3f)(v2);
        Vec3f v4 = v1 + vector_cast!(Vec3f)(v1);
    }
    else {
        static assert(false, "vector_cast.d: This unittest must be run with -version=Unittest");
    }
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
