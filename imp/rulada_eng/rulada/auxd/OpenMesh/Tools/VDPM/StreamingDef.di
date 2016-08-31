/*==========================================================================
 * StreamingDef.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/****************************************************************************
 * <TODO: Module Summary>
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III, OLM Digital, Inc.
 * Date: 12 Oct 2007
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
//===========================================================================

module auxd.OpenMesh.Tools.VDPM.StreamingDef;

const VDPM_STREAMING_PORT = 4096;

// debug (DEBUG_COUT)

debug (DEBUG_COUT) {
    static bool debug_print_;
    static bool debug_print()               { return debug_print_; }
    static void set_debug_print(bool flag)  { debug_print_ = flag; }
}

enum /*VDPMDownLinkStatus*/     { kStarted, kFinished, kStartable };
enum /*VDPMStreamingPhase*/     { kBaseMesh, kVSplitHeader, kVSplits };
enum /*VDPMClientMode*/         { kStatic, kDynamic };
enum /*VHierarchySearchMode*/   { kBruteForce, kUseHashing };
alias uint VDPMDownLinkStatus;
alias uint VDPMStreamingPhase;
alias uint VDPMClientMode;
alias uint VHierarchySearchMode;

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
