//============================================================================
// DecimaterT.d - 
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

module auxd.OpenMesh.Tools.Decimater.DecimaterT;

/** \file DecimaterT.hh
 */

//=============================================================================
//
//  CLASS DecimaterT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.Utils.Std : erase_index;
import auxd.OpenMesh.Tools.Utils.HeapT;
import auxd.OpenMesh.Tools.Decimater.ModBaseT;
import auxd.OpenMesh.Tools.Decimater.CollapseInfoT;


//== CLASS DEFINITION =========================================================


/** Decimater framework.
    See_Also: BaseModT, \ref decimater_docu
*/
class DecimaterT(MeshT)
{
public: //-------------------------------------------------------- public types

    alias DecimaterT!( MeshT )       Self;
    alias MeshT                      Mesh;
    alias CollapseInfoT!(MeshT)      CollapseInfo;
    alias ModBaseT!(Self)            Module;
    alias Module[]                   ModuleList;

public: //------------------------------------------------------ public methods

    /// Constructor
    this( Mesh _mesh )
    {
        mesh_=(_mesh),
            cmodule_=(null),
            initialized_=(false);
        // default properties
        mesh_.request_vertex_status();
        mesh_.request_edge_status();
        mesh_.request_face_status();
        mesh_.request_face_normals();

        // private vertex properties
        mesh_.add_property( collapse_target_ );
        mesh_.add_property( priority_ );
        mesh_.add_property( heap_position_ );
    }        

    /// Destructor
    ~this() {
        // default properties
        /+
        mesh_.release_vertex_status();
        mesh_.release_edge_status();
        mesh_.release_face_status();
        mesh_.release_face_normals();

        // private vertex properties
        mesh_.remove_property(collapse_target_);
        mesh_.remove_property(priority_);
        mesh_.remove_property(heap_position_);

        // dispose modules
        {
            foreach(m_it; bmodules_) {
                delete m_it;
            }
            bmodules_.length = 0;
            if (cmodule_)
                delete cmodule_;
        }
        +/
    }


    /** Initialize decimater and decimating modules.

        Return values:
        true   ok
        false  No ore more than one non-binary module exist. In that case
        the decimater is uninitialized!
    */
    bool initialize()
    {
        Module quadric=null;

        cmodule_ = null;
        foreach(m_it; bmodules_) 
        {
            if ( m_it.name() == "Quadric")
                quadric = m_it;

            if ( ! m_it.is_binary() )
            {
                if ( !cmodule_ ) // only one non-binary module allowed!
                    cmodule_ = m_it;
                else
                    return false;
            }
            m_it.initialize();
        }

        if (!cmodule_) // one non-binary module is mandatory!
        {
            if (!quadric)
                return false;
            else
            {
                cmodule_ = quadric; // let the quadric become the priority module
            }
        }

        foreach(i,m; bmodules_) {
            if (m is cmodule_) {
                bmodules_.erase_index( i );
            }
        }

        return initialized_ = true;
    }


    /// Returns whether decimater has been successfully initialized.
    bool is_initialized() /*const*/ { return initialized_; }


    /// Print information about modules to _os
    void info( ostream _os ) {
        _os.writefln("binary modules: " ,bmodules_.length);
        foreach(m_it; bmodules_) {
            _os.writefln("  " , m_it.name() );
        }
        _os.writefln("priority module: ",
                     (cmodule_ ? cmodule_.name() : "<None>"));
        _os.writefln("is initialized : " , (initialized_ ? "yes" : "no") );

    }

public: //--------------------------------------------------- module management

    /// access mesh. used in modules.
    Mesh mesh() { return mesh_; }

    /// add module to decimater
    bool add(_Module)( ref ModHandleT!(_Module) _mh )
    {
        if (_mh.is_valid())
            return false;

        _mh.__init( new _Module(this) );
        bmodules_ ~=  _mh.__module() ;

        initialized_ = false;
        return true;
    }


    /// remove module
    bool remove(_Module)( ref ModHandleT!(_Module) _mh )
    {
        if (!_mh.is_valid())
            return false;

        ModuleList.iterator it = std.find(bmodules_.begin(),
                                          bmodules_.end(),
                                          _mh.__module() );

        if ( it == bmodules_.end() ) // module not found
            return false;

        delete it.val;
        bmodules_.erase( it ); // finally remove from list
        _mh.__clear();

        initialized_ = false; // reset initialized state
        return true;
    }


    /// get module referenced by handle _mh
    Module get_module(Module)( ref ModHandleT!(Module) _mh )
    {
        assert( _mh.is_valid() );
        return _mh.__module();
    }

public:

    /** Decimate (perform _n_collapses collapses). Return number of
        performed collapses. If _n_collapses is not given reduce as
        much as possible */
    size_t decimate( size_t _n_collapses = 0 )
    {
        if ( !is_initialized() )
            return 0;

        Mesh.VertexIter         v_it, v_end=(mesh_.vertices_end());
        Mesh.VertexHandle       vp;
        Mesh.HalfedgeHandle     v0v1;
        Mesh.VertexVertexIter   vv_it;
        Mesh.VertexFaceIter     vf_it;
        uint                    n_collapses=0;

        alias Mesh.VertexHandle[]  Support;

        Support support; 
        support.length=15;

        // check _n_collapses
        if (!_n_collapses) _n_collapses = mesh_.n_vertices();


        // initialize heap
        auto  HI = HeapInterface(mesh_, priority_, heap_position_);
        DeciHeap heap = DeciHeap(HI);
        heap.reserve(mesh_.n_vertices());

        for (v_it = mesh_.vertices_begin(); v_it != v_end; ++v_it)
        {
            heap.reset_heap_position( v_it.handle() );
            if (!mesh_.vstatus_ptr(v_it.handle).deleted())
                heap_vertex( v_it.handle(), heap );
        }


        // process heap
        while ((!heap.empty()) && (n_collapses < _n_collapses))
        {
            // get 1st heap entry
            vp   = heap.front();
            v0v1 = mesh_.property(collapse_target_, vp);
            heap.pop_front();


            // setup collapse info
            auto ci = CollapseInfo(mesh_, v0v1);


            // check topological correctness AGAIN !
            if (!is_collapse_legal(ci))
                continue;


            // store support (= one ring of *vp)
            vv_it = mesh_.vv_iter(ci.v0);
            support.length = 0;
            for (; vv_it.is_active; ++vv_it)
                support ~= vv_it.handle();


            // perform collapse
            mesh_.collapse(v0v1);
            ++n_collapses;


            // update triangle normals
            vf_it = mesh_.vf_iter(ci.v1);
            for (; vf_it.is_active; ++vf_it)
                if (!mesh_.fstatus_ptr(vf_it.handle).deleted())
                    mesh_.set_normal(vf_it.handle, mesh_.calc_face_normal(vf_it.handle()));


            // post-process collapse
            postprocess_collapse(ci);


            // update heap (former one ring of decimated vertex)
            foreach(s_it; support)
            {
                assert(!mesh_.status_ptr(s_it).deleted());
                heap_vertex(s_it,heap);
            }
        }


        // delete heap
        heap.clear();


        // DON'T do garbage collection here! It's up to the application.
        return n_collapses;

    }

    /// Decimate to target complexity, returns number of collapses
    size_t decimate_to( size_t  _n_vertices )
    {
        return ( (_n_vertices < mesh().n_vertices()) ?
                 decimate( mesh().n_vertices() - _n_vertices ) : 0 );
    }


private:

    void update_modules(ref CollapseInfo _ci)
    {
        foreach(m_it; bmodules_) {
            m_it.postprocess_collapse(_ci);
        }
        cmodule_.postprocess_collapse(_ci);
    }

public:

    alias Mesh.VertexHandle    VertexHandle;
    alias Mesh.HalfedgeHandle  HalfedgeHandle;

    /// Heap interface
    struct HeapInterface
    {
    public:
        
        static HeapInterface opCall(
            Mesh               _mesh,
            VPropHandleT!(float) _prio,
            VPropHandleT!(int)   _pos)
        { 
            HeapInterface M; with(M) {
                mesh_=(_mesh), prio_=(_prio), pos_=(_pos);
            } return M;
        }

        bool
        less( VertexHandle _vh0, VertexHandle _vh1 )
        { return mesh_.property(prio_, _vh0) < mesh_.property(prio_, _vh1); }

        bool
        greater( VertexHandle _vh0, VertexHandle _vh1 )
        { return mesh_.property(prio_, _vh0) > mesh_.property(prio_, _vh1); }

        int
        get_heap_position(VertexHandle _vh)
        { return mesh_.property(pos_, _vh); }

        void
        set_heap_position(VertexHandle _vh, int _pos)
        { *mesh_.property_ptr(pos_, _vh) = _pos; }


    private:
        Mesh                  mesh_;
        VPropHandleT!(float)  prio_;
        VPropHandleT!(int)    pos_;
    }

    alias HeapT!(VertexHandle, HeapInterface)  DeciHeap;


private: //---------------------------------------------------- private methods

    /// Insert vertex in heap
    void heap_vertex(VertexHandle _vh, ref DeciHeap heap)
    {
        //   std.clog << "heap_vertex: " << _vh << std.endl;

        float                 prio, best_prio=(float.max);
        Mesh.HalfedgeHandle   heh, collapse_target;


        // find best target in one ring
        auto voh_it=Mesh.VertexOHalfedgeIter(mesh_, _vh);
        for (; voh_it.is_active; ++voh_it)
        {
            heh = voh_it.handle();
            auto ci = CollapseInfo(mesh_, heh);

            if (is_collapse_legal(ci))
            {
                prio = collapse_priority(ci);
                if (prio >= 0.0 && prio < best_prio)
                {
                    best_prio       = prio;
                    collapse_target = heh;
                }
            }
        }

        // target found . put vertex on heap
        if (collapse_target.is_valid())
        {
            //     std.clog << "  added|updated" << std.endl;
            *mesh_.property_ptr(collapse_target_, _vh) = collapse_target;
            *mesh_.property_ptr(priority_, _vh)        = best_prio;

            if (heap.is_stored(_vh))  heap.update(_vh);
            else                      heap.insert(_vh);
        }

        // not valid . remove from heap
        else
        {
            //     std.clog << "  n/a|removed" << std.endl;
            if (heap.is_stored(_vh))  heap.remove(_vh);

            *mesh_.property_ptr(collapse_target_, _vh) = collapse_target;
            *mesh_.property_ptr(priority_, _vh)        = -1;
        }

    }


    /// Is an edge collapse legal?  Performs topological test only.
    /// The method evaluates the status bit Locked, Deleted, and Feature.
    /// \attention The method temporarily sets the bit Tagged. After usage
    ///            the bit will be disabled!
    bool is_collapse_legal(/*const*/ ref CollapseInfo _ci)
    {
        //   std.clog << "DecimaterT<>.is_collapse_legal()\n";

        // locked ? deleted ?
        if (mesh_.vstatus_ptr(_ci.v0).locked() ||
            mesh_.vstatus_ptr(_ci.v0).deleted())
            return false;
/*
  if (!mesh_.is_collapse_ok(_ci.v0v1))
  {
  return false;
  }
*/
        if (_ci.vl.is_valid() && _ci.vr.is_valid() &&
            mesh_.find_halfedge(_ci.vl, _ci.vr).is_valid() &&
            mesh_.valence(_ci.vl) == 3 && mesh_.valence(_ci.vr) == 3)
        {
            return false;
        }
        //--- feature test ---

        if (mesh_.status_ptr(_ci.v0).feature() &&
            !mesh_.estatus_ptr(mesh_.edge_handle(_ci.v0v1)).feature())
            return false;



        //--- test one ring intersection ---

        Mesh.VertexVertexIter  vv_it;

        for (vv_it = mesh_.vv_iter(_ci.v0); vv_it.is_active; ++vv_it)
            mesh_.vstatus_ptr(vv_it.handle).set_tagged(false);

        for (vv_it = mesh_.vv_iter(_ci.v1); vv_it.is_active; ++vv_it)
            mesh_.vstatus_ptr(vv_it.handle).set_tagged(true);

        for (vv_it = mesh_.vv_iter(_ci.v0); vv_it.is_active; ++vv_it)
            if (mesh_.vstatus_ptr(vv_it.handle).tagged() &&
                vv_it.handle() != _ci.vl &&
                vv_it.handle() != _ci.vr)
                return false;

        // if both are invalid OR equal . fail
        if (_ci.vl == _ci.vr) return false;


        //--- test boundary cases ---
        if (mesh_.is_boundary(_ci.v0))
        {
            if (!mesh_.is_boundary(_ci.v1))
            {// don't collapse a boundary vertex to an inner one
                return false;
            }
            else
            {// edge between two boundary vertices has to be a boundary edge
                if (!(mesh_.is_boundary(_ci.v0v1) || mesh_.is_boundary(_ci.v1v0)))
                    return false;
            }
            // only one one ring intersection
            if (_ci.vl.is_valid() && _ci.vr.is_valid())
                return false;
        }

        // v0vl and v1vl must not both be boundary edges
        if (_ci.vl.is_valid() &&
            mesh_.is_boundary(_ci.vlv1) &&
            mesh_.is_boundary(_ci.v0v1))
            return false;

        // v0vr and v1vr must not be both boundary edges
        if (_ci.vr.is_valid() &&
            mesh_.is_boundary(_ci.vrv0) &&
            mesh_.is_boundary(_ci.v1vr))
            return false;

        // there have to be at least 2 incident faces at v0
        if (mesh_.cw_rotated_halfedge_handle(
                mesh_.cw_rotated_halfedge_handle(_ci.v0v1)) == _ci.v0v1)
            return false;


        // collapse passed all tests . ok
        return true;

    }


    /// Calculate priority of an halfedge collapse (using the modules)
    float collapse_priority(/*const*/ ref CollapseInfo _ci)
    {
        foreach(m_it; bmodules_) 
        {
            if ( m_it.collapse_priority(_ci) < 0.0)
                return -1.0; // ILLEGAL_COLLAPSE
        }
        return cmodule_.collapse_priority(_ci);
    }

    /// Post-process a collapse
    void postprocess_collapse(ref CollapseInfo _ci)
    {
        foreach(m_it; bmodules_) {
            m_it.postprocess_collapse(_ci);
        }
        cmodule_.postprocess_collapse(_ci);
    }





private: //------------------------------------------------------- private data


    // reference to mesh
    Mesh      mesh_;

    // list of modules
    ModuleList bmodules_;
    Module     cmodule_;

    bool       initialized_;


    // vertex properties
    VPropHandleT!(HalfedgeHandle)  collapse_target_;
    VPropHandleT!(float)           priority_;
    VPropHandleT!(int)             heap_position_;



private: // Noncopyable

    /+
    DecimaterT(/*const*/ Self&);
    Self& operator = (/*const*/ Self&);
    +/
}

version (Unittest)
{
    import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
}

unittest {
    version(Unittest) {
        alias TriMesh_ArrayKernelT!() MyMesh;
        alias DecimaterT!(MyMesh) MyDecimater;

        auto mesh = new MyMesh;
        auto deci = new MyDecimater(mesh);
    }
    else {
        static assert(false, "This unittest requires -version=Unittest");
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
