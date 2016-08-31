	/******************************************************************************* 

    Window module allows access to the game window. 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Window allows opening and closing of window with user given parameters. 
	Window also contains code to take a screenshot of itself, retrieve its 
	dimensions, resize itself and alter its coordinate system.

	Examples:
	--------------------
	import arc.window; 

	int main() 
	{
		// initialize SDL/OpenGL window 
		// read window parameters from a lua configuration file
		arc.window.open("Title", width, height, bFullScreen); 

		// take a screenshot of current window and save it as a bitmap
		arc.window.screenshot("screen1");
	   
		// toggle between full screen and window mode (linux only)
		arc.window.toggleFullScreen();

		// resize window with given width and height (currently texture information is lost on Windows)
		arc.window.resize(width, height)
	   
		// get window's height and width
		arc.window.getHeight/getWidth; 
	   
		while (gameloop)
		{
			// clear contents of window
			arc.window.clear();
			
			// draw stuff to the screen 
			
			// switch to next window frame
			arc.window.swap();
		}

		// closes the window
		arc.window.close(); 

	   return 0;
	}
	--------------------

*******************************************************************************/

module arc.window;

/*******************************************************************************

   Import all we need from the std library

*******************************************************************************/
import	std.string:cmp,toStringz;
import 	std.c: memcpy, exit;
import 	std.io; 

import
	arc.math.point,
	arc.math.rect,
	arc.types,
	arc.memory.routines; 

/*******************************************************************************

   Import all we need from derelict 

*******************************************************************************/
import 	
	derelict.opengl.gl,
	derelict.opengl.glu,
	derelict.sdl.sdl,
	derelict.sdl.image,
	derelict.util.exception;

/*******************************************************************************

	Opens a window with the given size and initializes OpenGL

*******************************************************************************/
void open(char[] argTitle, int argWidth, int argHeight, bool argFullscreen);
/*******************************************************************************

	Close SDL window and delete the screen

*******************************************************************************/
void close();

/// Returns window width
int getWidth() ;

/// Returns window height
int getHeight();

/// returns window size
Size getSize();

/// Returns true if window is fullscreen
bool isFullScreen();

/// get the window screen
SDL_Surface* getScreen();

/*******************************************************************************

	Resize window to desired width and height

*******************************************************************************/
void resize(int argWidth, int argHeight);

/*******************************************************************************

	Toggle between fullscreen and windowed mode; linux only

*******************************************************************************/
void toggleFullScreen();

/// clear the screen
void clear();
/// swap the screen buffers
void swap();

/// swap and clear the screen, equivalent to calling swap() and then clear()
void swapClear();

/*******************************************************************************

	Captures a screenshot and saves in BMP format to current directory

*******************************************************************************/
void screenshot(char[] argName);


/**
	Offers functionality for dealing with the coordinate system.
	
	By default the origin (0,0) is in the top-left corner, x faces right, y down.
	By default, the bottom-right corner has the coordinates (800,600).
	
	This is mainly intended to allow the customization of the coordinate
	system at startup and on window resizes. 

	It is not recommended to use this for scrolling: since these
	functions alter the global coordinate system, you will have no
	control over what scrolls and what doesn't. Use the scenegraph
	with a Transform node for selective scrolling.
**/
struct coordinates
{
	/// sets the virtual size of the screen
	static void setSize(Size argsize);
	/// sets the coordinates for the top-left corner of the screen
	static void setOrigin(Point argorigin);
	/// gets the virtual screen size
	static Size getSize();
	static arcfl getWidth();
	static arcfl getHeight();
	/// gets the coordinates of the top-left corner of the screen
	static Point getOrigin();				
	
private:
	static Size size;
	static Point origin;
	
	/// setup the projection and modelview matrices
	static void setupGLMatrices();
}


private
{
	/*******************************************************************************

		Initialize SDL

	*******************************************************************************/
	void initializeSDL();
	/*******************************************************************************

		Query's SDL for the current video info (desktop), extracts bpp and sets
				bpp to what it found it was, this way the color depth is the color depth
				the user uses from the desktop, and it should not crash

	*******************************************************************************/
	void setupPixelDepth();
	/*******************************************************************************

		Prints a slew of graphics driver and extension debug info

	*******************************************************************************/
	debug
	{
		void printVendor();
	}

	/*******************************************************************************

		Derelict is a library that allows me to load all my library functions at
				run time, and displaying a proper message if any single library fails 
				to load, a message like "Can't find library %s, go get it at %s"

	*******************************************************************************/
	void loadDerelict();
	
	// unload derelict 
	void unloadDerelict();
	/*******************************************************************************

		Sets up the pixel format the way we like it

	*******************************************************************************/
	void setupPixelFormat();


	/*******************************************************************************

		Resizes the openGL viewport and reinitializes its matrices. 
		Also resets GL states.

	*******************************************************************************/
	void resizeGL();
	/// initialize OpenGL parameters required to draw 
	void setGLStates();
	
	// skips trying to load glXGetProcAddress if it could not find it
	bool handleMissingOpenGL(char[] libName, char[] procName);
	/*******************************************************************************
	
		Private vars we hide inside the module
	
	*******************************************************************************/
	
	// window info
	char[] wTitle;
	int wWidth, wHeight;
	bool wFullscreen = false;

	// SDL info
	SDL_Surface *screen = null;
	int bpp = 0;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
