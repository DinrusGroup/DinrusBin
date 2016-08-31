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

module rae.core.IRaeMain;

import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;

//public import rae.core.globals;

import rae.core.Theme;

import rae.ui.InputState;
import rae.ui.EventType;

import rae.canvas.ICanvasItem;
import rae.canvas.Image;
import rae.canvas.Gradient;
import rae.canvas.Colour;
import rae.ui.Window;
import rae.ui.SubWindow;

import rae.core.Idle;
import rae.ui.Animator;

import rae.ui.Group;

interface IRaeMain
{
public:


	float _tempparam1();// = 53.1f;
	float _tempparam1(float set);
	float _tempparam2();
	float _tempparam2(float set);
	float _tempparam3();
	float _tempparam3(float set);
	float _tempparam4();
	float _tempparam4(float set);
	float _tempparam5();
	float _tempparam5(float set);
	
	dchar[] applicationNameD();// { return Utf.toString32( m_applicationName ); }
	public char[] applicationName();// { return m_applicationName; }
	public char[] applicationName(char[] set);// { return m_applicationName = set; }
	//protected char[] m_applicationName = "Rae Application";
	
	char[] homeDir();
	char[] desktopDir();
	char[] systemDir();
	char[] workingDir();
	char[] applicationDir();
	
	/*
	//REMOVE:
	public PgContext getPangoContext()
	{
		if( window !is null && window.size > 0 )
			return window[0].getPangoContext();
		//else
			return null;
	}
	*/

	//The height of one pixel in Height coordinates.
	//to convert pixels to Height coordinates:
	//	inPixels * pixel()
	//to convert Height coordinates to pixels:
	//	inHCoord / pixel()
	float pixel();// { return 1.0f/screenHeightP; }
	//This returns and accepts Height coordinates
	float roundToPixels( float set );//
	/*{
		return cast(float)(cast(int)( set / pixel )) * pixel;
	}*/

	//The default dpi (dots per inch) is 96.0f.
	//The user should change it according to screen size.
	//A smaller dpi will result in smaller widgets and
	//smaller text.
	public float dpi(float set);//
	/*{
		m_dpiMul = set/96.0f;
		return m_dpi = set;
	}*/
	public float dpi();// { return m_dpi; }
	//protected float m_dpi;
	
	public float dpiMul();// { return m_dpiMul; }
	//protected float m_dpiMul;

	public float curveSideSize();// { return m_curveSideSize; }
	//protected float m_curveSideSize = 0.30f;

	bool isFullScreen();// = false;
	bool isFullScreen(bool set);
	//uint screenWidthP = 800;
	//uint screenHeightP = 600;
	public uint screenWidthP();// { return m_screenWidthP; }
	public uint screenWidthP(uint set);// { return m_screenWidthP = set; }
	//protected uint m_screenWidthP = 1280;//1066;
	
	public uint screenHeightP();// { return m_screenHeightP; }
	public uint screenHeightP(uint set);//
	/*{
		debug(Rae) Trace.formatln("scrHei to: {}", set);
		return m_screenHeightP = set;
	}
	protected uint m_screenHeightP = 800;
	*/
	
	//Screen width and height in height coordinates.
	public float screenWidth();
	//screenHeight in height coordinates should always be 1.0f.
	public float screenHeight();
	
	float screenAspect();//
	/*{
		return cast(float)(screenWidthP)/cast(float)(screenHeightP);
	}
	*/
	
	public bool allowFBO();// { return m_allowFBO; }
	public bool allowFBO(bool set);// { return m_allowFBO = set; }
	
	//bool running = true;
	
	/*this(char[][] args)
	{
		debug(Rae) Trace.formatln("Rae.this() START.");
		debug(Rae) scope(exit) Trace.formatln("Rae.this() END.");
	
		init(args);
		
		g_rae = this;
	}*/
	
	///A list of all inputState things.
	///Basically one InputState pairs a keyboard
	///and a mouse.
	//LinkedList!(InputState) inputStateList;
	InputState inputState();//
	/*{
		if( inputStateList !is null )
			return inputStateList.head();
		return null;
	}*/
	
	void keyEvent( Window set_window, SEventType set_eventType, int set_key );//
	/*{
		debug(keyboard) Trace.formatln("Rae.keyEvent() START.");
		debug(keyboard) scope(exit) Trace.formatln("Rae.keyEvent() END.");
	
		//Handle null, by using the first window. This is a temp hack for GLFW single window...
		if( set_window is null )
		{
			if( window.size > 0 )
				set_window = window.head;
		}
		
		inputState.keyEvent( set_window, set_eventType, set_key );
		
		//Trace.formatln("Mouse event. x: ")(set_x)(" y: ")(set_y);
		
		set_window.rootKeyEvent( inputState );
	}*/
	
	void mouseEvent( Window set_window, SEventType eventType, int set_button, double set_x, double set_y );//
	/*{
		debug(mouse) Trace.formatln("Rae.mouseEvent() START.");
		debug(mouse) scope(exit) Trace.formatln("Rae.mouseEvent() END.");
	
		//Handle null, by using the first window. This is a temp hack for GLFW single window...
		if( set_window is null )
		{
			if( window.size > 0 )
				set_window = window.head;
		}
		
		inputState.mouseEvent( set_window, eventType, set_button, set_x, set_y );
		
		//Trace.formatln("Mouse event. x: ")(set_x)(" y: ")(set_y);
		
		set_window.rootMouseEvent( inputState );
	}
	*/
	
	void run();//
	void quit();//
	/*{
		running = false;
		
		version(gtk)
		{
			Main.quit();
		}
		version(glfw)
		{
			//TODO
		}
	}
	*/
	
	void render();
	/*{
		debug(render) Trace.formatln("Rae.render() START.");
		uint i = 0;
		foreach(win; window)
		{
			//debug(Rae) 
			debug(render) Trace.formatln("Rae.render() going to render window. {}", i);
			win.render();
			i++;
		}
		
		version(glfw)
		{
			glfwSwapBuffers();
		}
	}
	*/
		
	
	float getValueFromTheme( char[] set_name );
	Gradient getGradientFromTheme( char[] set_name );
	Colour getColourFromTheme( char[] set_name );
	float[] getColourArrayFromTheme( char[] set_name );

	version(zoomCairo)
	{
		Image getTextureFromTheme( char[] set_name, float set_height = 1.0f, Image old_texture = null );
	}
	//version(zoomGL)
	else
	{
		Image getTextureFromTheme( char[] set_name, float set_height = 1.0f, Image old_texture = null );
	}

	//Add a widget to the mainWindow canvas.
	//Calls mainWindow.addFloating to add it as e.g. floating window.
	void add(ICanvasItem set);
	
	//Used as a hack over GLFW one window limitation and C callbacks.
	//version(glfw)
	//{
	Window mainWindow();
	//}
	
	void registerWindow( Window a_window );
	/*{
		debug(Rae) Trace.formatln("Registered window.");//": {}", a_window.name);
	
		mainWindow = a_window;
		
		window.append( a_window );
	}*/
	
	/*
	LinkedList!(Animator) animator;
	void registerAnimator( Animator a_anim )
	{
		animator.append( a_anim );
	}
	void removeAnimator( Animator a_anim )
	{
		animator.remove( a_anim );
	}
	*/
	
	//The new idle:
	void registerIdle2( Idle2 a_idle );
	void removeIdle2( Idle2 a_idle );
	bool callIdles();	
	version(gtk)
	{
	//The old idle.
	void registerIdle( Idle a_idle );
	void stopIdles();
	void startIdles();
	}//version(gtk)
	
	//Groups:
	void registerGroup( Group a_group );
	void showGroup( Group a_group );//hides all other groups
	
	
	//Themes:
	protected Theme currentTheme();// { return m_currentTheme; }
	protected Theme currentTheme(Theme set);
	public void switchTheme(char[] set_theme);
	
	void initThemes();
	
	void createDarkTheme();
	void createWhiteTheme();	
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
