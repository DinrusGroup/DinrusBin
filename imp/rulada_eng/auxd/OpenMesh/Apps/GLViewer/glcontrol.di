//============================================================================
// glcontrol.d - OpenGL Control
//   Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   An OpenGL rendering widget for DFL (http://wiki.dprogramming.com/Dfl)
 *
 * Version: 0.2
 * Contributors: Anders Bergh, Bill Baxter (OLM Digital, Inc), Julian Smart
 * License: Public Domain (or ZLIB/LIBPNG where Public Domain is not valid)
 */
//============================================================================

module glcontrol;

import os.win.gui.control, os.win.gui.event, os.win.gui.base;
import os.win.gui.x.winapi;

import derelict.opengl.gl;
//import derelict.opengl.glu;
import derelict.opengl.wgl;
import derelict.util.wintypes;

/** Enum values for the pixelFormatAttribList which can be 
 *  passed to the GLControl's constructor.
 */  
enum : int
{
    DFL_GL_RGBA=1,          /* use true color palette */
    DFL_GL_BUFFER_SIZE,     /* bits for buffer if not DFL_GL_RGBA */
    DFL_GL_LEVEL,           /* 0 for main buffer, >0 for overlay, <0 for underlay */
    DFL_GL_DOUBLEBUFFER,    /* use doublebuffer */
    DFL_GL_STEREO,          /* use stereoscopic display */
    DFL_GL_AUX_BUFFERS,     /* number of auxiliary buffers */
    DFL_GL_MIN_RED,         /* use red buffer with most bits (> MIN_RED bits) */
    DFL_GL_MIN_GREEN,       /* use green buffer with most bits (> MIN_GREEN bits) */
    DFL_GL_MIN_BLUE,        /* use blue buffer with most bits (> MIN_BLUE bits) */
    DFL_GL_MIN_ALPHA,       /* use alpha buffer with most bits (> MIN_ALPHA bits) */
    DFL_GL_DEPTH_SIZE,      /* bits for Z-buffer (0,16,32) */
    DFL_GL_STENCIL_SIZE,    /* bits for stencil buffer */
    DFL_GL_MIN_ACCUM_RED,   /* use red accum buffer with most bits (> MIN_ACCUM_RED bits) */
    DFL_GL_MIN_ACCUM_GREEN, /* use green buffer with most bits (> MIN_ACCUM_GREEN bits) */
    DFL_GL_MIN_ACCUM_BLUE,  /* use blue buffer with most bits (> MIN_ACCUM_BLUE bits) */
    DFL_GL_MIN_ACCUM_ALPHA  /* use alpha buffer with most bits (> MIN_ACCUM_ALPHA bits) */
}


class GLControl: Control
{
    GLContext _context;
    protected derelict.util.wintypes.HDC _hdc;
    protected int[] _pixel_attribs;
    
    /** Create a new GLControl 
     *  The optional argument pixelFormatAttribList allows one to customize the 
     *  type of GL visual that is requested.  Valid attribute names are drawn from
     *  DFL_GL_RGBA and related enum values.  Some enums take a 
     */
    this(int[] pixelFormatAttribList = null) { 
        if (pixelFormatAttribList) _pixel_attribs = pixelFormatAttribList.dup;
    }


    /** Create a new GLControl 
     *
     *  The arguemnt share_with specifies a GLContext with which to share display
     *  lists.  By default, display lists owned by one context are not visible
     *  to another.  By specifying a share_with the new context will share lists 
     *  with the other.
     *
     *  The optional argument pixelFormatAttribList allows one to customize the 
     *  type of GL visual that is requested.  Valid attribute names are drawn from
     *  DFL_GL_RGBA and related enum values.  Some enums take a parameter, in which
     *  case it is just provided inline along with the 
     */
    this(GLContext share_with, int[] pixelFormatAttribList = null) { 
        _context = share_with; 
        if (pixelFormatAttribList) _pixel_attribs = pixelFormatAttribList.dup;
    }

    override void onHandleCreated(EventArgs ea)
    {
        _hdc = cast(derelict.util.wintypes.HANDLE) (cast(void*)GetDC(handle));
        setupPixelFormat();

        createContext();
        makeCurrent();
        initGL();

        // Always call resize at the beginning because resizing is usually a 
        // part of init-ing and we don't want to do window-size related initializations
        // in two places.
        onResize(EventArgs.empty);

        invalidate();
        
        super.onHandleCreated(ea);
    }
    
    override void onHandleDestroyed(EventArgs ea)
    {
        wglMakeCurrent(_hdc, null);
        delete _context;
        
        ReleaseDC(cast(os.win.gui.x.winapi.HANDLE)handle, cast(os.win.gui.x.winapi.HDC)_hdc);
        
        super.onHandleDestroyed(ea);
    }
    
    protected void setupPixelFormat()
    {
        int n;
        
        os.win.gui.x.winapi.PIXELFORMATDESCRIPTOR pfd;
        
        pfd.nSize = pfd.sizeof;
        pfd.nVersion = 1;
        pfd.dwFlags = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER;
        pfd.iPixelType = PFD_TYPE_RGBA;
        pfd.cColorBits = 24;
        pfd.cAlphaBits = 8;
        pfd.cAccumBits = 0;
        pfd.cDepthBits = 32;
        pfd.cStencilBits = 8;
        pfd.cAuxBuffers = 0;
        pfd.iLayerType = PFD_MAIN_PLANE;
        
        updatePFDWithAttributes(pfd, _pixel_attribs);
        _pixel_attribs.length = 0;  // just to free up a little memory

        n = derelict.util.wintypes.ChoosePixelFormat(cast(derelict.util.wintypes.HANDLE) _hdc,
                                                     cast(derelict.util.wintypes.PIXELFORMATDESCRIPTOR*) &pfd);
        
        SetPixelFormat(cast(os.win.gui.x.winapi.HANDLE) _hdc, n, &pfd);
    }

    private static void updatePFDWithAttributes(
        ref os.win.gui.x.winapi.PIXELFORMATDESCRIPTOR pfd,
        int[] attrib_list)
    {
        if(!attrib_list) return;

        pfd.dwFlags &= ~PFD_DOUBLEBUFFER;
        pfd.iPixelType = PFD_TYPE_COLORINDEX;
        pfd.cColorBits = 0;
        int arg=0;

        while(  arg < attrib_list.length && attrib_list[arg]!=0 )
        {
            switch( attrib_list[arg++] )
            {
            case DFL_GL_RGBA:
                pfd.iPixelType = PFD_TYPE_RGBA;
                break;
            case DFL_GL_BUFFER_SIZE:
                pfd.cColorBits = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_LEVEL:
                // this member looks like it may be obsolete
                if(attrib_list[arg] > 0) {
                    pfd.iLayerType = cast(ubyte)PFD_OVERLAY_PLANE;
                } else if(attrib_list[arg] < 0) {
                    pfd.iLayerType = cast(ubyte)PFD_UNDERLAY_PLANE;
                } else {
                    pfd.iLayerType = cast(ubyte)PFD_MAIN_PLANE;
                }
                arg++;
                break;
            case DFL_GL_DOUBLEBUFFER:
                pfd.dwFlags |= PFD_DOUBLEBUFFER;
                break;
            case DFL_GL_STEREO:
                pfd.dwFlags |= PFD_STEREO;
                break;
            case DFL_GL_AUX_BUFFERS:
                pfd.cAuxBuffers = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_MIN_RED:
                pfd.cColorBits = cast(ubyte)(pfd.cColorBits + (pfd.cRedBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_GREEN:
                pfd.cColorBits = cast(ubyte)(pfd.cColorBits + (pfd.cGreenBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_BLUE:
                pfd.cColorBits = cast(ubyte)(pfd.cColorBits + (pfd.cBlueBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_ALPHA:
                // doesn't count in cColorBits
                pfd.cAlphaBits = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_DEPTH_SIZE:
                pfd.cDepthBits = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_STENCIL_SIZE:
                pfd.cStencilBits = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_MIN_ACCUM_RED:
                pfd.cAccumBits = cast(ubyte)(pfd.cAccumBits + (pfd.cAccumRedBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_ACCUM_GREEN:
                pfd.cAccumBits = cast(ubyte)(pfd.cAccumBits + (pfd.cAccumGreenBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_ACCUM_BLUE:
                pfd.cAccumBits = cast(ubyte)(pfd.cAccumBits + (pfd.cAccumBlueBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_ACCUM_ALPHA:
                pfd.cAccumBits = cast(ubyte)(pfd.cAccumBits + (pfd.cAccumAlphaBits = cast(ubyte)attrib_list[arg++]));
                break;
            default:
                break;
            }
        }
    }

    /** Override this method to set up default OpenGL state, such as 
     *  Unchanging glEnable flags used by your application.
     *  This is called as soon as the GLContext for this window is available.
     *  It is current by default, so there is no need to call makeCurrent() first.
     */
    protected void initGL()
    {
    }

    /** You may override the render() method instead of onPaint.
     *  The default onPaint ensures that the GL context is current 
     *  first then calls render().
     */
    protected void render()
    {
        /* copy paste */
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glLoadIdentity();
        
        glColor3f(0.1, 0.3, 2);
        glTranslatef(-1.5f, 0.0f, -6.0f);
        glBegin(GL_TRIANGLES);
        glVertex3f( 0.0f, 1.0f, 0.0f);      // Top
        glVertex3f(-1.0f,-1.0f, 0.0f);      // Bottom Left
        glVertex3f( 1.0f,-1.0f, 0.0f);      // Bottom Right
        glEnd();                            // Finished Drawing

        glTranslatef(3.0f,0.0f,0.0f);       // Move Right
        glBegin(GL_QUADS);                  // Draw A Quad
        glVertex3f(-1.0f, 1.0f, 0.0f);      // Top Left
        glVertex3f( 1.0f, 1.0f, 0.0f);      // Top Right
        glVertex3f( 1.0f,-1.0f, 0.0f);      // Bottom Right
        glVertex3f(-1.0f,-1.0f, 0.0f);      // Bottom Left
        glEnd();

        swapBuffers();
    }

    override void onResize(EventArgs ea)
    {
        glViewport(0, 0, bounds.width, bounds.height);
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity(); //reset projection matrix
        //gluPerspective(54.0f, cast(GLfloat) bounds.width / cast(GLfloat) bounds.height, 1.0f, 1000.0f);
        glMatrixMode(GL_MODELVIEW); //set modelview matrix
        glLoadIdentity(); //reset modelview matrix
    }

    override void onPaint(PaintEventArgs pea)
    {
        super.onPaint(pea);
        render();
    }
    
    override void onPaintBackground(PaintEventArgs pea)
    {
        // overridden to prevent flicker caused by background erasure
    }
    
    /** Call this method to swap front and back buffers */
    void swapBuffers()
    {
        SwapBuffers(_hdc);
    }

    void makeCurrent() 
    {
        _context.makeCurrent(this);
    }

    protected void createContext()
    {
        // If _context was previously set that means we're doing list sharing.
        _context = new GLContext(this,_context);
    }

}


class GLContext
{
    alias derelict.util.wintypes.HGLRC HGLRC;
    protected HGLRC _hrc;
    
    this(GLControl glctrl, GLContext share_with=null) {
        _hrc = cast(HGLRC)wglCreateContext(glctrl._hdc);
        if(share_with) {
            wglShareLists( share_with._hrc, _hrc );
        }
    }

    ~this() {
        wglDeleteContext(_hrc);
    }

    void makeCurrent(GLControl win) {
        if(!wglMakeCurrent(win._hdc, _hrc))
            throw new Exception("GLContext: wglMakeCurrent.");
    }
    
}


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
