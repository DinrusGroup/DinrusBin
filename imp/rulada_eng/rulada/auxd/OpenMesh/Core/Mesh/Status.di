//============================================================================
// Status.d - 
//   Written in the D Programming Language (http://www.digitalmars.com/d)
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

module auxd.OpenMesh.Core.Mesh.Status;

//=============================================================================
//
//  CLASS Status
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;


//== CLASS DEFINITION  ========================================================
  

/** Status bits used by the Status class. 
 *  See_Also: auxd.OpenMesh.Attributes.StatusInfo
 */
enum Attributes : uint {

  DELETED  = 1,   ///< Item has been deleted
  LOCKED   = 2,   ///< Item is locked.
  SELECTED = 4,   ///< Item is selected.
  HIDDEN   = 8,   ///< Item is hidden.
  FEATURE  = 16,  ///< Item is a feature or belongs to a feature.
  TAGGED   = 32,  ///< Item is tagged.
  TAGGED2  = 64,  ///< Alternate bit for tagging an item.
  UNUSED   = 128  ///<
}

alias Attributes StatusBits ;

/** \class StatusInfo Status.hh <OpenMesh/Attributes/Status.hh>
 *
 *   Add status information to a base class.
 *
 *   See_Also: StatusBits
 */
struct StatusInfo
{
public:

    alias uint value_type;
    
    static StatusInfo opCall() {
        StatusInfo M; with(M) {
        } return M;
    }

    /// is deleted ?
    bool deleted() /*const*/  { return is_bit_set(StatusBits.DELETED); }
    /// set deleted
    void set_deleted(bool _b) { change_bit(StatusBits.DELETED, _b); }


    /// is locked ?
    bool locked() /*const*/  { return is_bit_set(StatusBits.LOCKED); }
    /// set locked
    void set_locked(bool _b) { change_bit(StatusBits.LOCKED, _b); }


    /// is selected ?
    bool selected() /*const*/  { return is_bit_set(StatusBits.SELECTED); }
    /// set selected
    void set_selected(bool _b) { change_bit(StatusBits.SELECTED, _b); }


    /// is hidden ?
    bool hidden() /*const*/  { return is_bit_set(StatusBits.HIDDEN); }
    /// set hidden
    void set_hidden(bool _b) { change_bit(StatusBits.HIDDEN, _b); }


    /// is feature ?
    bool feature() /*const*/  { return is_bit_set(StatusBits.FEATURE); }
    /// set feature
    void set_feature(bool _b) { change_bit(StatusBits.FEATURE, _b); }


    /// is tagged ?
    bool tagged() /*const*/  { return is_bit_set(StatusBits.TAGGED); }
    /// set tagged
    void set_tagged(bool _b) { change_bit(StatusBits.TAGGED, _b); }


    /// is tagged2 ? This is just one more tag info.
    bool tagged2() /*const*/  { return is_bit_set(StatusBits.TAGGED2); }
    /// set tagged
    void set_tagged2(bool _b) { change_bit(StatusBits.TAGGED2, _b); }


    /// return whole status
    uint bits() /*const*/ { return status_; }
    /// set whole status at once
    void set_bits(uint _bits) { status_ = _bits; }


    /// is a certain bit set ?
    bool is_bit_set(uint _s) /*const*/ { return (status_ & _s) > 0; }
    /// set a certain bit
    void set_bit(uint _s) { status_ |= _s; }
    /// unset a certain bit
    void unset_bit(uint _s) { status_ &= ~_s; }
    /// set or unset a certain bit
    void change_bit(uint _s, bool _b) {  
        if (_b) status_ |= _s; else status_ &= ~_s; }


private: 

    value_type status_  = 0;
}


unittest {
    StatusInfo x;
    x.set_bit(StatusBits.DELETED);
    assert(x.is_bit_set(StatusBits.DELETED));
    assert(x.deleted());
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
