module wx.GLCanvas;
public import wx.common;
public import wx.Window;
public import wx.Palette;

	//---------------------------------------------------------------------------
	// Constants for attriblist
	//---------------------------------------------------------------------------
	
	// The generic GL implementation doesn't support most of these options,
	// such as stereo, auxiliary buffers, alpha channel, and accum buffer.
	// Other implementations may actually support them.
	
	enum
	{
		WX_GL_RGBA=1,          /* use true color palette */
		WX_GL_BUFFER_SIZE,     /* bits for buffer if not WX_GL_RGBA */
		WX_GL_LEVEL,           /* 0 for main buffer, >0 for overlay, <0 for underlay */
		WX_GL_DOUBLEBUFFER,    /* use doublebuffer */
		WX_GL_STEREO,          /* use stereoscopic display */
		WX_GL_AUX_BUFFERS,     /* number of auxiliary buffers */
		WX_GL_MIN_RED,         /* use red buffer with most bits (> MIN_RED bits) */
		WX_GL_MIN_GREEN,       /* use green buffer with most bits (> MIN_GREEN bits) */
		WX_GL_MIN_BLUE,        /* use blue buffer with most bits (> MIN_BLUE bits) */
		WX_GL_MIN_ALPHA,       /* use blue buffer with most bits (> MIN_ALPHA bits) */
		WX_GL_DEPTH_SIZE,      /* bits for Z-buffer (0,16,32) */
		WX_GL_STENCIL_SIZE,    /* bits for stencil buffer */
		WX_GL_MIN_ACCUM_RED,   /* use red accum buffer with most bits (> MIN_ACCUM_RED bits) */
		WX_GL_MIN_ACCUM_GREEN, /* use green buffer with most bits (> MIN_ACCUM_GREEN bits) */
		WX_GL_MIN_ACCUM_BLUE,  /* use blue buffer with most bits (> MIN_ACCUM_BLUE bits) */
		WX_GL_MIN_ACCUM_ALPHA  /* use blue buffer with most bits (> MIN_ACCUM_ALPHA bits) */
	}

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) void wxGLContext_SetCurrent(IntPtr self, IntPtr canvas);
		static extern (C) void wxGLContext_Update(IntPtr self);
		static extern (C) void wxGLContext_SetColour(IntPtr self, string colour);
		static extern (C) void wxGLContext_SwapBuffers(IntPtr self);
		static extern (C) IntPtr wxGLContext_GetWindow(IntPtr self);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias GLContext wxGLContext;
	public class GLContext : wxObject
	{
		public this(IntPtr wxobj);
		public void SetCurrent(GLCanvas canvas = null);
		public void Update();
		public void SetColour(string colour);
		public void SwapBuffers();
		public Window window();
	}

		//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxGLCanvas_ctor(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name, int* attribList, inout Palette palette);
		static extern (C) IntPtr wxGLCanvas_ctor2(IntPtr parent, IntPtr shared_, int id, inout Point pos, inout Size size, uint style, string name, int* attribList, inout Palette palette);
		static extern (C) IntPtr wxGLCanvas_ctor3(IntPtr parent, IntPtr shared_, int id, inout Point pos, inout Size size, uint style, string name, int* attribList, inout Palette palette);

		static extern (C) void wxGLCanvas_SetCurrent(IntPtr self);
		static extern (C) void wxGLCanvas_UpdateContext(IntPtr self);
		static extern (C) void wxGLCanvas_SetColour(IntPtr self, string colour);
		static extern (C) void wxGLCanvas_SwapBuffers(IntPtr self);
		static extern (C) IntPtr wxGLCanvas_GetContext(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias GLCanvas wxGLCanvas;
	public class GLCanvas : Window
	{
		public static Palette wxNullPalette = null;
		const string wxGLCanvasStr = "GLCanvas";

		public this(Window parent, int id, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=0, string name=wxGLCanvasStr,int* attribList=null, Palette palette=wxNullPalette);
		public this(Window parent, GLContext shared_, int id, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=0, string name=wxGLCanvasStr,int* attribList=null, Palette palette=wxNullPalette);
		public this(Window parent, GLCanvas shared_, int id, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=0, string name=wxGLCanvasStr,int* attribList=null, Palette palette=wxNullPalette);
		public this(Window parent, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=0, string name=wxGLCanvasStr,int* attribList=null, Palette palette=wxNullPalette);
		public this(IntPtr wxobj) ;
		private this(IntPtr wxobj, bool memOwn);
		public void SetCurrent();
		public void UpdateContext();
		public void SetColour(string colour);
		public void SwapBuffers();
		public GLContext context();
	}
