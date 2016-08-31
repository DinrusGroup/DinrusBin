//============================================================================
// CompositeT.d - 
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
module auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.CompositeT;


/** \file Adaptive/Composite/CompositeT.hh
    
 */

//=============================================================================
//
//  CLASS CompositeT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.CompositeTraits;
import auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.RuleInterfaceT;
import auxd.OpenMesh.Core.IO.Streams;
import math=auxd.OpenMesh.Core.Geometry.MathDefs;

//== CLASS DEFINITION =========================================================

private {
    void pop_back(T)(ref T[] array) {
        array.length = array.length -1;
    }
    bool empty(T)(T[] array) {
        return array.length != 0;
    }
}


//== CLASS DEFINITION =========================================================

/** Adaptive Composite Subdivision framework.
 *
 *  The adaptive composite subdivision framework is based on the work
 *  done by P. Oswald and P. Schroeder. This framework elevates the
 *  uniform case of the composite scheme to the adaptive
 *  setting.
 *
 *  For details on the composite scheme refer to
 *  - <a
 *  href="http://cm.bell-labs.com/who/poswald/sqrt3.pdf">P. Oswald,
 *  P. Schroeder "Composite primal/dual sqrt(3)-subdivision schemes",
 *  CAGD 20, 3, 2003, 135--164</a>
 *
 *  For details on the transition from uniform to adaptive composite
 *  subdivision please refer to
 *  - <a
 *  href="http://www.eg.org/EG/DL/PE/OPENSG03/04sovakar.pdf>A. von Studnitz,
 *  A. Sovakar, L. Kobbelt "API Design for Adaptive Subdivision
 *  Schemes" OpenSG Symposium 2003</a>
 *
 *  In the composite scheme a subdivision operator is created by
 *  combining smaller "atomic" rules. Depending on the selection and
 *  ordering of the operator many known subdivision schemes can be
 *  created.
 *
 *  Every rule inherits from RuleInterfaceT and is represented out of
 *  the subdivider object by a RuleHandleT (as usual within
 *  %OpenMesh). You can add rules using the CompositeT.add()
 *  functions. The correct order of adding the rules is very
 *  important, and furthermore not all rules get along with each other
 *  very well. (Please read the given literature, especially the
 *  paper by Oswald and Schröder.)
 *  
 *  To use a composite subdivider first define a rule sequence
 *  describing the order of execution of the rules. In the order the
 *  rules habe been added they will be executed. E.g. the rules given
 *  in operator notation have to added from right to left.  
 *
 *  After the rule sequence has been defined the subdivider has to be
 *  intialized using CompositeT.initialize(). If everything went well,
 *  use CompositeT.refine() to subdivide locally a face or vertex.
 *
 *  \note Not all (topological) operators have been implemented!
 *  \note Only triangle meshes are supported.
 *  \note The rule sequence must begin with a topological operator.
 *
 *  See_Also: RuleInterfaceT, RuleHandleT
 *
 */ 
class CompositeT(M)
{
public:

    alias RuleInterfaceT!(M)  Rule;
    alias M                  Mesh;
    alias Rule[] RuleSequence;

    alias M.VertexHandle   VH;
    alias M.FaceHandle     FH;
    alias M.EdgeHandle     EH;
    alias M.HalfedgeHandle HH;

    /+
     // this doesn't work... macros?
     alias mesh_.deref               MOBJ ;
     alias to_vertex_handle          TVH  ;
     alias halfedge_handle           HEH  ;
     alias next_halfedge_handle      NHEH ;
     alias prev_halfedge_handle      PHEH ;
     alias opposite_halfedge_handle  OHEH ;
     +/

public:

    /// Constructor
    this(Mesh _mesh)  {
        subdiv_type_=(0) ;
        subdiv_rule_=(null);
        /*first_rule_(null), last_rule_(null);*/
        mesh_ = _mesh;
    }

    ///
    ~this() 
    {
        //cleanup();
    }


    /// Reset \c self to state after the default constructor except of
    /// the mesh.
    void cleanup()
    {
        subdiv_type_ = 0;
        subdiv_rule_ = null;

        foreach(r; rule_sequence_) {
            delete r;
        }
        rule_sequence_.length = 0;
    }


    /// Initialize faces, edges, vertices, and rules
    bool initialize()
    {
        Mesh.VertexIter  v_it;
        Mesh.FaceIter    f_it;
        Mesh.EdgeIter    e_it;
        /*const*/ Mesh.Point zero_point=Mesh.Point(0.0, 0.0, 0.0);
  
        // ---------------------------------------- Init Vertices
        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it) 
        {
            mesh_.data_ptr(v_it.handle).set_state(0);
            mesh_.data_ptr(v_it.handle).set_finale();
            mesh_.data_ptr(v_it.handle).set_position(0, mesh_.point(v_it.handle()));
        }
  
        // ---------------------------------------- Init Faces
        for (f_it = mesh_.faces_begin(); f_it != mesh_.faces_end(); ++f_it) 
        {
            mesh_.data_ptr(f_it.handle).set_state(0);
            mesh_.data_ptr(f_it.handle).set_finale();
            mesh_.data_ptr(f_it.handle).set_position(0, zero_point);
        }
  
        // ---------------------------------------- Init Edges
        for (e_it = mesh_.edges_begin(); e_it != mesh_.edges_end(); ++e_it) 
        {
            mesh_.data_ptr(e_it.handle).set_state(0);
            mesh_.data_ptr(e_it.handle).set_finale();
            mesh_.data_ptr(e_it.handle).set_position(0, zero_point);
        }
  
  
        // ---------------------------------------- Init Rules

        int n_subdiv_rules_ = 0;


        // look for subdivision rule(s)
        for (size_t i=0; i < n_rules(); ++i) {

            if (rule_sequence_[i].type()[0] == 'T' || 
                rule_sequence_[i].type()[0] == 't') 
            {     
                ++n_subdiv_rules_;
                subdiv_rule_ = rule_sequence_[i];
                subdiv_type_ = rule_sequence_[i].subdiv_type();
            }
        }


        // check for correct number of subdivision rules
        assert(n_subdiv_rules_ == 1, 
               "There must be exactly one 'T'-Rule added before initialization"  );

        if (n_subdiv_rules_ != 1)
        {    
            derr.writefln("Error! More than one subdivision rule not allowed!").flush;
            return false;
        }

        // check for subdivision type
        assert(subdiv_type_ == 3 || subdiv_type_ == 4);

        if (subdiv_type_ != 3 && subdiv_type_ != 4)
        {
            derr.writefln("Error! Unknown subdivision type in sequence!").flush;
            return false;
        }

        // set pointer to last rule
//   first_rule_ = rule_sequence_.front();
//   last_rule_  = rule_sequence_.back(); //[n_rules() - 1];

        // set numbers and previous rule
        for (size_t i = 0; i < n_rules(); ++i) 
        {
            rule_sequence_[i].set_subdiv_type(subdiv_type_);
            rule_sequence_[i].set_n_rules(n_rules());
            rule_sequence_[i].set_number(i);
            rule_sequence_[i].set_prev_rule(rule_sequence_[(i+n_rules()-1)%n_rules()]);
            rule_sequence_[i].set_subdiv_rule(subdiv_rule_);
        }

        return true;

    }

  
    /// Refine one face.
    void refine(Mesh.FaceHandle _fh)
    {
        Mesh.HalfedgeHandle[] hh_vector;

        // -------------------- calculate new level for faces and vertices
        int new_face_level = 
            t_rule().number() + 1 + 
            (cast(int)math.floor(cast(float)(mesh_.data_ptr(_fh).state() - t_rule().number() - 1)/n_rules()) + 1) * n_rules();

        int new_vertex_level = 
            new_face_level + l_rule().number() - t_rule().number();

        // -------------------- store old vertices
        // !!! only triangle meshes supported!
        Mesh.VertexHandle vh[3];

        vh[0] = mesh_.to_vertex_handle(mesh_.halfedge_handle(_fh));
        vh[1] = mesh_.to_vertex_handle(mesh_.next_halfedge_handle(mesh_.halfedge_handle(_fh)));
        vh[2] = mesh_.to_vertex_handle(mesh_.prev_halfedge_handle(mesh_.halfedge_handle(_fh)));

        // save handles to incoming halfedges for getting the new vertices 
        // after subdivision (1-4 split)
        if (subdiv_type_ == 4) 
        {
            hh_vector.length = 0;

            // green face
            if (mesh_.data_ptr(_fh).finale())
            {
                Mesh.FaceHalfedgeIter fh_it=(mesh_.fh_iter(_fh));

                for (; fh_it.is_active; ++fh_it) 
                {
                    hh_vector ~= (mesh_.prev_halfedge_handle(mesh_.opposite_halfedge_handle(fh_it.handle())));
                }
            }

            // red face
            else 
            {
      
                Mesh.HalfedgeHandle red_hh=(mesh_.data_ptr(_fh).red_halfedge());

                hh_vector ~= (mesh_.prev_halfedge_handle(mesh_.opposite_halfedge_handle(mesh_.next_halfedge_handle(red_hh))));
                hh_vector ~= (mesh_.prev_halfedge_handle(mesh_.opposite_halfedge_handle(mesh_.prev_halfedge_handle(mesh_.opposite_halfedge_handle(red_hh)))));
            }
        }

  
        // -------------------- Average rule before topo rule?
        if (t_rule().number() > 0)
            t_rule().prev_rule().raise(_fh, new_face_level-1);

        // -------------------- Apply topological operator first
        t_rule().raise(_fh, new_face_level);

        version (none){ // original code
        assert(MOBJ(_fh).state() >= 
               subdiv_rule_.number()+1+cast(int) (MOBJ(_fh).state()/n_rules())*n_rules());
        } else { // improved code (use % operation and avoid floating point division)
            assert( mesh_.data_ptr(_fh).state() >= ( t_rule().number()+1+generation(_fh) ) );
        }

        // raise new vertices to final levels
        if (subdiv_type_ == 3) 
        {
            Mesh.VertexHandle new_vh=(mesh_.to_vertex_handle(mesh_.next_halfedge_handle(mesh_.halfedge_handle(_fh))));

            // raise new vertex to final level
            l_rule().raise(new_vh, new_vertex_level);
        }

        if (subdiv_type_ == 4) 
        {
            Mesh.HalfedgeHandle hh;
            Mesh.VertexHandle   new_vh;

            while (hh_vector.length!=0) {

                hh = hh_vector[$-1];
                hh_vector.pop_back();

                // get new vertex
                new_vh = mesh_.to_vertex_handle(mesh_.next_halfedge_handle(hh));

                // raise new vertex to final level
                l_rule().raise(new_vh, new_vertex_level);
            }
        }

        // raise old vertices to final position 
        l_rule().raise(vh[0], new_vertex_level);
        l_rule().raise(vh[1], new_vertex_level);
        l_rule().raise(vh[2], new_vertex_level);

    }


    /// Raise one vertex to next final level.
    void refine(Mesh.VertexHandle _vh)
    {
        // calculate next final level for vertex
        int new_vertex_state = generation(_vh) + l_rule().number() + 1;

        assert( new_vertex_state == mesh_.data_ptr(_vh).state()+1 );

        // raise vertex to final position
        l_rule().raise(_vh, new_vertex_state);
    }


    /// Return subdivision split type (3 for 1-to-3 split, 4 for 1-to-4 split).
    int subdiv_type() { return subdiv_type_; }


    // Return subdivision rule.
    /*const*/ Rule subdiv_rule() /*const*/ { return subdiv_rule_; }

public:

    /// \name Managing composite rules
    //*@

    /** Add new rule to rule sequence by passing the type of the wanted
     *  rule as template argument to the method.
     *  \return Valid handle on success. Else it is invalid.
     */
    RuleHandleT!(R) addT(R)()
    {
        size_t idx = rule_sequence_.length;
        rule_sequence_ ~=  new R( mesh_ ) ;
        return RuleHandleT!(R)( (idx < rule_sequence_.length) ? idx : -1 );
    }

    /** Add new rule to rule sequence by passing an appropriate handle
     *  to the method.
     *  \return Valid handle on success. Else it is invalid.
     */
    RuleHandleT!(R) add(R)( ref RuleHandleT!(R) _rh )
    {
        return _rh = addT!(R)();
    }

    /** Get rule in the rule sequence by a handle.  
     *
     * \return The wanted rule if the handle is valid. The return value
     * is undefined if the handle is invalid!
     */
    RuleHandleT!(R).Rule rule(R)( /*const*/ RuleHandleT!(R) _rh )
    {
        alias RuleHandleT!(R).Rule rule_t;
        assert( _rh.is_valid() );
        return cast(rule_t)(rule_sequence_[ _rh.idx() ]);
    }


    /** Get rule (interface) by index
     *
     * \return The wanted rule if the handle is valid. The return value
     * is undefined if the handle is invalid!
     */
    RuleInterfaceT!(M) rule(dummy=void)( size_t _idx )
    {
        assert( _idx < n_rules() );
        return rule_sequence_[ _idx ];
    }

    /// Number of rules in the rule sequence
    size_t n_rules() /*const*/ { return rule_sequence_.length; }

    /// Return the sequence as string
    string rules_as_string(/*const*/ string _sep= " * ") /*const*/
    {
        string seq;
        if ( rule_sequence_ )
        {
            seq = rule_sequence_[0].type();
            foreach (it; rule_sequence_)
            {
                seq ~= _sep;
                seq ~= it.type();    
            }
        }
        return seq;

    }

    //@}

protected:

    /// The rule sequence
    /*const*/ RuleSequence rules() /*const*/ { return rule_sequence_; }

protected: // helper

    // get current generation from state
    state_t generation(state_t _s) { return _s-(_s % n_rules()); }
    state_t generation( VH _vh ) { return generation(mesh_.data_ptr(_vh).state()); }
    state_t generation( EH _eh ) { return generation(mesh_.data_ptr(_eh).state()); }
    state_t generation( FH _fh ) { return generation(mesh_.data_ptr(_fh).state()); }

private:

    // short cuts
    Rule t_rule() { return subdiv_rule_;           }
    Rule f_rule() { return rule_sequence_[0]; }
    Rule l_rule() { return rule_sequence_[$-1];  }

private:

    // 
    RuleSequence rule_sequence_;

    // Split type
    int   subdiv_type_;

    Rule  subdiv_rule_;
//   Rule  first_rule_; 
//   Rule  last_rule_;

    //
    Mesh  mesh_;

private:

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
