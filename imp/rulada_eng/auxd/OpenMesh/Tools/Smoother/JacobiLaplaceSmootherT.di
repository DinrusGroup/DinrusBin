//============================================================================
// JacobiLaplaceSmootherT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 03 Sep 2007
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

module auxd.OpenMesh.Tools.Smoother.JacobiLaplaceSmootherT;

/** \file JacobiLaplaceSmootherT.hh
    
 */


//=============================================================================
//
//  CLASS JacobiLaplaceSmootherT
//
//=============================================================================

//== INCLUDES =================================================================

public import auxd.OpenMesh.Tools.Smoother.LaplaceSmootherT;
import auxd.OpenMesh.Core.Utils.vector_cast;

//import std.io;

//== CLASS DEFINITION =========================================================

/** Laplacian Smoothing.
 *
 */
class JacobiLaplaceSmootherT(Mesh) : LaplaceSmootherT!(Mesh)
{
  private:
    alias LaplaceSmootherT!(Mesh)            Base;
  
  public:

    this( Mesh _mesh ) { super(_mesh); }

    // override: alloc umbrellas
    void smooth(uint _n)
    {
        if (Base.continuity() > Continuity.C0)
        {
            Base.mesh_.add_property(umbrellas_);
            if (Base.continuity() > Continuity.C1)
                Base.mesh_.add_property(squared_umbrellas_);
        }

        super.smooth(_n);

        if (Base.continuity() > Continuity.C0)
        {
            Base.mesh_.remove_property(umbrellas_);
            if (Base.continuity() > Continuity.C1)
                Base.mesh_.remove_property(squared_umbrellas_);
        }

    }


  protected:

    void compute_new_positions_C0()
    {
        Mesh.VertexIter  v_it, v_end=(Base.mesh_.vertices_end());
        Mesh.CVVIter     vv_it;
        Mesh.Normal      u, p, zero=Mesh.Normal(0,0,0);
        Mesh.Scalar      w;

        for (v_it=Base.mesh_.vertices_begin(); v_it!=v_end; ++v_it)
        {
            auto vh = v_it.handle;
            if (is_active(vh))
            {
                // compute umbrella
                u = zero;
                for (vv_it=mesh_.cvv_iter(vh); vv_it.is_active; ++vv_it)
                {
                    w = weight(mesh_.edge_handle(vv_it.current_halfedge_handle()));
                    u += vector_cast!(Mesh.Normal)(mesh_.point(vv_it.handle)) * w;
                }
                u *= weight(vh);
                u -= vector_cast!(Mesh.Normal)(mesh_.point(vh));

                // damping
                u *= 0.5;
    
                // store new position
                p  = vector_cast!(Mesh.Normal)(mesh_.point(vh));
                p += u;
                set_new_position(vh, p);
            }
        }
    }
    void compute_new_positions_C1()
    {
        Mesh.VertexIter  v_it, v_end=(mesh_.vertices_end());
        Mesh.CVVIter     vv_it;
        Mesh.Normal      u, uu, p, zero=Mesh.Normal(0,0,0);
        Mesh.Scalar      w, diag;


        // 1st pass: compute umbrellas
        for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
        {
            u = zero;
            for (vv_it=mesh_.cvv_iter(v_it.handle); vv_it.is_active; ++vv_it)
            {
                w  = weight(mesh_.edge_handle(vv_it.current_halfedge_handle()));
                u -= vector_cast!(Mesh.Normal)(mesh_.point(vv_it.handle))*w;
            }
            u *= weight(v_it.handle);
            u += vector_cast!(Mesh.Normal)(mesh_.point(v_it.handle));

            *mesh_.property_ptr(umbrellas_, v_it.handle) = u;
        }


        // 2nd pass: compute updates
        for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
        {
            auto vh = v_it.handle;
            if (is_active(vh))
            {
                uu   = zero;
                diag = 0.0;   
                for (vv_it=mesh_.cvv_iter(vh); vv_it.is_active; ++vv_it)
                {
                    w     = weight(mesh_.edge_handle(vv_it.current_halfedge_handle()));
                    uu   -= mesh_.property(umbrellas_, vv_it.handle);
                    diag += (w * weight(vv_it.handle) + 1.0) * w;
                }
                uu   *= weight(vh);
                diag *= weight(vh);
                uu   += mesh_.property(umbrellas_, vh);
                if (diag) uu *= 1.0/diag;

                // damping
                uu *= 0.25;
    
                // store new position
                p  = vector_cast!(Mesh.Normal)(mesh_.point(vh));
                p -= uu;
                set_new_position(vh, p);
            }
        }
    }


  private:

    VPropHandleT!(Mesh.Normal)   umbrellas_;
    VPropHandleT!(Mesh.Normal)   squared_umbrellas_;
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
