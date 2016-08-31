//============================================================================
// Exceptions.d - Exception classes
//
// Description: 
//   Provides some of the exceptions from C++'s stdexcept header used by
//   auxd.OpenMesh.  Adds not_implemented_error to those.
//
// Author:  William V. Baxter III
// Created: 30 Aug 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================
// $Id:$
//============================================================================

module auxd.OpenMesh.Core.Utils.Exceptions;

import auxd.OpenMesh.Core.System.config;

class not_implemented_error : Error
{
    this(string msg) { super(msg); }
}

class runtime_error : Error
{
    this(string msg) { super(msg); }
}

class logic_error : Error
{
    this(string msg) { super(msg); }
}



class invalid_argument : logic_error
{
    this(string msg) { super(msg); }
}

class length_error : logic_error
{
    this(string msg) { super(msg); }
}

class out_of_range : logic_error
{
    this(string msg) { super(msg); }
}


class range_error : runtime_error
{
    this(string msg) { super(msg); }
}
class overflow_error : runtime_error
{
    this(string msg) { super(msg); }
}
class underflow_error : runtime_error
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
