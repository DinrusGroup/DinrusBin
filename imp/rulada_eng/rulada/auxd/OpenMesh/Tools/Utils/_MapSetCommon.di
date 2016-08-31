/*==========================================================================
 * _MapSetCommon.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * Some common functionality used by the MapT and SetT types
 *
 * Authors:  William V. Baxter III, OLM Digital, Inc.
 * Date: 15 Oct 2007
 * Copyright: (C) 2007  William Baxter, OLM Digital, Inc.
 * License: ZLIB/LIBPNG
 */
//===========================================================================

module auxd.OpenMesh.Tools.Utils._MapSetCommon;
version(Tango) import std.compat;

class KeyException : Exception
{
    this(char[] msg) {
        super(msg);
    }
}

class invalid_iterator : Exception
{
    this(string msg) { super(msg); }
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
