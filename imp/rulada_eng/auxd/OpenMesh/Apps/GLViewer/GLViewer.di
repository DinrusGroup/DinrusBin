//============================================================================
// GLViewer.d - OpenGL Viewer with OpenMesh
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   A simple example of using OpenMesh/D to implement a TriMesh viewer
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 01 Sep 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 */
//============================================================================

module GLViewer;
version(Tango) import std.compat;

import derelict.opengl.gl;
import derelict.opengl.glu;
import derelict.sdl.sdl;
import GLshader;

//import auxd.OpenMesh.Core.Mesh.api;
import auxd.OpenMesh.Core.IO.Options : IO_Options;
import auxd.OpenMesh.Core.Geometry.VectorTypes;
import auxd.OpenMesh.Core.Utils.color_cast;
import auxd.OpenMesh.Core.Utils.Property;


import auxd.OpenMesh.Core.IO.Streams;

import arcball;
import MeshTypes;
import DrawerTypes;

alias MyPolyMesh MeshT;
alias MeshPolyDrawer MeshDrawer;

import MeshLoader;


import strlib = std.string;
alias strlib.toStringz c_str;
import math = std.math;
static import std.path;
static import std.file;


static string g_WindowBaseTitle = "OpenMesh/D OpenGL Viewer";

static this()
{
    // load the SDL shared library
    DerelictSDL.load();
    DerelictGL.load();
    DerelictGLU.load();

    SDL_Init(SDL_INIT_VIDEO);
}
static ~this()
{
    // Close OpenGL window and terminate GLFW
    SDL_Quit();
}


class VideoException : Exception
{
    this(char[] msg) {
        super(msg);
    }
}
struct SDLstate
{
    struct Mods {
        SDLMod mods,bmods;
        bool gotmods=false;
        void setup_mods() {
            if (!gotmods) { 
                mods = SDL_GetModState(); 
                bmods = mods&(KMOD_ALT|KMOD_CTRL|KMOD_SHIFT);
                gotmods=true; 
            }
        }
        bool alt_down() {
            setup_mods();
            return (mods & KMOD_ALT) != 0;
        }
        bool ctrl_down() {
            setup_mods();
            return (mods & KMOD_CTRL) != 0;
        }
        bool shift_down() {
            setup_mods();
            return (mods & KMOD_SHIFT) != 0;
        }
        bool is_alt() {
            setup_mods();
            return (bmods != 0) && (bmods & KMOD_ALT) == bmods;
        }
        bool is_ctrl() {
            setup_mods();
            return (bmods != 0) && (bmods & KMOD_CTRL) == bmods;
        }
        bool is_shift() {
            setup_mods();
            return (bmods != 0) && (bmods & KMOD_SHIFT) == bmods;
        }
        bool opEquals(uint m) {
            setup_mods();
            // Mask out states we don't care about
            m &= (KMOD_CTRL | KMOD_ALT | KMOD_SHIFT);
            // we want KMOD_LEFT_ALT in m to give us true if bmod RIGHT_ALT is true
            if (m&KMOD_ALT) m|=KMOD_ALT;
            if (m&KMOD_CTRL) m|=KMOD_CTRL;
            if (m&KMOD_SHIFT) m|=KMOD_SHIFT;
            if (bmods == m) return true;
            return (bmods != 0) && (bmods & m) == bmods;
        }
    }
    struct Buttons {
        uint btns;
        bool gotbtns=false;
        void setup_btns() {
            if (!gotbtns) { btns = SDL_GetMouseState(null,null); gotbtns=true; }
        }
        bool left_down() {
            setup_btns();
            return (btns & SDL_BUTTON(1)) != 0;
        }
        bool middle_down() {
            setup_btns();
            return (btns & SDL_BUTTON(2)) != 0;
        }
        bool right_down() {
            setup_btns();
            return (btns & SDL_BUTTON(3)) != 0;
        }
        bool is_left() {
            setup_btns();
            return (btns & SDL_BUTTON(1)) == SDL_BUTTON(1);
        }
        bool is_middle() {
            setup_btns();
            return (btns & SDL_BUTTON(2)) == SDL_BUTTON(2);
        }
        bool is_right() {
            setup_btns();
            return (btns & SDL_BUTTON(3)) == SDL_BUTTON(3);
        }
    }
    void reset() { mod.gotmods = btn.gotbtns = false; }
    
    Mods mod;
    Buttons btn;
    alias mod modifier;
    alias btn button;
    alias mod mods;
    alias btn btns;
    alias btn buttons;
}



class App
{
    MeshT mesh;
    MeshDrawer drawer;
    ArcBallController arcball_;
    Vec3f translation_;
    double zoom_ = 1.0;
    int win_width_ = 100;
    int win_height_ = 100;
    int[2] last_pos_;
    string current_file_;

    this(string[] args) {
        mesh = new MeshT;
        drawer = new MeshDrawer(mesh);
        arcball_ = new ArcBallController;
        translation_ = Vec3f(0,0,0);
        char[] mfile;

        if (args.length>1) {
            mfile = args[1];
        }
        else {
            throw new Exception("You must supply a file name on the command line");
        }

        {
            GLshader.shader_path_add(
                [std.file.getcwd, std.path.getDirName(args[0])]);
        }

        IO_Options opt;
        if (!MeshLoader.open_mesh!(MeshT)(mesh, mfile, opt)) {
            dlog.writefln("Read of model %s failed", mfile).flush;
            current_file_ = null;
        } else {
            current_file_ = mfile.dup;
            drawer.set_mesh(mesh);
            drawer.view_all();
        }
    }

    void zoom_by(float factor) { zoom_ *= factor; }

    void draw()
    {
        drawer.setup_modelview_matrix();
        Vec3f ctr = drawer.get_center();

        drawer.multviewGL();
        {
            glTranslatef(translation_.x,translation_.y,translation_.z);
            {
                glTranslatef(ctr.x,ctr.y,ctr.z);
                glScaled(zoom_, zoom_, zoom_);
                arcball_.multMatrixGL();
                glTranslatef(-ctr.x,-ctr.y,-ctr.z);
            }
            drawer.drawGL();
            glTranslatef(-translation_.x,-translation_.y,-translation_.z);
        }
        //arcball_.drawBall();
    }

    void resize(int w, int h) {
        win_width_ = w;
        win_height_ = h;
        drawer.resizeGL(w,h);
        drawer.setup_projection_matrix();
        arcball_.resizeRegion(w,h);
    }

    void mouse_wheel(ref SDL_MouseButtonEvent ev)
    {
        if (ev.button == SDL_BUTTON_WHEELUP) {
            zoom_ *= 1.0/1.1;
        }
        else {
            zoom_ *= 1.1;
        }
    }

    void mouse_down(ref SDL_MouseButtonEvent ev)
    {
        SDLstate s;

        if (s.mods.is_ctrl) {
        }
        else if (ev.button == SDL_BUTTON_LEFT) {
            arcball_.startDrag(ev.x,ev.y);
        }
        last_pos_[0] = ev.x;
        last_pos_[1] = ev.y;
    }

    void mouse_up(ref SDL_MouseButtonEvent ev)
    {
        SDLstate s;

        if (s.mods.is_ctrl) {
        }
        else if (ev.button == SDL_BUTTON_LEFT) {
            arcball_.endDrag();
        }
        last_pos_[0] = ev.x;
        last_pos_[1] = ev.y;
    }

    void mouse_move(ref SDL_MouseMotionEvent ev)
    {
        SDLstate s;
        
        // zoom-inout
        if (s.button.is_left && s.mod.is_ctrl) {
            double dy = ev.y - last_pos_[1];
/+
            double zoombase = 10;
            if (mods & KMOD_SHIFT) zoombase /= 4.;
            zoom_ *= math.pow(zoombase, dy/win_height_);
+/            
            float value_y = drawer.radius * dy * 3.0 / win_height_;
            translation_ += Vec3f(0.0, 0.0, value_y);

        }
        // move in x,y direction
        else if ( s.button.is_middle ||
                  (s.button.is_left && s.mods == KMOD_ALT) )
        {
            double dy = ev.y - last_pos_[1];
            double dx = ev.x - last_pos_[0];

            GLdouble* mvm = drawer.modelview_matrix();
            Vec3f center = drawer.center();
            float z = - (mvm[ 2]*center[0] + mvm[ 6]*center[1] + mvm[10]*center[2] + mvm[14]) /
                (mvm[ 3]*center[0] + mvm[ 7]*center[1] + mvm[11]*center[2] + mvm[15]);

            float aspect     = win_width_ / cast(float)win_height_;
            float near_plane = 0.01 * drawer.radius;
            float top        = math.tan(drawer.fovy()/2.0f*math.PI/180.0f) * near_plane;
            float right      = aspect*top;


            translation_ += (Vec3f( 2.0*dx/win_width_*right/near_plane*z,
                                   -2.0*dy/win_height_*top/near_plane*z,
                                    0.0f));
        }

        // Rotate
        else if ( s.btn.is_left && s.mods == 0) {
            arcball_.updateDrag(ev.x,ev.y);
        }
        last_pos_[0] = ev.x;
        last_pos_[1] = ev.y;
    }


}
App g_app;

void draw() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    if (g_app) g_app.draw();

    SDL_GL_SwapBuffers();
}

void idle()
{
    debug
    {
        GLenum e;
        while ((e = glGetError()) != GL_NO_ERROR)
        {
            ubyte* str = gluErrorString(e);
            dout.writefln("!! GL ERROR! %s", strlib.toString(cast(char*)str)).flush;
        }
    }
}

/* new window size or exposure */
void reshape(int width, int height)
{
    GLfloat h = cast(GLfloat) height / cast(GLfloat) width;

    glViewport(0, 0, cast(GLint) width, cast(GLint) height);
    g_app.resize(width,height);
}

GLshader.ShaderProgram g_shader;

void init_display()
{
    if( GLshader.glslInit() ) {
        g_shader = new GLshader.ShaderProgram("default.vert","default.frag");
        g_shader.compile();
    }

    g_app.drawer.initializeGL();
    glEnable(GL_NORMALIZE);
    //glClearColor(0.33, 0.47, 0.42, 0); // blue-green
    //glClearColor(.84,.88,.95,0); // light sky blue
    glClearColor(102/255.,156/255.,194/255.,0); // Sky blue
}


int main_loop()
{
    SDL_Surface *screen = SDL_SetVideoMode(800, 600, 32, SDL_OPENGL|SDL_RESIZABLE);
    if ( ! screen ) {
        derr.writefln("Couldn't set GL video mode: %s\n", SDL_GetError()).flush;
        SDL_Quit();
        throw new VideoException(
            strlib.format("Couldn't set GL video mode: %s\n", SDL_GetError()));
    }

    if(g_app.current_file_) {
        string bname = std.path.getBaseName(g_app.current_file_);
        SDL_WM_SetCaption(c_str(bname~" - "~g_WindowBaseTitle), "GLViewer");
    } else {
        SDL_WM_SetCaption(c_str(g_WindowBaseTitle), "GLViewer");
    }

    SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);
    SDL_EnableUNICODE(1);

    init_display();

    reshape(screen.w, screen.h);
    int done = 0;
    while ( ! done ) {
        SDL_Event event;

        idle();
        while ( SDL_PollEvent(&event) ) {
            //if (adapter.dispatchEvent(event)) {
            //    continue;
            //}
            switch(event.type) {
            case SDL_VIDEORESIZE:
                dout.writefln("Vid resize").flush;
                //screen = SDL_SetVideoMode(event.resize.w, event.resize.h, 16,
                //                          SDL_OPENGL|SDL_RESIZABLE);
                screen.w = event.resize.w;
                screen.h = event.resize.h;
                if ( screen ) {
                    init_display();
                    reshape(screen.w, screen.h);
                } else {
                    /* Uh oh, we couldn't set the new video mode?? */;
                }
                break;

            case SDL_QUIT:
                done = 1;
                break;

            case SDL_KEYDOWN:
            {
                auto key = event.key.keysym.sym;
                if (key == SDLK_ESCAPE) {
                    done = 1;
                }
                else if (key == SDLK_s) {
                    g_app.drawer.enable_strips();
                }
                else if (key == SDLK_PAGEDOWN ||
                         (key == SDLK_w && !(SDL_GetModState() & KMOD_SHIFT))) {
                    g_app.drawer.next_draw_mode();
                    dout.writefln("DrawMode: ", g_app.drawer.get_draw_mode()).flush;
                }
                else if (key == SDLK_PAGEUP ||
                         (key == SDLK_w && (SDL_GetModState() & KMOD_SHIFT))) {
                    g_app.drawer.prev_draw_mode();
                    dout.writefln("DrawMode: ", g_app.drawer.get_draw_mode()).flush;
                }
                else if (key == SDLK_n) {
                    if (SDL_GetModState() & KMOD_SHIFT) {
                        g_app.drawer.show_fnormals =
                            !g_app.drawer.show_fnormals;
                    }
                    else {
                        g_app.drawer.show_vnormals =
                            !g_app.drawer.show_vnormals;
                    }
                }
                else if (key == SDLK_f) {
                    g_app.drawer.flip_normals();
                }
                else if (key == SDLK_p) {
                    string modestr = g_app.drawer.get_draw_mode();
                    bool shift = (SDL_GetModState() & KMOD_SHIFT)!=0;
                    if (modestr == "Face Property") { 
                        if (shift) {g_app.drawer.prev_face_property(); }
                        else {      g_app.drawer.next_face_property(); }
                        string pname = g_app.drawer.face_property_drawer.property_name;
                        TypeInfo ptype = g_app.drawer.face_property_drawer.typeinfo;
                        dout.writefln("Now showing face property: '%s' (%s)",pname,ptype).flush;
                    }
                    else if (modestr == "Vertex Property") { 
                        if (shift) { g_app.drawer.prev_vertex_property(); }
                        else       { g_app.drawer.next_vertex_property(); }
                        string pname = g_app.drawer.vertex_property_drawer.property_name;
                        TypeInfo ptype = g_app.drawer.vertex_property_drawer.typeinfo;
                        dout.writefln("Now showing vertex property: '%s' (%s)",pname,ptype).flush;
                    }
                }
                else if (key == SDLK_c) {
                    bool shift = (SDL_GetModState() & KMOD_SHIFT)!=0;                    
                    glMatrixMode(GL_COLOR);
                    double s = 1.1;
                    if (shift) {
                        s = 1.0/s;
                    } 
                    glScaled(s,s,s);
                    glMatrixMode(GL_MODELVIEW);
                }
                else if (key == SDLK_t) {
                    g_app.drawer.two_sided_lighting = !
                        g_app.drawer.two_sided_lighting;
                }
                else if (key == SDLK_g) {
                    bool shift = (SDL_GetModState() & KMOD_SHIFT)!=0;
                    if (shift) {
                        g_shader.deactivate();
                        g_shader.reload_source();
                        g_shader.compile();
                        g_shader.activate();
                    } else {
                        if (g_shader.active) {
                            g_shader.deactivate();
                        } else {
                            g_shader.activate();
                        }
                    }
                }
                else if (key == SDLK_PLUS ||
                         key == SDLK_EQUALS) {
                    g_app.zoom_by(1.1);
                }
                else if (key == SDLK_MINUS) {
                    g_app.zoom_by(1.0/1.1);
                }
            }
            break;


            case SDL_MOUSEBUTTONDOWN:
                if (event.button.button == SDL_BUTTON_WHEELDOWN)
                {
                    g_app.mouse_wheel(event.button);
                } 
                else if (event.button.button == SDL_BUTTON_WHEELUP) {
                    g_app.mouse_wheel(event.button);
                }
                else {
                    g_app.mouse_down(event.button);
                }
                break;
            case SDL_MOUSEMOTION:
                g_app.mouse_move(event.motion);
                break;
            case SDL_MOUSEBUTTONUP:
                g_app.mouse_up(event.button);
                break;

            default:
                // do nothing
                break;
            }
        }

        /+
        //if (!gui.get_focus()) 
        {
            Uint8 *keys = SDL_GetKeyState(null);
            if ( keys[SDLK_UP] ) {
                view_rotx += 5.0;
            }
            if ( keys[SDLK_DOWN] ) {
                view_rotx -= 5.0;
            }
            if ( keys[SDLK_LEFT] ) {
                view_roty += 5.0;
            }
            if ( keys[SDLK_RIGHT] ) {
                view_roty -= 5.0;
            }
            if ( keys[SDLK_z] ) {
                if ( SDL_GetModState() & KMOD_SHIFT ) {
                    view_rotz -= 5.0;
                } else {
                    view_rotz += 5.0;
                }
            }
        }
        +/
        draw();
    }
    return 0;
}



int main(string[] argv)
{
    g_app = new App(argv);
    return main_loop();
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
