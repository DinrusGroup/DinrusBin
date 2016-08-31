//============================================================================
// api.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 01 Sep 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 */
//============================================================================

module auxd.OpenMesh.Tools.Decimater.api;

public import auxd.OpenMesh.Tools.Decimater.DecimaterT;
public import auxd.OpenMesh.Tools.Decimater.CollapseInfoT;
public import auxd.OpenMesh.Tools.Decimater.ModBaseT;
public import auxd.OpenMesh.Tools.Decimater.ModIndependentSetsT;
public import auxd.OpenMesh.Tools.Decimater.ModNormalFlippingT;
public import auxd.OpenMesh.Tools.Decimater.ModProgMeshT;
public import auxd.OpenMesh.Tools.Decimater.ModQuadricT;
public import auxd.OpenMesh.Tools.Decimater.ModRoundnessT;


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
