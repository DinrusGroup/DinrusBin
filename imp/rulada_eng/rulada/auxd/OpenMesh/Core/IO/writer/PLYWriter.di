/*==========================================================================
 * PLYReader.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * An OpenMesh PLY model format writer.
 *
 * For more about the PLY format see 
 *  http://www.cc.gatech.edu/projects/large_models/ply.html
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 15 Oct 2007
 * Copyright: (C) 2007-2008 William Baxter, OLM Digital, Inc.
 * License: ZLIB/LIBPNG
 */
//===========================================================================

module auxd.OpenMesh.Core.IO.writer.PLYWriter;

//=== INCLUDES ================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.SingletonT;
import auxd.OpenMesh.Core.IO.exporter.BaseExporter;
import auxd.OpenMesh.Core.IO.writer.BaseWriter;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.IO.IOManager;
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.IO.Options;
import auxd.OpenMesh.Core.Utils.Endian;
import auxd.OpenMesh.Core.Mesh.BaseKernel;
import binary = auxd.OpenMesh.Core.IO.BinaryHelper;
import auxd.OpenMesh.Core.Utils.Property;

import std.stream;
import std.string : toStringz;

import auxd.OpenMesh.Core.Utils.Std : starts_with;

version = PlyWriterVectorPropHack;

//=== IMPLEMENTATION ==========================================================
private{
    template _ident(T) { alias T _ident; }
/*
    template Vector2(T) { alias auxd.OpenMesh.Core.Geometry.VectorT.VectorT!(T,2) Vector2; }
    template Vector3(T) { alias auxd.OpenMesh.Core.Geometry.VectorT.VectorT!(T,3) Vector3; }
    template Vector4(T) { alias auxd.OpenMesh.Core.Geometry.VectorT.VectorT!(T,4) Vector4; }
    template Vector5(T) { alias auxd.OpenMesh.Core.Geometry.VectorT.VectorT!(T,5) Vector5; }
    template Vector6(T) { alias auxd.OpenMesh.Core.Geometry.VectorT.VectorT!(T,6) Vector6; }
    template Vector7(T) { alias auxd.OpenMesh.Core.Geometry.VectorT.VectorT!(T,7) Vector7; }
    template Vector8(T) { alias auxd.OpenMesh.Core.Geometry.VectorT.VectorT!(T,8) Vector8; }
*/
}



/** 
    This class defines the PLY writer. This class is further singleton'ed
    by SingletonT to PLYWriter.
*/
class _PLYWriter_ : public BaseWriter
{
  public:

    this() { IOManager().register_module(this); }

    string get_description() /*const*/  { return "PLY Format"; }
    string get_extensions()  /*const*/  { return "ply"; }

    void update_options(string _filename, ref Options _opt) {
        // everything supported!
    }

    bool write(/*const*/ string _filename, BaseExporter _be, Options _opt) /*const*/
    {
        // check exporter features
        if (!check(_be, _opt)) {
            derr.writefln("[PLYWriter] : exporter can't handle requested features").flush;
            return false;
        }

        // Ply can handle just about anything so none of our own checks here

        auto fout = new BufferedFile(_filename, FileMode.OutNew);
        scope(exit) { fout.close(); delete fout; }
        if (!fout.isOpen())
        {
            derr.writefln("[PLYWriter] : cannot open file ", _filename);
            return false;
        }

        _build_prop_writer_pipelines(_be,_opt);
        scope(exit) { 
            face_prop_writers_=null;
            vertex_prop_writers_=null;
        }
        return (_opt.check( Options.Binary ) 
                ? write_ply_binary(fout, _be, _opt)
                : write_ply_ascii(fout, _be, _opt) );
    }

    size_t binary_size(BaseExporter, Options) /*const*/ { return 0; }

  private:

    string _prop_type_stringT(T)() {
        static      if (is(T==float))   { return "float32"; }
        else static if (is(T==double))  { return "float64"; }
        else static if (is(T==int))     { return "int32"; }
        else static if (is(T==uint))    { return "uint32"; }
        else static if (is(T==byte))    { return "int8"; }
        else static if (is(T==ubyte))   { return "uint8"; }
        else static if (is(T==bool))    { return "bool"; }
        else static if (is(T==long))    { return "int64"; }
        else static if (is(T==ulong))   { return "uint64"; }
        /* TODO: real,cfloat,cdouble,creal */
        else {
            derr.writefln("Unknown prop type %s!", typeid(T));
            return "unknown";
        }
    }

    void write_header_prop_specT(T)(Stream fout, string prop_name) /*const*/
    {
        //dout.writefln("%s is a %s property!", prop_name, typeid(T));
        string tname = _prop_type_stringT!(T)();
        fout.writef("property %s %s\n", tname, prop_name);
    }

    /* D doesn't seem to have any way to specialize the VectorT part, but leave
     * the T and N free.  SO we have to list all the N's we want
     */
    void write_header_prop_specT(T : VectorT!(T,2))(Stream fout, string prop_name) /*const*/
    {
        string tname = _prop_type_stringT!(T)();
        fout.writef("property %s %s_0\n", tname, prop_name);
        fout.writef("property %s %s_1\n", tname, prop_name);
    }
    void write_header_prop_specT(T : VectorT!(T,3))(Stream fout, string prop_name) /*const*/
    {
        string tname = _prop_type_stringT!(T)();
        fout.writef("property %s %s_0\n", tname, prop_name);
        fout.writef("property %s %s_1\n", tname, prop_name);
        fout.writef("property %s %s_2\n", tname, prop_name);
    }
    void write_header_prop_specT(T : VectorT!(T,4))(Stream fout, string prop_name) /*const*/
    {
        string tname = _prop_type_stringT!(T)();
        fout.writef("property %s %s_0\n", tname, prop_name);
        fout.writef("property %s %s_1\n", tname, prop_name);
        fout.writef("property %s %s_2\n", tname, prop_name);
        fout.writef("property %s %s_3\n", tname, prop_name);
    }


    bool _try_element_subtype(alias C, alias funcT, ArgsT...)(TypeInfo it, ArgsT args)
    {
        static if (is(C!(float   ))) {
            if ( it == typeid(C!(float   )) ) { funcT!(C!(float ))(args);  return true;}
        }
        static if (is(C!(double  ))) {
            if ( it == typeid(C!(double  )) ) { funcT!(C!(double))(args); return true;  }
        }
        static if (is(C!(int     ))) {
            if ( it == typeid(C!(int     )) ) { funcT!(C!(int   ))(args); return true;  }
        }
        static if (is(C!(uint    ))) {
            if ( it == typeid(C!(uint    )) ) { funcT!(C!(uint  ))(args); return true;  }
        }
        static if (is(C!(byte    ))) {
            if ( it == typeid(C!(byte    )) ) { funcT!(C!(byte  ))(args); return true;  }
        }
        static if (is(C!(ubyte   ))) {
            if ( it == typeid(C!(ubyte   )) ) { funcT!(C!(ubyte ))(args); return true;  }
        }
        static if (is(C!(bool    ))) {
            if ( it == typeid(C!(bool    )) ) { funcT!(C!(bool  ))(args); return true;  }
        }
        static if (is(C!(long    ))) {
            if ( it == typeid(C!(long    )) ) { funcT!(C!(long  ))(args); return true;  }
        }
        static if (is(C!(ulong   ))) {
            if ( it == typeid(C!(ulong   )) ) { funcT!(C!(ulong ))(args); return true;  }
        }
        /* TODO: real cfloat,cdouble,creal */
        /* TODO get rid of hack when more general vector support works */
        version(PlyWriterVectorPropHack) {
            // Enable support for a very few common vector types 
            if (it == typeid(VectorT!(float,2))) { funcT!(VectorT!(float,2))(args);return true;}
            if (it == typeid(VectorT!(float,3))) { funcT!(VectorT!(float,3))(args);return true;}
            if (it == typeid(VectorT!(float,4))) { funcT!(VectorT!(float,4))(args);return true;}
            if (it == typeid(VectorT!(double,2))) { funcT!(VectorT!(double,2))(args);return true;}
            if (it == typeid(VectorT!(double,3))) { funcT!(VectorT!(double,3))(args);return true;}
            if (it == typeid(VectorT!(double,4))) { funcT!(VectorT!(double,4))(args);return true;}
            if (it == typeid(VectorT!(ubyte,3))) { funcT!(VectorT!(ubyte,3))(args);return true;}
            if (it == typeid(VectorT!(ubyte,4))) { funcT!(VectorT!(ubyte,4))(args);return true;}
        }
        return false;
    }

    bool dispatch_element_type(alias funcT, ArgsT...)(TypeInfo it, ArgsT args) 
    {
        // Try raw type first
        if (_try_element_subtype!(_ident,funcT,ArgsT)(it, args)) return true;

        // Then a bunch of possible different vector types
        // No -- not for now, this stuff causes too much woe with DMD 1.023
        // Lots of unresolved VectorT toString methods, and even some OPTLINK
        // crashes.
        /*
        if (_try_element_subtype!(Vector2,funcT,ArgsT)(it, args)) return true;
        if (_try_element_subtype!(Vector3,funcT,ArgsT)(it, args)) return true;
        if (_try_element_subtype!(Vector4,funcT,ArgsT)(it, args)) return true;
        if (_try_element_subtype!(Vector5,funcT,ArgsT)(it, args)) return true;
        if (_try_element_subtype!(Vector6,funcT,ArgsT)(it, args)) return true;
        if (_try_element_subtype!(Vector7,funcT,ArgsT)(it, args)) return true;
        if (_try_element_subtype!(Vector8,funcT,ArgsT)(it, args)) return true;
        */
        return false;
    }
    
    PropWriter[] face_prop_writers_;
    PropWriter[] vertex_prop_writers_;

    class PropWriter 
    {
        this (string pname) { prop_name_ = pname.dup; }
        // Write the "property ..." header string(s)
        abstract void write_header(Stream fout);
        abstract void write_elem_ascii(Stream fout, BaseKernel kernel, int idx);
        abstract void write_elem_binary(Stream fout, BaseKernel kernel, int idx, bool swap);
        string prop_name_;
    }

    class PropWriterT(T,PropHandleT,HandleType) : PropWriter
    { 
        this(string pname, PropHandleT phandle) {
            super(pname);
            prop_handle_ = phandle;
        }
        override void write_header(Stream fout) {
            write_header_prop_specT!(T)(fout, prop_name_);
        }
        override void write_elem_ascii(Stream fout, BaseKernel kernel, int idx) {
            HandleType hdl = HandleType(idx);
            T* v = kernel.property_ptr(prop_handle_, hdl);
            static if(is(typeof(T.init[0])) && is(typeof(T.init.length)) ) {
                // indexible type
                for (int i=0; i<v.length; i++) {
                    if (i!=0) fout.writef(" ");
                    fout.writef((*v)[i]);
                }
            }
            else {
                fout.writef(*v);
            }
        }
        override void write_elem_binary(Stream fout, BaseKernel kernel, int idx, bool swap) {
            HandleType hdl = HandleType(idx);
            T* v = kernel.property_ptr(prop_handle_, hdl);
            static if(is(typeof(T.init[0])) && is(typeof(T.init.length)) ) {
                // indexible type
                for (int i=0; i<v.length; i++) {
                    if (i!=0) fout.writef(" ");
                    binary.write_binary((*v)[i],fout,swap);
                }
            }
            else {
                binary.write_binary(*v,fout,swap);
            }
        }
        PropHandleT prop_handle_;
    }

    void _add_fprop_writerT(T)(PropWriter[]* writers, BaseKernel bk, string prop_name)
    {
        //dout.writefln("Adding fpropwriter for '%s', type '%s'", prop_name,typeid(T)).flush;
        FPropHandleT!(T) phandle;
        bk.get_property_handle(phandle, prop_name);
        (*writers) ~= new PropWriterT!(T,FPropHandleT!(T),FaceHandle)(prop_name,phandle);
    }

    void _add_vprop_writerT(T)(PropWriter[]* writers, BaseKernel bk, string prop_name)
    {
        //dout.writefln("Adding vpropwriter for '%s', type '%s'", prop_name,typeid(T)).flush;
        VPropHandleT!(T) phandle;
        bk.get_property_handle(phandle, prop_name);
        (*writers) ~= new PropWriterT!(T,VPropHandleT!(T),VertexHandle)(prop_name,phandle);
    }

    void _build_prop_writer_pipelines(BaseExporter _be, ref Options _opt) 
    {
        // Extra face properties
        {
            auto fpit = _be.kernel.fprops_begin, fpend = _be.kernel.fprops_end;
            for(; fpit!=fpend; ++fpit) {
                string pname = fpit.val.name;
                if (pname.length >= 2 && pname[0..2]=="f:") 
                    continue; // reserved prop name
                TypeInfo ptype = fpit.val.element_type;
                dispatch_element_type!(_add_fprop_writerT,PropWriter[]*,BaseKernel,string)(
                    ptype, &face_prop_writers_, _be.kernel, pname);
            }
        }
        // Extra vertex properties
        {
            auto vpit = _be.kernel.vprops_begin, vpend = _be.kernel.vprops_end;
            for(; vpit!=vpend; ++vpit) {
                string pname = vpit.val.name;
                if (pname.length >= 2 && pname[0..2]=="v:") 
                    continue; // reserved prop name
                TypeInfo ptype = vpit.val.element_type;
                dispatch_element_type!(_add_vprop_writerT,PropWriter[]*,BaseKernel,string)(
                    ptype, &vertex_prop_writers_, _be.kernel, pname);
            }
        }
    }
        

    void write_header(Stream fout, string _format, BaseExporter _be, ref Options _opt) {

        fout.writef(
            "ply\n"
            "format %s 1.0\n"
            "comment created by OpenMesh/D ply writer\n"
            "comment http://www.dsource.org/projects/openmeshd\n",
            _format);

        bool has_vnorm = _opt.check(Options.VertexNormal);
        bool has_vcolor = _opt.check(Options.VertexColor);
        bool has_vtex = _opt.check(Options.VertexTexCoord);

        bool has_fnorm = _opt.check(Options.FaceNormal);
        bool has_fcolor = _opt.check(Options.FaceColor);

        fout.writef("element vertex %s\n", _be.n_vertices);
        fout.writef("property float32 x\n"
                    "property float32 y\n"
                    "property float32 z\n"
                    );
        if (has_vnorm) {
            fout.writef("property float32 nx\n",
                        "property float32 ny\n",
                        "property float32 nz\n"
                        );
        }
        if (has_vcolor) {
            fout.writef("property uint8 r\n",
                        "property uint8 g\n",
                        "property uint8 b\n"
                        );
        }
        if (has_vtex) {
            fout.writef("property float32 s\n",
                        "property float32 t\n"
                        );
        }
        // Extra vertex properties
        {
            foreach(pw; vertex_prop_writers_) {
                pw.write_header(fout);
            }
        }
                
        fout.writef("element face %s\n", _be.n_faces);
        
        fout.writef(
            "property list uint8 int32 vertex_indices\n");
        if (has_fnorm) {
            fout.writef("property float32 nx\n",
                        "property float32 ny\n",
                        "property float32 nz\n"
                        );
        }
        if (has_fcolor) {
            fout.writef("property uint8 r\n",
                        "property uint8 g\n",
                        "property uint8 b\n"
                        );
        }
        // Extra face properties
        {
            foreach(pw; face_prop_writers_) {
                pw.write_header(fout);
            }
        }
                
        fout.writef("end_header\n");
    }

    bool write_ply_binary(Stream fout, BaseExporter _be, Options _opt) /*const*/
    {
        bool swap =
            ( (_opt.check(Options.MSB) && Endian.local()==Endian.LSB) ||
              (_opt.check(Options.LSB) && Endian.local()==Endian.MSB) );
        version(LittleEndian) {
            auto endian_str = swap ? "binary_big_endian" : "binary_little_endian";
        } else {
            auto endian_str = swap ? "binary_little_endian" : "binary_big_endian";
        }


        write_header(fout, endian_str, _be, _opt);

        bool has_vnorm = _opt.check(Options.VertexNormal);
        bool has_vcolor = _opt.check(Options.VertexColor);
        bool has_vtex = _opt.check(Options.VertexTexCoord);

        bool has_fnorm = _opt.check(Options.FaceNormal);
        bool has_fcolor = _opt.check(Options.FaceColor);

        for (int i=0, nV=_be.n_vertices(); i<nV; ++i)
        {
            VertexHandle vh = VertexHandle(i);
            Vec3f v  = _be.point(vh);
            binary.write_float(v.x, fout, swap);
            binary.write_float(v.y, fout, swap);
            binary.write_float(v.z, fout, swap);

            if (has_vnorm) {
                Vec3f n  = _be.normal(vh);
                binary.write_float(n.x, fout, swap);
                binary.write_float(n.y, fout, swap);
                binary.write_float(n.z, fout, swap);
            }
            if (has_vcolor) {
                Vec3ub c = _be.color(vh);
                fout.write(c[0]);
                fout.write(c[1]);
                fout.write(c[2]);
            }
            if (has_vtex) {
                Vec2f t  = _be.texcoord(vh);
                binary.write_float(t.x, fout, swap);
                binary.write_float(t.y, fout, swap);
            }
            // Extra vertex properties
            {
                foreach(pw; vertex_prop_writers_) {
                    pw.write_elem_binary(fout, _be.kernel, i, swap);
                }
            }
        }
        
        VertexHandle[] vhandles;
        for (int i=0, nF=_be.n_faces(); i<nF; ++i)
        {
            FaceHandle fh = FaceHandle(i);
            int nV = _be.get_vhandles(FaceHandle(i), vhandles);
            assert (nV<=255, "face has too many vertices!");
            ubyte ubnV = cast(ubyte)nV;
            fout.write(ubnV);
            foreach(vhs; vhandles) {
                binary.write_int(vhs.idx, fout, swap);
            }
            if (has_fnorm) {
                Vec3f n  = _be.normal(fh);
                binary.write_float(n.x, fout, swap);
                binary.write_float(n.y, fout, swap);
                binary.write_float(n.z, fout, swap);
            }
            if (has_fcolor) {
                Vec3ub c = _be.color(fh);
                fout.write(c[0]);
                fout.write(c[1]);
                fout.write(c[2]);
            }
            // Extra face properties
            {
                foreach(pw; face_prop_writers_) {
                    pw.write_elem_binary(fout, _be.kernel, i,swap);
                }
            }
        }

        return true;
    }

    bool write_ply_ascii(Stream fout, BaseExporter _be, Options _opt)
    {
        write_header(fout,"ascii", _be,_opt);

        bool has_vnorm = _opt.check(Options.VertexNormal);
        bool has_vcolor = _opt.check(Options.VertexColor);
        bool has_vtex = _opt.check(Options.VertexTexCoord);

        bool has_fnorm = _opt.check(Options.FaceNormal);
        bool has_fcolor = _opt.check(Options.FaceColor);

        for (int i=0, nV=_be.n_vertices(); i<nV; ++i)
        {
            VertexHandle vh = VertexHandle(i);
            Vec3f v  = _be.point(vh);
            fout.writef("%.10f %.10f %.10f", v.x, v.y, v.z);
            if (has_vnorm) {
                Vec3f n  = _be.normal(vh);
                fout.writef(" %.10f %.10f %.10f", n.x, n.y, n.z);
            }
            if (has_vcolor) {
                Vec3ub c = _be.color(vh);
                fout.writef(" %d %d %d", c[0],c[1],c[2]);
            }
            if (has_vtex) {
                Vec2f t  = _be.texcoord(vh);
                fout.writef(" %.10f %.10f %.10f", t.x, t.y);
            }
            // Extra vertex properties
            {
                foreach(pw; vertex_prop_writers_) {
                    fout.writef(" ");
                    pw.write_elem_ascii(fout, _be.kernel, i);
                }
            }

            fout.writef("\n");
        }
        
        VertexHandle[] vhandles;
        for (int i=0, nF=_be.n_faces(); i<nF; ++i)
        {
            FaceHandle fh = FaceHandle(i);
            int nV = _be.get_vhandles(FaceHandle(i), vhandles);
            fout.writef("%d", nV);
            foreach(vhs; vhandles) {
                fout.writef(" %d", vhs.idx);
            }
            if (has_fnorm) {
                Vec3f n  = _be.normal(fh);
                fout.writef(" %.10f %.10f %.10f", n.x, n.y, n.z);
            }
            if (has_fcolor) {
                Vec3ub c = _be.color(fh);
                fout.writef(" %d %d %d", c[0],c[1],c[2]);
            }
            // Extra face properties
            {
                foreach(pw; face_prop_writers_) {
                    fout.writef(" ");
                    pw.write_elem_ascii(fout, _be.kernel, i);
                }
            }
            fout.writef("\n");
        }

        return true;
    }
}


//== TYPE DEFINITION ==========================================================

static this()
{
    // creates and registers the default instance;
    PLYWriter();
}


/// Declare the single entity of the PLY writer
private _PLYWriter_  __PLYWriterInstance = null;
// register the PLYLoader singleton with MeshLoader
_PLYWriter_ PLYWriter() { 
    if (__PLYWriterInstance is null) { 
        __PLYWriterInstance = new _PLYWriter_();
    }
    return __PLYWriterInstance; 
}


unittest {
    
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
