//============================================================================
// SubdividerT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
//
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 02 Sep 2007
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

module auxd.OpenMesh.Tools.Subdivider.Uniform.SubdividerT;

/** \file SubdividerT.hh
    
 */

//=============================================================================
//
//  CLASS SubdividerT
//
//=============================================================================

//== INCLUDE ==================================================================

import auxd.OpenMesh.Core.System.config;
debug {
    // Makes life lot easier, when playing/messing around with low-level topology
    // changing methods of OpenMesh
    import  auxd.OpenMesh.Tools.Utils.MeshCheckerT;
    void ASSERT_CONSISTENCY(mesh_t) ( mesh_t m ) {
        assert(MeshCheckerT!(mesh_t)(m).check());
    }
}
else 
{
    void ASSERT_CONSISTENCY(mesh_t) ( mesh_t m ) {}
}

//== CLASS DEFINITION =========================================================

/** Abstract base class for uniform subdivision algorithms.
 *
 *  A derived class must overload the following functions:
 *  -# name()
 *  -# prepare()
 *  -# subdivide()
 *  -# cleanup()
 */
class SubdividerT(MeshType,RealType=float) //: private Utils.Noncopyable
{
public:

    alias MeshType mesh_t;
    alias RealType real_t;

public:

    /// \name Constructors
    //@{
    /// Constructor to be used with interface 2
    /// See_Also: attach(), operator()(size_t), detach()
    this() { attached_=null; }

    /// Constructor to be used with interface 1 (calls attach())
    /// See_Also: operator()( MeshType&, size_t )
    this( MeshType _m ) { attached_=null; attach(_m); }

    //@}

    /// Destructor (calls detach())
    ~this() {
        //detach();
    }

    /// Return name of subdivision algorithm
    abstract /*const*/ string name() /*const*/;


public: /// \name Interface 1

    //@{
    /// Subdivide the mesh \c _m \c _n times.
    /// See_Also: SubdividerT(MeshType&)
    bool opCall( MeshType _m, size_t _n )
    {    
        return prepare(_m) && subdivide( _m, _n ) && cleanup( _m );
    }
    //@}

public: /// \name Interface 2
    //@{
    /// Attach mesh \c _m to self
    /// See_Also: SubdividerT(), operator()(size_t), detach()
    bool attach( MeshType _m )
    {
        if ( attached_ is _m )
            return true;

        detach();
        if (prepare( _m ))
        {
            attached_ = _m;
            return true;
        }
        return false;
    }

    /// Subdivide the attached \c _n times.
    /// See_Also: SubdividerT(), attach(), detach()
    bool opCall( size_t _n )
    {
        return attached_ ? subdivide( attached_, _n ) : false;
    }

    /// Detach an eventually attached mesh.
    /// See_Also: SubdividerT(), attach(), operator()(size_t)
    void detach()
    {
        if ( attached_ )
        {
            cleanup( attached_ );
            attached_ = null;
        }
    }
    //@}

protected: 

    /// \name Overload theses methods
    //@{
    /// Prepare mesh, e.g. add properties
    abstract bool prepare( MeshType _m );

    /// Subdivide mesh \c _m \c _n times
    abstract bool subdivide( MeshType _m, size_t _n );

    /// Cleanup mesh after usage, e.g. remove added properties
    abstract bool cleanup( MeshType _m );
    //@}

private:

    MeshType attached_;

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
