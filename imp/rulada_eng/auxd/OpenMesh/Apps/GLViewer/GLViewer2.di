/*==========================================================================
 * GLViewer2.d - OpenGL Viewer with OpenMesh and DFL
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * DFL-based mesh viewer.
 *
 * This viewer is Windows-only as long as DFL remains Windows-only.
 * But it has much nicer features than the SDL version thanks to 
 * DFL's GUI-ness.
 *
 * For more information about obtaining and installing DFL see
 *  http://www.dprogramming.com/os.win.gui.php
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Date: 16 Nov 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 */
//===========================================================================

module GLViewer2;
version(Tango) import std.compat;

import os.win.gui.all;
import os.win.gui.x.winapi : LoadIconA,GetModuleHandleA;

import derelict.opengl.gl;
import derelict.opengl.glu;
import derelict.sdl.sdl;
import GLshader;

//import auxd.OpenMesh.Core.Mesh.api;
static import auxd.OpenMesh.Core.IO.Options;
alias auxd.OpenMesh.Core.IO.Options.Options  Options;
import auxd.OpenMesh.Core.Geometry.VectorTypes;
import auxd.OpenMesh.Core.Geometry.MatrixT;
import auxd.OpenMesh.Core.Utils.color_cast;
import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.IO.Streams;

import glcontrol;
import arcball;
import MeshTypes;
import DrawerTypes;
import MeshLoader;

pragma(lib, "OpenGl32.lib");
pragma(lib, "auxd.OpenMesh.lib");
pragma(lib, "auxD.lib");
pragma(lib, "DerelictGL.lib");
pragma(lib, "DerelictSDL.lib");
pragma(lib, "DerelictUtil.lib");
pragma(lib, "DerelictGLU.lib");

alias MyPolyMesh MeshT;
alias MeshPolyDrawer MeshDrawer;

import strlib = std.string;
alias strlib.toStringz c_str;
import math = std.math;
static import std.path;
static import std.file;

static string g_WindowBaseTitle = "OpenMesh/D OpenGL Viewer";
static string g_AppTitle = "OpenMesh/D Viewer";
// Hacks:
static StatusBar g_statusbar;
const char* g_IDI_ICON1 = cast(char*)101;

version(gui) {
    pragma(msg, "Compiling GUI Version");
    static this() {
        // redefine dout,derr,dlog to prevent IO exceptions
        version(Windows) {
            std.c.freopen("Nul", "w", dout.file);
            std.c.freopen("Nul", "w", derr.file);
        }
    }
}

static this()
{
    // load the SDL shared library
    DerelictGL.load();
    DerelictGLU.load();
}


class VideoException : Exception
{
    this(char[] msg) {
        super(msg);
    }
}

alias MatrixT!(GLdouble,4,4) mat4d;

class App
{
    MeshT mesh;
    MeshDrawer drawer;
    ArcBallController arcball_;
    Vec3f translation_;
    double zoom_ = 1.0;
    int win_width_ = 100;
    int win_height_ = 100;
    string current_file_;

    bool matrices_dirty_ = true;
    mat4d projection_;
    mat4d modelview_;
    int[4] viewport_;

    int pick_vertex = -1;
    int pick_face = -1;

    RegistryKey rkey;

    this() {
        rkey = Registry.currentUser.createSubKey("Software\\" ~ g_AppTitle);
        
        mesh = new MeshT;
        drawer = new MeshDrawer(mesh);
        arcball_ = new ArcBallController;
        translation_ = Vec3f(0,0,0);
        matrices_dirty_ = true;
    }

    

    void loadMesh(string fname) {
        IO_Options opt;
        MeshT _mesh;
        if (!MeshLoader.open_mesh!(MeshT)(_mesh, fname, opt)) {
            dlog.writefln("Read of model %s failed", fname).flush;
            current_file_ = null;
        } else {
            current_file_ = fname.dup;
            mesh = _mesh;
            drawer.set_mesh(_mesh);
            translation_ = Vec3f(0,0,0);
            drawer.setup_projection_matrix();
            drawer.view_all();
        }
        matrices_dirty_ = true;
    }

    void zoom_by(float factor) { 
        zoom_ *= factor;
        matrices_dirty_ = true;
    }
    void translate(float x, float y, float z) {
        translation_ += Vec3f(x,y,z);
        matrices_dirty_ = true;
    }

    void start_arcball_drag(int x, int y) {
        arcball_.startDrag(x,y);
    }
    void update_arcball_drag(int x, int y) {
        arcball_.updateDrag(x,y);
        matrices_dirty_ = true;
    }
    void end_arcball_drag() {
        arcball_.endDrag();
    }

    void draw()
    {
        //dlog.writefln("DRAW!").flush;

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
            if (matrices_dirty_) {
                glGetDoublev(GL_MODELVIEW_MATRIX, modelview_.ptr);
                glGetDoublev(GL_PROJECTION_MATRIX, projection_.ptr);
                glGetIntegerv(GL_VIEWPORT, viewport_.ptr);
                matrices_dirty_ = false;
            }
            drawer.drawGL();
            if (pick_vertex >= 0) {
                glPushAttrib(~0);
                Vec3f p = mesh.point(MeshT.VertexHandle(pick_vertex));
                glEnable(GL_COLOR_MATERIAL);
                glColor3ub(250, 100, 100);
                glPointSize(5);
                glDisable(GL_LIGHTING);
                glDisable(GL_TEXTURE_2D);
                glDisable(GL_DEPTH_TEST);
                glBegin(GL_POINTS); {
                    glVertex3fv(p.ptr);
                }
                glEnd();
                glPopAttrib();
                glPointSize(1);
            }
            glTranslatef(-translation_.x,-translation_.y,-translation_.z);
        }
        //arcball_.drawBall();
    }

    Vec3f unproject(int winx, int winy) 
    {
        GLdouble x,y,z;
        gluUnProject(winx, viewport_[3]-winy, 0.5, 
                     modelview_.ptr, projection_.ptr, viewport_.ptr,
                     &x,&y,&z);
        return Vec3f(x,y,z);
    }
    Vec3f project(double objx, double objy, double objz) 
    {
        GLdouble x,y,z;
        gluProject(objx, objy, objz, 
                   modelview_.ptr, projection_.ptr, viewport_.ptr,
                   &x,&y,&z);
        return Vec3f(x,viewport_[3]-y,z);
    }

    void resize(int w, int h) {
        dlog.writefln("Resize! [%s x %s]", w,h).flush;
        win_width_ = w;
        win_height_ = h;
        drawer.resizeGL(w,h);
        drawer.setup_projection_matrix();
        arcball_.resizeRegion(w,h);
        matrices_dirty_ = true;
    }
}
App g_app;
GLshader.ShaderProgram g_shader;


class RefreshTimer: Timer
{
    private GLControl glc;
    this (uint fps, GLControl glc)
    {
        this.glc = glc;
        this.interval = 1000/fps;
    }
    
    override void onTick (EventArgs ea)
    {
        glc.invalidate();
    }
}

enum PickMode {  None, Vertices, Faces }


class MyGLControl : GLControl
{
    protected int[2] last_pos_;
    protected PickMode pick_mode_;

    this() {
        setStyle(ControlStyles.SELECTABLE, true);
        tabStop = true;
    }

  public:
    void pick_mode(PickMode p) { 
        pick_mode_ = p;
    }
    PickMode pick_mode() { 
        return pick_mode_;
    }
    

  protected:
    override void onResize(EventArgs ea)
    {
        GLfloat h = cast(GLfloat) height / cast(GLfloat) width;

        glViewport(0, 0, cast(GLint) width, cast(GLint) height);
        if (g_app) g_app.resize(width,height);

        invalidate();
    }

    void load_mesh_file(string filename) {
        g_app.loadMesh(filename);
    }

    override void initGL() {

        if( GLshader.glslInit() ) {
            GLshader.shader_path_add([std.file.getcwd, Application.startupPath]);
            g_shader = new GLshader.ShaderProgram("default.vert","default.frag");
            g_shader.compile();
        }

        g_app.drawer.initializeGL();

        glEnable(GL_NORMALIZE);
        //glClearColor(0.33, 0.47, 0.42, 0); // blue-green
        //glClearColor(.84,.88,.95,0); // light sky blue
        //glClearColor(0.1,0.2,0.3,0.0); // dark blue
        glClearColor(102/255.,156/255.,194/255.,0); // Sky blue

    }

    override void render()
    {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        if (g_app) g_app.draw();
        swapBuffers();
        check_errors();
    }


    void check_errors()
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


    /+
      // doesn't get called 
    override void onMouseWheel(MouseEventArgs ev)
    {
        if (ev.delta > 0) {
            g_app.zoom_ *= 1.0/1.1;
        }
        else {
            g_app.zoom_ *= 1.1;
        }
    }+/
    override void onMouseMove(MouseEventArgs ev)
    {
        //if (ev.button==0) return;
        alias MouseButtons MB;
        auto drawer = g_app.drawer;

        auto mods = this.modifierKeys;
        // zoom-inout
        if (ev.button == MB.LEFT && mods == Keys.CONTROL) {
            double dy = ev.y - last_pos_[1];
            /+
             double zoombase = 10;
             if (mods & KMOD_SHIFT) zoombase /= 4.;
             zoom_ *= math.pow(zoombase, dy/win_height_);
             +/
            float value_y = drawer.radius * dy * 3.0 / this.height;
            g_app.translate(0, 0, value_y);

        }
        // move in x,y direction
        else if ( ev.button == MB.MIDDLE ||
                  (ev.button== MB.LEFT && mods == Keys.ALT) )
        {
            double dy = ev.y - last_pos_[1];
            double dx = ev.x - last_pos_[0];

            GLdouble* mvm = drawer.modelview_matrix();
            Vec3f center = drawer.center();
            float z = - (mvm[ 2]*center[0] + mvm[ 6]*center[1] + mvm[10]*center[2] + mvm[14]) /
                (mvm[ 3]*center[0] + mvm[ 7]*center[1] + mvm[11]*center[2] + mvm[15]);

            float aspect     = this.width / cast(float)this.height;
            float near_plane = 0.01 * drawer.radius;
            float top        = math.tan(drawer.fovy()/2.0f*math.PI/180.0f) * near_plane;
            float right      = aspect*top;

            g_app.translate(2.0*dx/this.width*right/near_plane*z,
                            -2.0*dy/this.height*top/near_plane*z,
                            0.0f);
        }
        // Rotate
        else if ( ev.button == MB.LEFT && mods == 0) {
            g_app.update_arcball_drag(ev.x,ev.y);
        }
        else if ( ev.button == MB.NONE) {
            // just hovering -- do pick
            if (pick_mode != PickMode.None) {
                float dmin = float.max;

                if (pick_mode == PickMode.Vertices) {
                    MeshT.VertexHandle vmin;
                    foreach(vh; g_app.mesh.vertices_begin) {
                        Vec3f p = g_app.mesh.point(vh);
                        Vec3f winp = g_app.project(p.x,p.y,p.z);
                        Vec2f dp = Vec2f(winp.x - ev.x, winp.y-ev.y);
                        float d = dp.norm;
                        if (d<dmin) {
                            vmin = vh;
                            dmin = d;
                        }
                    }
                    if (g_app.pick_vertex != vmin.idx) {
                        g_app.pick_vertex = vmin.idx;
                        //dout.writefln("Close vert = %s @ p = ", 
                        //               vmin, g_app.mesh.point(vmin)).flush;
                        update_quick_status();
                    }
                }
            }
            else {
                g_app.pick_vertex = -1;
            }
            
        }


        last_pos_[0] = ev.x;
        last_pos_[1] = ev.y;
    }
    override void onMouseDown(MouseEventArgs ev)
    {
        alias MouseButtons MB;
        auto mods = this.modifierKeys;
        if (mods == Keys.CONTROL) {
        }
        else if (ev.button == MB.LEFT) {
            g_app.start_arcball_drag(ev.x,ev.y);
        }
        last_pos_[0] = ev.x;
        last_pos_[1] = ev.y;
    }
    override void onMouseUp(MouseEventArgs ev)
    {
        alias MouseButtons MB;
        auto mods = this.modifierKeys;
        if (mods == Keys.CONTROL) {
        }
        else if (ev.button == MB.LEFT) {
            g_app.end_arcball_drag();
        }
        last_pos_[0] = ev.x;
        last_pos_[1] = ev.y;
    }
    string quick_status_string() {
        if (g_app.pick_vertex > 0) {
            return "vert: " ~ strlib.toString(g_app.pick_vertex);
        }
        else return "Ready";
    }
    string draw_mode_string() {
        string ret = g_app.drawer.get_draw_mode();
        if (ret == "Face Property") { 
            ret ~= ": " ~ g_app.drawer.face_property_drawer.property_name;
        }
        else if (ret == "Vertex Property") {
            ret ~= ": " ~ g_app.drawer.vertex_property_drawer.property_name;
        }
        if (g_shader && g_shader.active) {
            ret ~= " + shader";
        }
        return ret;
    }
    void update_quick_status() {
        string txt = quick_status_string();
        g_statusbar.panels[0].text = txt;
    }
    void update_draw_mode_status() {
        string txt = draw_mode_string();
        g_statusbar.panels[1].text = txt;
    }
    override void onKeyDown(KeyEventArgs ev)
    {
        //dlog.writefln("key down!").flush;
        bool handled = true;
        switch (ev.keyData) {
        case Keys.S: g_app.drawer.enable_strips(); break;

        case Keys.PAGE_DOWN:
        case Keys.W:
            g_app.drawer.next_draw_mode();
            dout.writefln("DrawMode: ", g_app.drawer.get_draw_mode()).flush;
            update_draw_mode_status();
            break;

        case Keys.PAGE_UP:
        case Keys.SHIFT+Keys.W:
            g_app.drawer.prev_draw_mode();
            dout.writefln("DrawMode: ", g_app.drawer.get_draw_mode()).flush;
            update_draw_mode_status();
            break;

        case Keys.SHIFT+Keys.N :
            g_app.drawer.show_fnormals = !g_app.drawer.show_fnormals;
            break;
        case Keys.N :
            g_app.drawer.show_vnormals = !g_app.drawer.show_vnormals;
            break;

        case Keys.F: g_app.drawer.flip_normals();
            break;

        case Keys.P: 
        case Keys.SHIFT+Keys.P: 
            string modestr = g_app.drawer.get_draw_mode();
            bool shift = ev.shift();
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
            update_draw_mode_status();
            break;

        case Keys.C : 
        case Keys.SHIFT+Keys.C : 
            bool shift = ev.shift();
            glMatrixMode(GL_COLOR);
            double s = 1.1;
            if (shift) {
                s = 1.0/s;
            } 
            glScaled(s,s,s);
            glMatrixMode(GL_MODELVIEW);
            break;

        case Keys.T :
            g_app.drawer.two_sided_lighting =
                !g_app.drawer.two_sided_lighting;
            break;

        case Keys.SHIFT+Keys.G :
            g_shader.deactivate();
            g_shader.reload_source();
            g_shader.compile();
            g_shader.activate();
            update_draw_mode_status();
            break;

        case Keys.G :
            if (g_shader.active) {
                g_shader.deactivate();
            } else {
                g_shader.activate();
            }
            update_draw_mode_status();
            break;

        case Keys.ADD:
            //case Keys.EQUALS:
            g_app.zoom_by(1.1);
            break;

        case Keys.SUBTRACT: 
            g_app.zoom_by(1.0/1.1);
            break;

        default:
            handled = false;
        }
        ev.handled = handled;

    }
    override void onKeyUp(KeyEventArgs ev)
    {
        //dlog.writefln("key up!").flush;
        super.onKeyUp(ev);
        ev.handled = true;//handled;
    }
    override void onKeyPress(KeyPressEventArgs ev)
    {
        //dlog.writefln("key press!").flush;
        super.onKeyPress(ev);
        ev.handled = true;//handled;
    }

}

class GLViewerForm: os.win.gui.form.Form
{
    // Do not modify or move this block of variables.
    //~Entice Designer variables begin here.
    MyGLControl glcontrol;
    os.win.gui.panel.Panel ctrlPanel;
    os.win.gui.button.Button exitButton;
    //~Entice Designer variables end here.
    
	StatusBar sbar;
    RefreshTimer idletimer;

	const char[] FILE_DIALOG_FILTER = 
        "3D Model (*.obj,*.ply,*.off,*.stl)|*.obj;*.ply;*.off;*.stl;*.stla,*.stlb"
        "|Wavefront OBJ (*.obj)|*.obj"
        "|PLY Models (*.ply)|*.ply"
        "|OFF Models (*.off)|*.off"
        "|STL Models (*.stl,*.stla,*.stlb)|*.stl;*.stla;*.stlb"
        "|All Files|*.*";
    
    this()
    {
		icon = new Icon(LoadIconA(GetModuleHandleA(null), g_IDI_ICON1));

        positionWindow_();
        createMenu_();
		createStatusbar_();
        initializeViewer();
        
        // Other opengltest initialization code here.
        idletimer = new RefreshTimer(120, glcontrol);
        idletimer.start();
        
        MyGLControl g = glcontrol;

		this.addShortcut(Keys.CONTROL + Keys.W, &shortcutClose);

        exitButton.click ~= &fileExit;
    }
    this(string start_file) {
        this();
        loadFile(start_file);
    }

    void shortcutClose(Object sender, FormShortcutEventArgs ev)
    {
        close();
    }

    void pick_mode(PickMode pmode) {
        glcontrol.pick_mode = pmode;
    }

    
    protected void positionWindow_()
    {
		RegistryValueDword regDword;
		RegistryValueSz regSz;
		
        RegistryKey rkey = g_app.rkey;

		// Set the window bounds. Try to load from registry.
		regDword = cast(RegistryValueDword)rkey.getValue("X");
		if(!regDword)
		{
			// Bounds not in registry, let Windows set it.
			startPosition = FormStartPosition.WINDOWS_DEFAULT_BOUNDS;
		}
		else
		{
            dlog.writefln("Restoring window postion").flush;
			startPosition = FormStartPosition.MANUAL;
			
			left = regDword.value;
			regDword = cast(RegistryValueDword)rkey.getValue("Y");
			if(regDword)
				top = regDword.value;
			regDword = cast(RegistryValueDword)rkey.getValue("DX");
			if(regDword && regDword.value >= width)
				width = regDword.value;
			regDword = cast(RegistryValueDword)rkey.getValue("DY");
			if(regDword && regDword.value >= height)
				height = regDword.value;
		}
    }

	protected override void onClosing(CancelEventArgs ea)
	{
        /+
		if(!canContinue)
		{
			ea.cancel = true;
		}
		else
        +/
		{
            save_prefs();
		}

	}
    protected void save_prefs() {
        // Closing now, so save settings...
			
        RegistryValueDword regDword;
        RegistryValueSz regSz;
        regDword = new RegistryValueDword;
        regSz = new RegistryValueSz;
			
        RegistryKey rkey = g_app.rkey;

        // Save window bounds to registry if not min/max.
        if(windowState == FormWindowState.NORMAL)
        {
            regDword.value = left;
            rkey.setValue("X", regDword);
            regDword.value = top;
            rkey.setValue("Y", regDword);
            regDword.value = width;
            rkey.setValue("DX", regDword);
            regDword.value = height;
            rkey.setValue("DY", regDword);
        }
			
        // Save some mode.
        //regDword.value = pad.wordWrap;
        //rkey.setValue("WWrap", regDword);
			
        // Save font info.
        /+
         Font fon;
         fon = pad.font;
         regSz.value = fon.name;
         rkey.setValue("fontname", regSz);
         regDword.value = cast(DWORD)fon.size;
         rkey.setValue("fontsize", regDword);
         regDword.value = fon.style;
         rkey.setValue("fontstyle", regDword);
         regDword.value = fon.gdiCharSet;
         rkey.setValue("fontscript", regDword);
         +/
    }


    protected override void onMouseWheel(MouseEventArgs ev)
    {
        if (ev.delta > 0) {
            g_app.zoom_ *= 1.0/1.1;
        }
        else {
            g_app.zoom_ *= 1.1;
        }
    }
/+
    override void onMouseMove(MouseEventArgs ev)
    {
        else if ( ev.button == MB.NONE) {
            // just hovering -- do pick
            if (pick_mode != PickMode.None) {
                dout.writefln("Mouse pos = %s,%s", ev.x, ev.y).flush;

                translate event & send to child


            }
        }
    }
+/
    protected override void onKeyDown(KeyEventArgs ev)
    {
        dlog.writefln("Form keydown! %s %s %s",
                      ev.keyCode, ev.keyData, ev.keyValue).flush;
    }

    protected void createMenu_()
    {
		MainMenu menubar;
		MenuItem file_menu, mi;
		
		menubar = new MainMenu;
		
		with(file_menu = new MenuItem)
		{
			text = "&File";
			index = 0;
			menubar.menuItems.add(file_menu);
		}
		
		with(mi = new MenuItem)
		{
			text = "&Open...\tCtrl+O";
			index = 1;
			click ~= &fileOpen;
			file_menu.menuItems.add(mi);
            this.addShortcut(Keys.CONTROL + Keys.O, &shortcutOpen);
		}
		
		with(mi = new MenuItem)
		{
			text = "Save &As...\tCtrl+S";
			index = 2;
			click ~= &fileSaveAs;
			file_menu.menuItems.add(mi);
		}
		
		with(mi = new MenuItem)
		{
			text = "-";
			index = 3;
			file_menu.menuItems.add(mi);
		}
		
		with(mi = new MenuItem)
		{
			text = "E&xit\tAlt+F4";
			index = 4;
			click ~= &fileExit;
			file_menu.menuItems.add(mi);
		}
		
        this.menu = menubar;

        createViewMenu_(menubar);

    }

    private void createViewMenu_(MainMenu mbar)
    {
        MenuItem view, pick, mi; 
        with(view = new MenuItem) {
            text = "&View";
            mbar.menuItems.add(view);
        }

        with(pick = new MenuItem) {
            text = "Pick";
            view.menuItems.add(pick);
        }

        with(mi = new MenuItem) {
            text = "None";
            pick.menuItems.add(mi);
            click ~= &menu_pick_mode_none;
        }
        with(mi = new MenuItem) {
            text = "Vertices";
            pick.menuItems.add(mi);
            click ~= &menu_pick_mode_vertices;
        }
        with(mi = new MenuItem) {
            text = "Faces";
            pick.menuItems.add(mi);
            click ~= &menu_pick_mode_faces;
        }
    }
    
    private void menu_pick_mode_none(Object,EventArgs) { pick_mode = PickMode.None; }
    private void menu_pick_mode_vertices(Object,EventArgs) { pick_mode = PickMode.Vertices; }
    private void menu_pick_mode_faces(Object,EventArgs) { pick_mode = PickMode.Faces; }


    private void delegate(Object,EventArgs) 
        adapt_handler(void delegate() fn) 
    {
        class ret {
            void delegate() fn_;
            this(void delegate() func) { fn_ = func; }
            void handler(Object, EventArgs) { fn_(); }
            ~this() { dout.writefln("Handler bye bye"); }
        }
        return &(new ret(fn)).handler;
    }

    private void createStatusbar_()
    {
		sbar = new StatusBar();
		sbar.name = "sbar";
		sbar.dock = os.win.gui.control.DockStyle.BOTTOM;
		sbar.bounds = os.win.gui.drawing.Rect(0, 250, 292, 23);
		sbar.parent = this;

		sbar.showPanels = true; // Show panels at first.
		sbar.panels.add(new StatusBarPanel("Ready"));
		sbar.panels.add(new StatusBarPanel("", 400));
		sbar.panels.add(new StatusBarPanel("", -1));

		autoScale = true;
        g_statusbar = sbar;
    }

    private void initializeViewer()
    {
        // Do not manually modify this function.
        //~Entice Designer 0.8.3 code begins here.
        //~DFL Form
        this.text = g_WindowBaseTitle;
        //clientSize = os.win.gui.all.Size(504, 365);
        //~DFL os.win.gui.panel.Panel=ctrlPanel
        ctrlPanel = new os.win.gui.panel.Panel();
        ctrlPanel.name = "ctrlPanel";
        ctrlPanel.dock = os.win.gui.all.DockStyle.LEFT;
        ctrlPanel.borderStyle = os.win.gui.all.BorderStyle.FIXED_SINGLE;
        ctrlPanel.bounds = os.win.gui.all.Rect(0, 0, 100, 365);
        //ctrlPanel.parent = this;
        //~DFL os.win.gui.button.Button=exitButton
        exitButton = new os.win.gui.button.Button();
        exitButton.name = "exitButton";
        exitButton.dock = os.win.gui.all.DockStyle.TOP;
        exitButton.text = "E&xit";
        //exitButton.bounds = os.win.gui.all.Rect(0, 0, 98, 23);
        exitButton.parent = ctrlPanel;

        //~DFL GlControl:os.win.gui.label.Label=glcontrol
        glcontrol = new MyGLControl();
        glcontrol.name = "glcontrol";
        glcontrol.dock = os.win.gui.all.DockStyle.FILL;
        //glcontrol.bounds = os.win.gui.all.Rect(100, 0, 404, 365);
        glcontrol.parent = this;
        //~Entice Designer 0.8.3 code ends here.

    }

    void fileExit(Object sender, EventArgs ea)
    {
        close();
        //save_prefs();
        //Application.exitThread();
    }

    void fileOpen(Object sender, EventArgs ea) { open_file();  }
    void shortcutOpen(Object sender, FormShortcutEventArgs ea) { open_file();  }
    
    void open_file() {
        OpenFileDialog ofd;
        ofd = new OpenFileDialog;
        ofd.filter = FILE_DIALOG_FILTER;
        ofd.defaultExt = "ply";
        if(DialogResult.OK == ofd.showDialog())
        {
            loadFile(ofd.fileName);
            //pad.modified = false;
            //setFileName(ofd.fileName);
        }
    }

    void fileSaveAs(Object sender, EventArgs ea)
    {
        dlog.writefln("Save file as ... [NOT IMPLEMENTED]").flush;
        msgBox("File->Save as... [NOT IMPLEMENTED]", "Save As...", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
    }

    void loadFile(string filename) {
        sbar.panels[0].text = "Loading...";
        dlog.writefln("Loading file %s...", filename).flush;
        glcontrol.load_mesh_file(filename);

        string bname = std.path.getBaseName(g_app.current_file_);
        this.text = bname~" - "~g_WindowBaseTitle;

		sbar.showPanels = false; // Shows text property instead of panels.

        sbar.panels[0].text = "Ready";
        sbar.panels[2].text = 
            std.string.format("%d verts, %d faces, %d edges", 
                              g_app.mesh.n_vertices(),
                              g_app.mesh.n_faces(),
                              g_app.mesh.n_edges());
        sbar.panels[1].text =
            g_app.drawer.get_draw_mode();
		sbar.showPanels = true; // Shows text property instead of panels.
    }

  protected:
}



int main(string[] argv)
{
    int result = 0;
    
    Application.enableVisualStyles();
    g_app = new App();

    //try
    {
        // Application initialization code here.
        
        GLViewerForm view;
        if (argv.length>1) {
            view = new GLViewerForm(argv[1]);
        }
        else {
            view = new GLViewerForm();
        }
        Application.run(view);
    }
/+
    catch(Object o)
    {
        msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
        
        result = 1;
    }
+/
    
    return result;
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
