//============================================================================
// Property.d - 
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 28 Aug 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================

module auxd.OpenMesh.Core.Utils.Property;

/*===========================================================================*\
 *                                                                           *
 *                               OpenMesh                                    *
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen      *
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

//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.IO.Streams;
import IO = auxd.OpenMesh.Core.IO.StoreRestore;
import stdutil = auxd.OpenMesh.Core.Utils.Std;

public import auxd.OpenMesh.Core.Utils.BaseProperty;
import std.string : format;

//== CLASS DEFINITION =========================================================

/** \class PropertyT Property.hh <OpenMesh/Core/Utils/PropertyT.hh>
 *
 *  \brief Default property class for any type T.
 *
 *  The default property class for any type T.
 *
 *  The property supports persistency if T is a "fundamental" type:
 *  - integer fundamental types except bool:
 *    char, short, int, long, long long (__int64 for MS VC++) and
 *    their unsigned companions.
 *  - float fundamentals except <tt>long double</tt>:
 *    float, double
 *  - %OpenMesh vector types
 *
 *  Persistency of non-fundamental types is supported if and only if a
 *  specialization of struct IO.binary<> exists for the wanted type.
 */

// TODO: it might be possible to define Property using kind of a runtime info
// structure holding the size of T. Then reserve, swap, resize, etc can be written
// in pure malloc() style w/o virtual overhead. Template member function proved per
// element access to the properties, asserting dynamic_casts in debug

class PropertyT(T) : BaseProperty
{
  public:

    alias T     Value;
    alias T[]   vector_type;
    alias T     value_type;
    alias T*    pointer;
    //alias T*    reference;
    //alias T*    const_reference;

  public:

    /// Default constructor
    this(/*const*/ string _name = "<unknown>")
    { super(_name); }

    void copy(PropertyT _other) {
        super.copy(_other);
        data_ = _other.data_.dup;
    }

  public: // inherited from BaseProperty

    void reserve(size_t _n) { 
        stdutil.reserve(data_,_n);
    }
    void resize(size_t _n)  { data_.length = _n; }
    void push_back()        { T x; data_ ~= x; }
    void swap(size_t _i0, size_t _i1)
    { 
        T tmp = data_[_i0];
        data_[_i0] = data_[_i1]; 
        data_[_i1] = tmp;
    }

  public:

    void set_persistent( bool _yn )
    { check_and_set_persistent!(T)( _yn ); }

    size_t n_elements()   /*const*/ { return data_.length; }
    size_t element_size() /*const*/ { return T.sizeof /*IO.size_of!(T)()*/; }
    TypeInfo element_type() { return typeid(T); }

    size_t size_of() /*const*/
    {
        if (element_size() != IO.UnknownSize)
            return super.size_of(n_elements());
        return element_size() * n_elements();
    }

    size_t size_of(size_t _n_elem) /*const*/
    { return super.size_of(_n_elem); }

    size_t store( ostream _ostr, bool _swap ) /*const*/
    {
        if ( IO.is_streamable!(vector_type)() )
            return IO.store(_ostr, data_, _swap );
        size_t bytes = 0;
        for (size_t i=0; i<n_elements(); ++i)
            bytes += IO.store( _ostr, data_[i], _swap );
        return bytes;
    }

    size_t restore( istream _istr, bool _swap )
    {
        if ( IO.is_streamable!(vector_type)() )
            return IO.restore(_istr, data_, _swap );
        size_t bytes = 0;
        for (size_t i=0; i<n_elements(); ++i)
            bytes += IO.restore( _istr, data_[i], _swap );
        return bytes;
    }

  public: // data access interface

    /// Get pointer to array (does not work for T==bool because of bitarray specialization)
    /*const*/ T[] data() /*const*/ { return data_; }

    /// Get pointer to i'th element.
    T* ptr(int _idx)
    {
        assert( cast(size_t)_idx < n_elements, 
                std.string.format("Index %s out of range [0..%s] for property '%s'",
                                  _idx, n_elements, name));
        return &data_[_idx];
    }

    /// Access the i'th element.
    T opIndex(int _idx)
    {
        //writefln("nelems = %s  -  idx = %s", n_elements, _idx);
        assert( cast(size_t)_idx < n_elements, 
                std.string.format("Index %s out of range [0..%s] for property '%s'",
                                  _idx, n_elements, name));
        return data_[_idx];
    }
    /// Set the i'th element.
    void opIndexAssign(T val, int _idx)
    {
        assert( cast(size_t)_idx < n_elements, 
                std.string.format("Index %s out of range [0..%s] for property '%s'",
                                  _idx, n_elements, name));
        data_[_idx] = val;
    }

    /// /*Const*/ access to the i'th element. No range check is performed!
    /+
     const_reference opIndex(int _idx) /*const*/
     {
     assert( size_t(_idx) < data_.size());
     return data_[_idx];
     }
     +/

    /// Make a copy of self.
    PropertyT!(T) dup() /*const*/
    {
        auto p = new PropertyT!(T)();
        p.copy(this);
        assert(p.data_.ptr !is this.data_.ptr);
        return p;
    }

    /// Make a copy of self (for compatibility with C++ API)
    alias dup clone;

  protected:
    /// Return raw pointer to a given element
    void*  raw_element_ptr(int _idx) {
        return ptr(_idx);
    }


  private:

    vector_type data_;
}

//-----------------------------------------------------------------------------

/+
/** \class PropertyT<bool> Property.hh <OpenMesh/Core/Utils/PropertyT.hh>

  Property specialization for bool type. The data will be stored as
  a bitset.
 */
template <>
class PropertyT<bool> : public BaseProperty
{
public:

  alias std.vector<bool>                       vector_type;
  alias bool                                    value_type;
  alias vector_type.reference                  reference;
  alias vector_type.const_reference            const_reference;

public:

  PropertyT(/*const*/ std.string& _name = "<unknown>")
    : BaseProperty(_name)
  { }

public: // inherited from BaseProperty

  void reserve(size_t _n) { data_.reserve(_n);    }
  void resize(size_t _n)  { data_.resize(_n);     }
  void push_back()        { data_.push_back(bool()); }
  void swap(size_t _i0, size_t _i1)
  { bool t(data_[_i0]); data_[_i0]=data_[_i1]; data_[_i1]=t; }

public:

  void set_persistent( bool _yn )
  {
    check_and_set_persistent<bool>( _yn );
  }

  size_t       n_elements()   /*const*/ { return data_.size();  }
  size_t       element_size() /*const*/ { return UnknownSize;    }
  size_t       size_of() /*const*/      { return size_of( n_elements() ); }
  size_t       size_of(size_t _n_elem) /*const*/
  {
    return _n_elem / 8 + ((_n_elem % 8)!=0);
  }

  size_t store( std.ostream& _ostr, bool _swap ) /*const*/
  {
    size_t bytes = 0;

    size_t N = data_.size() / 8;
    size_t R = data_.size() % 8;

    size_t        idx;  // element index
    size_t        bidx;
    unsigned char bits; // bitset

    for (bidx=idx=0; idx < N; ++idx, bidx+=8)
    {
      bits = !!data_[bidx]
        | (!!data_[bidx+1] << 1)
        | (!!data_[bidx+2] << 2)
        | (!!data_[bidx+3] << 3)
        | (!!data_[bidx+4] << 4)
        | (!!data_[bidx+5] << 5)
        | (!!data_[bidx+6] << 6)
        | (!!data_[bidx+7] << 7);
      _ostr << bits;
    }
    bytes = N;

    if (R)
    {
      bits = 0;
      for (idx=0; idx < R; ++idx)
        bits |= !!data_[bidx+idx] << idx;
      _ostr << bits;
      ++bytes;
    }

    std.cout << std.endl;

    assert( bytes == size_of() );

    return bytes;
  }

  size_t restore( std.istream& _istr, bool _swap )
  {
    size_t bytes = 0;

    size_t N = data_.size() / 8;
    size_t R = data_.size() % 8;

    size_t        idx;  // element index
    size_t        bidx; //
    unsigned char bits; // bitset

    for (bidx=idx=0; idx < N; ++idx, bidx+=8)
    {
      _istr >> bits;
      data_[bidx+0] = !!(bits & 0x01);
      data_[bidx+1] = !!(bits & 0x02);
      data_[bidx+2] = !!(bits & 0x04);
      data_[bidx+3] = !!(bits & 0x08);
      data_[bidx+4] = !!(bits & 0x10);
      data_[bidx+5] = !!(bits & 0x20);
      data_[bidx+6] = !!(bits & 0x40);
      data_[bidx+7] = !!(bits & 0x80);
    }
    bytes = N;

    if (R)
    {
      _istr >> bits;
      for (idx=0; idx < R; ++idx)
        data_[bidx+idx] = !!(bits & (1<<idx));
      ++bytes;
    }

    std.cout << std.endl;

    return bytes;
  }


public:

  /// Access the i'th element. No range check is performed!
  reference operator[](int _idx)
  {
    assert( size_t(_idx) < data_.size() );
    return data_[_idx];
  }

  /// Const access to the i'th element. No range check is performed!
  /*const*/_reference operator[](int _idx) /*const*/
  {
    assert( size_t(_idx) < data_.size());
    return data_[_idx];
  }

  /// Make a copy of self.
  PropertyT<bool>* dup() /*const*/
  {
    PropertyT<bool>* p = new PropertyT<bool>();
    p.data_ = data_;
    return p;
  }
  alias dup clone;

private:

  vector_type data_;
};
+/
//-----------------------------------------------------------------------------

/+


/** \class PropertyT<std.string> Property.hh <OpenMesh/Core/Utils/PropertyT.hh>

  Property specialization for std.string type.
*/
template <>
class PropertyT<std.string> : public BaseProperty
{
public:

  alias std.string                             Value;
  alias std.vector<std.string>                vector_type;
  alias std.string                             value_type;
  alias vector_type.reference                  reference;
  alias vector_type.const_reference            const_reference;

public:

  PropertyT(/*const*/ std.string& _name = "<unknown>")
    : BaseProperty(_name)
  { }

public: // inherited from BaseProperty

  void reserve(size_t _n) { data_.reserve(_n);    }
  void resize(size_t _n)  { data_.resize(_n);     }
  void push_back()        { data_.push_back(std.string()); }
  void swap(size_t _i0, size_t _i1) {
    std.swap(data_[_i0], data_[_i1]);
  }

public:

  void set_persistent( bool _yn )
  { check_and_set_persistent<std.string>( _yn ); }

  size_t       n_elements()   /*const*/ { return data_.size();  }
  size_t       element_size() /*const*/ { return UnknownSize;    }
  size_t       size_of() /*const*/
  { return IO.size_of( data_ ); }

  size_t       size_of(size_t _n_elem) /*const*/
  { return UnknownSize; }

  /// Store self as one binary block. Max. length of a string is 65535 bytes.
  size_t store( std.ostream& _ostr, bool _swap ) /*const*/
  { return IO.store( _ostr, data_, _swap ); }

  size_t restore( std.istream& _istr, bool _swap )
  { return IO.restore( _istr, data_, _swap ); }

public:

  /*const*/ value_type* data() /*const*/ { return (value_type*) &data_[0]; }

  /// Access the i'th element. No range check is performed!
  reference operator[](int _idx) {
    assert( size_t(_idx) < data_.size());
    return ((value_type*) &data_[0])[_idx];
  }

  /// /*Const*/ access the i'th element. No range check is performed!
  const_reference operator[](int _idx) /*const*/ {
    assert( size_t(_idx) < data_.size());
    return ((value_type*) &data_[0])[_idx];
  }

  PropertyT<value_type>* dup() /*const*/ {
    PropertyT<value_type>* p = new PropertyT<value_type>();
    p.data_ = data_;
    return p;
  }
  alias dup clone;

private:

  vector_type data_;

};
+/

/// Base property handle mixin
//   Note: these property handles were all derived from BaseHandle in the original code

template PropHandleMixin(T)
{
    mixin auxd.OpenMesh.Core.Mesh.Handles.HandleMixin!();

    alias T                                Value;
    alias T[]                              vector_type;
    alias T                                value_type;
    alias T*                               pointer;
    //alias vector_type.reference         reference;
    //alias vector_type.const_reference   const_reference;


/*
    int opEquals(typeof(*this) other) {
        return base.opEquals(other.base);
    }
    int opCmp(typeof(this) other) {
        return base.opCmp(&other.base);
    }
*/
}

/** \ingroup mesh_property_handle_group
 *  Handle representing a vertex property
 */
//alias BasePropHandleT VPropHandleT;
struct VPropHandleT(T) 
{
    mixin PropHandleMixin!(T);
}

/** \ingroup mesh_property_handle_group
 *  Handle representing a halfedge property
 */
//alias BasePropHandleT HPropHandleT;
struct HPropHandleT(T) 
{
    mixin PropHandleMixin!(T);
}


/** \ingroup mesh_property_handle_group
 *  Handle representing an edge property
 */
//alias BasePropHandleT EPropHandleT;
struct EPropHandleT(T) 
{
    mixin PropHandleMixin!(T);
}

/** \ingroup mesh_property_handle_group
 *  Handle representing a face property
 */
//alias BasePropHandleT FPropHandleT;
struct FPropHandleT(T) 
{
    mixin PropHandleMixin!(T);
}


/** \ingroup mesh_property_handle_group
 *  Handle representing a mesh property
 */
//alias BasePropHandleT MPropHandleT;
struct MPropHandleT(T) 
{
    mixin PropHandleMixin!(T);
}

unittest {
    auto x = new PropertyT!(float);
    x.resize(10);
    x[5] = 16.0;
    assert(x[5] == 16.0);
    assert(x.size_of()==float.sizeof * 10);
    
    VPropHandleT!(float) vpf = 5;
    assert(std.string.format(vpf) == "5");

    VPropHandleT!(float) vpf2 = 6;
    assert(vpf != vpf2);
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
