//============================================================================
// ModQuadricT.d - 
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

module auxd.OpenMesh.Tools.Decimater.ModQuadricT;

import std.io;


//=============================================================================
//
//  CLASS ModQuadricT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.Decimater.ModBaseT;
import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.Utils.vector_cast;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Geometry.QuadricT;


//== CLASS DEFINITION =========================================================


/** Mesh decimation module computing collapse priority based on error quadrics.
 *
 *  This module can be used as a binary and non-binary module.
 */
class ModQuadricT(DecimaterType) : ModBaseT!(DecimaterType)
{
  public:

    // Defines the types Self, Handle, Base, Mesh, and CollapseInfo
    // and the memberfunction name()
    mixin DECIMATING_MODULE!( DecimaterType, "Quadric" );

  public:

    /** Constructor
     *  \internal
     */
    this( DecimaterType _dec )
    {
        super(_dec, false);
        unset_max_err();
        super.mesh().add_property( quadrics_ );
    }


    /// Destructor
    ~this()
    {
        // OK?
        //super.mesh().remove_property(quadrics_);
    }


  public: // inherited

    /// Initalize the module and prepare the mesh for decimation.
    void initialize()
    {
        // alloc quadrics
        if (!quadrics_.is_valid())
            super.mesh().add_property( quadrics_ );

        // clear quadrics
        Mesh.VertexIter  v_it  = super.mesh().vertices_begin(),
            v_end = super.mesh().vertices_end();

        for (; v_it != v_end; ++v_it)
            super.mesh().property(quadrics_, v_it.handle).clear();

        // calc (normal weighted) quadric
        Mesh.FaceIter f_it  = super.mesh().faces_begin(),
            f_end = super.mesh().faces_end();

        Mesh.FaceVertexIter    fv_it;
        Mesh.VertexHandle      vh0, vh1, vh2;
        alias Vec3d            Vec3;
        double                 a,b,c,d, area;

        for (; f_it != f_end; ++f_it)
        {
            fv_it = super.mesh().fv_iter(f_it.handle());
            vh0 = fv_it.handle();  ++fv_it;
            vh1 = fv_it.handle();  ++fv_it;
            vh2 = fv_it.handle();

            Vec3 v0, v1, v2;
            {
                v0 = vector_cast!(Vec3)(super.mesh().point(vh0));
                v1 = vector_cast!(Vec3)(super.mesh().point(vh1));
                v2 = vector_cast!(Vec3)(super.mesh().point(vh2));
            }

            Vec3 n = cross((v1-v0) , (v2-v0));
            area = n.norm();
            if (area > float.min)
            {
                n /= area;
                area *= 0.5;
            }

            a = n[0];
            b = n[1];
            c = n[2];
            d = -dot(vector_cast!(Vec3)(super.mesh().point(vh0)) , n);

            auto q = Quadricd(a, b, c, d);
            q *= area;

            *super.mesh().property_ptr(quadrics_, vh0) += q;
            *super.mesh().property_ptr(quadrics_, vh1) += q;
            *super.mesh().property_ptr(quadrics_, vh2) += q;
        }

    }

    /** Compute collapse priority based on error quadrics.
     *
     *  See_Also: ModBaseT.collapse_priority() for return values,
     *            set_max_err()
     */
    float collapse_priority(/*const*/ ref CollapseInfo _ci)
    {
        alias QuadricT!(double) Q;

        Q q = *super.mesh().property_ptr(quadrics_, _ci.v0);
        q += *super.mesh().property_ptr(quadrics_, _ci.v1);

        double err = q.eval(_ci.p1);

        //min_ = std.min(err, min_);
        //max_ = std.max(err, max_);

        //double err = q( p );

        return cast(float)( (err < max_err_) ? err : super.ILLEGAL_COLLAPSE );
    }


    /// Post-process halfedge collapse (accumulate quadrics)
    void postprocess_collapse(/*const*/ ref CollapseInfo _ci)
    {
        *super.mesh().property_ptr(quadrics_, _ci.v1) +=
            *super.mesh().property_ptr(quadrics_, _ci.v0);
    }



  public: // specific methods

    /** Set maximum quadric error constraint and enable binary mode.
     *  \param _err    Maximum error allowed
     *  \param _binary Let the module work in non-binary mode in spite of the
     *                 enabled constraint.
     *  See_Also: unset_max_err()
     */
    void set_max_err(double _err, bool _binary=true)
    {
        max_err_ = _err;
        super.set_binary(_binary);
    }

    /// Unset maximum quadric error constraint and restore non-binary mode.
    /// See_Also: set_max_err()
    void unset_max_err()
    {
        max_err_ = double.max;
        super.set_binary(false);
    }

    /// Return value of max. allowed error.
    double max_err() /*const*/ { return max_err_; }


  private:

    // maximum quadric error
    double max_err_;

    // this vertex property stores a quadric for each vertex
    VPropHandleT!(QuadricT!(double))  quadrics_;
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
