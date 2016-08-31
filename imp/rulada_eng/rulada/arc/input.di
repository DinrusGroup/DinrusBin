/******************************************************************************* 

    Input module allows access to the keyboard and the mouse. 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
        The input module allows the user access to keyboard, mouse and joystick.
	Input must be processed once every frame. Use keyPressed methods to tell 
	if user only lightly pressed their key. Use keyDown methods to tell if 
	user is holding a key down. Use keyReleased to tell when user has released
	a key. 

    Examples:
    -------------------------------------------------------------------------------
    import arc.input;

int main() {
	
	// initializes input
	arc.input.open();
	arc.input.openJoysticks();
	
	// while the user hasn't closed the window
	while (!arc.input.keyDown(ARC_QUIT))
	{
		// get current input from user
		arc.input.process();

		// user lightly taps 't' key
		arc.input.keyPressed('t'); // a-z, SDLK_a-SDLK_z
		
		// user holds down 't' key
		arc.input.keyDown('t');

		// user lightly clicks right mouse button
		arc.input.mouseButtonPressed(RIGHT);

		// user holds down left mouse button
		arc.input.mouseButtonDown(LEFT) // RIGHT and MIDDLE work as well

		// returns true if user hits a character
		if (arc.input.charHit) {
			// returns the last characters the user hit
			char[] ch = arc.input.lastChars; 
		}

		// returns position of mouse
		arc.input.mouseX; // .mouseY  .mouseOldY  .mouseOldX 

		// returns true if mouse is in motion
		arc.input.mouseMotion; 

		// returns true if mouse is wheeling up
		// wheelDown - returns true on mouse Wheelup and Wheeldown
		arc.input.wheelUp; 

		foreach(stick; joysticksIter)
		{
			foreach(button; arc.input.joyButtonsDown(stick))
				writefln("button ", button, " pressed on joystick ", stick );
			foreach(button; arc.input.joyButtonsUp(stick))
				writefln("button ", button, " released on joystick ", stick );
			foreach(pos, axis; joyAxesMove(stick))
				writefln("axis ", axis, " moved to ", pos, " on joystick ", stick );
		}
	

		// close doesn't actually do anything now
        arc.input.close(); 
        
        return 0;
    }
    -------------------------------------------------------------------------------


*******************************************************************************/

module arc.input;

// import input key identifiers
import
	derelict.sdl.sdl,
	derelict.sdl.keysym;
	//derelict.sdl.events; 

// Input uses window when user resizes the window
import 
	arc.window,
	arc.log,
	arc.types,
	arc.math.point; 

// Let user have constants used in input
public import arc.internals.input.constants;

// Import mouse and keyboard structs internally
import 
	arc.internals.input.keyboard,
	arc.internals.input.mouse,
	arc.internals.input.joystick;

import std.math : abs;
import std.string : toString;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                      PUBLIC INTERFACE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
public {

/// clear's input, gets current modifiers, enables unicode and disables key repeat
void open(bool keyRepeat=true);

/// implementation just for symmetry, does not do anything
void close();

//
// keyboard configuration methods
//

/// sets keyboard repeat on or off
void setKeyboardRepeat(bool onoff);

//
// keyboard query methods
//

/// returns the full KeyStatus information for the key
KeyStatus keyStatus(int keyNum);
/// test if is set
private bool isSet(T)(T state, T flag) ;
/// returns true when key has gone from up to down between calls to process
bool keyPressed(int keyNum);
/// returns true when key has gone from down to up between calls to process
bool keyReleased(int keyNum);
/// returns true when key is physically down
bool keyDown(int keyNum) ;
/// returns true when key is physically up
bool keyUp(int keyNum);
/// returns true if user has hit a character on the keyboard between two calls to process
bool charHit();
/// returns characters hit by the user between two process calls
char[] lastChars();


//
// mouse query methods
//

/// returns full KeyStatus information for the button
KeyStatus mouseButtonStatus(int keyNum);

/// returns true if mouse button has gone from up to down between calls to process
bool mouseButtonPressed(int keyNum) ;
/// returns true if mouse button has gone from down to up between calls to process
bool mouseButtonReleased(int keyNum);
/// returns true if user holds mouse button down
bool mouseButtonDown(int keyNum);
/// returns true if user doesn't hold mouse button down
bool mouseButtonUp(int keyNum);

// NOTE: for the arc 2D game engine, mouse.x and mouse.y are only used 
//       to help determine the virtual coordinates.
//       for 3D games, you may want to use mouse.x and mouse.y
//       but for 2D games, there is never a need to, so mouseX and mouseX2D
//       will return the same values

/// mouseX position 
arcfl mouseX();
/// mouseY position 
arcfl mouseY() ;
/// mouse position
Point mousePos();
/// old mouse X position 
arcfl mouseOldX() ;
/// old mouse Y position 
arcfl mouseOldY()  ;
/// old mouse position
Point mouseOldPos() ;

/// returns true when mouse is moving
bool mouseMotion()  ;

/// set mouse cursor visibility
void defaultCursorVisible(bool argV);

/// returns true when mouse is wheeling up
bool wheelUp()   ;
/// returns true when mouse is wheeling down
bool wheelDown() ;


//
// joystick configuration
//

/// JoyStick Exception Class 
class JoystickException : Exception
{
	this(char[] msg)
	{
		super(msg);
	}
}

/// returns the number of joysticks that are plugged in
ubyte numJoysticks();
/*******************************************************************************

	Joysticks have to be opened with this function before they can be used.
	Use numJoysticks() to query the number of sticks (or gamepads) that are
	plugged in. Joysticks are identified by a number, starting from 0. Either
	specify a joystick by index to be opened, or call this function without
	any arguments to open all available joysticks.
	The number of joysticks that are actually opened is returned.
	
	Use numJoysticks to query the number of sticks or pads that are plugged in.

*******************************************************************************/
int openJoysticks(int index = -1);
/// The counterpart to openJoysticks.
void closeJoysticks(int index = -1);
//
// joystick query methods
//

/// returns whether button is currently down on joystick index (button numbers start from 0)
/// button must be smaller than numJoystickButtons(index) or a runtime error will result.
bool joyButtonDown(ubyte index, ubyte button);
/// returns whether button is up, see joyButtonDown for details
bool joyButtonUp(ubyte index, ubyte button);
/// returns whether button has been pressed since last call to process
bool joyButtonPressed(ubyte index, ubyte button);
/// returns whether button has been released since last call to process
bool joyButtonReleased(ubyte index, ubyte button);

/** returns position of axis on joystick index (axes numbers start from 0)
  axis must be smaller than numJoystickAxes(index) or a runtime error will result.
 
 The value returned is the current position of the axis, which is in the range of -1.0f to 1.0f epsilon (give or take)
 An exact value of 0.0f has a special meaning: in this case there was no axis movement at all
 */
arcfl joyAxisMoved(ubyte index, ubyte axis);

/// iterate over all open joysticks
int delegate(int delegate(inout ubyte)) joysticksIter;

/// iterate over currently down on joystick index
/// throws: JoystickException if index is not valid
Joysticks.Joystick.ButtonIterator joyButtonsDown(ubyte index);

/// iterate over buttons currently up on joystick index
/// throws: JoystickException if index is not valid
Joysticks.Joystick.ButtonIterator joyButtonsUp(ubyte index);

/// iterate over buttons on joystick index that were pressed since last call to process
/// throws: JoystickException if index is not valid
Joysticks.Joystick.ButtonIterator joyButtonsPressed(ubyte index);

/// iterate over buttons on joystick index that were released since last call to process
/// throws: JoystickException if index is not valid
Joysticks.Joystick.ButtonIterator joyButtonsReleased(ubyte index);

/// iterate over axes moved on joystick index since last call to process
int delegate(int delegate(inout ubyte axis, inout arcfl)) joyAxesMoved(ubyte index);

/// number of buttons on joystick index or 0 if joystick is not opened
ubyte numJoystickButtons(ubyte index);
/// number of axes on joystick index or 0 if joystick is not opened
ubyte numJoystickAxes(ubyte index);

/// vendor specific string describing this device or empty string if joystick is not opened
char[] joystickName(ubyte index);
/// true if this joystick has been opened, false otherwise
bool isJoystickOpen(ubyte index);

/// 
void setAxisThreshold(arcfl threshold);

//
// other methods
//

/// return whether SDL window has lost focus 
bool lostFocus() ;

/// force quit of application
void quit();

/// returns true if quitting 
bool isQuit();


/// Capture input from user
void process();

} // public

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                      PRIVATE INTERNALS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

private {
	// whether or not input has focus
	bool focus;
	Joysticks joysticks;
	KeyBoard keyboard;
	Mouse mouse;
} // private

static this()
{
	joysticksIter = &joysticks.opApply;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
