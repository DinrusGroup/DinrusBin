//============================================================================
// PropertyContainer.d - 
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 28 Aug 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================

module auxd.OpenMesh.Core.Utils.PropertyContainer;

import std.io;

/*===========================================================================*\
 *                                                                           *
 *                               OpenMesh                                    *
 *        Copyright (C) 2004 by Computer Graphics Group, RWTH Aachen         *
 *                           www.openmesh.org                                *
 *                                                                           *
 *---------------------------------------------------------------------------*
 *                                                                           *
 *                                License                                    *
 *                                                                           *
 *  This library is free software; you can redistribute it and/or modify it  *
 *  under the terms of the GNU Lesser General Public License as published    *
 *  by the Free Software Foundation, version 2.1.                            *
 *                                                                           *
 *  This library is distributed in the hope that it will be useful, but      *
 *  WITHOUT ANY WARRANTY; without even the implied warranty of               *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        *
 *  Lesser General Public License for more details.                          *
 *                                                                           *
 *  You should have received a copy of the GNU Lesser General Public         *
 *  License along with this library; if not, write to the Free Software      *
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.                *
 *                                                                           *
\*===========================================================================*/

import auxd.OpenMesh.Core.System.config;
public import auxd.OpenMesh.Core.Utils.Property;
import stdutil = auxd.OpenMesh.Core.Utils.Std;

//-----------------------------------------------------------------------------


//== CLASS DEFINITION =========================================================
/// A a container for properties.
///   PropHandleT is a template for handles, parameterized on property type.
///   It must be an alias here because it's not net a concrete type when passed in.
///   Use one of the types from auxd.OpenMesh.Core.Utils.Properties:
///       VPropHandle, HPropHandle, EPropHandle, FPropHandle, or MPropHandle
class PropertyContainer(alias PropHandleT)
{
public:

    //-------------------------------------------------- constructor / destructor

    this() {}
    ~this() {}


    //------------------------------------------------------------- info / access

    alias BaseProperty[] Properties;
    alias PropHandleT handle_template;

    /*const*/ Properties properties() /*const*/ { return properties_; }
    size_t size() /*const*/ { return properties_.length; }

    //--------------------------------------------------------- copy / assignment

    this(/*const*/ PropertyContainer _rhs) { this.set(_rhs); }

    PropertyContainer set(/*const*/ PropertyContainer _rhs)
    {
        clear();
        properties_.length = _rhs.properties_.length;
        foreach(i, prop; _rhs.properties_) {
            if (prop !is null) {
                properties_[i] = prop.dup();
                assert(properties_[i] !is prop);
            } else {
                properties_[i] = null;
            }
        }
        return this;
    }

    void copy(/*const*/ PropertyContainer _rhs) { 
        set(_rhs); 
    }


    //--------------------------------------------------------- manage properties

    PropHandleT!(T) add(T)(/*const*/ string _name="<unknown>")
    {
        int idx=0;
        foreach (ref p_it; properties_) {
            if (!p_it) { break; }
            idx++;
        }
        if (idx==properties_.length) properties_.length = idx+1;
        properties_[idx] = new PropertyT!(T)(_name);
        //std.io.writefln("Adding property %s, idx=", _name, idx);
        return PropHandleT!(T)(idx);
    }


    /** Lookup a property handle by name.  
     *  The template parameter T (the type of the property) must be provided explicitly. 
     */
    PropHandleT!(T) handle(T)(/*const*/ string _name) /*const*/
    {
        int idx = 0;
        foreach(prop; properties_)
        {
            if (prop !is null && prop.name == _name && //skip deleted properties
                cast(PropertyT!(T))prop !is null)//check type
            {
                return PropHandleT!(T)(idx);
            }
            ++idx;
        }
        return PropHandleT!(T)(); // invalid handle
    }

    BaseProperty property_by_name( /*const*/ string _name ) /*const*/
    {
        foreach(p_it; properties_) {
            if (p_it !is null && p_it.name == _name) //skip deleted properties
            {
                return p_it;
            }
        }
        // not found!
        return null;
    }

    PropertyT!(T) property(T)(PropHandleT!(T) _h)
    {
        //writefln("access property: h.idx: ", _h.idx);
        //writefln("properties.len: ", properties_.length);
        assert(_h.idx() >= 0 && _h.idx() < cast(int)properties_.length);
        assert(properties_[_h.idx()] !is null);
        PropertyT!(T) p = cast(PropertyT!(T))properties_[_h.idx()];
        version(release) {} else {
            assert(p !is null);
        }
        return p;
    }

    PropertyT!(T) opIndex(T)(PropHandleT!(T) _h) {
        return property!(T)(_h);
    }

    void opIndexAssign(T,S)(PropertyT!(T) _prop, PropHandleT!(S) _h) {
        assert(_h.idx() >= 0 && _h.idx() < cast(int)properties_.length);
        assert(properties_[_h.idx()] !is null);
        version(release) {} else {
            PropertyT!(T) p = cast(PropertyT!(T))properties_[_h.idx()];
            assert(p !is null);
        }
        properties_[_h.idx()] = _prop;
    }

    void set_property(T)(PropHandleT!(T) _h, PropertyT!(T) _prop) {
        assert(_h.idx() >= 0 && _h.idx() < cast(int)properties_.length);
        assert(properties_[_h.idx()] !is null);
        version(release) {} else {
            PropertyT!(T) p = cast(PropertyT!(T))properties_[_h.idx()];
            assert(p !is null);
        }
        properties_[_h.idx()] = _prop;
    }

/+
    /*const*/ PropertyT!(T) property(T)(PropHandleT!(T) _h) /*const*/
    {
        assert(_h.idx() >= 0 && _h.idx() < cast(int)properties_.length);
        assert(properties_[_h.idx()] !is null);
        auto p = cast(PropertyT!(T))(properties_[_h.idx()]);
        version(release) {} else {
            assert(p !is null);
        }
        return p;
    }
+/

    void remove(T)(PropHandleT!(T) _h)
    {
        assert(_h.idx() >= 0 && _h.idx() < cast(int)properties_.length);
        delete properties_[_h.idx()];
        properties_[_h.idx()] = null;
    }


    void clear()
    {
        foreach(ref p; properties_) {
            delete p;
            p = null;
        }
    }


    //---------------------------------------------------- synchronize properties

    void reserve(size_t _n) /*const*/ {
        foreach(ref p; properties_){
            if(p) p.reserve(_n);
        }
    }

    void resize(size_t _n) /*const*/ {
        foreach(ref p; properties_){
            if(p) p.resize(_n);
        }
    }

    void swap(size_t _i0, size_t _i1) /*const*/ {
        foreach(ref p; properties_){
            if(p) p.swap(_i0,_i1);
        }
    }


    int opApply(int delegate(ref BaseProperty) loop) {
        int N = properties_.length;
        for(size_t i=0; i<N; i++) {
            int ret = loop(properties_[i]);
            if (ret) return ret;
        }
        return 0;
    }
    int opApply(int delegate(ref size_t, ref BaseProperty) loop) {
        int N = properties_.length;
        for(size_t i=0; i<N; i++) {
            int ret = loop(i, properties_[i]);
            if (ret) return ret;
        }
        return 0;
    }



//protected:
    // generic add/get needed by BaseKernel 
    //but not meant for public consumption

    size_t _add( BaseProperty _bp )
    {
        size_t idx=0;
        foreach(p_it; properties_) {
            if (!p_it) break;
            idx++;
        }
        if (idx==properties_.length) properties_ ~= null;
        properties_[idx] = _bp;
        return idx;
    }

    BaseProperty _property( size_t _idx )
    {
        assert( _idx < properties_.length);
        assert( properties_[_idx] !is null);
        BaseProperty p = properties_[_idx];
        assert( p !is null );
        return p;
    }

/+
    /*const*/ BaseProperty _property( size_t _idx ) /*const*/
    {
        assert( _idx < properties_.length);
        assert( properties_[_idx] !is null);
        BaseProperty p = properties_[_idx];
        assert( p !is null );
        return p;
    }
+/
    alias stdutil.array_iterator!(Properties) iterator;
    //alias Properties.const_iterator const_iterator;
    iterator begin() { return stdutil.array_iter_begin(properties_); }
    iterator end()   { return stdutil.array_iter_end(properties_); }
    //const_iterator begin() /*const*/ { return properties_.begin(); }
    //const_iterator end() /*const*/   { return properties_.end(); }

private:

    Properties   properties_;
}

alias PropertyContainer!(VPropHandleT) VPropertyContainer;
alias PropertyContainer!(HPropHandleT) HPropertyContainer;
alias PropertyContainer!(EPropHandleT) EPropertyContainer;
alias PropertyContainer!(FPropHandleT) FPropertyContainer;
alias PropertyContainer!(MPropHandleT) MPropertyContainer;


//----------------------------------------------------------------------------

unittest {
    VPropertyContainer pc = new VPropertyContainer;
    //auto prop = new PropertyT!(float);
    auto prop_hdl = pc.add!(float)("something");

    auto prop = pc.property_by_name("something");
    std.io.writefln("typeof prop = ", typeof(prop).stringof);
    auto propT = pc.property(prop_hdl);
    std.io.writefln("typeof propT = ", typeof(propT).stringof);

    alias VPropertyContainer.iterator prop_iter;
    std.io.writefln("typeof iterator = ", VPropertyContainer.iterator.stringof);
    std.io.writefln("typeof iterator = ", prop_iter.stringof);


    pc.resize(10);

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
