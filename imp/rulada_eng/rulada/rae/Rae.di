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

module rae.Rae;

import tango.util.log.Trace;//Thread safe console output.

//import stdlib = tango.stdc.stdlib;

import tango.util.container.LinkedList;

import TextUtil = tango.text.Util;
import tango.io.FilePath;
import PathUtil = tango.util.PathUtil;//for normalize, which didn't remove ../
import tango.io.FileSystem;
import tango.sys.Environment;

import Utf = tango.text.convert.Utf;

//import freeimage.freeimage;

version(graphicsmagick)
{
	import Mag = magick.api;
}

public import rae.core.globals;

import rae.core.IRaeMain;

import rae.core.Theme;

import rae.ui.InputState;
import rae.ui.EventType;

import rae.canvas.ICanvasItem;
import rae.canvas.Image;
import rae.canvas.Gradient;
import rae.ui.Window;
import rae.ui.SubWindow;

import rae.core.Idle;
import rae.ui.Animator;
import rae.ui.Group;

version(gtk)
{
	import gtkD.gtk.Main;
	import gtkD.glgdk.GLdInit;
	import gtkD.gdk.Gdk;

	//GL imports:
	//public import gtkglc.gl;
	//public import gtkglc.glu;
	
	import gtkD.gtk.Timeout;
	
	import gtkD.pango.PgContext;
}

	//import gtk.Main;//TEMP

	public import rae.gl.gl;
	public import rae.gl.glu;
	public import rae.gl.glext;

version(glfw)
{
	import glfw.glfw;
}

version(sfml)
{
	import DSFML = dsfml.window.all;
}


//Rae g_rae;




class Rae : IRaeMain
{
public:
	float _tempparam1() { return m_tempparam1; }
	float _tempparam1(float set) { return m_tempparam1 = set; }
	float m_tempparam1 = 0.0f;
	float _tempparam2() { return m_tempparam2; }
	float _tempparam2(float set) { return m_tempparam2 = set; }
	float m_tempparam2 = 53.1f;
	float _tempparam3() { return m_tempparam3; }
	float _tempparam3(float set) { return m_tempparam3 = set; }
	float m_tempparam3 = 53.1f;
	float _tempparam4() { return m_tempparam4; }
	float _tempparam4(float set) { return m_tempparam4 = set; }
	float m_tempparam4 = 53.1f;
	float _tempparam5() { return m_tempparam5; }
	float _tempparam5(float set) { return m_tempparam5 = set; }
	float m_tempparam5 = 53.1f;
	
	public dchar[] applicationNameD() { return Utf.toString32( m_applicationName ); }
	public char[] applicationName() { return m_applicationName; }
	public char[] applicationName(char[] set) { return m_applicationName = set; }
	protected char[] m_applicationName = "Rae Application";
	
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
	float pixel() { return 1.0f/screenHeightP; }
	//This returns and accepts Height coordinates
	float roundToPixels( float set )
	{
		return cast(float)(cast(int)( set / pixel )) * pixel;
	}

	//The default dpi (dots per inch) is 96.0f.
	//The user should change it according to screen size.
	//A smaller dpi will result in smaller widgets and
	//smaller text.
	public float dpi(float set)
	{
		//The range for the Dpi is currently 30-300.
		//You'll get distortions in both ends. So, the
		//real usable range is something about 60-180.
		if( set < 30.0f ) set = 30.0f;
		else if( set > 300.0f ) set = 300.0f;
	
		m_dpiMul = set/96.0f;
		
		//Adjust curveSideSize to fall on the desired range.
		//Dpi over about 190.0 will propably not look so good anymore.
		//even with these adjustments. Would have to change the texture
		//size to 128 in that case. TODO.
		m_curveSideSize = m_dpiMul * 0.3f;
		if( m_curveSideSize < 0.25f ) m_curveSideSize = 0.25f;
		else if( m_curveSideSize > 0.48f ) m_curveSideSize = 0.48f;
		
		return m_dpi = set;
	}
	public float dpi() { return m_dpi; }
	protected float m_dpi;
	
	public float dpiMul() { return m_dpiMul; }
	protected float m_dpiMul;

	//A setting for RoundedRectangles:
	//e.g. in HORIZONTAL this is
	//the width of leftRect and rightRect.
	//This must be correct for the given dpi
	//because otherwise the rounded curve will
	//get clipped too soon.
	//Setting the dpi will change this too.
	//And it will get adjusted to be in the range 0.25f - 0.48f.
	public float curveSideSize() { return m_curveSideSize; }
	protected float m_curveSideSize = 0.3f;

	public bool isWindowedSet() { return m_isWindowedSet; }
	public void isWindowedSet(bool set) { m_isWindowedSet = set; }
	protected bool m_isWindowedSet = false;

	public bool isFullScreen() { return m_isFullScreen; }
	public bool isFullScreen(bool set)
	{
		if( isWindowedSet == false )
			m_isFullScreen = set;
		else if( isWindowedSet == true )
			m_isFullScreen = false;//Always make isFullScreen false if the isWindowedSet is true.
		return m_isFullScreen;
	}
	protected bool m_isFullScreen = false;
	//uint screenWidthP = 800;
	//uint screenHeightP = 600;
	public uint screenWidthP() { return m_screenWidthP; }
	public uint screenWidthP(uint set) { return m_screenWidthP = set; }
	protected uint m_screenWidthP = 1280;//1066;
	
	public uint screenHeightP() { return m_screenHeightP; }
	public uint screenHeightP(uint set)
	{
		debug(Rae) Trace.formatln("scrHei to: {}", set);
		m_p2hCoordMul = 1.0f / set;
		return m_screenHeightP = set;
	}
	protected uint m_screenHeightP = 800;
	
	public float p2hCoordMul() { return m_p2hCoordMul; }
	protected float m_p2hCoordMul = 0.00125f;//1.0f / screenHeightP;
	
	//Screen width and height in height coordinates.
	public float screenWidth() { return 1.0f*screenAspect; }
	//screenHeight in height coordinates should always be 1.0f.
	public float screenHeight() { return 1.0f; }
	
	float screenAspect()
	{
		return cast(float)(screenWidthP)/cast(float)(screenHeightP);
	}
	
	public bool allowFBO() { return m_allowFBO; }
	public bool allowFBO(bool set) { return m_allowFBO = set; }
	protected bool m_allowFBO = true;
	
	bool running = true;
	
	this(char[][] args)
	{
		debug(Rae) Trace.formatln("Rae.this() START.");
		debug(Rae) scope(exit) Trace.formatln("Rae.this() END.");
	
		init(args);
		
		g_rae = this;
	}
	
	///A list of all inputState things.
	///Basically one InputState pairs a keyboard
	///and a mouse.
	LinkedList!(InputState) inputStateList;
	InputState inputState()
	{
		if( inputStateList !is null )
			return inputStateList.head();
		return null;
	}
	
	void keyEvent( Window set_window, SEventType set_eventType, int set_key )
	{
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
	}
	
	void mouseEvent( Window set_window, SEventType eventType, int set_button, double set_x, double set_y )
	{
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
	
	void run()
	{
		debug(Rae) Trace.formatln("Rae.run() START.");
		debug(Rae) scope(exit) Trace.formatln("Rae.run() END.");
		version(gtk)
		{
			runGtk();
		}
	
		version(sfml)
		{
			while( running == true )
			{
				
				DSFML.Event evt;
				window.head.sfmlWindow.getEvent(evt);
				
				callIdles();
				
				//while( running == true && callIdles() == true )
				//{
				//	glfwPollEvents();
				//}
				
				//processEvents();
				render();
				//Trace.formatln( getSDLError() );
				//Trace.formatln("Rae.run().");
			}
		}
	
		version(glfw)
		{
			while( running == true )
			{
				//glfwPollEvents();//Don't use this, it's for games.
				//It will take up too much CPU all the time, even when
				//nothing is happening.
				glfwWaitEvents();//use this instead. It will sleep when
				//no events are being received.
				
				while( running == true && callIdles() == true )
				{
					glfwPollEvents();
				}
				//processEvents();
				//render();
				//Trace.formatln( getSDLError() );
				//Trace.formatln("Rae.run().");
			}
			
			glfwCloseWindow();
		}
		
		/*if( raeMainWindow is null )
		{
			//We should quit as there's no mainwindow created.
			Trace.formatln("Rae.run() We should quit as there's no mainwindow created.");
		}*/
		/*while( running == true )
		{
			processEvents();
			render();
			//Trace.formatln( getSDLError() );
			//Trace.formatln("Rae.run().");
		}*/
	}
	
	void quit()
	{
		running = false;
		
		version(graphicsmagick)
		{
			Mag.DestroyMagick();
		}
		
		version(gtk)
		{
			Main.quit();
		}
		version(glfw)
		{
			//stdlib.exit(0);
		}
	}
	
	void render()
	{
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
	
	//you can't set these yourself. I'm not sure if that's a good thing.
	public char[] homeDir() { return m_homeDir; }
	protected char[] homeDir(char[] set) { return m_homeDir = set; }
	protected char[] m_homeDir;
	
	public char[] desktopDir() { return m_desktopDir; }
	protected char[] desktopDir(char[] set) { return m_desktopDir = set; }
	protected char[] m_desktopDir;
	
	public char[] systemDir() { return m_systemDir; }
	protected char[] systemDir(char[] set) { return m_systemDir = set; }
	protected char[] m_systemDir;
	
	///The current working directory.
	public char[] workingDir() { return m_workingDir; }
	protected char[] workingDir(char[] set) { return m_workingDir = set; }
	protected char[] m_workingDir;
	
	///The application directory. Where the application was run from.
	public char[] applicationDir() { return m_applicationDir; }
	protected char[] applicationDir(char[] set) { return m_applicationDir = set; }
	protected char[] m_applicationDir;
	
	void initDirectories(char[][] args)
	{
		workingDir = FileSystem.getDirectory;
		version(linux)
		{
			//This is propably Posix only:
			homeDir = Environment.get("HOME") ~ "/";
			desktopDir = homeDir ~ "Desktop/";
			systemDir = "/";
		}
		version(darwin)
		{
			homeDir = Environment.get("HOME") ~ "/";
			desktopDir = homeDir ~ "Desktop/";
			systemDir = "/";
		}
		version(Windows)
		{
			homeDir = "C:/";//TODO find out how to do this properly 
			//See http://www.flexhex.com/docs/articles/hard-links.phtml
			//for why this is wrong, and how to get the desktop dir properly.
			//I don't have the time to implement that...
			desktopDir = "C:/Document and Settings/All Users/Desktop/";
			systemDir = "C:/";
		}
		
	
		if( homeDir is null )
		{
			Trace.formatln("Can't find environment variable HOME.");
		}
		
		char[] args_zero = args[0].dup;
		
		//This is fix for a tango bug (possibly fixed in trunk)
		//which will crash on Windows, if the path separator is \
		//instead of / that tango now uses.
		TextUtil.replace( args_zero, '\\', '/' );
		
		//Now we'll setup appDir
		scope mypath = new FilePath( args_zero );
		
		debug(Rae) Trace.formatln("applicationDir before: {}", mypath.path() );
		
		bool starts_with_two_dots = false;
		if( args[0][0] == '.' && args[0][1] == '.' )
			starts_with_two_dots = true;
		
		mypath = FileSystem.toAbsolute( mypath );//This will add /home/user...
		if( starts_with_two_dots )
			applicationDir = PathUtil.normalize( mypath.path() );//This will get rid of the trailing /../
		else applicationDir = mypath.path();
		
		debug(Rae)
		{
			Trace.formatln("applicationDir after: {}", applicationDir );
			Trace.formatln("workingDir: {}", workingDir );
			Trace.formatln("homeDir: {}", homeDir );
		}
	}
	
	void init(char[][] args)
	{
		debug(Rae) Trace.formatln("Rae.init() START.");
		debug(Rae) scope(exit) Trace.formatln("Rae.init() END.");
		
		dpi = 110.0f;//This looks good on my laptop.
		//dpi = 100.0f;//This looks good on my laptop.
		//On a desktop this is propably too much.
		//You can override it with --dpi 85.0
		//dpi = 96.0f;
		//dpi = 72.0f;
		//dpi = 82.0f;
			
		if (args.length > 1)
		{
			//foreach(char[] ar; args)
			for( uint i = 0; i < args.length; i++ )
			{
				char[] ar = args[i];
				
				if( ar == "--help" )
				{
					Trace.formatln("Rae.\n\n"
						"Available command line switches are:\n"
						"--help : This help message.\n"
						"--fullscreen or -f : Well this is the default actually.\n"
						"--windowed or -w : Windowed mode.\n"
						"--dpi 96.0 : Set your relative display size with the dpi setting."
						"--theme Dark : Set the theme. (Currently Flat, White or Dark.)"
						"\n"
						);
						running = false;//Quit.
						return;
				}
				if( ar == "--fullscreen" || ar == "-f" )
				{
					isFullScreen = true;
					debug(Rae) Trace.formatln("Fullscreen mode.");
				}
				else if( ar == "--windowed" || ar == "-w" )
				{
					isFullScreen = false;
					isWindowedSet = true;
					debug(Rae) Trace.formatln("Windowed mode.");
				}
				else if( ar == "--dpi" )
				{
					if( i+1 < args.length )
					{
						dpi = Float.toFloat!(char)( args[i+1] );
						debug(Rae) Trace.formatln("Set screen dpi to {}", cast(double) dpi );
					}
				}
				else if( ar == "--theme" )
				{
					if( i+1 < args.length )
					{
						switchTheme( args[i+1] );
						debug(Rae) Trace.formatln("Set theme to {}", args[i+1] );
					}
				}
			}//endfor
		}//endif
		
		initDirectories(args);
		
		window = new LinkedList!(Window);
		
		idle2 = new LinkedList!(Idle2);
		
		version(gtk)
		{
			idle = new LinkedList!(Idle);
		}
		//animator = new LinkedList!(Animator);
		textures = new LinkedList!(Image);
		
		inputStateList = new LinkedList!(InputState);
		InputState defaultInputState = new InputState();
		inputStateList.append( defaultInputState );
		
		version(gtk)
		{
			debug(Rae) Trace.formatln("Going to initGtk.");
			initGtk(args);
			debug(Rae) Trace.formatln("Done initGtk.");
		}
		
		version(glfw)
		{
			debug(Rae) Trace.formatln("Going to initGLFW.");
			initGLFW(args);
			debug(Rae) Trace.formatln("Done initGLFW.");
		}
		
		//FreeImage_Initialise();
		version(graphicsmagick)
		{
			Mag.InitializeMagick(args);
			//Mag.GetExceptionInfo(&exception);
		}
		
		//initThemes();//We do this on demand now...
	}
		
	version(gtk)
	{
		//protected:
			
			void initGtk(char[][] args)
			{
				debug(Rae) Trace.formatln("Rae.initGtk() START.");
				debug(Rae) scope(exit) Trace.formatln("Rae.initGtk() END.");
				
				Main.init(args);
				GLdInit.init(args);
				//PihlajaMainWindow pihlajaMainWindow = new PihlajaMainWindow();
				//pihlajaMainWindow.showAll();
				
				//Get screen dimensions:
				screenWidthP = Gdk.screenWidth();
				screenHeightP = Gdk.screenHeight();
				
				debug(Rae) Trace.formatln("screenWidthP: {}", screenWidthP);
				debug(Rae) Trace.formatln("screenHeightP: {}", screenHeightP);
			}
			
			void runGtk()
			{
				debug(Rae) Trace.formatln("Rae.runGtk() START.");
				debug(Rae) scope(exit) Trace.formatln("Rae.runGtk() END.");
				Main.run();
			}
	}
	
	version(glfw)
	{
		void initGLFW(char[][] args)
		{
			glfwInit();
			
			//Main.init(args);
			
			//Get screen dimensions:
			
			GLFWvidmode vidmode;
			
			glfwGetDesktopMode( &vidmode );
			
			screenWidthP = vidmode.Width;//1280;//TODO get it from glfw
			screenHeightP = vidmode.Height;//800;//TODO
		
			debug(Rae) Trace.formatln("GLFW videomode: width: {}, height: {}", screenWidthP, screenHeightP );
			
		}
	}
	
	LinkedList!(Image) textures;
	
	/*
	Image getTextureByID( uint set_id )
	{
		foreach( Image img; textures )
		{
			if( img.id == set_id )
				return img;
		}
		return null;
	}
	*/
	
	float getValueFromTheme( char[] set_name )
	{
		if( themes is null )
			initThemes();
	
		return currentTheme.getValue(set_name);
	}
	
	float getValueDpiFromTheme( char[] set_name )
	{
		//Currently this is just an alias for getValue.
		//But this might change so that it will
		//add the dpi to the queried value.
		//I'll have to think, how this dpi system will work.
		//and how to change the dpi while the program is running.
		if( themes is null )
			initThemes();
	
		return currentTheme.getValue(set_name) * dpiMul;
	}
	
	Gradient getGradientFromTheme( char[] set_name )
	{
		if( themes is null )
			initThemes();
	
		return currentTheme.getGradient(set_name);
	}
	
	Colour getColourFromTheme( char[] set_name )
	{
		if( themes is null )
			initThemes();
	
		return currentTheme.getColour(set_name);
	}
	
	float[] getColourArrayFromTheme( char[] set_name )
	{
		if( themes is null )
			initThemes();
	
		return currentTheme.getColourArray(set_name);
	
		/*
		float[] result = new float[4];
			
			switch( set_name )
			{
				default:
				break;
				case "Rae.Button":
					//colour(0.7f, 0.7f, 0.7f, 1.0f);//Light grey
					
					//result[0] = 0.7f;
					//result[1] = 0.7f;
					//result[2] = 0.7f;
					//result[3] = 1.0f;
					
					//colour(0.1f, 0.1f, 0.1f, 1.0f);//dark grey
					
					result[0] = 0.1f;
					result[1] = 0.1f;
					result[2] = 0.1f;
					result[3] = 1.0f;
					
				break;
				case "Rae.WindowHeader.Top":
					result[0] = 0.1f;
					result[1] = 0.1f;
					result[2] = 0.1f;
					result[3] = 1.0f;
				break;
				case "Rae.WindowHeader.Bottom":
					result[0] = 0.0f;
					result[1] = 0.0f;
					result[2] = 0.0f;
					result[3] = 1.0f;
				break;
				case "Rae.CircleButton":
					
				break;
			}
		
		return result;
		*/
	}

	version(zoomCairo)
	{
		Image getTextureFromTheme( char[] set_name, float set_height = 1.0f, Image old_texture = null )
		{
			if( themes is null )
				initThemes();
		
			return currentTheme.getImage(set_name, set_height, old_texture);
		}
	}
	//version(zoomGL)
	else
	{
		Image getTextureFromTheme( char[] set_name, float set_height = 1.0f, Image old_texture = null )
		{
			if( themes is null )
				initThemes();
		
			return currentTheme.getImage(set_name);
		}
	}

/*
	Image getTextureFromTheme( char[] set_name )
	{
		if( themes is null )
			initThemes();
	
		return currentTheme.getImage(set_name);
	
		//
		Image texture = getTextureByName(set_name);
		
		float[4] m_textColourData = [1.0f, 1.0f, 1.0f, 1.0f];
		
		if( texture is null )
		{
			switch( set_name )
			{
				default:
				break;
				case "Rae.Button":
					Trace.formatln("Creating Button texture.");
					texture = new Image( Image.GRADIENT_2 );
					texture.name = "Rae.Button";
					registerTexture(texture);
				break;
				case "Rae.CircleButton":
					texture = Image.createCircle(m_textColourData);
					texture.name = "Rae.CircleButton";
					registerTexture(texture);
				break;
				case "Rae.HScrollbar.background":
					texture = new Image( Image.GRADIENT_2 );
					texture.name = "Rae.HScrollbar.background";
					registerTexture(texture);
				break;
				case "Rae.HScrollbar.controlRect":
					texture = new Image( Image.GRADIENT_2 );
					texture.name = "Rae.HScrollbar.controlRect";
					registerTexture(texture);
				break;
				case "Rae.VScrollbar.background":
					texture = new Image( Image.GRADIENT_2_VERTICAL );
					texture.name = "Rae.VScrollbar.background";
					registerTexture(texture);
				break;
				case "Rae.VScrollbar.controlRect":
					texture = new Image( Image.GRADIENT_2_VERTICAL );
					texture.name = "Rae.VScrollbar.controlRect";
					registerTexture(texture);
				break;
			}
		}
		
		return texture;
		
	}
	
*/
	/*
	Image getTextureByName( char[] set_name )
	{
		
		foreach( Image img; textures )
		{
			if( img.name == set_name )
			{
				Trace.formatln("Reusing texture called {}.", set_name );
				return img;
			}
		}
		return null;
		
	}
	*/
	
	/*
	void registerTexture( Image a_image )
	{
		//Trace.formatln("Registered texture: {}", a_image.name);
		textures.append( a_image );
	}
	*/
	
	//Add a widget to the mainWindow canvas.
	//Calls mainWindow.addFloating to add it as e.g. floating window.
	void add(ICanvasItem set)
	{
		if( mainWindow !is null && set !is null )
			mainWindow.addFloating(cast(Rectangle) set);
	}
	
	//Used as a hack over GLFW one window limitation and C callbacks.
	//version(glfw)
	//{
	public Window mainWindow() { return m_mainWindow; }
	protected Window mainWindow(Window set) { return m_mainWindow = set; }
	protected Window m_mainWindow;
	//}
	
	LinkedList!(Window) window;
	
	void registerWindow( Window a_window )
	{
		debug(Rae) Trace.formatln("Registered window.");//": {}", a_window.name);
	
		mainWindow = a_window;
		
		window.append( a_window );
	}
	
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
	LinkedList!(Idle2) idle2;
	void registerIdle2( Idle2 a_idle )
	{
		if( idle2.contains( a_idle ) == false )
			idle2.append( a_idle );
	}
	void removeIdle2( Idle2 a_idle )
	{
		idle2.remove( a_idle );
	}
	bool callIdles()
	{
		debug(RaeIdle) Trace.formatln("Rae.callIdles().");
	
		bool is_some_idle_running = false;
	
		scope auto to_remove = new LinkedList!(Idle2);
		foreach( Idle2 i; idle2 )
		{
			if( i !is null )
			{
				if( i.running == true )
				{
					is_some_idle_running = true;
					i.call();
				}
				else to_remove.append(i);
			}
		}
		
		foreach( Idle2 i; to_remove )
		{
			if( i !is null )
			{
				idle2.remove(i);
			}
		}
		return is_some_idle_running;
	}
	
	version(gtk)
	{
	//The old idle.
	LinkedList!(Idle) idle;
	
	void registerIdle( Idle a_idle )
	{
		idle.append( a_idle );
	}
	
	void stopIdles()
	{
		foreach( Idle i; idle )
		{
			i.stop();
		}
	}
	
	void startIdles()
	{
		foreach( Idle i; idle )
		{
			i.start();
		}
	}
	
	}//version(gtk)
	
	
	//Groups:
	void registerGroup( Group a_group )
	{
		debug(Group) Trace.formatln("Registered group: {}", a_group.name );
		groups.append( a_group );
	}
	LinkedList!(Group) groups()
	{
		if( m_groups is null )
			m_groups = new LinkedList!(Group);
		return m_groups;
	}
	protected LinkedList!(Group) m_groups;
	
	void showGroup( Group a_group )//hides all other groups
	{
		if( groups.contains(a_group) )
		{
			foreach( Group grp; groups )
			{
				if( a_group is grp )
				{
					grp.show();
				}
				else grp.hide();
			}
		}
	}
	
	//Themes:
	
	protected LinkedList!(Theme) themes;
	protected Theme currentTheme() { return m_currentTheme; }
	protected Theme currentTheme(Theme set)
	{
		currentThemeName = set.name;
		return m_currentTheme = set;
	}
	protected Theme m_currentTheme;
	protected char[] currentThemeName = "Flat";
	public void switchTheme(char[] set_theme)
	{
		//We can't init themes here. Need initGtk and other stuff before.
		//if( themes is null )
		//	initThemes();
	
		if( themes is null )
		{
			currentThemeName = set_theme;
		}
		else
		{
			foreach(Theme th; themes)
			{
				if( th.name == set_theme )
					currentTheme = th;
			}
		}
	}
	
	void initThemes()
	{
		debug(Rae) Trace.formatln("Rae.initThemes() START.");
		debug(Rae) scope(exit) Trace.formatln("Rae.initThemes() END.");
	
		if( themes is null )
			themes = new LinkedList!(Theme);
		
		createFlatTheme();
		createDarkTheme();
		createWhiteTheme();
	}
	
	void createDarkTheme()
	{
		debug(Rae) Trace.formatln("Rae.createDarkTheme() START.");
		debug(Rae) scope(exit) Trace.formatln("Rae.createDarkTheme() END.");
		
		Theme my_theme = new Theme("Dark");//"18% Gray");
		themes.append( my_theme );
		
		if( currentTheme is null )
			m_currentTheme = my_theme;
			
		if( currentThemeName == my_theme.name )
			currentTheme = my_theme;
		
		my_theme.addColour( "Rae.Text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Box", 0.18f, 0.18f, 0.18f, 1.0f );
		my_theme.addColour( "Rae.Menu", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.MenuItem", 0.18f, 0.18f, 0.18f, 1.0f );
		my_theme.addColour( "Rae.MenuItem.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.MenuItem.prelight", 0.1f, 0.2f, 0.85f, 0.7f );
		my_theme.addColour( "Rae.Button", 0.1f, 0.1f, 0.1f, 1.0f );
		my_theme.addColour( "Rae.Button.outline", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.Button.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.CircleButton", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.CircleButton.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.ProgressBar", 0.12f, 0.12f, 0.12f, 1.0f );
		my_theme.addColour( "Rae.ProgressBar.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.background", 0.12f, 0.12f, 0.12f, 1.0f );
		my_theme.addColour( "Rae.Slider.backgroundoutline", 0.0f, 0.0f, 0.0f, 1.0f );
		//my_theme.addColour( "Rae.Slider.control", 63.0f/255.0f, 128.0f/255.0f, 74.0f/255.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.control", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.control.outline", 0.24f, 0.24f, 0.24f, 1.0f );
		my_theme.addColour( "Rae.Scrollbar", 0.12f, 0.12f, 0.12f, 1.0f );
		my_theme.addColour( "Rae.Paned", 0.12f, 0.12f, 0.12f, 1.0f );
		my_theme.addColour( "Rae.PanedController", 0.25f, 0.25f, 0.25f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.Top", 0.1f, 0.1f, 0.1f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.Bottom", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.outline", 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 0.0f );
		my_theme.addColour( "Rae.SubWindow.background", 0.18f, 0.18f, 0.18f, 1.0f );
		my_theme.addColour( "Rae.SubWindow.shadow", 0.0f, 0.0f, 0.0f, 0.6f );
		my_theme.addColour( "Rae.Canvas.background", 0.12f, 0.12f, 0.12f, 1.0f );
		//my_theme.addColour( "Rae.ResizeButton", 63.0f/255.0f, 128.0f/255.0f, 74.0f/255.0f, 1.0f );
		my_theme.addColour( "Rae.ResizeButton", 128.0f/255.0f, 128.0f/255.0f, 128.0f/255.0f, 1.0f );
		my_theme.addColour( "Rae.ResizeButton.outline", 128.0f/255.0f, 128.0f/255.0f, 128.0f/255.0f, 0.0f );
		
		//Values:
		version(linux)
		{
			my_theme.addValueDpi( "Rae.Font.normal", 10.0f );//9.0f
			my_theme.addValueDpi( "Rae.Font.small", 7.0f );//6.0f
		}
		version(darwin)
		{
			my_theme.addValueDpi( "Rae.Font.normal", 13.5f );//9.0f
			my_theme.addValueDpi( "Rae.Font.small", 10.0f );//6.0f
		}
		version(Windows)
		{
			my_theme.addValueDpi( "Rae.Font.normal", 10.0f );//9.0f
			my_theme.addValueDpi( "Rae.Font.small", 7.0f );//6.0f
		}
		my_theme.addValueDpi( "Rae.Button.defaultHeight", 0.025f );
		my_theme.addValueDpi( "Rae.Button.rectangle.defaultHeight", 0.025f );
		my_theme.addValueDpi( "Rae.Button.square.defaultHeight", 0.050f );
		my_theme.addValueDpi( "Rae.Button.circle.defaultHeight", 0.0125f );
		my_theme.addValueDpi( "Rae.Button.triangle.defaultHeight", 0.008f );
		my_theme.addValueDpi( "Rae.TickButton.defaultHeight", 0.0125f );
		my_theme.addValueDpi( "Rae.WindowHeader.NORMAL.defaultHeight", 0.03f );
		my_theme.addValueDpi( "Rae.WindowHeader.SMALL.defaultHeight", 0.02f );
		my_theme.addValueDpi( "Rae.HSlider.defaultHeight", 0.019f );
		my_theme.addValueDpi( "Rae.VSlider.defaultWidth", 0.019f );
		my_theme.addValueDpi( "Rae.HScrollbar.defaultHeight", 0.019f );
		my_theme.addValueDpi( "Rae.VScrollbar.defaultWidth", 0.019f );
		my_theme.addValueDpi( "Rae.PanedController.defaultSize", 0.010f );
		
		my_theme.addValue( "Rae.Button.curveFactor", 1.0f );
		my_theme.addValue( "Rae.Button.rectangle.curveFactor", 1.0f );
		my_theme.addValue( "Rae.Button.square.curveFactor", 0.3f );
		my_theme.addValue( "Rae.Slider.curveFactor", 1.0f );
		
		//Gradients:
		
		Gradient gradient = new Gradient();
		gradient.add( 0.0f, 224.0f/255.0f, 224.0f/255.0f, 224.0f/255.0f, 1.0f );
		gradient.add( 0.35f, 224.0f/255.0f, 224.0f/255.0f, 224.0f/255.0f, 1.0f );
		gradient.add( 0.66f, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f );
		gradient.add( 1.0f, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f );
		my_theme.addGradient("Image.GRADIENT_2", gradient);
		my_theme.addGradient("Rae.Button", gradient);
		my_theme.addGradient("Rae.Scrollbar.background", gradient);
		
		Gradient gradient2 = new Gradient();
		/*
		gradient2.add( 0.0f, 248.0f/255.0f, 248.0f/255.0f, 248.0f/255.0f, 1.0f );
		gradient2.add( 0.15f, 175.0f/255.0f, 229.0f/255.0f, 93.0f/255.0f, 1.0f );
		gradient2.add( 0.18f, 179.0f/255.0f, 234.0f/255.0f, 96.0f/255.0f, 1.0f );
		gradient2.add( 0.57f, 48.0f/255.0f, 107.0f/255.0f, 25.0f/255.0f, 1.0f );
		gradient2.add( 1.0f, 48.0f/255.0f, 107.0f/255.0f, 25.0f/255.0f, 1.0f );
		*/
		gradient2.add( 0.0f, 248.0f/255.0f, 248.0f/255.0f, 248.0f/255.0f, 1.0f );
		gradient2.add( 0.15f, 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0f );
		gradient2.add( 0.18f, 234.0f/255.0f, 234.0f/255.0f, 234.0f/255.0f, 1.0f );
		gradient2.add( 0.57f, 107.0f/255.0f, 107.0f/255.0f, 107.0f/255.0f, 1.0f );
		gradient2.add( 1.0f, 107.0f/255.0f, 107.0f/255.0f, 107.0f/255.0f, 1.0f );
		
		my_theme.addGradient("Rae.WindowHeader.Top", gradient2);
		my_theme.addGradient("Rae.Slider.control", gradient2);
		my_theme.addGradient("Rae.ProgressBar.foreground", gradient2);
		
		Gradient gradient32 = new Gradient();
		gradient32.add( 0.0f, 8.0f/255.0f, 8.0f/255.0f, 8.0f/255.0f, 1.0f );
		gradient32.add( 0.30f, 7.0f/255.0f, 7.0f/255.0f, 7.0f/255.0f, 1.0f );
		gradient32.add( 0.62f, 5.0f/255.0f, 5.0f/255.0f, 5.0f/255.0f, 1.0f );
		gradient32.add( 1.0f, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.WindowHeader.continued", gradient32);
		
		/*
		//The first menu gradient that goes to pure black.
		Gradient gradient3 = new Gradient();
		gradient3.add( 0.0f, 9.0f/255.0f, 9.0f/255.0f, 9.0f/255.0f, 1.0f );
		gradient3.add( 0.30f, 7.0f/255.0f, 7.0f/255.0f, 7.0f/255.0f, 1.0f );
		gradient3.add( 0.62f, 5.0f/255.0f, 5.0f/255.0f, 5.0f/255.0f, 1.0f );
		gradient3.add( 1.0f, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Menu", gradient3);
		*/
		
		Gradient gradient3 = new Gradient();
		gradient3.add( 0.0f, 14.0f/255.0f, 14.0f/255.0f, 14.0f/255.0f, 1.0f );
		gradient3.add( 0.30f, 11.0f/255.0f, 11.0f/255.0f, 11.0f/255.0f, 1.0f );
		gradient3.add( 0.62f, 9.0f/255.0f, 9.0f/255.0f, 9.0f/255.0f, 1.0f );
		gradient3.add( 1.0f, 8.0f/255.0f, 8.0f/255.0f, 8.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Menu", gradient3);
		
		Gradient gradient4 = new Gradient();
		gradient4.add( 0.0f, 238.0f/255.0f, 238.0f/255.0f, 238.0f/255.0f, 1.0f );
		gradient4.add( 0.22f, 238.0f/255.0f, 238.0f/255.0f, 238.0f/255.0f, 1.0f );
		gradient4.add( 0.75f, 177.0f/255.0f, 177.0f/255.0f, 177.0f/255.0f, 1.0f );
		gradient4.add( 1.0f, 75.0f/255.0f, 75.0f/255.0f, 75.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Slider.background", gradient4);
		my_theme.addGradient("Rae.ProgressBar.background", gradient4);
		
		Gradient gradient5 = new Gradient();
		gradient5.add(0.0f, 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addGradient("Rae.Button.triangle", gradient5);
		
		Gradient gradient6 = new Gradient();
		gradient6.add( 0.0f, 112.0f/255.0f, 112.0f/255.0f, 112.0f/255.0f, 1.0f );
		gradient6.add( 0.40f, 70.0f/255.0f, 70.0f/255.0f, 70.0f/255.0f, 1.0f );
		gradient6.add( 0.60f, 0.0f, 0.0f, 0.0f, 1.0f );
		gradient6.add( 0.64f, 0.0f, 0.0f, 0.0f, 1.0f );
		gradient6.add( 1.0f, 32.0f/255.0f, 60.0f/255.0f, 117.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Button.circle", gradient6);
		
		//Textures:
				
		debug(Rae) Trace.formatln("Rae.initThemes() Creating images.");
		
		Image tex = new Image( Image.GRADIENT_2 );
		
		debug(Rae) Trace.formatln("Rae.initThemes() first images created ok.");
		
		tex.name = "Image.GRADIENT_2";
		my_theme.addImage( tex, "Image.GRADIENT_2" );
		
		//debug(Rae) Trace.formatln("Rae.initThemes() adding first image.");
		//my_theme.addImage( "Rae.Button", tex );
		
		debug(Rae) Trace.formatln("Rae.initThemes() Creating more images.");
		
		my_theme.addImage( tex, "Rae.HScrollbar.background" );
		my_theme.addImage( tex, "Rae.HScrollbar.controlRect" );
		
		debug(Rae) Trace.formatln("Rae.initThemes() Creating even more images.");
		
		Image tex3 = new Image( Image.GRADIENT_2_VERTICAL );
		tex3.name = "Image.GRADIENT_2_VERTICAL";
		my_theme.addImage( tex3, "Rae.VScrollbar.background" );
		my_theme.addImage( tex3, "Rae.VScrollbar.controlRect" );
		
		debug(Rae) Trace.formatln("Rae.initThemes() Trying to create a circlebutton.");
		
		//float[4] m_textColourData = [1.0f, 1.0f, 1.0f, 1.0f];
		//Image tex2 = Image.createCircle(m_textColourData);
		Image tex2 = my_theme.createTextureForSize( my_theme.getValue("Rae.PanedController.defaultSize") );
		tex2.name = "Rae.PanedCircleButton";
		my_theme.drawCircle( tex2, my_theme.getGradient("Rae.PanedController"), my_theme.getValue("Rae.PanedController.defaultSize"), false );
		tex2.createTexture();
		my_theme.addImage( tex2, "Rae.PanedCircleButton" );
		
		/*
		Image tex4 = Image.createHalfCircleLeft(m_textColourData);
		tex4.name = "Rae.Button.leftRoundRect";
		my_theme.addImage( "Rae.Button.leftRoundRect", tex4 );
		*/
		
		debug(Rae) Trace.formatln("Rae.initThemes() Going to call my_theme.createImages (Dark theme).");
		
		my_theme.createImages();
	}
	
	void createWhiteTheme()
	{
		debug(Rae) Trace.formatln("Rae.createWhiteTheme() START.");
		debug(Rae) scope(exit) Trace.formatln("Rae.createWhiteTheme() END.");
	
		Theme my_theme = new Theme("White");
		themes.append( my_theme );
		
		//if( currentTheme is null )
		//currentTheme = my_theme;
		debug(Theme) Trace.formatln("currentThemeName: {} my_theme.name: {}", currentThemeName, my_theme.name );
		
		if( currentThemeName == my_theme.name )
		{
			Trace.formatln("Yes. Changed theme.");
			currentTheme = my_theme;
		}
		
		//my_theme.addColour( "Rae.Text", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.Text", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.Box", 0.97f, 0.97f, 0.97f, 1.0f );
		my_theme.addColour( "Rae.Menu", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.MenuItem", 0.97f, 0.97f, 0.97f, 1.0f );
		my_theme.addColour( "Rae.MenuItem.text", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.MenuItem.prelight", 0.1f, 0.2f, 0.8f, 0.6f );
		my_theme.addColour( "Rae.Button", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Button.outline", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.Button.text", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.CircleButton", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.CircleButton.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.ProgressBar", 0.7f, 0.7f, 0.7f, 1.0f );
		my_theme.addColour( "Rae.ProgressBar.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.background", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.backgroundoutline", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.control", 1.0f, 1.0f, 1.0f, 1.0f );
		//my_theme.addColour( "Rae.Slider.control", 63.0f/255.0f, 128.0f/255.0f, 74.0f/255.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.control.outline", 0.24f, 0.24f, 0.24f, 1.0f );
		my_theme.addColour( "Rae.Scrollbar", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Paned", 0.97f, 0.97f, 0.97f, 1.0f );
		my_theme.addColour( "Rae.PanedController", 0.85f, 0.85f, 0.85f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.Top", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.Bottom", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.text", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.outline", 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 0.0f );
		my_theme.addColour( "Rae.SubWindow.background", 0.98f, 0.98f, 0.98f, 1.0f );
		my_theme.addColour( "Rae.SubWindow.shadow", 0.0f, 0.0f, 0.0f, 0.6f );
		my_theme.addColour( "Rae.Canvas.background", 0.5f, 0.5f, 0.5f, 1.0f );
		my_theme.addColour( "Rae.ResizeButton", 95.0f/255.0f, 95.0f/255.0f, 95.0f/255.0f, 1.0f);
		my_theme.addColour( "Rae.ResizeButton.outline", 95.0f/255.0f, 95.0f/255.0f, 95.0f/255.0f, 0.0f );
		
		//Values:
		version(linux)
		{
			my_theme.addValueDpi( "Rae.Font.normal", 10.0f );//9.0f
			my_theme.addValueDpi( "Rae.Font.small", 7.0f );//6.0f
		}
		version(darwin)
		{
			my_theme.addValueDpi( "Rae.Font.normal", 13.5f );//9.0f
			my_theme.addValueDpi( "Rae.Font.small", 10.0f );//6.0f
		}
		version(Windows)
		{
			my_theme.addValueDpi( "Rae.Font.normal", 10.0f );//9.0f
			my_theme.addValueDpi( "Rae.Font.small", 7.0f );//6.0f
		}
		my_theme.addValueDpi( "Rae.Button.defaultHeight", 0.025f );
		my_theme.addValueDpi( "Rae.Button.rectangle.defaultHeight", 0.025f );
		my_theme.addValueDpi( "Rae.Button.square.defaultHeight", 0.050f );
		my_theme.addValueDpi( "Rae.Button.circle.defaultHeight", 0.0125f );//rename because it's misguiding. defaultTextureHeight?
		my_theme.addValueDpi( "Rae.Button.triangle.defaultHeight", 0.008f );
		my_theme.addValueDpi( "Rae.TickButton.defaultHeight", 0.0125f );
		my_theme.addValueDpi( "Rae.WindowHeader.NORMAL.defaultHeight", 0.03f );
		my_theme.addValueDpi( "Rae.WindowHeader.SMALL.defaultHeight", 0.02f );
		my_theme.addValueDpi( "Rae.HSlider.defaultHeight", 0.019f );
		my_theme.addValueDpi( "Rae.VSlider.defaultWidth", 0.019f );
		my_theme.addValueDpi( "Rae.HScrollbar.defaultHeight", 0.019f );
		my_theme.addValueDpi( "Rae.VScrollbar.defaultWidth", 0.019f );
		my_theme.addValueDpi( "Rae.PanedController.defaultSize", 0.010f );
		
		my_theme.addValue( "Rae.Button.curveFactor", 0.8f );
		my_theme.addValue( "Rae.Button.rectangle.curveFactor", 0.8f );
		my_theme.addValue( "Rae.Button.square.curveFactor", 0.3f );
		my_theme.addValue( "Rae.Slider.curveFactor", 1.0f );
		
		//Gradients:
		
		/*
		Gradient gradient = new Gradient();
		gradient.add( 0.0f, 205.0f/255.0f, 205.0f/255.0f, 205.0f/255.0f, 1.0f );
		gradient.add( 0.35f, 205.0f/255.0f, 205.0f/255.0f, 205.0f/255.0f, 1.0f );
		gradient.add( 0.66f, 168.0f/255.0f, 168.0f/255.0f, 168.0f/255.0f, 1.0f );
		gradient.add( 1.0f, 168.0f/255.0f, 168.0f/255.0f, 168.0f/255.0f, 1.0f );
		my_theme.addGradient("Image.GRADIENT_2", gradient);
		*/
		
		/*
		//Whiter:
		Gradient gradient = new Gradient();
		gradient.add( 0.0f, 255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 1.0f );
		gradient.add( 0.4f, 248.0f/255.0f, 248.0f/255.0f, 248.0f/255.0f, 1.0f );
		gradient.add( 0.6f, 175.0f/255.0f, 175.0f/255.0f, 175.0f/255.0f, 1.0f );
		gradient.add( 1.0f, 238.0f/255.0f, 238.0f/255.0f, 238.0f/255.0f, 1.0f );
		my_theme.addGradient("Image.GRADIENT_2", gradient);
		my_theme.addGradient("Rae.Button", gradient);
		my_theme.addGradient("Rae.Scrollbar.background", gradient);
		*/
		
		Gradient gradient = new Gradient();
		gradient.add( 0.0f, 234.0f/255.0f, 234.0f/255.0f, 234.0f/255.0f, 1.0f );
		gradient.add( 0.40f, 230.0f/255.0f, 230.0f/255.0f, 230.0f/255.0f, 1.0f );
		gradient.add( 0.60f, 194.0f/255.0f, 194.0f/255.0f, 194.0f/255.0f, 1.0f );
		gradient.add( 0.9f, 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 1.0f );
		gradient.add( 1.0f, 230.0f/255.0f, 230.0f/255.0f, 230.0f/255.0f, 1.0f );
		my_theme.addGradient("Image.GRADIENT_2", gradient);
		my_theme.addGradient("Rae.Button", gradient);
		my_theme.addGradient("Rae.Scrollbar.background", gradient);
		
		/*
		//Ugly green gradient:
		Gradient gradient2 = new Gradient();
		gradient2.add( 0.0f, 248.0f/255.0f, 248.0f/255.0f, 248.0f/255.0f, 1.0f );
		gradient2.add( 0.15f, 175.0f/255.0f, 229.0f/255.0f, 93.0f/255.0f, 1.0f );
		gradient2.add( 0.18f, 179.0f/255.0f, 234.0f/255.0f, 96.0f/255.0f, 1.0f );
		gradient2.add( 0.57f, 48.0f/255.0f, 107.0f/255.0f, 25.0f/255.0f, 1.0f );
		gradient2.add( 1.0f, 48.0f/255.0f, 107.0f/255.0f, 25.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.WindowHeader.Top", gradient2);
		my_theme.addGradient("Rae.Slider.control", gradient2);
		my_theme.addGradient("Rae.ProgressBar.foreground", gradient2);
		*/
		
		Gradient gradient2 = new Gradient();
		gradient2.add( 0.0f, 252.0f/255.0f, 252.0f/255.0f, 252.0f/255.0f, 1.0f );
		gradient2.add( 0.18f, 232.0f/255.0f, 232.0f/255.0f, 232.0f/255.0f, 1.0f );
		gradient2.add( 0.7f, 219.0f/255.0f, 219.0f/255.0f, 219.0f/255.0f, 1.0f );
		gradient2.add( 1.0f, 202.0f/255.0f, 202.0f/255.0f, 202.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.WindowHeader.Top", gradient2);
		my_theme.addGradient("Rae.Slider.control", gradient2);
		my_theme.addGradient("Rae.ProgressBar.foreground", gradient2);
		
		Gradient gradient32 = new Gradient();
		gradient32.add( 0.0f, 202.0f/255.0f, 202.0f/255.0f, 202.0f/255.0f, 1.0f );
		gradient32.add( 0.30f, 195.0f/255.0f, 195.0f/255.0f, 195.0f/255.0f, 1.0f );
		gradient32.add( 0.80f, 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 1.0f );
		gradient32.add( 1.0f, 180.0f/255.0f, 180.0f/255.0f, 180.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.WindowHeader.continued", gradient32);
		
		Gradient gradient3 = new Gradient();
		gradient3.add( 0.0f, 254.0f/255.0f, 254.0f/255.0f, 254.0f/255.0f, 1.0f );
		gradient3.add( 0.30f, 252.0f/255.0f, 252.0f/255.0f, 252.0f/255.0f, 1.0f );
		gradient3.add( 0.62f, 250.0f/255.0f, 250.0f/255.0f, 250.0f/255.0f, 1.0f );
		gradient3.add( 1.0f, 235.0f/255.0f, 235.0f/255.0f, 235.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Menu", gradient3);
		
		Gradient gradient4 = new Gradient();
		gradient4.add( 0.0f, 75.0f/255.0f, 75.0f/255.0f, 75.0f/255.0f, 1.0f );
		gradient4.add( 0.22f, 177.0f/255.0f, 177.0f/255.0f, 177.0f/255.0f, 1.0f );
		gradient4.add( 0.75f, 238.0f/255.0f, 238.0f/255.0f, 238.0f/255.0f, 1.0f );
		gradient4.add( 1.0f, 238.0f/255.0f, 238.0f/255.0f, 238.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Slider.background", gradient4);
		my_theme.addGradient("Rae.ProgressBar.background", gradient4);
		
		Gradient gradient5 = new Gradient();
		gradient5.add(0.0f, 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addGradient("Rae.Button.triangle", gradient5);
		
		Gradient gradient6 = new Gradient();
		gradient6.add( 0.0f, 112.0f/255.0f, 112.0f/255.0f, 112.0f/255.0f, 1.0f );
		gradient6.add( 0.40f, 70.0f/255.0f, 70.0f/255.0f, 70.0f/255.0f, 1.0f );
		gradient6.add( 0.60f, 0.0f, 0.0f, 0.0f, 1.0f );
		gradient6.add( 0.64f, 0.0f, 0.0f, 0.0f, 1.0f );
		gradient6.add( 1.0f, 32.0f/255.0f, 60.0f/255.0f, 117.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Button.circle", gradient6);
		
		//Textures:
		
		debug(Rae) Trace.formatln("Rae.initThemes() Creating images.");
		
		Image tex = new Image( Image.GRADIENT_2 );
		
		debug(Rae) Trace.formatln("Rae.initThemes() first images created ok.");
		
		tex.name = "Image.GRADIENT_2";
		my_theme.addImage( tex, "Image.GRADIENT_2" );
		
		//debug(Rae) Trace.formatln("Rae.initThemes() adding first image.");
		//my_theme.addImage( "Rae.Button", tex );
		
		debug(Rae) Trace.formatln("Rae.initThemes() Creating more images.");
		
		my_theme.addImage( tex, "Rae.HScrollbar.background" );
		my_theme.addImage( tex, "Rae.HScrollbar.controlRect" );
		
		debug(Rae) Trace.formatln("Rae.initThemes() Creating even more images.");
		
		Image tex3 = new Image( Image.GRADIENT_2_VERTICAL );
		tex3.name = "Image.GRADIENT_2_VERTICAL";
		my_theme.addImage( tex3, "Rae.VScrollbar.background" );
		my_theme.addImage( tex3, "Rae.VScrollbar.controlRect" );
		
		//float[4] m_textColourData = [1.0f, 1.0f, 1.0f, 1.0f];
		//Image tex2 = Image.createCircle(m_textColourData);
		Image tex2 = my_theme.createTextureForSize( my_theme.getValue("Rae.PanedController.defaultSize") );
		tex2.name = "Rae.PanedCircleButton";
		my_theme.drawCircle( tex2, my_theme.getGradient("Rae.PanedController"), my_theme.getValue("Rae.PanedController.defaultSize"), false );
		tex2.createTexture();
		my_theme.addImage( tex2, "Rae.PanedCircleButton" );
		
		//Image tex4 = Image.createHalfCircleLeft(m_textColourData);
		//tex4.name = "Rae.Button.leftRoundRect";
		//my_theme.addImage( "Rae.Button.leftRoundRect", tex4 );
		
		//Image test1 = new Image( Image.RGB_TEST );
		//test1.name = "Image.RGB_TEST";
		//my_theme.addImage( "Rae.Button", test1 );
		
		my_theme.createImages();
		
	}

	void createFlatTheme()
	{
		debug(Rae) Trace.formatln("Rae.createFlatTheme() START.");
		debug(Rae) scope(exit) Trace.formatln("Rae.createFlatTheme() END.");
		
		Theme my_theme = new Theme("Flat");
		themes.append( my_theme );
		
		if( currentTheme is null )
			m_currentTheme = my_theme;
			
		if( currentThemeName == my_theme.name )
			currentTheme = my_theme;
		
		my_theme.addColour( "Rae.Text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Box", 0.18f, 0.18f, 0.18f, 1.0f );
		my_theme.addColour( "Rae.Menu", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.MenuItem", 0.18f, 0.18f, 0.18f, 1.0f );
		//my_theme.addColour( "Rae.MenuItem", 0.88f, 0.88f, 0.88f, 1.0f );
		my_theme.addColour( "Rae.MenuItem.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.MenuItem.prelight", 0.2f, 0.8f, 0.3f, 0.6f );
		my_theme.addColour( "Rae.Button", 0.1f, 0.1f, 0.1f, 1.0f );
		my_theme.addColour( "Rae.Button.outline", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.Button.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.CircleButton", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.CircleButton.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.ProgressBar", 0.12f, 0.12f, 0.12f, 1.0f );
		my_theme.addColour( "Rae.ProgressBar.text", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.background", 0.12f, 0.12f, 0.12f, 1.0f );
		my_theme.addColour( "Rae.Slider.backgroundoutline", 0.0f, 0.0f, 0.0f, 1.0f );
		//my_theme.addColour( "Rae.Slider.control", 63.0f/255.0f, 128.0f/255.0f, 74.0f/255.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.control", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.Slider.control.outline", 0.24f, 0.24f, 0.24f, 1.0f );
		my_theme.addColour( "Rae.Scrollbar", 0.12f, 0.12f, 0.12f, 1.0f );
		my_theme.addColour( "Rae.Paned", 0.12f, 0.12f, 0.12f, 1.0f );
		my_theme.addColour( "Rae.PanedController", 0.25f, 0.25f, 0.25f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.Top", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.Bottom", 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.text", 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addColour( "Rae.WindowHeader.outline", 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 0.0f );
		//my_theme.addColour( "Rae.SubWindow.background", 0.18f, 0.18f, 0.18f, 1.0f );
		my_theme.addColour( "Rae.SubWindow.background", 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 1.0f );
		my_theme.addColour( "Rae.SubWindow.shadow", 0.0f, 0.0f, 0.0f, 0.6f );
		my_theme.addColour( "Rae.Canvas.background", 0.12f, 0.12f, 0.12f, 1.0f );
		//my_theme.addColour( "Rae.ResizeButton", 63.0f/255.0f, 128.0f/255.0f, 74.0f/255.0f, 1.0f );
		my_theme.addColour( "Rae.ResizeButton", 128.0f/255.0f, 128.0f/255.0f, 128.0f/255.0f, 1.0f );
		my_theme.addColour( "Rae.ResizeButton.outline", 128.0f/255.0f, 128.0f/255.0f, 128.0f/255.0f, 0.0f );
		
		//Values:
		version(linux)
		{
			my_theme.addValueDpi( "Rae.Font.normal", 10.0f );//9.0f
			my_theme.addValueDpi( "Rae.Font.small", 7.0f );//6.0f
		}
		version(darwin)
		{
			my_theme.addValueDpi( "Rae.Font.normal", 13.5f );//9.0f
			my_theme.addValueDpi( "Rae.Font.small", 10.0f );//6.0f
		}
		version(Windows)
		{
			my_theme.addValueDpi( "Rae.Font.normal", 10.0f );//9.0f
			my_theme.addValueDpi( "Rae.Font.small", 7.0f );//6.0f
		}
		my_theme.addValueDpi( "Rae.Button.defaultHeight", 0.025f );
		my_theme.addValueDpi( "Rae.Button.rectangle.defaultHeight", 0.025f );
		my_theme.addValueDpi( "Rae.Button.square.defaultHeight", 0.050f );
		my_theme.addValueDpi( "Rae.Button.circle.defaultHeight", 0.0125f );
		my_theme.addValueDpi( "Rae.Button.triangle.defaultHeight", 0.008f );
		my_theme.addValueDpi( "Rae.TickButton.defaultHeight", 0.0125f );
		my_theme.addValueDpi( "Rae.WindowHeader.NORMAL.defaultHeight", 0.03f );
		my_theme.addValueDpi( "Rae.WindowHeader.SMALL.defaultHeight", 0.02f );
		my_theme.addValueDpi( "Rae.HSlider.defaultHeight", 0.019f );
		my_theme.addValueDpi( "Rae.VSlider.defaultWidth", 0.019f );
		my_theme.addValueDpi( "Rae.HScrollbar.defaultHeight", 0.019f );
		my_theme.addValueDpi( "Rae.VScrollbar.defaultWidth", 0.019f );
		my_theme.addValueDpi( "Rae.PanedController.defaultSize", 0.010f );
		
		my_theme.addValue( "Rae.Button.curveFactor", 0.5f );
		my_theme.addValue( "Rae.Button.rectangle.curveFactor", 0.5f );
		my_theme.addValue( "Rae.Button.square.curveFactor", 0.3f );
		my_theme.addValue( "Rae.Slider.curveFactor", 1.0f );
		
		//my_theme.addValue("Rae.SubWindow.isDrawContainer", true );
		
		//Gradients:
		
		Gradient gradient = new Gradient();
		gradient.add( 0.0f, 0.0f, 0.0f, 0.0f, 1.0f );
		gradient.add( 1.0f, 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addGradient("Image.GRADIENT_2", gradient);
		my_theme.addGradient("Rae.Button", gradient);
		my_theme.addGradient("Rae.Scrollbar.background", gradient);
		
		Gradient gradient2 = new Gradient();
		/*
		gradient2.add( 0.0f, 248.0f/255.0f, 248.0f/255.0f, 248.0f/255.0f, 1.0f );
		gradient2.add( 0.15f, 175.0f/255.0f, 229.0f/255.0f, 93.0f/255.0f, 1.0f );
		gradient2.add( 0.18f, 179.0f/255.0f, 234.0f/255.0f, 96.0f/255.0f, 1.0f );
		gradient2.add( 0.57f, 48.0f/255.0f, 107.0f/255.0f, 25.0f/255.0f, 1.0f );
		gradient2.add( 1.0f, 48.0f/255.0f, 107.0f/255.0f, 25.0f/255.0f, 1.0f );
		*/
		gradient2.add( 0.0f, 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 1.0f );
		gradient2.add( 1.0f, 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 1.0f );
		
		my_theme.addGradient("Rae.WindowHeader.Top", gradient2);
		my_theme.addGradient("Rae.Slider.control", gradient2);
		my_theme.addGradient("Rae.ProgressBar.foreground", gradient2);
		
		Gradient gradient32 = new Gradient();
		//gradient32.add( 0.0f, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f );
		//gradient32.add( 1.0f, 2.0f/255.0f, 2.0f/255.0f, 2.0f/255.0f, 1.0f );
		gradient32.add( 0.0f, 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 1.0f );
		gradient32.add( 1.0f, 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.WindowHeader.continued", gradient32);
		
		/*
		//The first menu gradient that goes to pure black.
		Gradient gradient3 = new Gradient();
		gradient3.add( 0.0f, 9.0f/255.0f, 9.0f/255.0f, 9.0f/255.0f, 1.0f );
		gradient3.add( 0.30f, 7.0f/255.0f, 7.0f/255.0f, 7.0f/255.0f, 1.0f );
		gradient3.add( 0.62f, 5.0f/255.0f, 5.0f/255.0f, 5.0f/255.0f, 1.0f );
		gradient3.add( 1.0f, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Menu", gradient3);
		*/
		
		Gradient gradient3 = new Gradient();
		gradient3.add( 0.0f, 14.0f/255.0f, 14.0f/255.0f, 14.0f/255.0f, 1.0f );
		gradient3.add( 0.30f, 11.0f/255.0f, 11.0f/255.0f, 11.0f/255.0f, 1.0f );
		gradient3.add( 0.62f, 4.0f/255.0f, 4.0f/255.0f, 4.0f/255.0f, 1.0f );
		gradient3.add( 1.0f, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Menu", gradient3);
		
		Gradient gradient4 = new Gradient();
		gradient4.add( 0.0f, 105.0f/255.0f, 105.0f/255.0f, 105.0f/255.0f, 1.0f );
		gradient4.add( 1.0f, 105.0f/255.0f, 105.0f/255.0f, 105.0f/255.0f, 1.0f );
		my_theme.addGradient("Rae.Slider.background", gradient4);
		my_theme.addGradient("Rae.ProgressBar.background", gradient4);
		
		Gradient gradient5 = new Gradient();
		gradient5.add(0.0f, 1.0f, 1.0f, 1.0f, 1.0f );
		my_theme.addGradient("Rae.Button.triangle", gradient5);
		
		Gradient gradient6 = new Gradient();
		gradient6.add( 0.0f, 0.0f, 0.0f, 0.0f, 1.0f );
		gradient6.add( 1.0f, 0.0f, 0.0f, 0.0f, 1.0f );
		my_theme.addGradient("Rae.Button.circle", gradient6);
		
		//Textures:
				
		debug(Rae) Trace.formatln("Rae.initThemes() Creating images.");
		
		Image tex = new Image( Image.GRADIENT_2 );
		
		debug(Rae) Trace.formatln("Rae.initThemes() first images created ok.");
		
		tex.name = "Image.GRADIENT_2";
		my_theme.addImage( tex, "Image.GRADIENT_2" );
		
		//debug(Rae) Trace.formatln("Rae.initThemes() adding first image.");
		//my_theme.addImage( "Rae.Button", tex );
		
		debug(Rae) Trace.formatln("Rae.initThemes() Creating more images.");
		
		my_theme.addImage( tex, "Rae.HScrollbar.background" );
		my_theme.addImage( tex, "Rae.HScrollbar.controlRect" );
		
		debug(Rae) Trace.formatln("Rae.initThemes() Creating even more images.");
		
		Image tex3 = new Image( Image.GRADIENT_2_VERTICAL );
		tex3.name = "Image.GRADIENT_2_VERTICAL";
		my_theme.addImage( tex3, "Rae.VScrollbar.background" );
		my_theme.addImage( tex3, "Rae.VScrollbar.controlRect" );
		
		debug(Rae) Trace.formatln("Rae.initThemes() Trying to create a circlebutton.");
		
		//float[4] m_textColourData = [1.0f, 1.0f, 1.0f, 1.0f];
		//Image tex2 = Image.createCircle(m_textColourData);
		Image tex2 = my_theme.createTextureForSize( my_theme.getValue("Rae.PanedController.defaultSize") );
		tex2.name = "Rae.PanedCircleButton";
		my_theme.drawCircle( tex2, my_theme.getGradient("Rae.PanedController"), my_theme.getValue("Rae.PanedController.defaultSize"), false );
		tex2.createTexture();
		my_theme.addImage( tex2, "Rae.PanedCircleButton" );
		
		/*
		Image tex4 = Image.createHalfCircleLeft(m_textColourData);
		tex4.name = "Rae.Button.leftRoundRect";
		my_theme.addImage( "Rae.Button.leftRoundRect", tex4 );
		*/
		
		debug(Rae) Trace.formatln("Rae.initThemes() Going to call my_theme.createImages (Dark theme).");
		
		my_theme.createImages();
	}
	
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
