//============================================================================
// decimater.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 28 Aug 2007
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

module decimater;


// ----------------------------------------------------------------------------

static import std.string;
//--------------------
import auxd.OpenMesh.Core.IO.MeshIO;
//--------------------
import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
//--------------------
static import auxd.OpenMesh.Core.Mesh.api;
import auxd.OpenMesh.Core.Utils.vector_cast;
import auxd.OpenMesh.Tools.Utils.getopt;
import auxd.OpenMesh.Core.IO.Streams;
import OpenMeshIO = auxd.OpenMesh.Core.IO.MeshIO;
import UtilTimer = auxd.OpenMesh.Tools.Utils.Timer;
import IOOptions = auxd.OpenMesh.Core.IO.Options;
import MDecimater = auxd.OpenMesh.Tools.Decimater.api;

static import auxd.OpenMesh.Core.IO.readers;
static import auxd.OpenMesh.Core.IO.writers;

import Utils.CmdOption;

//----------------------------------------------------------------- traits ----

alias auxd.OpenMesh.Core.Mesh.api.DefaultTraits MyTraits;

//------------------------------------------------------------------- mesh ----

alias TriMesh_ArrayKernelT!(MyTraits) ArrayTriMesh;


//-------------------------------------------------------------- decimator ----

alias MDecimater.DecimaterT!(ArrayTriMesh)   Decimater;

//---------------------------------------------------------------- globals ----

int gverbose = 0;
int gdebug   = 0;

//--------------------------------------------------- decimater arguments  ----


struct DecOptions
{
    static DecOptions opCall()
    { 
        DecOptions M; with(M) {
            n_collapses = 0.0;
        } return M;
    }

    CmdOption!(bool)        decorate_name;
    CmdOption!(bool)        lock_boundary;
    CmdOption!(float)       n_collapses;
    CmdOption!(float)       Q;    // Quadrics
    CmdOption!(float)       NF;   // Normal Flipping
    CmdOption!(bool)        IS;   // Independent Sets
    CmdOption!(char[])      PM;   // Progressive Mesh
    CmdOption!(float)       R;    // Roundness

    bool init(T)(ref CmdOption!(T) _o, string _val )
    {
        if ( _val.length == 0 )
            _o.enable();
        else
        {
            T v;
            try {
                v = convert!(T)(_val);
            }
            catch {
                return false;
            }      
            _o = v;
        }
        return true;
    }


    bool parse_argument( string arg )
    {
        int pos = std.string.find(arg, ':');

        string name;
        string value;

        if (pos == -1)
            name = arg;
        else
        {
            name  = arg[0..pos];
            value = arg[pos+1..$];
        }
        name = std.string.strip(name);
        value = std.string.strip(value);
        
        if (name == "Q")  return init(Q,  value);
        if (name == "NF") return init(NF, value);
        if (name == "PM") return init(PM, value);
        if (name == "IS") return init(IS, value);
        if (name == "R")  return init(R,  value);
        return false;
    }
}

//----------------------------------------------------- decimater wrapper  ----
//
bool
decimate(Mesh,Decimater)(string _ifname,
                         string _ofname,
                         DecOptions _opt)
{
    Mesh                 mesh;
    IOOptions.Options  opt;
    scope timer = new UtilTimer.Timer;

    // ---------------------------------------- read source mesh
    {
        if (gverbose)
            dlog.writef("source mesh: ").flush;
        bool rc;
   
        if (gverbose)
            dlog.writefln(_ifname).flush;
        if ( (rc = OpenMeshIO.read_mesh(mesh, _ifname, opt))==0 )
        {
            derr.writefln("  ERROR: read of '", _ifname, "' failed!" );
            return rc;
        }
    }
   
    // ---------------------------------------- do some decimation
    {
        // ---- 0 - For module NormalFlipping one needs face normals

        if ( !opt.check( IOOptions.Options.FaceNormal ) )
        {
            if ( !mesh.has_face_normals() )
                mesh.request_face_normals();

            if (gverbose)
                dlog.writefln("  updating face normals").flush;
            mesh.update_face_normals();
        }
     
        if ( _opt.lock_boundary.is_enabled() )
        {
            mesh.request_vertex_status();
            // iterate over all vertices
            for (Mesh.VertexIter v_it=mesh.vertices_begin(); v_it!=mesh.vertices_end(); ++v_it) 
            {
                // do something with *h_it, h_it->, or h_it.handle()
                if (mesh.is_boundary(v_it.handle)) {
                    mesh.vstatus_ptr(v_it.handle).set_locked(true);
                }
            }
        }

        // ---- 1 - create decimater instance
        Decimater decimater = new Decimater( mesh );
     
        // ---- 2 - registrate modules
        if (gverbose)
            dlog.writefln("  register modules" ).flush;
          
     
        MDecimater.ModQuadricT!(Decimater).Handle        modQ;

        if (_opt.Q.is_enabled())
        {
            decimater.add(modQ);
            if (_opt.Q.has_value())
                decimater.get_module( modQ ).set_max_err( _opt.Q.val );
        }

        MDecimater.ModNormalFlippingT!(Decimater).Handle modNF;
     
        if (_opt.NF.is_enabled())
        {
            decimater.add(modNF);
            if (_opt.NF.has_value())
                decimater.get_module( modNF ).set_normal_deviation( _opt.NF.val );
        }

        MDecimater.ModProgMeshT!(Decimater).Handle       modPM;

        if ( _opt.PM.is_enabled() )
            decimater.add(modPM);


        MDecimater.ModIndependentSetsT!(Decimater).Handle modIS;
     
        if ( _opt.IS.is_enabled() )
            decimater.add(modIS);


        MDecimater.ModRoundnessT!(Decimater).Handle      modR;

        if ( _opt.R.is_enabled() )
        {
            decimater.add( modR );
            if ( _opt.R.has_value() )
                decimater.get_module( modR ).set_min_angle( _opt.R.val,
                                                            !modQ.is_valid() ||
                                                            !decimater.get_module(modQ).is_binary());
        }

        // ---- 3 - initialize decimater

        if (gverbose)
            dlog.writefln("initializing mesh" ).flush;
     
        {
            bool rc;
            timer.start();
            rc = decimater.initialize();
            timer.stop();
            if (!rc)
            {
                derr.writefln( "  initializing failed! (Did you specify a non-binary module like -M Q:0.1");
                return false;
            }
        }
        if (gverbose)
            dlog.writefln("  Elapsed time: ", timer.as_string());

        if (gverbose)
            decimater.info( dlog );

        // ---- 4 - do it

        if (gverbose)
        {
            dlog.writefln("decimating");
            dlog.writefln("  # vertices: ", mesh.n_vertices());
        }

        float nv_before = cast(float)mesh.n_vertices();

        timer.start();
        int rc = 0;
        float nc = _opt.n_collapses.val;
        if (nc < 0.0)
            rc = decimater.decimate_to( cast(size_t)(-nc) );
        else if (nc >= 1.0 || nc == 0.0)
            rc = decimater.decimate( cast(size_t)nc );
        else if (nc > 0.0f)
            rc = decimater.decimate_to(cast(size_t)(mesh.n_vertices() * nc));
        timer.stop();
     
        // ---- 5 - write progmesh file for progviewer (before garbage collection!)
     
        if ( _opt.PM.has_value() )
            decimater.get_module(modPM).write( _opt.PM.val );
    
        // ---- 6 - throw away all tagged edges

        mesh.garbage_collection();

        if (gverbose)
        {       
            dlog.writefln(
                      "  # executed collapses: " , rc, "\n",
                      "  # vertices: " , mesh.n_vertices() , ", ",
                      ( 100.0*mesh.n_vertices()/nv_before ) , "%%\n",
                      "  Elapsed time: " , timer.as_string() , "\n",
                      "  collapses/s : " , rc/timer.seconds()).flush;
        }

    }
      
    // write resulting mesh
    if ( _ofname.length != 0 )
    {
        string ofname = _ofname;

        int pos = std.string.rfind(ofname,'.');
        if (pos == -1)
        {
            ofname ~= ".off";
            pos = std.string.rfind(ofname, '.');
        }

        if ( _opt.decorate_name.is_enabled() )
        {
            ofname = std.string.insert(ofname,  pos, "-");
            ofname = std.string.insert(ofname, ++pos, std.string.format(mesh.n_vertices()));
        }

        IOOptions.Options optb;

        //optb += auxd.OpenMesh.IO.Options.Binary;

        if ( !OpenMeshIO.write_mesh(mesh, ofname, optb ) )
        {
            derr.writefln("  Cannot write decimated mesh to file '", 
                          ofname).flush;
            return false;
        }
        dlog.writefln("  Exported decimated mesh to file '", ofname).flush;
    }
   
    return true;
}

//------------------------------------------------------------------ main -----

int main(string[] argv)   
{
    string  ifname, ofname;
   
    DecOptions opt = DecOptions();

    //
    version(OM_USE_OSG) {
        osg.osgInit( argv.length, argv.ptr );
    }

    //---------------------------------------- parse command line
    {
        int c;
    
        while ( (c=getopt( argv, "dbDhi:M:n:o:v")) != -1 )
        {
            switch (c)
            {
            case 'D': opt.decorate_name = true;   break;
            case 'b': opt.lock_boundary = true;   break;
            case 'd': gdebug        = true;   break;
            case 'h': usage_and_exit(0);
            case 'i': ifname        = optarg; break;
            case 'o': ofname        = optarg; break;
            case 'M': opt.parse_argument( optarg ); break;
            case 'n': opt.n_collapses = std.conv.toFloat(optarg); break;
            case 'v': gverbose      = true;   break;
            case '?':
            default:
                derr.writefln("FATAL: cannot process command line option '", cast(char)c , "'!").flush;
                std.c.exit(-1);
            }                  
        }
    }

    //----------------------------------------

    if ( (-1.0f < opt.n_collapses.val) &&  (opt.n_collapses.val < 0.0f) )
    {
        derr.writefln("Error: Option -n: invalid value argument!").flush;
        usage_and_exit(2);
    }

    if (!ifname || !ofname) {
        derr.writefln("Error: You  must specify -i and -o arguments for input and output");
        usage_and_exit(3);
    }

    //----------------------------------------

    if (gverbose)
    {
        dlog.writefln( 
            "    Input file: " , ifname, "\n",
            "   Output file: " , ofname, "\n",
            "    #collapses: " , opt.n_collapses).flush;
    }


    //----------------------------------------


   
    if (gverbose)
    {
        dlog.writefln("Begin decimation").flush;
    }
   
    bool rc = decimate!(ArrayTriMesh, Decimater)( ifname, ofname, opt );

    if (gverbose)
    {
        if (!rc)
            dlog.writefln( "Decimation failed!");
        else
            dlog.writefln( "Decimation done." );
    }

    //----------------------------------------
    return 0;
}


//-----------------------------------------------------------------------------

void usage_and_exit(int xcode)
{
    char[] errmsg;
  
    switch(xcode)
    {
    case 1: errmsg = "Option not supported!"; break;
    case 2: errmsg = "Invalid output file format!"; break;
    case 3: errmsg = "Missing file argument!"; break;
    }
  
    derr.writefln();
    if (xcode)
    {
        derr.writefln("Error ", xcode,  ": ", errmsg, "\n");
    }
    derr.writefln(
        "Usage: decimator [Options] -i input-file -o output-file\n"
        "  Decimating a mesh using quadrics and normal flipping.\n"
        "Options\n"
        " -b               - lock the boundary\n"
        " -v               - verbose\n"
        " -n <N>\n"
        "    N >= 1: do N halfedge collapses.\n"
        "    N <=-1: decimate down to |N| vertices.\n"
        "    0 < N < 1: decimate down to N%%.\n"
        "\n"
        " -M \"{Module-Name}[:Value]}\"\n"
        "    Use named module with eventually given parameterization\n"
        "\n"
        "Modules:\n\n"
        "  IS              - ModIndependentSets\n"
        "  NF[:angle]      - ModNormalFlipping\n"
        "  PM[:file name]  - ModProgMesh\n"
        "  Q[:error]       - ModQuadric\n"
        "  R[:angle]       - ModRoundness\n"
        "    0 < angle < 60\n");
    
    std.c.exit( xcode );
}



//                             end of file
//=============================================================================



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
