//============================================================================
// VectorTypes.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   This instantiates a lot of common vector types.  
 * It adds about 25K of code with dmd/win so it's not imported by default.
 *
 * But, with this module you can easily get all the Vector stuff under one 
 * namespace with a renamed import: import vecs = auxd.OpenMesh.Core.Geometry.VectorTypes;
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 29 Aug 2007
 */
//============================================================================

module auxd.OpenMesh.Core.Geometry.VectorTypes;

public import auxd.linalg.VectorTypes;

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
