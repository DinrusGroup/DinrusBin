/*==========================================================================
 * process.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * <TODO: Module Summary>
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III
 * Date: 10 Dec 2007
 * Copyright: (C) 2007  William Baxter
 */
//===========================================================================

module std2.process;

//version(Tango) import std.compat;
public import std.process;

version (Windows)
{
    // GetCurrentProcessId was added to D2's os.windows file.
    private {
        import os.windows : DWORD;  
        extern (Windows) export DWORD GetCurrentProcessId();
    }
}


version(linux)
{
    alias std.c.getpid getpid;
}
else version (Windows)
{
    //alias os.windows.GetCurrentProcessId getpid;
    alias GetCurrentProcessId getpid;
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
