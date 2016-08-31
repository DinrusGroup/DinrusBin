//============================================================================
// api.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 28 Aug 2007
 * Copyright: (C) 2007-2008 William Baxter, OLM Digital, Inc.
 * License: ZLIB/LIBPNG
 */
//============================================================================

module auxd.OpenMesh.Core.Mesh.api;


public import auxd.OpenMesh.Core.Mesh.Traits;
alias auxd.OpenMesh.Core.Mesh.Traits.DefaultTraits DefaultTraits;

public import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
public import auxd.OpenMesh.Core.Mesh.PolyMesh_ArrayKernelT;
public import auxd.OpenMesh.Core.Mesh.IteratorsT;
public import auxd.OpenMesh.Core.Mesh.CirculatorsT;

public import auxd.OpenMesh.Core.Geometry.api;



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
