/*==========================================================================
 * DrawerTypes.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * This only exists to work around a bug in OPTLINK
 * http://d.puremagic.com/issues/show_bug.cgi?id=424
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Date: 15 Nov 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 */
//===========================================================================

module DrawerTypes;

import MeshTypes;
import MeshDrawerT;

//alias MeshDrawerT.MeshDrawerT!(MyTriMesh) MeshTriDrawer;
alias MeshDrawerT.MeshDrawerT!(MyPolyMesh) MeshPolyDrawer;





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
