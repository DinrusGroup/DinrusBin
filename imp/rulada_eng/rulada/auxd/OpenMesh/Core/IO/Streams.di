//============================================================================
// Streams.d - Stream-based IO layer.
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   Stream IO include for auxd.OpenMesh.
 *   Defines compatibility stuff for porting OpenMesh to D.
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 30 Aug 2007
 * Copyright: (C) 2007-2008 William Baxter, OLM Digital, Inc.
 * License: ZLIB/LIBPNG
 */
//============================================================================

module auxd.OpenMesh.Core.IO.Streams;

public import std.cstream;
public import std.stream;

alias OutputStream ostream;
alias InputStream istream;

alias std.cstream.dout dlog;
alias std.cstream.dout dout;
alias std.cstream.derr derr;

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
