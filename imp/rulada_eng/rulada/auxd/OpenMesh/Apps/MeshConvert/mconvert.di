/*==========================================================================
 * mconvert.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * Command-line tool to convert one mesh format to another using OpenMesh/D
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Date: 12 Oct 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 */
//===========================================================================

module auxd.OpenMesh.Apps.MeshConvert.mconvert;

pragma(lib, "auxD");

import auxd.OpenMesh.Core.IO.Streams;

import meshio = auxd.OpenMesh.Core.IO.MeshIO;
import io_opt = auxd.OpenMesh.Core.IO.Options;
import stdutil = auxd.OpenMesh.Core.Utils.Std;
import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
import auxd.OpenMesh.Core.Mesh.PolyMesh_ArrayKernelT;
import auxd.OpenMesh.Core.Mesh.Traits;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Mesh.Attributes;
import auxd.OpenMesh.Tools.Utils.Timer;
import auxd.OpenMesh.Tools.Utils.getopt;

static import std.conv;
static import std.string;


class MyTraits : public DefaultTraits
{
    const uint
        VertexAttributes = AttributeBits.Normal | AttributeBits.Color | AttributeBits.TexCoord2D,
        HalfedgeAttributes = AttributeBits.PrevHalfedge,
        FaceAttributes  = AttributeBits.Normal | AttributeBits.Color;
}

alias TriMesh_ArrayKernelT!(MyTraits) MyTriMesh;
alias PolyMesh_ArrayKernelT!(MyTraits) MyMesh;

void usage()
{
   
    dout.writefln("\nUsage: mconvert [option] <input> [<output>]\n");
    dout.writefln("   Convert from one 3D geometry format to another.\n"
                  "   Or simply display some information about the object\n"
                  "   stored in <input>.\n");
    dout.writefln("Options:");
    dout.writefln("  -b\tUse binary mode if supported by target format." );
    dout.writefln("    -l\tStore least significant bit first (LSB, little endian)." );
    dout.writefln("    -m\tStore most significant bit first (MSB, big endian)." );
    dout.writefln("    -s\tSwap byte order.\n" );
    dout.writefln("  -B\tUse binary mode if supported by source format." );
    dout.writefln("    -S\tSwap byte order of input data." );
    dout.writefln("  -c\tCopy vertex color if provided by input." );
    dout.writefln("  -d\tCopy face color if provided by input." );
    dout.writefln("  -C\tTranslate object in its center-of-gravity." );
    dout.writefln("  -n\tCopy vertex normals if provided by input. Else compute normals." );
    dout.writefln("  -N\tReverse normal directions.\n" );
    dout.writefln("  -t\tCopy vertex texture coordinates if provided by input file." );
    dout.writefln("  -T \"x y z\"\tTranslate object by vector (x, y, z)");
    dout.writefln;
}

// ----------------------------------------------------------------------------

struct Option(T)
{
    T value;
    bool is_valid = false;

    bool is_empty() { return !is_valid; }
    void opAssign( T _rhs )
    { value = _rhs; is_valid=true; }
}

// ----------------------------------------------------------------------------

int main(string[] argv )
{
    // ------------------------------------------------------------ command line

    int c;
    string ifname, ofname;
    bool rev_normals = false;
    bool obj_center  = false;
    io_opt.Options opt, ropt;

    Option!(MyMesh.Point) tvec;

    while ( (c=getopt(argv, "bBcdCi:hlmnNo:sStT:"))!=-1 )
    {
        switch(c)
        {
        case 'b': opt  += io_opt.Options.Binary; break;
        case 'B': ropt += io_opt.Options.Binary; break;
        case 'l': opt  += io_opt.Options.LSB; break;
        case 'm': opt  += io_opt.Options.MSB; break;
        case 's': opt  += io_opt.Options.Swap; break;
        case 'S': ropt += io_opt.Options.Swap; break;
        case 'n': 
            opt  += io_opt.Options.VertexNormal; 
            opt  += io_opt.Options.FaceNormal; break;
        case 'N': rev_normals = true; break;
        case 'C': obj_center  = true; break;
        case 'c': opt  += io_opt.Options.VertexColor; break;
        case 'd': opt  += io_opt.Options.FaceColor; break;
        case 't': opt  += io_opt.Options.VertexTexCoord; break;
        case 'T': 
        {
            dout.writefln(optarg);
            auto components = std.string.split(optarg);
            MyMesh.Point p;
            foreach(i,comp; components) {
                p[i] = std.conv.toFloat(comp);
            }
            tvec = p;
            dout.writefln(p);
            break;
        }
        case 'i': ifname = optarg; break;
        case 'o': ofname = optarg; break;
        case 'h':
            usage(); return 0;
        case '?':
        default:
            usage(); return 1;
        }
    }

    if (!ifname)
    { 
        if (optind < argv.length)
            ifname = argv[optind++];
        else {
            usage(); return 1;
        }
    }

    MyMesh mesh;
    scope timer = new Timer;

    // ------------------------------------------------------------ read

    dout.writefln("reading..");
    {
        bool rc;
        timer.start();
        rc = meshio.read_mesh( mesh, ifname, ropt );
        timer.stop();
        if (rc)
            dout.writefln("  read in " , timer.as_string());
        else
        {
            dout.writefln("  read failed\n");
            return 1;
        }       
        timer.reset();
    }


    // ---------------------------------------- some information about input
    dout.writefln(ropt.check(io_opt.Options.Binary) 
                  ? "  source is binary\n"
                  : "  source is ascii\n");   

    dout.writefln("  #V " , mesh.n_vertices());
    dout.writefln("  #E " , mesh.n_edges());
    dout.writefln("  #F " , mesh.n_faces());

    if (ropt.vertex_has_texcoord())
        dout.writefln("  has texture coordinates");
    
    if (ropt.vertex_has_normal())
        dout.writefln("  has vertex normals");

    if (ropt.vertex_has_color())
        dout.writefln("  has vertex colors");
    
    if (ropt.face_has_normal())
        dout.writefln("  has face normals");

    if (ropt.face_has_color())
        dout.writefln("  has face colors");

    // 
    if (!ofname)
    {
        if ( optind < argv.length )
            ofname = argv[optind++];
        else
            return 0;
    }

    // ------------------------------------------------------------ features

    // ---------------------------------------- compute normal feature
    if ( opt.vertex_has_normal && !ropt.vertex_has_normal)
    {
        dout.writefln("compute vertex normals");

        timer.start();
        mesh.update_face_normals();
        timer.stop();
        dout.writefln("  " , mesh.n_faces()
                      , " face normals in " , timer.as_string());
        timer.reset();
    }
    if ( opt.face_has_normal && !ropt.face_has_normal)
    {
        dout.writefln("compute face normals");

        timer.start();
        mesh.update_face_normals();
        timer.stop();
        dout.writefln("  " , mesh.n_faces()
                      , " face normals in " , timer.as_string());
        timer.reset();
       
    }


    // ---------------------------------------- reverse normal feature
    if ( rev_normals && ropt.vertex_has_normal() )
    {
        dout.writefln("reverse normal directions");
        timer.start();
        MyMesh.VertexIter vit = mesh.vertices_begin;
        for (; vit != mesh.vertices_end; ++vit)
            mesh.set_normal( vit.handle, -mesh.normal( vit.handle ) );
        timer.stop();
        dout.writefln("  " , mesh.n_vertices(),
                      " vertex normals in " , timer.as_string());
        timer.reset();
    }


    // ---------------------------------------- centering feature
    if ( obj_center )
    {
        auto cog = Vec3f(0,0,0);
        size_t nv;
        dout.writefln("center object");
        timer.start();    
        MyMesh.VertexIter vit = mesh.vertices_begin();
        for (; vit != mesh.vertices_end(); ++vit)
            cog += mesh.point( vit.handle );
        timer.stop();
        nv   = mesh.n_vertices();
        cog *= 1.0f/mesh.n_vertices();
        dout.writefln("  cog = [" , cog , "]'");
        if (cog.sqrnorm() > 0.8) // actually one should consider the size of object
        {
            vit = mesh.vertices_begin();
            timer.cont();
            for (; vit != mesh.vertices_end(); ++vit)
                mesh.set_point( vit.handle , mesh.point( vit.handle )-cog );
            timer.stop();
            nv += mesh.n_vertices();
        }
        else
            dout.writefln("    already centered!");
        dout.writefln("  visited " , nv
                      , " vertices in " , timer.as_string());
        timer.reset();       
    }


    // ---------------------------------------- translate feature
    if ( tvec.is_valid )
    {
        dout.writefln("Translate object by " , tvec);

        timer.start();
        MyMesh.VertexIter vit = mesh.vertices_begin();
        for (; vit != mesh.vertices_end(); ++vit)
            mesh.set_point( vit.handle , mesh.point( vit.handle ) + tvec.value );
        timer.stop();
        dout.writefln("  moved " , mesh.n_vertices()
                      , " vertices in " , timer.as_string());
    }

    // ---------------------------------------- color vertices feature
    if (  opt.check( io_opt.Options.VertexColor ) &&
          !ropt.check( io_opt.Options.VertexColor ) )
    {
        dout.writefln("Color vertices");

        double d  = 256.0/cast(double)mesh.n_vertices();
        double d2 = d/2.0;
        double r  = 0.0, g = 0.0, b = 255.0;
        timer.start();
        MyMesh.VertexIter vit = mesh.vertices_begin();
        for (; vit != mesh.vertices_end(); ++vit)
        {
            mesh.set_color( vit.handle , MyMesh.Color( stdutil.min(cast(int)(r+0.5),255), 
                                                       stdutil.min(cast(int)(g+0.5),255), 
                                                       stdutil.max(cast(int)(b+0.5),0) ) );
            r += d;
            g += d2;
            b -= d;
        }
        timer.stop();
        dout.writefln("  colored " , mesh.n_vertices()
                      , " vertices in " , timer.as_string());
    }

    // ---------------------------------------- color faces feature
    if (  opt.check( io_opt.Options.FaceColor ) &&
          !ropt.check( io_opt.Options.FaceColor ) )
    {
        dout.writefln("Color faces");

        double d  = 256.0/cast(double)mesh.n_faces();
        double d2 = d/2.0;
        double r  = 0.0, g = 50.0, b = 255.0;
        timer.start();
        MyMesh.FaceIter it = mesh.faces_begin();
        for (; it != mesh.faces_end(); ++it)
        {
            mesh.set_color( it.handle , MyMesh.Color( stdutil.min(cast(int)(r+0.5),255), 
                                                      stdutil.min(cast(int)(g+0.5),255), 
                                                      stdutil.max(cast(int)(b+0.5),0) ) );
            r += d2;
//       g += d2;
            b -= d;
        }
        timer.stop();
        dout.writefln("  colored " , mesh.n_faces(),
                      " faces in " , timer.as_string());
    }

    // ------------------------------------------------------------ write
  
    dout.writefln("writing..");    
    {
        bool rc;
        timer.start();
        // remove any unsupported options before writing
        io_opt.Options wantopt = opt;
        meshio.supported_writer_options(ofname, opt);
        rc = meshio.write_mesh( mesh, ofname, opt );
        timer.stop();
       
        if (!rc)
        {
            derr.writefln("  error writing mesh!");
            return 1;
        }
       
        // -------------------------------------- write output and some info
        if ( opt.check(io_opt.Options.Binary) )
        {          
            dout.writefln("  Binary size: %s bytes", meshio.binary_size(mesh, ofname, opt));
        }
        else if ( wantopt.check(io_opt.Options.Binary) )
        {
            dout.writefln("  [binary output not supported]");
        }

        if ( opt.vertex_has_normal() )
            dout.writefln("  with vertex normals");
        else if ( wantopt.vertex_has_normal() )
            dout.writefln("  [vertex normals not supported]");
        
        if ( opt.vertex_has_color() )
            dout.writefln("  with vertex colors");
        else if ( wantopt.vertex_has_color() )
            dout.writefln("  [vertex colors not supported]");

        if ( opt.vertex_has_texcoord() )
            dout.writefln("  with vertex texcoord");
        else if ( wantopt.vertex_has_texcoord() )
            dout.writefln("  [vertex texcoord not supported]");

        if ( opt.face_has_normal() )
            dout.writefln("  with face normals");
        else if ( wantopt.face_has_normal() )
            dout.writefln("  [face normals not supported]");

        if ( opt.face_has_color() )
            dout.writefln("  with face colors");
        else if ( wantopt.face_has_color() )
            dout.writefln("  [face colors not supported]");

        dout.writefln("  wrote in " , timer.as_string());
        timer.reset();       
    }

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
