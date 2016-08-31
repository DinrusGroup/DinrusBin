//============================================================================
// api.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 05 Sep 2007
 * Copyright: (C) 2007-2008 William Baxter, OLM Digital, Inc.
 */
//============================================================================

module auxd.OpenMesh.Core.Geometry.api;

public import auxd.OpenMesh.Core.Geometry.VectorTypes; // pulls in VectorT too
public import math = auxd.OpenMesh.Core.Geometry.MathDefs;


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
