//============================================================================
// color_cast.d - 
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 01 Sep 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================
// $Id:$
//============================================================================

module auxd.OpenMesh.Core.Utils.color_cast;

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
import auxd.OpenMesh.Core.Utils.vector_cast;

//=============================================================================


/** \name Cast vector type to another vector type.
*/
//@{

//-----------------------------------------------------------------------------
/// Cast one color vector to another.

//-----------------------------------------------------------------------------


void color_copy(src_t,dst_t,scale_t,uint N, uint i=0)
    (/*const*/ ref src_t s, ref dst_t d, scale_t scale, scale_t bias)
{
    static if(i<N) {
        d[i] = cast(typeof(d[0]))(s[i] * scale + bias);
        color_copy!(src_t,dst_t,scale_t,N,i+1)(s,d, scale, bias);
    }
}


//-----------------------------------------------------------------------------


template color_cast(dst_t) {
    dst_t color_cast(src_t)(ref src_t src) { 
        alias typeof(src_t.init[0]) src_elem_t;
        alias typeof(dst_t.init[0]) dst_elem_t;
        const bool src_is_float = is(typeof(src_elem_t.nan));
        const bool dst_is_float = is(typeof(dst_elem_t.nan));
        static assert(src_t.length == dst_t.length, 
                      "Length of vector types do not match");

        static if (is(dst_t==src_t)) {
            //pragma(msg, "trivial branch");
            return src; 
        }
        else static if ((src_is_float && dst_is_float) ||
                        (!src_is_float && !dst_is_float))
        {
            //pragma(msg, "float/int matches branch");
            static assert(src_t.length == dst_t.length, 
                          "Length of vector types do not match");
            dst_t tmp;
            vector_copy!(src_t, dst_t, src_t.length)(src, tmp);
            return tmp;
        }
        else static if(src_is_float && !dst_is_float) 
        {
            //pragma(msg, "src_float, dest int");
            dst_t tmp;
            alias  typeof(src[0]) scale_t ;
            scale_t scale = cast(scale_t)255;
            scale_t bias = cast(scale_t)0.5;
            color_copy!(src_t, dst_t, scale_t, src_t.length)(src, tmp, scale, bias);
            return tmp;
        }
        else // (!src_is_float && dst_is_float)
        {
            //pragma(msg, "dest_float, src int");
            dst_t tmp;
            alias  typeof(tmp[0]) scale_t;
            scale_t scale = cast(scale_t)1.0/cast(scale_t)255;
            scale_t bias = cast(scale_t)0;
            color_copy!(src_t, dst_t, scale_t, src_t.length)(src, tmp, scale, bias);
            return tmp;
        }
    }
}

//@}

version(Unittest) {
    import auxd.OpenMesh.Core.Geometry.VectorT;
    import std.io;
}


unittest {
    version(Unittest) {
        //Vec3f
        VectorT!(float,3) v; v = [.1f,.2,.3];
        Vec3ub c = [0u,128,255];


        writefln("      v=%s       c=%s\n"
                 "cast(v)=%s cast(c)=%s", v,c, color_cast!(Vec3ub)(v), color_cast!(Vec3f)(c));
        writefln("      v=[%s,%s,%s]", v[0],v[1],v[2]);
        //Vec3ub c2 = (color_cast!(Vec3ub)(v)/2 + c/2);
    }
    else {
        static assert(false, "color_cast.d: This unittest must be run with -version=Unittest");
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
