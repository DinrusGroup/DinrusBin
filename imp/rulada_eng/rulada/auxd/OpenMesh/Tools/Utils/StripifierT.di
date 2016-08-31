//============================================================================
// StripifierT.d - 
//    Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III, OLM Digital, Inc.
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

module auxd.OpenMesh.Tools.Utils.StripifierT;
import std.io;

//=============================================================================
//
//  CLASS StripifierT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.Utils.Std;
import auxd.OpenMesh.Tools.Utils.ListT;

//== FORWARDDECLARATIONS ======================================================


//== CLASS DEFINITION =========================================================

	      
/** \class StripifierT StripifierT.hh <OpenMesh/Tools/Utils/StripifierT.hh>
    This class decomposes a triangle mesh into several triangle strips.
*/

class StripifierT(Mesh)
{
public:
   
    alias uint                    Index;
    alias Index[]                 Strip;
    alias Strip[]                 Strips;
    alias array_iterator!(Strip)  IndexIterator;
    alias array_iterator!(Strips) StripsIterator;


    /// Default constructor
    this(Mesh _mesh) {  mesh_ = _mesh; }


    /// Compute triangle strips, returns number of strips
    uint stripify()
    {
        // preprocess:  add new properties
        mesh_.add_property( processed_ );
        mesh_.add_property( used_ ); 
        mesh_.request_face_status();
  
  
        // build strips
        clear();
        build_strips();
  
        // postprocess:  remove properties
        //mesh_.remove_property(processed_);
        //mesh_.remove_property(used_);
        //mesh_.release_face_status();
  
  
        return n_strips();
    }

    /// delete all strips
    void clear() {  
        strips_.length = 0;
    }

    /// returns number of strips
    uint n_strips() /*const*/ { return strips_.length; }

    /// are strips computed?
    bool is_valid() /*const*/ { return !strips_.empty(); }

    /// Access strips
    StripsIterator begin() /*const*/ { return array_iter_begin(strips_); }
    /// Access strips
    StripsIterator end()   /*const*/ { return array_iter_end(strips_); }


private:

    alias Mesh.FaceHandle[]  FaceHandles;


    /// this method does the main work
    void build_strips() 
    {
        Strip[3]                experiments;
        Mesh.HalfedgeHandle[3]  h;
        uint                    best_idx, best_length, length;
        FaceHandles[3]          faces;
        Mesh.FaceIter           f_it, f_end=mesh_.faces_end();
  
  
  
        // init faces to be un-processed and un-used
        // deleted or hidden faces are marked processed
        if (mesh_.has_face_status())
        {
            for (f_it=mesh_.faces_begin(); f_it!=f_end; ++f_it)
                if (mesh_.fstatus_ptr(f_it.handle).hidden() || mesh_.fstatus_ptr(f_it.handle).deleted()) {
                    *processed_ptr(f_it.handle) = *used_ptr(f_it.handle) = true;
                }
                else {
                    *processed_ptr(f_it.handle) = *used_ptr(f_it.handle) = false;
                }
        }
        else
        {
            for (f_it=mesh_.faces_begin(); f_it!=f_end; ++f_it)
                *processed_ptr(f_it.handle) = *used_ptr(f_it.handle) = false;
        }
  
  
  
        for (f_it=mesh_.faces_begin(); true; )
        {
            // find start face
            for (; f_it!=f_end; ++f_it)
                if (!processed(f_it.handle))
                    break;
            if (f_it==f_end) break; // stop if all have been processed
    
    
            // collect starting halfedges
            h[0] = mesh_.halfedge_handle(f_it.handle());
            h[1] = mesh_.next_halfedge_handle(h[0]);
            h[2] = mesh_.next_halfedge_handle(h[1]);
    
    
            // build 3 strips, take best one
            best_length = best_idx = 0;
            for (uint i=0; i<3; ++i)
            {
                build_strip(h[i], experiments[i], faces[i]);
                if ((length = experiments[i].length) > best_length) 
                {
                    best_length = length;
                    best_idx    = i;
                }
      
                foreach(fh_it; faces[i]) {
                    *used_ptr(fh_it) = false;
                }
            }
    
    
            // update processed status
            foreach(fh_it; faces[best_idx]) {
                *processed_ptr(fh_it) = true;
            }    
    
    
            // add best strip to strip-list
            //writefln("push strip");
            strips_ ~= experiments[best_idx].dup;
        }
    }

    /// build a strip from a given halfedge (in both directions)
    void build_strip(Mesh.HalfedgeHandle _start_hh,
                     ref Strip _strip,
                     ref FaceHandles _faces)
    {
        ListT!(uint)          strip;
        Mesh.HalfedgeHandle   hh;
        Mesh.FaceHandle       fh;
  
  
        // reset face list
        _faces.length = 0;
  
  
        // init strip
        strip ~= (mesh_.from_vertex_handle(_start_hh).idx());
        strip ~= (mesh_.to_vertex_handle(_start_hh).idx());
  
  
        // walk along the strip: 1st direction
        hh = mesh_.prev_halfedge_handle(mesh_.opposite_halfedge_handle(_start_hh));
        while (1)
        {
            // go right
            hh = mesh_.next_halfedge_handle(hh);
            hh = mesh_.opposite_halfedge_handle(hh);
            hh = mesh_.next_halfedge_handle(hh);
            if (mesh_.is_boundary(hh)) break;
            fh = mesh_.face_handle(hh);
            if (processed(fh) || used(fh)) break; 
            _faces.push_back(fh);
            *used_ptr(fh) = true;
            strip ~= (mesh_.to_vertex_handle(hh).idx());
    
            // go left
            hh = mesh_.opposite_halfedge_handle(hh);
            hh = mesh_.next_halfedge_handle(hh);
            if (mesh_.is_boundary(hh)) break;
            fh = mesh_.face_handle(hh);
            if (processed(fh) || used(fh)) break; 
            _faces.push_back(fh);
            *used_ptr(fh) = true;
            strip ~= (mesh_.to_vertex_handle(hh).idx());
        }
  
  
        // walk along the strip: 2nd direction
        bool flip = false;
        hh = mesh_.prev_halfedge_handle(_start_hh);
        while (1)
        {
            // go right
            hh = mesh_.next_halfedge_handle(hh);
            hh = mesh_.opposite_halfedge_handle(hh);
            hh = mesh_.next_halfedge_handle(hh);
            if (mesh_.is_boundary(hh)) break;
            fh = mesh_.face_handle(hh);
            if (processed(fh) || used(fh)) break; 
            _faces.push_back(fh);
            *used_ptr(fh) = true;
            strip.prepend(mesh_.to_vertex_handle(hh).idx());
            flip = true;
    
            // go left
            hh = mesh_.opposite_halfedge_handle(hh);
            hh = mesh_.next_halfedge_handle(hh);
            if (mesh_.is_boundary(hh)) break;
            fh = mesh_.face_handle(hh);
            if (processed(fh) || used(fh)) break; 
            _faces.push_back(fh);
            *used_ptr(fh) = true;
            strip.prepend(mesh_.to_vertex_handle(hh).idx());
            flip = false;
        }
  
        if (flip) strip.prepend(strip.front());
  
  
        // copy final strip to _strip
        _strip.length = strip.length;
        _strip.length = 0;
        foreach(el; strip) {
            _strip ~= el;
        }
    }

    FPropHandleT!(bool).value_type  processed(Mesh.FaceHandle _fh) {
        return mesh_.property(processed_, _fh);
    }
    FPropHandleT!(bool).value_type  used(Mesh.FaceHandle _fh) {
        return mesh_.property(used_, _fh);
    }
    FPropHandleT!(bool).pointer  processed_ptr(Mesh.FaceHandle _fh) {
        return mesh_.property_ptr(processed_, _fh);
    }
    FPropHandleT!(bool).pointer  used_ptr(Mesh.FaceHandle _fh) {
        return mesh_.property_ptr(used_, _fh);
    }



private:

    Mesh                  mesh_;
    Strips                strips_;
    FPropHandleT!(bool)   processed_, used_;
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
