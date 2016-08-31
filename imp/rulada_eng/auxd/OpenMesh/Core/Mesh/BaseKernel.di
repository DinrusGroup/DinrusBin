//============================================================================
// BaseKernel.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 28 Aug 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License: LGPL 2.1
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

module auxd.OpenMesh.Core.Mesh.BaseKernel;

import std.io;


//=============================================================================
//
//  CLASS BaseKernel
//
//=============================================================================



//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.PropertyContainer;
import auxd.OpenMesh.Core.Mesh.Handles;


//== CLASS DEFINITION =========================================================

/// This class provides the basic property management like adding/removing
/// properties and access to properties.
/// All operations provided by %BaseKernel need at least a property handle
/// (VPropHandleT, EPropHandleT, HPropHandleT, FPropHandleT, MPropHandleT).
/// which keeps the data type of the property, too.
///
/// There are two types of properties:
/// -# Standard properties - mesh data (e.g. vertex normal or face color)
/// -# Custom properties - user defined data
///
/// The differentiation is only semantically, technically both are
/// equally handled. Therefore the methods provided by the %BaseKernel
/// are applicable to both property types.
///
/// \attention Since the class PolyMeshT derives from a kernel, hence all public
/// elements of %BaseKernel are usable.

class BaseKernel
{
public: //-------------------------------------------- constructor / destructor

    this() {
        vprops_ = new VPropertyContainer;
        hprops_ = new HPropertyContainer;
        eprops_ = new EPropertyContainer;
        fprops_ = new FPropertyContainer;
        mprops_ = new MPropertyContainer;
    }

    /** Deep copy 'other' over top top of 'this' */
    void copy(BaseKernel other) 
    {
        vprops_.copy(other.vprops_);
        hprops_.copy(other.hprops_);
        eprops_.copy(other.eprops_);
        fprops_.copy(other.fprops_);
        mprops_.copy(other.mprops_);
    }


public: //-------------------------------------------------- add new properties

    /// \name Add a property to a mesh item

    //@{

    /** Adds a property
     *
     *  Depending on the property handle type a vertex, (half-)edge, face or
     *  mesh property is added to the mesh. If the action fails the handle
     *  is invalid.
     *  On success the handle must be used to access the property data with
     *  property().
     *
     *  \param  _ph   A property handle defining the data type to bind to mesh.
     *                On success the handle is valid else invalid.
     *  \param  _name Optional name of property. Following restrictions apply
     *                to the name:
     *                -# Maximum length of name is 256 characters
     *                -# The prefixes matching "^[vhefm]:" are reserved for
     *                   internal usage.
     *                -# The expression "^<.*>$" is reserved for internal usage.
     *  \return \c true on success else \c false.
     *
     */

    void add_property(T)( ref VPropHandleT!(T) _ph, /*const*/ string _name="<vprop>")
    {
        _ph =  vprops_.add!(T)(_name);
        //writefln("vprophandle idx now: ", _ph.idx());
        vprops_.resize(n_vertices());
    }

    void add_property(T)( ref HPropHandleT!(T) _ph, /*const*/ string _name="<hprop>")
    {
        _ph = hprops_.add!(T)(_name);
        hprops_.resize(n_halfedges());
    }

    void add_property(T)( ref EPropHandleT!(T) _ph, /*const*/ string _name="<eprop>")
    {
        _ph = eprops_.add!(T)(_name);
        eprops_.resize(n_edges());
    }

    void add_property(T)( ref FPropHandleT!(T) _ph, /*const*/ string _name="<fprop>")
    {
        _ph = fprops_.add!(T)(_name);
        fprops_.resize(n_faces());
    }

    void add_property(T)( ref MPropHandleT!(T) _ph, /*const*/ string _name="<mprop>")
    {
        _ph = mprops_.add!(T)(_name);
        mprops_.resize(1);
    }

    //@}


public: //--------------------------------------------------- remove properties

    /// \name Removing a property from a mesh tiem
    //@{

    /** Remove a property.
     *
     *  Removes the property represented by the handle from the apropriate
     *  mesh item.
     *  \param _ph Property to be removed. The handle is invalid afterwords.
     */

    void remove_property(T)(ref VPropHandleT!(T) _ph)
    {
        if (_ph.is_valid())
            vprops_.remove!(T)(_ph);
        _ph.reset();
    }

    void remove_property(T)(ref HPropHandleT!(T) _ph)
    {
        if (_ph.is_valid())
            hprops_.remove!(T)(_ph);
        _ph.reset();
    }

    
    void remove_property(T)(ref EPropHandleT!(T) _ph)
    {
        if (_ph.is_valid())
            eprops_.remove!(T)(_ph);
        _ph.reset();
    }

    
    void remove_property(T)(ref FPropHandleT!(T) _ph)
    {
        if (_ph.is_valid())
            fprops_.remove!(T)(_ph);
        _ph.reset();
    }

    
    void remove_property(T)(ref MPropHandleT!(T) _ph)
    {
        if (_ph.is_valid())
            mprops_.remove!(T)(_ph);
        _ph.reset();
    }

    //@}

public: //------------------------------------------------ get handle from name

    /// \name Get property handle by name
    //@{

    /** Retrieves the handle to a named property by it's name.
     *
     *  \param _ph    A property handle. On success the handle is valid else
     *                invalid.
     *  \param _name  Name of wanted property.
     *  \return \c true if such a named property is available, else \c false.
     */

    bool get_property_handle(T)(ref VPropHandleT!(T) _ph,
                                /*const*/ string _name) /*const*/
    {
        _ph = vprops_.handle!(T)(_name);
        return _ph.is_valid;
    }

    bool get_property_handle(T)(ref HPropHandleT!(T) _ph,
                                /*const*/ string _name) /*const*/
    {
        _ph = hprops_.handle!(T)(_name);
        return _ph.is_valid();
    }

    bool get_property_handle(T)(ref EPropHandleT!(T) _ph,
                                /*const*/ string _name) /*const*/
    {
        _ph = eprops_.handle!(T)(_name);
        return _ph.is_valid();
    }

    bool get_property_handle(T)(ref FPropHandleT!(T) _ph,
                                /*const*/ string _name) /*const*/
    {
        _ph = fprops_.handle!(T)(_name);
        return _ph.is_valid();
    }

    bool get_property_handle(T)(ref MPropHandleT!(T) _ph,
                                /*const*/ string _name) /*const*/
    {
        _ph = mprops_.handle!(T)(_name);
        return _ph.is_valid();
    }
//@}

public: //--------------------------------------------- BaseProperty from name
    BaseProperty find_vprop( /*const*/ string _name)
    { return vprops_.property_by_name(_name); }

    BaseProperty find_eprop( /*const*/ string _name)
    { return eprops_.property_by_name(_name); }

    BaseProperty find_hprop( /*const*/ string _name)
    { return hprops_.property_by_name(_name); }

    BaseProperty find_fprop( /*const*/ string _name)
    { return fprops_.property_by_name(_name); }

    BaseProperty find_mprop( /*const*/ string _name)
    { return mprops_.property_by_name(_name); }


public: //--------------------------------------------------- access properties

    /// \name Access a property
    //@{

    /** Access a property
     *
     *  This method returns a reference to property. The property handle
     *  must be valid! The result is unpredictable if the handle is invalid!
     *
     *  \param  _ph     A \em valid (!) property handle.
     *  \return The wanted property if the handle is valid.
     */

    PropertyT!(T) property(T,int _=1)(VPropHandleT!(T) _ph) {
        return vprops_.property!(T)(_ph);
    }
    PropertyT!(T) property(T,int _=2)(HPropHandleT!(T) _ph) {
        return hprops_.property!(T)(_ph);
    }
    PropertyT!(T) property(T,int _=3)(EPropHandleT!(T) _ph) {
        return eprops_.property!(T)(_ph);
    }
    PropertyT!(T) property(T,int _=4)(FPropHandleT!(T) _ph) {
        return fprops_.property!(T)(_ph);
    }
    PropertyT!(T) mproperty(T)(MPropHandleT!(T) _ph) {
        return mprops_.property!(T)(_ph);
    }

    void opIndexAssign(PropHandle,T)(PropertyT!(T) _prop,  PropHandle _ph) {
        static assert(is(PropHandle.value_type == T),
                      "Handle data type and Property data type mismatch");
        static if (is(PropHandle==VPropHandleT!(T))) {
            //vprops_[_ph] = _prop;
            vprops_.set_property!(T)(_ph, _prop);
        }
        else static if (is(PropHandle==HPropHandleT!(T))) {
            //hprops_[_ph] = _prop;
            hprops_.set_property!(T)(_ph, _prop);
        }
        else static if (is(PropHandle==EPropHandleT!(T))) {
            //eprops_[_ph] = _prop;
            eprops_.set_property!(T)(_ph, _prop);
        }
        else static if (is(PropHandle==FPropHandleT!(T))) {
            //fprops_[_ph] = _prop;
            fprops_.set_property!(T)(_ph, _prop);
        }
        else static if (is(PropHandle==MPropHandleT!(T))) {
            //mprops_[_ph] = _prop;
            mprops_.set_property!(T)(_ph, _prop);
        }
        else {
            static assert("Unknown property handle type");
        }
    }
/+
    void opIndexAssign(T)(VPropHandleT!(T) _ph, PropertyT!(T) _prop) {
        vprops_.property!(T)(_ph) = _prop;
    }
    void opIndexAssign(T)(HPropHandleT!(T) _ph, PropertyT!(T) _prop) {
        hprops_.property(_ph) = _prop;
    }
    void opIndexAssign(T)(EPropHandleT!(T) _ph, PropertyT!(T) _prop) {
        eprops_.property(_ph) = _prop;
    }
    void opIndexAssign(T)(FPropHandleT!(T) _ph, PropertyT!(T) _prop) {
        fprops_.property(_ph) = _prop;
    }
    void opIndexAssign(T)(MPropHandleT!(T) _ph, PropertyT!(T) _prop) {
        mprops_.property(_ph) = _prop;
    }
+/

/+
    /*const*/ PropertyT!(T) property(T)(VPropHandleT!(T) _ph) /*const*/ {
        return vprops_.property(_ph);
    }

    /*const*/ PropertyT!(T) property(T)(HPropHandleT!(T) _ph) /*const*/ {
        return hprops_.property(_ph);
    }

    /*const*/ PropertyT!(T) property(T)(EPropHandleT!(T) _ph) /*const*/ {
        return eprops_.property(_ph);
    }

    /*const*/ PropertyT!(T) property(T)(FPropHandleT!(T) _ph) /*const*/ {
        return fprops_.property(_ph);
    }

    /*const*/ PropertyT!(T) mproperty(T)(MPropHandleT!(T) _ph) /*const*/ {
        return mprops_.property(_ph);
    }
+/
    //@}

public: //-------------------------------------------- access property elements

    /// \name Access a property element using a handle to a mesh item
    //@{

    /** Return value of property for an item
     */

    VPropHandleT!(T).value_type
    property(T)(VPropHandleT!(T) _ph, VertexHandle _vh) {
        return vprops_.property!(T)(_ph)[_vh.idx()];
    }

    HPropHandleT!(T).value_type
    property(T)(HPropHandleT!(T) _ph, HalfedgeHandle _hh) {
        return hprops_.property!(T)(_ph)[_hh.idx()];
    }


    EPropHandleT!(T).value_type
    property(T)(EPropHandleT!(T) _ph, EdgeHandle _eh) {
        return eprops_.property!(T)(_ph)[_eh.idx()];
    }


    FPropHandleT!(T).value_type
    property(T)(FPropHandleT!(T) _ph, FaceHandle _fh) {
        return fprops_.property!(T)(_ph)[_fh.idx()];
    }


    MPropHandleT!(T).value_type
    property(T)(MPropHandleT!(T) _ph) {
        return mprops_.property!(T)(_ph)[0];
    }


/+
    template property_ptr(PropH,ElemH) {
        PropH.pointer property_ptr(PropH _ph, ElemH _eh) {
            static if (is(ElemH==VertexHandle)) {
                return vprops_.property!(PropH.value_type)(_ph).ptr(_eh.idx);
            }
            else static if (is(ElemH==HalfedgeHandle)) {
                return hprops_.property!(PropH.value_type)(_ph).ptr(_eh.idx);
            }
            else static if (is(ElemH==EdgeHandle)) {
                return eprops_.property!(PropH.value_type)(_ph).ptr(_eh.idx);
            } 
            else static if (is(ElemH==FaceHandle)) {
                return fprops_.property!(PropH.value_type)(_ph).ptr(_eh.idx);
            }
            else {
                static assert(false, "Unknown handle type: " ~ ElemH.stringof);
            }
        }
    }
+/

    VPropHandleT!(T).pointer
    property_ptr(T)(VPropHandleT!(T) _ph, VertexHandle _vh) {
        return vprops_.property!(T)(_ph).ptr(_vh.idx);
    }

    HPropHandleT!(T).pointer
    property_ptr(T)(HPropHandleT!(T) _ph, HalfedgeHandle _hh) {
        return hprops_.property!(T)(_ph).ptr(_hh.idx);
    }

    EPropHandleT!(T).pointer
    property_ptr(T)(EPropHandleT!(T) _ph, EdgeHandle _eh) {
        return eprops_.property!(T)(_ph).ptr(_eh.idx);
    }

    FPropHandleT!(T).pointer
    property_ptr(T)(FPropHandleT!(T) _ph, FaceHandle _fh) {
        return fprops_.property!(T)(_ph).ptr(_fh.idx);
    }

    MPropHandleT!(T).pointer
    property_ptr(T)(MPropHandleT!(T) _ph) {
        return mprops_.property!(T)(_ph).ptr(0);
    }


/+
    VPropHandleT!(T).const_reference
        property(T)(VPropHandleT!(T) _ph, VertexHandle _vh) /*const*/ {
        return vprops_.property(_ph)[_vh.idx()];
    }


    HPropHandleT!(T).const_reference
        property(T)(HPropHandleT!(T) _ph, HalfedgeHandle _hh) /*const*/ {
        return hprops_.property(_ph)[_hh.idx()];
    }

    EPropHandleT!(T).const_reference
        property(T)(EPropHandleT!(T) _ph, EdgeHandle _eh) /*const*/ {
        return eprops_.property(_ph)[_eh.idx()];
    }

    FPropHandleT!(T).const_reference
        property(T)(FPropHandleT!(T) _ph, FaceHandle _fh) /*const*/ {
        return fprops_.property(_ph)[_fh.idx()];
    }

    MPropHandleT!(T).const_reference
        property(T)(MPropHandleT!(T) _ph) /*const*/ {
        return mprops_.property(_ph)[0];
    }
+/
    //@}

public:

    size_t n_vprops() /*const*/ { return vprops_.size(); }

    size_t n_eprops() /*const*/ { return eprops_.size(); }

    size_t n_hprops() /*const*/ { return hprops_.size(); }

    size_t n_fprops() /*const*/ { return fprops_.size(); }

    size_t n_mprops() /*const*/ { return mprops_.size(); }

protected: //------------------------------------------------- low-level access

public:   // used by non-native kernel and MeshIO, should be protected

/+
    /*const*/ BaseProperty _get_vprop( /*const*/ string _name) /*const*/
    { return vprops_.property(_name); }

    /*const*/ BaseProperty _get_eprop( /*const*/ string _name) /*const*/
    { return eprops_.property(_name); }

    /*const*/ BaseProperty _get_hprop( /*const*/ string _name) /*const*/
    { return hprops_.property(_name); }

    /*const*/ BaseProperty _get_fprop( /*const*/ string _name) /*const*/
    { return fprops_.property(_name); }

    /*const*/ BaseProperty _get_mprop( /*const*/ string _name) /*const*/
    { return mprops_.property(_name); }
+/

    BaseProperty _vprop( size_t _idx ) { return vprops_._property( _idx ); }
    BaseProperty _eprop( size_t _idx ) { return eprops_._property( _idx ); }
    BaseProperty _hprop( size_t _idx ) { return hprops_._property( _idx ); }
    BaseProperty _fprop( size_t _idx ) { return fprops_._property( _idx ); }
    BaseProperty _mprop( size_t _idx ) { return mprops_._property( _idx ); }

/+
    /*const*/ BaseProperty _vprop( size_t _idx ) /*const*/
    { return vprops_._property( _idx ); }
    /*const*/ BaseProperty _eprop( size_t _idx ) /*const*/
    { return eprops_._property( _idx ); }
    /*const*/ BaseProperty _hprop( size_t _idx ) /*const*/
    { return hprops_._property( _idx ); }
    /*const*/ BaseProperty _fprop( size_t _idx ) /*const*/
    { return fprops_._property( _idx ); }
    /*const*/ BaseProperty _mprop( size_t _idx ) /*const*/
    { return mprops_._property( _idx ); }
+/

    size_t _add_vprop( BaseProperty _bp ) { return vprops_._add( _bp ); }
    size_t _add_eprop( BaseProperty _bp ) { return eprops_._add( _bp ); }
    size_t _add_hprop( BaseProperty _bp ) { return hprops_._add( _bp ); }
    size_t _add_fprop( BaseProperty _bp ) { return fprops_._add( _bp ); }
    size_t _add_mprop( BaseProperty _bp ) { return mprops_._add( _bp ); }

protected: // low-level access non-public

/+
    BaseProperty _vprop( BaseHandle _h )
    { return vprops_._property( _h.idx() ); }
    BaseProperty _eprop( BaseHandle _h )
    { return eprops_._property( _h.idx() ); }
    BaseProperty _hprop( BaseHandle _h )
    { return hprops_._property( _h.idx() ); }
    BaseProperty _fprop( BaseHandle _h )
    { return fprops_._property( _h.idx() ); }
    BaseProperty _mprop( BaseHandle _h )
    { return mprops_._property( _h.idx() ); }
+/

/+
    /*const*/ BaseProperty _vprop( BaseHandle _h ) /*const*/
    { return vprops_._property( _h.idx() ); }
    /*const*/ BaseProperty _eprop( BaseHandle _h ) /*const*/
    { return eprops_._property( _h.idx() ); }
    /*const*/ BaseProperty _hprop( BaseHandle _h ) /*const*/
    { return hprops_._property( _h.idx() ); }
    /*const*/ BaseProperty _fprop( BaseHandle _h ) /*const*/
    { return fprops_._property( _h.idx() ); }
    /*const*/ BaseProperty _mprop( BaseHandle _h ) /*const*/
    { return mprops_._property( _h.idx() ); }
+/

public: //----------------------------------------------------- element numbers


    uint n_vertices()  /*const*/ { return 0; }
    uint n_halfedges() /*const*/ { return 0; }
    uint n_edges()     /*const*/ { return 0; }
    uint n_faces()     /*const*/ { return 0; }


protected: //------------------------------------------- synchronize properties

    void vprops_reserve(uint _n) /*const*/ { vprops_.reserve(_n); }
    void vprops_resize(uint _n) /*const*/ { vprops_.resize(_n); }
    void vprops_swap(uint _i0, uint _i1) /*const*/ {
        vprops_.swap(_i0, _i1);
    }

    void hprops_reserve(uint _n) /*const*/ { hprops_.reserve(_n); }
    void hprops_resize(uint _n) /*const*/ { hprops_.resize(_n); }
    void hprops_swap(uint _i0, uint _i1) /*const*/ {
        hprops_.swap(_i0, _i1);
    }

    void eprops_reserve(uint _n) /*const*/ { eprops_.reserve(_n); }
    void eprops_resize(uint _n) /*const*/ { eprops_.resize(_n); }
    void eprops_swap(uint _i0, uint _i1) /*const*/ {
        eprops_.swap(_i0, _i1);
    }

    void fprops_reserve(uint _n) /*const*/ { fprops_.reserve(_n); }
    void fprops_resize(uint _n) /*const*/ { fprops_.resize(_n); }
    void fprops_swap(uint _i0, uint _i1) /*const*/ {
        fprops_.swap(_i0, _i1);
    }

    void mprops_resize(uint _n) /*const*/ { mprops_.resize(_n); }

public:

    //void property_stats(std.io._iobuf* _ostr = std.clog) /*const*/;

public:

    alias VPropertyContainer.iterator vprop_iterator;
    alias FPropertyContainer.iterator fprop_iterator;
    alias EPropertyContainer.iterator eprop_iterator;
    alias HPropertyContainer.iterator hprop_iterator;
    alias MPropertyContainer.iterator mprop_iterator;
    //alias PropertyContainer.const_iterator const_prop_iterator;

    vprop_iterator vprops_begin() { return vprops_.begin(); }
    vprop_iterator vprops_end()   { return vprops_.end(); }
    //const_prop_iterator vprops_begin() /*const*/ { return vprops_.begin(); }
    //const_prop_iterator vprops_end()   /*const*/ { return vprops_.end(); }

    eprop_iterator eprops_begin() { return eprops_.begin(); }
    eprop_iterator eprops_end()   { return eprops_.end(); }
    //const_prop_iterator eprops_begin() /*const*/ { return eprops_.begin(); }
    //const_prop_iterator eprops_end()   /*const*/ { return eprops_.end(); }

    hprop_iterator hprops_begin() { return hprops_.begin(); }
    hprop_iterator hprops_end()   { return hprops_.end(); }
    //const_prop_iterator hprops_begin() /*const*/ { return hprops_.begin(); }
    //const_prop_iterator hprops_end()   /*const*/ { return hprops_.end(); }

    fprop_iterator fprops_begin() { return fprops_.begin(); }
    fprop_iterator fprops_end()   { return fprops_.end(); }
    //const_prop_iterator fprops_begin() /*const*/ { return fprops_.begin(); }
    //const_prop_iterator fprops_end()   /*const*/ { return fprops_.end(); }

    mprop_iterator mprops_begin() { return mprops_.begin(); }
    mprop_iterator mprops_end()   { return mprops_.end(); }
    //const_prop_iterator mprops_begin() /*const*/ { return mprops_.begin(); }
    //const_prop_iterator mprops_end()   /*const*/ { return mprops_.end(); }

private:

    VPropertyContainer  vprops_;
    HPropertyContainer  hprops_;
    EPropertyContainer  eprops_;
    FPropertyContainer  fprops_;
    MPropertyContainer  mprops_;
}
//=============================================================================

unittest{
    BaseKernel k = new BaseKernel();

}




//=============================================================================
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
