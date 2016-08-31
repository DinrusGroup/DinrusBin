//============================================================================
// SmootherT.d - 
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

module auxd.OpenMesh.Tools.Smoother.SmootherT;

/** \file SmootherT.hh
    
 */

//=============================================================================
//
//  CLASS SmootherT
//
//=============================================================================


//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
public import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.Utils.vector_cast;
import math =  auxd.OpenMesh.Core.Geometry.MathDefs;

//== CLASS DEFINITION =========================================================

/** Base class for smoothing algorithms.
 */	      
class SmootherT(Mesh)  // : private Utils.Noncopyable
{
public:

    alias Mesh.Scalar        Scalar;
    alias Mesh.Point         Point;
    alias Mesh.Normal        NormalType;
    alias Mesh.VertexHandle  VertexHandle;
    alias Mesh.EdgeHandle    EdgeHandle;

    // initialize smoother
    enum Component { 
        Tangential,           ///< Smooth tangential direction
        Normal,               ///< Smooth normal direction
        Tangential_and_Normal ///< Smooth tangential and normal direction
    }

    enum Continuity { 
        C0, 
        C1, 
        C2 
    }

public:

    // constructor
    this( Mesh _mesh ) {
        mesh_ = _mesh;

        // request properties
        mesh_.request_vertex_status();
        mesh_.request_face_normals();
        mesh_.request_vertex_normals();

        // custom properties
        mesh_.add_property(original_positions_);
        mesh_.add_property(original_normals_);
        mesh_.add_property(new_positions_);
        mesh_.add_property(is_active_);


        // default settings
        component_  = Component.Tangential_and_Normal;
        continuity_ = Continuity.C0;
        tolerance_  = -1.0;
    }

    ~this() {
        /+
         // free properties
         mesh_.release_vertex_status();
         mesh_.release_face_normals();
         mesh_.release_vertex_normals();

         // free custom properties
         mesh_.remove_property(original_positions_);
         mesh_.remove_property(original_normals_);
         mesh_.remove_property(new_positions_);
         mesh_.remove_property(is_active_);
         +/
    }

public:

    /// Initialize smoother
    /// \param _comp Determine component to smooth
    /// \param _cont 
    void initialize(Component _comp, Continuity _cont)
    {
        Mesh.VertexIter  v_it, v_end=(mesh_.vertices_end());


        // store smoothing settings
        component_  = _comp;
        continuity_ = _cont;


        // update normals
        mesh_.update_face_normals();
        mesh_.update_vertex_normals();


        // store original points & normals
        for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
        {
            auto vh = v_it.handle;
            *mesh_.property_ptr(original_positions_, vh) = mesh_.point(vh);
            *mesh_.property_ptr(original_normals_,   vh) = mesh_.normal(vh);
        }

    }


    //@{
    /// Set local error
    void set_relative_local_error(Scalar _err)
    {
        if (!mesh_.vertices_empty())
        {
            Mesh.VertexIter  v_it=(mesh_.vertices_begin()), 
                v_end=(mesh_.vertices_end());


            // compute bounding box
            Point  bb_min, bb_max;
            bb_min = bb_max = mesh_.point(v_it.handle);
            for (++v_it; v_it!=v_end; ++v_it)
            {
                bb_min.minimize(mesh_.point(v_it.handle));
                bb_max.minimize(mesh_.point(v_it.handle));
            }


            // abs. error = rel. error * bounding-diagonal
            set_absolute_local_error(_err * (bb_max-bb_min).norm());
        }
    }

    void set_absolute_local_error(Scalar _err)
    {
        tolerance_ = _err;
    }

    void disable_local_error_check()
    {
        tolerance_ = -1.0;
    }
    //@}


    /// Do _n smoothing iterations
    void smooth(uint _n)
    {
        // mark active vertices
        set_active_vertices();

        // smooth _n iterations
        while (_n--)
        {
            compute_new_positions();

            if (component_ == Component.Tangential)
                project_to_tangent_plane();

            else if (tolerance_ >= 0.0)
                local_error_check();

            move_points();
        }
    }



    /// Find active vertices. Resets tagged status !
    void set_active_vertices()
    {
        Mesh.VertexIter  v_it, v_end=(mesh_.vertices_end());


        // is something selected?
        bool nothing_selected=(true);
        for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
            if (mesh_.vstatus_ptr(v_it.handle).selected())
            { nothing_selected = false; break; }


        // tagg all active vertices
        bool active;
        for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
        {
            active = ((nothing_selected || mesh_.vstatus_ptr(v_it.handle).selected()) 
                      && !mesh_.is_boundary(v_it.handle)
                      && !mesh_.vstatus_ptr(v_it.handle).locked());
            *mesh_.property_ptr(is_active_, v_it.handle) = active;
        }


        // C1: remove one ring of boundary vertices
        if (continuity_ == Continuity.C1)
        {
            Mesh.VVIter     vv_it;

            for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
                if (mesh_.is_boundary(v_it.handle))
                    for (vv_it=mesh_.vv_iter(v_it.handle); vv_it.is_active; ++vv_it)
                        *mesh_.property_ptr(is_active_, vv_it.handle) = false;
        }


        // C2: remove two rings of boundary vertices
        if (continuity_ == Continuity.C2)
        {
            Mesh.VVIter     vv_it;

            for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
            {
                mesh_.vstatus_ptr(v_it.handle).set_tagged(false);
                mesh_.vstatus_ptr(v_it.handle).set_tagged2(false);
            }

            for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
                if (mesh_.is_boundary(v_it.handle))
                    for (vv_it=mesh_.vv_iter(v_it.handle); vv_it.is_active; ++vv_it)
                        mesh_.vstatus_ptr(v_it.handle).set_tagged(true);

            for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
                if (mesh_.vstatus_ptr(v_it.handle).tagged())
                    for (vv_it=mesh_.vv_iter(v_it.handle); vv_it.is_active; ++vv_it)
                        mesh_.vstatus_ptr(v_it.handle).set_tagged2(true);

            for (v_it=mesh_.vertices_begin(); v_it!=v_end; ++v_it)
            {
                if (mesh_.vstatus_ptr(v_it.handle).tagged2())
                    *mesh_.property_ptr(is_active_, vv_it.handle) = false;
                mesh_.vstatus_ptr(v_it.handle).set_tagged(false);
                mesh_.vstatus_ptr(v_it.handle).set_tagged2(false);
            }
        }
    }


private:

    // single steps of smoothing
    void compute_new_positions()
    {
        switch (continuity_)
        {
        case Continuity.C0:
            compute_new_positions_C0();
            break;

        case Continuity.C1:
            compute_new_positions_C1();
            break;

        case Continuity.C2:
            break;
        }
    }

    void project_to_tangent_plane()
    {
        Mesh.VertexIter  v_it=(mesh_.vertices_begin()), 
            v_end=(mesh_.vertices_end());
        // Normal should be a vector type. In some environment a vector type
        // is different from point type, e.g. OpenSG!
        Mesh.Normal      translation, normal;


        for (; v_it != v_end; ++v_it)  
        {
            auto vh = v_it.handle;
            if (is_active(vh))
            {
                translation  = new_position(vh)-orig_position(vh);
                normal       = orig_normal(vh);
                normal      *= dot(translation, normal);
                translation -= normal;
                translation += vector_cast!(Mesh.Normal)(orig_position(vh));
                set_new_position(vh, translation);
            }
        }
    }

    void local_error_check()
    {
        Mesh.VertexIter  v_it=(mesh_.vertices_begin()), 
            v_end=(mesh_.vertices_end());

        Mesh.Normal      translation;
        Mesh.Scalar      s;


        for (; v_it != v_end; ++v_it)  
        {
            auto vh = v_it.handle;
            if (is_active(vh))
            {
                translation  = new_position(vh) - orig_position(vh);

                s = math.abs(dot(translation, orig_normal(vh)));

                if (s > tolerance_)
                {
                    translation *= (tolerance_ / s);
                    translation += vector_cast!(NormalType)(orig_position(vh));
                    set_new_position(vh, translation);
                }
            }
        }
    }

    void move_points()
    {
        Mesh.VertexIter  v_it=(mesh_.vertices_begin()), 
            v_end=(mesh_.vertices_end());

        for (; v_it != v_end; ++v_it)  {
            auto vh = v_it.handle;
            if (is_active(vh))
                mesh_.set_point(vh, mesh_.property(new_positions_, vh));
        }
    }
  


protected:

    // override these
    abstract void compute_new_positions_C0();        
    abstract void compute_new_positions_C1();


protected:

    // misc helpers

    /*const*/ Point orig_position(VertexHandle _vh) /*const*/
    { return mesh_.property(original_positions_, _vh); }

    /*const*/ NormalType orig_normal(VertexHandle _vh) /*const*/
    { return mesh_.property(original_normals_, _vh); }

    /*const*/ Point new_position(VertexHandle _vh) /*const*/
    { return mesh_.property(new_positions_, _vh); }

    void set_new_position(VertexHandle _vh, /*const*/ ref Point _p)
    { *mesh_.property_ptr(new_positions_, _vh) = _p; }

    bool is_active(VertexHandle _vh) /*const*/ 
    { return mesh_.property(is_active_, _vh); }

    Component  component()  /*const*/ { return component_;  }
    Continuity continuity() /*const*/ { return continuity_; }

protected:

    Mesh  mesh_;


private:

    Scalar      tolerance_;
    Scalar      normal_deviation_;
    Component   component_;
    Continuity  continuity_;

    VPropHandleT!(Point)      original_positions_;
    VPropHandleT!(NormalType) original_normals_;
    VPropHandleT!(Point)      new_positions_;
    VPropHandleT!(bool)       is_active_;
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
