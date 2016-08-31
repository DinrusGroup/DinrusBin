/*==========================================================================
 * MeshLoaderT.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * <TODO: Module Summary>
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Date: 17 Nov 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 */
//===========================================================================

module MeshLoader;
version(Tango) import std.compat;

import MeshIO = auxd.OpenMesh.Core.IO.MeshIO;
alias MeshIO.IO_Options IO_Options;
import auxd.OpenMesh.Core.IO.Streams;

bool open_mesh(Mesh)(ref Mesh mesh, string _filename, ref IO_Options _opt = IO_Options(IO_Options.All))
{
    // load mesh
    // calculate normals
    // set scene center and radius   
  
    dout.writefln("Loading from file '" , _filename, "'...").flush;
    if ( MeshIO.read_mesh(mesh, _filename, _opt ))
    {
    
        // update face and vertex normals
        if ( _opt.check( IO_Options.FaceNormal ) ) {
            dout.writefln("File provides face normals");
        }
    
        if ( _opt.check( IO_Options.VertexNormal ) ) {
            dout.writefln("File provides vertex normals");
        }

        // check for possible color information
        if ( _opt.check( IO_Options.VertexColor ) )
        {
            dout.writefln("File provides vertex colors");
        }


        if ( _opt.check( IO_Options.FaceColor ) )
        {
            dout.writefln("File provides face colors");
        }

        if ( _opt.check( IO_Options.VertexTexCoord ) )
            dout.writefln( "File provides texture coordinates");

        {
            string got_one;
            auto vpit = mesh.vprops_begin, vpend = mesh.vprops_end;
            for(; vpit!=vpend; ++vpit) {
                if (!vpit.val) { continue; }
                string pname = vpit.val.name;
                if (pname.length >= 2 && pname[0..2]=="v:") 
                    continue; // reserved prop name
                if(got_one.length==0) got_one = pname.dup;
                TypeInfo ptype = vpit.val.element_type;
                dout.writefln("File provides per-vertex property '%s' of type %s",
                              pname, ptype);
            }
        }
        {
            string got_one;
            auto vpit = mesh.fprops_begin, vpend = mesh.fprops_end;
            for(; vpit!=vpend; ++vpit) {
                if (!vpit.val) { continue; }
                string pname = vpit.val.name;
                if (pname.length >= 2 && pname[0..2]=="f:") 
                    continue; // reserved prop name
                if(got_one.length==0) got_one = pname.dup;
                TypeInfo ptype = vpit.val.element_type;
                dout.writefln("File provides per-face property '%s' of type %s",
                              pname, ptype);
            }
        }

        // info
        dlog.writefln( mesh.n_vertices() , " vertices, ",
                       mesh.n_edges()    , " edges, ",
                       mesh.n_faces()    , " faces").flush;
    
    
        // loading done
        return true;
    }
    return false;
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
