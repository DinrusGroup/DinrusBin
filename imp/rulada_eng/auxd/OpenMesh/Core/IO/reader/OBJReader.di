//============================================================================
// OBJReader.d -
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description:
 *  Implements an reader module for OBJ files
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 01 Sep 2007
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
//============================================================================

module auxd.OpenMesh.Core.IO.reader.OBJReader;

//=== INCLUDES ================================================================


import auxd.OpenMesh.Core.IO.Streams;

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.SingletonT;
import auxd.OpenMesh.Core.IO.importer.BaseImporter;
import auxd.OpenMesh.Core.IO.reader.BaseReader;
import auxd.OpenMesh.Core.IO.Options;
import auxd.OpenMesh.Core.IO.IOManager;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Utils.color_cast;
import auxd.OpenMesh.Core.Mesh.Handles;
import util = auxd.OpenMesh.Core.Utils.Std;

static import std.string;
static import std.path;
import std.c;
import std.ctype;

//== IMPLEMENTATION ===========================================================

private {
    bool startsWith(string s, string sub) {
        return (s.length>=sub.length && s[0..sub.length]==sub);
    }
    bool endsWith(string s, string sub) {
        return (s.length>=sub.length && s[$-sub.length..$]==sub);
    }
}

/**
    Implementation of the OBJ format reader.
*/
class _OBJReader_ : public BaseReader
{
  public:

    this() {   IOManager().register_module(this); }

    string get_description() /*const*/ { return "Alias/Wavefront"; }
    string get_extensions()  /*const*/ { return "obj"; }

    bool read(/*const*/ string _filename,
              BaseImporter _bi,
              inout Options _opt)
    {
        FILE* fin = fopen(std.string.toStringz(_filename), "r");
        if (!fin)
        {
            derr.writefln("[OBJReader] : cannot not open file ", _filename).flush;
            return false;
        }

        {
            // Figure out the base path for loading mtl files
            path_ = std.path.getDirName(_filename);
        }

        IO_Options opt_ret = _opt;
        // Take away things OBJ doesn't support
        opt_ret -= IO_Options.Binary;
        opt_ret -= IO_Options.FaceNormal;
        opt_ret -= IO_Options.VertexColor;
        // May have vertex normals or vertex texcoord, but we have to 
        // read on to find out.  FaceColor may be taken from 
        // material properties.

        bool ok = read(fin, _bi, opt_ret);

        fclose(fin);

        _opt = opt_ret;
        return ok;
    }

  private:

    class Material
    {
    public:

        this() { reset(); }

        void reset()
        {
            has_Kd = false;
            has_Ka = false;
            has_Ks = false;
            has_Tr = false;
            has_Ns = false;
            has_illum = false;

            // Default vals according to spec
            Ka=[0.2f,0.2,0.2];
            Kd=[0.8f,0.8,0.8];
            Ks=[1.0f,1.0,1.0];
            Tr=1.0f;
            Ns=0.0f;
            illum = 1;
            map_Ka = null;
            map_Kd = null;
            map_Ks = null;
            map_Tr = null;
            map_Ns = null;
            map_Bump = null;
        }
        string toString() {
            char[] ret = "Material(";
            if (has_Kd) ret ~= "Kd,";
            if (has_Ka) ret ~= "Ka,";
            if (has_Ks) ret ~= "Ks,";
            if (has_Tr) ret ~= "Tr,";
            if (has_Ns) ret ~= "Ns,";
            if (map_Ka !is null) { ret ~= "map_Ka=" ~ map_Ka ~","; }
            if (map_Kd !is null) { ret ~= "map_Kd=" ~ map_Kd ~",";}
            if (map_Ks !is null) { ret ~= "map_Ks=" ~ map_Ks ~","; }
            if (map_Tr !is null) { ret ~= "map_Tr=" ~ map_Tr ~","; }
            if (map_Ns !is null) { ret ~= "map_Ns=" ~ map_Ns ~","; }
            if (ret[$-1]==',') ret[$-1]=')';
            else { ret ~= ")"; }
            return ret;
        }

        bool is_valid() /*const*/
        { return has_Kd || has_Ka || has_Ks || has_Tr || has_Ns; }

        void set_Kd( float r, float g, float b )
        { Kd=Vec3f(r,g,b); has_Kd=true; }

        void set_Ka( float r, float g, float b )
        { Ka=Vec3f(r,g,b); has_Ka=true; }

        void set_Ks( float r, float g, float b )
        { Ks=Vec3f(r,g,b); has_Ks=true; }

        void set_Ns( float t )
        { Ns=t;            has_Ns=true; }

        void set_Tr( float t )
        { Tr=t;            has_Tr=true; }

        void set_illum( int i )
        { illum=i;         has_illum=true; }


    public: // data
        bool has_Ka; // ambient
        bool has_Kd; // diffuse
        bool has_Ks; // specular
        bool has_Tr; // transperency
        bool has_Ns; // shininess
        bool has_illum; /* illumination mode
                         *   1: flat material, ignore specular Ks
                         *   2: with specular 
                         */
        Vec3f Ka;
        Vec3f Kd;
        Vec3f Ks;
        float Tr;
        float Ns;
        int   illum;
        char[] map_Ka;
        char[] map_Kd;
        char[] map_Ks;
        char[] map_Tr;
        char[] map_Ns;
        char[] map_Bump;
    }

    alias Material[string] MaterialList;

    MaterialList materials_;

    const LINE_LEN = 1024;
    bool read_mtl( FILE* _in )
    {
        char[LINE_LEN]   line_buf;

        string key;
        Material    mat = null;
        float       f1,f2,f3;
        int         i1;

        char[] line;

        memset(line_buf.ptr,0,LINE_LEN);
        while( _in && !feof(_in) && fgets(line_buf.ptr, LINE_LEN, _in) )
        {
            if (line_buf[0] == '#') // skip comments
            {
                memset(line_buf.ptr,0,LINE_LEN);
                continue;
            }
            
            line = std.string.strip(line_buf[0..strlen(line_buf.ptr)]);

            if (line.startsWith("newmtl ")) // begin new material definition
            {
                if (mat !is null && key.length!=0) {
                    materials_[key] = mat;
                }
                mat = new Material;
                char* p0 = line.ptr+6;
                char* p1;
                while( isspace(*++p0) ){} p1=p0;
                while(!isspace(*p1)) ++p1; *p1='\0';
                key   = p0[0..p1-p0].dup;
            }
            else if (line.startsWith("Kd ")) // diffuse color
            {
                if (sscanf(line.ptr, "Kd %f %f %f", &f1, &f2, &f3))
                    mat.set_Kd(f1,f2,f3);
            }

            else if (line.startsWith("Ka ")) // ambient color
            {
                if (sscanf(line.ptr, "Ka %f %f %f", &f1, &f2, &f3))
                    mat.set_Ka(f1,f2,f3);
            }

            else if (line.startsWith("Ks ")) // specular color
            {
                if (sscanf(line.ptr, "Ks %f %f %f", &f1, &f2, &f3))
                    mat.set_Ks(f1,f2,f3);
            }
            else if (line.startsWith("illum ")) // diffuse/specular shading model
            {
                if (sscanf(line.ptr, "illum %d", &i1))
                {
                    mat.set_illum(i1);
                }
            }
            else if (line.startsWith("Ns ")) // Shininess [0..200]
            {
                if (sscanf(line.ptr, "Ns %f", &f1))
                {
                    mat.set_Ns(f1);
                }
            }
            else if (line.startsWith("Tr ")) // transparency value
            {
                if (sscanf(line.ptr, "Tr %f", &f1))
                    mat.set_Tr(f1);
            }
            else if (line.startsWith("d ")) // transparency value
            {
                if (sscanf(line.ptr, "d %f", &f1))
                    mat.set_Tr(f1);
            }

            else if (line.startsWith("map_Ka ")) // ambient map
            {
                mat.map_Ka = std.string.strip(line[7..$]).dup;
            }
            else if (line.startsWith("map_Kd ")) // diffuse map
            {
                mat.map_Kd = std.string.strip(line[7..$]).dup;
            }
            else if (line.startsWith("map_Ks ")) // specular map
            {
                mat.map_Kd = std.string.strip(line[7..$]).dup;
            }
            else if (line.startsWith("map_Tr ")) // opacity map
            {
                mat.map_Tr = std.string.strip(line[7..$]).dup;
            }
            else if (line.startsWith("map_d ")) // opacity map
            {
                mat.map_Tr = std.string.strip(line[6..$]).dup;
            }
            else if (line.startsWith("map_Bump ")) // bump map
            {
                mat.map_Bump = std.string.strip(line[9..$]).dup;
            }
                     
            memset(line_buf.ptr,0,LINE_LEN);
        }
        // commit last material
        if (mat !is null && key.length!=0)
            materials_[key] = mat;

        debug(OBJReader) {
            dout.writefln("Read materials:");
            foreach(k,v; materials_) {
                dout.writefln("  %s: %s", k,v);
            }
            dout.flush;
        }

        return true;

    }

  private:

    bool read(FILE* _in, BaseImporter _bi, inout Options _opt)

    {
        //dlog.writefln("[OBJReader] : read file").flush;

        char[LINE_LEN]         s;
        float                  x, y, z, u, v, w;

        BaseImporter.VHandles vhandles;

        bool used_vtexc=false,used_vnorm=false,used_fcolor=false;
        bool want_vtexc = _opt.check(IO_Options.VertexTexCoord);
        bool want_vnorm = _opt.check(IO_Options.VertexNormal);
        bool want_fcolor = _opt.check(IO_Options.FaceColor);

        Vec3f[]     normals;
        Vec2f[]     texcoords;

        Material[string]  materials;
        string            matname;

        memset(s.ptr, 0, LINE_LEN);

        FaceHandle[] fh_list; fh_list.length = 10;
        uint line_num = 1;
        while(_in && !feof(_in) && fgets(s.ptr, LINE_LEN, _in))
        {
            //dout.writef("read: ", s[0..strlen(s.ptr)]).flush;

            // comment
            if (s[0] == '#' || isspace(s[0]))  {
                line_num++;
                continue;
            }

            // material file
            else if (strncmp(s.ptr, "mtllib ", 7)==0)
            {
                char mtlfile[256];

                if ( sscanf(s.ptr, "mtllib %s", mtlfile.ptr) )
                {
                    string file = path_ ~ mtlfile[0..strlen(mtlfile.ptr)];

                    FILE * _mtl = fopen( std.string.toStringz(file), std.string.toStringz("r") );
                    if ( _mtl !is null )
                    {
                        if ( !read_mtl(_mtl) )
                            derr.writefln("  Warning: Failure reading mtl file '%s'", file).flush;
                        fclose( _mtl );
                        dlog.writefln("  " , materials_.length , " materials loaded.").flush;
                    }
                    else
                        derr.writefln("  Warning: Material file '", file, "' not found!").flush;
                }
            }

            // usemtl
            else if (strncmp(s.ptr, "usemtl ", 7)==0)
            {
                char *p0 = s.ptr+6;
                char *p1;
                while( isspace(*++p0) ){} p1=p0;
                while(!isspace(*p1)) {++p1;} *p1='\0';
                matname = p0[0..p1-p0].dup;
                if (!(matname in materials_))
                {
                    derr.writefln("Warning: Material '" , matname ,
                                  "' not defined in material file.");
                    matname="";
                }
            }

            // vertex
            else if (strncmp(s.ptr, "v ", 2) == 0)
            {
                if (sscanf(s.ptr, "v %f %f %f", &x, &y, &z))
                    _bi.add_vertex(Vec3f(x,y,z));
            }


            // texture coord
            else if (strncmp(s.ptr, "vt ", 3) == 0)
            {
                if (sscanf(s.ptr, "vt %f %f %f", &u, &v, &w)==2)
                {
                    texcoords ~= Vec2f(u, v);
                    _opt += Options.VertexTexCoord;
                }
                else
                {
                    derr.writefln("Only single 2D texture coordinate per vertex allowed!" ).flush;
                    return false;
                }
            }


            // normal
            else if (strncmp(s.ptr, "vn ", 3) == 0)
            {
                if (sscanf(s.ptr, "vn %f %f %f", &x, &y, &z))
                    normals ~= Vec3f(x,y,z);
                _opt += Options.VertexNormal;
            }


            // face
            else if (strncmp(s.ptr, "f ", 2) == 0)
            {
                int component=0, nV=0;
                bool endOfVertex=false;
                char *p0;
                char *p1=(s.ptr+1);

                vhandles.length = 0;

                while (*p1 == ' ') ++p1; // skip white-spaces

                while (p1)
                {
                    p0 = p1;

                    // overwrite next separator

                    // skip '/', '\n', ' ', '\0', '\r' <-- don't forget Windows
                    while (*p1 != '/' && *p1 != '\r' && *p1 != '\n' &&
                           *p1 != ' ' && *p1 != '\0')
                        ++p1;

                    // detect end of vertex
                    if (*p1 != '/') endOfVertex = true;

                    // replace separator by '\0'
                    if (*p1 != '\0')
                    {
                        *p1 = '\0';
                        p1++; // point to next token
                    }

                    // detect end of line and break
                    if (*p1 == '\0' || *p1 == '\n')
                        p1 = null;


                    // read next vertex component
                    if (*p0 != '\0')
                    {
                        alias std.string.atoi atoi;
                        string str = p0[0..strlen(p0)];
                        int id = atoi(str);
                        if (id>0) {
                            // obj uses 1-based indexing
                            id -= 1;
                        } else {
                            // negative indices allowed too.
                            // -1 is last vert so far, -2 second to last, etc...
                            id += _bi.n_vertices;


                        }

                        // TODO: if same vert appears in different faces with 
                        // different texture coords or normals, then it needs to 
                        // be split into 2 separate verts.

                        switch (component)
                        {
                        case 0: // vertex id
                            vhandles ~= VertexHandle(id);
                            break;

                        case 1: // texture coord id
                            if (want_vtexc) {
                                assert(vhandles.length !=0 );
                                assert(cast(uint)id < texcoords.length);
                                _bi.set_texcoord(vhandles[$-1], texcoords[id]);
                                used_vtexc = true;
                            }
                            break;

                        case 2: // vertex normal id
                            if (want_vnorm) {
                                assert(vhandles.length!=0);
                                assert(cast(uint)id < normals.length);
                                _bi.set_normal(vhandles[$-1], normals[id]);
                                used_vnorm = true;
                            }
                            break;
                        }
                    }

                    ++component;

                    if (endOfVertex)
                    {
                        component = 0;
                        nV++;
                        endOfVertex = false;
                    }
                }

                // TODO: Fix this to use new generic property handling facilities like
                // the ply reader.  Instead of just cherry picking Kd to use as the color.

                //dout.writefln("add face: %s", vhandles);
                fh_list.length = 0;
                FaceHandle fh = _bi.add_face(vhandles, &fh_list);

                if ( want_fcolor && matname.length!=0 && materials_[matname].has_Kd )
                {
                    Material mat = materials_[matname];

                    Vec3ub fc = color_cast!(Vec3ub)(mat.Kd);

                    foreach (it; fh_list) {
                        _bi.set_color( it, fc );
                    }
                    used_fcolor = true;
                }
            }

            memset(&s, 0, LINE_LEN);
            line_num++;
        }

        if (!used_fcolor) _opt -= IO_Options.FaceColor;
        if (!used_vnorm)  _opt -= IO_Options.VertexNormal;
        if (!used_fcolor) _opt -= IO_Options.VertexTexCoord;

        return true;

    }

    string path_;

}


//== TYPE DEFINITION ==========================================================

static this() {
    // creates and registers the default instance;
    OBJReader();
}



private _OBJReader_  __OBJReaderInstance = null;
_OBJReader_ OBJReader() {
    if (__OBJReaderInstance is null) {
        __OBJReaderInstance = new _OBJReader_();
    }
    return __OBJReaderInstance;
}


unittest {
    auto reader = OBJReader() ;
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
