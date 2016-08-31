/*==========================================================================
 * DrawerHelpers.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * <TODO: Module Summary>
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Date: 15 Nov 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 */
//===========================================================================

module MeshDrawHelpers;
version(Tango) import std.compat;

import derelict.opengl.gl;
import derelict.opengl.glu;
import auxd.OpenMesh.Core.Geometry.VectorTypes;
import auxd.OpenMesh.Core.Utils.casts;

import std.io;
alias writefln debugfln;

private template Tuple(Args...)
{
    alias Args Tuple;
}

template DrawFunctors(Mesh)
{
    alias Mesh.FaceHandle FaceHandle;
    alias Mesh.VertexHandle VertexHandle;
    alias Mesh.HalfedgeHandle HalfedgeHandle;
    alias Mesh.EdgeHandle EdgeHandle;
    alias Mesh.FaceIter   FaceIter;
    alias Mesh.Vertex     Vertex;
    alias Mesh.Point      Point;
    alias Mesh.Scalar     Scalar;

    mixin MeshGL!(Mesh);


    class draw_points {
        const string name = "Points";
        rawdraw_points rawdraw;
        this() { rawdraw = new typeof(rawdraw); }
        void draw(Mesh mesh) {
            glDisable(GL_LIGHTING);
            rawdraw.draw(mesh);
        }
    }
    class draw_wire_tris {
        const string name = "Wireframe";
        rawdraw_wire_tris rawdraw;
        this() { rawdraw = new typeof(rawdraw); }
        void draw(Mesh mesh) {
            glDisable(GL_LIGHTING);
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
            rawdraw.draw(mesh);
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
        }
    }
    class draw_wire_polys {
        const string name = "Wireframe Polygons";
        rawdraw_wire_polys rawdraw;
        this() { rawdraw = new typeof(rawdraw); }
        void draw(Mesh mesh) {
            glDisable(GL_LIGHTING);
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
            rawdraw.draw(mesh);
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
        }
    }

    class draw_solid_flat_tris_quads : rawdraw_solid_flat_tris_quads {
        string name =  "Solid Flat";
        this(bool _Tris=true, bool _Quads=false) { 
            super(_Tris,_Quads);
            if (!_Tris && _Quads) name ~= " Quads";
            if (_Tris && _Quads) name ~= " w/Quads";
        }
        void draw(Mesh mesh)
        {
            glEnable(GL_LIGHTING);
            glShadeModel(GL_FLAT);
            super.draw(mesh);
        }
    }
  
    class draw_solid_flat_and_wireframe_tris_quads {
        string name =  "Solid Flat + Wireframe";
        rawdraw_solid_flat_tris_quads rawdraw_flat;
        rawdraw_wire_polys rawdraw_wire;
        this(bool _tris=true, bool _quads=false) { 
            if (!_tris && _quads) name ~= " Quads";
            else if (_tris && _quads) name ~= " w/Quads";

            rawdraw_flat = new typeof(rawdraw_flat)(_tris,_quads);
            rawdraw_wire = new typeof(rawdraw_wire);
        }
        void draw(Mesh mesh)
        {
            glEnable(GL_LIGHTING);
            glShadeModel(GL_FLAT);
            glEnable(GL_POLYGON_OFFSET_FILL);
            glPolygonOffset (1., 1.);
            rawdraw_flat.draw(mesh);
            glDisable(GL_POLYGON_OFFSET_FILL);

            glDisable(GL_LIGHTING);
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
            glColor4f( 1.0f, 1.0f, 1.0f, 1.0f );
            rawdraw_wire.draw(mesh);

            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
        }
    }
        
    class draw_hidden_line_tris {
        const string name =  "Hidden-Line";
        rawdraw_wire_tris rawdraw;
        this() { rawdraw = new typeof(rawdraw); }
        void draw(Mesh mesh)
        {
            glDisable(GL_LIGHTING);
            glShadeModel(GL_FLAT);
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
            glColor4f( 0.0f, 0.0f, 0.0f, 1.0f );
            glDepthRange(0.01, 1.0);
            rawdraw.draw(mesh);
    
            glPolygonMode( GL_FRONT_AND_BACK, GL_LINE);
            glColor4f( 1.0f, 1.0f, 1.0f, 1.0f );
            glDepthRange( 0.0, 1.0 );
            rawdraw.draw(mesh);
    
            glPolygonMode( GL_FRONT_AND_BACK, GL_FILL);          
        }
    }
  
    class draw_solid_smooth_tris_quads : rawdraw_solid_smooth_tris_quads {
        string name =  "Solid Smooth";
        this(bool _Tris=true, bool _Quads=false) { 
            super(_Tris,_Quads);
            if (!_Tris && _Quads) name ~= " Quads";
            if (_Tris && _Quads) name ~= " w/Quads";
        }
        void draw(Mesh mesh)
        {
            glEnable(GL_LIGHTING);
            glShadeModel(GL_SMOOTH);
            super.draw(mesh);
        }
    }

    class draw_colored_vertices {
        const string name =  "Colored Vertices";
        rawdraw_colored_vertices rawdraw;
        this() { rawdraw = new typeof(rawdraw); }
        void draw(Mesh mesh)
        {
            glDisable(GL_LIGHTING);
            glShadeModel(GL_SMOOTH);
            rawdraw.draw(mesh);
        }
    }

    class draw_solid_faces {
        const string name =  "Solid Colored Faces";
        rawdraw_solid_faces rawdraw;
        this() { rawdraw = new typeof(rawdraw); }
        void draw(Mesh mesh)
        {
            glDisable(GL_LIGHTING);
            glShadeModel(GL_FLAT);
            rawdraw.draw(mesh);
            //setDefaultMaterial();
        }
    }
  
    class draw_smooth_faces {
        const string name =  "Smooth Colored Faces";
        rawdraw_smooth_faces rawdraw;
        this() { rawdraw = new typeof(rawdraw); }
        void draw(Mesh mesh)
        {
            glEnable(GL_LIGHTING);
            glShadeModel(GL_SMOOTH);
            rawdraw.draw(mesh);
            //setDefaultMaterial();
        }
    }

    class rawdraw_points
    {
        //const string name = "_Points";
        void draw(Mesh mesh) {
            Mesh.FaceIter fIt = mesh.faces_begin, fEnd= mesh.faces_end;
            Mesh.ConstFaceVertexIter fvIt;
            glEnableClientState(GL_VERTEX_ARRAY);
            glVertexPointer(3, GL_FLOAT, 0, mesh.points().ptr);

            if (mesh.has_vertex_colors()/* && use_color_*/)
            {
                glEnable(GL_COLOR_MATERIAL);
                glEnableClientState(GL_COLOR_ARRAY);
                glColorPointer(3, GL_UNSIGNED_BYTE, 0, mesh.vertex_colors().ptr);
            } else {
                glColor3f(1,1,1);
            }

            glDrawArrays( GL_POINTS, 0, mesh.n_vertices() );
            glDisableClientState(GL_VERTEX_ARRAY);
            glDisableClientState(GL_COLOR_ARRAY);
            glDisable(GL_COLOR_MATERIAL);
        }
    }

    class rawdraw_wire_tris
    {
        //const string name = "_Wireframe";
        void draw(Mesh mesh) {
            Mesh.FaceIter fIt = mesh.faces_begin, fEnd= mesh.faces_end;
            Mesh.ConstFaceVertexIter fvIt;
            glBegin(GL_TRIANGLES);
            for (; fIt!=fEnd; ++fIt)
            {
                fvIt = mesh.cfv_iter(fIt.handle()); 
                glVertex3fv( mesh.point_ptr(fvIt.handle).ptr );
                ++fvIt;
                glVertex3fv( mesh.point_ptr(fvIt.handle).ptr );
                ++fvIt;
                glVertex3fv( mesh.point_ptr(fvIt.handle).ptr );
            }
            glEnd();
        }
    }
    class rawdraw_wire_polys
    {
        //const string name = "_Wireframe Polygons";
        void draw(Mesh mesh) {
            Mesh.FaceIter fIt = mesh.faces_begin, fEnd= mesh.faces_end;
            Mesh.ConstFaceVertexIter fvIt;

            for (; fIt!=fEnd; ++fIt)
            {
                glBegin(GL_LINE_LOOP);
                foreach(vh; mesh.fv_iter(fIt.handle)) 
                {
                    glVertex3fv( mesh.point_ptr(vh).ptr );
                }
                glEnd();
            }
        }
    }
    class rawdraw_solid_flat_tris_quads
    {
        //const string name = "_Solid Flat";
        bool WithTris = true;
        bool WithQuads = false;
        this(bool _tris = true, bool _quads = false) {
            WithTris = _tris;
            WithQuads = _quads;
        }
        void draw(Mesh mesh) {
            bool docolor = mesh.has_face_colors()/* && use_color_*/;
            if (docolor) {
                glEnable(GL_COLOR_MATERIAL);
            }
            Mesh.FaceIter fIt, fEnd= mesh.faces_end;
            if (WithTris) {
                fIt = mesh.faces_begin;
                glBegin(GL_TRIANGLES);
                for (; fIt!=fEnd; ++fIt)
                {
                    if (mesh.valence(fIt.handle) != 3) continue;
                    glNormal3fv( mesh.normal_ptr(fIt.handle).ptr );
                    if (docolor)
                        glColor3ubv( mesh.color_ptr(fIt.handle).ptr );
      
                    foreach(fvh; mesh.fv_iter(fIt.handle)) { 
                        glVertex3fv( mesh.point_ptr(fvh).ptr );
                    }
                }
                glEnd();
            }
            if (WithQuads) {
                bool hasPoly = 0;
                fIt = mesh.faces_begin;
                glBegin(GL_QUADS);
                for (; fIt!=fEnd; ++fIt)
                {
                    int nv = mesh.valence(fIt.handle);
                    if (nv > 4) { hasPoly = true; }
                    if (nv == 4) {
                        glNormal3fv( mesh.normal_ptr(fIt.handle).ptr );
                        if (docolor)
                            glColor3ubv( mesh.color_ptr(fIt.handle).ptr );
      
                        foreach(fvh; mesh.fv_iter(fIt.handle)) { 
                            glVertex3fv( mesh.point_ptr(fvh).ptr );
                        }
                    }
                }
                glEnd();
                if (hasPoly) {
                    fIt = mesh.faces_begin;
                    for (; fIt!=fEnd; ++fIt)
                    {
                        int nv = mesh.valence(fIt.handle);
                        if (nv <= 4) { continue; }

                        glNormal3fv( mesh.normal_ptr(fIt.handle).ptr );
                        if (docolor)
                            glColor3ubv( mesh.color_ptr(fIt.handle).ptr );
                        
                        glBegin(GL_TRIANGLE_FAN);
                        foreach(fvh; mesh.fv_iter(fIt.handle)) { 
                            glVertex3fv( mesh.point_ptr(fvh).ptr );
                        }
                        glEnd();
                    }
                }
            }
            if (docolor) {
                glDisable(GL_COLOR_MATERIAL);
            }
        }    
    }
    class rawdraw_solid_smooth_tris_quads
    {
        //const string name = "_Solid Smooth";
        int tex_id = 0;
        int tex_mode = 0;
        bool WithTris = true;
        bool WithQuads = false;
        this(bool _tris = true, bool _quads = false) {
            WithTris = _tris;
            WithQuads = _quads;
        }
        void draw(Mesh mesh) {

            glEnableClientState(GL_VERTEX_ARRAY);
            glVertexPointer(3, GL_FLOAT, 0, mesh.points().ptr);

            glEnableClientState(GL_NORMAL_ARRAY);
            glNormalPointer(GL_FLOAT, 0, mesh.vertex_normals().ptr);

            if (mesh.has_vertex_colors())
            {
                glEnable(GL_COLOR_MATERIAL);
                glEnableClientState( GL_COLOR_ARRAY );
                glColorPointer(3, GL_UNSIGNED_BYTE, 0,mesh.vertex_colors().ptr);
            }

            if ( tex_id && mesh.has_vertex_texcoords2D() )
            {
                glEnableClientState(GL_TEXTURE_COORD_ARRAY);
                glTexCoordPointer(2, GL_FLOAT, 0, mesh.texcoords2D().ptr);
                glEnable(GL_TEXTURE_2D);
                glBindTexture(GL_TEXTURE_2D, tex_id);
                glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, tex_mode);
            }

            Mesh.FaceIter fIt, fEnd=mesh.faces_end;
            if (WithTris) {
                fIt = mesh.faces_begin;
                glBegin(GL_TRIANGLES);
                for (; fIt!=fEnd; ++fIt)
                {
                    if (mesh.valence(fIt.handle)!=3) continue;
                    auto fvIt = mesh.cfv_iter(fIt.handle); 
                    glArrayElement(fvIt.handle.idx);
                    ++fvIt;
                    glArrayElement(fvIt.handle.idx);
                    ++fvIt;
                    glArrayElement(fvIt.handle.idx);
                }
                glEnd();
            }

            if (WithQuads) {
                bool hasPoly = 0;
                fIt = mesh.faces_begin;
                glBegin(GL_QUADS);
                for (; fIt!=fEnd; ++fIt)
                {
                    int nv = mesh.valence(fIt.handle);
                    if (nv > 4) { hasPoly = true; }
                    if (nv == 4) {
                        auto fvIt = mesh.cfv_iter(fIt.handle);
                        glArrayElement(fvIt.handle.idx);
                        ++fvIt;
                        glArrayElement(fvIt.handle.idx);
                        ++fvIt;
                        glArrayElement(fvIt.handle.idx);
                        ++fvIt;
                        glArrayElement(fvIt.handle.idx);
                    }
                }
                glEnd();

                if (hasPoly) {
                    fIt = mesh.faces_begin;
                    for (; fIt!=fEnd; ++fIt)
                    {
                        int nv = mesh.valence(fIt.handle);
                        if (nv <= 4) { continue; }

                        glBegin(GL_TRIANGLE_FAN);
                        foreach(fvh; mesh.fv_iter(fIt.handle)) { 
                            glArrayElement( fvh.idx );
                        }
                        glEnd();
                    }
                }
            }

            glDisableClientState(GL_VERTEX_ARRAY);
            glDisableClientState(GL_NORMAL_ARRAY);
            glDisableClientState(GL_COLOR_ARRAY);
            glDisable(GL_COLOR_MATERIAL);

            if ( tex_id && mesh.has_vertex_texcoords2D() )
            {
                glDisableClientState(GL_TEXTURE_COORD_ARRAY);
                glDisable(GL_TEXTURE_2D);
            }
        }    
    }

    class rawdraw_colored_vertices
    {
        //const string name = "_Colored Vertices";
        void draw(Mesh mesh) {
            Mesh.FaceIter fIt = mesh.faces_begin, fEnd= mesh.faces_end;
            Mesh.ConstFaceVertexIter fvIt;


            glEnableClientState(GL_VERTEX_ARRAY);
            glVertexPointer(3, GL_FLOAT, 0, mesh.points().ptr);

            glEnableClientState(GL_NORMAL_ARRAY);
            glNormalPointer(GL_FLOAT, 0, mesh.vertex_normals().ptr);

            if ( mesh.has_vertex_colors() /*&& use_color_*/ )
            {
                glEnable(GL_COLOR_MATERIAL);
                glEnableClientState( GL_COLOR_ARRAY );
                glColorPointer(3, GL_UNSIGNED_BYTE, 0,mesh.vertex_colors().ptr);
            }

            glBegin(GL_TRIANGLES);
            for (; fIt!=fEnd; ++fIt)
            {
                fvIt = mesh.cfv_iter(fIt.handle()); 
                glArrayElement(fvIt.handle().idx());
                ++fvIt;
                glArrayElement(fvIt.handle().idx());
                ++fvIt;
                glArrayElement(fvIt.handle().idx());
            }
            glEnd();
    
            glDisableClientState(GL_VERTEX_ARRAY);
            glDisableClientState(GL_NORMAL_ARRAY);
            glDisableClientState(GL_COLOR_ARRAY);
            glDisable(GL_COLOR_MATERIAL);
        }  
    }

    class rawdraw_solid_faces
    {
        //const string name = "_Solid Colored Faces";
        void draw(Mesh mesh) {
            Mesh.FaceIter fIt = mesh.faces_begin, fEnd= mesh.faces_end;
            Mesh.ConstFaceVertexIter fvIt;


            glEnableClientState(GL_VERTEX_ARRAY);
            glVertexPointer(3, GL_FLOAT, 0, mesh.points().ptr);

            glEnableClientState(GL_NORMAL_ARRAY);
            glNormalPointer(GL_FLOAT, 0, mesh.vertex_normals().ptr);

            glBegin(GL_TRIANGLES);
            for (; fIt!=fEnd; ++fIt)
            {
                glColor( mesh, fIt.handle() );

                fvIt = mesh.cfv_iter(fIt.handle()); 
                glArrayElement(fvIt.handle().idx());
                ++fvIt;
                glArrayElement(fvIt.handle().idx());
                ++fvIt;
                glArrayElement(fvIt.handle().idx());
            }
            glEnd();
    
            glDisableClientState(GL_VERTEX_ARRAY);
            glDisableClientState(GL_NORMAL_ARRAY);
        }  

    }
    class rawdraw_smooth_faces
    {
        //const string name = "_Smooth Colored Faces";
        void draw(Mesh mesh) {
            Mesh.FaceIter fIt = mesh.faces_begin, fEnd= mesh.faces_end;
            Mesh.ConstFaceVertexIter fvIt;

            glEnableClientState(GL_VERTEX_ARRAY);
            glVertexPointer(3, GL_FLOAT, 0, mesh.points().ptr);

            glEnableClientState(GL_NORMAL_ARRAY);
            glNormalPointer(GL_FLOAT, 0, mesh.vertex_normals().ptr);

            glBegin(GL_TRIANGLES);
            for (; fIt!=fEnd; ++fIt)
            {
                glMaterial( mesh, fIt.handle() );

                fvIt = mesh.cfv_iter(fIt.handle()); 
                glArrayElement(fvIt.handle().idx());
                ++fvIt;
                glArrayElement(fvIt.handle().idx());
                ++fvIt;
                glArrayElement(fvIt.handle().idx());
            }
            glEnd();
    
            glDisableClientState(GL_VERTEX_ARRAY);
            glDisableClientState(GL_NORMAL_ARRAY);
        }  
    }
}

template MeshGL(Mesh) {
    void glVertex( Mesh mesh, /*const*/ ref Mesh.Point _p )
    { glVertex3fv( _p.ptr ); }
  
    // vertex properties

    void glVertex( Mesh mesh, /*const*/ Mesh.VertexHandle _vh )
    { glVertex3fv( mesh.point_ptr( _vh ).ptr ); }

    void glNormal( Mesh mesh, /*const*/ Mesh.VertexHandle _vh )
    { glNormal3fv( mesh.normal_ptr( _vh ).ptr ); }

    void glTexCoord( Mesh mesh, /*const*/ Mesh.VertexHandle _vh )
    { glTexCoord2fv( mesh.texcoord2D_ptr(_vh).ptr ); }
  
    void glColor( Mesh mesh, /*const*/ Mesh.VertexHandle _vh )
    { glColor3ubv( mesh.color_ptr(_vh).ptr ); }
  
    // face properties

    void glNormal( Mesh mesh, /*const*/ Mesh.FaceHandle _fh )
    { glNormal3fv( mesh.normal_ptr( _fh ).ptr ); }

    void glColor( Mesh mesh, /*const*/ Mesh.FaceHandle _fh )
    { glColor3ubv( mesh.color_ptr(_fh).ptr ); }

    void glMaterial( Mesh mesh, /*const*/ Mesh.FaceHandle _fh, 
                     int _f=GL_FRONT_AND_BACK, int _m=GL_DIFFUSE )
    { 
        Vec3f c = color_cast!(Vec3f)(mesh.color(_fh));
        Vec4f m = [ c[0], c[1], c[2], 1.0f ];
        
        glMaterialfv(_f, _m, m.ptr); 
    }

    // Generic color

    void glColorT(T)(ref T color) 
    { 
        static if(false) {}

	else static if(is(T==byte  )) { glColor3b(color,color,color); }
        else static if(is(T==ubyte )) { glColor3ub(color,color,color); }
        else static if(is(T==short )) { glColor3s(color,color,color); }
        else static if(is(T==ushort)) { glColor3us(color,color,color); }
        else static if(is(T==int   )) { glColor3i(color,color,color); }
        else static if(is(T==uint  )) { glColor3ui(color,color,color); }
        else static if(is(T==float )) { glColor3f(color,color,color); }
        else static if(is(T==double)) { glColor3d(color,color,color); }

        else static if(is(T==VectorT!(byte,   2))) { glColor3b(color[0],color[1],0); }
        else static if(is(T==VectorT!(ubyte,  2))) { glColor3ub(color[0],color[1],0); }
        else static if(is(T==VectorT!(short,  2))) { glColor3s(color[0],color[1],0); }
        else static if(is(T==VectorT!(ushort, 2))) { glColor3us(color[0],color[1],0); }
        else static if(is(T==VectorT!(int,    2))) { glColor3i(color[0],color[1],0); }
        else static if(is(T==VectorT!(uint,   2))) { glColor3ui(color[0],color[1],0); }
        else static if(is(T==VectorT!(float,  2))) { glColor3f(color[0],color[1],0); }
        else static if(is(T==VectorT!(double, 2))) { glColor3d(color[0],color[1],0); }

        else static if(is(T==VectorT!(byte,   3))) { glColor3bv(color.ptr); }
        else static if(is(T==VectorT!(ubyte,  3))) { glColor3ubv(color.ptr); }
        else static if(is(T==VectorT!(short,  3))) { glColor3sv(color.ptr); }
        else static if(is(T==VectorT!(ushort, 3))) { glColor3usv(color.ptr); }
        else static if(is(T==VectorT!(int,    3))) { glColor3iv(color.ptr); }
        else static if(is(T==VectorT!(uint,   3))) { glColor3uiv(color.ptr); }
        else static if(is(T==VectorT!(float,  3))) { glColor3fv(color.ptr); }
        else static if(is(T==VectorT!(double, 3))) { glColor3dv(color.ptr); }

        else static if(is(T==VectorT!(byte,   4))) { glColor4bv(color.ptr); }
        else static if(is(T==VectorT!(double, 4))) { glColor4dv(color.ptr); }
        else static if(is(T==VectorT!(float,  4))) { glColor4fv(color.ptr); }
        else static if(is(T==VectorT!(int,    4))) { glColor4iv(color.ptr); }
        else static if(is(T==VectorT!(short,  4))) { glColor4sv(color.ptr); }
        else static if(is(T==VectorT!(ubyte,  4))) { glColor4ubv(color.ptr); }
        else static if(is(T==VectorT!(uint,   4))) { glColor4uiv(color.ptr); }
        else static if(is(T==VectorT!(ushort, 4))) { glColor4usv(color.ptr); } 

            else {
                static assert(false, "Type '"~T.stringof~"' not supported");
            }
    }
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
