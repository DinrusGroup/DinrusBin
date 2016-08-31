//============================================================================
// IteratorsT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Iterators for PolyMesh/TriMesh
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

module auxd.OpenMesh.Core.Mesh.IteratorsT;


//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Mesh.Status;
import auxd.OpenMesh.Core.Mesh.Handles;


//== CLASS DEFINITION =========================================================


/** \class VertexIterT IteratorsT.hh <OpenMesh/Mesh/Iterators/IteratorsT.hh>
    Linear iterator.
*/

struct VertexIterT(Mesh)
{
public:
  

    //--- Typedefs ---

    alias Mesh.Vertex          value_type;
    alias VertexHandle         value_handle;

    alias value_type           reference;
    alias value_type*          pointer;
    alias Mesh*                mesh_ptr;
    alias Mesh*                mesh_ref;

    /// Default /*const*/ructor.
    static typeof(*this) opCall() {
        VertexIterT M; with(M) {
            mesh_=null; skip_bits_=0; 
        } return M;
    }


    /// Construct with mesh and a target handle. 
    static typeof(*this) opCall(
        ref Mesh _mesh, value_handle _hnd, bool _skip=false
                                ) 
    {
        VertexIterT M; with(M) {
        mesh_=_mesh, hnd_=(_hnd), skip_bits_=(0);
        if (_skip) enable_skipping();
        } return M;
    }


    /// Standard dereferencing ptr
    //reference operator*()  /*const*/ { return mesh_.deref(hnd_); }
    value_type val()  /*const*/ { return *mesh_.deref(hnd_); }
  
    /// Standard pointer ptr
    pointer   ptr() /*const*/ { return (mesh_.deref(hnd_)); }
  
    /// Get the handle of the item the iterator refers to.
    value_handle handle() /*const*/ { return hnd_; }

    /// Cast to the handle of the item the iterator refers to.
    //operator value_handle() /*const*/ { return hnd_; }

    /// Are two iterators equal? Only valid if they refer to the same mesh!
    bool opEquals(/*const*/ ref VertexIterT _rhs) /*const*/
    { return ((mesh_ == _rhs.mesh_) && (hnd_ == _rhs.hnd_)); }

    /// Standard pre-increment operator
    VertexIterT* opAddAssign(uint i)
    { 
        assert(i==1);
        hnd_.__increment(); if (skip_bits_) skip_fwd(); return this; 
    }

    /// Standard pre-decrement operator
    VertexIterT* opSubAssign(uint i) 
    {         
        assert(i==1);
        hnd_.__decrement(); if (skip_bits_) skip_bwd(); return this; 
    }
  

    /// opApply to allow using in 'foreach'
    int opApply(int delegate(ref value_handle) loop) {
        auto end = mesh_.vertices_end();
        for(;*this != end; ++*this) {
            int ret = loop(hnd_);
            if (ret) return ret;
        }
        return 0;
    }
    /// opApply to allow using in 'foreach' with counter
    int opApply(int delegate(ref uint, ref value_handle) loop) {
        auto end = mesh_.vertices_end();
        for(uint idx=0; *this != end; ++*this, ++idx) {
            int ret = loop(idx, hnd_);
            if (ret) return ret;
        }
        return 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void enable_skipping()
    {
        if (mesh_ && mesh_.has_vertex_status())
        {
            StatusInfo status;
            status.set_deleted(true);
            status.set_hidden(true);
            skip_bits_ = status.bits();
            skip_fwd();
        }
        else skip_bits_ = 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void disable_skipping() { skip_bits_ = 0; }



private:

    void skip_fwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() < cast(int) mesh_.n_vertices()) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__increment();
    }


    void skip_bwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() >= 0) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__decrement();
    }



private:
    Mesh      mesh_;
    value_handle  hnd_;
    uint  skip_bits_;
}


//== CLASS DEFINITION =========================================================

	      
/** \class ConstVertexIterT IteratorsT.hh <OpenMesh/Mesh/Iterators/IteratorsT.hh>
    Linear iterator.
*/

struct ConstVertexIterT(Mesh)
{
public:
  

    //--- Aliass ---

    alias Mesh.Vertex              value_type;
    alias VertexHandle        value_handle;

    alias /*const*/ value_type*    reference;
    alias /*const*/ value_type*    pointer;
    alias /*const*/ Mesh*          mesh_ptr;
    alias /*const*/ Mesh*          mesh_ref;




    /// Default constructor.
    static ConstVertexIterT opCall() {
        ConstVertexIterT M; with (M) {
            mesh_=null, skip_bits_=0 ;
        } return M;
    }


    /// Construct with mesh and a target handle. 
    static ConstVertexIterT opCall(ref Mesh _mesh, value_handle _hnd, bool _skip=false) 
    {
        ConstVertexIterT M; with (M) {
            mesh_=(_mesh), hnd_=(_hnd), skip_bits_=0 ;
            if (_skip) enable_skipping();
        } return M;
    }


    /// Standard dereferencing ptr
    value_type val()  /*const*/ { return *mesh_.deref(hnd_); }
  
    /// Standard pointer ptr
    pointer   ptr() /*const*/ { return (mesh_.deref(hnd_)); }
  
    /// Get the handle of the item the iterator refers to.
    value_handle handle() /*const*/ { return hnd_; }

    /// Cast to the handle of the item the iterator refers to.
    //operator value_handle() /*const*/ { return hnd_; }

    /// Are two iterators equal? Only valid if they refer to the same mesh!
    int opEquals(/*const*/ ref ConstVertexIterT _rhs) /*const*/ 
    { return ((mesh_ == _rhs.mesh_) && (hnd_ == _rhs.hnd_)); }

    /// Standard pre-increment operator
    void /*ref ConstVertexIterT*/ opAddAssign(uint i)
    { 
        assert(i==1);
        hnd_.__increment(); if (skip_bits_) skip_fwd(); 
        //return this; 
    }

    /// Standard pre-decrement operator
    void /*ref ConstVertexIterT*/ opSubAssign(uint i) 
    {
        assert(i==1); hnd_.__decrement(); if (skip_bits_) skip_bwd(); 
        //return this; 
    }
  

    /// Turn on skipping: automatically skip deleted/hidden elements
    void enable_skipping()
    {
        if (mesh_ && mesh_.has_vertex_status())
        {
            StatusInfo status;
            status.set_deleted(true);
            status.set_hidden(true);
            skip_bits_ = status.bits();
            skip_fwd();
        }
        else skip_bits_ = 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void disable_skipping() { skip_bits_ = 0; }



private:

    void skip_fwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() < cast(int) mesh_.n_vertices()) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__increment();
    }


    void skip_bwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() >= 0) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__decrement();
    }



private:
    Mesh      mesh_;
    value_handle  hnd_;
    uint  skip_bits_;
}


//== CLASS DEFINITION =========================================================

	      
/** \class HalfedgeIterT IteratorsT.hh <OpenMesh/Mesh/Iterators/IteratorsT.hh>
    Linear iterator.
*/

struct HalfedgeIterT(Mesh)
{
public:
  

    //--- Aliass ---

    alias Mesh.Halfedge           value_type;
    alias HalfedgeHandle         value_handle;

    alias /*const*/ value_type    reference;
    alias /*const*/ value_type*    pointer;
    alias /*const*/ Mesh*          mesh_ptr;
    alias /*const*/ Mesh*          mesh_ref;




    /// Default constructor.
    static HalfedgeIterT opCall()
    {
        HalfedgeIterT M; with(M) {
            mesh_=null, skip_bits_=0 ;
        } return M;
    }


    /// Construct with mesh and a target handle. 
    static HalfedgeIterT opCall(ref Mesh _mesh, value_handle _hnd, bool _skip=false)
    {
        HalfedgeIterT M; with(M) {
            mesh_=(_mesh), hnd_=(_hnd), skip_bits_=(0) ;
            if (_skip) enable_skipping();
        } return M;
    }


    /// Standard dereferencing ptr
    value_type val()  /*const*/ { return *mesh_.deref(hnd_); }
  
    /// Standard pointer ptr
    pointer   ptr() /*const*/ { return mesh_.deref(hnd_); }
  
    /// Get the handle of the item the iterator refers to.
    value_handle handle() /*const*/ { return hnd_; }

    /// Cast to the handle of the item the iterator refers to.
    //operator value_handle() /*const*/ { return hnd_; }

    /// Are two iterators equal? Only valid if they refer to the same mesh!
    int opEquals(/*const*/ ref HalfedgeIterT _rhs) /*const*/ 
    { return ((mesh_ == _rhs.mesh_) && (hnd_ == _rhs.hnd_)); }

    /// Standard pre-increment operator
    void opAddAssign(uint i) 
    { assert(i==1); hnd_.__increment(); if (skip_bits_) skip_fwd(); 
        //return *this; 
    }

    /// Standard pre-decrement operator
    void opSubAssign(uint i) 
    { assert(i==1); hnd_.__decrement(); if (skip_bits_) skip_bwd(); 
        //return *this; 
    }
  

    /// Turn on skipping: automatically skip deleted/hidden elements
    void enable_skipping()
    {
        if (mesh_ && mesh_.has_halfedge_status())
        {
            StatusInfo status;
            status.set_deleted(true);
            status.set_hidden(true);
            skip_bits_ = status.bits();
            skip_fwd();
        }
        else skip_bits_ = 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void disable_skipping() { skip_bits_ = 0; }



private:

    void skip_fwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() < cast(int) mesh_.n_halfedges()) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__increment();
    }


    void skip_bwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() >= 0) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__decrement();
    }



private:
    Mesh      mesh_;
    value_handle  hnd_;
    uint  skip_bits_;
}


//== CLASS DEFINITION =========================================================

	      
/** \class ConstHalfedgeIterT IteratorsT.hh <OpenMesh/Mesh/Iterators/IteratorsT.hh>
    Linear iterator.
*/

struct ConstHalfedgeIterT(Mesh)
{
public:
  

    //--- Aliass ---

    alias Mesh.Halfedge           value_type;
    alias HalfedgeHandle         value_handle;

    alias /*const*/ value_type*    reference;
    alias /*const*/ value_type*    pointer;
    alias /*const*/ Mesh*          mesh_ptr;
    alias /*const*/ Mesh*          mesh_ref;




    /// Default constructor.
    static ConstHalfedgeIterT opCall()
    {
        ConstHalfedgeIterT M; with(M) {
            mesh_=null, skip_bits_=0 ;
        } return M;
    }


    /// Construct with mesh and a target handle. 
    static ConstHalfedgeIterT opCall(ref Mesh _mesh, value_handle _hnd, bool _skip=false)
    {
        ConstHalfedgeIterT M; with(M) {
            mesh_=(_mesh), hnd_=(_hnd), skip_bits_=0 ;
            if (_skip) enable_skipping();
        } return M;
    }


    /// Standard dereferencing ptr
    value_type val()  /*const*/ { return *mesh_.deref(hnd_); }
  
    /// Standard pointer ptr
    pointer   ptr() /*const*/ { return (mesh_.deref(hnd_)); }
  
    /// Get the handle of the item the iterator refers to.
    value_handle handle() /*const*/ { return hnd_; }

    /// Cast to the handle of the item the iterator refers to.
    //operator value_handle() /*const*/ { return hnd_; }

    /// Are two iterators equal? Only valid if they refer to the same mesh!
    int opEquals(/*const*/ ref ConstHalfedgeIterT _rhs) /*const*/ 
    { return ((mesh_ == _rhs.mesh_) && (hnd_ == _rhs.hnd_)); }

    /// Standard pre-increment operator
    void opAddAssign(uint i) 
    { assert(i==1); hnd_.__increment(); if (skip_bits_) skip_fwd(); /*return *this;*/ }

    /// Standard pre-decrement operator
    void opSubAssign(uint i) 
    { assert(i==1); hnd_.__decrement(); if (skip_bits_) skip_bwd(); /*return *this;*/ }
  

    /// Turn on skipping: automatically skip deleted/hidden elements
    void enable_skipping()
    {
        if (mesh_ && mesh_.has_halfedge_status())
        {
            StatusInfo status;
            status.set_deleted(true);
            status.set_hidden(true);
            skip_bits_ = status.bits();
            skip_fwd();
        }
        else skip_bits_ = 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void disable_skipping() { skip_bits_ = 0; }



private:

    void skip_fwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() < cast(int) mesh_.n_halfedges()) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__increment();
    }


    void skip_bwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() >= 0) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__decrement();
    }



private:
    Mesh      mesh_;
    value_handle  hnd_;
    uint  skip_bits_;
}


//== CLASS DEFINITION =========================================================

	      
/** \class EdgeIterT IteratorsT.hh <OpenMesh/Mesh/Iterators/IteratorsT.hh>
    Linear iterator.
*/

struct EdgeIterT(Mesh)
{
public:
  

    //--- Aliass ---

    alias Mesh.Edge           value_type;
    alias EdgeHandle         value_handle;

    alias /*const*/ value_type*    reference;
    alias /*const*/ value_type*    pointer;
    alias /*const*/ Mesh*          mesh_ptr;
    alias /*const*/ Mesh*          mesh_ref;




    /// Default constructor.
    static EdgeIterT opCall()
    {
        EdgeIterT M; with(M) {
            mesh_=null, skip_bits_=0 ;
        } return M;
    }


    /// Construct with mesh and a target handle. 
    static EdgeIterT opCall(ref Mesh _mesh, value_handle _hnd, bool _skip=false)
    {
        EdgeIterT M; with(M) {
            mesh_=(_mesh), hnd_=(_hnd), skip_bits_=0 ;
            if (_skip) enable_skipping();
        } return M;
    }


    /// Standard dereferencing ptr
    value_type val()  /*const*/ { return *mesh_.deref(hnd_); }
  
    /// Standard pointer ptr
    pointer   ptr() /*const*/ { return mesh_.deref(hnd_); }
  
    /// Get the handle of the item the iterator refers to.
    value_handle handle() /*const*/ { return hnd_; }

    /// Cast to the handle of the item the iterator refers to.
    //operator value_handle() /*const*/ { return hnd_; }

    /// Are two iterators equal? Only valid if they refer to the same mesh!
    int opEquals(/*const*/ ref EdgeIterT _rhs) /*const*/ 
    { return ((mesh_ == _rhs.mesh_) && (hnd_ == _rhs.hnd_)); }

    /// Standard pre-increment operator
    void opAddAssign(uint i) 
    { assert(i==1); hnd_.__increment(); if (skip_bits_) skip_fwd(); 
        //return *this; 
    }

    /// Standard pre-decrement operator
    void opSubAssign(uint i) 
    { assert(i==1); hnd_.__decrement(); if (skip_bits_) skip_bwd(); 
        //return *this; 
    }
  

    /// opApply to allow using in 'foreach'
    int opApply(int delegate(ref value_handle) loop) {
        auto end = mesh_.edges_end();
        for(;*this != end; ++*this) {
            int ret = loop(hnd_);
            if (ret) return ret;
        }
        return 0;
    }
    /// opApply to allow using in 'foreach' with counter
    int opApply(int delegate(ref uint, ref value_handle) loop) {
        auto end = mesh_.edges_end();
        for(uint idx=0;*this != end; ++*this,++idx) {
            int ret = loop(idx,hnd_);
            if (ret) return ret;
        }
        return 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void enable_skipping()
    {
        if (mesh_ && mesh_.has_edge_status())
        {
            StatusInfo status;
            status.set_deleted(true);
            status.set_hidden(true);
            skip_bits_ = status.bits();
            skip_fwd();
        }
        else skip_bits_ = 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void disable_skipping() { skip_bits_ = 0; }



private:

    void skip_fwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() < cast(int) mesh_.n_edges()) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__increment();
    }


    void skip_bwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() >= 0) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__decrement();
    }



private:
    Mesh      mesh_;
    value_handle  hnd_;
    uint  skip_bits_;
}


//== CLASS DEFINITION =========================================================

	      
/** \class ConstEdgeIterT IteratorsT.hh <OpenMesh/Mesh/Iterators/IteratorsT.hh>
    Linear iterator.
*/


struct ConstEdgeIterT(Mesh)
{
public:
  

    //--- Aliass ---

    alias Mesh.Edge           value_type;
    alias EdgeHandle         value_handle;

    alias /*const*/ value_type*    reference;
    alias /*const*/ value_type*    pointer;
    alias /*const*/ Mesh*          mesh_ptr;
    alias /*const*/ Mesh*          mesh_ref;




    /// Default constructor.
    static ConstEdgeIterT opCall()
    {
        ConstEdgeIterT M; with(M) {
            mesh_=null, skip_bits_=0 ;
        } return M;
    }


    /// Construct with mesh and a target handle. 
    static ConstEdgeIterT opCall(ref Mesh _mesh, value_handle _hnd, bool _skip=false)
    {
        ConstEdgeIterT M; with(M) {
            mesh_=_mesh;
            hnd_ = _hnd;
            skip_bits_=0 ;
            if (_skip) enable_skipping();
        } return M;
    }


    /// Standard dereferencing ptr
    value_type val()  /*const*/ { return *mesh_.deref(hnd_); }
  
    /// Standard pointer ptr
    pointer   ptr() /*const*/ { return (mesh_.deref(hnd_)); }
  
    /// Get the handle of the item the iterator refers to.
    value_handle handle() /*const*/ { return hnd_; }

    /// Cast to the handle of the item the iterator refers to.
    //operator value_handle() /*const*/ { return hnd_; }

    /// Are two iterators equal? Only valid if they refer to the same mesh!
    int opEquals(/*const*/ ref ConstEdgeIterT _rhs) /*const*/ 
    { return ((mesh_ == _rhs.mesh_) && (hnd_ == _rhs.hnd_)); }

    /// Standard pre-increment operator
    void opAddAssign(uint i) 
    { assert(i==1); hnd_.__increment(); if (skip_bits_) skip_fwd(); /*return *this;*/ }

    /// Standard pre-decrement operator
    void opSubAssign(uint i) 
    { assert(i==1); hnd_.__decrement(); if (skip_bits_) skip_bwd(); /*return *this;*/ }
  

    /// Turn on skipping: automatically skip deleted/hidden elements
    void enable_skipping()
    {
        if (mesh_ && mesh_.has_edge_status())
        {
            StatusInfo status;
            status.set_deleted(true);
            status.set_hidden(true);
            skip_bits_ = status.bits();
            skip_fwd();
        }
        else skip_bits_ = 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void disable_skipping() { skip_bits_ = 0; }



private:

    void skip_fwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() < cast(int) mesh_.n_edges()) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__increment();
    }


    void skip_bwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() >= 0) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__decrement();
    }



private:
    Mesh      mesh_;
    value_handle  hnd_;
    uint  skip_bits_;
}


//== CLASS DEFINITION =========================================================

	      
/** \class FaceIterT IteratorsT.hh <OpenMesh/Mesh/Iterators/IteratorsT.hh>
    Linear iterator.
*/

struct FaceIterT(Mesh)
{
public:
  

  //--- Aliass ---

  alias Mesh.Face           value_type;
  alias FaceHandle         value_handle;

  alias /*const*/ value_type*    reference;
  alias /*const*/ value_type*    pointer;
  alias /*const*/ Mesh*          mesh_ptr;
  alias /*const*/ Mesh*          mesh_ref;


    /// Default constructor.
    static FaceIterT opCall()
    {
        FaceIterT M; with(M) {
            mesh_=null, skip_bits_=0 ;
        } return M;
    }


    /// Construct with mesh and a target handle. 
    static FaceIterT opCall(ref Mesh _mesh, value_handle _hnd, bool _skip=false)
    {
        FaceIterT M; with(M) {
            mesh_=(_mesh), hnd_=(_hnd), skip_bits_=(0) ;
            if (_skip) enable_skipping();
        } return M;
    }


    /// Standard dereferencing ptr
    value_type val()  /*const*/ { return *mesh_.deref(hnd_); }
  
    /// Standard pointer ptr
    pointer   ptr() /*const*/ { return (mesh_.deref(hnd_)); }
  
    /// Get the handle of the item the iterator refers to.
    value_handle handle() /*const*/ { return hnd_; }

    /// Cast to the handle of the item the iterator refers to.
    //operator value_handle() /*const*/ { return hnd_; }

    /// Are two iterators equal? Only valid if they refer to the same mesh!
    int opEquals(/*const*/ ref FaceIterT _rhs) /*const*/ 
    { return ((mesh_ == _rhs.mesh_) && (hnd_ == _rhs.hnd_)); }

    /// Standard pre-increment operator
    void opAddAssign(uint i) 
    { assert(i==1); hnd_.__increment(); if (skip_bits_) skip_fwd(); /*return *this;*/ }

    /// Standard pre-decrement operator
    void opSubAssign(uint i) 
    { assert(i==1); hnd_.__decrement(); if (skip_bits_) skip_bwd(); /*return *this;*/ }
  


    /// opApply to allow using in 'foreach'
    int opApply(int delegate(ref value_handle) loop) {
        auto end = mesh_.faces_end();
        for(;*this != end; ++*this) {
            int ret = loop(hnd_);
            if (ret) return ret;
        }
        return 0;
    }
    /// opApply to allow using in 'foreach' with counter
    int opApply(int delegate(ref uint, ref value_handle) loop) {
        auto end = mesh_.faces_end();
        for(uint idx=0;*this != end; ++*this,++idx) {
            int ret = loop(idx,hnd_);
            if (ret) return ret;
        }
        return 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void enable_skipping()
    {
        if (mesh_ && mesh_.has_face_status())
        {
            StatusInfo status;
            status.set_deleted(true);
            status.set_hidden(true);
            skip_bits_ = status.bits();
            skip_fwd();
        }
        else skip_bits_ = 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void disable_skipping() { skip_bits_ = 0; }



private:

    void skip_fwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() < cast(int) mesh_.n_faces()) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__increment();
    }


    void skip_bwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() >= 0) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__decrement();
    }



private:
    Mesh      mesh_;
    value_handle  hnd_;
    uint  skip_bits_;
}


//== CLASS DEFINITION =========================================================

	      
/** \class ConstFaceIterT IteratorsT.hh <OpenMesh/Mesh/Iterators/IteratorsT.hh>
    Linear iterator.
*/

struct ConstFaceIterT(Mesh)
{
public:
  

    //--- Aliass ---

    alias Mesh.Face           value_type;
    alias FaceHandle         value_handle;

    alias /*const*/ value_type*    reference;
    alias /*const*/ value_type*    pointer;
    alias /*const*/ Mesh*          mesh_ptr;
    alias /*const*/ Mesh*          mesh_ref;




    /// Default constructor.
    static   ConstFaceIterT opCall()
    {
        ConstFaceIterT M; with(M) {
            mesh_=null, skip_bits_=0 ;
        } return M;
    }


    /// Construct with mesh and a target handle. 
    static   ConstFaceIterT opCall(ref Mesh _mesh, value_handle _hnd, bool _skip=false)
    {
        ConstFaceIterT M; with(M) {
            mesh_=_mesh, hnd_=_hnd, skip_bits_=0 ;
            if (_skip) enable_skipping();
        } return M;
    }




    /// Standard dereferencing ptr
    value_type val()  /*const*/ { return *mesh_.deref(hnd_); }
  
    /// Standard pointer ptr
    pointer   ptr() /*const*/ { return (mesh_.deref(hnd_)); }
  
    /// Get the handle of the item the iterator refers to.
    value_handle handle() /*const*/ { return hnd_; }

    /// Cast to the handle of the item the iterator refers to.
    //operator value_handle() /*const*/ { return hnd_; }

    /// Are two iterators equal? Only valid if they refer to the same mesh!
    int opEquals(/*const*/ ref ConstFaceIterT _rhs) /*const*/ 
    { return ((mesh_ == _rhs.mesh_) && (hnd_ == _rhs.hnd_)); }

    /// Standard pre-increment operator
    void opAddAssign(uint i) 
    { assert(i==1); hnd_.__increment(); if (skip_bits_) skip_fwd(); /*return *this;*/ }

    /// Standard pre-decrement operator
    void opSubAssign(uint i) 
    { assert(i==1); hnd_.__decrement(); if (skip_bits_) skip_bwd(); /*return *this;*/ }
  

    /// Turn on skipping: automatically skip deleted/hidden elements
    void enable_skipping()
    {
        if (mesh_ && mesh_.has_face_status())
        {
            StatusInfo status;
            status.set_deleted(true);
            status.set_hidden(true);
            skip_bits_ = status.bits();
            skip_fwd();
        }
        else skip_bits_ = 0;
    }


    /// Turn on skipping: automatically skip deleted/hidden elements
    void disable_skipping() { skip_bits_ = 0; }

private:

    void skip_fwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() < cast(int) mesh_.n_faces()) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__increment();
    }


    void skip_bwd() 
    {
        assert(mesh_ && skip_bits_);
        while ((hnd_.idx() >= 0) && 
               (mesh_.status_ptr(hnd_).bits() & skip_bits_))
            hnd_.__decrement();
    }



private:
    Mesh      mesh_;
    value_handle  hnd_;
    uint  skip_bits_;
}


import std.io;
unittest
{
    float[] x = [1.0f,2,3,4,5];
    auto xit = array_iter_begin(x);
    auto xend = array_iter_end(x);
    for (; xit!=xend; ++xit) {
        writefln(xit.val);
    }
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
