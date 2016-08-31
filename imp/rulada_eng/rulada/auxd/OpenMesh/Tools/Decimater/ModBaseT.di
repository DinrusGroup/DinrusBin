//============================================================================
// ModBaseT.d -
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description:
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 31 Aug 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License:
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation, version 2.1.
 *                                                                           
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *                                                                           
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
//============================================================================

module auxd.OpenMesh.Tools.Decimater.ModBaseT;

/** \file ModBaseT.hh
    Base class for all decimation modules.
 */

//=============================================================================
//
//  CLASS ModBaseT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.Decimater.CollapseInfoT;


//== FORWARD DECLARATIONS =====================================================

//class DecimaterT!(Mesh);


//== CLASS DEFINITION =========================================================

/** Handle for mesh decimation modules
    \internal
 */
struct ModHandleT(Module)
{
public:

    alias ModHandleT!(Module) Self;
    alias Module module_type;

public:

    /// Check handle status
    /// \return \c true, if handle is valid, else \c false.
    bool is_valid() /*const*/ { return mod_ !is null; }

public:
    // NOTE: These should only be called by DecimaterT
    // In the C++ version DecimaterT was a friend class
    // Here we just prefix with  __ to ward off the unwary.
    void     __clear()           { mod_ = null; }
    void     __init(Module _m)   { mod_ = _m;   }
    Module   __module()          { return mod_; }

private:

    Module mod_ =null;
}




//== CLASS DEFINITION =========================================================



/// Macro that sets up the name() function
/// \internal
template DECIMATER_MODNAME(string _mod_name) {
    /*const*/ string name() /*const*/ {
        return _mod_name;
    }
}


/** Convenience macro, to be used in derived modules
 *  The macro defines the types
 *  - \c Handle, type of the module's handle.
 *  - \c Base,   type of ModBaseT<>.
 *  - \c Mesh,   type of the associated mesh passed by the decimater type.
 *  - \c CollapseInfo,  to your convenience
 *  and uses DECIMATER_MODNAME() to define the name of the module.
 *
 *  \param Classname  The name of the derived class.
 *  \param DecimaterT Pass here the decimater type, which is the
 *                    template parameter passed to ModBaseT.
 *  \param Name       Give the module a name.
 */
template DECIMATING_MODULE(alias DecimaterT, string Name)
{
    alias typeof(this) Self;
    alias auxd.OpenMesh.Tools.Decimater.ModBaseT.ModHandleT!( Self )          Handle;
    alias auxd.OpenMesh.Tools.Decimater.ModBaseT.ModBaseT!( DecimaterT )      Base;
    alias Base.Mesh         Mesh;
    alias Base.CollapseInfo CollapseInfo;
    //mixin DECIMATER_MODNAME!( Name );
    /*const*/ string name() /*const*/ {
        return Name;
    }
}



//== CLASS DEFINITION =========================================================


/** Base class for all decimation modules.

    Each module has to implement this interface.
    To build your own module you have to
    -# derive from this class.
    -# create the basic settings with DECIMATING_MODULE().
    -# override collapse_priority(), if necessary.
    -# override initialize(), if necessary.
    -# override postprocess_collapse(), if necessary.

    A module has two major working modes:
    -# binary mode
    -# non-binary mode

    In the binary mode collapse_priority() checks a constraint and
    returns LEGAL_COLLAPSE or ILLEGAL_COLLAPSE.

    In the non-binary mode the module computes a float error value in
    the range [0, inf) and returns it. In the case a constraint has
    been set, e.g. the error must be lower than a upper bound, and the
    constraint is violated, collapse_priority() must return
    ILLEGAL_COLLAPSE.

    See_Also: collapse_priority()

    \todo "Tutorial on building a custom decimation module."

*/
class ModBaseT(DecimaterType)
{
public:

    alias DecimaterType.Mesh        Mesh;
    alias CollapseInfoT!(Mesh)      CollapseInfo;

    enum {
        ILLEGAL_COLLAPSE = -1, ///< indicates an illegal collapse
        LEGAL_COLLAPSE   = 0   ///< indicates a legal collapse
    }

protected:

    /// Default constructor
    /// See_Also: \ref decimater_docu
    this(ref DecimaterType _dec, bool _is_binary)
    {
        dec_=(_dec); is_binary_=(_is_binary);
    }

public:

    /// Virtual desctructor
    ~this() { }

    /// Set module's name (using DECIMATER_MODNAME macro)
    mixin DECIMATER_MODNAME!("ModBase");


    /// Returns true if criteria returns a binary value.
    bool is_binary() /*const*/ { return is_binary_; }

    /// Set whether module is binary or not.
    void set_binary(bool _b)   { is_binary_ = _b; }


public: // common interface

    /// Initialize module-internal stuff
    void initialize() { }

    /** Return collapse priority.
     *
     *  In the binary mode collapse_priority() checks a constraint and
     *  returns LEGAL_COLLAPSE or ILLEGAL_COLLAPSE.
     *
     *  In the non-binary mode the module computes a float error value in
     *  the range [0, inf) and returns it. In the case a constraint has
     *  been set, e.g. the error must be lower than a upper bound, and the
     *  constraint is violated, collapse_priority() must return
     *  ILLEGAL_COLLAPSE.
     *
     *  \return Collapse priority in the range [0,inf),
     *          \c LEGAL_COLLAPSE or \c ILLEGAL_COLLAPSE.
     */
    float collapse_priority(/*const*/ ref CollapseInfoT!(Mesh) _ci)
    { return LEGAL_COLLAPSE; }

    /** After _from_vh has been collapsed into _to_vh, this method
        will be called.
    */
    void postprocess_collapse(/*const*/ ref CollapseInfoT!(Mesh) _ci)
    {}



protected:

    /// Access the mesh associated with the decimater.
    Mesh mesh() { return dec_.mesh(); }

private:

/+
    // hide copy constructor & assignemnt
    ModBaseT(const ModBaseT& _cpy);
    ModBaseT& operator=(const ModBaseT& );
+/
    // reference to decimater
    DecimaterType dec_;

    bool is_binary_;
}


unittest {

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
