/*==========================================================================
 * adaptive_subdivider.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * <TODO: Module Summary>
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 17 Oct 2007
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

module auxd.OpenMesh.Apps.Subdivider.adaptive_subdivider;


// --- IMPORTS -----------------------------------------------------

// -------------------- OpenMesh
import auxd.OpenMesh.Core.IO.MeshIO;
import auxd.OpenMesh.Core.IO.Options;
import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Tools.Utils.Timer;
import auxd.OpenMesh.Tools.Utils.getopt;
// -------------------- OpenMesh Adaptive Composite Subdivider
import auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.CompositeT;
import auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.RulesT;
import auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.CompositeTraits;
alias auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.CompositeTraits CTraits;
// -------------------- STL
import auxd.OpenMesh.Core.IO.Streams;
import std.math;
import std.string;
import std.path;
import std.conv;

//import std.io;

// define mesh, rule interface, and subdivider types
alias TriMesh_ArrayKernelT!(CompositeTraits) MyMesh;
//alias RuleInterfaceT!(MyMesh)  Rule;
alias CompositeT!(MyMesh)      Subdivider;

// ----------------------------------------------------------------------------

// factory function to add a RULE to a subdivider
static string ADD_FN(string RULE)
{
    return
        "bool add_"~RULE~"( Subdivider _sub )\n"
        "{ return _sub.addT!("~RULE~"!(MyMesh))().is_valid; }";
}

mixin(ADD_FN( "Tvv3" ));
mixin(ADD_FN( "Tvv4" ));
mixin(ADD_FN( "VF"   ));
mixin(ADD_FN( "FF"   ));
mixin(ADD_FN( "FFc"  ));
mixin(ADD_FN( "FV"   ));
mixin(ADD_FN( "FVc"  ));
mixin(ADD_FN( "VV"   ));
mixin(ADD_FN( "VVc"  ));
mixin(ADD_FN( "VE"   ));
mixin(ADD_FN( "VdE"  ));
mixin(ADD_FN( "VdEc" ));
mixin(ADD_FN( "EV"   ));
mixin(ADD_FN( "EVc"  ));
mixin(ADD_FN( "EF"   ));
mixin(ADD_FN( "FE"   ));
mixin(ADD_FN( "EdE"  ));
mixin(ADD_FN( "EdEc" ));

// Function type for 
alias bool function( Subdivider )  add_rule_ft;

// map rule name to factory function
class RuleMap
{
    alias add_rule_ft[string] MapT;
    MapT map_;
    
    add_rule_ft* opIn_r(string key) {
        return key in map_;
    }
    add_rule_ft opIndex(string key) {
        return map_[key];
    }
    void opIndexAssign(add_rule_ft val, string key) {
        map_[key] = val;
    }

    this()
    {
        static string ADD(string name) {
            return "map_[\""~name~"\"] = &add_"~name~";";
        }
        mixin(ADD( "Tvv3" ));
        mixin(ADD( "Tvv4" ));
        mixin(ADD( "VF"   ));
        mixin(ADD( "FF"   ));
        mixin(ADD( "FFc"  ));
        mixin(ADD( "FV"   ));
        mixin(ADD( "FVc"  ));
        mixin(ADD( "VV"   ));
        mixin(ADD( "VVc"  ));
        mixin(ADD( "VE"   ));
        mixin(ADD( "VdE"  ));
        mixin(ADD( "VdEc" ));
        mixin(ADD( "EV"   ));
        mixin(ADD( "EVc"  ));
        mixin(ADD( "EF"   ));
        mixin(ADD( "FE"   ));
        mixin(ADD( "EdE"  ));
        mixin(ADD( "EdEc" ));
    }
}
    

// ----------------------------------------------------------------------------


int main(string[] argv)
{
    size_t  n_iter = 0;          // n iteration
    size_t  max_nv = size_t.max; // max. number of vertices in the end
    string  ifname;              // input mesh
    string  ofname;              // output mesh
    string  rule_sequence = "Tvv3 VF FF FVc"; // sqrt3 default
    bool    uniform = false;
    int     c;

    // ---------------------------------------- evaluate command line
    while ( (c=getopt(argv, "hlm:n:r:sU"))!=-1 )
    {
        switch(c)
        {
        case 's': rule_sequence = "Tvv3 VF FF FVc";       break; // sqrt3
        case 'l': rule_sequence = "Tvv4 VdE EVc VdE EVc"; break; // loop
        case 'n': n_iter = std.conv.toUint(optarg); break;
        case 'm': max_nv = std.conv.toUint(optarg); break;
        case 'r': rule_sequence = optarg.dup; break;
        case 'U': uniform = true; break;
        case 'h': usage(argv[0]); return(0);
        case '?':
        default:  usage(argv[0]); return(1);
        }
    }

    if ( optind == argv.length ) {
        usage(argv[0]); return(2);
    }

    if ( optind < argv.length )
        ifname = argv[optind++];

    if ( optind < argv.length )
        ofname = argv[optind++];

    // if ( optind < argv.length ) // too many arguments

    // ---------------------------------------- mesh and subdivider
    auto mesh = new MyMesh;
    auto subdivider = new Subdivider(mesh);


    // -------------------- read mesh from file
        dout.writef( "Input mesh         : " , ifname , "\n").flush;
    if (!read_mesh(mesh, ifname))
    {
        derr.writef( "  Error reading file!\n").flush;
        return 1;
    }

    // store orignal size of mesh
    size_t n_vertices = mesh.n_vertices;
    size_t n_edges    = mesh.n_edges;
    size_t n_faces    = mesh.n_faces;

    if ( n_iter > 0 )
        dout.writef( "Desired #iterations: " , n_iter , "\n").flush;

    if ( max_nv < size_t.max )
    {
        dout.writef( "Desired max. #V    : " , max_nv , "\n").flush;
        if (!n_iter )
            n_iter = size_t.max;
    }


    scope available_rules = new RuleMap;

    // -------------------- Setup rule sequence
    // The grammar is a sequence of subdivision rules with possible options
    {

        add_rule_ft it_second = null;
        string it_first = null;

        string[] tokens;
        string token;

        tokens = std.string.split(rule_sequence);
        string pop(ref string[] ss) 
        { string ret = ss[0]; ss = ss[1..$]; return ret; }
        
        while (tokens.length!=0)
        {
            token = tokens.pop();
            auto _pRuleFn = token in available_rules;
            if ( _pRuleFn !is null )
            {
                (*_pRuleFn)( subdivider );
            }
            else if ( token[0]=='(' && subdivider.n_rules > 0 )
            {
                int beg=1;
                if (token.length==1)
                {
                    token = tokens.pop();
                    beg = 0;
                }

                int end  = token.rfind(')');
                if (end<0) end=token.length;

                MyMesh.Scalar coeff;
                dout.writef( "  %s\n" , token).flush;
                dout.writef( "  %s %s\n", beg , end).flush;
                coeff = std.conv.toDouble(token[beg..end]);
                dout.writef( "  coeffecient %s\n" , coeff).flush;
                subdivider.rule( subdivider.n_rules()-1 ).set_coeff(coeff);

                if (end == token.length)
                {
                    token = tokens.pop();
                    if (token[0]!=')')
                    {
                        derr.writef( "Syntax error: Missing ')'\n").flush;
                        return 1;
                    }
                }
            }
            else
            {
                derr.writef( "Syntax error: " , token , "?\n").flush;
                return 1;
            }
        }
    }

    dout.writef( "Rule sequence      : %s\n", subdivider.rules_as_string);

    // -------------------- Initialize subdivider
    dout.writef( "Initialize subdivider\n").flush;
    if (!subdivider.initialize())
    {
        derr.writef( "  Error!\n").flush;
        return 1;
    }

    //
    MyMesh.FaceFaceIter   ff_it;
    double                quality=(0.0), face_quality, temp_quality;
    int                   valence;

    // ---------------------------------------- subdivide
    dout.writef( "\nSubdividing...\n").flush;

    scope timer = new Timer;
    scope timer2 = new Timer;
    size_t                 i;

    if ( uniform )
    { // unifom
        MyMesh.VertexHandle vh;
        MyMesh.VertexIter   v_it;
        MyMesh.FaceHandle   fh;
        MyMesh.FaceIter     f_it;


        // raise all vertices to target state
        timer.start();

        size_t n       = n_iter;
        size_t n_rules = subdivider.n_rules();

        i = 0;

        // calculate target states for faces and vertices
        int target1 = (n - 1) * n_rules + subdivider.subdiv_rule().number() + 1;
        int target2 = n * n_rules;

        for (f_it = mesh.faces_begin(); f_it != mesh.faces_end(); ++f_it) {

            if (mesh.data(f_it.handle).state() < target1) {
                ++i;
                fh = f_it.handle;
                timer2.start();
                subdivider.refine(fh);
                timer2.stop();
            }
        }

        for (v_it = mesh.vertices_begin(); v_it != mesh.vertices_end(); ++v_it) {

            if (mesh.data(v_it.handle).state() < target2) {
                vh = v_it.handle;
                timer2.cont();
                subdivider.refine(vh);
                timer2.stop();
            }
        }
        timer.stop();
    }
    else
    { // adaptive

        MyMesh.FaceIter   f_it;
        MyMesh.FaceHandle fh;

        double[]            __acos;
        size_t              buckets=3000;
        double              range=2.0;
        double              range2bucket=buckets/range;

        __acos.length = buckets+1;
        for (i = 0; i < buckets; ++i)
            __acos[i] = ( acos(-1.0 + i * range / buckets) );
        __acos[$-1] = 0.0;

        timer.start(); // total time needed

        //  n iterations or until desired number of vertices reached approx.
        for (i = 0; i < n_iter && mesh.n_vertices < max_nv; ++i)
        {
            mesh.update_face_normals();

            // calculate quality
            quality = 0.0;

            fh = mesh.faces_begin.handle;

            // check every face
            for (f_it = mesh.faces_begin; f_it != mesh.faces_end; ++f_it) {

                face_quality = 0.0;
                valence      = 0;

                for (ff_it = mesh.ff_iter(f_it.handle); ff_it.is_active; ++ff_it) {

                    temp_quality = dot( *mesh.normal_ptr(f_it.handle),
                                        *mesh.normal_ptr(ff_it.handle) );

                    if (temp_quality >= 1.0)
                        temp_quality = .99;
                    else if (temp_quality <= -1.0)
                        temp_quality = -.99;
                    temp_quality  = (1.0+temp_quality) * range2bucket;
                    face_quality += __acos[cast(int)(temp_quality+.5)];

                    ++valence;
                }

                face_quality /= valence;

                // calaculate face area
                MyMesh.Point  p1, p2, p3;
                MyMesh.Scalar area;

                //auto heh = &mesh.halfedge_handle;
                //auto nheh = &mesh.next_halfedge_handle;
                //auto tvh  = &mesh.to_vertex_handle;
                //auto fvh = &mesh.from_vertex_handle;
                with (mesh) {
                    alias halfedge_handle heh;
                    alias next_halfedge_handle nheh;
                    alias to_vertex_handle tvh;
                    alias from_vertex_handle fvh;
                    p1 = point(to_vertex_handle(halfedge_handle(f_it.handle)));
                    p2 = point(from_vertex_handle(halfedge_handle(f_it.handle)));
                    p3 = point(to_vertex_handle(
                                   next_halfedge_handle(
                                       halfedge_handle(f_it.handle))));
                }

                area = cross(p2 - p1,p3 - p1).norm;

                // weight face_quality
                face_quality *= pow(area, .1);
                //face_quality *= area;

                if (face_quality >= quality && !mesh.is_boundary(f_it.handle))
                {
                    quality = face_quality;
                    fh      = f_it.handle;
                }
            }

            // Subdivide Face
            //timer2.cont;
            subdivider.refine(fh);
            //timer2.stop;
        }

        // calculate time
        timer.stop();

    } // uniform/adaptive?

    // calculate maximum refinement level
    CTraits.state_t max_level = 0;

    for (MyMesh.VertexIter v_it = mesh.vertices_begin;
         v_it != mesh.vertices_end; ++v_it)
    {
        if (mesh.data_ptr(v_it.handle).state > max_level)
            max_level = mesh.data_ptr(v_it.handle).state;
    }


    // output results
    dout.writef( "\nDid " , i , (uniform ? " uniform " : "" ),
                 " subdivision steps in ",
                 timer.as_string,
                 ", " , i/timer.seconds , " steps/s\n");
    dout.writef( "  only refinement: " , timer2.as_string,
                 ", " , i/timer2.seconds , " steps/s\n\n");

    dout.writef( "Before: ");
    dout.writef( n_vertices , " Vertices, ");
    dout.writef( n_edges , " Edges, ");
    dout.writef( n_faces , " Faces. \n");

    dout.writef( "Now   : ");
    dout.writef( mesh.n_vertices , " Vertices, ");
    dout.writef( mesh.n_edges , " Edges, ");
    dout.writef( mesh.n_faces , " Faces. \n\n");

    dout.writef( "Maximum quality          : " , quality , "\n");
    dout.writef( "Maximum Subdivision Level: " , max_level/subdivider.n_rules,
                 "\n" , "\n").flush;

    // ---------------------------------------- write mesh to file
    {
        if ( ofname.length == 0 )
        {
            ofname = std.string.format("result.%s-%sx.off",
                                       subdivider.rules_as_string("_"),i);
        }

        dout.writef( "Output file: '" , ofname , "'.\n").flush;
        if (!write_mesh(mesh, ofname, Options(Options.Binary)))
        {
            derr.writef( "  Error writing file!\n").flush;
            return 1;
        }
    }
    return 0;
}

// ----------------------------------------------------------------------------
// helper

void usage(string _fname)
{
    dout.writef( "\n"
                 "Usage: " , std.path.getBaseName(_fname),
                 " [Options] input-mesh [output-mesh]\n\n");
    dout.writef( "\tAdaptively refine an input-mesh. The refined mesh is stored in\n"
                 "\ta file named \"result.XXX.off\" (binary .off), if not specified\n"
                 "\texplicitely (optional 2nd parameter of command line).\n\n");
    dout.writef( "Options:\n");
    dout.writef( "-n <int>\n\tAdaptively refine <int> times.\n"
                 "-m <int>\n\tAdaptively refine up to approx. <int> vertices.\n"
                 "-l\tUse rule sequence for adaptive Loop.\n"
                 "-s\tUse rule sequence for adaptive sqrt(3).\n"
                 "-U\tRefine mesh uniformly (simulates uniform subdivision).\n"
                 "-r <rule sequence>\n\tDefine a custom rule sequence.\n"
                 "\tAvailable rules are:\n"
                 "\t\t Tvv3, Tvv4, VF, FF, FFc, FV, FVc,\n"
                 "\t\t VV, VVc, VE, VdE, VdEc, EV, EVc, EF, FE, EdE, EdEc\n\n").flush;
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
