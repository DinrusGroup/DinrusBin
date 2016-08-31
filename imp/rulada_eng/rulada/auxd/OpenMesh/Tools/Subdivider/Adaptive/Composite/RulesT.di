//============================================================================
// RulesT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
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

module auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.RulesT;

/** \file RulesT.hh
    
 */


//=============================================================================
//
//  Composite Subdivision and Averaging Rules
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
public import auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.RuleInterfaceT;
public import auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.Traits;
import auxd.OpenMesh.Core.IO.MeshIO;
import math = auxd.OpenMesh.Core.Geometry.MathDefs;


//== CLASS DEFINITION =========================================================

private template MESH_ALIASES(alias mesh) {
    // This doesn't work -- you can't alias-in virtual functions from a member
    // Local functions are a possibility but templated functions aren't possible.
    // Need macros...
    //macro(handle) { mesh_.data_ptr(handle) }
    /+    
    alias mesh.data MOBJ;
    alias mesh.face_handle mFH;
    alias mesh.vertex_handle mVH;
    alias mesh.edge_handle mEH;
    alias mesh.halfedge_handle mHEH;
    alias mesh.next_halfedge_handle mNHEH;
    alias mesh.prev_halfedge_handle mPHEH;
    alias mesh.opposite_halfedge_handle mOHEH;
    alias mesh.to_vertex_handle mTVH;
    alias mesh.from_vertex_handle mFVH;
+/
}

/** Adaptive Composite Subdivision framework.
*/

private {
    void pop_back(T)(ref T[] array) {
        array.length = array.length -1;
    }
    bool empty(T)(T[] array) {
        return array.length == 0;
    }
}

//=============================================================================
  
/** Topological composite rule Tvv,3 doing a 1-3 split of a face.
 */
class Tvv3(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "Tvv3", "M" ) );

  private:
    alias RuleInterfaceT!(M)                 Base;

    mixin MESH_ALIASES!(mesh_);

  public:

    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh);  super.set_subdiv_type(3); };


    void raise(M.FaceHandle   _fh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_fh).state() < _target_state) 
        {
            update(_fh, _target_state);

            M.VertexVertexIter          vv_it;
            M.FaceVertexIter            fv_it;
            M.VertexHandle              vh;
            M.Point                     position=M.Point(0.0, 0.0, 0.0);
            M.Point                     face_position;
            /*const*/ M.Point           zero_point=M.Point(0.0, 0.0, 0.0);
            M.VertexHandle[] vertex_vector;
            int                                      valence=(0);

            // raise all adjacent vertices to level x-1
            for (fv_it = Base.mesh_.fv_iter(_fh); fv_it.is_active; ++fv_it) {

                vertex_vector ~= (fv_it.handle());
            }

            while(!vertex_vector.empty()) {

                vh = vertex_vector[$-1];
                vertex_vector.pop_back();

                if (_target_state > 1)
                    Base.prev_rule().raise(vh, _target_state - 1);
            }

            face_position = mesh_.data_ptr(_fh).position(_target_state - 1);
    
            M.EdgeHandle             eh;
            M.EdgeHandle[]  edge_vector;

            // interior face
            if (!Base.mesh_.is_boundary(_fh) || mesh_.data_ptr(_fh).finale()) { 

                // insert new vertex
                vh = Base.mesh_.new_vertex();

                Base.mesh_.split(_fh, vh);

                // calculate display position for new vertex
                for (vv_it = Base.mesh_.vv_iter(vh); vv_it.is_active; ++vv_it) 
                {
                    position += Base.mesh_.point(vv_it.handle());
                    ++valence;
                }

                position /= valence;

                // set attributes for new vertex
                Base.mesh_.set_point(vh, position);
                mesh_.data_ptr(vh).set_position(_target_state, zero_point);
                mesh_.data_ptr(vh).set_state(_target_state);
                mesh_.data_ptr(vh).set_not_finale();

                M.VertexOHalfedgeIter      voh_it;
                // check for edge flipping
                for (voh_it = Base.mesh_.voh_iter(vh); voh_it.is_active; ++voh_it) {
      
                    if (m.face_handle(voh_it.handle()).is_valid()) {

                        m.data_ptr(m.face_handle(voh_it.handle())).set_state(_target_state);
                        m.data_ptr(m.face_handle(voh_it.handle())).set_not_finale();
                        m.data_ptr(m.face_handle(voh_it.handle())).set_position(_target_state - 1, face_position);
      

                        for (state_t j = 0; j < _target_state; ++j) {
                            m.data_ptr(m.face_handle(voh_it.handle())).set_position(j, m.data_ptr(_fh).position(j));
                        }
      
                        if (m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle()))).is_valid()) {

                            if (m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle())))).state() == _target_state) {

                                if (Base.mesh_.is_flip_ok(m.edge_handle(m.next_halfedge_handle(voh_it.handle())))) {

                                    edge_vector ~= (m.edge_handle(m.next_halfedge_handle(voh_it.handle())));
                                }
                            }
                        }
                    }
                }
            }
    
            // boundary face
            else { 

                M.VertexHandle vh1 = Base.mesh_.new_vertex(),
                    vh2 = Base.mesh_.new_vertex();
      
                M.HalfedgeHandle hh2 = m.halfedge_handle(_fh),
                    hh1, hh3;
      
                while (!Base.mesh_.is_boundary(m.opposite_halfedge_handle(hh2)))
                    hh2 = m.next_halfedge_handle(hh2);
      
                eh = m.edge_handle(hh2);
      
                hh2 = m.next_halfedge_handle(hh2);
                hh1 = m.next_halfedge_handle(hh2);
      
                assert(Base.mesh_.is_boundary(eh));

                Base.mesh_.split(eh, vh1);

                eh = m.edge_handle(m.prev_halfedge_handle(hh2));

                assert(Base.mesh_.is_boundary(eh));

                Base.mesh_.split(eh, vh2);

                hh3 = m.next_halfedge_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(hh1)));

                M.VertexHandle   vh0=(m.to_vertex_handle(hh1)),
                    vh3=(m.from_vertex_handle(hh2));

                // set display position and attributes for new vertices
                Base.mesh_.set_point(vh1, (Base.mesh_.point(vh0) * 2.0 + Base.mesh_.point(vh3)) / 3.0);

                m.data_ptr(vh1).set_position(_target_state, zero_point);
                m.data_ptr(vh1).set_state(_target_state);
                m.data_ptr(vh1).set_not_finale();

                m.data_ptr(vh0).set_position(_target_state, m.data_ptr(vh0).position(_target_state - 1) * 3.0);
                m.data_ptr(vh0).set_state(_target_state);
                m.data_ptr(vh0).set_not_finale();

                // set display position and attributes for old vertices
                Base.mesh_.set_point(vh2, (Base.mesh_.point(vh3) * 2.0 + Base.mesh_.point(vh0)) / 3.0);
                m.data_ptr(vh2).set_position(_target_state, zero_point);
                m.data_ptr(vh2).set_state(_target_state);
                m.data_ptr(vh2).set_not_finale();

                m.data_ptr(vh3).set_position(_target_state, m.data_ptr(vh3).position(_target_state - 1) * 3.0);
                m.data_ptr(vh3).set_state(_target_state);
                m.data_ptr(vh3).set_not_finale();

                // init 3 faces
                m.data_ptr(m.face_handle(hh1)).set_state(_target_state);
                m.data_ptr(m.face_handle(hh1)).set_not_finale();
                m.data_ptr(m.face_handle(hh1)).set_position(_target_state - 1, face_position);
      
                m.data_ptr(m.face_handle(hh2)).set_state(_target_state);
                m.data_ptr(m.face_handle(hh2)).set_not_finale();
                m.data_ptr(m.face_handle(hh2)).set_position(_target_state - 1, face_position);

                m.data_ptr(m.face_handle(hh3)).set_state(_target_state);
                m.data_ptr(m.face_handle(hh3)).set_finale();
                m.data_ptr(m.face_handle(hh3)).set_position(_target_state - 1, face_position);
      

                for (state_t j = 0; j < _target_state; ++j) {
                    m.data_ptr(m.face_handle(hh1)).set_position(j, m.data_ptr(_fh).position(j));
                }
      
                for (state_t j = 0; j < _target_state; ++j) {

                    m.data_ptr(m.face_handle(hh2)).set_position(j, m.data_ptr(_fh).position(j));
                }
      
                for (state_t j = 0; j < _target_state; ++j) {

                    m.data_ptr(m.face_handle(hh3)).set_position(j, m.data_ptr(_fh).position(j));
                }
      
                // check for edge flipping
                if (m.face_handle(m.opposite_halfedge_handle(hh1)).is_valid()) {

                    if (m.data_ptr(m.face_handle(m.opposite_halfedge_handle(hh1))).state() == _target_state) {

                        if (Base.mesh_.is_flip_ok(m.edge_handle(hh1))) {

                            edge_vector ~= (m.edge_handle(hh1));
                        }
                    }
                }

                if (m.face_handle(m.opposite_halfedge_handle(hh2)).is_valid()) {

                    if (m.data_ptr(m.face_handle(m.opposite_halfedge_handle(hh2))).state() == _target_state) {

                        if (Base.mesh_.is_flip_ok(m.edge_handle(hh2))) {

                            edge_vector ~= (m.edge_handle(hh2));
                        }
                    }
                }
            }
  
            // flip edges
            while (!edge_vector.empty()) {

                eh = edge_vector[$-1];
                edge_vector.pop_back();
      
                assert(Base.mesh_.is_flip_ok(eh));

                Base.mesh_.flip(eh);

                m.data_ptr(m.face_handle(m.halfedge_handle(eh, 0))).set_finale();
                m.data_ptr(m.face_handle(m.halfedge_handle(eh, 1))).set_finale();

                m.data_ptr(m.face_handle(m.halfedge_handle(eh, 0))).set_state(_target_state);
                m.data_ptr(m.face_handle(m.halfedge_handle(eh, 1))).set_state(_target_state);

                m.data_ptr(m.face_handle(m.halfedge_handle(eh, 0))).set_position(_target_state, face_position);
                m.data_ptr(m.face_handle(m.halfedge_handle(eh, 1))).set_position(_target_state, face_position);
            }
        }
    }
    void raise(M.VertexHandle _vh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_vh).state() < _target_state) {

            update(_vh, _target_state);

            // multiply old position by 3
            m.data_ptr(_vh).set_position(_target_state, m.data_ptr(_vh).position(_target_state - 1) * 3.0);

            m.data_ptr(_vh).inc_state();

            assert(m.data_ptr(_vh).state() == _target_state);
        }
    }
}


//=============================================================================


/** Topological composite rule Tvv,4 doing a 1-4 split of a face
 */
class Tvv4(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "Tvv4", "M" ) );

  private:
    alias RuleInterfaceT!(M)                 Base;
  public:
    alias M.HalfedgeHandle HEH;
    alias M.VertexHandle   VH;
   
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh);  super.set_subdiv_type(4); };

    void raise(M.FaceHandle   _fh, state_t _target_state)
    {
        alias mesh_ m;

        if (m.data_ptr(_fh).state() < _target_state) {

            update(_fh, _target_state);

            M.FaceVertexIter              fv_it;
            M.VertexHandle                temp_vh;
            M.Point                       face_position;
            /*const*/ M.Point                 zero_point=M.Point(0.0, 0.0, 0.0);
            M.VertexHandle[]   vertex_vector;
            M.HalfedgeHandle[] halfedge_vector;

            // raise all adjacent vertices to level x-1
            for (fv_it = Base.mesh_.fv_iter(_fh); fv_it.is_active; ++fv_it) {

                vertex_vector ~= (fv_it.handle());
            }

            while(!vertex_vector.empty()) {

                temp_vh = vertex_vector[$-1];
                vertex_vector.pop_back();

                if (_target_state > 1) {
                    Base.prev_rule().raise(temp_vh, _target_state - 1);
                }
            }

            face_position = m.data_ptr(_fh).position(_target_state - 1);

            M.HalfedgeHandle hh[3];
            M.VertexHandle   vh[3];
            M.VertexHandle   new_vh[3];
            M.FaceHandle     fh[4];
            M.EdgeHandle     eh;
            M.HalfedgeHandle temp_hh;

            // normal (finale) face
            if (m.data_ptr(_fh).finale()) {

                // define three halfedge handles around the face
                hh[0] = m.halfedge_handle(_fh);
                hh[1] = m.next_halfedge_handle(hh[0]);
                hh[2] = m.next_halfedge_handle(hh[1]);

                assert(hh[0] == m.next_halfedge_handle(hh[2]));

                vh[0] = m.to_vertex_handle(hh[0]);
                vh[1] = m.to_vertex_handle(hh[1]);
                vh[2] = m.to_vertex_handle(hh[2]);
      
                new_vh[0] = Base.mesh_.add_vertex(zero_point);
                new_vh[1] = Base.mesh_.add_vertex(zero_point);
                new_vh[2] = Base.mesh_.add_vertex(zero_point);

                // split three edges
                split_edge(hh[0], new_vh[0], _target_state);
                eh = m.edge_handle(m.prev_halfedge_handle(hh[2]));
                split_edge(hh[1], new_vh[1], _target_state);
                split_edge(hh[2], new_vh[2], _target_state);

                assert(m.from_vertex_handle(hh[2]) == vh[1]);
                assert(m.from_vertex_handle(hh[1]) == vh[0]);
                assert(m.from_vertex_handle(hh[0]) == vh[2]);

                if (m.face_handle(m.opposite_halfedge_handle(hh[0])).is_valid()) 
                {
                    temp_hh = m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(hh[0])));
                    if (m.data_ptr(m.face_handle(temp_hh)).red_halfedge() != temp_hh)
                        halfedge_vector ~= (temp_hh);
                }

                if (m.face_handle(m.opposite_halfedge_handle(hh[1])).is_valid()) {

                    temp_hh = m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(hh[1])));
                    if (m.data_ptr(m.face_handle(temp_hh)).red_halfedge() != temp_hh)
                        halfedge_vector ~= (temp_hh);
                }

                if (m.face_handle(m.opposite_halfedge_handle(hh[2])).is_valid()) {

                    temp_hh = m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(hh[2])));
                    if (m.data_ptr(m.face_handle(temp_hh)).red_halfedge() != temp_hh)
                        halfedge_vector ~= (temp_hh);
                }
            }
    
            // splitted face, check for type
            else {

                // define red halfedge handle
                M.HalfedgeHandle red_hh=(m.data_ptr(_fh).red_halfedge());

                if (m.face_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(red_hh))).is_valid() 
                    && m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh)))).is_valid() 
                    && m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(red_hh)))).red_halfedge() == red_hh 
                    && m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh))))).red_halfedge() == red_hh) 
                {

                    // three times divided face
                    vh[0] = m.to_vertex_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh)))));
                    vh[1] = m.to_vertex_handle(red_hh);
                    vh[2] = m.to_vertex_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(red_hh))));
          
                    new_vh[0] = m.from_vertex_handle(red_hh);
                    new_vh[1] = m.to_vertex_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh)));
                    new_vh[2] = m.to_vertex_handle(m.next_halfedge_handle(red_hh));
    
                    hh[0] = m.prev_halfedge_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(red_hh)));
                    hh[1] = m.prev_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh))));
                    hh[2] = m.next_halfedge_handle(red_hh);
    
                    eh = m.edge_handle(red_hh);
                }
      
                else 
                {

                    if ((m.face_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(red_hh))).is_valid() && 
                         m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(red_hh)))).red_halfedge() 
                         == red_hh )
                        || (m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh)))).is_valid() 
                            && m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh))))).red_halfedge() == red_hh))
                    {

                        // double divided face
                        if (m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(red_hh)))).red_halfedge() == red_hh) 
                        {
                            // first case
                            vh[0] = m.to_vertex_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh)));
                            vh[1] = m.to_vertex_handle(red_hh);
                            vh[2] = m.to_vertex_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(red_hh))));
      
                            new_vh[0] = m.from_vertex_handle(red_hh);
                            new_vh[1] = Base.mesh_.add_vertex(zero_point);
                            new_vh[2] = m.to_vertex_handle(m.next_halfedge_handle(red_hh));
  
                            hh[0] = m.prev_halfedge_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(red_hh)));
                            hh[1] = m.prev_halfedge_handle(m.opposite_halfedge_handle(red_hh));
                            hh[2] = m.next_halfedge_handle(red_hh);
  
                            // split one edge
                            eh = m.edge_handle(red_hh);
  
                            split_edge(hh[1], new_vh[1], _target_state);
  
                            assert(m.from_vertex_handle(hh[2]) == vh[1]);
                            assert(m.from_vertex_handle(hh[1]) == vh[0]);
                            assert(m.from_vertex_handle(hh[0]) == vh[2]);
        
                            if (m.face_handle(m.opposite_halfedge_handle(hh[1])).is_valid()) 
                            {
                                temp_hh = m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(hh[1])));
                                if (m.data_ptr(m.face_handle(temp_hh)).red_halfedge() != temp_hh)
                                    halfedge_vector ~= (temp_hh);
                            }
                        }
                        else 
                        {

                            // second case
                            vh[0] = m.to_vertex_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh)))));
                            vh[1] = m.to_vertex_handle(red_hh);
                            vh[2] = m.to_vertex_handle(m.next_halfedge_handle(red_hh));
      
                            new_vh[0] = m.from_vertex_handle(red_hh);
                            new_vh[1] = m.to_vertex_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh)));
                            new_vh[2] = Base.mesh_.add_vertex(zero_point);

                            hh[0] = m.prev_halfedge_handle(red_hh);
                            hh[1] = m.prev_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh))));
                            hh[2] = m.next_halfedge_handle(red_hh);

                            // split one edge
                            eh = m.edge_handle(red_hh);

                            split_edge(hh[2], new_vh[2], _target_state);

                            assert(m.from_vertex_handle(hh[2]) == vh[1]);
                            assert(m.from_vertex_handle(hh[1]) == vh[0]);
                            assert(m.from_vertex_handle(hh[0]) == vh[2]);

                            if (m.face_handle(m.opposite_halfedge_handle(hh[2])).is_valid()) {
	    
                                temp_hh = m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(hh[2])));
                                if (m.data_ptr(m.face_handle(temp_hh)).red_halfedge() != temp_hh)
                                    halfedge_vector ~= (temp_hh);
                            }
                        }
                    }

                    else {
	  
                        // one time divided face
                        vh[0] = m.to_vertex_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(red_hh)));
                        vh[1] = m.to_vertex_handle(red_hh);
                        vh[2] = m.to_vertex_handle(m.next_halfedge_handle(red_hh));
      
                        new_vh[0] = m.from_vertex_handle(red_hh);
                        new_vh[1] = Base.mesh_.add_vertex(zero_point);
                        new_vh[2] = Base.mesh_.add_vertex(zero_point);

                        hh[0] = m.prev_halfedge_handle(red_hh);
                        hh[1] = m.prev_halfedge_handle(m.opposite_halfedge_handle(red_hh));
                        hh[2] = m.next_halfedge_handle(red_hh);

                        // split two edges
                        eh = m.edge_handle(red_hh);

                        split_edge(hh[1], new_vh[1], _target_state);
                        split_edge(hh[2], new_vh[2], _target_state);

                        assert(m.from_vertex_handle(hh[2]) == vh[1]);
                        assert(m.from_vertex_handle(hh[1]) == vh[0]);
                        assert(m.from_vertex_handle(hh[0]) == vh[2]);

                        if (m.face_handle(m.opposite_halfedge_handle(hh[1])).is_valid()) {

                            temp_hh = m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(hh[1])));
                            if (m.data_ptr(m.face_handle(temp_hh)).red_halfedge() != temp_hh)
                                halfedge_vector ~= (temp_hh);
                        }

                        if (m.face_handle(m.opposite_halfedge_handle(hh[2])).is_valid()) {

                            temp_hh = m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(hh[2])));
                            if (m.data_ptr(m.face_handle(temp_hh)).red_halfedge() != temp_hh)
                                halfedge_vector ~= (temp_hh);
                        }
                    }
                }
            }

            // continue here for all cases
	
            // flip edge
            if (Base.mesh_.is_flip_ok(eh)) {
      
                Base.mesh_.flip(eh);
            }
    
            // search new faces
            fh[0] = m.face_handle(hh[0]);
            fh[1] = m.face_handle(hh[1]);
            fh[2] = m.face_handle(hh[2]);
            fh[3] = m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(hh[0])));

            assert(_fh == fh[0] || _fh == fh[1] || _fh == fh[2] || _fh == fh[3]); 

            // init new faces
            for (int i = 0; i <= 3; ++i) {

                m.data_ptr(fh[i]).set_state(_target_state);
                m.data_ptr(fh[i]).set_finale();
                m.data_ptr(fh[i]).set_position(_target_state, face_position);
                m.data_ptr(fh[i]).set_red_halfedge(Base.mesh_.InvalidHalfedgeHandle);
            }

            // init new vertices and edges
            for (int i = 0; i <= 2; ++i) {
	
                m.data_ptr(new_vh[i]).set_position(_target_state, zero_point);
                m.data_ptr(new_vh[i]).set_state(_target_state);
                m.data_ptr(new_vh[i]).set_not_finale();

                Base.mesh_.set_point(new_vh[i], (Base.mesh_.point(vh[i]) + Base.mesh_.point(vh[(i + 2) % 3])) * 0.5);

                m.data_ptr(m.edge_handle(hh[i])).set_state(_target_state);
                m.data_ptr(m.edge_handle(hh[i])).set_position(_target_state, zero_point);
                m.data_ptr(m.edge_handle(hh[i])).set_finale();

                m.data_ptr(m.edge_handle(m.next_halfedge_handle(hh[i]))).set_state(_target_state);
                m.data_ptr(m.edge_handle(m.next_halfedge_handle(hh[i]))).set_position(_target_state, zero_point);
                m.data_ptr(m.edge_handle(m.next_halfedge_handle(hh[i]))).set_finale();

                m.data_ptr(m.edge_handle(m.prev_halfedge_handle(hh[i]))).set_state(_target_state);
                m.data_ptr(m.edge_handle(m.prev_halfedge_handle(hh[i]))).set_position(_target_state, zero_point);
                m.data_ptr(m.edge_handle(m.prev_halfedge_handle(hh[i]))).set_finale();
            }

            // check, if opposite triangle needs splitting
            while (!halfedge_vector.empty()) {

                temp_hh = halfedge_vector[$-1];
                halfedge_vector.pop_back();

                check_edge(temp_hh, _target_state);
            }

            assert(m.data_ptr(fh[0]).state() == _target_state);
            assert(m.data_ptr(fh[1]).state() == _target_state);
            assert(m.data_ptr(fh[2]).state() == _target_state);
            assert(m.data_ptr(fh[3]).state() == _target_state);
        }
    }
    void raise(M.VertexHandle _vh, state_t _target_state)
    {
        alias mesh_ m;
 
        if (m.data_ptr(_vh).state() < _target_state)
        {

            update(_vh, _target_state);

            // multiply old position by 4
            m.data_ptr(_vh).set_position(_target_state, m.data_ptr(_vh).position(_target_state - 1) * 4.0);

            m.data_ptr(_vh).inc_state();
        }
    }
    void raise(M.EdgeHandle   _eh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_eh).state() < _target_state) 
        {
            update(_eh, _target_state);

            M.FaceHandle fh=(m.face_handle(m.halfedge_handle(_eh, 0)));

            if (!fh.is_valid())
                fh=m.face_handle(m.halfedge_handle(_eh, 1));

            raise(fh, _target_state);

            assert(m.data_ptr(_eh).state() == _target_state);
        }
    }

  private:

    void split_edge(ref HEH _hh, ref VH _vh, state_t _target_state)
    {
        alias mesh_ m;
        M.HalfedgeHandle temp_hh;

        if (m.face_handle(m.opposite_halfedge_handle(_hh)).is_valid()) 
        {
            if (!m.data_ptr(m.face_handle(m.opposite_halfedge_handle(_hh))).finale()) 
            {    
                if (m.data_ptr(m.face_handle(m.opposite_halfedge_handle(_hh))).red_halfedge().is_valid()) 
                {        
                    temp_hh = m.data_ptr(m.face_handle(m.opposite_halfedge_handle(_hh))).red_halfedge();
                }
                else 
                {
                    // two cases for divided, but not visited face
                    if (m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(_hh))))).state() 
                        == m.data_ptr(m.face_handle(m.opposite_halfedge_handle(_hh))).state()) 
                    {
                        temp_hh = m.prev_halfedge_handle(m.opposite_halfedge_handle(_hh));
                    }

                    else if (m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(_hh))))).state() 
                             == m.data_ptr(m.face_handle(m.opposite_halfedge_handle(_hh))).state())
                    {
                        temp_hh = m.next_halfedge_handle(m.opposite_halfedge_handle(_hh)); 
                    }
                }
            }
            else
                temp_hh = Base.mesh_.InvalidHalfedgeHandle;
        }
        else
            temp_hh = Base.mesh_.InvalidHalfedgeHandle;
	 
        // split edge
        Base.mesh_.split(m.edge_handle(_hh), _vh);
	  
        if (m.from_vertex_handle(_hh) == _vh) 
        {	    
            m.data_ptr(m.edge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(_hh))))).set_state(m.data_ptr(m.edge_handle(_hh)).state());
            _hh = m.prev_halfedge_handle(m.opposite_halfedge_handle(m.prev_halfedge_handle(_hh)));
        }

        if (m.face_handle(m.opposite_halfedge_handle(_hh)).is_valid()) {
	  
            m.data_ptr(m.edge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(_hh)))).set_not_finale();
            m.data_ptr(m.face_handle(m.opposite_halfedge_handle(_hh))).set_state(_target_state-1);
            m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(_hh)))))).set_state(_target_state-1);

            m.data_ptr(m.face_handle(m.opposite_halfedge_handle(_hh))).set_not_finale();
            m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(_hh)))))).set_not_finale();

            m.data_ptr(m.edge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(_hh)))).set_state(_target_state);

            if (temp_hh.is_valid()) {
	
                m.data_ptr(m.face_handle(m.opposite_halfedge_handle(_hh))).set_red_halfedge(temp_hh);
                m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(_hh)))))).set_red_halfedge(temp_hh);
            } 
            else {

                M.FaceHandle 
                    fh1=(m.face_handle(m.opposite_halfedge_handle(_hh))),
                    fh2=(m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(_hh))))));

                m.data_ptr(fh1).set_red_halfedge(m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(_hh))));
                m.data_ptr(fh2).set_red_halfedge(m.opposite_halfedge_handle(m.prev_halfedge_handle(m.opposite_halfedge_handle(_hh))));

                /*const*/ M.Point zero_point=M.Point(0.0, 0.0, 0.0);

                m.data_ptr(fh1).set_position(_target_state - 1, zero_point);
                m.data_ptr(fh2).set_position(_target_state - 1, zero_point);
            }
        }

        // init edges
        m.data_ptr(m.edge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(_hh))))).set_state(_target_state - 1);
        m.data_ptr(m.edge_handle(m.next_halfedge_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(_hh))))).set_finale();

        m.data_ptr(m.edge_handle(_hh)).set_state(_target_state - 1);
        m.data_ptr(m.edge_handle(_hh)).set_finale();
    }
    void check_edge(/*const*/ M.HalfedgeHandle _hh, 
                    state_t _target_state)
    {
        alias mesh_ m;
        M.FaceHandle fh1=(m.face_handle(_hh)),
            fh2=(m.face_handle(m.opposite_halfedge_handle(_hh)));

        assert(fh1.is_valid());
        assert(fh2.is_valid());

        M.HalfedgeHandle red_hh=(m.data_ptr(fh1).red_halfedge());
  
        if (!m.data_ptr(fh1).finale()) {

            assert (m.data_ptr(fh1).finale() == m.data_ptr(fh2).finale());
            assert (!m.data_ptr(fh1).finale());
            assert (m.data_ptr(fh1).red_halfedge() == m.data_ptr(fh2).red_halfedge());

            /*const*/ M.Point zero_point=M.Point(0.0, 0.0, 0.0);

            m.data_ptr(fh1).set_position(_target_state - 1, zero_point);
            m.data_ptr(fh2).set_position(_target_state - 1, zero_point);

            assert(red_hh.is_valid());

            if (!red_hh.is_valid()) {

                m.data_ptr(fh1).set_state(_target_state - 1);
                m.data_ptr(fh2).set_state(_target_state - 1);

                m.data_ptr(fh1).set_red_halfedge(_hh);
                m.data_ptr(fh2).set_red_halfedge(_hh);

                m.data_ptr(m.edge_handle(_hh)).set_not_finale();
                m.data_ptr(m.edge_handle(_hh)).set_state(_target_state - 1);
            }

            else {

                m.data_ptr(m.edge_handle(_hh)).set_not_finale();
                m.data_ptr(m.edge_handle(_hh)).set_state(_target_state - 1);

                raise(fh1, _target_state);

                assert(m.data_ptr(fh1).state() == _target_state);
            }
        }
    }
}


//=============================================================================


/** Composite rule VF
 */
class VF(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "VF", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.FaceHandle _fh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_fh).state() < _target_state) {

            update(_fh, _target_state);

            // raise all neighbour vertices to level x-1
            M.FaceVertexIter            fv_it;
            M.VertexHandle              vh;
            M.VertexHandle[] vertex_vector;

            if (_target_state > 1) {

                for (fv_it = Base.mesh_.fv_iter(_fh); fv_it.is_active; ++fv_it) {

                    vertex_vector ~= (fv_it.handle());
                }

                while (!vertex_vector.empty()) {

                    vh = vertex_vector[$-1];
                    vertex_vector.pop_back();

                    Base.prev_rule().raise(vh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);

            for (fv_it = Base.mesh_.fv_iter(_fh); fv_it.is_active; ++fv_it) {

                ++valence;
                position += Base.mesh_.data_ptr(fv_it.handle).position(_target_state - 1);
            }

            position /= valence;

            // boundary rule
            if (Base.number() == Base.subdiv_rule().number() + 1 && 
                Base.mesh_.is_boundary(_fh)                  && 
                !m.data_ptr(_fh).finale())
                position *= 0.5;

            m.data_ptr(_fh).set_position(_target_state, position);
            m.data_ptr(_fh).inc_state();

            assert(_target_state == m.data_ptr(_fh).state());
        }
    }
}


//=============================================================================


/** Composite rule FF
 */
class FF(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "FF", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.FaceHandle _fh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_fh).state() < _target_state) {

            update(_fh, _target_state);

            // raise all neighbour faces to level x-1
            M.FaceFaceIter              ff_it;
            M.FaceHandle                fh;
            M.FaceHandle[]   face_vector;

            if (_target_state > 1) {

                for (ff_it = Base.mesh_.ff_iter(_fh); ff_it.is_active; ++ff_it) {

                    face_vector ~= (ff_it.handle());
                }

                while (!face_vector.empty()) {

                    fh = face_vector[$-1];
                    face_vector.pop_back();

                    Base.prev_rule().raise(fh, _target_state - 1);
                }

                for (ff_it = Base.mesh_.ff_iter(_fh); ff_it.is_active; ++ff_it) {

                    face_vector ~= (ff_it.handle());
                }

                while (!face_vector.empty()) {

                    fh = face_vector[$-1];
                    face_vector.pop_back();

                    while (m.data_ptr(fh).state() < _target_state - 1)
                        Base.prev_rule().raise(fh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);

            for (ff_it = Base.mesh_.ff_iter(_fh); ff_it.is_active; ++ff_it) {

                ++valence;

                position += Base.mesh_.data_ptr(ff_it.handle).position(_target_state - 1);
            }

            position /= valence;

            m.data_ptr(_fh).set_position(_target_state, position);
            m.data_ptr(_fh).inc_state();
        }
    }
}


//=============================================================================


/** Composite rule FFc
 */
class FFc(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "FFc", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.FaceHandle _fh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_fh).state() < _target_state) {

            update(_fh, _target_state);

            // raise all neighbour faces to level x-1
            M.FaceFaceIter              ff_it=(Base.mesh_.ff_iter(_fh));
            M.FaceHandle                fh;
            M.FaceHandle[]   face_vector;

            if (_target_state > 1) 
            {
                for (; ff_it.is_active; ++ff_it) 
                    face_vector ~= (ff_it.handle());

                while (!face_vector.empty()) 
                {
                    fh = face_vector[$-1];
                    face_vector.pop_back();
                    Base.prev_rule().raise(fh, _target_state - 1);
                }

                for (ff_it = Base.mesh_.ff_iter(_fh); ff_it.is_active; ++ff_it) 
                    face_vector ~= (ff_it.handle());

                while (!face_vector.empty()) {

                    fh = face_vector[$-1];
                    face_vector.pop_back();

                    while (m.data_ptr(fh).state() < _target_state - 1)
                        Base.prev_rule().raise(fh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);

            for (ff_it = Base.mesh_.ff_iter(_fh); ff_it.is_active; ++ff_it) 
            {
                ++valence;
                position += Base.mesh_.data_ptr(ff_it.handle).position(_target_state - 1);
            }

            position /= valence;

            // choose coefficient c
            M.Scalar c = Base.coeff();

            position *= (1.0 - c);
            position += m.data_ptr(_fh).position(_target_state - 1) * c;

            m.data_ptr(_fh).set_position(_target_state, position);
            m.data_ptr(_fh).inc_state();
        }
    }
}


//=============================================================================


/** Composite rule FV
 */
class FV(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "FV", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.VertexHandle _vh, state_t _target_state)
    {
        alias mesh_ m;

        if (m.data_ptr(_vh).state() < _target_state) {

            update(_vh, _target_state);

            // raise all neighbour vertices to level x-1
            M.VertexFaceIter            vf_it=(Base.mesh_.vf_iter(_vh));
            M.FaceHandle                fh;
            M.FaceHandle[]   face_vector;

            if (_target_state > 1) {

                for (; vf_it.is_active; ++vf_it) {

                    face_vector ~= (vf_it.handle());
                }

                while (!face_vector.empty()) {

                    fh = face_vector[$-1];
                    face_vector.pop_back();

                    Base.prev_rule().raise(fh, _target_state - 1);
                }

                for (vf_it = Base.mesh_.vf_iter(_vh); vf_it.is_active; ++vf_it) {

                    face_vector ~= (vf_it.handle());
                }

                while (!face_vector.empty()) {

                    fh = face_vector[$-1];
                    face_vector.pop_back();

                    while (m.data_ptr(fh).state() < _target_state - 1)
                        Base.prev_rule().raise(fh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);

            for (vf_it = Base.mesh_.vf_iter(_vh); vf_it.is_active; ++vf_it) {

                ++valence;
                position += Base.mesh_.data_ptr(vf_it.handle).position(_target_state - 1);
            }

            position /= valence;

            m.data_ptr(_vh).set_position(_target_state, position);
            m.data_ptr(_vh).inc_state();

            if (Base.number() == Base.n_rules() - 1) {

                Base.mesh_.set_point(_vh, position);
                m.data_ptr(_vh).set_finale();
            }
        }
    }
}


//=============================================================================


/** Composite rule FVc
 */
class FVc(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "FVc", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh);  init_coeffs(50); }

    void raise(M.VertexHandle _vh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_vh).state() < _target_state) {

            update(_vh, _target_state);

            M.VertexOHalfedgeIter       voh_it;
            M.FaceHandle                fh;
            M.FaceHandle[]    face_vector;
            int                         valence=(0);

            face_vector.length = 0;

            // raise all neighbour faces to level x-1
            if (_target_state > 1) {

                for (voh_it = Base.mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) {

                    if (m.face_handle(voh_it.handle()).is_valid()) {

                        face_vector ~= (m.face_handle(voh_it.handle()));

                        if (m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle()))).is_valid()) {

                            face_vector ~= (m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle()))));
                        }
                    }
                }

                while (!face_vector.empty()) {

                    fh = face_vector[$-1];
                    face_vector.pop_back();

                    Base.prev_rule().raise(fh, _target_state - 1);
                }

                for (voh_it = Base.mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) {

                    if (m.face_handle(voh_it.handle()).is_valid()) {

                        face_vector ~= (m.face_handle(voh_it.handle()));

                        if (m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle()))).is_valid()) {

                            face_vector ~= (m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle()))));
                        }
                    }
                }

                while (!face_vector.empty()) {

                    fh = face_vector[$-1];
                    face_vector.pop_back();

                    while (m.data_ptr(fh).state() < _target_state - 1)
                        Base.prev_rule().raise(fh, _target_state - 1);
                }

                for (voh_it = Base.mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) {

                    if (m.face_handle(voh_it.handle()).is_valid()) {

                        face_vector ~= (m.face_handle(voh_it.handle()));

                        if (m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle()))).is_valid()) {

                            face_vector ~= (m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle()))));
                        }
                    }
                }

                while (!face_vector.empty()) {

                    fh = face_vector[$-1];
                    face_vector.pop_back();

                    while (m.data_ptr(fh).state() < _target_state - 1)
                        Base.prev_rule().raise(fh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point               position=M.Point(0.0, 0.0, 0.0);
            M.Scalar              c;
            version(none) {
            /*const*/ M.Scalar        _2pi=(2.0*math.PI);
            /*const*/ M.Scalar        _2over3=(2.0/3.0);

            for (voh_it = Base.mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) 
            {     
                ++valence;
            }

            // choose coefficient c
            c = _2over3 * ( math.cos( _2pi / valence) + 1.0);
            }else {
            valence = Base.mesh_.valence=(_vh);
            c       = coeff(valence);
            }


            for (voh_it = Base.mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) {

                fh = m.face_handle(voh_it.handle());
                if (fh.is_valid())
                    Base.prev_rule().raise(fh, _target_state - 1);

                fh = m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle())));
                if (fh.is_valid())
                    Base.prev_rule().raise(fh, _target_state - 1);

                if (m.face_handle(voh_it.handle()).is_valid()) {

                    if (m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle()))).is_valid()) {

                        position += m.data_ptr(m.face_handle(voh_it.handle())).position(_target_state - 1) * c;

                        position += m.data_ptr(m.face_handle(m.opposite_halfedge_handle(m.next_halfedge_handle(voh_it.handle())))).position(_target_state - 1) * (1.0 - c);
                    }
                    else {

                        position += m.data_ptr(m.face_handle(voh_it.handle())).position(_target_state - 1);
                    }
                }

                else {

                    --valence;
                }
            } 
    
            position /= valence;

            m.data_ptr(_vh).set_position(_target_state, position);
            m.data_ptr(_vh).inc_state();

            assert(m.data_ptr(_vh).state() == _target_state);
    
            // check if last rule
            if (Base.number() == Base.n_rules() - 1) {

                Base.mesh_.set_point(_vh, position);
                m.data_ptr(_vh).set_finale();
            }
        }
    }

    static void init_coeffs(size_t _max_valence)
    {
        if ( coeffs_.length == _max_valence+1 )
            return;

        if ( coeffs_.length < _max_valence+1 )
        {
            /*const*/ double _2pi=(2.0*math.PI);
            /*const*/ double _2over3=(2.0/3.0);

            if (coeffs_.empty())
                coeffs_ ~= (0.0); // dummy for valence 0
      
            for(size_t v=coeffs_.length; v <= _max_valence; ++v)
                coeffs_ ~= (_2over3 * ( math.cos( _2pi / v) + 1.0));    
        }
    }
    static /*const*/ double[] coeffs() { return coeffs_; }

    double coeff( size_t _valence )
    {
        assert(_valence < coeffs_.length);
        return coeffs_[_valence];
    }

  private:

    static double[] coeffs_;

}


//=============================================================================


/** Composite rule VV
 */
class VV(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "VV", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:

    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.VertexHandle _vh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_vh).state() < _target_state) 
        {
            update(_vh, _target_state);

            // raise all neighbour vertices to level x-1
            M.VertexVertexIter              vv_it=(Base.mesh_.vv_iter(_vh));
            M.VertexHandle                  vh;
            M.VertexHandle[]     vertex_vector;

            if (_target_state > 1) {

                for (; vv_it.is_active; ++vv_it) {

                    vertex_vector ~= (vv_it.handle());
                }

                while (!vertex_vector.empty()) {

                    vh = vertex_vector[$-1];
                    vertex_vector.pop_back();

                    Base.prev_rule().raise(vh, _target_state - 1);
                }

                for (; vv_it.is_active; ++vv_it) {

                    vertex_vector ~= (vv_it.handle());
                }

                while (!vertex_vector.empty()) {

                    vh = vertex_vector[$-1];
                    vertex_vector.pop_back();

                    Base.prev_rule().raise(vh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);

            for (vv_it = Base.mesh_.vv_iter(_vh); vv_it.is_active; ++vv_it) {

                ++valence;

                position += Base.mesh_.data_ptr(vv_it.handle).position(_target_state - 1);
            }

            position /= valence;

            m.data_ptr(_vh).set_position(_target_state, position);
            m.data_ptr(_vh).inc_state();

            // check if last rule
            if (Base.number() == Base.n_rules() - 1) {

                Base.mesh_.set_point(_vh, position);
                m.data_ptr(_vh).set_finale();
            }
        }
    }
}


//=============================================================================


/** Composite rule VVc
 */
class VVc(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "VVc", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.VertexHandle _vh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_vh).state() < _target_state) {

            update(_vh, _target_state);

            // raise all neighbour vertices to level x-1
            M.VertexVertexIter              vv_it=(Base.mesh_.vv_iter(_vh));
            M.VertexHandle                  vh;
            M.VertexHandle[]     vertex_vector;

            if (_target_state > 1) {

                for (; vv_it.is_active; ++vv_it) {

                    vertex_vector ~= (vv_it.handle());
                }

                while (!vertex_vector.empty()) {

                    vh = vertex_vector[$-1];
                    vertex_vector.pop_back();

                    Base.prev_rule().raise(vh, _target_state - 1);
                }

                for (; vv_it.is_active; ++vv_it) {

                    vertex_vector ~= (vv_it.handle());
                }

                while (!vertex_vector.empty()) {

                    vh = vertex_vector[$-1];
                    vertex_vector.pop_back();

                    Base.prev_rule().raise(vh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);
            M.Scalar c;

            for (vv_it = Base.mesh_.vv_iter(_vh); vv_it.is_active; ++vv_it) 
            {
                ++valence;
                position += Base.mesh_.data_ptr(vv_it.handle).position(_target_state - 1);
            }

            position /= valence;

            // choose coefficcient c
            c = Base.coeff();

            position *= (1.0 - c);
            position += m.data_ptr(_vh).position(_target_state - 1) * c;

            m.data_ptr(_vh).set_position(_target_state, position);
            m.data_ptr(_vh).inc_state();

            if (Base.number() == Base.n_rules() - 1) 
            {
                Base.mesh_.set_point(_vh, position);
                m.data_ptr(_vh).set_finale();
            }
        }
    }
}


//=============================================================================


/** Composite rule VE
 */
class VE(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "VE", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.EdgeHandle _eh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_eh).state() < _target_state) {

            update(_eh, _target_state);

            // raise all neighbour vertices to level x-1
            M.VertexHandle          vh;
            M.HalfedgeHandle        hh1=(m.halfedge_handle(_eh, 0)),
                hh2=(m.halfedge_handle(_eh, 1));

            if (_target_state > 1) {

                vh = m.to_vertex_handle(hh1);
      
                Base.prev_rule().raise(vh, _target_state - 1);

                vh = m.to_vertex_handle(hh2);
      
                Base.prev_rule().raise(vh, _target_state - 1);
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);

            valence = 2;
            position += m.data_ptr(m.to_vertex_handle(hh1)).position(_target_state - 1);
            position += m.data_ptr(m.to_vertex_handle(hh2)).position(_target_state - 1);

            position /= valence;

            m.data_ptr(_eh).set_position(_target_state, position);
            m.data_ptr(_eh).inc_state();
        }
    }
}


//=============================================================================


/** Composite rule VdE
 */
class VdE(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "VdE", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.EdgeHandle _eh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_eh).state() < _target_state) 
        {
            update(_eh, _target_state);

            // raise all neighbour vertices to level x-1
            M.VertexHandle             vh;
            M.HalfedgeHandle           hh1=(m.halfedge_handle(_eh, 0)),
                hh2=(m.halfedge_handle(_eh, 1));
            M.VertexHandle[] vertex_vector;
            M.FaceHandle                fh1, fh2;

            if (_target_state > 1) {

                fh1 = m.face_handle(hh1);
                fh2 = m.face_handle(hh2);

                if (fh1.is_valid()) {

                    Base.prev_rule().raise(fh1, _target_state - 1);

                    vh = m.to_vertex_handle(m.next_halfedge_handle(hh1));
                    Base.prev_rule().raise(vh, _target_state - 1);
                }
			   
                if (fh2.is_valid()) {

                    Base.prev_rule().raise(fh2, _target_state - 1);

                    vh = m.to_vertex_handle(m.next_halfedge_handle(hh2));
                    Base.prev_rule().raise(vh, _target_state - 1);
                }
			   
                vh = m.to_vertex_handle(hh1);
                Base.prev_rule().raise(vh, _target_state - 1);

                vh = m.to_vertex_handle(hh2);
                Base.prev_rule().raise(vh, _target_state - 1);
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);

            valence = 2;
            position += m.data_ptr(m.to_vertex_handle(hh1)).position(_target_state - 1);
            position += m.data_ptr(m.to_vertex_handle(hh2)).position(_target_state - 1);

            if (fh1.is_valid()) {

                position += m.data_ptr(m.to_vertex_handle(m.next_halfedge_handle(hh1))).position(_target_state - 1);
                ++valence;
            }

            if (fh2.is_valid()) {
      
                position += m.data_ptr(m.to_vertex_handle(m.next_halfedge_handle(hh2))).position(_target_state - 1);
                ++valence;
            }

            if (super.number() == super.subdiv_rule().number() + 1) 
                valence = 4;

            position /= valence;

            m.data_ptr(_eh).set_position(_target_state, position);
            m.data_ptr(_eh).inc_state();
        }
    }
}


//=============================================================================


/** Composite rule VdEc
 */
class VdEc(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "VdEc", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.EdgeHandle _eh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_eh).state() < _target_state) 
        {
            update(_eh, _target_state);

            // raise all neighbour vertices to level x-1
            M.VertexHandle             vh;
            M.HalfedgeHandle           hh1=(m.halfedge_handle(_eh, 0)),
                hh2=(m.halfedge_handle(_eh, 1));
            M.VertexHandle[] vertex_vector;
            M.FaceHandle                fh1, fh2;

            if (_target_state > 1) {

                fh1 = m.face_handle(m.halfedge_handle(_eh, 0));
                fh2 = m.face_handle(m.halfedge_handle(_eh, 1));

                Base.prev_rule().raise(fh1, _target_state - 1);
                Base.prev_rule().raise(fh2, _target_state - 1);

                vertex_vector ~= (m.to_vertex_handle(hh1));
                vertex_vector ~= (m.to_vertex_handle(hh2));

                vertex_vector ~= (m.to_vertex_handle(m.next_halfedge_handle(hh1)));
                vertex_vector ~= (m.to_vertex_handle(m.next_halfedge_handle(hh2)));

                while (!vertex_vector.empty()) {

                    vh = vertex_vector[$-1];
                    vertex_vector.pop_back();

                    Base.prev_rule().raise(vh, _target_state - 1);
                }

                vertex_vector ~= (m.to_vertex_handle(hh1));
                vertex_vector ~= (m.to_vertex_handle(hh2));

                vertex_vector ~= (m.to_vertex_handle(m.next_halfedge_handle(hh1)));
                vertex_vector ~= (m.to_vertex_handle(m.next_halfedge_handle(hh2)));

                while (!vertex_vector.empty()) {

                    vh = vertex_vector[$-1];
                    vertex_vector.pop_back();

                    Base.prev_rule().raise(vh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);
            M.Scalar c;

            // choose coefficient c
            c = Base.coeff();

            valence = 4;
            position += m.data_ptr(m.to_vertex_handle(hh1)).position(_target_state - 1) * c;
            position += m.data_ptr(m.to_vertex_handle(hh2)).position(_target_state - 1) * c;
            position += m.data_ptr(m.to_vertex_handle(m.next_halfedge_handle(hh1))).position(_target_state - 1) * (0.5 - c);
            position += m.data_ptr(m.to_vertex_handle(m.next_halfedge_handle(hh2))).position(_target_state - 1) * (0.5 - c);

            position /= valence;

            m.data_ptr(_eh).set_position(_target_state, position);
            m.data_ptr(_eh).inc_state();
        }
    }
}


//=============================================================================


/** Composite rule EV
 */
class EV(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "EV", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.VertexHandle _vh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_vh).state() < _target_state) {

            update(_vh, _target_state);

            // raise all neighbour vertices to level x-1
            M.VertexEdgeIter            ve_it=(Base.mesh_.ve_iter(_vh));
            M.EdgeHandle                eh;
            M.EdgeHandle[]   edge_vector;

            if (_target_state > 1) {

                for (; ve_it.is_active; ++ve_it) {

                    edge_vector ~= (ve_it.handle());
                }

                while (!edge_vector.empty()) {

                    eh = edge_vector[$-1];
                    edge_vector.pop_back();

                    Base.prev_rule().raise(eh, _target_state - 1);
                }

                for (ve_it = Base.mesh_.ve_iter(_vh); ve_it.is_active; ++ve_it) {

                    edge_vector ~= (ve_it.handle());
                }

                while (!edge_vector.empty()) {

                    eh = edge_vector[$-1];
                    edge_vector.pop_back();

                    while (m.data_ptr(eh).state() < _target_state - 1)
                        Base.prev_rule().raise(eh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);

            for (ve_it = Base.mesh_.ve_iter(_vh); ve_it.is_active; ++ve_it) {

                if (Base.mesh_.data_ptr(ve_it.handle).finale()) {

                    ++valence;

                    position += Base.mesh_.data_ptr(ve_it.handle).position(_target_state - 1);
                }
            }

            position /= valence;

            m.data_ptr(_vh).set_position(_target_state, position);
            m.data_ptr(_vh).inc_state();

            // check if last rule
            if (Base.number() == Base.n_rules() - 1) {

                Base.mesh_.set_point(_vh, position);
                m.data_ptr(_vh).set_finale();
            }
        }
    }
}


//=============================================================================


/** Composite rule EVc
 */
class EVc(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "EVc", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:

    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh);  init_coeffs(50); }

    void raise(M.VertexHandle _vh, state_t _target_state)
    {
        alias mesh_ m;
        if (m.data_ptr(_vh).state() < _target_state) 
        {
            update(_vh, _target_state);

            // raise all neighbour vertices to level x-1
            M.VertexOHalfedgeIter       voh_it;
            M.EdgeHandle                eh;
            M.FaceHandle                fh;
            M.EdgeHandle[]   edge_vector;
            M.FaceHandle[]   face_vector;

            if (_target_state > 1) {

                for (voh_it = Base.mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) {

                    face_vector ~= (m.face_handle(voh_it.handle()));
                }

                while (!face_vector.empty()) {

                    fh = face_vector[$-1];
                    face_vector.pop_back();

                    if (fh.is_valid())
                        Base.prev_rule().raise(fh, _target_state - 1);
                }

                for (voh_it = Base.mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) {

                    edge_vector ~= (m.edge_handle(voh_it.handle()));

                    edge_vector ~= (m.edge_handle(m.next_halfedge_handle(voh_it.handle())));
                }

                while (!edge_vector.empty()) {

                    eh = edge_vector[$-1];
                    edge_vector.pop_back();

                    while (m.data_ptr(eh).state() < _target_state - 1)
                        Base.prev_rule().raise(eh, _target_state - 1);
                }
            }


            // calculate new position
            M.Point        position=M.Point(0.0, 0.0, 0.0);
            M.Scalar       c;
            M.Point        zero_point=M.Point(0.0, 0.0, 0.0);
            int                         valence=(0);

            valence = Base.mesh_.valence(_vh);
            c       = coeff( valence );

            for (voh_it = Base.mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) 
            {
                if (m.data_ptr(m.edge_handle(voh_it.handle())).finale()) 
                {
                    position += m.data_ptr(m.edge_handle(voh_it.handle())).position(_target_state-1)*c;

                    if ( m.face_handle(voh_it.handle()).is_valid() && 
                         m.data_ptr(m.edge_handle(m.next_halfedge_handle(voh_it.handle()))).finale() && 
                         m.data_ptr(m.edge_handle(m.next_halfedge_handle(voh_it.handle()))).position(_target_state - 1) != zero_point) 
                    {
                        position += m.data_ptr(m.edge_handle(m.next_halfedge_handle(voh_it.handle()))).position(_target_state-1) * (1.0-c);
                    }
                    else {
                        position += m.data_ptr(m.edge_handle(voh_it.handle())).position(_target_state - 1) * (1.0 - c);
                    }
                }
                else {
                    --valence;
                }
            }

            position /= valence;

            m.data_ptr(_vh).set_position(_target_state, position);
            m.data_ptr(_vh).inc_state();

            // check if last rule
            if (Base.number() == Base.n_rules() - 1) {

                Base.mesh_.set_point(_vh, position);
                m.data_ptr(_vh).set_finale();
            }
        }
    }

    static void init_coeffs(size_t _max_valence)
    {
        if ( coeffs_.length == _max_valence+1 ) // equal? do nothing
            return;

        if (coeffs_.length < _max_valence+1) // less than? add additional valences
        {
            /*const*/ double _2pi = 2.0*math.PI;
            double c;
  
            if (coeffs_.empty())
                coeffs_ ~= (0.0); // dummy for invalid valences 0,1,2

            for(size_t v=coeffs_.length; v <= _max_valence; ++v)
            {
                // ( 3/2 + cos ( 2 PI / valence ) )² / 2 - 1
                c = 1.5 + math.cos( _2pi / v );
                c = c * c * 0.5 - 1.0;
                coeffs_ ~= (c);
            }
        }
    }
    static /*const*/ double[] coeffs() { return coeffs_; }

    double coeff( size_t _valence )
    {
        assert(_valence < coeffs_.length);
        return coeffs_[_valence];
    }

  private:

    static double[] coeffs_;
  
}


//=============================================================================


/** Composite rule EF
 */
class EF(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "EF", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.FaceHandle _fh, state_t _target_state)
    {
        alias mesh_ m;

        if (m.data_ptr(_fh).state() < _target_state) {

            update(_fh, _target_state);

            // raise all neighbour edges to level x-1
            M.FaceEdgeIter              fe_it=(Base.mesh_.fe_iter(_fh));
            M.EdgeHandle                eh;
            M.EdgeHandle[]   edge_vector;

            if (_target_state > 1) {

                for (; fe_it.is_active; ++fe_it) {

                    edge_vector ~= (fe_it.handle());
                }

                while (!edge_vector.empty()) {

                    eh = edge_vector[$-1];
                    edge_vector.pop_back();

                    Base.prev_rule().raise(eh, _target_state - 1);
                }

                for (fe_it = Base.mesh_.fe_iter(_fh); fe_it.is_active; ++fe_it) {

                    edge_vector ~= (fe_it.handle());
                }

                while (!edge_vector.empty()) {

                    eh = edge_vector[$-1];
                    edge_vector.pop_back();

                    while (m.data_ptr(eh).state() < _target_state - 1)
                        Base.prev_rule().raise(eh, _target_state - 1);
                }
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(0);

            for (fe_it = Base.mesh_.fe_iter(_fh); fe_it.is_active; ++fe_it) {

                if (Base.mesh_.data_ptr(fe_it.handle).finale()) {

                    ++valence;

                    position += Base.mesh_.data_ptr(fe_it.handle).position(_target_state - 1);
                }
            }

            assert (valence == 3);

            position /= valence;

            m.data_ptr(_fh).set_position(_target_state, position);
            m.data_ptr(_fh).inc_state();
        }
    }
}


//=============================================================================


/** Composite rule FE
 */
class FE(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "FE", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.EdgeHandle _eh, state_t _target_state)
    {
        alias mesh_ m;

        if (m.data_ptr(_eh).state() < _target_state) {

            update(_eh, _target_state);

            // raise all neighbour faces to level x-1
            M.FaceHandle                fh;

            if (_target_state > 1) {

                fh = m.face_handle(m.halfedge_handle(_eh, 0));
                Base.prev_rule().raise(fh, _target_state - 1);

                fh = m.face_handle(m.halfedge_handle(_eh, 1));
                Base.prev_rule().raise(fh, _target_state - 1);

                fh = m.face_handle(m.halfedge_handle(_eh, 0));
                Base.prev_rule().raise(fh, _target_state - 1);

                fh = m.face_handle(m.halfedge_handle(_eh, 1));
                Base.prev_rule().raise(fh, _target_state - 1);
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(2);

            position += m.data_ptr(m.face_handle(m.halfedge_handle(_eh, 0))).position(_target_state - 1);
    
            position += m.data_ptr(m.face_handle(m.halfedge_handle(_eh, 1))).position(_target_state - 1);
    
            position /= valence;

            m.data_ptr(_eh).set_position(_target_state, position);
            m.data_ptr(_eh).inc_state();
        }
    }
}


//=============================================================================


/** Composite rule EdE
 */
class EdE(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "EdE", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.EdgeHandle _eh, state_t _target_state)
    {
        alias mesh_ m;


        if (m.data_ptr(_eh).state() < _target_state) {

            update(_eh, _target_state);

            // raise all neighbour faces and edges to level x-1
            M.HalfedgeHandle            hh1, hh2;
            M.FaceHandle                fh;
            M.EdgeHandle                eh;

            hh1 = m.halfedge_handle(_eh, 0);
            hh2 = m.halfedge_handle(_eh, 1);

            if (_target_state > 1) {

                fh = m.face_handle(hh1);
                Base.prev_rule().raise(fh, _target_state - 1);

                fh = m.face_handle(hh2);
                Base.prev_rule().raise(fh, _target_state - 1);

                eh = m.edge_handle(m.next_halfedge_handle(hh1));
                Base.prev_rule().raise(eh, _target_state - 1);

                eh = m.edge_handle(m.prev_halfedge_handle(hh1));
                Base.prev_rule().raise(eh, _target_state - 1);

                eh = m.edge_handle(m.next_halfedge_handle(hh2));
                Base.prev_rule().raise(eh, _target_state - 1);

                eh = m.edge_handle(m.prev_halfedge_handle(hh2));
                Base.prev_rule().raise(eh, _target_state - 1);
            }

            // calculate new position
            M.Point position=M.Point(0.0, 0.0, 0.0);
            int                  valence=(4);

            position += m.data_ptr(m.edge_handle(m.next_halfedge_handle(hh1))).position(_target_state - 1);
            position += m.data_ptr(m.edge_handle(m.prev_halfedge_handle(hh1))).position(_target_state - 1);
            position += m.data_ptr(m.edge_handle(m.next_halfedge_handle(hh2))).position(_target_state - 1);
            position += m.data_ptr(m.edge_handle(m.prev_halfedge_handle(hh2))).position(_target_state - 1);

            position /= valence;

            m.data_ptr(_eh).set_position(_target_state, position);
            m.data_ptr(_eh).inc_state();
        }
    }
}


//=============================================================================


/** Composite rule EdEc
 */
class EdEc(M) : RuleInterfaceT!(M)
{
    mixin( COMPOSITE_RULE( "EdEc", "M" ) );
  private:
    alias RuleInterfaceT!(M)                 Base;

  public:
    alias RuleInterfaceT!(M) Inherited;

    this(M _mesh) { super(_mesh); }

    void raise(M.EdgeHandle _eh, state_t _target_state)
    {
        alias mesh_ m;

        if (m.data_ptr(_eh).state() < _target_state) {

            update(_eh, _target_state);

            // raise all neighbour faces and edges to level x-1
            M.HalfedgeHandle            hh1, hh2;
            M.FaceHandle                fh;
            M.EdgeHandle                eh;

            hh1 = m.halfedge_handle(_eh, 0);
            hh2 = m.halfedge_handle(_eh, 1);

            if (_target_state > 1) {

                fh = m.face_handle(hh1);
                Base.prev_rule().raise(fh, _target_state - 1);

                fh = m.face_handle(hh2);
                Base.prev_rule().raise(fh, _target_state - 1);

                eh = m.edge_handle(m.next_halfedge_handle(hh1));
                Base.prev_rule().raise(eh, _target_state - 1);

                eh = m.edge_handle(m.prev_halfedge_handle(hh1));
                Base.prev_rule().raise(eh, _target_state - 1);

                eh = m.edge_handle(m.next_halfedge_handle(hh2));
                Base.prev_rule().raise(eh, _target_state - 1);

                eh = m.edge_handle(m.prev_halfedge_handle(hh2));
                Base.prev_rule().raise(eh, _target_state - 1);
            }

            // calculate new position
            M.Point  position=M.Point(0.0, 0.0, 0.0);
            int                valence=(4);
            M.Scalar c;

            position += m.data_ptr(m.edge_handle(m.next_halfedge_handle(hh1))).position(_target_state - 1);
            position += m.data_ptr(m.edge_handle(m.prev_halfedge_handle(hh1))).position(_target_state - 1);
            position += m.data_ptr(m.edge_handle(m.next_halfedge_handle(hh2))).position(_target_state - 1);
            position += m.data_ptr(m.edge_handle(m.prev_halfedge_handle(hh2))).position(_target_state - 1);

            position /= valence;

            // choose coefficient c
            c = Base.coeff();

            position *= (1.0 - c);

            position += m.data_ptr(_eh).position(_target_state - 1) * c;

            m.data_ptr(_eh).set_position(_target_state, position);
            m.data_ptr(_eh).inc_state();
        }
    }
}

// ----------------------------------------------------------------------------



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
