//============================================================================
// ModProgMeshT.d - 
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

module auxd.OpenMesh.Tools.Decimater.ModProgMeshT;

/** \file ModProgMeshT.hh
 */


//=============================================================================
//
//  CLASS ModProgMeshT - IMPLEMENTATION
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.Decimater.ModBaseT;
import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.Utils.vector_cast;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.IO.BinaryHelper;
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.Utils.Endian;


//== CLASS DEFINITION =========================================================


/** Collect progressive mesh information while decimating.
 *
 *  The progressive mesh data is stored in an internal structure, which
 *  can be evaluated after the decimation process and (!) before calling
 *  the garbage collection of the decimated mesh.
 */
class ModProgMeshT(DecimaterType) : public ModBaseT!(DecimaterType)
{
public:

    mixin DECIMATING_MODULE!( DecimaterType, "ProgMesh" );

    /** Struct storing progressive mesh information
     *  See_Also: CollapseInfoT, ModProgMeshT
     */
    struct Info
    {
        /// Initializing constructor copies appropriate handles from
        /// collapse information \c _ci.
        static Info opCall( /*const*/ ref CollapseInfo _ci ) {
            Info M; with (M) {
                v0=(_ci.v0);
                v1=(_ci.v1);
                vl=(_ci.vl);
                vr=(_ci.vr);
            } return M;
        }

        Mesh.VertexHandle v0; ///< See CollapseInfoT.v0
        Mesh.VertexHandle v1; ///< See CollapseInfoT.v1
        Mesh.VertexHandle vl; ///< See CollapseInfoT.vl
        Mesh.VertexHandle vr; ///< See CollapseInfoT.vr

    }

    /// Type of the list storing the progressive mesh info Info.
    alias Info[]           InfoList;


  public:

    /// Constructor
    this( DecimaterType _dec ) 
    {
        super(_dec, true);
        super.mesh().add_property( idx_ );
    }


    /// Destructor
    ~this()
    {
        //super.mesh().remove_property( idx_ );
    }

    /*const*/ InfoList  pmi() /*const*/
    {
        return pmi_;
    }

  public: // inherited


    /// Stores collapse information in a queue.
    /// See_Also: infolist()
    void postprocess_collapse(/*const*/ ref CollapseInfo _ci)
    {
        pmi_ ~= Info( _ci ) ;
    }


    bool is_binary() /*const*/ { return true; }


public: // specific methods

    /** Write progressive mesh data to a file in proprietary binary format .pm.
     *
     *  The methods uses the collected data to write a progressive mesh
     *  file. It's a binary format with little endian byte ordering:
     *
     *  - The first 8 bytes contain the word "ProgMesh".
     *  - 32-bit int for the number of vertices \c NV in the base mesh.
     *  - 32-bit int for the number of faces in the base mesh.
     *  - 32-bit int for the number of halfedge collapses (now vertex splits)
     *  - Positions of vertices of the base mesh (32-bit float triplets).<br>
     *    \c [x,y,z][x,y,z]...
     *  - Triplets of indices (32-bit int) for each triangle (index in the
     *    list of vertices of the base mesh defined by the positions.<br>
     *    \c [v0,v1,v2][v0,v1,v2]...
     *  - For each collapse/split a detail information package made of
     *    3 32-bit floats for the positions of vertex \c v0, and 3 32-bit
     *    int indices for \c v1, \c vl, and \c vr.
     *    The index for \c vl or \c vr might be -1, if the face on this side
     *    of the edge does not exists.
     *
     *  \remark Write file before calling the garbage collection of the mesh.
     *  \param _ofname Name of the file, where to write the progressive mesh
     *  \return \c true on success of the operation, else \c false.
     */
    bool write( /*const*/ string _ofname ) {
        // sort vertices
        size_t i=0, N=super.mesh().n_vertices(), n_base_vertices=(0), n_base_faces=(0);
        Mesh.VertexHandle[]  vhandles; vhandles.length=N;


        // base vertices
        Mesh.VertexIter 
            v_it=super.mesh().vertices_begin(), 
            v_end=super.mesh().vertices_end();

        for (; v_it != v_end; ++v_it)  
            if (!super.mesh().vstatus_ptr(v_it.handle).deleted()) 
            {
                vhandles[i] = v_it.handle();  
                *super.mesh().property_ptr( idx_, v_it.handle ) = i;  
                ++i;
            }
        n_base_vertices = i;


        // deleted vertices
        foreach_reverse(r_it; pmi_) 
        { 
            vhandles[i] = r_it.v0;  
            *super.mesh().property_ptr( idx_, r_it.v0) = i;  
            ++i;
        }


        // base faces
        Mesh./*Const*/FaceIter f_it  = super.mesh().faces_begin(),
            f_end = super.mesh().faces_end();
        for (; f_it != f_end; ++f_it) 
            if (!super.mesh().fstatus_ptr(f_it.handle).deleted()) 
                ++n_base_faces;

        // ---------------------------------------- write progressive mesh

        scope ostream fout = new BufferedFile( _ofname, FileMode.Out /*binary?*/ );
    
        if (!fout)
            return false;   

        // always use little endian byte ordering
        bool swap = Endian.local() != Endian.LSB;

        // write header
        fout.writeString("ProgMesh");
        IO.store( fout, n_base_vertices, swap );
        IO.store( fout, n_base_faces   , swap );
        IO.store( fout, pmi_.length    , swap );

        Vec3f p;

        // write base vertices
        for (i=0; i<n_base_vertices; ++i)
        {
            assert (!super.mesh().vstatus_ptr(vhandles[i]).deleted());
            p  = vector_cast!( Vec3f )( super.mesh().point(vhandles[i]) );
    
            IO.store( fout, p, swap );
        }
    

        // write base faces
        for (f_it=super.mesh().faces_begin(); f_it != f_end; ++f_it)  
        {
            if (!super.mesh().fstatus_ptr(f_it.handle).deleted()) 
            {
                auto fv_it = Mesh.ConstFaceVertexIter (super.mesh(), f_it.handle());
      
                IO.store( fout, *super.mesh().property_ptr( idx_,   fv_it.handle ) ); ++fv_it;
                IO.store( fout, *super.mesh().property_ptr( idx_,   fv_it.handle ) ); ++fv_it;
                IO.store( fout, *super.mesh().property_ptr( idx_,   fv_it.handle ) );
            }
        }
  
  
        // write detail info
        foreach_reverse(r_it; pmi_)
        { 
            // store v0.pos, v1.idx, vl.idx, vr.idx
            IO.store( fout, vector_cast!(Vec3f)(super.mesh().point(r_it.v0)));
            IO.store( fout, super.mesh().property( idx_, r_it.v1 ) );
            IO.store( fout, 
                      r_it.vl.is_valid() ? super.mesh().property(idx_, r_it.vl) : -1 );
            IO.store( fout, 
                      r_it.vr.is_valid() ? super.mesh().property(idx_, r_it.vr) : -1 );
        }

        return true;

    }
    /// Reference to collected information
    /*const*/ InfoList infolist() /*const*/ { return pmi_; }

  private:

    // hide this method form user
    void set_binary(bool _b) {}

    InfoList           pmi_;
    VPropHandleT!(int) idx_;
}

//== IMPLEMENTATION ========================================================== 



unittest {

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
