//============================================================================
// Plane3d.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 29 Aug 2007
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

module auxd.OpenMesh.Core.Geometry.Plane3d;

//=============================================================================
//
//  CLASS Plane3D
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.Geometry.VectorT;


//== CLASS DEFINITION =========================================================

	      
/** \class Plane3d Plane3d.hh <OpenMesh/Tools/VDPM/Plane3d.hh>

    ax + by + cz + d = 0
*/


struct Plane3d
{
public:

    alias Vec3f       vector_type;
    alias vector_type.value_type   value_type;

public:

    static Plane3d opCall()
    {
        Plane3d M; with(M) {
            d_ = 0;
        } return M;
    }

    static Plane3d opCall(/*const*/ ref vector_type _dir, /*const*/ ref vector_type _pnt)
    { 
        Plane3d M; with (M) {
            n_ = _dir;
            n_.normalize();
            d_ = -dot(n_,_pnt);
        } return M;
    }

    value_type signed_distance(/*const*/ ref Vec3f _p)
    {
        return  dot(n_ , _p) + d_;
    }

public:

    vector_type n_;
    value_type  d_;

}

unittest {
    Plane3d p;
    auto q = Plane3d( Vec3f(0,1,0), Vec3f(1,0,1) );

    p.signed_distance( Vec3f(1,1,1) );

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
