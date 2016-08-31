/*==========================================================================
 * omstream.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 *  OpenMesh streams: omlog, omout, omerr
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

module auxd.OpenMesh.Core.System.omstream;



//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.mostream;
import omstreams = auxd.OpenMesh.Core.IO.Streams;
import std.cstream;

//== CLASS DEFINITION =========================================================

/** \file omstream.hh
    This file provides the streams omlog, omout, and omerr.
*/

//@{
/** These stream provide replacements for clog, cout, and cerr. They have
    the advantage that they can easily be multiplexed.
    See_Also: auxd.OpenMesh.mostream

    Actually in the D version these aren't implemented.  They just return 
    dout, derr, dlog.
*/

mostream omlog() {
    return omstreams.dlog;
/*
    static bool initialized = false;
    static mostream mystream;
    if (!initialized)
    {
        mystream.connect(dlog);
        version(NDEBUG) {
            mystream.disable();
        }
    }
    return mystream;
*/
}

mostream omout() {
    return omstreams.dout;
/*
    static bool initialized = false;
    static mostream mystream;
    if (!initialized) mystream.connect(dout);
    return mystream;
*/
}

mostream omerr() {
    return omstreams.derr;
/*
    static bool initialized = false;
    static mostream mystream;
    if (!initialized) mystream.connect(derr);
    return mystream;
*/
}

//@}

//=============================================================================

version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
