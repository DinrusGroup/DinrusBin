/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

module gtkD.gtkglc.glgdktypes;


public import gtkD.gtkc.glibtypes;
public import gtkD.gtkc.gdktypes;
alias uint VisualID;

public enum GdkGLConfigMode
{
	MODE_RGB = 0,
	MODE_RGBA = 0, /+* same as RGB +/
	MODE_INDEX = 1 << 0,
	MODE_SINGLE = 0,
	MODE_DOUBLE = 1 << 1,
	MODE_STEREO = 1 << 2,
	MODE_ALPHA = 1 << 3,
	MODE_DEPTH = 1 << 4,
	MODE_STENCIL = 1 << 5,
	MODE_ACCUM = 1 << 6,
	MODE_MULTISAMPLE = 1 << 7 /+* not supported yet +/
}
alias GdkGLConfigMode GLConfigMode;

public enum GdkGLConfigAttrib
{
	USE_GL = 1, /+* support GLX rendering +/
	BUFFER_SIZE = 2, /+* depth of the color buffer +/
	LEVEL = 3, /+* level inn plane stacking +/
	RGBA = 4, /+* true if RGBA mode +/
	DOUBLEBUFFER = 5, /+* double buffering supported +/
	STEREO = 6, /+* stereo buffering supported +/
	AUX_BUFFERS = 7, /+* number of aux buffers +/
	RED_SIZE = 8, /+* number of red component bits +/
	GREEN_SIZE = 9, /+* number of green component bits +/
	BLUE_SIZE = 10, /+* number of blue component bits +/
	ALPHA_SIZE = 11, /+* number of alpha component bits +/
	DEPTH_SIZE = 12, /+* number of depth bits +/
	STENCIL_SIZE = 13, /+* number of stencil bits +/
	ACCUM_RED_SIZE = 14, /+* number of red accum bits +/
	ACCUM_GREEN_SIZE = 15, /+* number of green accum bits +/
	ACCUM_BLUE_SIZE = 16, /+* number of blue accum bits +/
	ACCUM_ALPHA_SIZE = 17, /+* number of alpha accum bits +/
	/+*
	 * FBConfig-specific attributes.
	 * [ GLX 1.3 and later ]
	+/
	CONFIG_CAVEAT = 0x20,
	X_VISUAL_TYPE = 0x22,
	TRANSPARENT_TYPE = 0x23,
	TRANSPARENT_INDEX_VALUE = 0x24,
	TRANSPARENT_RED_VALUE = 0x25,
	TRANSPARENT_GREEN_VALUE = 0x26,
	TRANSPARENT_BLUE_VALUE = 0x27,
	TRANSPARENT_ALPHA_VALUE = 0x28,
	DRAWABLE_TYPE = 0x8010,
	RENDER_TYPE = 0x8011,
	X_RENDERABLE = 0x8012,
	FBCONFIG_ID = 0x8013,
	MAX_PBUFFER_WIDTH = 0x8016,
	MAX_PBUFFER_HEIGHT = 0x8017,
	MAX_PBUFFER_PIXELS = 0x8018,
	VISUAL_ID = 0x800B,
	SCREEN = 0x800C,
	/+*
	 * Multisampling configuration attributes.
	 * [ GLX 1.4 and later ]
	+/
	SAMPLE_BUFFERS = 100000,
	SAMPLES = 100001
}
alias GdkGLConfigAttrib GLConfigAttrib;

public enum GdkGLConfigCaveat
{
	DONT_CARE = 0xFFFFFFFF, /+* GDK_GL_DONT_CARE +/
	NONE = 0x8000, /+* GDK_GL_NONE +/
	GDK_GL_SLOW_CONFIG = 0x8001,
	GDK_GL_NON_CONFORMANT_CONFIG = 0x800D
}
alias GdkGLConfigCaveat GLConfigCaveat;

public enum GdkGLVisualType
{
	TYPE_DONT_CARE = 0xFFFFFFFF, /+* GDK_GL_DONT_CARE +/
	GDK_GL_TRUE_COLOR = 0x8002,
	GDK_GL_DIRECT_COLOR = 0x8003,
	GDK_GL_PSEUDO_COLOR = 0x8004,
	GDK_GL_STATIC_COLOR = 0x8005,
	GDK_GL_GRAY_SCALE = 0x8006,
	GDK_GL_STATIC_GRAY = 0x8007
}
alias GdkGLVisualType GLVisualType;

public enum GdkGLTransparentType
{
	NONE = 0x8000, /+* GDK_GL_NONE +/
	RGB = 0x8008,
	INDEX = 0x8009
}
alias GdkGLTransparentType GLTransparentType;

public enum GdkGLDrawableTypeMask
{
	WINDOW_BIT = 1 << 0, /+* 0x00000001 +/
	PIXMAP_BIT = 1 << 1, /+* 0x00000002 +/
	PBUFFER_BIT = 1 << 2 /+* 0x00000004 +/
}
alias GdkGLDrawableTypeMask GLDrawableTypeMask;

public enum GdkGLRenderTypeMask
{
	RGBA_BIT = 1 << 0, /+* 0x00000001 +/
	COLOR_INDEX_BIT = 1 << 1 /+* 0x00000002 +/
}
alias GdkGLRenderTypeMask GLRenderTypeMask;

public enum GdkGLBufferMask
{
	FRONT_LEFT_BUFFER_BIT = 1 << 0, /+* 0x00000001 +/
	FRONT_RIGHT_BUFFER_BIT = 1 << 1, /+* 0x00000002 +/
	BACK_LEFT_BUFFER_BIT = 1 << 2, /+* 0x00000004 +/
	BACK_RIGHT_BUFFER_BIT = 1 << 3, /+* 0x00000008 +/
	AUX_BUFFERS_BIT = 1 << 4, /+* 0x00000010 +/
	DEPTH_BUFFER_BIT = 1 << 5, /+* 0x00000020 +/
	STENCIL_BUFFER_BIT = 1 << 6, /+* 0x00000040 +/
	ACCUM_BUFFER_BIT = 1 << 7 /+* 0x00000080 +/
}
alias GdkGLBufferMask GLBufferMask;

public enum GdkGLConfigError
{
	BAD_SCREEN = 1, /+* screen # is bad +/
	BAD_ATTRIBUTE = 2, /+* attribute to get is bad +/
	NO_EXTENSION = 3, /+* no glx extension on server +/
	BAD_VISUAL = 4, /+* visual # not known by GLX +/
	BAD_CONTEXT = 5, /+* returned only by importContext EXT? +/
	BAD_VALUE = 6, /+* returned only by glXSwapIntervalSGI? +/
	BAD_ENUM = 7 /+* unused? +/
}
alias GdkGLConfigError GLConfigError;

public enum GdkGLRenderType
{
	RGBA_TYPE = 0x8014,
	COLOR_INDEX_TYPE = 0x8015
}
alias GdkGLRenderType GLRenderType;

public enum GdkGLDrawableAttrib
{
	PRESERVED_CONTENTS = 0x801B,
	LARGEST_PBUFFER = 0x801C,
	WIDTH = 0x801D,
	HEIGHT = 0x801E,
	EVENT_MASK = 0x801F
}
alias GdkGLDrawableAttrib GLDrawableAttrib;

public enum GdkGLPbufferAttrib
{
	PRESERVED_CONTENTS = 0x801B, /+* GDK_GL_PRESERVED_CONTENTS +/
	LARGEST_PBUFFER = 0x801C, /+* GDK_GL_LARGEST_PBUFFER +/
	HEIGHT = 0x8040,
	WIDTH = 0x8041
}
alias GdkGLPbufferAttrib GLPbufferAttrib;

public enum GdkGLEventMask
{
	PBUFFER_CLOBBER_MASK = 1 << 27 /+* 0x08000000 +/
}
alias GdkGLEventMask GLEventMask;

public enum GdkGLEventType
{
	DAMAGED = 0x8020,
	SAVED = 0x8021
}
alias GdkGLEventType GLEventType;

/**
 * <<Geometric Object Rendering
 * X Window System Interaction>>
 */
public enum GdkGLDrawableType
{
	WINDOW = 0x8022,
	PBUFFER = 0x8023
}
alias GdkGLDrawableType GLDrawableType;


/**
 * Main Gtk struct.
 */
public struct GdkGLConfig{}


/**
 * Main Gtk struct.
 */
public struct GdkGLContext{}


/**
 * Main Gtk struct.
 */
public struct GdkGLDrawable{}


/**
 * Main Gtk struct.
 */
public struct GdkGLPixmap{}


/**
 * Main Gtk struct.
 */
public struct GdkGLWindow{}


/*
 * Returns the GdkGLDrawable held by the pixmap. In fact, this is macro
 * that casts the result of gdk_pixmap_get_gl_pixmap to GdkGLDrawable.
 * pixmap:
 * a GdkGLPixmap.
 * Returns:
 * the GdkGLDrawable.
 * <<Rendering Surface
 * OpenGL Window>>
 */
// TODO
// #define gdk_pixmap_get_gl_drawable(pixmap)

/*
 * Returns the GdkGLDrawable held by the window. In fact, this is macro
 * that casts the result of gdk_window_get_gl_window to GdkGLDrawable.
 * window:
 * a GdkGLWindow.
 * Returns:
 * the GdkGLDrawable.
 * <<OpenGL Pixmap
 * Font Rendering>>
 */
// TODO
// #define gdk_window_get_gl_drawable(window)

/*
 * major:
 * minor:
 * micro:
 */
// TODO
// #define GDKGLEXT_CHECK_VERSION(major, minor, micro)

/*
 */
// void (*GdkGLProc) (void);
public typedef extern(C) void  function () GdkGLProc;

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gtkglc");
        } else version (DigitalMars) {
            pragma(link, "DD-gtkglc");
        } else {
            pragma(link, "DO-gtkglc");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gtkglc");
        } else version (DigitalMars) {
            pragma(link, "DD-gtkglc");
        } else {
            pragma(link, "DO-gtkglc");
        }
    }
}
