/*
* The X11/MIT License
* 
* Copyright (c) 2008-2009, Jonas Kivi
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

module rae.ui.Window;

import tango.util.log.Trace;//Thread safe console output.

import Math = tango.math.Math;

import Float = tango.text.convert.Float;
import Utf = tango.text.convert.Utf;
import Integer = tango.text.convert.Integer;
import stringz = tango.stdc.stringz;

import tango.io.FilePath;

//import tango.core.Thread;
import tango.time.StopWatch;
import tango.util.container.LinkedList;

import rae.core.globals;
import rae.core.IRaeMain;
import Shz = rae.ui.InputState;
import rae.ui.EventType;
import Shrz = rae.ui.Widget;
import rae.canvas.ICanvasItem;
import rae.canvas.Rectangle;
import rae.canvas.IRootWindow;
import rae.canvas.Draw;
import rae.ui.SubWindow;
import rae.ui.Label;
//import rae.ui.Menu;


version(glfw)
{
	import rae.core.Idle;
	//public import gl.gl;
	//public import gl.glu;
	//public import gl.glext;

	import glfw.glfw;
}

version(sfml)
{
	import rae.core.Idle;
	
	import dsfml.system.all;
	import dsfml.window.all;
	import dsfml.graphics.all;

	//Just my own branch of sfml...
	//import dsfml.gl.gl;
	//import dsfml.gl.glu;
}

public import rae.gl.gl;
public import rae.gl.glu;
public import rae.gl.glext;
import rae.gl.util;

version(gtk)
{

import gtkD.gtk.VBox;
//import gtkglc.gl;
//import gtkglc.glu;
//import rae.canvas.util.GLExtensions;

import gtkD.glgdk.GLConfig;
import gtkD.glgdk.GLContext;
import gtkD.glgdk.GLDraw;
import gtkD.glgdk.GLDrawable;
import gtkD.gtkglc.glgdktypes;
//import gtkglc.glgtktypes;

import gtkD.glgtk.GLCapability;
import gtkD.glgtk.GLWidget;



import Gtk = gtkD.gtk.DrawingArea;
//import gtkD.gtk.Layout;
//import gtkD.gtk.Menu;
//import gtkD.gtk.MenuItem;
import gtkD.gtk.Widget;
//import gtkD.gtk.Button;
import gtkD.gtk.MainWindow;
//import Gdk = gdk.Window;
//import gdk.Event;
//import gdk.EventStruct;

import gtkD.gtk.Idle;
import gtkD.gtk.Timeout;

//import gdk.Font;
//import gdk.Drawable;
//import gdk.GC;

import gtkD.pango.PgContext;
}

version(gtk)
{

class GtkOpenGLCanvas : Gtk.DrawingArea
{
	//need to include the mixin to add GL capabilities to this widget
	mixin GLCapability;

	Window raeWindow;

protected:
	//Idle mainIdle;
	//int idleID;
	
	bool animate = false;//Possibly remove this?
	
public:
	GLfloat width;
	GLfloat height;
	
	this( Window set_rae_window )
	{
		debug(GtkOpenGLCanvas) Trace.formatln("GtkOpenGLCanvas.this() START.");
		debug(GtkOpenGLCanvas) scope(exit) Trace.formatln("GtkOpenGLCanvas.this() END.");
	
		raeWindow = set_rae_window;
	
		//this.testGL = testGL;
		//super(false,0);
		//super(null, null);
		
		
		//We'll try to get a 10bit OpenGL context:
		int[] glAtribList = [
			cast(int)GdkGLConfigAttrib.RGBA, 1,
			//cast(int)GdkGLConfigAttrib.MODE_DEPTH,
			cast(int)GdkGLConfigAttrib.DOUBLEBUFFER, 1,
			cast(int)GdkGLConfigAttrib.RED_SIZE, 10,
			cast(int)GdkGLConfigAttrib.GREEN_SIZE, 10,
			cast(int)GdkGLConfigAttrib.BLUE_SIZE, 10,
			0 //GDK_GL_ATTRIB_LIST_NONE ? which isn't bound in gtkDgl.
		];
		
		GLConfig glConfig;
		
		try
		{
			glConfig = new GLConfig(
				glAtribList			
			/*GLConfigMode.MODE_RGB
			| GLConfigMode.MODE_DEPTH
			| GLConfigMode.MODE_DOUBLE,
			GLConfigMode.MODE_RGB
			| GLConfigMode.MODE_DEPTH
			*/
			);
		}
		catch(Exception ex)
		{
			Trace.formatln("Unable to create 10bit OpenGL context.");
			//We can leave glConfig to be null...
		}
		
			
		
		setGLCapability(glConfig);	// set the GL capabilities for this widget
		//setGLCapability(GLConfig glConfig = null, int renderType = GLRenderType.RGBA_TYPE)
	
		//setSizeRequest(800,400);		
		addOnRealize(&realizeCallback);						// dispatcher.addRealizeListener(this,da);
		addOnMap(&mapCallback);								// dispatcher.addMapListener(this,da);
		addOnExpose(&exposeCallback);						// dispatcher.addExposeListener(this,da);
		//addOnConfigure(&configureCallback);					// dispatcher.addConfigureListener(this,da);
		addOnVisibilityNotify(&visibilityCallback);			// dispatcher.addVisibilityListener(this,da);
		//dispatcher.addButtonClickedListener(this,da);
		addOnButtonPress(&mouseButtonPressCallback);		// dispatcher.addMouseButtonListener(this,da);
		addOnButtonRelease(&mouseButtonReleaseCallback);	// dispatcher.addMouseMotionListener(this,da);
		
		addOnScroll(&scrollCallback);
			
		//addOnKeyPress(&onKeyPress);	
			
		//da.addOnVisibilityNotify(&visibilityCallback);
			
		addOnMotionNotify(&motionNotifyCallback);
			
		//menu = createPopupMenu();
	}
	
	bool initGL()
	{
		debug(GtkOpenGLCanvas) Trace.formatln("GtkOpenGLCanvas.initGL() START.");
		debug(GtkOpenGLCanvas) scope(exit) Trace.formatln("GtkOpenGLCanvas.initGL() END.");
		raeWindow.initGL();	
		return true;
	}
	
	bool drawGL(GdkEventExpose* event = null)
	{
		debug(GtkOpenGLCanvas) Trace.formatln("GtkOpenGLCanvas.drawGL() START.");
		debug(GtkOpenGLCanvas) scope(exit) Trace.formatln("GtkOpenGLCanvas.drawGL() END.");
		raeWindow.render();
		return true;
	}
	
	bool resizeGL(GdkEventConfigure* e)
	{
		debug(GtkOpenGLCanvas) Trace.formatln("GtkOpenGLCanvas.resizeGL() START.");
		debug(GtkOpenGLCanvas) scope(exit) Trace.formatln("GtkOpenGLCanvas.resizeGL() END.");
		GLfloat wP = 0.0f;
		GLfloat hP = 0.0f;
		
		if ( e == null )
		{
			wP = getWidth();
			hP = getHeight();
		}
		else
		{
			wP = e.width;
			hP = e.height;
		}
		
		raeWindow.resize(wP, hP);
		return true;
	}
	
	void sendRenderMessage()
	{
		glDrawFrame();
	}
	
	void addRenderIdle()
	{
		raeWindow.addRenderIdle();
	}
	
	void removeRenderIdle()
	{
		raeWindow.removeRenderIdle();
	}
	
	bool visibilityCallback(GdkEventVisibility* e, Widget widget)
	{
		debug(GtkOpenGLCanvas) Trace.formatln("GtkOpenGLCanvas.visibilityCallback() START.");
		debug(GtkOpenGLCanvas) scope(exit) Trace.formatln("GtkOpenGLCanvas.visibilityCallback() END.");
		if (animate)
		{
			if (e.state == VisibilityState.FULLY_OBSCURED)
			{
				removeRenderIdle();
			}
			else
			{
				addRenderIdle();
			}
		}
		
		return true;
	}

	
	bool exposeCallback(GdkEventExpose* e, Widget widget)
	{
		debug(GtkOpenGLCanvas) Trace.formatln("GtkOpenGLCanvas.exposeCallback() START.");
		debug(GtkOpenGLCanvas) scope(exit) Trace.formatln("GtkOpenGLCanvas.exposeCallback() END.");
		glDrawFrame(widget);
		return true;
	}
	
	bool noExposeCallback(Widget widget){ return false; }
	
	
	

	void mapCallback(Widget drawable)
	{
		//if (animate)
		//{
			addRenderIdle();
		//}
	}

	void unmapCallback(Widget drawable)
	{
		removeRenderIdle();
	}

//	void buttonClickedCallback(Button button, String action)
//	{
//	}

	void realizeCallback(Widget widget)
	{
		debug(GtkOpenGLCanvas) Trace.formatln("GtkOpenGLCanvas.realizeCallback() START.");
		debug(GtkOpenGLCanvas) scope(exit) Trace.formatln("GtkOpenGLCanvas.realizeCallback() END.");
	
		GLContext context = GLWidget.getGLContext(widget);
		GLDrawable drawable = GLWidget.getGLDrawable(widget);
		
		/*** OpenGL BEGIN ***/
		if (!drawable.glBegin(context) )
		{
			return ;
		}
		
		//glClearColor(0.5, 0.5, 0.8, 1.0);
		//glClearColor( 0.1f, 0.2f, 0.1f, 1.0f );
		//glClearColor( 0.0f, 0.0f, 0.0f, 0.0f );
		//glClearDepth(1.0);
			
		GLExtensions.checkGLExtensions();
		
		initGL();
		resizeGL(null);
		

		//initVideoGL();
		
		toggleAnimation();
		addRenderIdle();
		
		drawable.glEnd();
		/*** OpenGL END ***/
		
		return;
	}

	bool unrealizeCallback(Widget widget){return false;}

	


	static float begin_x = 0.0f;
	static float begin_y = 0.0f;
	
	static float dx = 0.0f;
	static float dy = 0.0f;

	/*
	float temp_mouse_x = 0.0f;
	float temp_mouse_y = 0.0f;
	void updateTempMousePosition( float set_x, float set_y )
	{
		temp_mouse_x = set_x;
		temp_mouse_y = set_y;
	}
	*/
	
	bool mouseButtonPressCallback(GdkEventButton*event, Widget widget)
	{
		
		//updateTempMousePosition( raeWindow.p2hco_x(event.x), raeWindow.p2hco_x(event.x) );
		
		g_rae.mouseEvent
		(
			raeWindow,
			Shz.SEventType.MOUSE_BUTTON_PRESS,
			event.button,
			raeWindow.p2hco_x(event.x),
			raeWindow.p2hco_y(event.y)
			//event.x - (raeWindow.wP*0.5f),
			//event.y - (raeWindow.hP*0.5f)
		);
	
		/*if (event.button == 1)
		{
			
		
			//if (animate)
			//{
				//toggleAnimation();
			//}
		}*/
		
		//begin_x = event.x;
		//begin_y = event.y;
		
		return false;
	}
	
	bool mouseButtonReleaseCallback(GdkEventButton*event, Widget widget)
	{
		//g_rae.mouseEvent( EventType.MOUSE_BUTTON_RELEASE, event.button, event.x, event.y );
	
		//updateTempMousePosition( raeWindow.p2hco_x(event.x), raeWindow.p2hco_x(event.x) );
	
		g_rae.mouseEvent
		(
			raeWindow,
			Shz.SEventType.MOUSE_BUTTON_RELEASE,
			event.button,
			raeWindow.p2hco_x(event.x),
			raeWindow.p2hco_y(event.y)
			//event.x - (raeWindow.wP*0.5f),
			//event.y - (raeWindow.hP*0.5f)
		);
	
		/*if (event.button == 1)
		{
			//if (!animate && ((dx*dx + dy*dy) > ANIMATE_THRESHOLD))
			//{
			//	toggleAnimation();
			//}
		}
		else if (event.button == 3)
		{
			// Popup menu.
			//menu.popup(null,null,null,null,event.button, event.time);
			return true;
		}
		
		dx = 0.0;
		dy = 0.0;
		*/
		return false;
	}

	bool motionNotifyCallback(GdkEventMotion* event, Widget widget)
	{
		//updateTempMousePosition( raeWindow.p2hco_x(event.x), raeWindow.p2hco_x(event.x) );
	
		
		//debug:
		//Trace.formatln("event.x: {}", event.x );
		//Trace.formatln("event.y: {}", event.y );
		/*
		Trace.formatln("screenWidthP/2: {}", (raeWindow.wP*0.5f) );
		Trace.formatln("finalx: {}", event.x - (raeWindow.wP*0.5f) );
		Trace.formatln("finaly: {}", event.y - (raeWindow.hP*0.5f) );
		*/
		
	
		//g_rae.mouseEvent( EventType.MOUSE_MOTION, 0, event.x, event.y );
		g_rae.mouseEvent
		(
			raeWindow,
			Shz.SEventType.MOUSE_MOTION,
			0,//event.button,
			raeWindow.p2hco_x(event.x),
			raeWindow.p2hco_y(event.y)
			//event.x - (raeWindow.wP*0.5f),
			//event.y - (raeWindow.hP*0.5f)
		);
		
		/*
		float wP = width;
		float hP = height;
		float x = event.x;
		float y = event.y;
		gboolean redraw = false;
		
		// Rotation.
		if (event.state == ModifierType.BUTTON1_MASK )
		{
				dx = x - begin_x;
				dy = y - begin_y;
			
			redraw = true;
		}
		
		// Scaling.
		if (event.state == ModifierType.BUTTON2_MASK )
		{
			redraw = true;
		}
		
		begin_x = x;
		begin_y = y;
		
		if (redraw && !animate)
		{
			queueDraw();
		}
		*/
		return true;
	}

	bool scrollCallback( GdkEventScroll* event, Widget widget )
	{
		debug(Window) Trace.formatln("GtkOpenGLCanvas.scrollCallback() START.");
		debug(Window) scope(exit) Trace.formatln("GtkOpenGLCanvas.scrollCallback() END.");
		
		Shz.SEventType event_type;
		
		if( event.direction == GdkScrollDirection.UP )
			event_type = Shz.SEventType.SCROLL_UP;
		else if( event.direction == GdkScrollDirection.DOWN )
			event_type = Shz.SEventType.SCROLL_DOWN;
		
		debug(Window) Trace.formatln("GtkOpenGLCanvas.scrollCallback() Going to send mouseEvent.");
		
		
		
		g_rae.mouseEvent
		(
			raeWindow,
			event_type,
			0,//event.button,
			raeWindow.p2hco_x(event.x),
			raeWindow.p2hco_y(event.y)
			//temp_mouse_x,
			//temp_mouse_y
			//event.x - (raeWindow.wP*0.5f),
			//event.y - (raeWindow.hP*0.5f)
		);
		
		/*
		switch( event.direction )
		{
			default:
			break;
			case GdkScrollDirection.UP:
				if( event.state & GdkModifierType.SHIFT_MASK )
				{
					zoomX = zoomX + zoomAdder;
				}
				else
				{
					zoomOnMouse( zoomAdder );
				}
			break;
			case GdkScrollDirection.DOWN:
				if( event.state & GdkModifierType.SHIFT_MASK )
				{
					zoomX = zoomX - zoomAdder;
				}
				else
				{
					zoom = zoom - zoomAdder;
				}
			break;
		}
		*/

		return true;
	}

//static gboolean
//key_press_event (GtkWidget   *widget,
//		 GdkEventKey *event,
//		 gpointer     data)
//{
//  switch (event.keyval)
//    {
//    case GDK_Escape:
//      gtk_main_quit ();
//      break;
//
//    default:
//      return false;
//    }
//
//  return true;
//}


	
	
	
	/* Toggle animation.*/
	void toggleAnimation()
	{
		animate = !animate;

		if (animate)
		{
			addRenderIdle();
		}
		else
		{
			removeRenderIdle();
			queueDraw();
		}

	}

//	static void
//	change_shape (GtkMenuItem  *menuitem, GLuint *shape)
//	{
//	  shape_current = *shape;
//	  init_view();
//	}
//
//	static void
//	change_material (GtkMenuItem  *menuitem,
//					 MaterialProp *mat)
//	{
//	  mat_current = mat;
//	}

//	/* For popup menu. */
//	static gboolean
//	button_press_event_popup_menu (GtkWidget      *widget,
//					   GdkEventButton *event,
//					   gpointer        data)
//	{
//	  if (event.button == 3)
//		{
//		  /* Popup menu. */
//		  gtk_menu_popup (GTK_MENU (widget), NULL, NULL, NULL, NULL,
//				  event.button, event.time);
//		  return true;
//		}
//	
//	  return false;
//	}
//

//	void activateCallback(MenuItem menuItem, char[] action)
//	{
//	}
/*	void activateItemCallback(MenuItem menuItem)
	{
		char[] action = menuItem.getActionName();
		version(Rulada)
		{
			Trace.formatln("activateItemCallback action = %s {}", action);
		}
		else //version(Phobos)
		{
    	printf("activateItemCallback action = %.*s \n", action);
    }
		
	//
	//	switch(action)
	//	{
	//		default: break;
	//	}
	//
    	//init_view();
	}
	*/
}



class GtkWindow : MainWindow
{
	
	Window raeWindow;
	GtkOpenGLCanvas openGLCanvas;

	this( char[] set_name, Window set_rae_window )
	{
		debug(Window) Trace.formatln("GtkWindow.this() START.");
		debug(Window) scope(exit) Trace.formatln("GtkWindow.this() END.");
	
		raeWindow = set_rae_window;
	
		super(set_name);
		
		setReallocateRedraws(true);
		
		
		//setBorderWidth(10);
		//setSizeRequest(800,400);
		//resize( 800, 400 );
		
		
		openGLCanvas = new GtkOpenGLCanvas(raeWindow);
		
		debug(Window) Trace.formatln("GtkWindow.this() Adding GtkOpenGLCanvas to GtkWindow.");
		
		add( openGLCanvas );
		
		debug(Window) Trace.formatln("GtkWindow.this() Trying to show GtkOpenGLCanvas.");
		
		openGLCanvas.show();
		
		addOnKeyPress(&onKeyPress);
		addOnKeyRelease(&onKeyRelease);
		
		debug(Window) Trace.formatln("GtkWindow.this() Trying to show GtkWindow.");
		
		show();
	}
	
	bool onKeyPress( GdkEventKey* event, Widget widget)
	{
		if(event !is null)
		{
			//raeWindow.onKeyPress(event.keyval);
			g_rae.keyEvent
			(
			 raeWindow,
			 Shz.SEventType.KEY_PRESS,
			 event.keyval
			 );
		}
		return true;
	}
	
	bool onKeyRelease( GdkEventKey* event, Widget widget)
	{
		if(event !is null)
		{
			//raeWindow.onKeyPress(event.keyval);
			g_rae.keyEvent
			(
			 raeWindow,
			 Shz.SEventType.KEY_RELEASE,
			 event.keyval
			 );
		}
		return true;
	}
	
	///Don't use this. It's too slow!
	/*
	void invalidate()
	{
		gdk.Window.Window win = getWindow();
		if( win !is null )
		{
			//Trace.formatln("GdkWindow.invalidateRect()...");
			
			//The null parameter for the Gdk.Rectangle
			//will ask for a redraw of the whole
			//window.
			//The true parameter will ask to invalidate
			//the children... in this case that's
			//our openGLCanvas.
			win.invalidateRect( null, true );
		}
	}
	*/
}

}//version(gtk)

version(glfw)
{

version (Win32)
{
extern (Windows):
}
else
{
extern (C):

void reshape( int set_w, int set_h )
{
	debug(Window) Trace.formatln("GLFW.reshape() START.");
	debug(Window) scope(exit) Trace.formatln("GLFW.reshape() END.");
	
	if( g_rae.mainWindow !is null )
	{
		g_rae.mainWindow.resize(cast(float)set_w, cast(float)set_h);
	}
	else
	{
		debug(Window) Trace.formatln("GLFW.reshape() g_rae.mainWindow not available. Trying to reshape by ourselves.");
		
		debug(Window) Trace.formatln("set_w: {} set_h: {}", set_w, set_h);
		
		uint wP = set_w;
		uint hP = set_h;
		
		//GLsizei sx = 0;
		//GLsizei sy = 0;
		//GLsizei sw = cast(GLsizei)wP;
		//GLsizei sh = cast(GLsizei)hP;
		GLsizei sx = -cast(GLsizei)(g_rae.screenWidthP-wP)/2;
		GLsizei sy = -cast(GLsizei)(g_rae.screenHeightP-hP)/2;
		GLsizei sw = cast(GLsizei)g_rae.screenWidthP;
		GLsizei sh = cast(GLsizei)g_rae.screenHeightP;
	
		debug(Window)
		{
			Trace.formatln("screenY: {}", sx );
			Trace.formatln("screenX: {}", sy );
			Trace.formatln("screenWidthP: {}", sw );
			Trace.formatln("screenHeightP: {}", sh );
		}
		
		//assert(0);
	
		if( sh == 0 )
			sh = 1;
			
		/*
		if( height != view_height || width != view_width )
		{		
			sh = cast(uint)((cast(float)width / viewAspect) * pixelAspectWidth);	
			sy = (height - sh) / 2;
			
			//debug(output) Trace.formatln("pixelaspect: ")(pixelAspectWidth);
			debug(output) Trace.formatln("sx: ")(sx)(" sy: ")(sy)(" sw: ")(sw)(" sh: ")(sh);
		}
		*/
		
		//float ratio	= wP / hP;
		float ratio	= cast(GLfloat)sw / cast(GLfloat)sh;
		 
		//glViewport( g_rae.screenWidthP/2, g_rae.screenHeightP/2, g_rae.screenWidthP/2, g_rae.screenHeightP/2 );
		glViewport( sx, sy, sw, sh );
		//glViewport( 0, 0, cast(int)set_w, cast(int)set_h );
		//Trace.formatln("width:")(width);
		//Trace.formatln("height:")(height);
		//glViewport( 0, 0, cast(int)width, cast(int)height );
		glMatrixMode( GL_PROJECTION );
		glLoadIdentity();
		//gluPerspective( 40.0f, ratio, 0.0f, 200.0f );
		
		//The number 53.1f is just the number that works so that pixels don't
		//get distorted. We don't want to do glOrtho as we want to have a pseudo
		//3D world. And we want objects to lie on z = 0. That's why we do a
		//glTranslatef(0, 0 ,-1.0f) and go a bit backwards with our "camera".
		//I've manually checked the 53.1f with a checkerboard pattern in a
		//texture and it seems to not produce any artifacts. Any advice on how
		//we'd better achieve what we want would be great.
		
		gluPerspective(53.1f, ratio, 1.0f, 200.0f);//The one that works!
		//gluPerspective(g_rae.tempparam1, ratio, 0.0f, 200.0f);
		glMatrixMode( GL_MODELVIEW );
		glLoadIdentity();
	
	}
	/*glViewport( 0, 0, cast(GLsizei)w, cast(GLsizei)h );
	
	glMatrixMode( GL_PROJECTION );
	glLoadIdentity();
	
	gluPerspective( 60.0f,
								 cast(GLfloat)w / cast(GLfloat)h,
								 1.0f,
								 200.0f );
	
	glMatrixMode( GL_MODELVIEW );
	glLoadIdentity();
	
	gluLookAt( 0.0, 0.0, 10.0f,//VIEW_SCENE_DIST,// eye
						0.0, 0.0, 0.0,            // center of vision
						0.0, -1.0, 0.0 );         // up vector
	*/
	
}

void windowrefreshcallback()
{
	//Trace.formatln("windowrefreshcallback." );
	//g_rae.render();
}

int windowclosedcallback()
{
	g_rae.quit();
	return true;//true closes window.
}

void mouseposfun( int mousex, int mousey )
{
	//Trace.formatln("Motion notify mousex: {} mousey: {}", Integer.toString(mousex), Integer.toString(mousey) );
	
	
	if( g_rae.mainWindow !is null )
	{
	g_rae.mouseEvent
	(
	 g_rae.mainWindow,//raeWindow,
	 Shz.SEventType.MOUSE_MOTION,
	 0,//event.button,
	 g_rae.mainWindow.p2hco_x(mousex),
	 g_rae.mainWindow.p2hco_y(mousey)
	 );
	}
	 
}

void mousefun( int button, int action )
{
	int mousex = 0;
	int mousey = 0;
	
	glfwGetMousePos( &mousex, &mousey );
	
	//Trace.formatln("Button mousex: {} mousey: {}", Integer.toString(mousex), Integer.toString(mousey) );
	
	switch( action )
	{
		case GLFW_PRESS:
			if( g_rae.mainWindow !is null )
			{
			g_rae.mouseEvent
			(
			 g_rae.mainWindow,//raeWindow,
			 Shz.SEventType.MOUSE_BUTTON_PRESS,
			 button+1,//Yes. GLFW starts it's buttons from 0, and Rae from 1.
			 g_rae.mainWindow.p2hco_x(mousex),
			 g_rae.mainWindow.p2hco_y(mousey)
			 );
			}
			switch( button )
		{
			case GLFW_MOUSE_BUTTON_LEFT:
				//Trace.formatln( "Pressed left mouse button. {}", button );
				break;
			case GLFW_MOUSE_BUTTON_MIDDLE:
				//Trace.formatln( "Pressed middle mouse button. {}", button );
				break;
			case GLFW_MOUSE_BUTTON_RIGHT:
				//Trace.formatln( "Pressed right mouse button. {}", button );
				break;
		}
			break;
		case GLFW_RELEASE:
			if( g_rae.mainWindow !is null )
			{
			g_rae.mouseEvent
			(
			 g_rae.mainWindow,//raeWindow,
			 Shz.SEventType.MOUSE_BUTTON_RELEASE,
			 button+1,
			 g_rae.mainWindow.p2hco_x(mousex),
			 g_rae.mainWindow.p2hco_y(mousey)
			 );
			}
			switch( button )
		{
			case GLFW_MOUSE_BUTTON_LEFT:
				//Trace.formatln( "Released left mouse button." );
				break;
			case GLFW_MOUSE_BUTTON_MIDDLE:
				//Trace.formatln( "Released middle mouse button." );
				break;
			case GLFW_MOUSE_BUTTON_RIGHT:
				//Trace.formatln( "Released right mouse button." );
				break;
		}
			break;
	}
}

void mousewheelfun( int pos )
{
		debug(Window) Trace.formatln("Window.scrollCallback() START.");
		debug(Window) scope(exit) Trace.formatln("Window.scrollCallback() END.");
		
		static int mempos = 0;
		
		static Shz.SEventType event_type;
		
		int mousex = 0;
		int mousey = 0;
		glfwGetMousePos( &mousex, &mousey );
		
		if( pos > mempos )
			event_type = Shz.SEventType.SCROLL_UP;
		else if( pos < mempos )
			event_type = Shz.SEventType.SCROLL_DOWN;
		//Otherwise event_type will be what it used to be,
		//because it's static. But that's not always correct.
		//The other option would be to not send the event when
		//the pos reported by GLFW stays the same, but that
		//would give a feeling of less response.
		//Now it will give the feeling of wrong response
		//if somebody's doing very small scrolls up and down.
		//But usually that's not the case.
		
		debug(Window)
		{
			Trace.format("mousewheelfun: pos: {}", pos );
			if( event_type == Shz.SEventType.SCROLL_UP )
				Trace.formatln("SCROLL_UP.");
			else if( event_type == Shz.SEventType.SCROLL_DOWN )
				Trace.formatln("SCROLL_DOWN.");
		}
		
		debug(Window) Trace.formatln("GtkOpenGLCanvas.scrollCallback() Going to send mouseEvent.");
		
		
		if( g_rae.mainWindow !is null )
		{
		g_rae.mouseEvent
		(
			g_rae.mainWindow,//raeWindow,
			event_type,
			(pos - mempos),//event.button is reused in the scroll events as the relative amount of scroll.
			g_rae.mainWindow.p2hco_x(mousex),
			g_rae.mainWindow.p2hco_y(mousey)
			//temp_mouse_x,
			//temp_mouse_y
			//event.x - (raeWindow.wP*0.5f),
			//event.y - (raeWindow.hP*0.5f)
		);
		}
	
		mempos = pos;

	//Trace.formatln("Motion notify mousex: {} mousey: {}", Integer.toString(mousex), Integer.toString(mousey) );
	/*
	if( g_rae.mainWindow !is null )
	{
	g_rae.mouseEvent
	(
	 g_rae.mainWindow,//raeWindow,
	 Shz.SEventType.MOUSE_MOTION,
	 0,//event.button,
	 g_rae.mainWindow.p2hco_x(mousex),
	 g_rae.mainWindow.p2hco_y(mousey)
	 );
	}
	*/
	 
}


void keyfun( int key, int action )
{
	int keysym = 0;

	switch( key )
	{
		default:
			//Ignore others not listed here.
		return;
		case GLFW_KEY_ESC:
			keysym = KeySym.Escape;
		break;
		case GLFW_KEY_F1: keysym = KeySym.F1; break;
		case GLFW_KEY_F2: keysym = KeySym.F2; break;
		case GLFW_KEY_F3: keysym = KeySym.F3; break;
		case GLFW_KEY_F4: keysym = KeySym.F4; break;
		case GLFW_KEY_F5: keysym = KeySym.F5; break;
		case GLFW_KEY_F6: keysym = KeySym.F6; break;
		case GLFW_KEY_F7: keysym = KeySym.F7; break;
		case GLFW_KEY_F8: keysym = KeySym.F8; break;
		case GLFW_KEY_F9: keysym = KeySym.F9; break;
		case GLFW_KEY_F10: keysym = KeySym.F10; break;
		case GLFW_KEY_F11: keysym = KeySym.F11; break;
		case GLFW_KEY_F12: keysym = KeySym.F12; break;
		case GLFW_KEY_F13: keysym = KeySym.F13; break;
		case GLFW_KEY_F14: keysym = KeySym.F14; break;
		case GLFW_KEY_F15: keysym = KeySym.F15; break;
		case GLFW_KEY_F16: keysym = KeySym.F16; break;
		case GLFW_KEY_F17: keysym = KeySym.F17; break;
		case GLFW_KEY_F18: keysym = KeySym.F18; break;
		case GLFW_KEY_F19: keysym = KeySym.F19; break;
		case GLFW_KEY_F20: keysym = KeySym.F20; break;
		case GLFW_KEY_F21: keysym = KeySym.F21; break;
		case GLFW_KEY_F22: keysym = KeySym.F22; break;
		case GLFW_KEY_F23: keysym = KeySym.F23; break;
		case GLFW_KEY_F24: keysym = KeySym.F24; break;
		case GLFW_KEY_F25: keysym = KeySym.F25; break;
		case GLFW_KEY_UP: keysym = KeySym.Up; break;
		case GLFW_KEY_DOWN: keysym = KeySym.Down; break;
		case GLFW_KEY_LEFT: keysym = KeySym.Left; break;
		case GLFW_KEY_RIGHT: keysym = KeySym.Right; break;
		case GLFW_KEY_TAB: keysym = KeySym.Tab; break;
    case GLFW_KEY_ENTER: keysym = KeySym.Return; break;//? not sure.
    case GLFW_KEY_BACKSPACE: keysym = KeySym.BackSpace; break;
    case GLFW_KEY_INSERT: keysym = KeySym.Insert; break;
    case GLFW_KEY_DEL: keysym = KeySym.Delete; break;
    case GLFW_KEY_PAGEUP: keysym = KeySym.Page_Up; break;
    case GLFW_KEY_PAGEDOWN: keysym = KeySym.Page_Down; break;
    case GLFW_KEY_HOME: keysym = KeySym.Home; break;
    case GLFW_KEY_END: keysym = KeySym.End; break;
    case GLFW_KEY_KP_ENTER: keysym = KeySym.KP_Enter; break;
    //case GLFW_KEY_SPACE: keysym = KeySym.KP_Space; break;
	}

	switch(action)
	{
		default:
		case GLFW_PRESS:
			debug(keyboard) Trace.formatln("Keypress: {}", key);
			if( g_rae.mainWindow !is null )
			{
				g_rae.keyEvent
				(
					g_rae.mainWindow,//raeWindow,
					Shz.SEventType.KEY_PRESS,
					keysym
				);
			}
		break;
		case GLFW_RELEASE:
			debug(keyboard) Trace.formatln("Keyrelease: {}", key);
			if( g_rae.mainWindow !is null )
			{
				g_rae.keyEvent
				(
			 		g_rae.mainWindow,//raeWindow,
			 		Shz.SEventType.KEY_RELEASE,
			 		keysym
			 	);
			}
		break;
	}
	
	return;
	
	/+
	
    case GLFW_KEY_LSHIFT:
			Trace.formatln( "LSHIFT" );
			break;
    case GLFW_KEY_RSHIFT:
			Trace.formatln( "RSHIFT" );
			break;
    case GLFW_KEY_LCTRL:
			Trace.formatln( "LCTRL" );
			break;
    case GLFW_KEY_RCTRL:
			Trace.formatln( "RCTRL" );
			break;
    case GLFW_KEY_LALT:
			Trace.formatln( "LALT" );
			break;
    case GLFW_KEY_RALT:
			Trace.formatln( "RALT" );
			break;
    
    
    case GLFW_KEY_KP_0:
			Trace.formatln( "KEYPAD 0" );
			break;
    case GLFW_KEY_KP_1:
			Trace.formatln( "KEYPAD 1" );
			break;
    case GLFW_KEY_KP_2:
			Trace.formatln( "KEYPAD 2" );
			break;
    case GLFW_KEY_KP_3:
			Trace.formatln( "KEYPAD 3" );
			break;
    case GLFW_KEY_KP_4:
			Trace.formatln( "KEYPAD 4" );
			break;
    case GLFW_KEY_KP_5:
			Trace.formatln( "KEYPAD 5" );
			break;
    case GLFW_KEY_KP_6:
			Trace.formatln( "KEYPAD 6" );
			break;
    case GLFW_KEY_KP_7:
			Trace.formatln( "KEYPAD 7" );
			break;
    case GLFW_KEY_KP_8:
			Trace.formatln( "KEYPAD 8" );
			break;
    case GLFW_KEY_KP_9:
			Trace.formatln( "KEYPAD 9" );
			break;
    case GLFW_KEY_KP_DIVIDE:
			Trace.formatln( "KEYPAD DIVIDE" );
			break;
    case GLFW_KEY_KP_MULTIPLY:
			Trace.formatln( "KEYPAD MULTIPLY" );
			break;
    case GLFW_KEY_KP_SUBTRACT:
			Trace.formatln( "KEYPAD SUBTRACT" );
			break;
    case GLFW_KEY_KP_ADD:
			Trace.formatln( "KEYPAD ADD" );
			break;
    case GLFW_KEY_KP_DECIMAL:
			Trace.formatln( "KEYPAD DECIMAL" );
			break;
    case GLFW_KEY_KP_EQUAL:
			Trace.formatln( "KEYPAD =" );
			break;
    
    case 'R':
			/*keyrepeat = (keyrepeat+1) & 1;
			if( keyrepeat )
			{
				glfwEnable( GLFW_KEY_REPEAT );
			}
			else
			{
				glfwDisable( GLFW_KEY_REPEAT );
			}
			Trace.formatln( "R => Key repeat: {}", keyrepeat ? "ON" : "OFF" );
			 */
			break;
    case 'S':
			/*
			systemkeys = (systemkeys+1) & 1;
			if( systemkeys )
			{
				glfwEnable( GLFW_SYSTEM_KEYS );
			}
			else
			{
				glfwDisable( GLFW_SYSTEM_KEYS );
			}
			Trace.formatln( "S => System keys: {}", systemkeys ? "ON" : "OFF" );
			*/
			break;
    default:
			if( key > 0 && key < 256 )
			{
				Trace.formatln( "Key pressed: {}", cast(char) key );
			}
			else
			{
				Trace.formatln( "Some unknown key was pressed ???" );
			}
			break;
	}
	+/
}


void unicodekeyfun( int unicodekey, int action )
{
	switch(action)
	{
		default:
		case GLFW_PRESS:
			debug(keyboard) Trace.formatln("Unicodekeypress: {} dchar: {}", unicodekey, cast(dchar)unicodekey);
			if( g_rae.mainWindow !is null )
			{
			g_rae.keyEvent
			(
			 g_rae.mainWindow,//raeWindow,
			 Shz.SEventType.KEY_PRESS,
			 unicodekey//KeySym.space//InputState.convertKeyFromNative(key)
			 );
			}
		break;
		case GLFW_RELEASE:
			debug(keyboard) Trace.formatln("Unicodekeyrelease: {} dchar: {}", unicodekey, cast(dchar)unicodekey);
			if( g_rae.mainWindow !is null )
			{
			g_rae.keyEvent
			(
			 g_rae.mainWindow,//raeWindow,
			 Shz.SEventType.KEY_RELEASE,
			 unicodekey//KeySym.space//InputState.convertKeyFromNative(key)
			 );
			}
		break;
	}
	return;
}
}

extern(D):

}//version(glfw)

class Window : public Shrz.Widget, public IRootWindow
{
	//dchar[] name = "";
	this(dchar[] set_name )
	{
		debug(Window) Trace.formatln("Window.this() START.");
		debug(Window) scope(exit) Trace.formatln("Window.this() END.");
	
		//name = set_name;
		//HACK: Set width and height to 1.0 to override
		//an exception that currently occurs when
		//Rectangle sets a minWidth.
		//UPDATE: I just removed the exception for now. Now it just
		//does nothing when w() is called in a Window. Much better.
		_w = 1.0f;
		_h = 1.0f;
	
		//NOT TRUE AT THE MOMENT:
		//Toplevel Windows are hidden by default
		//other widgets are shown by default.
		//isHidden = true;
	
		draw = new Draw();
	
		version(gtk)
		{
			gtkWindow = new GtkWindow(Utf.toString(set_name), this );
		}

		version(sfml)
		{
			if( g_rae.isFullScreen == true )
			{
				sfmlWindow = new RenderWindow(VideoMode(1280, 800, 32), Utf.toString(set_name), Style.FULLSCREEN );
			}
			else 
			{
				sfmlWindow = new RenderWindow(VideoMode(640, 480, 32), Utf.toString(set_name) );
			}
			
			initGL();
		}

		version(glfw)
		{
			debug(Window) Trace.formatln("Going to create a GLFW window of the size: {} x {}", g_rae.screenWidthP, g_rae.screenHeightP );
		
			
			if( g_rae.isFullScreen == true )
			{
				/*if( !glfwOpenWindow( 1280,800, 0,0,0,0, 16,0, GLFW_FULLSCREEN ) )
				{
					Trace.formatln("Unable to create GLFW window.");
					glfwTerminate();
					return;
				}*/
				wP = g_rae.screenWidthP;
				hP = g_rae.screenHeightP;
				
				createGLFWWindow(g_rae.screenWidthP, g_rae.screenHeightP, true );
				initGL();
				reshape( cast(int)g_rae.screenWidthP, cast(int)g_rae.screenHeightP );
				resize( cast(float)g_rae.screenWidthP, cast(float)g_rae.screenHeightP );
				glfwSetWindowSize(g_rae.screenWidthP, g_rae.screenHeightP);
			}
			else
			{
				createGLFWWindow( g_rae.screenWidthP-20, g_rae.screenHeightP-100, false );
				initGL();
				resize( g_rae.screenWidthP-20.0f, g_rae.screenHeightP-100.0f );
			}
			
			glfwEnable( GLFW_KEY_REPEAT );
			glfwEnable( GLFW_SYSTEM_KEYS );
		}
	
		debug(Window) Trace.formatln("Before Window.super().");
		
		super();
		type = "Window"d;
		name = set_name;
		m_arrangeType = ArrangeType.LAYER;
		
		//super(set_name, WindowHeaderType.NORMAL, WindowHeaderType.NORMAL, true, false );//isfrontside=true, use_fbo_clipping=false
		//super(set_name, WindowHeaderType.NONE, WindowHeaderType.NONE, true, false );//isfrontside=true, use_fbo_clipping=false
		plainWindow = new PlainWindow(set_name, WindowButtonType.NONE, WindowHeaderType.NONE, WindowHeaderType.NONE, true, false );//isfrontside=true, use_fbo_clipping=false
		plainWindow.isClipping = false;
		//plainWindow = new PlainWindow(set_name, WindowHeaderType.SMALL, WindowHeaderType.SMALL, true, false );//isfrontside=true, use_fbo_clipping=false
		plainWindow.controlWidget = this;
		addFloating(plainWindow);
		plainWindow.shadowType = rae.canvas.PlainRectangle.ShadowType.NONE;//Remove the shadow from here as it isn't even shown.
	
		if(g_rae !is null)
			g_rae.registerWindow(this);

		if( g_rae.isFullScreen == true )
		{
			fullscreen();
		}
		
		fpsLabel = new Label("FPS");

		debug(Window) Trace.formatln("After Window.super().");
	}
	
	version(glfw)
	{
		void createGLFWWindow(uint set_w, uint set_h, bool set_fullscreen )
		{
			int to_full_or_not = GLFW_WINDOW;
			if( set_fullscreen == true )
				to_full_or_not = GLFW_FULLSCREEN;
			if( !glfwOpenWindow( set_w, set_h, 0,0,0,0, 16,0, to_full_or_not ) )
			{
				Trace.formatln("Unable to create GLFW window.");
				glfwTerminate();
				return;
			}
			//}

			//Set the window title so that it isn't GLFW Window.
			glfwSetWindowTitle( stringz.toStringz(g_rae.applicationName) );

			glfwDisable(GLFW_AUTO_POLL_EVENTS);

			glfwSetWindowRefreshCallback( &windowrefreshcallback );
			glfwSetWindowCloseCallback( &windowclosedcallback );
			glfwSetWindowSizeCallback( &reshape );
			glfwSetKeyCallback( &keyfun );
			glfwSetCharCallback( &unicodekeyfun );
			//glfwEnable( GLFW_STICKY_KEYS );
			glfwSetMouseButtonCallback( &mousefun );
			glfwSetMousePosCallback( &mouseposfun );
			glfwSetMouseWheelCallback( &mousewheelfun );
			glfwSwapInterval( 1 );
			glfwEnable(GLFW_MOUSE_CURSOR);
		}
	}
	
	void minimize()
	{
		version(gtk)
		{
		//GTK is TODO on minimize.
			Trace.formatln("Window.minimize() is TODO on GTK backend of Rae. Sorry.");
		}
		
		version(glfw)
		{
			glfwIconifyWindow();
		}
	}

	dchar[] name(){ return super.name(); }
	void name( dchar[] set_name )
	{
		super.name(set_name);
		version(gtk)
		{
			if( gtkWindow !is null )
				gtkWindow.setTitle( Utf.toString(set_name) );
		}
		version(glfw)
		{
			glfwSetWindowTitle( stringz.toStringz( Utf.toString(set_name) ) );
		}
		version(sfml)
		{
			Trace.formatln("Window.name() is undefined when using the SFML backend.");
		}
		//return m_name;
	}
	
	override void colour( float sr, float sg, float sb, float sa )
	{
		super.colour( sr, sg, sb, sa );
		glClearColor( sr, sg, sb, sa );
	}
	
	///Return false if it fails to set the icon from that file.
	bool setIconFromFile(char[] filename)
	{
		version(gtk)
		{
			try
			{
				gtkWindow.setIconFromFile(filename);
			}
			catch( Exception ex )
			{
				version(Windows)
				{
					//On windows .svg files seem to be unsupported,
					//so we'll make this hack to test for a .png
					//file with the same name then.
					//If even that doesn't work, then we return
					//false as it failed.
					FilePath fpath = new FilePath(filename);
					if( fpath.suffix == ".svg" )
						fpath.suffix = ".png";
					
					try
					{
						gtkWindow.setIconFromFile(fpath.toString);
					}
					catch( Exception ex )
					{
						//now it really failed.
						return false;
					}
				}
				else //version Unix:
				{
					return false;//propably failed.
				}
			}
			return true;
		}
		else //other versions are yet undefined.
		{
			return false;
		}
	}
	
	//This shows how stupid it is to have a plainWindow
	//as the backend for a Window.
	public float zoom()
	{
		if( plainWindow !is null ) return plainWindow.zoom();
		return m_zoomY;
	}
	public void zoom(float set)
	{
		if( plainWindow !is null ) plainWindow.zoom( set );
		//return 1.0f;
	}
	public float zoomX()
	{
		if( plainWindow !is null ) return plainWindow.zoomX();
		return m_zoomX;
	}
	public void zoomX(float set)
	{
		if( plainWindow !is null ) plainWindow.zoomX( set );
		//return 1.0f;
	}
	public void zoomXN(float set)
	{
		if( plainWindow !is null ) plainWindow.zoomXN( set );
		//return 1.0f;
	}
	public float zoomY()
	{
		if( plainWindow !is null ) return plainWindow.zoomY();
		return m_zoomY;
	}
	public void zoomY(float set)
	{
		if( plainWindow !is null ) plainWindow.zoomY( set );
		//return 1.0f;
	}
	public void zoomYN(float set)
	{
		if( plainWindow !is null ) plainWindow.zoomYN( set );
		//return 1.0f;
	}
	
	PlainWindow plainWindow;
	
	/*
	
	REMOVE: we got the pangoContext fixed from Cairo...
	that's in Draw.
	
	PgContext pangoContext;
	
	public PgContext getPangoContext()
	{
		//PgContext pgcon = 
		if(pangoContext is null)
			pangoContext = gtkWindow.getPangoContext();
			
		return pangoContext;
	}*/
	
	//Rendering thread thing:
	
	//REVIEW: This renderIdleCallback thing is kind of wierd,
	//and there could be a better way to do this.
	//But this is what I came up with after fiddling with
	//it for a couple of days.
	//The idea is that the ICanvasItems call invalidate()
	//and that calls Window's invalidate() which calls
	//addRenderIdle. That then keeps a count of the
	//calls it gets with invalidateCountPlus().
	//It can't be more than 100 and always => 0.
	//First time the idle is added. It calls
	//renderIdleCallback(). That then looks at the
	//amount of invalidateCount. If it's over zero
	//it will return true to keep the Idle running,
	//and it will also do an invalidateCountMinus()
	//and render the opengl window.
	//When the invalidateCount reaches 0 and
	//renderIdleCallback is called again, the
	//opengl window will get rendered once more,
	//and then it will return false. That will tell
	//the Idle to stop, and destroy atleast the gtk C
	//idle. Propably the D object will get destroyed
	//by the GC later, when the new Idle is created.
	
	//Suggestions for a better system are welcome.
	//But atleast for now, this one works and
	//accomplishes the idea of not rendering if
	//nothing is happening. The old system just
	//rendered as fast as it could, leading to
	//100% CPU usage for Rae apps. Now we only
	//get near 100% CPU when invalidate() is called
	//continuously, e.g. while playing a video.
	
	
	protected uint invalidateCountPlus()
	{
		if( m_invalidateCount < 100 )
			return m_invalidateCount++;
		return m_invalidateCount;
	}
	protected uint invalidateCountMinus()
	{
		if( m_invalidateCount > 0 )
			return m_invalidateCount--;
		return m_invalidateCount;
	}
	protected uint invalidateCount() { return m_invalidateCount; }
	protected uint m_invalidateCount = 0;
	
	bool shouldremoveRenderIdle = false;

	version(gtk)
	{
		bool renderIdleCallback()
		{
			debug(invalidateidle) Trace.formatln("Window.renderIdleCallback() START.");
			debug(invalidateidle) scope(exit) Trace.formatln("Window.renderIdleCallback() END.");
			//g_rae.callIdles();
			
			//removeRenderIdle();
			
			if( invalidateCount > 0 )
			{
				invalidateCountMinus();
				//glDrawFrame(this);
				//render();
				
				gtkWindow.openGLCanvas.sendRenderMessage();
				
			}
			else
			{
				//glDrawFrame(this);
				//render();
				
				gtkWindow.openGLCanvas.sendRenderMessage();
				
				shouldremoveRenderIdle = true;
				//REVIEW: 
				//This is the last time we draw, so
				//the timer must be stopped, for
				//animations to work that count on the
				//frameTime to be accurate.
				//When the idle stops, we might not draw
				//for e.g. 5 seconds, and the next time
				//we draw, out frameTime will be 5 seconds
				//so animations get finished really quickly
				//because they then think that that's how
				//fast they should run.
				
				//raeWindow.timer.stop();
				//raeWindow.
				timerNotValid = true;
				
				return false;
			}
			
			return true;
		}
	}
	
	version(glfw)
	{
		bool renderIdleCallback()
		{
			debug(invalidateidle) Trace.formatln("Window.renderIdleCallback() START.");
			debug(invalidateidle) scope(exit) Trace.formatln("Window.renderIdleCallback() END.");
			//g_rae.callIdles();
			
			//removeRenderIdle();
			
			if( invalidateCount > 0 )
			{
				debug(invalidateidle) Trace.formatln("Window.renderIdleCallback() invalidateCount: {}", invalidateCount() );
				invalidateCountMinus();
				
				g_rae.render();
				
			}
			else
			{
				debug(invalidateidle) Trace.formatln("Window.renderIdleCallback() Going to remove idle.");
			
				g_rae.render();
				
				//assert(0);
				
				shouldremoveRenderIdle = true;
				//REVIEW: 
				//This is the last time we draw, so
				//the timer must be stopped, for
				//animations to work that count on the
				//frameTime to be accurate.
				//When the idle stops, we might not draw
				//for e.g. 5 seconds, and the next time
				//we draw, out frameTime will be 5 seconds
				//so animations get finished really quickly
				//because they then think that that's how
				//fast they should run.
				
				//raeWindow.timer.stop();
				//raeWindow.
				timerNotValid = true;
				
				return false;
			}
			return true;
		}
	}
	
	
	void addRenderIdle()
	{
		debug(invalidateidle) Trace.formatln("Window.addRenderIdle() START.");
		debug(invalidateidle) scope(exit) Trace.formatln("Window.addRenderIdle() END.");
	
		invalidateCountPlus();
	
		if( shouldremoveRenderIdle == true )
			removeRenderIdle();
			
		version(gtk)
		{
			if ( mainIdle is null )
			{
				shouldremoveRenderIdle = false;
				
				mainIdle = new Idle(&renderIdleCallback);	
			}
		}
		version(glfw)
		{
			if( invalidateIdle is null )
			{
				debug(invalidateidle) Trace.formatln("addRenderIdle. Going to add a invalidateThread.");
				shouldremoveRenderIdle = false;
				//
				invalidateIdle = new Idle2(&renderIdleCallback);
				//invalidateThread = new Thread(&renderIdleCallback);
				//invalidateThread.start();
			}
			else if( invalidateIdle.running == false )
			{
				invalidateIdle.start();
			}
			//Trace.formatln("not adding another invalidateThread.");
		}
	}
	
	void removeRenderIdle()
	{
		debug(invalidateidle) Trace.formatln("Window.removeRenderIdle() START.");
		debug(invalidateidle) scope(exit) Trace.formatln("Window.removeRenderIdle() END.");
		
		version(gtk)
		{
			if ( mainIdle !is null )
			{
				mainIdle.stop();
				mainIdle = null;
			}
		}
		version(glfw)
		{
			if( invalidateIdle !is null )
			{
				invalidateIdle.stop();
			}
		}
	}
	
	version(gtk)
	{
		Idle mainIdle;
	}
	
	version(glfw)
	{
		Idle2 invalidateIdle;
	}
	//
	
	
	version(gtk)
	{
		public void show() { if( gtkWindow !is null ) gtkWindow.showAll(); isHidden = false; }
		public void hide() { if( gtkWindow !is null ) gtkWindow.hide(); isHidden = true; }
	}
	
	version(glfw)
	{
		public void show(){isHidden = false;}
		public void hide(){isHidden = true;}
	}

	//REMOVE: We propably don't need these anymore. It's handled in openGLCanvas:
	
	//protected bool isInvalidated(bool set) { return m_isInvalidated = set; }
	//protected bool isInvalidated() { return m_isInvalidated; }
	//protected bool m_isInvalidated = false;
	
	/*
	protected bool isInvalidated(bool set) { return gtkWindow.openGLCanvas.isInvalidated = set; }
	protected bool isInvalidated() { return gtkWindow.openGLCanvas.isInvalidated; }
	*/
	
	//synchronized 
	void invalidate()
	{
		debug(invalidate) Trace.formatln("Window.invalidate() START.");
		debug(invalidate) scope(exit) Trace.formatln("Window.invalidate() END.");
		
		//gtkWindow.openGLCanvas.addRenderIdle();
		
		//We only do real invalidating if the
		//isInvalidated flag is released to false
		//after rendering. This way too many calls
		//to invalidate are ignored.
		
		//version(gtk)
		//{
		
		//if( isInvalidated == false )
		//{
			//isInvalidated = true;
			//gtkWindow.invalidate();//This is too slow!
			//if( gtkWindow !is null && gtkWindow.openGLCanvas !is null )
			//	gtkWindow.openGLCanvas.addRenderIdle();
			addRenderIdle();
		//}
		/*}//version(gtk)
		version(glfw)
		{
			//TODO
			addRenderIdle();
		}*/
		
	}
	
	
	
	//These are overridden from Widget.
	
	//FALSE: Currently these return pixel-coordinates.
	//Maybe that's not what is good. Maybe we should
	//have different methods e.g. width() which
	//would return the width in pixels.
	//Then these could return it in height-coordinates.
	
	
	//BUG in native window resize: something like this, yet it doesn't work:
	//I think we should just override this thing completely and
	//just do gtkWindow.resize without these x2 etc. calculations.
	public float x2() { return super.x2(); }
	public void x2(float set)
	{
		float new_width = _w + ((set - (_w*0.5f)));
		float set_pix = hco2p_rel_x( new_width );
		wP(set_pix);
		//return set;
	}
	public void x2N(float set)
	{
		float new_width = _w + ((set - (_w*0.5f)));
		float set_pix = hco2p_rel_x( new_width );
		wP(set_pix);
		//return set;
	}
	
	public float y2() { return super.y2(); }
	public void y2(float set)
	{
		float new_width = _h + ((set - (_h*0.5f)));
		float set_pix = hco2p_rel_y( new_width );
		hP(set_pix);
		//return set;
	}
	public void y2N(float set)
	{
		float new_width = _h + ((set - (_h*0.5f)));
		float set_pix = hco2p_rel_y( new_width );
		hP(set_pix);
		//return set;
	}
	
	
	public float w() { return _w; }
	public void w( float set )
	{
		debug(Window) Trace.formatln("Window.w() Can't yet set Window width in height coordinates.");
		//throw new Exception("Can't yet set Window width in height coordinates.");
		//return _w = set;
	}
	public void wN( float set )
	{
		debug(Window) Trace.formatln("Window.wN() Can't yet set Window width in height coordinates.");
		//throw new Exception("Can't yet set Window width in height coordinates.");
		//return _w = set;
	}
	protected float _w = 1.33333f;
	
	public float h() { return _h; }
	public void h( float set )
	{
		debug(Window) Trace.formatln("Window.h() Can't yet set Window height in height coordinates.");
		//throw new Exception("Can't yet set Window height in height coordinates.");
		//return _h = set;
	}
	public void hN( float set )
	{
		debug(Window) Trace.formatln("Window.hN() Can't yet set Window height in height coordinates.");
		//throw new Exception("Can't yet set Window height in height coordinates.");
		//return _h = set;
	}
	protected float _h = 1.0f;
	
	public float wP() { return _wP; }
	public void wP( float set )
	{
		_wP = set;
		//Trace.formatln("wP: set: {}", cast(double)set );
		_w = p2hco_rel_x(set);
		_ix1 = -(_w * 0.5f);
		_ix2 = _w * 0.5f;
		//super.w( p2hco_rel_x(set) );
		//Trace.formatln("wP: p2hco_rel_x(set): {}", cast(double)p2hco_rel_x(set) );
		//Trace.formatln("wP: _w: {}", cast(double)_w );
		//Trace.formatln("wP: screenHeightP: {}", cast(double)screenHeightP );
		
		version(gtk)
		{
			if( gtkWindow !is null )
				gtkWindow.resize( cast(int)_wP, cast(int)_hP );
		}
		version(glfw)
		{
			//TODO: glfwSetWindowSize( cast(int)_wP, cast(int)_hP );
		}
		
		arrange();
		invalidate();
		//return _wP;
	}
	protected float _wP = 1024.0f;
	
	public float hP() { return _hP; }
	public void hP( float set )
	{
		_hP = set;
		_h = p2hco_rel_y(set);
		_iy1 = -(_h * 0.5f);
		_iy2 = _h * 0.5f;
		//super.h( p2hco_rel_y(set) );
		
		version(gtk)
		{
			if( gtkWindow !is null )
				gtkWindow.resize( cast(int)_wP, cast(int)_hP );
		}
		version(glfw)
		{
			//TODO: glfwSetWindowSize( cast(int)_wP, cast(int)_hP );
		}
		
		arrange();
		invalidate();
		//return _hP;
	}
	protected float _hP = 768.0f;
	
	version(gtk)
	{
		GtkWindow gtkWindow;
	}
	
	version(sfml)
	{
		RenderWindow sfmlWindow;
	}
	
	//OpenGL picking, didn't quite work as it was too slow.
	/*
	//internal
	public uint nextPickingID()
	{
		return m_nextPickingID++;
	}
	static uint m_nextPickingID = 0;
	*/
	//Input handling
	
	//In pixels:
	public uint screenWidthP() { return g_rae.screenWidthP; }
	public uint screenHeightP() { return g_rae.screenHeightP; }
	public float screenAspect() { return g_rae.screenAspect; }
		
	//For interface IRootWindow:
	//public float pixel() { return 1.0f/screenHeightP; }
	//Zooming version:
	//public float pixel() { return 1.0f/h; }
	
	//internal
	public void grabInputRootWindow( Rectangle set )
	{
		debug(mouse) Trace.formatln("Window.grabInputRootWindow().");
		if( m_grabbedWidget !is null )
		{
			debug(mouse) Trace.formatln("Tried to grab two widgets. 1: {} 2: {}", m_grabbedWidget.name, set.name );
			//throw new Exception("Tried to grab two widgets. TODO.");//TODO DEBUG.
			ungrabInputRootWindow(m_grabbedWidget);
		}
			
		m_grabbedWidget = set;
	}
	//internal
	//return true if the ungrabbed widget was the same as the caller.
	//Will ungrab even if the widget is different.
	public bool ungrabInputRootWindow( Rectangle set )
	//Does this really need an argument...
	//Maybe for checking?
	{
		debug(mouse) Trace.formatln("Window.ungrabInputRootWindow().");
		bool res = false;
		if( set is m_grabbedWidget )
			res = true;
		m_grabbedWidget = null;
		return res;
	}
	//if this is null, nothing is grabbed.
	protected Rectangle m_grabbedWidget;
	
	//internal
	public void grabKeyInputRootWindow( Rectangle set )
	{
		debug(keyboard) Trace.formatln("Window.grabKeyInputRootWindow().");
		if( m_grabbedKeyWidget !is null )
		{
			debug(keyboard) Trace.formatln("Tried to grabKey two widgets.");
			//throw new Exception("Tried to grabKey two widgets. TODO.");//TODO DEBUG.
			ungrabKeyInputRootWindow(m_grabbedKeyWidget);
		}
			
		m_grabbedKeyWidget = set;
	}
	//internal
	public void ungrabKeyInputRootWindow( Rectangle set )
	//Does this really need an argument...
	//Maybe for checking? (Which we're not doing now.)
	{
		debug(keyboard) Trace.formatln("Window.ungrabKeyInputRootWindow().");
		m_grabbedKeyWidget = null;
	}
	//if this is null, nothing is grabbed for key input.
	protected Rectangle m_grabbedKeyWidget;
	
	
	
	//OpenGL picking didn't quite work as it was
	//really slow:
	/*
	protected uint[1024] pickingBuffer;//Too big?
	
	//internal
	//Accepts Height-coordinates.
	//Call render() after this and
	//endPicking() after render.
	void startPicking( double mouseX, double mouseY )
	{
		GLint[4] viewport;
	
		float ratio	= wP / hP;//Pixel-coordinates... CHECK.
		//Should w and h be in Height-coordinates and
		//then there should be some other methods like
		//w_pco or widthPixels() heightPixels()??
		//Sounds good.
	
		glSelectBuffer( pickingBuffer.size, pickingBuffer.ptr );
		glRenderMode(GL_SELECT);
	
		glMatrixMode(GL_PROJECTION);
		glPushMatrix();
			glLoadIdentity();
		
			glGetIntegerv( GL_VIEWPORT, viewport.ptr );
			gluPickMatrix( hco2p_x( mouseX ),viewport[3] - hco2p_y(mouseY),
					5,5,viewport.ptr );
			gluPerspective(53.2f, ratio, 0.0f, 200.0f);//The one that works!
			glMatrixMode(GL_MODELVIEW);
			glInitNames();
	}
	
	//internal
	void endPicking(Shz.InputState input)
	{
		int hits;
		
		// restoring the original projection matrix
		glMatrixMode(GL_PROJECTION);
		glPopMatrix();
		glMatrixMode(GL_MODELVIEW);
		glFlush();
		
		// returning to normal rendering mode
		hits = glRenderMode(GL_RENDER);
		
		// if there are hits process them
		if (hits != 0)
			processHits( hits, input );
	}
	
	//internal
	void processHits( int hits, Shz.InputState input )
	{
		uint i;
		uint j;
		uint names;
		uint* ptr;
		uint minZ;
		uint* ptrNames;
		uint numberOfNames;
	
		//Trace.formatln( "hits = {}", hits );
		ptr = cast(uint*)pickingBuffer.ptr;
		minZ = 0xffffffff;
		for( i = 0; i < hits; i++ )
		{
			names = *ptr;
			ptr++;
			if( *ptr < minZ )
			{
				numberOfNames = names;
				minZ = *ptr;
				ptrNames = ptr+2;
			}	
			ptr += names+2;
		}
		
		//Trace.format("The closest hit names are ");
		ptr = ptrNames;
		for( j = 0; j < numberOfNames; j++,ptr++)
		{
			//Trace.format("{} ", *ptr);
			
			foreach( Shrz.Widget wid; itemList )
			{
				if( wid.pickingID == *ptr )
					wid.mouseEvent( input, true );// )//true for bypass_hittest
				//	did_hit = true;
			}
		}
		//Trace.formatln("");
	}
	*/


	bool rootKeyEvent( Shz.InputState input )
	{
		debug(keyboard) Trace.formatln("Window.rootKeyEvent.");
		//TODO make keyfocus!
		
		//If something is grabbed
		//all the input goes to that widget.
		if( m_grabbedKeyWidget !is null )
		{
			debug(keyboard) Trace.formatln("Window.rootKeyEvent. going to the grabbed one.");
			//was_handled = 
			m_grabbedKeyWidget.keyEvent( input );//, true );
		}
		/*
		//NO, we propably don't want the fullscreenItem to get all keyboard input.
		//That would mean it will bypass all useful stuff like ESC to quit, or F,
		//for unfullscreen, if those are defined in some other widget.
		else if( m_fullscreenItem !is null )
		{
			m_fullscreenItem.keyEvent( input );
		}
		*/
		else //otherwise the input goes to this Window only.
		{
				keyEvent(input);
		
				//TODO Maybe we could have a
				//widget.requestKeyInput() which
				//would make the keyEvents go to those
				//widgets that have requested it!
		}
		
		return true;
	}
	
	//CHECK why is this synchronized. Propably just some testing... REMOVE.
	//synchronized 
	bool rootMouseEvent( Shz.InputState input )
	{
		debug(mouse) Trace.formatln("Window.rootMouseEvent() START.");
		debug(mouse) scope(exit) Trace.formatln("Window.rootMouseEvent() END.");
	
		debug(mouseclick)
		{
			if( input.eventType == SEventType.MOUSE_BUTTON_PRESS )
			{
				Trace.formatln("\n\nClick...Window.rootMouseEvent() START." );
				scope(exit) Trace.formatln("Click...Window.rootMouseEvent() END." );
			}
		}
	
		//Trace.formatln("Window.mouseEvent() START.");
	
		bool was_handled = false;
		
		//If something is grabbed, or if we have a fullscreenItem
		//all the input goes to that widget.
		if( m_grabbedWidget !is null )
		{
			debug(mouse) Trace.formatln("Window.rootMouseEvent. going to the grabbed one.");
			was_handled = m_grabbedWidget.mouseEvent( input, false );
			//false will not dive the input lower in the hierarchy.
		}
		else if( m_fullscreenItem !is null )
		{
			was_handled = m_fullscreenItem.mouseEvent( input );
		}
		else //otherwise the input goes to all widgets.
		{
		
			was_handled = mouseEvent(input);
		
		/*
			
			//OpenGL picking didn't quite work as it was
			//really slow.
		
			startPicking( input.mouse.x, input.mouse.y );
				render();
			endPicking(input);
			
			return true;
		*/	
			//The faster manual version:
			/*foreach( Shrz.Widget wid; itemList )
			{
				if( wid.mouseEvent( input ) )
					did_hit = true;
			}*/
			
/*			Trace.formatln("Window.Going to get enclosureList.");
			
			//First check which ones were hit.
			scope LinkedList!(Shrz.Widget) hitlist = enclosureList(input);
			//Best zOrder widget will be in .tail.
			hitlist.tail.mouseEvent( input );
*/
				
				
				
				
			/+	
				
			//Trace.formatln("New window event round..." );
				//scope LinkedList!(ICanvasItem) hit_items = enclosureList( scx(event.x), scy(event.y) );
				scope LinkedList!(ICanvasItem) hit_items = new LinkedList!(ICanvasItem);
				hit_items = enclosureList( input.mouse.x, input.mouse.y, hit_items );
				if( hit_items !is null && hit_items.size() != 0 )
				{
					/*
					foreach( ICanvasItem hit; hit_items )
					{
						Trace.formatln("window event hit: {}", hit.name );
					}
					*/
				
					//We want the hit item with the lowest zOrder.
					//0 is the topmost zOrder.
					ICanvasItem top_hit = hit_items.tail();
					Trace.formatln("top_hit zOrder: {} {}", top_hit.name, top_hit.zOrder );
					foreach( ICanvasItem it; hit_items )
					{
						Trace.formatln("zOrder: {} {}", it.name, it.zOrder );
						if( it.zOrder < top_hit.zOrder )
						{
							Trace.formatln("this is topper z {} {} than {} {}.", it.name, it.zOrder, top_hit.name, top_hit.zOrder );
							top_hit = it;
						}
					}
					
					if( lastHitWidget !is top_hit )
					{
						//store the current event.
						SEventType temp_event_type = input.eventType;
						bool temp_is_handled = input.isHandled;
						
						if( lastHitWidget !is null )
						{
							/*
							if( hit_items.contains(lastHitWidget) )
							{
							
							}
							else
							{
							*/
								//notify the lastHitWidget that the pointer has left it.
								input.eventType = SEventType.LEAVE_NOTIFY;
								lastHitWidget.mouseEvent( input );//THIS , true );
							//}
						}
						//notify the new hit widget that the pointer has entered it.
						input.eventType = SEventType.ENTER_NOTIFY;
						top_hit.mouseEvent( input );//THIS , true );
						//restore the current event.
						input.eventType = temp_event_type;
						input.isHandled = temp_is_handled;
					
					}
					
					//Mark the current top_hit as the lastHitWidget.
					lastHitWidget = top_hit;
					//Send the actual event.
					was_handled = top_hit.mouseEvent( input );//THIS , true );
				}
				else //we didn't hit anything
				{
					if( lastHitWidget !is null )
					{
						//store the current event.
						SEventType temp_event_type = input.eventType;
						bool temp_is_handled = input.isHandled;
						//notify the lastHitWidget that the pointer has left it.
						input.eventType = SEventType.LEAVE_NOTIFY;
						lastHitWidget.mouseEvent( input );//THIS , true );
						//restore the current event (although this isn't necessary in Window...).
						input.eventType = temp_event_type;
						input.isHandled = temp_is_handled;
						lastHitWidget = null;
					}
				}
				
				+/
				
				
				
				
				
				
		}
		return was_handled;
	}
	
	//ICanvasItem lastHitWidget;
	/*
	public ArrangeType arrangeType()
	{
		if( plainWindow is null )
			return m_arrangeType;
		return plainWindow.arrangeType;
	}
	public ArrangeType arrangeType(ArrangeType set)
	{
		if( plainWindow is null )
			return m_arrangeType = set;
		return plainWindow.arrangeType = set;
	}
	*/
	
	Rectangle container()
	{
		if( plainWindow is null ) return null;
		//else
			return plainWindow.container;
	}
	
	//void add( Shrz.Widget a_widget )
	void add( Rectangle a_widget )
	{
		a_widget.rootWindow = this;
		plainWindow.add( a_widget );
		arrange();
		invalidate();
	}
	
	void remove( Rectangle a_widget )
	{
		//a_widget.rootWindow = this;
		plainWindow.remove( a_widget );
		removeFromCanvas( a_widget );
		arrange();
		invalidate();
	}
	
	void append( Rectangle a_widget )
	{
		a_widget.rootWindow = this;
		plainWindow.append( a_widget );
		arrange();
		invalidate();
	}
	
	void prepend( Rectangle a_widget )
	{
		a_widget.rootWindow = this;
		plainWindow.prepend( a_widget );
		arrange();
		invalidate();
	}
	
	void addFloating( Rectangle a_widget )
	{
		a_widget.rootWindow = this;
		super.add( a_widget );
		arrange();
		invalidate();
	}
	
	void removeFromCanvas( Rectangle a_widget )
	{
		//a_widget.rootWindow = this;
		super.remove( a_widget );
	}
	
	//protected 
	
	void maximizeChild(Rectangle tomax)
	{
		if( menu is null || menu.isHidden() )
		{
			tomax.moveToAnim(0.0f, 0.0f, 0.0f);
			tomax.sizeAnim( w, h );
		}
		else
		{
			tomax.moveToAnim(0.0f, menu.h * 0.5f, 0.0f);
			tomax.sizeAnim( w, h - menu.h );
		}
	}
	
	void arrange()
	{
		if( m_itemList is null ) return;//So we don't crash when there's no items.
	
		foreach( Rectangle wid; itemList )
		{
			wid.beforeArrange();
		}
	
		//super.arrange();
		checkZOrder();
		
		//Hmm. This is a hack to bypass Widget.arrange.
		//We basically want the main PlainWindow to be Widget.arranged,
		//but we want all other Widgets in this Window, which are addFloatinged,
		//to be bypassed and to be freely movable. Maybe override arrange,
		//so that it only arranges PlainWindow! And that's what we're
		//doing here.
		
		if( menu !is null )
		{
			menu.wN = w;
			menu.hN = menu.ifDefaultHeight();
			menu.yPos = -(h*0.5f) + (menu.h*0.5f);
		}
		
		if( plainWindow !is null )
		{
			//This is basically a simplification of ArrangeType.FREE.
		
			plainWindow.wN = w;
			
			//This is a little hack to get the size correct...
			plainWindow.defaultWidth = w;
			
			if( menu is null || menu.isHidden )
			{
				plainWindow.hN = h;
				plainWindow.yPos = 0.0f;
				plainWindow.defaultHeight = h;
			}
			else
			{
				plainWindow.hN = h - menu.h;
				plainWindow.yPos = menu.h * 0.5f;
				plainWindow.defaultHeight = h - menu.h;
			}
			
			plainWindow.arrange();
		}
	
		//Trace.formatln("win w: {} h: {}", cast(double)w, cast(double)h );
	
		//Trace.formatln("This size: {}", toString() );
	
		//These are the addFloatinged widgets, i.e.
		//The freely (or not) floating windows.
		foreach( Rectangle wid; itemList )
		{
			if( wid.yPackOptions == PackOptions.EXPAND )
			{
				//TODO
			}
			else if( wid.yPackOptions == PackOptions.SHRINK )
			{
				wid.hN = wid.ifDefaultHeight;
			}
			
			if( wid.xPackOptions == PackOptions.EXPAND )
			{
				//TODO
			}
			else if( wid.xPackOptions == PackOptions.SHRINK )
			{
				wid.wN = wid.ifDefaultWidth;
			}
		
			wid.arrange();
		//	//Trace.formatln("	ch: {}", wid.toString());
			
		//	wid.w = w - (border*2.0);
		//	//wid.h = h - (border*2.0);
		}
	}
	
	
	
	void defaultSize(double set_width, double set_height)
	{
		//super.defaultSize(set_width, set_height); ?
		
		//rectangle.
		//set( x, y, set_width, set_height );
		//arrange();
		
		version(gtk)
		{
			//gtkWindow.setSizeRequest( cast(int)set_width, cast(int)set_height );
			//Doesn't work?:
			//gtkWindow.setDefaultSize( cast(int)set_width, cast(int)set_height );
			gtkWindow.resize( cast(int)set_width, cast(int)set_height );
		}
		version(glfw)
		{
			glfwSetWindowSize( cast(int)set_width, cast(int)set_height );
		}
		
		arrange();
	}
	
	protected bool isFullScreen = false;
	
	void toggleFullscreen()
	{
		if( isFullScreen == true )
			unfullscreen();
		else fullscreen();
	}
	
	//version(glfw)
	//{
		int widthUnFullscreen = 400;
		int heightUnFullscreen = 400;
	//}
	
	void fullscreen()
	{
		version(glfw)
		{
			Trace.formatln("Fullscreen doesn't currently work with the GLFW backend. You must use the -f flag when running this program to get fullscreen.");
			isFullScreen = true;
			return;//Currently doesn't work.
			
			//if( isFullScreen == false )
			//{
				//glfwSetWindowSize(g_rae.screenWidthP, g_rae.screenHeightP );
				//TODO maybe destroy our window and create a new fullscreen?
				//NOPE doesn't work:
				//glfwCloseWindow();
				//createGLFWWindow(g_rae.screenWidthP, g_rae.screenHeightP, true);
				
			//}
		}
	
		widthUnFullscreen = cast(int)wP;
		heightUnFullscreen = cast(int)hP;
		
		debug(Window) Trace.formatln("Window.fullscreen() widthUnFullscreen: {} heightUnFullscreen: {}", widthUnFullscreen, heightUnFullscreen );
		
		version(sfml)
		{
			if( g_rae.isFullScreen == false )
			{
				sfmlWindow.create(VideoMode(1280, 800, 32), Utf.toString(name), Style.FULLSCREEN );
			}
			else 
			{
				sfmlWindow.create(VideoMode(640, 480, 32), Utf.toString(name) );
			}
		}
		
		isFullScreen = true;
		//gtkWindow.maximize();
		version(gtk)
		{
			gtkWindow.fullscreen();
			version(Windows)
			{
				//On Windows we don't get proper fullscreen for some reason.
				gtkWindow.setSizeRequest( cast(int)g_rae.screenWidthP, cast(int)g_rae.screenHeightP );
			}
		}
		arrange();
	}
	
	void unfullscreen()
	{
		version(glfw)
		{	
			isFullScreen = false;
			return;
			//TODO
			//glfwSetWindowSize( widthUnFullscreen, heightUnFullscreen );
			//glfwCloseWindow();
			//createGLFWWindow( widthUnFullscreen, heightUnFullscreen, false);
		}
	
		isFullScreen = false;
		//gtkWindow.maximize();
		version(gtk)
		{
			version(Windows)
			{
				debug(Window) Trace.formatln("Window.unfullscreen() widthUnFullscreen: {} heightUnFullscreen: {}", widthUnFullscreen, heightUnFullscreen );
				//On Windows we don't get proper fullscreen for some reason.
				gtkWindow.setSizeRequest( cast(int)widthUnFullscreen, cast(int)heightUnFullscreen );
				gtkWindow.resize( cast(int)widthUnFullscreen, cast(int)heightUnFullscreen );
				gtkWindow.setDefaultSize( cast(int)widthUnFullscreen, cast(int)heightUnFullscreen );
			}
			
			gtkWindow.unfullscreen();
			
			version(Windows)
			{
				debug(Window) Trace.formatln("Window.unfullscreen() again widthUnFullscreen: {} heightUnFullscreen: {}", widthUnFullscreen, heightUnFullscreen );
				//On Windows we don't get proper fullscreen for some reason.
				gtkWindow.setSizeRequest( cast(int)widthUnFullscreen, cast(int)heightUnFullscreen );
				gtkWindow.resize( cast(int)widthUnFullscreen, cast(int)heightUnFullscreen );
				gtkWindow.setDefaultSize( cast(int)widthUnFullscreen, cast(int)heightUnFullscreen );
			}
		}
		arrange();
	}
	
	void maximize()
	{
		if( g_rae.isFullScreen == false )
		{
			version(gtk)
			{
				gtkWindow.maximize();
			}
			version(glfw)
			{
					//TODO
			}
			arrange();
		}
	}
	
	void onKeyPress(int key)
	{
		
	}
	
	//OpenGL:
	
	//Lights:
	/* Ambient Light Values ( NEW ) */
	GLfloat LightAmbient[] = [ 0.5f, 0.5f, 0.5f, 1.0f ];
	/* Diffuse Light Values ( NEW ) */
	GLfloat LightDiffuse[] = [ 1.0f, 1.0f, 1.0f, 1.0f ];
	/* Light Position ( NEW ) */
	GLfloat LightPosition[] = [ 0.0f, 0.0f, 2.0f, 1.0f ];
	
	void requestVSync()
	{
		version(gtk)
		{
			if( GLExtensions.checkExtension("GLX_SGI_swap_control") )
				glXSwapIntervalSGI( 1 );
			else if( GLExtensions.checkExtension("GLX_MESA_swap_control") )
				glXSwapIntervalMESA( 1 );
			else
			{
				debug(Window) Trace.formatln("Unable to turn VSync on.");
			}
		}
		
		version(glfw)
		{
			debug(Window) Trace.formatln("GLFW version doesn't have ability to affect VSync.");
		}
		
		version(sfml)
		{
			sfmlWindow.useVerticalSync(true);
		}
		
	}
	
	void initGL()
	{
		debug(Window) Trace.formatln("Window.initGL() START.");
		debug(Window) scope(exit) Trace.formatln("Window.initGL() END.");
	
		requestVSync();
	
		/* Enable Texture Mapping ( NEW ) */
		glEnable( GL_TEXTURE_2D );

		/* Enable smooth shading */
		glShadeModel( GL_SMOOTH );

		/* Set the background black */
		//glClearColor( 0.0f, 0.0f, 0.0f, 1.0f );
		glClearColor( 0.0f, 0.0f, 0.0f, 1.0f );
		//glClearColor( 1.0f, 1.0f, 1.0f, 1.0f );
		//glClearColor( 0.1f, 0.2f, 0.1f, 1.0f );

		/* Depth buffer setup */
		glClearDepth( 1.0f );

		/* Enables Depth Testing */
		//glEnable( GL_DEPTH_TEST );

		/* The Type Of Depth Test To Do */
		glDepthFunc( GL_LEQUAL );

		/* Really Nice Perspective Calculations */
		//glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST );

		/* Setup The Ambient Light */
		glLightfv( GL_LIGHT1, GL_AMBIENT, LightAmbient.ptr );

		/* Setup The Diffuse Light */
		glLightfv( GL_LIGHT1, GL_DIFFUSE, LightDiffuse.ptr );

		/* Position The Light */
		glLightfv( GL_LIGHT1, GL_POSITION, LightPosition.ptr );

		/* Enable Light One */
		glEnable( GL_LIGHT1 );

		/* Full Brightness, 50% Alpha ( NEW ) */
		glColor4f( 1.0f, 1.0f, 1.0f, 0.5f);


		glEnable(GL_BLEND);	// Turn Blending On
    /* Blending Function For Translucency Based On Source Alpha Value  */
    //glBlendFunc( GL_SRC_ALPHA, GL_ONE );
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
		
		//line antialiasing:
		//THIS: glEnable (GL_LINE_SMOOTH);
		//THIS: glHint (GL_LINE_SMOOTH_HINT, GL_NICEST);
		//THIS: glLineWidth(1.5f);
		//glLineWidth(1.0f);
		
		//glHint (GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
		//glEnable (GL_BLEND);
		//not this, LINES: glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		//not this, POLYGONS: glBlendFunc( GL_SRC_ALPHA_SATURATE, GL_ONE );
		
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		
		//Counter clockwise is the OpenGL default so we use it too.
		glFrontFace(GL_CCW);
		//glFrontFace(GL_CW);
		
		//Crashy:
		//glEnable (GL_POLYGON_SMOOTH);
		//glHint (GL_POLYGON_SMOOTH_HINT, GL_NICEST);
		
		// Change to texture matrix and flip and rotate the texture
		//glMatrixMode(GL_TEXTURE);
		//glRotatef(180.0f, 0.0f, 0.0f, 1.0f);
		//glScalef(-1.0f, 1.0f, 1.0f);
		
		// Back to normal
		//glMatrixMode(GL_MODELVIEW);
		
		//return true;
	
	}
	
	/**
	* showFullscreenItem can be used to set a ICanvasItem (any widget or rectangle)
	* that will be shown as absolutely fullscreen, and no other ICanvasItems or
	* windows will be drawn. Make sure you have some way of getting away from that
	* state. You can call hideFullscreenItem() to return to normal operation.
	*/
	public void showFullscreenItem(PlainRectangle set)
	{
		m_fullscreenItem = set;
		fullscreenItemWidthMem = m_fullscreenItem.w;
		fullscreenItemHeightMem = m_fullscreenItem.h;
		
		//temporarily set it to windowsize:
		//m_fullscreenItem.w = g_rae.screenWidth();
		//m_fullscreenItem.h = g_rae.screenHeight();
		
		//Animations look silly here.
		//m_fullscreenItem.whAnim( w, h );
		m_fullscreenItem.w = w;
		m_fullscreenItem.h = h;
	}
	public void hideFullscreenItem()
	{
		//Animations look silly here.
		//m_fullscreenItem.whAnim(fullscreenItemWidthMem, fullscreenItemHeightMem );
		m_fullscreenItem.w = fullscreenItemWidthMem;
		m_fullscreenItem.h = fullscreenItemHeightMem;
		m_fullscreenItem = null;
	}
	///You can check if you currently have a fullscreenItem in use.
	public bool isFullscreenItem()
	{
		if( m_fullscreenItem is null )
			return false;
		//else
			return true;
	}
	protected PlainRectangle m_fullscreenItem;
	protected float fullscreenItemWidthMem = 1.0f;
	protected float fullscreenItemHeightMem = 1.0f;
	
	//
	
	Rectangle menu(){ return m_menu; }
	void menu( Rectangle amenu )
	{
		m_menu = amenu;
		//add( amenu );
		addFloating(m_menu);
	}
	protected Rectangle m_menu;
	
	//
	
	public bool timerNotValid = false;
	StopWatch timer;
	
	///Returns elapsed time since last frame in milliseconds
	public double frameTime() { return m_frameTime; }
	protected double frameTime(double set) { return m_frameTime = set; }
	double m_frameTime = 0.0;
	
	Label fpsLabel;
	double fpsTime = 0.0;
	int fpsCount = 0;
	
	protected Draw draw;
	
	void render()
	{
		render(draw);
	}
	
	void render(Draw set_draw)
	{
		debug(render) Trace.formatln("\n\n\n\nWindow.render() START.");
		debug(render) scope(exit) Trace.formatln("Window.render() END.\n\n\n\n");
	
		checkOpenGLError();
	
		if( timerNotValid == true )
		{
			timerNotValid = false;
			//REVIEW: Will this (frameTime = 0.0) make
			//the animations response a bit
			//slow, as the animation doesn't go anywhere in the
			//first frame.
			//CURRENT SOLUTION: Maybe I'll just put a default of
			//40 milliseconds (25fps). That will move the
			//animation a lot during the first frame.
			//But I guess, it's OK, as it will make it
			//feel more responsive and there wasn't any
			//animation before, so there will be no glitches...?
			frameTime = 0.040;
		}
		else
		{
			frameTime = timer.stop();// * 0.001;//convert to milliseconds.
			fpsTime += frameTime;
			fpsCount++;
			
			if( fpsTime >= 5.0 )//5 seconds
			{
				//plainWindow.setBottomHeaderText( Float.toString32((cast(double)fpsCount)/5.0) );
				fpsLabel.text( Float.toString32((cast(double)fpsCount)/5.0) );
				fpsTime = 0.0;
				fpsCount = 0;
			}
			
			//This approach will lead to some jumps in the animation, if
			//there is a lot of delay between the frames. I'll try to set
			//a limit for the amount the animation can advance in a frame.
			//I'll set it to 90 milliseconds. That's a bit under 12 fps if
			//you know what I mean. (That means that if the animation is in
			//this frame is going to be updated more than 12 fps would, that is
			//the actual fps is below 12, then we'll just pretend that we're
			//doing 12 fps, and animate like that, even the screen will get
			//updated less than 12 fps. The animation will appear more solid,
			//hopefully. This tweak is after the fps calculation on purpose,
			//as it's not supposed to affect the calculation results.
			if( frameTime > 0.090 ) frameTime = 0.090;
		}
		
		timer.start();
		
		//idle...
		if( m_itemList !is null )
			foreach(Rectangle wid; itemList)
			{
				if( wid !is null )
					wid.idle();
			}
	
		/*
		version(darwin)
		{
			resize(wP, hP);
		}
		*/
	
		/* These are to calculate our fps */
		//static GLint T0     = 0;
		//static GLint Frames = 0;

		//glClearColor( 0.1f, 0.2f, 0.1f, 1.0f );
		/* Clear The Screen And The Depth Buffer */
		glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

		glPushMatrix();

		/* Reset the view */
		//glLoadIdentity( );
		
		glScalef(1.0f, -1.0f, 1.0f);//Make Y-axis point down.
		//glScalef(1.0f/h, -1.0f/h, 1.0f);
		
		//Also testing a half pixel offset to move the pixel centers.
		//But it didn't bring any benefits. It just caused some more tearing.
		//glTranslatef(g_rae.pixel*0.5f, g_rae.pixel*0.5f, -1.0f);
		
		//Here's a test to draw in pixels:
		//glTranslatef(0.0f, 0.0f, -(screenHeightP/2.0f) + g_rae._tempparam1);
		
		glTranslatef(0.0f, 0.0f, -1.0f);
		//Let's go one unit backwards in the Z-axis to see stuff
		//and to let the objects lie in the 0.0 z-plane.
		
		/*
		static float rota = 0.0f;
		
		rota += 1.1f;
		glRotatef(rota, 0.0, 1.0f, 0.0f);
		
		
		glBegin(GL_TRIANGLES);
		
			glColor4f(1.0f, 0.0f, 0.4f, 1.0f);
			glVertex3f(0.0f, 0.0f, 0.0f);
			glVertex3f(0.5f, 1.0f, 0.0f);
			glVertex3f(1.0f, 0.0f, 0.0f);
			
			glVertex3f(-0.2f, -0.2f, 0.0f);
			glVertex3f(0.2f, -0.2f, 0.0f);
			glVertex3f(0.0f, 0.2f, 0.0f);
		
			glVertex3f(-0.2f, -0.2f, 0.0f);
			glVertex3f(0.0f, 0.2f, 0.0f);
			glVertex3f(0.2f, -0.2f, 0.0f);
			
		
		glEnd();
		
		//
		
		glColor4f(1.0f, 0.5f, 0.3f, 1.0f);

		glBegin(GL_TRIANGLES);
			glVertex3f(0.0f, 0.0f, 0.0f);
			glVertex3f(0.2f, 0.2f, 0.0f);
			glVertex3f(0.0f, 0.2f, 0.0f);
			
			glVertex3f(0.2f, 0.2f, 0.0f);
			glVertex3f(20.0f, 20.0f, 0.0f);
			glVertex3f(0.2f, 20.0f, 0.0f);
		
		
		glEnd();
		*/
		
		//If we have a fullscreenItem then we draw only
		//that.
		if( m_fullscreenItem !is null )
		{
			m_fullscreenItem.render(draw);
		}
		else //otherwise we render normally
		{
			//foreach(Shrz.Widget wid; itemList)
			/*
			//OLD SIMPLE METHOD:
			if( m_itemList !is null )
				foreach(Rectangle wid; itemList)
				{
					if( wid !is null )
						wid.render(draw);
				}
				*/
				
				//NEW RENDER CHILDREN ZORDER METHOD:
				
				//Then the zorder pass, where we render:
				uint widget_count = 0;
				//We'll start the rendering from the zorder itemList.length-1.
				int min_layer = itemList.size-1;
				int max_layer = itemList.size;
				int suggested_next_layer = 0;
			
				while( widget_count < itemList.size )
				{
					foreach(Rectangle wid; itemList)
					{
						//if( wid.isFBO == false )
						//if( wid.isClipByParent == true )
						
						if( wid.zOrder <= max_layer )//ignore those who are already handled. Those are bigger than max_layer.
						{
							if( wid.zOrder >= min_layer )//this widgets layer falls inbetween min_layer and max_layer, so we render it.
							{
								widget_count++;//add widget count, so we keep track when we have rendered all the layers.
								wid.render(draw);
							}
							else if( suggested_next_layer < wid.zOrder )//this widget is still unhandled but it's layer is bigger than
							//our suggested_next_layer. So we'll make that our suggested_next_layer instead.
							//suggested_next_layer will thus be the highest number we haven't yet handled.
							{
								suggested_next_layer = wid.zOrder;
							}
						}
					}
					//Then we move on. This is done with the min_layer and max_layer variables.
					max_layer = min_layer - 1;//The first time around this will be 4999, so that's our upper limit now.
					min_layer = suggested_next_layer;//And this will be the highest num yet to be handled.
					suggested_next_layer = 0;//And then we need to zero this, so that we'll get a valid number next time.
				}
				
		}
		
		
		
		
		glPopMatrix();
		
		glFlush();
								
		//REMOVE: Not needed anymore:
		//Clear the isInvalidated flag.
		//You can now invalidate again.
		//isInvalidated = false;
			
/*
		//glScalef(1.0f, -1.0f, 1.0f);

    // Translate Into/Out Of The Screen By z
    glTranslatef( 0.0f, 0.0f, -10.0f );

    glRotatef( 0.5, 1.0f, 0.0f, 0.0f); // Rotate On The X Axis By xrot
    glRotatef( 1.0, 0.0f, 1.0f, 0.0f); // Rotate On The Y Axis By yrot
*/
		//drawVideo();

		//Move these to idle:
		//xrot += xspeed; /* Add xspeed To xrot */
    //yrot += yspeed; /* Add yspeed To yrot */
		
		/*if( xspeed > 0.0f )
			xspeed -= 0.1f;
		else if( xspeed < 0.0f )
			xspeed += 0.1f;
		if( yspeed > 0.0f )
			yspeed -= 0.1f;
		else if( yspeed < 0.0f )
			yspeed += 0.1f;
		*/
		
		
		/*
		GLfloat gl_x = 1.0f;
		GLfloat gl_y = 1.0f;
		GLfloat gl_w = 1.0f;
		GLfloat gl_h = 1.5f;
		
		
		glColor4f( 1.0f, 0.0f, 1.0f, 1.0f ); //Control Transparency
				glBegin (GL_QUADS);
					//glTexCoord2f	(	xx,						0.0 );
					glVertex3f		(	gl_x,					gl_y,					0.0 );
					//glTexCoord2f	(	xx + ww,			0.0 );  			// (fs.w / 512.0)
					glVertex3f		(	gl_x + gl_w,	gl_y,					0.0 );
					//glTexCoord2f	(	xx + ww,			hh );					// (368.0 / 512.0) (240.0 / 512.0)
					glVertex3f		(	gl_x + gl_w,	gl_y + gl_h,	0.0 );
					//glTexCoord2f	(	xx,						hh );					// (fs.h / 512.0)
					glVertex3f		(	gl_x,					gl_y + gl_h,	0.0 );
				glEnd ();
		*/
	}
	
	//GLfloat width;
	//GLfloat height;
	
	//This will center the coordinates
	//so that center of the window is 0,0.
	//And the height of the screen is 1.0.
	//width of the screen is aspect.
	void resize(GLfloat set_w, GLfloat set_h)
	{
		debug(Window) Trace.formatln("Window.resize() START.");
		debug(Window) scope(exit) Trace.formatln("Window.resize() END.");
		
		wP = set_w;
		hP = set_h;
		
		
		/*GLsizei sx = 0;
		GLsizei sy = 0;
		GLsizei sw = cast(GLsizei)wP;
		GLsizei sh = cast(GLsizei)hP;
		*/
		GLsizei sx = -(cast(GLsizei)(screenWidthP-wP)/2);
		GLsizei sy = -(cast(GLsizei)(screenHeightP-hP)/2);
		GLsizei sw = cast(GLsizei)screenWidthP;
		GLsizei sh = cast(GLsizei)screenHeightP;
	
		debug(Window)
		{
			Trace.formatln("wP: {}", wP );
			Trace.formatln("hP: {}", hP );
			Trace.formatln("screenY: {}", sx );
			Trace.formatln("screenX: {}", sy );
			Trace.formatln("screenWidthP: {}", sw );
			Trace.formatln("screenHeightP: {}", sh );
		}
	
		if( sh == 0 )
			sh = 1;
			
		/*
		if( height != view_height || width != view_width )
		{		
			sh = cast(uint)((cast(float)width / viewAspect) * pixelAspectWidth);	
			sy = (height - sh) / 2;
			
			//debug(output) Trace.formatln("pixelaspect: ")(pixelAspectWidth);
			debug(output) Trace.formatln("sx: ")(sx)(" sy: ")(sy)(" sw: ")(sw)(" sh: ")(sh);
		}
		*/
		
		//float ratio	= wP / hP;
		float ratio	= cast(GLfloat)sw / cast(GLfloat)sh;
		
		glViewport( sx, sy, sw, sh );
			 
		//glViewport( g_rae.screenWidthP/2, g_rae.screenHeightP/2, g_rae.screenWidthP/2, g_rae.screenHeightP/2 );
		
		//glViewport( 0, 0, cast(int)set_w, cast(int)set_h );
		//Trace.formatln("width:")(width);
		//Trace.formatln("height:")(height);
		//glViewport( 0, 0, cast(int)width, cast(int)height );
		glMatrixMode( GL_PROJECTION );
		glLoadIdentity();
		//gluPerspective( 40.0f, ratio, 0.0f, 200.0f );
		
		//The number 53.1f is just the number that works so that pixels don't
		//get distorted. We don't want to do glOrtho as we want to have a pseudo
		//3D world. And we want objects to lie on z = 0. That's why we do a
		//glTranslatef(0, 0 ,-1.0f) and go a bit backwards with our "camera".
		//I've manually checked the 53.1f with a checkerboard pattern in a
		//texture and it seems to not produce any artifacts. Any advice on how
		//we'd better achieve what we want would be great.
		
		//version(darwin)
		//{
			//GLfloat top = Math.tan(53.1f*Math.PI/360.0f);// (near == 0.0f).
			GLfloat top = 0.0005f;
			//GLfloat top = (screenHeightP/2);//a test to draw in pixels...
			GLfloat bottom = -top;
			//GLfloat right = (screenWidthP/2);//a test to draw in pixels...
			GLfloat right = ratio * top;
			GLfloat left = -right;//ratio * bottom;
			//left, right, bottom, top, near, far.
			//a test to draw in pixels:
			//glFrustum(left, right, bottom, top, cast(float)(screenHeightP/2.0f), cast(float)(screenHeightP/2.0f) + 2000.0f);
			glFrustum(left, right, bottom, top, 0.001f, 200.0f);
		
		//}
		//else //Linux, Windows seem to work correctly.
		//{
		
		
		/*
		A BUG. sort of.
		Here's some keywords to let the search engines find this better:
		gluPerspective doesn't work on OSX.
		gluPerspective has no effect on OSX.
		For the past three days, I've been furiously trying to fight this stupid bug.
		Linux and Windows worked fine with it, but Mac OS X couldn't handle it.
		It seems that you cannot pass 0.0 as the near factor of gluPerspective or glFrustum.
		Damn. On OS X that is. Other platforms cope with it very well. It's propably
		in the OpenGL specs some where, but I never seemed to find it even though I read dozens
		of webpages about problems with gluPerspective and glFrustum.
		*/
		
			//fovy, aspect, zNear, zFar
			//////////gluPerspective(53.1, cast(double)ratio, 1.0, 200.0);//The one that works!
		//}
		
		//2D version:
		//GLdouble left, right, bottom, top, near, far
		//glOrtho(cast(double)-ratio/2.0, cast(double)ratio/2.0, -0.5, 0.5, 0.0, 200.0);
		
		
		//gluPerspective(25.0f, ratio, 0.0f, 200.0f);
		
		//gluPerspective(g_rae.tempparam1, ratio, 0.0f, 200.0f);
		
		glMatrixMode( GL_MODELVIEW );
		glLoadIdentity();
	}
	
	
	/+
	void resize(GLfloat set_w, GLfloat set_h)
	{
		debug(Window) Trace.formatln("Window.resize() START.");
		debug(Window) scope(exit) Trace.formatln("Window.resize() END.");
		
		wP = set_w;
		hP = set_h;
		
		
		/*GLsizei sx = 0;
		GLsizei sy = 0;
		GLsizei sw = cast(GLsizei)wP;
		GLsizei sh = cast(GLsizei)hP;
		*/
		GLsizei sx = -(cast(GLsizei)(screenWidthP-wP)/2);
		GLsizei sy = -(cast(GLsizei)(screenHeightP-hP)/2);
		GLsizei sw = cast(GLsizei)screenWidthP;
		GLsizei sh = cast(GLsizei)screenHeightP;
	
		debug(Window)
		{
			Trace.formatln("wP: {}", wP );
			Trace.formatln("hP: {}", hP );
			Trace.formatln("screenY: {}", sx );
			Trace.formatln("screenX: {}", sy );
			Trace.formatln("screenWidthP: {}", sw );
			Trace.formatln("screenHeightP: {}", sh );
		}
	
		if( sh == 0 )
			sh = 1;
			
		/*
		if( height != view_height || width != view_width )
		{		
			sh = cast(uint)((cast(float)width / viewAspect) * pixelAspectWidth);	
			sy = (height - sh) / 2;
			
			//debug(output) Trace.formatln("pixelaspect: ")(pixelAspectWidth);
			debug(output) Trace.formatln("sx: ")(sx)(" sy: ")(sy)(" sw: ")(sw)(" sh: ")(sh);
		}
		*/
		
		//float ratio	= wP / hP;
		float ratio	= cast(GLfloat)sw / cast(GLfloat)sh;
		
		glViewport( sx, sy, sw, sh );
			 
		//glViewport( g_rae.screenWidthP/2, g_rae.screenHeightP/2, g_rae.screenWidthP/2, g_rae.screenHeightP/2 );
		
		//glViewport( 0, 0, cast(int)set_w, cast(int)set_h );
		//Trace.formatln("width:")(width);
		//Trace.formatln("height:")(height);
		//glViewport( 0, 0, cast(int)width, cast(int)height );
		glMatrixMode( GL_PROJECTION );
		glLoadIdentity();
		//gluPerspective( 40.0f, ratio, 0.0f, 200.0f );
		
		//The number 53.1f is just the number that works so that pixels don't
		//get distorted. We don't want to do glOrtho as we want to have a pseudo
		//3D world. And we want objects to lie on z = 0. That's why we do a
		//glTranslatef(0, 0 ,-1.0f) and go a bit backwards with our "camera".
		//I've manually checked the 53.1f with a checkerboard pattern in a
		//texture and it seems to not produce any artifacts. Any advice on how
		//we'd better achieve what we want would be great.
		
		//version(darwin)
		//{
			//GLfloat top = Math.tan(53.1f*Math.PI/360.0f);// (near == 0.0f).
			GLfloat top = 0.0005f;
			GLfloat bottom = -top;
			GLfloat left = ratio * bottom;
			GLfloat right = ratio * top;
			//left, right, bottom, top, near, far.
			glFrustum(left, right, bottom, top, 0.001f, 200.0f);
		
		//}
		//else //Linux, Windows seem to work correctly.
		//{
		
		
		/*
		A BUG. sort of.
		Here's some keywords to let the search engines find this better:
		gluPerspective doesn't work on OSX.
		gluPerspective has no effect on OSX.
		For the past three days, I've been furiously trying to fight this stupid bug.
		Linux and Windows worked fine with it, but Mac OS X couldn't handle it.
		It seems that you cannot pass 0.0 as the near factor of gluPerspective or glFrustum.
		Damn. On OS X that is. Other platforms cope with it very well. It's propably
		in the OpenGL specs some where, but I never seemed to find it even though I read dozens
		of webpages about problems with gluPerspective and glFrustum.
		*/
		
			//fovy, aspect, zNear, zFar
			//////////gluPerspective(53.1, cast(double)ratio, 1.0, 200.0);//The one that works!
		//}
		
		//2D version:
		//GLdouble left, right, bottom, top, near, far
		//glOrtho(cast(double)-ratio/2.0, cast(double)ratio/2.0, -0.5, 0.5, 0.0, 200.0);
		
		
		//gluPerspective(25.0f, ratio, 0.0f, 200.0f);
		
		//gluPerspective(g_rae.tempparam1, ratio, 0.0f, 200.0f);
		
		glMatrixMode( GL_MODELVIEW );
		glLoadIdentity();
		
		/*
		gluLookAt( 0.0, 0.0, -1.0,//VIEW_SCENE_DIST,// eye
		 0.0, 0.0, 0.0,            // center of vision
		 0.0, 1.0, 0.0 );         // up vector
		*/
		//gluPerspective(53.1f, ratio, 0.0f, 200.0f);//The one that works!
	}
	
	+/
	
/+
//The old height based version:

	//This will center the coordinates
	//so that center of the window is 0,0.
	//And the height of the screen is 1.0.
	//width of the screen is aspect.
	void resize(GLfloat set_w, GLfloat set_h)
	{
		wP = set_w;
		hP = set_h;
		
		//GLsizei sx = 0;
		//GLsizei sy = 0;
		//GLsizei sw = cast(GLsizei)wP;
		//GLsizei sh = cast(GLsizei)hP;
		GLsizei sx = -cast(GLsizei)(screenWidthP-wP)/2;
		GLsizei sy = -cast(GLsizei)(screenHeightP-hP)/2;
		GLsizei sw = cast(GLsizei)screenWidthP;
		GLsizei sh = cast(GLsizei)screenHeightP;
	
		Trace.formatln("screenY: {}", sx );
		Trace.formatln("screenX: {}", sy );
		Trace.formatln("screenWidthP: {}", sw );
		Trace.formatln("screenHeightP: {}", sh );
	
		if( sh == 0 )
			sh = 1;
			
		/*
		if( height != view_height || width != view_width )
		{		
			sh = cast(uint)((cast(float)width / viewAspect) * pixelAspectWidth);	
			sy = (height - sh) / 2;
			
			//debug(output) Trace.formatln("pixelaspect: ")(pixelAspectWidth);
			debug(output) Trace.formatln("sx: ")(sx)(" sy: ")(sy)(" sw: ")(sw)(" sh: ")(sh);
		}
		*/
		
		//float ratio	= wP / hP;
		float ratio	= cast(GLfloat)sw / cast(GLfloat)sh;
		 
		//glViewport( g_rae.screenWidthP/2, g_rae.screenHeightP/2, g_rae.screenWidthP/2, g_rae.screenHeightP/2 );
		glViewport( sx, sy, sw, sh );
		//Trace.formatln("width:")(width);
		//Trace.formatln("height:")(height);
		//glViewport( 0, 0, cast(int)width, cast(int)height );
		glMatrixMode( GL_PROJECTION );
		glLoadIdentity();
		//gluPerspective( 40.0f, ratio, 0.0f, 200.0f );
		gluPerspective(53.2f, ratio, 0.0f, 200.0f);//The one that works!
		glMatrixMode( GL_MODELVIEW );
		glLoadIdentity();
	}
+/	
	
	/+
	//The version with a zooming interface:
	void resize(GLfloat set_w, GLfloat set_h)
	{
		wP = set_w;
		hP = set_h;
		
		GLsizei sx = 0;
		GLsizei sy = 0;
		GLsizei sw = cast(GLsizei)wP;
		GLsizei sh = cast(GLsizei)hP;
	
		if( sh == 0 )
			sh = 1;
			
		/*
		if( height != view_height || width != view_width )
		{		
			sh = cast(uint)((cast(float)width / viewAspect) * pixelAspectWidth);	
			sy = (height - sh) / 2;
			
			//debug(output) Trace.formatln("pixelaspect: ")(pixelAspectWidth);
			debug(output) Trace.formatln("sx: ")(sx)(" sy: ")(sy)(" sw: ")(sw)(" sh: ")(sh);
		}
		*/
		
		//float ratio	= wP / hP;
		float ratio	= cast(GLfloat)sw / cast(GLfloat)sh;
		 
		//glViewport( g_rae.screenWidthP/2, g_rae.screenHeightP/2, g_rae.screenWidthP/2, g_rae.screenHeightP/2 );
		glViewport( sx, sy, sw, sh );
		//Trace.formatln("width:")(width);
		//Trace.formatln("height:")(height);
		//glViewport( 0, 0, cast(int)width, cast(int)height );
		glMatrixMode( GL_PROJECTION );
		glLoadIdentity();
		//gluPerspective( 40.0f, ratio, 0.0f, 200.0f );
		gluPerspective(53.2f, ratio, 0.0f, 200.0f);//The one that works!
		glMatrixMode( GL_MODELVIEW );
		glLoadIdentity();
	}
	+/
	
	//void resizeGL(GLfloat set_w, GLfloat set_h)
	//{
	/*	debug(Window) Trace.formatln("Window.resizeGL() START. wP: ")(set_w)(" hP: ")(set_h);
		debug(Window) scope(exit) Trace.formatln("Window.resizeGL() END.");
	
		wP = set_w;
		hP = set_h;
		
		glViewport (0, 0, cast(GLsizei)(wP), cast(GLsizei)(hP));
		*/
		/+
	
		/* Height / width ration */
    GLfloat ratio;
 
    /* Protect against a divide by zero */
    if ( height == 0.0f )
			height = 1.0f;

    ratio = width / height;

    /* Setup our viewport. */
    glViewport( 0, 0, cast(GLint)width, cast(GLint)height );

    /* change to the projection matrix and set our viewing volume. */
    glMatrixMode( GL_PROJECTION );
    glLoadIdentity( );

    /* Set our perspective */
    gluPerspective( 45.0f, ratio, 0.1f, 100.0f );

    /* Make sure we're chaning the model view and not the projection */
    glMatrixMode( GL_MODELVIEW );

    /* Reset The View */
    glLoadIdentity( );
	
		+/
	//}
	
	
	
	//Some helpers:

	///Height Coordinates to pixel coordinates
	double hco2p_x(double from)
	{
		//Trace.formatln("aspect:")(aspect);
		return ((from + (screenAspect*0.5f)) * screenHeightP );
		
	}
	
	double hco2p_y(double from)
	{
		return ((from + 0.5f) * screenHeightP );
	}
	
	double hco2p_rel_x(double from)
	{
		return (from * screenHeightP);
	}
	
	double hco2p_rel_y(double from)
	{
		return (from * screenHeightP);
	}

	
	//This is half of screenHeightP - windowHeight
	//It's used in resize() and in pixel to height coordinates
	//conversions.
	protected float magicHalfHeight()
	{
		return ((screenHeightP-hP)/2);
	}
	protected float magicHalfWidth()
	{
		return ((screenWidthP-wP)/2);
	}

	///Pixels to Height Coordinates
	double p2hco_x(double from)
	{
		//Trace.formatln("aspect:")(aspect);
		return (((from+magicHalfWidth) / screenHeightP) - (screenAspect*0.5f));
		//return ((from / h) - 0.5f);
	}
	
	double p2hco_y(double from)
	{
		//double res = (((from+((screenHeightP-h)/2)) / screenHeightP) - 0.5f);
		//Trace.format("from: {} to: {}", from, res );
		//return res;
		return (((from+magicHalfHeight) / screenHeightP) - 0.5f);
	}
	
	double p2hco_rel_x(double from)
	{
		return (from / screenHeightP);
	}
	
	double p2hco_rel_y(double from)
	{
		return (from / screenHeightP);
	}

/+
//Zooming interface versions:

	///Height Coordinates to pixel coordinates
	double hco2p_x(double from)
	{
		//Trace.formatln("aspect:")(aspect);
		return ((from + (aspect*0.5f)) * h );
		
	}
	
	double hco2p_y(double from)
	{
		return ((from + 0.5f) * h );
	}
	
	double hco2p_rel_x(double from)
	{
		return (from * h);
	}
	
	double hco2p_rel_y(double from)
	{
		return (from * h);
	}

	///Pixels to Height Coordinates
	double p2hco_x(double from)
	{
		//Trace.formatln("aspect:")(aspect);
		return ((from / h) - (aspect*0.5f));
		//return ((from / h) - 0.5f);
	}
	
	double p2hco_y(double from)
	{
		return ((from / h) - 0.5f);
	}
	
	double p2hco_rel_x(double from)
	{
		return (from / h);
	}
	
	double p2hco_rel_y(double from)
	{
		return (from / h);
	}
+/	
	
	
	
}



version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
