//============================================================================
// LaplaceSmootherT.d - 
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

module auxd.OpenMesh.Tools.Smoother.LaplaceSmootherT;

/** \file LaplaceSmootherT.hh
    
 */

//=============================================================================
//
//  CLASS LaplaceSmootherT
//
//=============================================================================

//== INCLUDES =================================================================

public import auxd.OpenMesh.Tools.Smoother.SmootherT;
import auxd.OpenMesh.Core.Geometry.VectorT;
import math = auxd.OpenMesh.Core.Geometry.MathDefs;
import util = auxd.OpenMesh.Core.Utils.Std;

//== CLASS DEFINITION =========================================================

/// Laplacian Smoothing.      
class LaplaceSmootherT(Mesh) : SmootherT!(Mesh)
{
  private:
    alias typeof(super)                 Base;
  public:

    alias SmootherT!(Mesh).Component     Component;
    alias SmootherT!(Mesh).Continuity    Continuity;
    alias SmootherT!(Mesh).Scalar        Scalar;
    alias SmootherT!(Mesh).VertexHandle  VertexHandle;
    alias SmootherT!(Mesh).EdgeHandle    EdgeHandle;
  

    this( Mesh _mesh )
    {
        // custom properties
        super(_mesh);
        mesh_.add_property(vertex_weights_);
        mesh_.add_property(edge_weights_);
    }
    ~this()
    {
        /+
         // free custom properties
         mesh_.remove_property(vertex_weights_);
         mesh_.remove_property(edge_weights_);
         +/
    }


    void initialize(Component _comp, Continuity _cont)
    {
        super.initialize(_comp, _cont);

        // calculate weights
        switch (_comp)
        {
        case Component.Tangential:
            compute_weights(LaplaceWeighting.UniformWeighting);
            break;


        case Component.Normal:
            compute_weights(LaplaceWeighting.CotWeighting);
            break;
      

        case Component.Tangential_and_Normal:
            compute_weights(LaplaceWeighting.UniformWeighting);
            break;
        }
    }


  protected:

    // misc helpers

    Scalar weight(VertexHandle _vh) /*const*/ 
    { return mesh_.property(vertex_weights_, _vh); }

    Scalar weight(EdgeHandle _eh) /*const*/ 
    { return mesh_.property(edge_weights_, _eh); }


  private:

    enum LaplaceWeighting { UniformWeighting, CotWeighting }
    void compute_weights(LaplaceWeighting _mode)
    {
        Mesh.VertexIter        v_it, v_end=(mesh_.vertices_end());
        Mesh.EdgeIter          e_it, e_end=(mesh_.edges_end());
        Mesh.HalfedgeHandle    heh0, heh1, heh2;
        Mesh.VertexHandle      v0, v1;
        /*const*/ Mesh.Point*       p0, p1, p2;
        Mesh.Normal            d0, d1;
        Mesh.Scalar            weight, lb=(-1.0), ub=(1.0);



        // init vertex weights
        for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
            *mesh_.property_ptr(vertex_weights_, v_it.handle) = 0.0;



        switch (_mode)
        {
            // Uniform weighting
        case LaplaceWeighting.UniformWeighting:
        {
            for (e_it=mesh_.edges_begin(); e_it!=e_end; ++e_it)
            {
                heh0   = mesh_.halfedge_handle(e_it.handle(), 0);
                heh1   = mesh_.halfedge_handle(e_it.handle(), 1);
                v0     = mesh_.to_vertex_handle(heh0);
                v1     = mesh_.to_vertex_handle(heh1);
	
                *mesh_.property_ptr(edge_weights_, e_it.handle) = 1.0;
                *mesh_.property_ptr(vertex_weights_, v0) += 1.0;
                *mesh_.property_ptr(vertex_weights_, v1) += 1.0;
            }

            break;
        }


        // Cotangent weighting
        case LaplaceWeighting.CotWeighting:
        {
            for (e_it=mesh_.edges_begin(); e_it!=e_end; ++e_it)
            {
                weight = 0.0;
	
                heh0   = mesh_.halfedge_handle(e_it.handle(), 0);
                v0     = mesh_.to_vertex_handle(heh0);
                p0     = &mesh_.point(v0);
	
                heh1   = mesh_.halfedge_handle(e_it.handle(), 1);
                v1     = mesh_.to_vertex_handle(heh1);
                p1     = &mesh_.point(v1);
	
                heh2   = mesh_.next_halfedge_handle(heh0);
                p2     = &mesh_.point(mesh_.to_vertex_handle(heh2));
                d0     = (*p0 - *p2); d0.normalize();
                d1     = (*p1 - *p2); d1.normalize();
                weight += 1.0 / math.tan(math.acos(util.max(lb, util.min(ub, dot(d0,d1) ))));
	
                heh2   = mesh_.next_halfedge_handle(heh1);
                p2     = &mesh_.point(mesh_.to_vertex_handle(heh2));
                d0     = (*p0 - *p2); d0.normalize();
                d1     = (*p1 - *p2); d1.normalize();
                weight += 1.0 / math.tan(math.acos(util.max(lb, util.min(ub, dot(d0,d1) ))));
	
                *mesh_.property_ptr(edge_weights_, e_it.handle)   = weight;
                *mesh_.property_ptr(vertex_weights_, v0)  += weight;
                *mesh_.property_ptr(vertex_weights_, v1)  += weight;
            }
            break;
        }
        }

  
        // invert vertex weights:
        // before: sum of edge weights
        // after: one over sum of edge weights
        for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
        {
            weight = mesh_.property(vertex_weights_, v_it.handle);
            if (weight)
                *mesh_.property_ptr(vertex_weights_, v_it.handle) = 1.0 / weight;
        }
    }


    VPropHandleT!(Scalar)  vertex_weights_;
    EPropHandleT!(Scalar)  edge_weights_;
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
