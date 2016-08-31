//============================================================================
// casts.d - 
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 01 Sep 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================
// $Id:$
//============================================================================

module auxd.OpenMesh.Core.Utils.casts;

public import auxd.OpenMesh.Core.Utils.color_cast;
public import auxd.OpenMesh.Core.Utils.vector_cast;



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
