//============================================================================
// RuleInterfaceT.d - 
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

module auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.RuleInterfaceT;

//=============================================================================
//
//  CLASS RuleInterfaceT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.CompositeTraits;
import auxd.OpenMesh.Core.Mesh.Handles;

//== CLASS DEFINITION =========================================================


// ----------------------------------------------------------------------------

/** Handle template for adaptive composite subdividion rules
 *  \internal
 * 
 *  Use typed handle of a rule, e.g. Tvv3<MyMesh>.Handle.
 */
struct RuleHandleT(R) //: BaseHandle
{
    static RuleHandleT opCall(int _idx=-1) {
        RuleHandleT M; with(M) {
            idx_ = _idx;
        } return M;
    }
    alias R Rule;

    mixin HandleMixin!();
    //bool opImplicitCast() /*const*/ { return is_valid(); }

}

/** Defines the method type() (RuleInterfaceT.type()) and the
 *  aliass Self and Handle.
 *  Usage is   mixin( COMPOSITE_RULE("MyClass", "MyMeshT") );
 */
string COMPOSITE_RULE( string classname, string mesh_type )
{
    string code = 
        "protected:\n"
        "  //friend class CompositeT!("~mesh_type~");\n"
        "public:\n"
        "  /*const*/ string type() /*const*/ { return \""~classname~"\"; }\n"
        "  alias "~classname~"!("~mesh_type~")     Self;\n"
        "  alias RuleHandleT!( Self )      Handle;\n";
    return code;
}

private {
    void pop_back(T)(ref T[] array) {
        array.length = array.length -1;
    }
    bool empty(T)(T[] array) {
        return array.length != 0;
    }
}


// ----------------------------------------------------------------------------
/** Base class for adaptive composite subdivision rules
 *  See_Also: class CompositeT
 */
class RuleInterfaceT(M)
{
public:

    alias M                   Mesh;
    alias RuleInterfaceT!(M)   Self;
    alias RuleHandleT!( Self ) Rule;

    alias M.Scalar  scalar_t;

protected:

    /// Default constructor
    this(Mesh _mesh) { mesh_ = _mesh; };

public:


    /// Returns the name of the rule.
    /// Use define COMPOSITE_RULE to overload this function in a derived class.
    abstract /*const*/ string type() /*const*/;

public:

    /// \name Raise item
    //@{
    /// Raise item to target state \c _target_state.
    void raise(M.FaceHandle _fh, state_t _target_state) 
    {
        if (mesh_.data_ptr(_fh).state() < _target_state) {
            update(_fh, _target_state);
            mesh_.data_ptr(_fh).inc_state();
        }
    }

    void raise(M.EdgeHandle _eh, state_t _target_state) 
    {
        if (mesh_.data_ptr(_eh).state() < _target_state) {
            update(_eh, _target_state);
            mesh_.data_ptr(_eh).inc_state();
        }
    }

    void raise(M.VertexHandle _vh, state_t _target_state) 
    {
        if (mesh_.data_ptr(_vh).state() < _target_state) {
            update(_vh, _target_state);
            mesh_.data_ptr(_vh).inc_state();
        }
    }
    //@}

    void update(M.FaceHandle _fh, state_t _target_state)
    {
        M.FaceHandle opp_fh;

        while (mesh_.data_ptr(_fh).state() < _target_state - 1) {
            prev_rule().raise(_fh, _target_state - 1);
        }

        // Don't use unflipped / unfinal faces!!!
        if (subdiv_type() == 3) {

            if (mesh_.face_handle(mesh_.opposite_halfedge_handle(mesh_.halfedge_handle(_fh))).is_valid()) {

                while (!mesh_.data_ptr(_fh).finale()) {

                    opp_fh = mesh_.face_handle(mesh_.opposite_halfedge_handle(mesh_.halfedge_handle(_fh)));

                    assert (mesh_.data_ptr(_fh).state() >=
                            mesh_.data_ptr(opp_fh).state());

                    // different states: raise other face
                    if (mesh_.data_ptr(_fh).state() > mesh_.data_ptr(opp_fh).state()){

                        // raise opposite face
                        prev_rule().raise(opp_fh, _target_state - 1);
                    }

                    else {

                        // equal states

                        // flip edge
                        // 	    M.EdgeHandle eh(mesh_.edge_handle(mesh_.halfedge_handle(_fh)));

                        // 	    if (mesh_.is_flip_ok(eh)) {

                        // 	      std.cout << "Flipping Edge...\n";

                        // 	      mesh_.flip(eh);

                        // 	      mesh_.data_ptr(_fh).set_finale();
                        // 	      mesh_.data_ptr(opp_fh).set_finale();
                        // 	    }

                        // 	    else {

                        // 	      std.cout << "Flip not okay.\n";
                        // 	    }
                    }
                }
            }

            else {

                // 	mesh_.data_ptr(_fh).set_finale();
            }

            //     std.cout << "Raising Face   to Level " 
            // 	      << _target_state
            // 	      << " with "
            // 	      << type()
            // 	      << ".\n";

        }
    
        assert( subdiv_type() != 4       || 
                mesh_.data_ptr(_fh).finale() ||
                _target_state%n_rules() == (subdiv_rule().number() + 1)%n_rules() );

        M.FaceEdgeIter   fe_it;
        M.FaceVertexIter fv_it;
        M.EdgeHandle     eh;
        M.VertexHandle   vh;

        M.FaceHandle[] face_vector;

        if (_target_state > 1) {

            for (fe_it = mesh_.fe_iter(_fh); fe_it.is_active; ++fe_it) {

                eh = fe_it.handle();
                prev_rule().raise(eh, _target_state - 1);
            }

            for (fv_it = mesh_.fv_iter(_fh); fv_it.is_active; ++fv_it) {

                vh = fv_it.handle();
                prev_rule().raise(vh, _target_state - 1);
            }
        }
    }
  

    void update(M.EdgeHandle _eh, state_t _target_state) 
    {
        state_t state = (mesh_.data_ptr(_eh).state());

        // raise edge to correct state
        if (state + 1 < _target_state && _target_state > 0) {

            prev_rule().raise(_eh, _target_state - 1);
        }

        M.VertexHandle vh;
        M.FaceHandle   fh;

        if (_target_state > 1)
        {
            vh = mesh_.to_vertex_handle(mesh_.halfedge_handle(_eh, 0));
            prev_rule().raise(vh, _target_state - 1);

            vh = mesh_.to_vertex_handle(mesh_.halfedge_handle(_eh, 1));
            prev_rule().raise(vh, _target_state - 1);

            fh = mesh_.face_handle(mesh_.halfedge_handle(_eh, 0));
            if (fh.is_valid())
                prev_rule().raise(fh, _target_state - 1);

            fh = mesh_.face_handle(mesh_.halfedge_handle(_eh, 1));
            if (fh.is_valid())
                prev_rule().raise(fh, _target_state - 1);
        }
    }


    void update(M.VertexHandle _vh, state_t _target_state) {

        state_t state = (mesh_.data_ptr(_vh).state());

        // raise vertex to correct state
        if (state + 1 < _target_state)
        {
            prev_rule().raise(_vh, _target_state - 1);
        }

        M.HalfedgeHandle[] halfedge_vector;

        M.VertexOHalfedgeIter voh_it;
        M.EdgeHandle eh;
        M.FaceHandle fh;

        if (_target_state > 1)
        {

            for (voh_it = mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) {
                halfedge_vector ~= (voh_it.handle());
            }

            while ( !halfedge_vector.empty() ) {
                eh = mesh_.edge_handle(halfedge_vector[$-1]);
                halfedge_vector.length = halfedge_vector.length - 1;

                prev_rule().raise(eh, _target_state - 1);
            }

            for (voh_it = mesh_.voh_iter(_vh); voh_it.is_active; ++voh_it) {
                halfedge_vector ~= voh_it.handle;
            }

            while ( !halfedge_vector.empty() ) {
                fh = mesh_.face_handle(halfedge_vector[$-1]);
                halfedge_vector.length = halfedge_vector.length - 1;

                if (fh.is_valid())
                    prev_rule().raise(fh, _target_state - 1);
            }
        }
    }

public:


    /// Type of split operation, if it is a topological operator
    int  subdiv_type() /*const*/ { return subdiv_type_; }


    /// Position in rule sequence
    int  number() /*const*/      { return number_;      }

    /// \name Parameterization of rule
    //@{

    /// Set coefficient - ignored by non-parameterized rules.
    void set_coeff( scalar_t _coeff ) { coeff_ = _coeff; }

    /// Get coefficient - ignored by non-parameterized rules.
    scalar_t coeff() /*const*/ { return coeff_; }

    //@}

//protected: (these are supposed to be for use by CompositeT only!)

    void  set_prev_rule(Self _p) { prev_rule_ = _p; }
    Self prev_rule() { return prev_rule_; }

    void  set_subdiv_rule(Self _n) { subdiv_rule_ = _n; }
    Self subdiv_rule() { return subdiv_rule_; }

    void set_number(int _n) { number_ = _n; }

    void set_n_rules(int _n) { n_rules_ = _n; }
    int  n_rules() { return n_rules_; }

    void set_subdiv_type(int _n) 
    { assert(_n == 3 || _n == 4); subdiv_type_ = _n; }

    //friend class CompositeT<M>;

protected:

    Mesh mesh_;

private:

    Self prev_rule_;
    Self subdiv_rule_;
  
    int   subdiv_type_;
    int   number_;
    int   n_rules_;

    scalar_t coeff_;

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
