/*==========================================================================
 * PLYReader.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * An OpenMesh reader for models in the PLY format.
 *
 * For more about the PLY format see 
 *  http://www.cc.gatech.edu/projects/large_models/ply.html
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Date: 15 Oct 2007
 * Copyright: (C) 2007-2008 William Baxter, OLM Digital, Inc.
 * License: ZLIB/LIBPNG
 */
//===========================================================================

module auxd.OpenMesh.Core.IO.reader.PLYReader;

//=== INCLUDES ================================================================

import auxd.OpenMesh.Core.IO.Streams;

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.SingletonT;
import auxd.OpenMesh.Core.IO.importer.BaseImporter;
import auxd.OpenMesh.Core.IO.reader.BaseReader;
import auxd.OpenMesh.Core.IO.Options : IO_Options;
import auxd.OpenMesh.Core.IO.IOManager;
import binary = auxd.OpenMesh.Core.IO.BinaryHelper;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Utils.color_cast;
import auxd.OpenMesh.Core.Mesh.Handles;
import util = auxd.OpenMesh.Core.Utils.Std;


import boxer = std.boxer;
import math = std.math;
static import std.string;
static import std.conv;
//import std.c;
//import std.c.string;

import std.io;
alias writefln debugfln;


//== IMPLEMENTATION ===========================================================

// Some helper routines
private {
    bool startsWith(string s, string sub) {
        return (s.length>=sub.length && s[0..sub.length]==sub);
    }
    bool endsWith(string s, string sub) {
        return (s.length>=sub.length && s[$-sub.length..$]==sub);
    }

    // Hack copied from std.boxer
    bool isArrayTypeInfo(TypeInfo type)
    {
        char[] name = type.classinfo.name;
        return name.length >= 10 && name[9] == 'A' && name != "TypeInfo_AssociativeArray";
    }

    template unbox_convert(T) {
        T unbox_convert(boxer.Box value)
        {
            return boxer.unbox!(T)(value);
        }
    }

    // Unboxes all the elements of a boxed array using the conversion rules
    // used when unboxing single values.  In other words allow float[] to be 
    // unboxed as double[], etc.
    template unbox_convert(T:T[]) {
        T[] unbox_convert(boxer.Box value) {
            assert (value.type !is null);
        
            if (typeid(T[]) is value.type)
                return *cast(T[]*) value.data;
            if (typeid(void*) is value.type && *cast(void**) value.data is null)
                return null;
            if (!isArrayTypeInfo(value.type)) {
                throw new boxer.UnboxException(value, typeid(T[]));
            }
            // try to convert each element
            auto elinfo = value.type.next(); // TODO: is this always the elem type??

            void[] data = value.data;
            void* data_ptr = (*cast(void[]*) data).ptr;
            uint nelem = (*cast(void[]*) data).length;

            // See if one element of the data is unboxable
            boxer.Box testbox = boxer.box(elinfo, data_ptr);
            if (!testbox.unboxable(typeid(T))) {
                throw new boxer.UnboxException(value, typeid(T[]));
            }
            T[] ret;
            ret.length = nelem;
            for(int i=0; i<nelem; i++) {
                ret[i] = boxer.unbox!(T)( boxer.box(elinfo, data_ptr + i*elinfo.tsize) );
            }
            return ret;
        }
    }
    ubyte unbox_color_comp(boxer.Box value) {
        // convert floating point types from [0,1] to [0,255].
        ubyte ret;
        TypeInfo tinfo = value.type;
        if (tinfo is typeid(float) ||
            tinfo is typeid(double)) 
        {
            double dval = boxer.unbox!(double)(value);
            //clamp 
            if (dval>1.0) dval = 1.0;
            if (dval<0.0) dval = 0.0;
            ret = cast(ubyte)(math.round(255.0 * dval));
        }
        else {
            long lval = boxer.unbox!(long)(value);
            if (lval > 255) lval = 255;
            if (lval < 0) lval = 0;
            ret = cast(ubyte)lval;
        }
        return ret;
    }
}

/** 
    Implementation of the PLY format reader. This class is singleton'ed by 
    SingletonT to PLYReader.
*/
class _PLYReader_ : public BaseReader
{
  public:

    private alias std.string.toStringz c_str;
    const LINE_LEN = 1024;

    this() {   IOManager().register_module(this); }

    string get_description() /*const*/ { return "PLY Format"; }
    string get_extensions()  /*const*/ { return "ply"; }
    string get_magic()       /*const*/ { return "ply\n"; }

    bool read(/*const*/ string _filename, 
              BaseImporter _bi, 
              inout IO_Options _opt)
    {
        auto ifs = new BufferedFile(_filename, FileMode.In);
        scope(exit) { ifs.close(); delete ifs; }

        if (!ifs.isOpen())
        {
            derr.writefln("[PLYReader] : cannot not open file ", _filename).flush;
            return false;
        }

        IO_Options opt_ret = _opt;
        // Take away things PLY doesn't support

        bool result = read(ifs, _bi, opt_ret);

        _opt = opt_ret;

        return result;
    }

    bool can_u_read(/*const*/ string _filename) /*const*/
    {
        // !!! Assuming BaseReader.can_u_parse( std.string& )
        // does not call BaseReader.read_magic()!!!
        if (super.can_u_read(_filename))
        {
            auto ifs = new BufferedFile(_filename, FileMode.In);
            scope(exit) { ifs.close(); delete ifs; }
            return (ifs.isOpen() && can_u_read(ifs));
        }
        return false;
    }



  private:
    static class InvalidFormatError : Exception
    {
        this(string msg) { super(msg); }
    }

    bool read(InputStream _in, BaseImporter _bi, inout IO_Options _opt ) /*const*/
    {
        scope desc = new _Descrip;
        try {
            parse_header(_in, desc, _bi);
        }
        catch(Exception e) { 
            derr.writefln("Error: ", e).flush;
            return false; 
        }

        if (!desc.vertex_has_normal)   _opt -= IO_Options.VertexNormal;
        if (!desc.vertex_has_color)    _opt -= IO_Options.VertexColor;
        if (!desc.vertex_has_texcoord) _opt -= IO_Options.VertexTexCoord;
        if (!desc.face_has_color)      _opt -= IO_Options.FaceColor;
        if (!desc.face_has_normal)     _opt -= IO_Options.FaceNormal;

        _opt.set_flag(IO_Options.Binary, desc.is_binary);
        _opt.set_flag(IO_Options.Swap,   desc.need_swap);

        return read_impl(_in,_bi,_opt,desc);
    }

    bool read_impl(InputStream _in, BaseImporter _bi, inout IO_Options _opt, _Descrip _desc) 
    {
        alias std.string.strip strip;
        alias std.string.split split;

        char[] line;

        uint nV = _desc.n_vertices;
        uint nF = _desc.n_faces;
        _bi.reserve(nV, 3*nV, nF);

        bool is_binary = _desc.is_binary;

        // READ VERTICES
        for (int i=0; i<nV; ) 
        {
            if (_in.eof) {
                derr.writefln("Unexpected end of file").flush;
                return false;
            }
            /*
            line = _in.readLine();
            line = line.strip();
            if (line.startsWith("comment")) {
                continue;  // not sure if comments are legal outside header or not...
            }*/
            Vec3f p = Vec3f(0,0,0), n = Vec3f(0,0,0);
            Vec2f texc = Vec2f(0,0);
            Vec3ub color = Vec3ub(255,255,255);
            bool got_norm = false;
            bool got_texc = false;
            bool got_color = false;
            bool got_other = false;

            bool want_norm = _opt.check(IO_Options.VertexNormal);
            bool want_color = _opt.check(IO_Options.VertexColor);
            bool want_texc = _opt.check(IO_Options.VertexTexCoord);

            boxer.Box ret;
            VertexHandle vh = _bi.add_vertex();
            foreach(prop; _desc.vprops) {
                if (is_binary) {
                    ret = prop.read_prop_binary(_in, _bi, _opt, _desc.need_swap);
                } else {
                    ret = prop.read_prop_ascii(_in, _bi, _opt);
                }
                if (ret.type is null) {
                    derr.writefln("Failed to read vertex description %s",i).flush;
                    return false;
                }
                switch(prop.name) {
                case "x":  p.x = boxer.unbox!(float)(ret);  break;
                case "y":  p.y = boxer.unbox!(float)(ret);  break;
                case "z":  p.z = boxer.unbox!(float)(ret);  break;
                case "nx":  n.x = boxer.unbox!(float)(ret); got_norm = true; break;
                case "ny":  n.y = boxer.unbox!(float)(ret); got_norm = true; break;
                case "nz":  n.z = boxer.unbox!(float)(ret); got_norm = true; break;
                case "r":  color[0] = unbox_color_comp(ret); got_color = true; break;
                case "g":  color[1] = unbox_color_comp(ret); got_color = true; break;
                case "b":  color[2] = unbox_color_comp(ret); got_color = true; break;
                case "s":  texc[0] = boxer.unbox!(float)(ret); got_texc = true; break;
                case "t":  texc[1] = boxer.unbox!(float)(ret); got_texc = true; break;
                default:
                    if (prop.type_supported) {
                        // ack! need to go box to prop->box
                        TypeInfo[] types; void* data;
                        boxer.boxArrayToArguments([ret], types, data);
                        _bi.set_property(vh, prop.name, types[0],data);
                    }
                }
            }
            _bi.set_point(vh, p);
            if (want_norm && got_norm) {
                _bi.set_normal(vh,n);
            }
            if (want_color && got_color) {
                _bi.set_color(vh,color);
            }
            if (want_texc && got_texc) {
                _bi.set_texcoord(vh,texc);
            }

            ++i;
        }

        // READ FACES
        FaceHandle[] fh_list; fh_list.length = 10;
        VertexHandle[] vs; vs.length = 10; vs.length = 0; // prealloc
        struct NamedBox {
            string name;
            boxer.Box box;
        }
        NamedBox[] extra_fprops;
        for (int i=0; i<nF; )
        {
            if (_in.eof) {
                derr.writefln("Unexpected end of file").flush;
                return false;
            }
/*
            line = _in.readLine();
            line = line.strip();
            if (line.startsWith("comment")) {
                continue;  // not sure if comments are legal outside header or not...
            }
*/
            uint[] vids;
            Vec3f n = Vec3f(0,0,0);
            Vec3ub color = Vec3ub(255,255,255);
            bool got_norm = false;
            bool got_color = false;

            bool want_norm = _opt.check(IO_Options.FaceNormal);
            bool want_color = _opt.check(IO_Options.FaceColor);

            boxer.Box ret;
            int iextras = 0;
            foreach(prop; _desc.fprops) {
                if (is_binary) {
                    ret = prop.read_prop_binary(_in, _bi, _opt, _desc.need_swap);
                } else {
                    ret = prop.read_prop_ascii(_in, _bi, _opt);
                }
                if (ret.type is null) {
                    derr.writefln("Failed to read vertex description %s",i).flush;
                    return false;
                }
                switch(prop.name) {
                case "nx":  n.x = boxer.unbox!(float)(ret); got_norm = true; break;
                case "ny":  n.y = boxer.unbox!(float)(ret); got_norm = true; break;
                case "nz":  n.z = boxer.unbox!(float)(ret); got_norm = true; break;
                case "r":  color[0] = unbox_color_comp(ret); got_color = true; break;
                case "g":  color[1] = unbox_color_comp(ret); got_color = true; break;
                case "b":  color[2] = unbox_color_comp(ret); got_color = true; break;
                case "vertex_indices": vids = unbox_convert!(uint[])(ret); break;
                default:
                    if (prop.type_supported) {
                        if (iextras+1>extra_fprops.length) {
                            extra_fprops.length = extra_fprops.length+1;
                            extra_fprops[$-1].name = prop.name.dup;
                        }
                        else {
                            assert(extra_fprops[iextras].name==prop.name,
                                   "these prop names should be in sync");
                        }
                        extra_fprops[iextras++].box = ret;
                    }
                    
                }
            }
            vs.length = vids.length;
            foreach(ii,idx; vids) { vs[ii] = VertexHandle(idx); }
            vids.length = 0;

            fh_list.length = 0;
            _bi.add_face(vs, &fh_list); // returns list if face got triangulated

            foreach(fh; fh_list) {
                if (want_norm && got_norm) {
                    _bi.set_normal(fh,n);
                    _opt += IO_Options.FaceNormal;
                }
                if (want_color && got_color) {
                    _bi.set_color(fh,color);
                    _opt += IO_Options.FaceColor;
                }
                foreach (ref xprop; extra_fprops) {
                    // ack! need to go box to prop->box
                    TypeInfo[] types; void* data;
                    boxer.boxArrayToArguments([xprop.box], types, data);
                    _bi.set_property(fh, xprop.name, types[0], data);
                }
            }
            ++i;
        }


        return true;
    }

    // reading is true if we're actually reading the file
    //            false if we're just scanning the header
    bool parse_header(InputStream _is, _Descrip _desc, BaseImporter _bi) 
    {
        alias std.string.strip strip;
        alias std.string.split split;

        char[] line; line.length = 4;

        _is.readExact(line.ptr,4);
        if (line != "ply\n") {
            throw new InvalidFormatError(
                "File is not a PLY file.  Missing magic number 'ply\\n' (first line was '"~line~"'");
        }
        
        string[] words;
        string[][] fprops,vprops;
        string cur_element;
        
        bool got_end_header = false;
        for(int lnum=2; !_is.eof(); ++lnum)
        {
            line = _is.readLine();
            line = line.strip();

            if (line == "end_header") {
                got_end_header = true;
                break;
            }

            else if (line.startsWith("comment")) {
                continue;
            }

            else if (line.startsWith("format")) 
            {
                words = line.split();
                // format [fmt] [version]
                string format = words[1];
                if (format == "ascii") {
                    _desc.is_binary = false;
                } else {
                    _desc.is_binary = true;
                    if (format == "binary_big_endian") {
                        version(LittleEndian) {
                            _desc.need_swap = true;
                        }
                    }
                    else if (format == "binary_little_endian") {
                        version(BigEndian) {
                            _desc.need_swap = true;
                        }
                    }
                    else {
                        throw new InvalidFormatError(
                            std.string.format("line %s: Unsupported ply format: '%s'", lnum,format));
                    }
                }
            }

            else if (line.startsWith("element")) 
            {
                words = line.split();
                if (words.length != 3) {
                    throw new InvalidFormatError(
                        std.string.format("line %s: element description has wrong number of components", lnum));
                }
                if (words[1] == "vertex") {
                    _desc.n_vertices = std.conv.toUint(words[2]);
                    //prop_ptr = &_desc.vprops;
                    //known_props_ptr = &known_vprops;
                    cur_element = "vertex";
                } 
                else if (words[1] == "face") {
                    _desc.n_faces = std.conv.toUint(words[2]);
                    //prop_ptr = &_desc.fprops;
                    //known_props_ptr = &known_fprops;
                    cur_element = "face";
                }
                else {
                    throw new InvalidFormatError(
                        std.string.format("line %s: unsupported element type: %s", lnum, words[1]));
                }
            }

            else if (line.startsWith("property")) {
                if (_bi) { // skip the work if we're just scanning header, not actually importing
                    words = line.split();
                    if (cur_element=="vertex") {
                        vprops ~= words.dup;
                    }
                    else if (cur_element == "face") {
                        fprops ~= words.dup;
                    }
                }                    
            }
            else {
                throw new InvalidFormatError(
                    std.string.format("line %s: PLY format syntax error '%s'",lnum,line));
            }
        }
        if (!got_end_header) {
            throw new InvalidFormatError("end_header tag not found in file");
        }

        if (_bi) {
            _process_property_descriptions(_desc, _bi, vprops,fprops);
        }
        return true;
    }

    private void _process_property_descriptions(_Descrip _desc, BaseImporter _bi,
                                                string[][] vprops, string[][] fprops)
    {
        string[string] known_vprops = 
            [
                "x"[]:"x"[],    "y":"y",   "z":"z",
                "nx":"nx", "ny":"ny", "nz":"nz",
                "r":"r",    "g":"g",   "b":"b",
                "red":"r",    "green":"g",   "blue":"b",
                "t":"t",    "s":"s",
             ];
        string[string] known_fprops = 
            [
                "nx"[]:"nx"[], "ny":"ny", "nz":"nz",
                "r":"r",    "g":"g",   "b":"b",
                "red":"r",    "green":"g",   "blue":"b",
                "vertex_indices":"vertex_indices",
             ];
        string[][string] known_vector_suffixes = 
            // These can also be preceeded by an '_'
            [
                "x"[] : cast(string[])["x","y","z","w"],
                "r"   : ["r", "g", "b", "a"],
                "s"   : ["s", "t", "r", "q"],
                "red" : ["red", "green", "blue", "alpha"],
                "0"   : ["0","1","2","3"],
                "1"   : ["1","2","3","4"],
             ];
        string[] words;

        enum ElemT { BadElem=-1,VertexElem=0,FaceElem=1 };
        Prop[]*[2] prop_ptrs = [&_desc.vprops, &_desc.fprops];
        string[string][2] known_props = [known_vprops,known_fprops];
        ElemT cur_element=ElemT.BadElem;

        void update_desc_from_prop(ref string propname) 
        {
            if (auto _ret = propname in known_props[cur_element]) {
                propname = *_ret;
            }
            if (cur_element == ElemT.VertexElem) {
                switch(propname) {
                case "x": case "y": case "z":
                    _desc.vertex_has_position = true; break;
                case "nx": case "ny": case "nz":
                    _desc.vertex_has_normal = true; break;
                case "r": case "g": case "b":
                    _desc.vertex_has_color = true; break;
                case "s": case "t":
                    _desc.vertex_has_texcoord = true; break;
                default:
                    _desc.vertex_has_other = true; break;
                }
            }
            else if (cur_element == ElemT.FaceElem) {
                switch(propname) {
                case "nx": case "ny": case "nz":
                    _desc.face_has_normal = true; break;
                case "r": case "g": case "b":
                    _desc.face_has_color = true; break;
                default:
                    _desc.face_has_other = true; break;
                }
            }
        }
        void add_prop(string[] words) {
            // words is like ["float32", "x"] -- "property" stripped
            string propname = words[1];
            string typename = ply_canonical_type(words[0]);
            update_desc_from_prop(propname);
            bool ok = _bi.supports_property_data_type(ply_data_type_typeid(typename));
            *prop_ptrs[cur_element] ~= new ScalarProp(propname, typename, ok);
            if (!(words[1] in known_props[cur_element])) {
                if ((*prop_ptrs[cur_element])[$-1].type_supported) {
                    dlog.writefln("PLYReader: reading extra %s property, '%s'", 
                                  words[0],words[1]).flush;
                } else {
                    derr.writefln("PLYReader: Ignoring unsupported %s property, '%s'", 
                                  words[0],words[1]).flush;
                }
            }
        }
        void add_vector_prop(string[][] lines, string first_suffix, int N)
        {
            // each lines[i] is like  ["property", "float32", "pos_x"]
            // merge the sequence into one VectorT prop
            string prop_base_name = lines[0][2][0..$-first_suffix.length];
            string prop_type = ply_canonical_type(lines[0][1]);

            TypeInfo ti;
            switch(N) {
            case 2: ti = ply_data_vector_type_typeid!(2)(prop_type); break;
            case 3: ti = ply_data_vector_type_typeid!(3)(prop_type); break;
            case 4: ti = ply_data_vector_type_typeid!(4)(prop_type); break;
            default:
                assert(false, "Unsupported vector length");
            }
            bool ok = _bi.supports_property_data_type(ti);
            *prop_ptrs[cur_element] ~= new VectorProp(prop_base_name, N, prop_type, ok);
            if ((*prop_ptrs[cur_element])[$-1].type_supported) {
                dlog.writefln("PLYReader: reading extra %s-vector %s property, '%s'", 
                              N,prop_type,prop_base_name).flush;
            } else {
                derr.writefln("PLYReader: Ignoring unsupported %s-vector %s property: ", 
                              N,prop_type,prop_base_name).flush;
            }
        }

        void add_list_prop(string[] words) {
            // words is a tokenized ply list property line without the 
            // leading "property list" part.
            // Something like: ["uint8", "int32", "vertex_indices"]
            string propname = words[2];
            string idxtypename = ply_canonical_type(words[0]);
            string typename = ply_canonical_type(words[1]);
            update_desc_from_prop(propname);
            bool ok = _bi.supports_property_data_type(ply_data_type_typeid(typename));
            *prop_ptrs[cur_element] ~= new ListProp(propname,idxtypename,typename, ok);
            if (!(words[2] in known_props[cur_element])) {
                derr.writefln(
                    "PLYReader: Ignoring unsupported %s list property: ",
                    words[1],words[2]).flush;
            }
        }


        int vector_sequence_length(string prop_lines[][], ref string first_suffix)
        {
            // prop_lines[0] is regular tokenized ply prop line 
            // like ["property", "float32", "ambient_r"]
            // see if there is a sequence following this one like "ambient_g","ambient_b"
            // If so make it a vector.
            string pname0 = prop_lines[0][2];
            // known props like just r,g,b are handled separately
            if (pname0 in known_props[cur_element]) return 0; 
            string ptype0 = prop_lines[0][1];
            foreach(start,suffixes; known_vector_suffixes) 
            {
                bool got_start=false;
                string sep = "";
                if (pname0.endsWith("_"~start)) { got_start=true; sep="_";}
                else if (pname0.endsWith(start)) { got_start=true; }
                if (got_start) {
                    // see how big the sequence is
                    string basename0 = pname0[0..$-start.length];
                    int i=1;
                    while(i<suffixes.length 
                          && i<prop_lines.length
                          && prop_lines[i][1]==ptype0 /* catches "list" too*/
                          && prop_lines[i][2].startsWith(basename0)
                          && prop_lines[i][2].endsWith(sep~suffixes[i]))
                    { ++i; }
                    
                    if (i>1) {
                        first_suffix = sep~start;
                        return i;
                    }
                }
            }
            return 0;
        }

        void process_category(ElemT cur_el, string[][] prop_lines)
        {
            cur_element = cur_el;

            for(int idx = 0; idx<prop_lines.length; ++idx)
            {
                string[] words = prop_lines[idx];
                if (words[1] == "list") {
                    add_list_prop(words[2..$]);
                }
                else {
                    string first_suffix;
                    int len = vector_sequence_length(prop_lines[idx..$], first_suffix);
                    switch(len) {
                    case 0: case 1: 
                        add_prop(words[1..$]); 
                        break;

                    case 2: case 3: case 4:
                        add_vector_prop(prop_lines[idx..idx+len], first_suffix, len); idx+=len-1; break;
                    default:
                        assert(false, "bad length for vector property");
                    }
                }
            }
        }

        process_category(ElemT.VertexElem, vprops);

        process_category(ElemT.FaceElem, fprops);
    }

    bool can_u_read(InputStream _is) /*const*/
    {
        try {
            auto desc = new _Descrip;
            if (!parse_header(_is, desc, null)) {
                //dout.writefln("Desc:\n",desc).flush;
                return false;
            }

        }
        catch(Exception e) {
            derr.writefln("Error: ", e).flush;
            return false;
        }
        return true;
    }


    static TypeInfo ply_data_type_typeid(string type) {
        switch(type) {
        case "int8":   return typeid(byte);
        case "uint8":  return typeid(ubyte);
        case "int16":  return typeid(short);
        case "uint16": return typeid(ushort);
        case "int32":    return typeid(int);
        case "uint32":   return typeid(uint);
        case "float32":  return typeid(float);
        case "float64": return typeid(double);

        default: return null;
        }
    }
    static TypeInfo ply_data_vector_type_typeid(int N)(string type) {
        switch(type) {
        case "int8":   return typeid(VectorT!(byte,N));
        case "uint8":  return typeid(VectorT!(ubyte,N));
        case "int16":  return typeid(VectorT!(short,N));
        case "uint16": return typeid(VectorT!(ushort,N));
        case "int32":    return typeid(VectorT!(int,N));
        case "uint32":   return typeid(VectorT!(uint,N));
        case "float32":  return typeid(VectorT!(float,N));
        case "float64": return typeid(VectorT!(double,N));
        default: return null;
        }
    }

    static uint ply_format_binary_size(string type) {
        uint[string] prop_sizes =
            [
                "int8"[]     :  1u,
                "uint8"      :  1,
                "int16"      :  2,
                "uint16"     :  2,
                "int32"      :  4,
                "uint32"     :  4,
                "float32"    :  4,
                "float"      :  4,
                "float64"    :  8,
                "double"     :  8,
             ];
        if (type in prop_sizes) {
            return prop_sizes[type];
        }
        else {
            throw new InvalidFormatError("Unknown data type: "~type);
        }
    }

    // Some ply files contain types like 'int' or 'uchar' instead
    // of the specific in32, uint8 types.
    static string ply_canonical_type(string type) 
    {
        string[string] prop_names =
            [
                "int8"[]     :  "int8"[],
                "char"       :  "int8",
                "byte"       :  "int8",
                "uint8"      :  "uint8",
                "uchar"      :  "uint8",
                "ubyte"      :  "uint8",
                "int16"      :  "int16",
                "uint16"     :  "uint16",
                "int32"      :  "int32",
                "int"        :  "int32",
                "uint32"     :  "uint32",
                "float32"    :  "float32",
                "float"      :  "float32",
                "float64"    :  "float64",
                "double"     :  "float64",
             ];
        if (type in prop_names) {
            return prop_names[type].dup;
        }
        else {
            throw new InvalidFormatError("Unknown data type: "~type);
        }
    }
    union PlyValue {
        byte   int8;
        ubyte  uint8;
        short  int16;
        ushort uint16;
        int    int32;
        uint   uint32;
        float  float32;
        double float64;
    }

    static class Prop {
        this(string _name, string _type, bool _bi_supported) {
            name = _name.dup;
            type = _type.dup;
            type_supported = _bi_supported;
            typeinfo = ply_data_type_typeid(type);
        }
        string name;
        string type;
        bool type_supported;
        TypeInfo typeinfo;

        // std.stream doesn't parse nan or inf properly, so we do it ourselves
        void read_float(InputStream _in, float* f_out) {
            string str;
            _in.readf("%s",&str); // basically tokenize on white space
            //debug dout.writefln("Read float num: %s", str).flush;
            try {
                *f_out = std.conv.toFloat(str);
            } catch(std.conv.ConvError e) {
                derr.writefln("PLYReader: Bad float32 number: %s", str).flush;
            }
        }
        void read_double(InputStream _in, double* f_out) {
            string str;
            _in.readf("%s",&str); // basically tokenize on white space
            //debug dout.writefln("Read float num: %s", str).flush;
            try {
                *f_out = std.conv.toDouble(str);
            } catch(std.conv.ConvError e) {
                derr.writefln("PLYReader: Bad float64 number: %s", str).flush;
            }
        }


        boxer.Box read_one_ascii(InputStream _in, string _type) {
            PlyValue p;
            boxer.Box ret;
            switch(_type) {
            case "int8": _in.readf(&p.int8); ret = boxer.box(p.int8); break;
            case "uint8": _in.readf(&p.uint8); ret = boxer.box(p.uint8); break;
            case "int16": _in.readf(&p.int16); ret = boxer.box(p.int16);  break;
            case "uint16": _in.readf(&p.uint16); ret = boxer.box(p.uint16); break;
            case "int32": _in.readf(&p.int32); ret = boxer.box(p.int32); break;
            case "uint32": _in.readf(&p.uint32); ret = boxer.box(p.uint32); break;
            case "float32": read_float(_in,&p.float32); ret = boxer.box(p.float32); break;
            case "float64": read_double(_in,&p.float64); ret = boxer.box(p.float64); break;
            default:
                derr.writefln("Bad data type: '%s'", this.type);
            }
            return ret;
        }

        boxer.Box read_array_ascii(InputStream _in, string _type, uint len) {
            PlyValue p;
            boxer.Box ret;
            //debug { dout.writefln("read_array_ascii: read len=%s of type=%s",len,_type).flush; }
            static string make_case(string t, string read_func="_in.readf") {
                return
                    "{
                       typeof(p."~t~")[] arr; arr.length = len;
                       foreach(ref x; arr) {
                          "~read_func~"(&x); 
                       } ret = boxer.box(arr);
                     } ";
            }
            void float_reader(float *f) { read_float(_in, f); }
            void double_reader(double *f) { read_double(_in, f); }
            switch(_type) {
            case "int8":   mixin(make_case("int8"));  break;
            case "uint8":  mixin(make_case("uint8")); break;
            case "int16":  mixin(make_case("int16")); break;
            case "uint16": mixin(make_case("uint16")); break;
            case "int32":  mixin(make_case("int32")); break;
            case "uint32": mixin(make_case("uint32")); break;
            case "float32":mixin(make_case("float32","float_reader")); break;
            case "float64":mixin(make_case("float64","double_reader")); break;
            default:
                derr.writefln("Bad data type: '%s'", this.type);
            }
            return ret;
        }

        boxer.Box read_vector_ascii(InputStream _in, string _type, uint len) {
            PlyValue p;
            //debug { dout.writefln("read_vector_ascii: read len=%s of type=%s",len,_type).flush; }
            static string make_case(string t, string L, string read_func="_in.readf") {
                return
                    "{
                       VectorT!(typeof(p."~t~"), "~L~") vec;
                       foreach(ref x; vec) {
                          "~read_func~"(&x);
                       } box_ret = boxer.box(vec);
                     } ";
            }
            static string make_switch(string L) {
                string ret = "{ matched=true;\nswitch(_type) {\n";
                foreach(i,t; ["int8","uint8","int16","uint16","int32","uint32"])
                {
                    ret ~= "case \"" ~ t ~ "\": " ~ make_case(t,L) ~ " break;";
                }
                ret ~= "case \"float32\": " ~ make_case("float32",L,"float_reader") ~ " break;";
                ret ~= "case \"float64\": " ~ make_case("float64",L,"double_reader") ~ " break;";
                ret ~= "default: matched=false;\n";
                ret ~= " } }";
                return ret;
            }
            void float_reader(float *f) { read_float(_in, f); }
            void double_reader(double *f) { read_double(_in, f); }

            boxer.Box box_ret;
            bool matched = false;
            switch(len) {
            case 2: mixin(make_switch("2")); break;
            case 3: mixin(make_switch("3")); break;
            case 4: mixin(make_switch("4")); break;
            default:
                derr.writefln("Bad vector length: '%s'", this.type);
            }
            if (!matched) {
                derr.writefln("Bad data type: '%s'", this.type);
            }
            return box_ret;
        }


        boxer.Box read_one_binary(InputStream _in, string _type, bool swap) {
            PlyValue p;
            boxer.Box ret;
            alias binary.swap_endian do_swap;
            switch(_type) {
            case "int8": _in.read(p.int8); if(swap) do_swap(p.int8); ret = boxer.box(p.int8); break;
            case "uint8": _in.read(p.uint8); if(swap) do_swap(p.uint8); ret = boxer.box(p.uint8); break;
            case "int16": _in.read(p.int16); if(swap) do_swap(p.int16);ret = boxer.box(p.int16);  break;
            case "uint16": _in.read(p.uint16); if(swap) do_swap(p.uint16);ret = boxer.box(p.uint16); break;
            case "int32": _in.read(p.int32); if(swap) do_swap(p.int32);ret = boxer.box(p.int32); break;
            case "uint32": _in.read(p.uint32); if(swap) do_swap(p.uint32);ret = boxer.box(p.uint32); break;
            case "float32": _in.read(p.float32); if(swap) do_swap(p.float32);ret = boxer.box(p.float32); break;
            case "float64": _in.read(p.float64); if(swap) do_swap(p.float64);ret = boxer.box(p.float64); break;
            default:
                derr.writefln("Bad data type: '%s'", this.type);
            }
            return ret;
        }

        boxer.Box read_array_binary(InputStream _in, string _type, uint len, bool swap) {
            PlyValue p;
            boxer.Box ret;
            alias binary.swap_endian do_swap;
            static string make_case(string t) {
                return
                    "{
                       typeof(p."~t~")[] arr; arr.length = len;
                       foreach(ref x; arr) {
                          _in.read(x); if(swap) do_swap(x);
                       } ret = boxer.box(arr);
                     } ";
            }
            switch(_type) {
            case "int8":   mixin(make_case("int8"));  break;
            case "uint8":  mixin(make_case("uint8")); break;
            case "int16":  mixin(make_case("int16")); break;
            case "uint16": mixin(make_case("uint16")); break;
            case "int32":  mixin(make_case("int32")); break;
            case "uint32": mixin(make_case("uint32")); break;
            case "float32":mixin(make_case("float32")); break;
            case "float64":mixin(make_case("float64")); break;
            default:
                derr.writefln("Bad data type: '%s'", this.type);
            }
            return ret;
        }

        boxer.Box read_vector_binary(InputStream _in, string _type, uint len, bool swap) {
            PlyValue p;
            alias binary.swap_endian do_swap;
            static string make_case(string t,string L) {
                return
                    "{
                       VectorT!(typeof(p."~t~"),"~L~") vec;
                       foreach(ref x; vec) {
                          _in.read(x); if(swap) do_swap(x);
                       } box_ret = boxer.box(vec);
                     } ";
            }
            static string make_switch(string L) {
                string ret = "{ matched=true;\nswitch(_type) {\n";
                foreach(i,t; ["int8","uint8","int16","uint16","int32","uint32",
                              "float32","float64"])
                {
                    ret ~= "case \"" ~ t ~ "\": " ~ make_case(t,L) ~ " break;";
                }
                ret ~= "default: matched=false;\n";
                ret ~= " } }";
                return ret;
            }

            boxer.Box box_ret;
            bool matched = false;
            switch(len) {
            case 2: mixin(make_switch("2")); break;
            case 3: mixin(make_switch("3")); break;
            case 4: mixin(make_switch("4")); break;
            default:
                derr.writefln("Bad vector length: '%s'", this.type);
            }
            if (!matched) {
                derr.writefln("Bad data type: '%s'", this.type);
            }
            return box_ret;
        }


        abstract boxer.Box read_prop_ascii(InputStream _in, BaseImporter _bi, ref IO_Options _opt);
        abstract boxer.Box read_prop_binary(InputStream _in, BaseImporter _bi, ref IO_Options _opt, bool _swap);
    }

    static class ScalarProp : Prop {
        this(string _name, string _type, bool _bi_supports) {
            super(_name, ply_canonical_type(_type), _bi_supports);
            size = ply_format_binary_size(this.type);
        }
        override boxer.Box read_prop_ascii(InputStream _in, BaseImporter _bi, ref IO_Options _opt)
        {
            return read_one_ascii(_in, this.type);
        }
        override boxer.Box read_prop_binary(InputStream _in, BaseImporter _bi, ref IO_Options _opt, bool _swap)
        {
            return read_one_binary(_in, this.type, _swap);
        }
        string toString() {
            return "ScalarProp("~name~","~type~")";
        }
        uint size;
    }

    static class VectorProp : Prop {
        this(string name, int n_elem, string elem_t, bool _bi_supports) {
            super(name, "vector", _bi_supports);
            num_elem = n_elem;
            elem_type = ply_canonical_type(elem_t);
            elem_size = ply_format_binary_size(elem_type);
        }
        override boxer.Box read_prop_ascii(InputStream _in, BaseImporter _bi, ref IO_Options _opt)
        {
            //debug { dout.writefln("Read VectorProp: elem_t=%s, n_elem=%s",elem_type,num_elem);}
            boxer.Box ret = read_vector_ascii(_in, this.elem_type, num_elem);
            return ret;
        }
        override boxer.Box read_prop_binary(InputStream _in, BaseImporter _bi, ref IO_Options _opt, bool _swap)
        {
            boxer.Box ret = read_vector_binary(_in, this.elem_type, num_elem, _swap);
            return ret;
        }
        string toString() {
            return "VectorProp("~name~","~std.string.toString(num_elem)~","~elem_type~")";
        }
        string elem_type;
        uint elem_size;
        uint num_elem;
    }

    static class ListProp : Prop {
        this(string name, string idx_t, string elem_t, bool _bi_supports) {
            super(name, "list", _bi_supports);
            index_type = ply_canonical_type(idx_t);
            elem_type = ply_canonical_type(elem_t);
            index_size = ply_format_binary_size(index_type);
            elem_size = ply_format_binary_size(elem_type);
        }
        override boxer.Box read_prop_ascii(InputStream _in, BaseImporter _bi, ref IO_Options _opt)
        {
            boxer.Box val;
            val = read_one_ascii(_in, this.index_type);
            uint nelem = boxer.unbox!(uint)(val);

            return read_array_ascii(_in, this.elem_type, nelem);
        }
        override boxer.Box read_prop_binary(InputStream _in, BaseImporter _bi, ref IO_Options _opt, bool _swap)
        {
            boxer.Box val;
            val = read_one_binary(_in, this.index_type, _swap);
            uint nelem = boxer.unbox!(uint)(val);

            return read_array_binary(_in, this.elem_type, nelem, _swap);
        }
        string toString() {
            return "ListProp("~name~","~index_type~","~elem_type~")";
        }
        string index_type;
        string elem_type;
        uint index_size;
        uint elem_size;
    }

    static class _Descrip {
        bool vertex_has_position = true;
        bool vertex_has_normal   = false;
        bool vertex_has_color    = false;
        bool vertex_has_texcoord = false;
        bool vertex_has_other    = false;
        bool face_has_normal     = false;
        bool face_has_color      = false;
        bool face_has_other      = false;
        bool is_binary           = false;
        bool need_swap           = false;

        Prop[] vprops;
        Prop[] fprops;

        uint n_vertices = 0;
        uint n_faces = 0;

        string toString() {
            return std.string.format(
                "  n verts: %s\n", n_vertices,
                "  n faces: %s\n", n_faces,
                "  vpos   : %s\n", vertex_has_position,
                "  vnorm  : %s\n", vertex_has_normal,
                "  vcolor : %s\n", vertex_has_color,
                "  vtex   : %s\n", vertex_has_texcoord,
                "  vother : %s\n", vertex_has_other,
                "  fnorm  : %s\n", face_has_normal,
                "  fcolor : %s\n", face_has_color,
                "  binary : %s\n", is_binary,
                "  swap   : %s\n", need_swap,
                " vprops  : %s\n", vprops,
                " fprops  : %s\n", fprops);
        }
    }
}


//== TYPE DEFINITION ==========================================================


static this() {
    // creates and registers the default instance;
    PLYReader();
}


/// Declare the single entity of the PLY reader
private _PLYReader_  __PLYReaderInstance = null;
_PLYReader_ PLYReader() { 
    if (__PLYReaderInstance is null) { 
        __PLYReaderInstance = new _PLYReader_();
    }
    return __PLYReaderInstance; 
}


unittest {
    auto reader = PLYReader() ;
}


//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:



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
