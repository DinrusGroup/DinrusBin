//============================================================================
// CirculatorsT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Vertex and Face circulators for PolyMesh/TriMesh
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 28 Aug 2007
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

module auxd.OpenMesh.Core.Mesh.CirculatorsT;


//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Mesh.Handles;

//== CLASS DEFINITION =========================================================

	      
private template _opApplyMixin() {
    /// opApply to allow using in 'foreach'
    int opApply(int delegate(ref value_handle) loop) {
        for(; is_active; ++*this) {
            int ret = loop(handle());
            if (ret) return ret;
        }
        return 0;
    }

    /// opApply to allow using in 'foreach' with counter index
    int opApply(int delegate(ref size_t, ref value_handle) loop) {
        for(size_t i=0; is_active; ++*this,++i) {
            int ret = loop(i,handle());
            if (ret) return ret;
        }
        return 0;
    }
    
}

/** \class VertexVertexIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct VertexVertexIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Vertex           value_type;
    alias VertexHandle         value_handle;

    //alias Mesh.Vertex&         reference;
    alias Mesh.Vertex*         pointer;



    /// Default constructor
    static VertexVertexIterT opCall();

    /// Construct with mesh and a VertexHandle
    static VertexVertexIterT opCall(Mesh _mesh, VertexHandle _start);


    /// Construct with mesh and start halfedge
    static VertexVertexIterT opCall(Mesh _mesh, HalfedgeHandle _heh) ;


    //friend struct ConstVertexVertexIterT!(Mesh);


    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) ;


    /// Pre-Decrement (next ccw target)
    void  opSubAssign(uint i) ;


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() ;

    /// Return the handle of the current target.
    VertexHandle handle();

    /+
    /// Cast to the handle of the current target.
    operator VertexHandle();
    +/
    

    ///  Return a reference to the current target.
    value_type val();

    /// Return a pointer to the current target.
    pointer ptr();


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    
    bool is_active() ;
	
    mixin _opApplyMixin;
    
  protected:

    Mesh             mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class ConstVertexVertexIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct ConstVertexVertexIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Vertex           value_type;
    alias VertexHandle         value_handle;

    //alias /*const*/ Mesh&         Mesh;
    //alias /*const*/ Mesh*         Mesh;
    //alias /*const*/ Mesh.Vertex&   reference;
    alias /*const*/ Mesh.Vertex*   pointer;



    /// Default constructor
    static ConstVertexVertexIterT opCall();


    /// Construct with mesh and a VertexHandle
    static ConstVertexVertexIterT opCall(Mesh _mesh, VertexHandle _start);


    /// Construct with mesh and start halfedge
    static ConstVertexVertexIterT opCall(Mesh _mesh, HalfedgeHandle _heh) ;

    /// Pre-Increment (next cw target)
    ConstVertexVertexIterT* opAddAssign(uint i);


    /// Pre-Decrement (next ccw target)
    ConstVertexVertexIterT* opSubAssign(uint i) ;


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle();

    /// Return the handle of the current target.
    VertexHandle handle() ;

    /+
    /// Cast to the handle of the current target.
    operator VertexHandle();
    +/
    

    ///  Return a reference to the current target.
    value_type val() ;

    /// Return a pointer to the current target.
    pointer ptr() ;


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active();


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================


/** \class VertexOHalfedgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct VertexOHalfedgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Halfedge           value_type;
    alias HalfedgeHandle         value_handle;

    //alias Mesh&               Mesh;
    //alias Mesh*               Mesh;
    //alias Mesh.Halfedge&         reference;
    alias Mesh.Halfedge*         pointer;



    /// Default constructor
    static VertexOHalfedgeIterT opCall();

    /// Construct with mesh and a VertexHandle
    static VertexOHalfedgeIterT opCall(Mesh _mesh, VertexHandle _start) ;

    /// Construct with mesh and start halfedge
    static VertexOHalfedgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh);


    /// Pre-Increment (next cw target)
    VertexOHalfedgeIterT* opAddAssign(uint i);

    /// Pre-Decrement (next ccw target)
    VertexOHalfedgeIterT* opSubAssign(uint i) ;

    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle();


    /// Return the handle of the current target.
    HalfedgeHandle handle();

    /+
    /// Cast to the handle of the current target.
    operator HalfedgeHandle();
    +/
    

    ///  Return a reference to the current target.
    value_type val();

    /// Return a pointer to the current target.
    pointer ptr();

    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active();

    mixin _opApplyMixin;


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class ConstVertexOHalfedgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct ConstVertexOHalfedgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    alias Mesh.Halfedge           value_type;
    alias HalfedgeHandle         value_handle;

    //alias /*const*/ Mesh&         Mesh;
    //alias /*const*/ Mesh*         Mesh;
    //alias /*const*/ Mesh.Halfedge&   reference;
    alias /*const*/ Mesh.Halfedge*   pointer;


    /// Default constructor
    static ConstVertexOHalfedgeIterT opCall();
	
    /// Construct with mesh and a VertexHandle
    static ConstVertexOHalfedgeIterT opCall(Mesh _mesh, VertexHandle _start);

    /// Construct with mesh and start halfedge
    static ConstVertexOHalfedgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh);

    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) ;

    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) ;

    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle();

    /// Return the handle of the current target.
    HalfedgeHandle handle() ;

    /+
    /// Cast to the handle of the current target.
    operator HalfedgeHandle();
	+/
    ///  Return a reference to the current target.
    value_type val() ;
	
    /// Return a pointer to the current target.
    pointer ptr();

    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() ;

  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class VertexIHalfedgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct VertexIHalfedgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Halfedge           value_type;
    alias HalfedgeHandle         value_handle;

    //alias Mesh&               Mesh;
    //alias Mesh*               Mesh;
    //alias Mesh.Halfedge&         reference;
    alias Mesh.Halfedge*         pointer;



    /// Default constructor
    static VertexIHalfedgeIterT opCall();

    /// Construct with mesh and a VertexHandle
    static VertexIHalfedgeIterT opCall(Mesh _mesh, VertexHandle _start);

    /// Construct with mesh and start halfedge
    static VertexIHalfedgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh);

    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) ;

    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i);

    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle();

    /// Return the handle of the current target.
    HalfedgeHandle handle();

    /+
    /// Cast to the handle of the current target.
    operator HalfedgeHandle() ;
    +/
    

    ///  Return a reference to the current target.
    value_type val();

    /// Return a pointer to the current target.
    pointer ptr() ;


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() ;


    mixin _opApplyMixin;

  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================


/** \class ConstVertexIHalfedgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct ConstVertexIHalfedgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    alias Mesh.Halfedge           value_type;
    alias HalfedgeHandle         value_handle;

    //alias /*const*/ Mesh&         Mesh;
    //alias /*const*/ Mesh*         Mesh;
    //alias /*const*/ Mesh.Halfedge&   reference;
    alias /*const*/ Mesh.Halfedge*   pointer;



    /// Default constructor
    static ConstVertexIHalfedgeIterT opCall() ;

    /// Construct with mesh and a VertexHandle
    static ConstVertexIHalfedgeIterT opCall(Mesh _mesh, VertexHandle _start);

    /// Construct with mesh and start halfedge
    static ConstVertexIHalfedgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh);

    /// Pre-Increment (next cw target)
    void opAddAssign(uint i);


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) ;


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle();

    /// Return the handle of the current target.
    HalfedgeHandle handle() ;

    /+
    /// Cast to the handle of the current target.
    operator HalfedgeHandle() ;
    +/
    

    ///  Return a reference to the current target.
    value_type val() ;

    /// Return a pointer to the current target.
    pointer ptr() ;


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() ;


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class VertexEdgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct VertexEdgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Edge           value_type;
    alias EdgeHandle         value_handle;

    //alias Mesh&               Mesh;
    //alias Mesh*               Mesh;
    //alias Mesh.Edge&         reference;
    alias Mesh.Edge*         pointer;



    /// Default constructor
    static VertexEdgeIterT opCall() ;

    /// Construct with mesh and a VertexHandle
    static VertexEdgeIterT opCall(Mesh _mesh, VertexHandle _start) ;

    /// Construct with mesh and start halfedge
    static VertexEdgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh);


    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) ;

    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) ;


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle();


    /// Return the handle of the current target.
    EdgeHandle handle();

    /+
    /// Cast to the handle of the current target.
    operator EdgeHandle() ;
    +/
    

    ///  Return a reference to the current target.
    value_type val() ;

    /// Return a pointer to the current target.
    pointer ptr();

    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active();


    mixin _opApplyMixin;

  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class ConstVertexEdgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct ConstVertexEdgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Edge           value_type;
    alias EdgeHandle         value_handle;

    //alias /*const*/ Mesh&         Mesh;
    //alias /*const*/ Mesh*         Mesh;
    //alias /*const*/ Mesh.Edge&   reference;
    alias /*const*/ Mesh.Edge*   pointer;

    /// Default constructor
    static ConstVertexEdgeIterT opCall() {
        ConstVertexEdgeIterT M; with(M) {
            mesh_=null, active_=false;
        } return M;
    }


    /// Construct with mesh and a VertexHandle
    static ConstVertexEdgeIterT opCall(Mesh _mesh, VertexHandle _start) {
        ConstVertexEdgeIterT M; with(M) {
            mesh_ = _mesh; 
                start_ = _mesh.halfedge_handle(_start);
                heh_ = start_;
                active_=false;
        } return M;
    }


    /// Construct with mesh and start halfedge
    static ConstVertexEdgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        ConstVertexEdgeIterT M; with(M) {
            mesh_ = _mesh;
                start_ = _heh;
                heh_ = _heh;
                active_=false;
        } return M;
    }


    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.cw_rotated_halfedge_handle(heh_);;
        //return this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.ccw_rotated_halfedge_handle(heh_);;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    EdgeHandle handle() /*const*/ {
        assert(mesh_);
        return mesh_.edge_handle(heh_); 
    }


    /+
    /// Cast to the handle of the current target.
    operator EdgeHandle() /*const*/ {
        assert(mesh_);
        return mesh_.edge_handle(heh_); 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class VertexFaceIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct VertexFaceIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Face           value_type;
    alias FaceHandle         value_handle;

    //alias Mesh&               Mesh;
    //alias Mesh*               Mesh;
    //alias Mesh.Face&         reference;
    alias Mesh.Face*         pointer;



    /// Default constructor
    static VertexFaceIterT opCall() {
        VertexFaceIterT M; with(M) {
            mesh_=null, active_=false ;
        } return M;
    }


    /// Construct with mesh and a VertexHandle
    static VertexFaceIterT opCall(Mesh _mesh, VertexHandle _start) {
        VertexFaceIterT M; with(M) {
            mesh_ = _mesh; 
            start_ = _mesh.halfedge_handle(_start);
            heh_ = start_;
            active_=false;
            if (heh_.is_valid() && !handle().is_valid()) opAddAssign(1);
        } return M;
    }


    /// Construct with mesh and start halfedge
    static VertexFaceIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        VertexFaceIterT M; with(M) {
            mesh_ = _mesh;
            start_ = _heh;
            heh_ = _heh;
            active_=false;
            if (heh_.is_valid() && !handle().is_valid()) opAddAssign(1);
        } return M;
    }


    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        do {  heh_=mesh_.cw_rotated_halfedge_handle(heh_); }
        while ((this.is_active) && (!handle().is_valid()));
        //return this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        do	heh_=mesh_.ccw_rotated_halfedge_handle(heh_); 
        while ((this.is_active) && (!handle().is_valid()));;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    FaceHandle handle() /*const*/ {
        assert(mesh_);
        return mesh_.face_handle(heh_); 
    }


    /+
    /// Cast to the handle of the current target.
    operator FaceHandle() /*const*/ {
        assert(mesh_);
        return mesh_.face_handle(heh_); 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }

    mixin _opApplyMixin;


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class ConstVertexFaceIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct ConstVertexFaceIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Face           value_type;
    alias FaceHandle         value_handle;

    //alias /*const*/ Mesh&         Mesh;
    //alias /*const*/ Mesh*         Mesh;
    //alias /*const*/ Mesh.Face&   reference;
    alias /*const*/ Mesh.Face*   pointer;


    /// Default constructor
    static ConstVertexFaceIterT opCall() {
        ConstVertexFaceIterT M; with(M) {
            mesh_=null, active_=false ;
        } return M;
    }


    /// Construct with mesh and a VertexHandle
    static ConstVertexFaceIterT opCall(Mesh _mesh, VertexHandle _start) {
        ConstVertexFaceIterT M; with(M) {
            mesh_=_mesh; 
            start_=(_mesh.halfedge_handle(_start));
            heh_=start_;
            active_=false;
            if (heh_.is_valid() && !handle().is_valid()) opAddAssign(1);
        } return M;
    }


    /// Construct with mesh and start halfedge
    static ConstVertexFaceIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        ConstVertexFaceIterT M; with(M) {
            mesh_ = _mesh;
            start_ = _heh;
            heh_ = _heh;
            active_=false;
            if (heh_.is_valid() && !handle().is_valid()) opAddAssign(1);
        } return M;
    }


    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        do heh_=mesh_.cw_rotated_halfedge_handle(heh_);
        while ((this.is_active) && (!handle().is_valid()));
        //return this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        do	heh_=mesh_.ccw_rotated_halfedge_handle(heh_); 
        while ((this.is_active) && (!handle().is_valid()));;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    FaceHandle handle() /*const*/ {
        assert(mesh_);
        return mesh_.face_handle(heh_); 
    }


/+
    /// Cast to the handle of the current target.
    operator FaceHandle() /*const*/ {
        assert(mesh_);
        return mesh_.face_handle(heh_); 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================


/** \class FaceVertexIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct FaceVertexIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Vertex           value_type;
    alias VertexHandle         value_handle;

    //alias Mesh&               Mesh;
    //alias Mesh*               Mesh;
    //alias Mesh.Vertex&         reference;
    alias Mesh.Vertex*         pointer;



    /// Default constructor
    static FaceVertexIterT opCall() {
        FaceVertexIterT M; with(M) {
            mesh_=null, active_=false ;
        } return M;
    }


    /// Construct with mesh and a FaceHandle
    static FaceVertexIterT opCall(Mesh _mesh, FaceHandle _start) {
        FaceVertexIterT M; with(M) {
            mesh_ = _mesh; 
                start_ = _mesh.halfedge_handle(_start);
                heh_ = start_;
                active_=false;
        } return M;
    }


    /// Construct with mesh and start halfedge
    static FaceVertexIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        FaceVertexIterT M; with(M) {
            mesh_ = _mesh;
                start_ = _heh;
                heh_ = _heh;
                active_=false;
        } return M;
    }


    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.next_halfedge_handle(heh_);;
        //return *this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) {
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.prev_halfedge_handle(heh_);;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    VertexHandle handle() /*const*/ {
        assert(mesh_);
        return mesh_.to_vertex_handle(heh_); 
    }


    /+
    /// Cast to the handle of the current target.
    operator VertexHandle() /*const*/ {
        assert(mesh_);
        return mesh_.to_vertex_handle(heh_); 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }

    mixin _opApplyMixin;


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class ConstFaceVertexIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct ConstFaceVertexIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Vertex           value_type;
    alias VertexHandle         value_handle;

    //alias /*const*/ Mesh&         Mesh;
    //alias /*const*/ Mesh*         Mesh;
    //alias /*const*/ Mesh.Vertex&   reference;
    alias /*const*/ Mesh.Vertex*   pointer;



    /// Default constructor
    static ConstFaceVertexIterT opCall() {
        ConstFaceVertexIterT M; with(M) {
            mesh_=null, active_=false ;
        } return M;
    }


    /// Construct with mesh and a FaceHandle
    static ConstFaceVertexIterT opCall(Mesh _mesh, FaceHandle _start) {
        ConstFaceVertexIterT M; with(M) {
            mesh_ = _mesh; 
                start_ = _mesh.halfedge_handle(_start);
                heh_ = start_;
                active_=false;
        } return M;
    }


    /// Construct with mesh and start halfedge
    static ConstFaceVertexIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        ConstFaceVertexIterT M; with(M) {
            mesh_ = _mesh;
                start_ = _heh;
                heh_ = _heh;
                active_=false;
        } return M;
    }



    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.next_halfedge_handle(heh_);;
        //return this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.prev_halfedge_handle(heh_);;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    VertexHandle handle() /*const*/ {
        assert(mesh_);
        return mesh_.to_vertex_handle(heh_); 
    }


    /+
    /// Cast to the handle of the current target.
    operator VertexHandle() /*const*/ {
        assert(mesh_);
        return mesh_.to_vertex_handle(heh_); 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class FaceHalfedgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct FaceHalfedgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Halfedge           value_type;
    alias HalfedgeHandle         value_handle;

    //alias Mesh&               Mesh;
    //alias Mesh*               Mesh;
    //alias Mesh.Halfedge&         reference;
    alias Mesh.Halfedge*         pointer;



    /// Default constructor
    static FaceHalfedgeIterT opCall() {
        FaceHalfedgeIterT M; with(M) {
            mesh_=null, active_=false ;
        } return M;
    }


    /// Construct with mesh and a FaceHandle
    static FaceHalfedgeIterT opCall(Mesh _mesh, FaceHandle _start) {
        FaceHalfedgeIterT M; with(M) {
            mesh_ = _mesh; 
                start_ = _mesh.halfedge_handle(_start);
                heh_ = start_;
                active_=false;
        } return M;
    }


    /// Construct with mesh and start halfedge
    static FaceHalfedgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        FaceHalfedgeIterT M; with(M) {
            mesh_ = _mesh;
                start_ = _heh;
                heh_ = _heh;
                active_=false;
        } return M;
    }



    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.next_halfedge_handle(heh_);;
        //return *this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.prev_halfedge_handle(heh_);;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns.
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    HalfedgeHandle handle() /*const*/ {
        assert(mesh_);
        return heh_; 
    }


    /+
    /// Cast to the handle of the current target.
    operator HalfedgeHandle() /*const*/ {
        assert(mesh_);
        return heh_; 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }

    mixin _opApplyMixin;


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class ConstFaceHalfedgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct ConstFaceHalfedgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Halfedge           value_type;
    alias HalfedgeHandle         value_handle;

    //alias /*const*/ Mesh&         Mesh;
    //alias /*const*/ Mesh*         Mesh;
    //alias /*const*/ Mesh.Halfedge&   reference;
    alias /*const*/ Mesh.Halfedge*   pointer;



    /// Default constructor
    static ConstFaceHalfedgeIterT opCall() {
        ConstFaceHalfedgeIterT M; with(M) {
            mesh_=null, active_=false ;
        } return M;
    }


    /// Construct with mesh and a FaceHandle
    static ConstFaceHalfedgeIterT opCall(Mesh _mesh, FaceHandle _start) {
        ConstFaceHalfedgeIterT M; with(M) {
            mesh_ = _mesh; 
                start_ = _mesh.halfedge_handle(_start);
                heh_ = start_;
                active_=false;
        } return M;
    }


    /// Construct with mesh and start halfedge
    static ConstFaceHalfedgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        ConstFaceHalfedgeIterT M; with(M) {
            mesh_ = _mesh;
                start_ = _heh;
                heh_ = _heh;
                active_=false;
        } return M;
    }



    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.next_halfedge_handle(heh_);;
        //return this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.prev_halfedge_handle(heh_);;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    HalfedgeHandle handle() /*const*/ {
        assert(mesh_);
        return heh_; 
    }


    /+
    /// Cast to the handle of the current target.
    operator HalfedgeHandle() /*const*/ {
        assert(mesh_);
        return heh_; 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }

  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class FaceEdgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct FaceEdgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Edge           value_type;
    alias EdgeHandle         value_handle;

    //alias Mesh&               Mesh;
    //alias Mesh*               Mesh;
    //alias Mesh.Edge&         reference;
    alias Mesh.Edge*         pointer;


    /// Default constructor
    static FaceEdgeIterT opCall() {
        FaceEdgeIterT M; with(M) {
            mesh_=null, active_=false ;
        } return M;
    }


    /// Construct with mesh and a FaceHandle
    static FaceEdgeIterT opCall(Mesh _mesh, FaceHandle _start) {
        FaceEdgeIterT M; with(M) {
            mesh_ = _mesh; 
                start_ = _mesh.halfedge_handle(_start);
                heh_ = start_;
                active_=false;
        } return M;
    }


    /// Construct with mesh and start halfedge
    static FaceEdgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        FaceEdgeIterT M; with(M) {
            mesh_ = _mesh;
                start_ = _heh;
                heh_ = _heh;
                active_=false;
        } return M;
    }



    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.next_halfedge_handle(heh_);;
        //return *this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.prev_halfedge_handle(heh_);;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    EdgeHandle handle() /*const*/ {
        assert(mesh_);
        return mesh_.edge_handle(heh_); 
    }


    /+
    /// Cast to the handle of the current target.
    operator EdgeHandle() /*const*/ {
        assert(mesh_);
        return mesh_.edge_handle(heh_); 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }



    mixin _opApplyMixin;


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class ConstFaceEdgeIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct ConstFaceEdgeIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Edge           value_type;
    alias EdgeHandle         value_handle;

    //alias /*const*/ Mesh&         Mesh;
    //alias /*const*/ Mesh*         Mesh;
    //alias /*const*/ Mesh.Edge&   reference;
    alias /*const*/ Mesh.Edge*   pointer;



    /// Default constructor
    static ConstFaceEdgeIterT opCall() {
        ConstFaceEdgeIterT M; with(M) {
            mesh_=null, active_=false ;
        } return M;
    }


    /// Construct with mesh and a FaceHandle
    static ConstFaceEdgeIterT opCall(Mesh _mesh, FaceHandle _start)
    {
        ConstFaceEdgeIterT M; with(M) {
            mesh_ = _mesh; 
                start_ = _mesh.halfedge_handle(_start);
                heh_ = start_;
                active_=false;
        } return M;
    }


    /// Construct with mesh and start halfedge
    static ConstFaceEdgeIterT opCall(Mesh _mesh, HalfedgeHandle _heh) 
    {
        ConstFaceEdgeIterT M; with(M) {
            mesh_ = _mesh;
                start_ = _heh;
                heh_ = _heh;
                active_=false;
        } return M;
    }


    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.next_halfedge_handle(heh_);;
        //return this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        heh_=mesh_.prev_halfedge_handle(heh_);;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    EdgeHandle handle() /*const*/ {
        assert(mesh_);
        return mesh_.edge_handle(heh_); 
    }


    /+
    /// Cast to the handle of the current target.
    operator EdgeHandle() /*const*/ {
        assert(mesh_);
        return mesh_.edge_handle(heh_); 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class FaceFaceIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct FaceFaceIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Face           value_type;
    alias FaceHandle         value_handle;

    //alias Mesh&               Mesh;
    //alias Mesh*               Mesh;
    //alias Mesh.Face&         reference;
    alias Mesh.Face*         pointer;



    /// Default constructor
    static FaceFaceIterT opCall() {
        FaceFaceIterT M; with(M) {
            mesh_=null, active_=false;
                } return M;
    }


    /// Construct with mesh and a FaceHandle
    static FaceFaceIterT opCall(Mesh _mesh, FaceHandle _start) {
        FaceFaceIterT M; with(M) {
            mesh_ = _mesh; 
            start_ = _mesh.halfedge_handle(_start);
            heh_ = start_;
            active_=false;
            if (heh_.is_valid() && !handle().is_valid()) opAddAssign(1);
        } return M;
    }        


    /// Construct with mesh and start halfedge
    static FaceFaceIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        FaceFaceIterT M; with(M) {
            mesh_ = _mesh;
            start_ = _heh;
            heh_ = _heh;
            active_=false;
            if (heh_.is_valid() && !handle().is_valid()) opAddAssign(1);
        } return M;
    }


    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        do heh_=mesh_.next_halfedge_handle(heh_); 
        while ((this.is_active) && (!handle().is_valid()));;
        //return *this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        do heh_=mesh_.prev_halfedge_handle(heh_); 
        while ((this.is_active) && (!handle().is_valid()));;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    FaceHandle handle() /*const*/ {
        assert(mesh_);
        return mesh_.face_handle(mesh_.opposite_halfedge_handle(heh_)); 
    }


    /+
    /// Cast to the handle of the current target.
    operator FaceHandle() /*const*/ {
        assert(mesh_);
        return mesh_.face_handle(mesh_.opposite_halfedge_handle(heh_)); 
    }
    +/
    

    ///  Return a reference to the current target.
    value_type val() /*const*/ { 
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ {
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }


    mixin _opApplyMixin;


  protected:

    Mesh         mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
}



//== CLASS DEFINITION =========================================================

	      
/** \class ConstFaceFaceIterT CirculatorsT.hh <OpenMesh/Mesh/Iterators/CirculatorsT.hh>
    Circulator.
*/

struct ConstFaceFaceIterT(Mesh)
{
  public:


    //--- Aliases ---

    //alias HalfedgeHandle   HalfedgeHandle;

    alias Mesh.Face           value_type;
    alias FaceHandle         value_handle;

    //alias /*const*/ Mesh&         Mesh;
    //alias /*const*/ Mesh            Mesh;
    //alias /*const*/ Mesh.Face&   reference;
    alias /*const*/ Mesh.Face*   pointer;



    /// Default constructor
    static ConstFaceFaceIterT opCall() {
        ConstFaceFaceIterT M; with(M) {
            mesh_=null, active_=false ;
        } return M;
    }


    /// Construct with mesh and a FaceHandle
    static ConstFaceFaceIterT opCall(Mesh _mesh, FaceHandle _start) {
        ConstFaceFaceIterT M; with(M) {
            mesh_ = _mesh; 
            start_ = _mesh.halfedge_handle(_start);
            heh_ = start_;
            active_=false;
            if (heh_.is_valid() && !handle().is_valid()) opAddAssign(1);

        } return M;
    }


    /// Construct with mesh and start halfedge
    static ConstFaceFaceIterT opCall(Mesh _mesh, HalfedgeHandle _heh) {
        ConstFaceFaceIterT M; with(M) {
            mesh_ = _mesh;
            start_ = _heh;
            heh_ = _heh;
            active_=false;
            if (heh_.is_valid() && !handle().is_valid()) opAddAssign(1);
        } return M;
    }


    /// Pre-Increment (next cw target)
    void opAddAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        do heh_=mesh_.next_halfedge_handle(heh_); 
        while ((this.is_active) && (!handle().is_valid()));;
        //return this;
    }


    /// Pre-Decrement (next ccw target)
    void opSubAssign(uint i) { 
        assert(i==1);
        assert(mesh_);
        active_ = true;
        do heh_=mesh_.prev_halfedge_handle(heh_); 
        while ((this.is_active) && (!handle().is_valid()));;
        //return *this;
    }


    /** Get the current halfedge. There are \c Vertex*Iters and \c
        Face*Iters.  For both the current state is defined by the
        current halfedge. This is what this method returns. 
    */
    HalfedgeHandle current_halfedge_handle() /*const*/ {
        return heh_;
    }


    /// Return the handle of the current target.
    FaceHandle handle() /*const*/ {
        assert(mesh_);
        return mesh_.face_handle(mesh_.opposite_halfedge_handle(heh_)); 
    }


    /+
    /// Cast to the handle of the current target.
    operator FaceHandle() /*const*/ {
        assert(mesh_);
        return mesh_.face_handle(mesh_.opposite_halfedge_handle(heh_)); 
    }
    +/
    

    value_type val() {
        assert(mesh_);
        return *mesh_.deref(handle());
    }

    /// Return a pointer to the current target.
    pointer ptr() /*const*/ { 
        assert(mesh_);
        return mesh_.deref(handle());
    }


    /** Returns whether the circulator is still valid.
        After one complete round around a vertex/face the circulator becomes
        invalid, i.e. this function will return \c false. Nevertheless you
        can continue circulating. This method just tells you whether you
        have completed the first round.
    */
    //operator bool() /*const*/ { 
    bool is_active() {
        return heh_.is_valid() && ((start_ != heh_) || (!active_));
    }


  protected:

    Mesh             mesh_;
    HalfedgeHandle   start_, heh_;
    bool             active_;
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
