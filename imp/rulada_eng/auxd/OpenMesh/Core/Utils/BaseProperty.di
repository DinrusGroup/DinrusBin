//============================================================================
// BaseProperty.d - 
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 29 Aug 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================
// $Id:$
//============================================================================

module auxd.OpenMesh.Core.Utils.BaseProperty;

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
import auxd.OpenMesh.Core.IO.StoreRestore;
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.Utils.Exceptions;

private extern(C) void* memcpy (void*, void*, size_t) ;


//== CLASS DEFINITION =========================================================

/** \class BaseProperty Property.d <OpenMesh/Core/Utils/Property.d>

    Abstract class defining the basic interface of a dynamic property.
**/

class BaseProperty
{
public:

    /// Indicates an error when a size is returned by a member.
    static const size_t UnknownSize = cast(size_t)-1;

public:

    /// \brief Default constructor.
    ///
    /// In %OpenMesh all mesh data is stored in so-called properties.
    /// We distinuish between standard properties, which can be defined at
    /// compile time using the Attributes in the traits definition and
    /// at runtime using the request property functions defined in one of
    /// the kernels.
    ///
    /// If the property should be stored along with the default properties
    /// in the OM-format one must name the property and enable the persistant
    /// flag with set_persistent().
    ///
    /// \param _name Optional textual name for the property.
    ///
    this(/*const*/string _name = "<unknown>")
    {
        name_= (_name), persistent_ = (false);
    }

    /// Destructor.
    ~this() {}

    /// Copy other's contents over contents of this
    void copy(BaseProperty _other) {
        name_ = _other.name_;
        persistent_ = _other.persistent_;
    }

    /// Copy an element from another base property to this one
    void copy_element(int _i, BaseProperty _other, int _iother)
    {
        size_t sz = element_size();
        assert(sz == _other.element_size(), "Elements are different sizes");
        if (sz==UnknownSize) {
            throw new runtime_error("Attempt to copy property element of unknown size");
        }
        memcpy(raw_element_ptr(_i), _other.raw_element_ptr(_iother), sz);
    }

    abstract TypeInfo element_type();

public: // synchronized array interface

    /// Reserve memory for n elements.
    abstract void reserve(size_t _n);

    /// Resize storage to hold n elements.
    abstract void resize(size_t _n);

    /// Extend the number of elements by one.
    abstract void push_back();

    /// Let two elements swap their storage place.
    abstract void swap(size_t _i0, size_t _i1);

    /// Return a deep copy of self.
    abstract BaseProperty dup () /*const*/;

public: // named property interface

    /// Return the name of the property
    /*const*/ string name() /*const*/ { return name_; }

    void stats(ostream _ostr) /*const*/ {
        _ostr.writefln("  " , name() , (persistent() ? ", persistent " : ""));
    }

public: // I/O support

    /// Returns true if the persistent flag is enabled else false.
    bool persistent() /*const*/ { return persistent_; }

    /// Enable or disable persistency. Self must be a named property to enable
    /// persistency.
    abstract void set_persistent( bool _yn );

    /// Number of elements in property
    abstract size_t       n_elements() /*const*/;

    /// Size of one element in bytes or UnknownSize if not known.
    abstract size_t       element_size() /*const*/;

    /// Return size of property in bytes
    size_t       size_of() /*const*/
    {
        return size_of( n_elements() );
    }

    /// Estimated size of property if it has _n_elem elements.
    /// The member returns UnknownSize if the size cannot be estimated.
    size_t       size_of(size_t _n_elem) /*const*/
    {
        return (element_size()!=UnknownSize)
            ? (_n_elem*element_size())
            : UnknownSize;
    }

    /// Store self as one binary block
    abstract size_t store( ostream _ostr, bool _swap ) /*const*/;

    /** Restore self from a binary block. Uses reserve() to set the
        size of self before restoring.
    **/
    abstract size_t restore( istream _istr, bool _swap );

protected:

    /// Return raw pointer to a given element
    abstract void*  raw_element_ptr(int _idx);

    // To be used in a derived class, when overloading set_persistent()
    void check_and_set_persistent(T)( bool _yn )
    {
        if ( _yn && !is_streamable!(T)() ) {
            derr.writefln("Warning! Type of property value is not binary storable!");
        }
        persistent_ = is_streamable!(T)() && _yn;
    }

private:

    char[] name_;
    bool   persistent_;
}

unittest {
    // not much you can do here...
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
