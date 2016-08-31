//============================================================================
// subdivider.d - 
//   Written in the D Programming Language (http://www.digitalmars.com/d)
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

module auxd.OpenMesh.Apps.Subdivider.subdivider;


import auxd.OpenMesh.Core.IO.Streams;
// ---------------------------------------- OpenMesh Stuff
import meshio = auxd.OpenMesh.Core.IO.MeshIO;
import auxd.OpenMesh.Core.IO.Options;
import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
import auxd.OpenMesh.Tools.Utils.Timer;
import auxd.OpenMesh.Tools.Utils.getopt;
// ---------------------------------------- Subdivider
import auxd.OpenMesh.Tools.Subdivider.Uniform.Sqrt3T;
import auxd.OpenMesh.Tools.Subdivider.Uniform.LoopT;
import auxd.OpenMesh.Tools.Subdivider.Uniform.CompositeSqrt3T;
import auxd.OpenMesh.Tools.Subdivider.Uniform.CompositeLoopT;

static import auxd.OpenMesh.Core.IO.readers;
static import auxd.OpenMesh.Core.IO.writers;


import std.io;


import auxd.OpenMesh.Tools.Subdivider.Uniform.Composite.CompositeTraits;
// ----------------------------------------------------------------------------

static import std.conv;

alias CompositeTraits       CTraits;
alias TriMesh_ArrayKernelT!(CTraits)              CMesh;

alias TriMesh_ArrayKernelT!()                              Mesh;
alias Sqrt3T!( Mesh )                              Sqrt3;
alias LoopT!( Mesh )                               Loop;
alias CompositeSqrt3T!( CMesh )                    CompositeSqrt3;
alias CompositeLoopT!( CMesh )                     CompositeLoop;

// ----------------------------------------------------------------------------

double[string] timings;

// ----------------------------------------------------------------------------

bool subdivide(Subdivider)( Subdivider.mesh_t _m, size_t _n, 
                            Timer.Format _fmt )
{
    bool       rc;
    scope         t = new Timer;
    scope subdivide = new Subdivider;
    
    dout.writefln("Subdivide %s times with '%s'" , _n, subdivide.name);
    
    subdivide.attach(_m);
    t.start();
    rc=subdivide( _n );
    t.stop();
    subdivide.detach();

    if (rc)
    {
        dout.writefln("  Done [%s]" , t.as_string(_fmt)).flush;
        timings[subdivide.name()] = t.seconds();
    }
    else
        dout.writefln("  Failed!").flush;
    return rc;
}

// ----------------------------------------------------------------------------

int mainT(Subdivider)( size_t _n, 
                       /*const*/ string _ifname, 
                       /*const*/ string _ofname, 
                       /*const*/ Timer.Format _fmt,
                       char force_mode = '0')
{
    // -------------------- read mesh
    dout.writefln( "Read mesh from file " , _ifname).flush;

    auto mesh = new Subdivider.mesh_t;

    Options opt;
    if ( meshio.read_mesh( mesh, _ifname, opt ) )
        dout.writefln("  OK");
    else
    {
        dout.writefln( "  Failed!");
        return 1;
    }

    dout.writefln( "  #V " , mesh.n_vertices(), 
                   ", #F " , mesh.n_faces(),
                   ", #E " , mesh.n_edges()).flush;

    // -------------------- subdividing
    try
    {
        if (!subdivide!(Subdivider)( mesh, _n, _fmt ))
            return 1;
    }
    catch(Exception x)
    {
        derr.writefln(x);
        return 1;
    }

    // -------------------- write mesh

    dout.writefln( "  #V " , mesh.n_vertices ,
                   ", #F " , mesh.n_faces,
                   ", #E " , mesh.n_edges);

    if ( _ofname )
    {
        dout.writefln("opt = %s", opt);
        Options oopt;
        dout.writefln( "Write resulting mesh to file " , _ofname , "..").flush;
        if (force_mode=='b') { oopt += Options.Binary; }
        else if (force_mode=='a') { oopt -= Options.Binary; }
        dout.writefln("oopt = %s", oopt).flush;
        if (meshio.write_mesh(mesh, _ofname, oopt))
        {
            dout.writefln( "OK").flush;
        }
        else
        {
            derr.writefln ("Failed! Could not write file!").flush;
            return 1;
        }
    }

    return 0;
}

// ----------------------------------------------------------------------------

int main(char[][] argv)
{
    int    c;

    bool        compare_all = false;
    size_t      n;
    string ifname;
    string ofname;

    enum {
        TypeSqrt3,
        TypeLoop,
        TypeCompSqrt3,
        TypeCompLoop
    } 
    auto st = TypeSqrt3;

    Timer.Format fmt = Timer.Format.Automatic;
    char force_mode = '0';

    void get_iters() {
        n = std.conv.toInt(optarg);
    }

    while ( (c=getopt(argv, "bacs:S:l:L:hf:"))!=-1 )
    {
        switch(c)
        {
        case 'b': force_mode = 'b'; break;
        case 'a': force_mode = 'a'; break;
        case 'c': compare_all=true; break;
        case 's': st = TypeSqrt3; get_iters(); break;
        case 'S': st = TypeCompSqrt3; get_iters(); break;
        case 'l': st = TypeLoop; get_iters(); break;
        case 'L': st = TypeCompLoop; get_iters(); break;
        case 'f': 
        {
            switch(*optarg)
            {          
            case 'm': fmt = Timer.Format.MSeconds; break;
            case 'c': fmt = Timer.Format.HSeconds; break;
            case 's': fmt = Timer.Format.Seconds;  break;
            case 'a':
            default:  fmt = Timer.Format.Automatic; break;
            }
            break;
        }
        case 'h':
        case '?': usage(); return 0;
        default:  usage(); return 1;
        }
    }
  
    if (argv.length-optind < 2) { 
        usage(); return 1;
    }

    // input file
    ifname = argv[optind++].dup;

    // output file, if provided
    if ( optind < argv.length ) {
        ofname = argv[optind++].dup;
    }

    // --------------------
    if ( compare_all )
    {
        int rc;
        rc  = mainT!(Sqrt3)         ( n, ifname, "", fmt );
        rc += mainT!(Loop)          ( n, ifname, "", fmt );
        rc += mainT!(CompositeSqrt3)( n, ifname, "", fmt );
        rc += mainT!(CompositeLoop) ( n, ifname, "", fmt );
    
        if (rc)
            return rc;

        dout.writefln.flush;

        dout.writefln( "Timings:");
        foreach(k,v; timings)
            dout.writefln( k , ": " , Timer.as_string(v) );
        dout.writefln( "Ratio composite/native algorithm:\n");
        dout.writefln( "sqrt(3): ", 
                       timings["Uniform Composite Sqrt3"]/timings["Uniform Sqrt3"],
                       "\n",
                       "loop   : ",
                       timings["Uniform Composite Loop"]/timings["Uniform Loop"]).flush;
        return 0;
    }
    else switch(st)
         {
         case TypeSqrt3: 
             return mainT!(Sqrt3)( n, ifname, ofname, fmt, force_mode );
         case TypeLoop:  
             return mainT!(Loop)( n, ifname, ofname, fmt, force_mode );
         case TypeCompSqrt3: 
             return mainT!(CompositeSqrt3)( n, ifname, ofname, fmt, force_mode );
         case TypeCompLoop:  
             return mainT!(CompositeLoop)( n, ifname, ofname, fmt, force_mode );
         }
    return 1;
}

// ----------------------------------------------------------------------------

void usage()
{
    dout.writefln(
        "Usage: subdivide [Subdivider Type] #Iterations Input [Output].\n"
        "Subdivider Type\n"
        "\n"
        "  -l\tLoop\n"
        "  -L\tComposite Loop\n"
        "  -s\tSqrt3\n"
        "  -S\tComposite Sqrt3\n"
        "\n"
        "  -a\tforce ascii output\n"
        "  -b\tforce binary output").flush;
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
