/*==========================================================================
 * MeshTypes.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * <TODO: Module Summary>
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III
 * Date: 15 Nov 2007
 * Copyright: (C) 2007  William Baxter
 */
//===========================================================================

module MeshTypes;

//import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
//alias TriMesh_ArrayKernelT!() MyTriMesh;

import auxd.OpenMesh.Core.Mesh.PolyMesh_ArrayKernelT;
alias PolyMesh_ArrayKernelT!() MyPolyMesh;


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
