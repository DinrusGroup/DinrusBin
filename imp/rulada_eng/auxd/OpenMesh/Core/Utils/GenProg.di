//============================================================================
// GenProg.d - 
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 28 Aug 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================
// $Id:$
//============================================================================

module auxd.OpenMesh.Core.Utils.GenProg;

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
//   $Date: 2007-05-18 15:17:50 $
//                                                                            
//=============================================================================


//=============================================================================
//
//  Utils for generic/generative programming
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;


//== IMPLEMENTATION ===========================================================


/// This type maps \c true or \c false to different types.
struct Bool2Type(bool b) { enum { my_bool = b } }

/// This class generates different types from different \c int 's.
struct Int2Type(int i)  { enum { my_int = i } }

/// Handy typedef for Bool2Type<true> classes
alias Bool2Type!(true) True;

/// Handy typedef for Bool2Type<false> classes
alias Bool2Type!(false) False;

//-----------------------------------------------------------------------------
/// compile time assertions 
template AssertCompile(bool Expr) {
    static_assert(Expr);
}


//--- Template "if" w/ partial specialization ---------------------------------
// not really necessary with 'static if' in the langauge


template assert_compile(EXPR) {
    static_assert(EXPR);
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
