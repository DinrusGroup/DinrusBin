//============================================================================
// MeshDrawerT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 01 Sep 2007
 * Copyright: (C) 2007-2008 William Baxter, OLM Digital, Inc.
 */
//============================================================================

module MeshDrawerT;
version(Tango) import std.compat;

import derelict.opengl.gl;
import derelict.opengl.glu;

//import auxd.OpenMesh.Core.Mesh.api;
//import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
import auxd.OpenMesh.Core.IO.Options;
import auxd.OpenMesh.Core.Geometry.VectorTypes;
import auxd.OpenMesh.Core.Utils.casts;
import TimerUtil = auxd.OpenMesh.Tools.Utils.Timer;
import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.Utils.Std;
import auxd.OpenMesh.Core.Utils.Exceptions;

import auxd.OpenMesh.Tools.Utils.StripifierT;

import MeshIO = auxd.OpenMesh.Core.IO.MeshIO;

import MeshDrawHelpers;

class MeshDrawerT(MeshT) 
{
public:
    alias MeshT Mesh;
    alias MeshT.Point Point;
    alias MeshT.VertexHandle VertexHandle;
    alias StripifierT!(Mesh) MyStripifier;
    const size_t NONE = size_t.max;
    mixin MeshGL!(Mesh);

    this(Mesh mesh=null)
    { 
        f_strips_ = false; 
        tex_id_= 0;
        tex_mode_= GL_MODULATE;
        use_color_ = true;
        show_vnormals_ = false;
        show_fnormals_ = false;
        mesh_ = mesh;

        alias MeshDrawHelpers.DrawFunctors!(Mesh) DFunc;
        void add(DrawMode m) {
            known_draw_modes_[m.name] = m;
        }
        add( new StockDrawMode!(DFunc.draw_points) );
        add( new StockDrawMode!(DFunc.draw_wire_tris) );
        add( new StockDrawMode!(DFunc.draw_wire_polys) );
        add( new StockDrawMode!(DFunc.draw_solid_flat_tris_quads) );
        add( new StockDrawMode!(DFunc.draw_solid_flat_tris_quads)(
                 new DFunc.draw_solid_flat_tris_quads(true,true)) );
        add( new StockDrawMode!(DFunc.draw_solid_flat_and_wireframe_tris_quads) );
        add( new StockDrawMode!(DFunc.draw_solid_flat_and_wireframe_tris_quads)(
                 new DFunc.draw_solid_flat_and_wireframe_tris_quads(true,true)) );
        add( new StockDrawMode!(DFunc.draw_solid_smooth_tris_quads) );
        add( new StockDrawMode!(DFunc.draw_solid_smooth_tris_quads)(
                 new DFunc.draw_solid_smooth_tris_quads(true,true)) );
        add( new StockDrawMode!(DFunc.draw_hidden_line_tris) );
        add( new StockDrawMode!(DFunc.draw_colored_vertices) );
        add( new StockDrawMode!(DFunc.draw_solid_faces) );
        add( new StockDrawMode!(DFunc.draw_smooth_faces) );
        add( new StripsNVertexArraysMode );
        add( new ShowStripsMode );
        add( new VertexPropertyMode );
        add( new FacePropertyMode );

        reset_draw_modes();

    }

    class DrawMode {
        abstract void opCall();
        abstract string name();
        MeshDrawerT drawer() { return this.outer; }
        Mesh mesh() { return this.outer.mesh_; }
    }
    class StockDrawMode(DrawFunctor) : DrawMode {
        DrawFunctor drawer_;
        this() { drawer_ = new DrawFunctor; }
        this(DrawFunctor d) { drawer_ = d; }
        void opCall() { drawer_.draw(mesh()); }
        string name() { return drawer_.name; }
    }
    class StripsNVertexArraysMode : DrawMode {
        string name() { return "Strips'n VertexArrays"; }
        void opCall() {
            glEnable(GL_LIGHTING);
            glShadeModel(GL_SMOOTH);

            glEnableClientState(GL_VERTEX_ARRAY);
            glVertexPointer(3, GL_FLOAT, 0, mesh.points().ptr);

            glEnableClientState(GL_NORMAL_ARRAY);
            glNormalPointer(GL_FLOAT, 0, mesh.vertex_normals().ptr);


            if (mesh.has_vertex_colors() && use_color_)
            {
                glEnable(GL_COLOR_MATERIAL);
                glEnableClientState(GL_COLOR_ARRAY);
                glColorPointer(3, GL_UNSIGNED_BYTE, 0, mesh.vertex_colors().ptr);
            }

            if ( tex_id_ && mesh.has_vertex_texcoords2D() )
            {
                glEnableClientState(GL_TEXTURE_COORD_ARRAY);
                glTexCoordPointer(2, GL_FLOAT, 0, mesh.texcoords2D().ptr);
                glEnable(GL_TEXTURE_2D);
                glBindTexture(GL_TEXTURE_2D, tex_id_);
                glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, tex_mode_);
            }

            MyStripifier.StripsIterator strip_it = strips_.begin();
            MyStripifier.StripsIterator strip_last = strips_.end();

            // Draw all strips
            for (; strip_it!=strip_last; ++strip_it)
            {
                glDrawElements(GL_TRIANGLE_STRIP, 
                               strip_it.ptr.length, GL_UNSIGNED_INT, &(*strip_it.ptr)[0] );
            }

            glDisableClientState(GL_VERTEX_ARRAY);
            glDisableClientState(GL_NORMAL_ARRAY);
            glDisableClientState(GL_TEXTURE_COORD_ARRAY);
            glDisableClientState(GL_COLOR_ARRAY);
            glDisable(GL_COLOR_MATERIAL);

        }
    }
    class ShowStripsMode : DrawMode {
        string name() { return "Show Strips"; }
        void opCall() {
            glDisable(GL_LIGHTING);
            MyStripifier.StripsIterator strip_it = strips_.begin();
            MyStripifier.StripsIterator strip_last = strips_.end();

            float cmax  = 256.0f;
            int   range = 220;
            int   base  = cast(int)cmax-range;
            int   drcol  = 13;
            int   dgcol  = 31;
            int   dbcol  = 17;
    
            int rcol=0, gcol=dgcol, bcol=dbcol+dbcol;
         
            // Draw all strips
            for (; strip_it!=strip_last; ++strip_it)
            {
                MyStripifier.IndexIterator idx_it   = array_iter_begin(*strip_it.ptr);
                MyStripifier.IndexIterator idx_last = array_iter_end(*strip_it.ptr);
      
                rcol = (rcol+drcol) % range;
                gcol = (gcol+dgcol) % range;
                bcol = (bcol+dbcol) % range;
      
                glBegin(GL_TRIANGLE_STRIP);
                glColor3f((rcol+base)/cmax, (gcol+base)/cmax, (bcol+base)/cmax);
                for ( ;idx_it != idx_last; ++idx_it )
                    glVertex3fv( mesh_.point_ptr(Mesh.VertexHandle(idx_it.val)).ptr );
                glEnd();
            }
            glColor3f(1.0, 1.0, 1.0);
        }
    }
    class DrawPropertyMode : DrawMode {
        BasePropRenderer renderer_;
        string property_name;

        TypeInfo typeinfo() { 
            update_renderer_(); 
            return renderer_ ? renderer_.typeinfo : null; 
        }
        abstract BaseProperty lookup_prop_by_name(string _name);
        protected void update_renderer_() {
            if (property_name.length == 0) { renderer_ = null; return; }
            BaseProperty prop = lookup_prop_by_name(property_name);
            if (!prop) {renderer_ = null; return; } 
            TypeInfo ptype = prop.element_type();
            if (!renderer_ || ptype!=renderer_.typeinfo) {
                renderer_ = make_renderer_(ptype);
            }
        }

        protected BasePropRenderer make_renderer_(TypeInfo ti) {
            BasePropRenderer pr;
            version (OPTLINKIsMyFriend) {
                if (false) {}
                else if (ti==typeid(byte  )) { pr = new PropRenderer!(byte  ); }
                else if (ti==typeid(ubyte )) { pr = new PropRenderer!(ubyte ); }
                else if (ti==typeid(short )) { pr = new PropRenderer!(short ); }
                else if (ti==typeid(ushort)) { pr = new PropRenderer!(ushort); }
                else if (ti==typeid(int   )) { pr = new PropRenderer!(int   ); }
                else if (ti==typeid(uint  )) { pr = new PropRenderer!(uint  ); }
                else if (ti==typeid(float )) { pr = new PropRenderer!(float ); }
                else if (ti==typeid(double)) { pr = new PropRenderer!(double); }

                else if (ti==typeid(VectorT!(byte,   2))) { pr = new PropRenderer!(VectorT!(byte,   2)); }
                else if (ti==typeid(VectorT!(ubyte,  2))) { pr = new PropRenderer!(VectorT!(ubyte,  2)); }
                else if (ti==typeid(VectorT!(short,  2))) { pr = new PropRenderer!(VectorT!(short,  2)); }
                else if (ti==typeid(VectorT!(ushort, 2))) { pr = new PropRenderer!(VectorT!(ushort, 2)); }
                else if (ti==typeid(VectorT!(int,    2))) { pr = new PropRenderer!(VectorT!(int,    2)); }
                else if (ti==typeid(VectorT!(uint,   2))) { pr = new PropRenderer!(VectorT!(uint,   2)); }
                else if (ti==typeid(VectorT!(float,  2))) { pr = new PropRenderer!(VectorT!(float,  2)); }
                else if (ti==typeid(VectorT!(double, 2))) { pr = new PropRenderer!(VectorT!(double, 2)); }

                else if (ti==typeid(VectorT!(byte,   3))) { pr = new PropRenderer!(VectorT!(byte,   3)); }
                else if (ti==typeid(VectorT!(ubyte,  3))) { pr = new PropRenderer!(VectorT!(ubyte,  3)); }
                else if (ti==typeid(VectorT!(short,  3))) { pr = new PropRenderer!(VectorT!(short,  3)); }
                else if (ti==typeid(VectorT!(ushort, 3))) { pr = new PropRenderer!(VectorT!(ushort, 3)); }
                else if (ti==typeid(VectorT!(int,    3))) { pr = new PropRenderer!(VectorT!(int,    3)); }
                else if (ti==typeid(VectorT!(uint,   3))) { pr = new PropRenderer!(VectorT!(uint,   3)); }
                else if (ti==typeid(VectorT!(float,  3))) { pr = new PropRenderer!(VectorT!(float,  3)); }
                else if (ti==typeid(VectorT!(double, 3))) { pr = new PropRenderer!(VectorT!(double, 3)); }

                else if (ti==typeid(VectorT!(byte,   4))) { pr = new PropRenderer!(VectorT!(byte,   4)); }
                else if (ti==typeid(VectorT!(double, 4))) { pr = new PropRenderer!(VectorT!(double, 4)); }
                else if (ti==typeid(VectorT!(float,  4))) { pr = new PropRenderer!(VectorT!(float,  4)); }
                else if (ti==typeid(VectorT!(int,    4))) { pr = new PropRenderer!(VectorT!(int,    4)); }
                else if (ti==typeid(VectorT!(short,  4))) { pr = new PropRenderer!(VectorT!(short,  4)); }
                else if (ti==typeid(VectorT!(ubyte,  4))) { pr = new PropRenderer!(VectorT!(ubyte,  4)); }
                else if (ti==typeid(VectorT!(uint,   4))) { pr = new PropRenderer!(VectorT!(uint,   4)); }
                else if (ti==typeid(VectorT!(ushort, 4))) { pr = new PropRenderer!(VectorT!(ushort, 4)); }
                else {pr = null;}

            } else {
                // pick and choose most likely suspects
                if (false) {}
                else if (ti==typeid(byte  )) { pr = new PropRenderer!(byte  ); }
                else if (ti==typeid(ubyte )) { pr = new PropRenderer!(ubyte ); }
                else if (ti==typeid(float )) { pr = new PropRenderer!(float ); }
                else if (ti==typeid(double)) { pr = new PropRenderer!(double); }

                else if (ti==typeid(VectorT!(byte,   2))) { pr = new PropRenderer!(VectorT!(byte,   2)); }
                else if (ti==typeid(VectorT!(ubyte,  2))) { pr = new PropRenderer!(VectorT!(ubyte,  2)); }
                else if (ti==typeid(VectorT!(float,  2))) { pr = new PropRenderer!(VectorT!(float,  2)); }
                else if (ti==typeid(VectorT!(double, 2))) { pr = new PropRenderer!(VectorT!(double, 2)); }

                else if (ti==typeid(VectorT!(byte,   3))) { pr = new PropRenderer!(VectorT!(byte,   3)); }
                else if (ti==typeid(VectorT!(ubyte,  3))) { pr = new PropRenderer!(VectorT!(ubyte,  3)); }
                else if (ti==typeid(VectorT!(float,  3))) { pr = new PropRenderer!(VectorT!(float,  3)); }
                else if (ti==typeid(VectorT!(double, 3))) { pr = new PropRenderer!(VectorT!(double, 3)); }

                else if (ti==typeid(VectorT!(byte,   4))) { pr = new PropRenderer!(VectorT!(byte,   4)); }
                else if (ti==typeid(VectorT!(ubyte,  4))) { pr = new PropRenderer!(VectorT!(ubyte,  4)); }
                else if (ti==typeid(VectorT!(double, 4))) { pr = new PropRenderer!(VectorT!(double, 4)); }
                else if (ti==typeid(VectorT!(float,  4))) { pr = new PropRenderer!(VectorT!(float,  4)); }
                else {pr = null;}
            }
            return pr;
        }
    }
    class VertexPropertyMode : DrawPropertyMode {
        string name() { return "Vertex Property"; }
        override BaseProperty lookup_prop_by_name(string _pname) { 
            return mesh.find_vprop(_pname); 
        }
        void opCall() {
            update_renderer_();
            if (renderer_) {
                renderer_.draw_vprop(property_name);
            }
        }
        protected Mesh.vprop_iterator cur_prop_iter_() {
            if (!property_name.length) { return mesh.vprops_end(); }
            auto it = mesh.vprops_begin(), end = mesh.vprops_end();
            for (; it!=end; ++it) {
                if (it.val && property_name == it.val.name)
                    break;
            }
            return it;
        }
        void next_property() {
            auto it = cur_prop_iter_();
            if (it==mesh.vprops_end) { 
                it==mesh.vprops_begin; 
                if (it.val) { property_name = it.val.name; return; }
            }
            auto start = it;
            do {
                ++it;
                if (it==mesh.vprops_end())  {
                    it = mesh.vprops_begin();
                }
                if (it==start) { property_name = null; return; }
            } while (!it.val)
            property_name = it.val.name;
        }
        void prev_property() {
            auto it = cur_prop_iter_();
            auto start = it;
            do {
                if (it==mesh.vprops_begin()) {
                    it = mesh.vprops_end();
                }
                --it;
                if (it==start) { property_name = null; return; }
            } while (!it.val);
            property_name = it.val.name;
        }
    }
    class FacePropertyMode : DrawPropertyMode {
        string name() { return "Face Property"; }
        override BaseProperty lookup_prop_by_name(string _pname) { 
            return mesh.find_fprop(_pname);
        }
        void opCall() {
            update_renderer_();
            if (renderer_) {
                renderer_.draw_fprop(property_name);
            }
        }
        protected Mesh.fprop_iterator cur_prop_iter_() {
            if (!property_name.length) { return mesh.fprops_end(); }
            auto it = mesh.fprops_begin(), end = mesh.fprops_end();
            for (; it!=end; ++it) {
                if (it.val && property_name == it.val.name)
                    break;
            }
            return it;
        }
        void next_property() {
            auto it = cur_prop_iter_();
            if (it==mesh.fprops_end) { 
                it==mesh.fprops_begin; 
                if (it.val) { property_name = it.val.name; return; }
            }
            auto start = it;
            do {
                ++it;
                if (it==mesh.fprops_end())  {
                    it = mesh.fprops_begin();
                }
                if (it==start) { property_name = null; return; }
            } while (!it.val)
            property_name = it.val.name;
        }
        void prev_property() {
            auto it = cur_prop_iter_();
            auto start = it;
            do {
                if (it==mesh.fprops_begin()) {
                    it = mesh.fprops_end();
                }
                --it;
                if (it==start) { property_name = null; return; }
            } while (!it.val);
            property_name = it.val.name;
        }
    }
    class BasePropRenderer {
        MeshDrawerT drawer() { return this.outer; }
        Mesh mesh() { return this.outer.mesh_; }
        abstract TypeInfo typeinfo();
        abstract void draw_fprop(string propname);
        abstract void draw_vprop(string propname);
        //float scale_ = 1.0f;??  use glColorMatrix externally instead?
    }
    class PropRenderer(T) : BasePropRenderer 
    {
        override TypeInfo typeinfo() { return typeid(T); }
        override void draw_vprop(string propname) {
            VPropHandleT!(T) proph;
            mesh.get_property_handle(proph,propname);

            glDisable(GL_LIGHTING);
            glShadeModel(GL_SMOOTH);

            glEnableClientState(GL_VERTEX_ARRAY);
            glVertexPointer(3, GL_FLOAT, 0, mesh.points().ptr);

            glEnable(GL_COLOR_MATERIAL);

            glBegin(GL_TRIANGLES);
            Mesh.FaceIter fIt = mesh.faces_begin, fEnd= mesh.faces_end;
            Mesh.ConstFaceVertexIter fvIt;
            for (; fIt!=fEnd; ++fIt)
            {
                fvIt = mesh.cfv_iter(fIt.handle); 

                glColorT( *mesh.property_ptr(proph, fvIt.handle) );
                glArrayElement(fvIt.handle.idx);
                ++fvIt;

                glColorT( *mesh.property_ptr(proph, fvIt.handle) );
                glArrayElement(fvIt.handle.idx);
                ++fvIt;

                glColorT( *mesh.property_ptr(proph, fvIt.handle) );
                glArrayElement(fvIt.handle.idx);
            }
            glEnd();
    
            glDisableClientState(GL_VERTEX_ARRAY);
            glDisable(GL_COLOR_MATERIAL);
        }
        override void draw_fprop(string propname) {
            FPropHandleT!(T) proph;
            mesh.get_property_handle(proph,propname);

            glDisable(GL_LIGHTING);
            glShadeModel(GL_FLAT);

            glEnableClientState(GL_VERTEX_ARRAY);
            glVertexPointer(3, GL_FLOAT, 0, mesh.points().ptr);

            Mesh.FaceIter fIt = mesh.faces_begin, fEnd= mesh.faces_end;
            Mesh.ConstFaceVertexIter fvIt;
            glBegin(GL_TRIANGLES);
            for (; fIt!=fEnd; ++fIt)
            {
                T* propv = mesh.property_ptr(proph,fIt.handle);
                glColorT( *propv );

                fvIt = mesh.cfv_iter(fIt.handle()); 
                glArrayElement(fvIt.handle().idx());
                ++fvIt;
                glArrayElement(fvIt.handle().idx());
                ++fvIt;
                glArrayElement(fvIt.handle().idx());
            }
            glEnd();
    
            glDisableClientState(GL_VERTEX_ARRAY);
        }
    }

    /// set the mesh to use
    bool set_mesh(Mesh mesh) 
    {
        // calculate normals
        // set scene center and radius   
  
        mesh_ = mesh;
        {
            if (strips_) strips_.clear();

            reset_draw_modes();

            bool fnorm_reliable=true,vnorm_reliable=true;
            if (!mesh.has_face_normals) {
                mesh.request_face_normals();
                mesh.update_face_normals();
                fnorm_reliable = false;
            }
            if (!mesh.has_vertex_normals) {
                mesh.request_vertex_normals();
                mesh.update_vertex_normals();
                vnorm_reliable = false;
            }
            correct_sign_of_normals(fnorm_reliable,vnorm_reliable);

            // check for possible color information
            if ( mesh.has_vertex_colors )
            {
                dout.writefln("Mesh provides vertex colors");
                add_draw_mode("Colored Vertices");
            }

            if ( mesh.has_face_colors )
            {
                dout.writefln("Mesh provides face colors");
                add_draw_mode("Solid Colored Faces");
                add_draw_mode("Smooth Colored Faces");
            }

            if ( mesh.has_vertex_texcoords2D )
                dout.writefln( "File provides texture coordinates");

            // Check for extra properties
            {
                string got_one;
                auto vpit = mesh_.vprops_begin, vpend = mesh_.vprops_end;
                for(; vpit!=vpend; ++vpit) {
                    if (!vpit.val) { continue; }
                    string pname = vpit.val.name;
                    if (pname.length >= 2 && pname[0..2]=="v:") 
                        continue; // reserved prop name
                    if(got_one.length==0) got_one = pname.dup;
                    TypeInfo ptype = vpit.val.element_type;
                    dout.writefln("Mesh provides per-vertex property '%s' of type %s",
                                  pname, ptype);
                }
                if (got_one.length) { 
                    add_draw_mode("Vertex Property"); 
                    auto m = vertex_property_drawer();
                    if (m) { m.property_name = got_one; }
                }
            }
            {
                string got_one;
                auto vpit = mesh_.fprops_begin, vpend = mesh_.fprops_end;
                for(; vpit!=vpend; ++vpit) {
                    if (!vpit.val) { continue; }
                    string pname = vpit.val.name;
                    if (pname.length >= 2 && pname[0..2]=="f:") 
                        continue; // reserved prop name
                    if(got_one.length==0) got_one = pname.dup;
                    TypeInfo ptype = vpit.val.element_type;
                    dout.writefln("Mesh provides per-face property '%s' of type %s",
                                  pname, ptype);
                }
                if (got_one.length) { 
                    add_draw_mode("Face Property");
                    auto m = face_property_drawer();
                    if (m) { m.property_name = got_one; }
                }
            }

            // info
            dlog.writefln( mesh_.n_vertices() , " vertices, ",
                           mesh_.n_edges()    , " edges, ",
                           mesh_.n_faces()    , " faces").flush;
    
            // bounding box
            Mesh./*Const*/VertexIter vIt=(mesh_.vertices_begin());
            Mesh./*Const*/VertexIter vEnd=(mesh_.vertices_end());      
    
            Vec3f bbMin, bbMax;
    
            bbMin = bbMax = vector_cast!(Vec3f)(mesh_.point(vIt.handle));
    
            for (size_t count=0; vIt!=vEnd; ++vIt, ++count)
            {
                bbMin.minimize( vector_cast!(Vec3f)(mesh_.point(vIt.handle)));
                bbMax.maximize( vector_cast!(Vec3f)(mesh_.point(vIt.handle)));
            }
    
    
            // set center and radius
            set_scene_pos( (bbMin+bbMax)*0.5, (bbMin-bbMax).norm()*0.5 );
    
            // for normal display
            normal_scale_ = (bbMax-bbMin).min()*0.05f;
    
            // base point for displaying face normals
            // also check for non-tris
            uint num_quads = 0;
            uint num_polys = 0;
            {
                scope t = new TimerUtil.Timer;
                t.start();
                mesh_.add_property( fp_normal_base_ );
                Mesh.FaceIter f_it = mesh_.faces_begin();
                Mesh.FaceVertexIter fv_it;
                for (;f_it != mesh_.faces_end(); ++f_it)
                {
                    auto v = Mesh.Point(0,0,0);
                    int nv=0;
                    for( fv_it=mesh_.fv_iter(f_it.handle); fv_it.is_active; ++fv_it,++nv) {
                        v += vector_cast!( Mesh.Normal )(mesh_.point(fv_it.handle));
                    }
                    if (nv==3) {}
                    else if (nv==4) { ++num_quads; }
                    else            { ++num_polys; }
                    v *= 1.0f/cast(float)nv;
                    *mesh_.property_ptr( fp_normal_base_, f_it.handle ) = v;
                }
                t.stop();
                dlog.writefln( "Computed base point for displaying face normals [" 
                               , t.as_string() , " sec]" ).flush;
            }

            if (num_quads) {
                dlog.writefln( "Model has %s quad face(s)", num_quads).flush;
                add_draw_mode("Solid Smooth w/Quads");
                add_draw_mode("Solid Flat w/Quads");
                add_draw_mode("Solid Flat + Wireframe w/Quads");
                set_draw_mode("Solid Smooth w/Quads");
            }

            if (num_polys) {
                dlog.writefln( "Model has %s general polygon face(s)", num_polys).flush;
                
                // disable all draw modes except "Wireframe Polygons"
                set_draw_mode("Wireframe Polygons");
            }

            // loading done
            return true;
        }
        return false;

    }
  

    /// load texture
    bool open_texture( /*const*/ string _filename ) 
    {
        return false;
    }



    Mesh mesh() { return mesh_; }
  

    void enable_strips() 
    {
        if (!f_strips_)
        {
            f_strips_ = true;  
            if (!strips_) {
                strips_= new MyStripifier(mesh_);
                dlog.writefln( "Computing strips..").flush;
                scope t = new TimerUtil.Timer;
                t.start();
                compute_strips();
                t.stop();
                dlog.writefln( "done [" , strips_.n_strips(), 
                               " strips created in " , t.as_string() , "]").flush;
            }
            add_draw_mode("Strips'n VertexArrays");
            add_draw_mode("Show Strips");
        }
        set_draw_mode("Strips'n VertexArrays");
    }

    void disable_strips() {
        if (f_strips_)
        {
            f_strips_ = false; 
            del_draw_mode("Show Strips");
            del_draw_mode("Strip'n VertexArrays");
        }
    }
  

    void flip_normals() 
    {
        with(mesh_) {
            foreach(vit; vertices_begin) {
                set_normal(vit, -normal(vit));
            }
            foreach(fit; faces_begin) {
                set_normal(fit, -normal(fit));
            }
        }
    }

    size_t n_draw_modes() { return draw_mode_names_.length; }

    void clear_draw_modes() {
        draw_mode_names_.length = 0;
        draw_mode_ = NONE;
    }

    void reset_draw_modes() {
        clear_draw_modes();
        add_draw_mode("Solid Smooth");
        add_draw_mode("Solid Flat");
        add_draw_mode("Solid Flat + Wireframe");
        add_draw_mode("Hidden-Line");
        add_draw_mode("Wireframe");
        add_draw_mode("Wireframe Polygons");
        add_draw_mode("Points");

        set_draw_mode("Solid Smooth");
        //set_draw_mode("Solid Flat");
    }

    bool add_draw_mode(string mode ) {
        auto i = find_index(draw_mode_names_, mode);
        if (i == NOT_FOUND) {
            // look for name in actual drawers list
            if (!(mode in known_draw_modes_)) {
                throw new Exception("add_draw_mode: No such mode '"~mode~"'");
            }
            draw_mode_names_ ~= mode.dup;
            return true;
        }
    }

    void next_draw_mode() {
        if (draw_mode_==NONE) { 
            if (n_draw_modes) draw_mode_=0;
        }
        else {
            draw_mode_ = (draw_mode_+1) % n_draw_modes;
        }
    }

    void prev_draw_mode() {
        if (draw_mode_==NONE || draw_mode_ == 0) { 
            draw_mode_ = n_draw_modes-1;
        }
        else {
            --draw_mode_;
        }
    }

    void set_draw_mode(string mode) {
        auto i = find_index(draw_mode_names_, mode);
        if (i != NOT_FOUND) {
            draw_mode_ = i;
        }
        else {
            throw new runtime_error(std.string.format("no such draw mode: ", mode));
        }
    }

    string get_draw_mode() {
        if (draw_mode_ == NONE) {
            return "NONE";
        }
        else {
            return draw_mode_names_[draw_mode_];
        }
    }

    void del_draw_mode(string mode ) {
        auto i = find_index(draw_mode_names_, mode);
        if (i) { erase_index(draw_mode_names_, i); }
        else {
            throw new runtime_error(std.string.format("no such draw mode: ", mode));
        }
    }

    FacePropertyMode face_property_drawer() {
        return cast(FacePropertyMode)known_draw_modes_["Face Property"];
    }

    VertexPropertyMode vertex_property_drawer() {
        return cast(VertexPropertyMode)known_draw_modes_["Vertex Property"];
    }

    void next_face_property() {
        face_property_drawer.next_property();
    }
    void prev_face_property() {
        face_property_drawer.prev_property();
    }
    void next_vertex_property() {
        vertex_property_drawer.next_property();
    }
    void prev_vertex_property() {
        vertex_property_drawer.prev_property();
    }

    /*const*/ string current_draw_mode() /*const*/
    { return draw_mode_ ? draw_mode_names_[draw_mode_-1] : nomode_; }



    /* Sets the center and size of the whole scene. 
       The _center is used as fixpoint for rotations and for adjusting
       the camera/viewer (see view_all()). */
    void set_scene_pos( /*const*/ref Vec3f _center, float _radius )
    {
        dout.writefln("scene pos = %s   radius = %s", _center, _radius);
        center_ = _center;
        radius_ = _radius;
        glFogf( GL_FOG_START,      1.5*_radius );
        glFogf( GL_FOG_END,        3.0*_radius );

        //update_projection_matrix();
        view_all();
    }

    Vec3f get_center() {
        return center_;
    }

    /* view the whole scene: the eye point is moved far enough from the
       center so that the whole scene is visible. */
    void view_all() {
        translate( Vec3f( -(modelview_matrix_[0]*center_[0] + 
                            modelview_matrix_[4]*center_[1] +
                            modelview_matrix_[8]*center_[2] + 
                            modelview_matrix_[12]),
                          -(modelview_matrix_[1]*center_[0] + 
                            modelview_matrix_[5]*center_[1] +
                            modelview_matrix_[9]*center_[2] + 
                            modelview_matrix_[13]),
                          -(modelview_matrix_[2]*center_[0] + 
                            modelview_matrix_[6]*center_[1] +
                            modelview_matrix_[10]*center_[2] + 
                            modelview_matrix_[14] +
                            3.0*radius_) ) );
    }


    float radius() /*const*/ { return radius_; }
    /*const*/ Vec3f center() /*const*/ { return center_; }
    /*const*/ int width() /*const*/ { return width_; }
    /*const*/ int height() /*const*/ { return height_; }

    /*const*/ GLdouble* modelview_matrix() /*const*/  { return modelview_matrix_.ptr;  }
    /*const*/ GLdouble* projection_matrix() /*const*/ { return projection_matrix_.ptr; }

    float fovy() /*const*/ { return 45.0f; }

    void show_vnormals(bool vnorm) { show_vnormals_ = vnorm; }
    bool show_vnormals() { return show_vnormals_; }
    void show_fnormals(bool fnorm) { show_fnormals_ = fnorm; }
    bool show_fnormals() { return show_fnormals_; }
    void use_color(bool use_col) { use_color_ = use_color; }
    bool use_color() { return use_color_; }

    /// Set scaling for display of normal vectors
    void normal_scale(float nscale) { normal_scale_ = nscale; }
    /// Return current scaling for display of normal vectors
    float normal_scale() { return normal_scale_; }

    /// Toggle two-sided lighting on and off.  
    /// Must be called when the GL context is active.
    void two_sided_lighting(bool onOff) {
        int ion = onOff;
        glLightModeliv(GL_LIGHT_MODEL_TWO_SIDE, &ion);
    }

    /// Get current two-sided lighting state.
    /// Must be called when the GL context is active.
    bool two_sided_lighting() {
        GLboolean ion;
        glGetBooleanv(GL_LIGHT_MODEL_TWO_SIDE, &ion);
        return ion!=0;
    }

    void multviewGL() {
        glMatrixMode( GL_MODELVIEW );
        glMultMatrixd( modelview_matrix_.ptr );
    }

    void
    drawGL()
    {
        string dmode;
        if (draw_mode_ == NONE) {
            dmode = "Solid Smooth";
        }
        else {
            dmode = draw_mode_names_[draw_mode_];
        }

        draw_scene(draw_mode_names_[draw_mode_]);
    }

    void setup_projection_matrix() { update_projection_matrix(); }
    void setup_modelview_matrix() { 
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
    }

    void
    resizeGL( int _w, int _h )
    {
        width_ = _w;
        height_ = _h;
        //update_projection_matrix();
        //glViewport(0, 0, _w, _h);
        updateGL();
    }

    void updateGL() {
        // callback?
    }
    void makeCurrent() {
        // callback?
    }

    // draw the scene: will be called by the drawGL() method.
    void draw_scene(/*const*/string _draw_mode)
    {
        if ( ! mesh_.n_vertices() )
            return;
   
        if (auto mptr = _draw_mode in known_draw_modes_) {
            (*mptr)();
            setDefaultMaterial();
        }

        if (show_vnormals_)
        {
            Mesh.VertexIter vit;
            glDisable(GL_LIGHTING);
            glBegin(GL_LINES);
            glColor3f(1.000f, 0.803f, 0.027f); // orange
            for(vit=mesh_.vertices_begin(); vit!=mesh_.vertices_end(); ++vit)
            {
                glVertex( mesh_, vit.handle );
                glVertex( mesh_, mesh_.point( vit.handle ) + normal_scale_*mesh_.normal( vit.handle ) );
            }
            glEnd();
        }

        if (show_fnormals_)
        {
            Mesh.FaceIter fit;
            glDisable(GL_LIGHTING);
            glBegin(GL_LINES);
            glColor3f(0.705f, 0.976f, 0.270f); // greenish
            for(fit=mesh_.faces_begin(); fit!=mesh_.faces_end(); ++fit)
            {
                glVertex( mesh_, *mesh_.property_ptr(fp_normal_base_, fit.handle) );
                glVertex( mesh_, mesh_.property(fp_normal_base_, fit.handle) + 
                          normal_scale_*mesh_.normal( fit.handle ) );
            }
            glEnd();
        }
    }

    double performance() { return 1.0; }
  
    void setDefaultMaterial() {
        const GLfloat[] mat_a = [0.2, 0.2, 0.2, 1.0];
        const GLfloat[] mat_d = [0.85, 0.85, 0.7, 1.0];
        const GLfloat[] mat_s = [0.6, 0.6, 0.4, 1.0];
        const GLfloat[] shine = [120.0];
  
        glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT,   mat_a.ptr);
        glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE,   mat_d.ptr);
        glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR,  mat_s.ptr);
        glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, shine.ptr);

    }
    void setDefaultLight()
    {
        static GLfloat[4] pos1 = [0.1,  0.1,  0.08, 0.0]; // main light
        static GLfloat[4] col1 = [ 0.7,  0.7,  0.5,  1.0]; // reddish

        static GLfloat[4] pos2 = [-0.1, -0.1, 0.05, 0.0]; // secondary
        static GLfloat[4] col2 = [ 0.4,  0.5,  0.55,  1.0]; // bluish

        static GLfloat[4] pos3 = [ 0.0,  0.03,  0.1,  0.0]; // headlight
        static GLfloat[4] col3 = [ 0.1,  0.1,  0.1,  1.0]; // dim white
 
        glEnable(GL_LIGHT0);    
        glLightfv(GL_LIGHT0,GL_POSITION, pos1.ptr);
        glLightfv(GL_LIGHT0,GL_DIFFUSE,  col1.ptr);
        glLightfv(GL_LIGHT0,GL_SPECULAR, col1.ptr);
  
        glEnable(GL_LIGHT1);  
        glLightfv(GL_LIGHT1,GL_POSITION, pos2.ptr);
        glLightfv(GL_LIGHT1,GL_DIFFUSE,  col2.ptr);
        //glLightfv(GL_LIGHT1,GL_SPECULAR, col2.ptr);

        glEnable(GL_LIGHT2);  
        glLightfv(GL_LIGHT2,GL_POSITION, pos3.ptr);
        glLightfv(GL_LIGHT2,GL_DIFFUSE,  col3.ptr);
        //glLightfv(GL_LIGHT2,GL_SPECULAR, [0.f,0,0,0][].ptr);
        glLightfv(GL_LIGHT0,GL_AMBIENT,  col3.ptr);
    }

    void
    initializeGL()
    {  
        // OpenGL state
        glClearColor(0.0, 0.0, 0.0, 0.0);
        glDisable( GL_DITHER );
        glEnable( GL_DEPTH_TEST );

        // Material
        setDefaultMaterial();
  
        // Fog
        GLfloat[4] fogColor = [ 0.3f, 0.3, 0.4, 1.0 ];
        glFogi(GL_FOG_MODE,    GL_LINEAR);
        glFogfv(GL_FOG_COLOR,  fogColor.ptr);
        glFogf(GL_FOG_DENSITY, 0.35);
        glHint(GL_FOG_HINT,    GL_DONT_CARE);
        glFogf(GL_FOG_START,    5.0f);
        glFogf(GL_FOG_END,     25.0f);

        // scene pos and size
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        glGetDoublev(GL_MODELVIEW_MATRIX, modelview_matrix_.ptr);
        if (!mesh) {
            set_scene_pos(Vec3f(0.0, 0.0, 0.0), 1.0);
        }
        else {
            //update_projection_matrix();
            view_all();
        }

        // Lighting
        //glLoadIdentity();
        setDefaultLight();  
  
        // Setup which material properties will track color,
        // but don't enable GL_COLOR_MATERIAL by default
        glColorMaterial( GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);

        // Two sided lighting by default because lots of real
        // models have inconsistent triangle ordering
        int is_ON = 1;
        glLightModeliv(GL_LIGHT_MODEL_TWO_SIDE, &is_ON);
    }



//----------------------------------------------------------------------------


    void
    translate( /*const*/ ref Vec3f _trans )
    {
        // Translate the object by _trans
        // Update modelview_matrix_
        makeCurrent();
        glLoadIdentity();
        glTranslated( _trans[0], _trans[1], _trans[2] );
        glMultMatrixd( modelview_matrix_.ptr );
        glGetDoublev( GL_MODELVIEW_MATRIX, modelview_matrix_.ptr);
    }


//----------------------------------------------------------------------------


    void
    rotate( /*const*/ ref Vec3f _axis, float _angle )
    {
        // Rotate around center center_, axis _axis, by angle _angle
        // Update modelview_matrix_

        Vec3f t = Vec3f( modelview_matrix_[0]*center_[0] + 
                         modelview_matrix_[4]*center_[1] +
                         modelview_matrix_[8]*center_[2] + 
                         modelview_matrix_[12],
                         modelview_matrix_[1]*center_[0] + 
                         modelview_matrix_[5]*center_[1] +
                         modelview_matrix_[9]*center_[2] + 
                         modelview_matrix_[13],
                         modelview_matrix_[2]*center_[0] + 
                         modelview_matrix_[6]*center_[1] +
                         modelview_matrix_[10]*center_[2] + 
                         modelview_matrix_[14] );
  
        makeCurrent();
        glLoadIdentity();
        glTranslatef(t[0], t[1], t[2]);
        glRotated( _angle, _axis[0], _axis[1], _axis[2]);
        glTranslatef(-t[0], -t[1], -t[2]); 
        glMultMatrixd(modelview_matrix_.ptr);
        glGetDoublev(GL_MODELVIEW_MATRIX, modelview_matrix_.ptr);
    }


protected:

    void update_projection_matrix()
    {
        makeCurrent();
        glMatrixMode( GL_PROJECTION );
        glLoadIdentity();
        gluPerspective(45.0, cast(GLfloat) width() / cast(GLfloat) height(),
                       0.01*radius_, 100.0*radius_);
        glGetDoublev( GL_PROJECTION_MATRIX, projection_matrix_.ptr);
        glMatrixMode( GL_MODELVIEW );
    }


    void compute_strips()
    {
        if (f_strips_)
        {
            strips_.clear();
            strips_.stripify();
        }
    }    

    void correct_sign_of_normals(bool fnorm_reliable, bool vnorm_reliable) 
    {
        if (!(fnorm_reliable ^ vnorm_reliable)) return;
        
        with(mesh_) {
            if (fnorm_reliable) {
                foreach(vit; vertices_begin) {
                    int count = 0;
                    Point vnorm = normal(vit);
                    foreach(fit; vf_iter(vit)) {
                        if ( dot(vnorm,*normal_ptr(fit)) <0 )
                            count--;
                        else 
                            count++;
                    }
                    if (count <0) { 
                        // flip vert normal to agree better with surrounding face normals
                        vnorm *= -1.0;
                        set_normal(vit, vnorm);
                    }
                }
            }
            else {
                foreach(fit; faces_begin) 
                {
                    int count = 0;
                    Point fnorm = normal(fit);
                    foreach(vit; fv_iter(fit)) {
                        if ( dot(fnorm,*normal_ptr(vit)) <0 )
                            count--;
                        else 
                            count++;
                    }
                    if (count <0) { 
                        // flip face normal to agree better with surrounding vertex normals
                        fnorm *= -1.0;
                        set_normal(fit, fnorm);
                    }
                }
            }
        }
    }

protected:

    int              width_;
    int              height_;
    Vec3f            center_;
    float            radius_;
	      
    GLdouble         projection_matrix_[16];
    GLdouble         modelview_matrix_[16];

    size_t           draw_mode_;
    DrawMode[string] known_draw_modes_;
    
    string[]          draw_mode_names_;
    static string     nomode_="";



    bool                   f_strips_=false; // enable/disable strip usage
    MyStripifier           strips_ = null;

    GLuint                 tex_id_=0;
    GLint                  tex_mode_;

    // virtual trackball: map 2D screen point to unit sphere
    //bool map_to_sphere(const QPoint& _point, auxd.OpenMesh.Vec3f& _result)
    //{
    //}

    Vec2i            last_point_2D_;
    Vec3f            last_point_3D_;
    bool             last_point_ok_;

    
    auxd.OpenMesh.Core.IO.Options.Options  opt_; // mesh file contained texcoords?
    Mesh                   mesh_;
    bool                   use_color_;
    bool                   show_vnormals_;
    bool                   show_fnormals_;
    float                  normal_scale_;

    FPropHandleT!( Mesh.Point ) fp_normal_base_;
    
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
