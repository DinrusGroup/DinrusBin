//============================================================================
// list.d -  Linked list data structure 
//
// Description: 
//   A doubly linked list data structure based originally on the one in 
//   ArcLib (but I extracted the iterators from the class)
//
// Author:  William V. Baxter III
// Created: 04 Sep 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================

/**
 *  Linked list data strcuture.
 *  Deprecated:  use auxd.OpenMesh.Tools.Utils.ListT instead.
 */

module auxd.OpenMesh.Core.Utils.list;

import auxd.OpenMesh.Tools.Utils.ListT;

alias auxd.OpenMesh.Tools.Utils.ListT.ListT list;


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
