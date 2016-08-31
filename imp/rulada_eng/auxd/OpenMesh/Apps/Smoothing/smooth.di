//============================================================================
// smooth.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
//
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 11 Oct 2007
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
//============================================================================

module smooth;

import std.cstream;
static import std.string;
static import std.conv;

import auxd.OpenMesh.Core.IO.MeshIO;
import auxd.OpenMesh.Core.IO.writers;
import auxd.OpenMesh.Core.IO.readers;
import auxd.OpenMesh.Core.Mesh.api;
//import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
import auxd.OpenMesh.Tools.Utils.Timer;
import auxd.OpenMesh.Tools.Smoother.JacobiLaplaceSmootherT;
import auxd.OpenMesh.Tools.Utils.getopt;


alias auxd.OpenMesh.Core.Mesh.api.DefaultTraits MyTraits;
/*
struct MyTraits : public auxd.OpenMesh.Core.Mesh.api.DefaultTraits;
{
    alias auxd.OpenMesh.Vec3f Point;
    alias auxd.OpenMesh.Vec3f Normal;
}
*/
alias TriMesh_ArrayKernelT!(MyTraits)  MyMesh;


//-----------------------------------------------------------------------------

void usage()
{
    dout.writefln;
    dout.writefln("Usage: smooth [Options] <iterations> <input mesh> <output mesh>\n");
    dout.writefln;
    dout.writefln( "Options \n\n"
                   "  -c <0|1> \t continuity (C0,C1). Default: C1\n"
                   "  -t \t\t smooth tangential direction. Default: Enabled\n"
                   "  -n \t\t smooth normal direction. Default: Enabled").flush;
}


//-----------------------------------------------------------------------------


int main(char[][] argv)
{
    int    c;

    scope mesh = new MyMesh;
    scope t = new auxd.OpenMesh.Tools.Utils.Timer.Timer;
    string ifname;
    string ofname;

    SmootherT!(MyMesh).Continuity 
        continuity = SmootherT!(MyMesh).Continuity.C1;

    SmootherT!(MyMesh).Component  
        component  = SmootherT!(MyMesh).Component.Tangential_and_Normal;

    int iterations;

    // ---------------------------------------- evaluate command line

    while ( (c=getopt(argv, "tnc:h"))!=-1 )
    {
        switch(c)
        {
        case 'c': {
            switch(*optarg)
            { 
            case '0' : continuity = SmootherT!(MyMesh).Continuity.C0; break;
            case '1' : continuity = SmootherT!(MyMesh).Continuity.C1; break;
            }
            break;
        }
        case 't':
            component = component==SmootherT!(MyMesh).Component.Normal
                ? SmootherT!(MyMesh).Component.Tangential_and_Normal
                : SmootherT!(MyMesh).Component.Tangential;
        break;

        case 'n': 
            component = component==SmootherT!(MyMesh).Component.Tangential 
                ? SmootherT!(MyMesh).Component.Tangential_and_Normal
                : SmootherT!(MyMesh).Component.Normal;
        break;

        case 'h': usage(); return 0;
        case '?':
        default:  usage(); return 1;
        }
    }
  
    if (argv.length-optind < 3) {
        usage(); return(1);
    }


    // # iterations
    {
        iterations = std.conv.toInt(argv[optind]);
    }


    // input file
    ifname = argv[++optind];


    // output file
    ofname = argv[++optind];


    auxd.OpenMesh.Core.IO.Options.Options opt;

    // ---------------------------------------- read mesh
  
    dout.writefln( "read mesh...").flush;
    t.start();
    read_mesh(mesh, ifname, opt);
    t.stop();
    dout.writefln( "done (" , t.as_string() , ")\n");

    dout.writefln( "  #V " , mesh.n_vertices()).flush;
    foreach(v; mesh.vertices_begin) {
        dout.writefln("  %s", *mesh.point_ptr(v));
    }

    // ---------------------------------------- smooth

    scope smoother = new JacobiLaplaceSmootherT!(MyMesh)(mesh);
    dout.writefln( "initializing...").flush;
    smoother.initialize(component,continuity);
 
    dout.writefln( "smoothing...").flush;

    t.start(); 
    smoother.smooth(iterations); 
    t.stop();

    dout.writefln( "done (",
                   t.seconds() , "s ~ ",
                   t.as_string() , ", " ,
                   (iterations*mesh.n_vertices())/t.seconds() , " Vertices/s)");

    // ---------------------------------------- write mesh

    dout.writefln( "write mesh...") .flush;
    foreach(v; mesh.vertices_begin) {
        dout.writefln("  %s", *mesh.point_ptr(v));
    }
    t.start();
    write_mesh(mesh, ofname, opt);
    t.stop();
    dout.writefln( "done (" , t.as_string() , "s)").flush;

    return 0;
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
