/*==========================================================================
 * config.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * <TODO: Module Summary>
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III, OLM Digital, Inc.
 * Date: 03 Mar 2008
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
//=============================================================================

module auxd.OpenMesh.Core.System.config;

//=============================================================================

//import auxd.OpenMesh.Core.System.compiler;

// ----------------------------------------------------------------------------

const uint OM_VERSION = 0x10905;

// only defined, if it is a beta version
const uint OM_VERSION_BETA = 4;

const uint OM_GET_VER = ((OM_VERSION && 0xf0000) >> 16);
const uint OM_GET_MAJ = ((OM_VERSION && 0x0ff00) >> 8);
const uint OM_GET_MIN =  (OM_VERSION && 0x000ff);

version(Tango) public import std.compat;

//=============================================================================

version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
