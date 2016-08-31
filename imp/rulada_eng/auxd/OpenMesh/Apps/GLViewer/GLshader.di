/*==========================================================================
 * GLshader.d
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

module GLshader;
version(Tango) import std.compat;
import derelict.opengl.gl;
import derelict.opengl.glu;
import derelict.util.exception;

import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.Utils.Std : insert, erase_index;
import strlib = std.string;
alias strlib.toStringz c_str;
import std.stream;

import std.io;
alias writefln debugfln;

static bool G_shaders_supported = false;

private string[] G_shader_path_;

/** Splice in the list of dirnames to the shader path
 *  The list is spliced in before the position idx.  Negative 
 *  idx values are calculated relative to the end+1
 *  So -1 appends after the last element
 *     -2 appends just before the last element
 *      0 prepends before all elements
 */
void shader_path_add(string dirlist[], int idx=-1)
{
    if (idx<0) idx = G_shader_path_.length + idx + 1;
    foreach_reverse(d; dirlist) {
        G_shader_path_.insert(cast(size_t)idx,d);
    }
}
/** Add the directory dirname to the shader path
 *  Inserts before the position idx.  Negative 
 *  idx values are calculated relative to the end+1
 *  So -1 appends after the last element
 *     -2 appends just before the last element
 *      0 prepends before all elements
 */
void shader_path_add(string dir, int idx=-1)
{
    if (idx<0) idx = G_shader_path_.length + idx + 1;
    G_shader_path_.insert(cast(size_t)idx,dir);
}

/** Delete the search path component at index 
 *  If index is negative then it is interpreted from 
 *  end of list.
 */
void shader_path_del(int idx) {
    if (idx<0) idx = G_shader_path_.length + idx + 1;
    G_shader_path_.erase_index(cast(size_t)idx);
}

/** Return the complete shader search path */
string[] get_shader_path(string dirname)
{
    return G_shader_path_;
}

/** Read text file, throws exception if it can't */
string textFileReadThrows(string _filename)
{
    char[] ret;
    auto ifs = new BufferedFile(_filename, FileMode.In);
    scope(exit) { ifs.close(); delete ifs; }

    foreach(ulong n, char[] line; ifs) {
        ret ~= line;
        ret ~= "\n";
    }    
    return ret;
}

/** Read text file, return empty string if it can't */
string textFileRead(string _filename)
{
    char[] ret;
    try {
        ret = textFileReadThrows(_filename);
    }
    catch(Exception e) {
        derr.writefln("Problem reading ", _filename).flush;
    }
    return ret;
}

string textFilePathRead(string _filename)
{
    if (std.path.isabs(_filename)) {
        return textFileRead(_filename);
    }
    foreach(dir; G_shader_path_) {
        char[] path = std.path.join(dir,_filename);
        try {
            char[] ret = textFileReadThrows(path);
            return ret;
        }
        catch(StreamException e) {
        }
    }
}



bool glslInit() {

    try{
        DerelictGL.loadVersions(GLVersion.Version20);
    } catch(SharedLibProcLoadException e) {
        G_shaders_supported = false;
        string ver = DerelictGL.versionString(DerelictGL.availableVersion);
        derr.writefln("GL version %s.  GL >2.0 required for shader support.", ver);
        return false;
    }
    G_shaders_supported = true;
    string ver = DerelictGL.versionString(DerelictGL.availableVersion);
    dlog.writefln("GL version %s.  Shader support enabled.", ver);
    return true;
}

void printGLLog(Stream sout, GLuint obj)
{
    int infologLength = 0;
    char[1024] infoLog;
 
	if (glIsShader(obj))
		glGetShaderInfoLog(obj, 1024, &infologLength, infoLog.ptr);
	else
		glGetProgramInfoLog(obj, 1024, &infologLength, infoLog.ptr);
 
    if (infologLength > 0)
		sout.writefln("-----\nGLLog\n-----\n",infoLog[0..infologLength]).flush;
}

class ShaderProgram
{
    string vert_file;
    string frag_file;
    GLuint vert_id = 0;
    GLuint frag_id = 0;
    GLuint prog_id = 0;
    
    this(string vfile, string ffile) {
        vert_file = vfile;
        frag_file = ffile;
    }

    void set_programs(string vfile, string ffile) {
        vert_file = vfile;
        frag_file = ffile;
        if (!initialized()) { init(); }
        reload_source();
    }

    bool init() {
        writefln("Initialize shader program");
        prog_id = glCreateProgram();
        vert_id = glCreateShader(GL_VERTEX_SHADER);
        frag_id = glCreateShader(GL_FRAGMENT_SHADER);

        reload_source();
        return true;
    }

    void destroy() {
        glDeleteProgram(prog_id);
        glDeleteShader(vert_id);
        glDeleteShader(frag_id);
    }

    bool initialized() {
        return (prog_id!=0);
    }

    void reload_source() {
        string code; char*ptr; int len;

        if (!initialized) init();

        code = textFilePathRead(vert_file);
        ptr = code.ptr;
        len = code.length;
        glShaderSource(vert_id, 1, &ptr, &len);

        code = textFilePathRead(frag_file);
        ptr = code.ptr;
        len = code.length;
        glShaderSource(frag_id, 1, &ptr, &len);
    }	

    bool compile() {
        if (!prog_id) { init(); }
        if (!prog_id) return false;

        GLuint[10] cur_ids;
        int nattached;
        glGetAttachedShaders(prog_id, cur_ids.length, &nattached, cur_ids.ptr);
        bool is_attached(GLuint id) {
            foreach(i; cur_ids[0..nattached]) {
                if (i==id) return true;
            }
            return false;
        }

        GLint compileStatus;
        glCompileShader(vert_id);
        glGetShaderiv(vert_id, GL_COMPILE_STATUS, &compileStatus);
        if (compileStatus) {
            if (!is_attached(vert_id))
                glAttachShader(prog_id,vert_id);
        } else {
            derr.writefln("Could not compile vertex shader.").flush;
            printGLLog(derr,vert_id);
        }
    
        glCompileShader(frag_id);
        glGetShaderiv(frag_id, GL_COMPILE_STATUS, &compileStatus);
        if (compileStatus) {
            if (!is_attached(frag_id))
                glAttachShader(prog_id,frag_id);
        } else {
            derr.writefln("Could not compile fragment shader.").flush;
            printGLLog(derr,frag_id);
        }
	
        glLinkProgram(prog_id);
        GLint linkStatus;
        glGetProgramiv(prog_id, GL_LINK_STATUS, &linkStatus);
        if (linkStatus) {
        }
        else {
            derr.writefln("Could not link the program.").flush;
            printGLLog(derr,prog_id);

        }
        return linkStatus != GL_FALSE;
    }

    bool active() {
        if (!prog_id) return false;
        GLint cur_id;
        glGetIntegerv(GL_CURRENT_PROGRAM, &cur_id);
        return (cur_id == prog_id);
    }

    void activate(bool yesno=true) {
        if (yesno) {
            glUseProgram(prog_id);
        }
        else deactivate();
    }

    void deactivate() {
        glUseProgram(0);
    }

    
}


void setShaders(string vfile, string ffile)
{
    GLuint vShader = glCreateShader(GL_VERTEX_SHADER);
    GLuint fShader = glCreateShader(GL_FRAGMENT_SHADER);	
	
    string vcode = textFilePathRead(vfile);
    string fcode = textFilePathRead(ffile);
	
    char*ptr = fcode.ptr;
    int len = fcode.length;
    glShaderSource(fShader, 1, &ptr, &len);

    ptr = vcode.ptr;
    len = vcode.length;
    glShaderSource(vShader, 1, &ptr, &len);
	
    GLuint prog = glCreateProgram();

    GLint compileStatus;
    glCompileShader(vShader);
    glGetShaderiv(vShader, GL_COMPILE_STATUS, &compileStatus);
	if (compileStatus) {
        glAttachShader(prog,vShader);
    } else {
		derr.writefln("Could not compile vertex shader.").flush;
        printGLLog(derr,vShader);
    }
    
    glCompileShader(fShader);
    glGetShaderiv(fShader, GL_COMPILE_STATUS, &compileStatus);
	if (compileStatus) {
        glAttachShader(prog,fShader);
    } else {
		derr.writefln("Could not compile fragment shader.").flush;
        printGLLog(derr,fShader);
    }
	
    glLinkProgram(prog);
    GLint linkStatus;
    glGetProgramiv(prog, GL_LINK_STATUS, &linkStatus);
	if (linkStatus) {
        glUseProgram(prog);
    }
    else {
		derr.writefln("Could not link the program.").flush;
        printGLLog(derr,prog);

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
