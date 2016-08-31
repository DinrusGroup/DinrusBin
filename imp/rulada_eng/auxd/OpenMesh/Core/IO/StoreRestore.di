//=============================================================================
//                                                                            
//                               OpenMesh                                     
//        Copyright (C) 2003 by Computer Graphics Group, RWTH Aachen          
//                           www.openmesh.org                                 
//                                                                            
//-----------------------------------------------------------------------------
//                                                                            
//                                License                                     
//                                                                            
//   This library is free software; you can redistribute it and/or modify it 
//   under the terms of the GNU Lesser General Public License as published   
//   by the Free Software Foundation, version 2.1.                           
//                                                                             
//   This library is distributed in the hope that it will be useful, but       
//   WITHOUT ANY WARRANTY; without even the implied warranty of                
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU         
//   Lesser General Public License for more details.                           
//                                                                            
//   You should have received a copy of the GNU Lesser General Public          
//   License along with this library; if not, write to the Free Software       
//   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.                 
//                                                                            
//-----------------------------------------------------------------------------
//                                                                            
//   $Revision: 1.2 $
//   $Date: 2007-05-18 15:17:38 $
//                                                                            
//=============================================================================


//=============================================================================
//
//  Helper Functions for binary reading / writing
//
//=============================================================================

module auxd.OpenMesh.Core.IO.StoreRestore;


//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.IO.SR_binary;
import auxd.OpenMesh.Core.IO.Streams;

alias auxd.OpenMesh.Core.IO.SR_binary.UnknownSize UnknownSize;

//=============================================================================


/** \name Handling binary input/output.
    These functions take care of swapping bytes to get the right Endian.
*/
//@{


//-----------------------------------------------------------------------------
// StoreRestore definitions

bool is_streamable(T)()
{ return binary!(T).is_streamable; }

bool is_streamable(T,dummy=void)( /*const*/ ref T ) 
{ return binary!(T).is_streamable; }

size_t size_of(T)() 
{ return binary!(T).size_of(); }

size_t size_of(T,dummy=void)( /*const*/ ref T v )
{ return binary!(T).size_of(v); }

size_t store(T)( ostream _os, /*const ref */T _v, bool _swap=false)
{ return binary!(T).store( _os, _v, _swap ); }

size_t restore(T)( istream _is, ref T _v, bool _swap=false)
{ return binary!(T).restore( _is, _v, _swap ); }

//@}


//=============================================================================
unittest {
    is_streamable!(float)();
    float x;
    is_streamable(x);
    size_of!(float);
    size_of(x);
    bool caught = false;
    try {
        store(dout, 2.3f);
    } catch(auxd.OpenMesh.Core.Utils.Exceptions.logic_error e) {
        caught = true;
    }
    assert(caught, "expected a logic error to be thrown");
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
