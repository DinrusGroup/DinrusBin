/******************************************************************************* 

    Implementation of Mouse for Arc Input

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Implementation of Mouse for Arc Input, not to be used seperately.
		

	Examples:
	--------------------
		Not provided.
	--------------------

*******************************************************************************/

module arc.internals.input.mouse;

import 
	arc.internals.input.constants,
	arc.internals.input.signals,
	arc.input,
	arc.math.point,
	arc.types;

import 
	derelict.sdl.sdltypes,
	derelict.sdl.sdl;

/*******************************************************************************

	Mouse structure to hold all the information in a mouse.

*******************************************************************************/
struct Mouse
{
	/**
		The first set of coordinates, 'real world' coordinates, are used to tell
		where the mouse is no matter the size of the window.
	**/
	int x = 0, y = 0;
	int oldX = 0, oldY = 0;

	/** 
		The '2D' coordinates, aka virtual coordinates, stay the same relative to the
		window, so the window can be resized and the relative coordinates stay the
		same, making them good for 2D gui's.
	**/
	arcfl x2D = 0, y2D = 0;
	arcfl oldX2D = 0, oldY2D = 0;

	/**
		The next bool tells us whether or not the mouse has been moving. It is useful
		so you can say, that if the mouse is moving, move a window with it.
	**/
	bool moving = false;

	/// array of button information
	KeyStatus[MAXMOUSEBUTTON] buttonStatus;

	/// set default cursor visibility
	void setDefaultCursorVisible(bool argV)
	{
		if(argV)
			SDL_ShowCursor(SDL_ENABLE);
		else
			SDL_ShowCursor(SDL_DISABLE);
	}
	
	/*******************************************************************************

		Properly handle mouse motion

		NOTE: 	Virtual coordinates make it so a smaller or bigger window
				keeps the same relative mouse coordinates, whether it be 800x600 or
				anything else they are used so you can click on gui objects when they
				are resized by OpenGL.

	*******************************************************************************/
	void handleMotion(inout SDL_Event event)
	{
		moving = true;

		oldX = x;
		oldY = y;

		x = event.button.x;
		y = event.button.y;

		oldX2D = x2D;
		oldY2D = y2D;

		x2D = x/(arc.window.getWidth/arc.window.coordinates.getWidth) + arc.window.coordinates.getOrigin.x;
		y2D = y/(arc.window.getHeight/arc.window.coordinates.getHeight) + arc.window.coordinates.getOrigin.y;
		
		// emit signal
		arc.internals.input.signals.signals.mouseMove.emit(Point(x2D, y2D));
	}
	
		
	/*******************************************************************************

			Clear all data in the hit bool array

	*******************************************************************************/
	void clearHit()
	{
		for (int i = 0; i < MAXMOUSEBUTTON; ++i)
			buttonStatus[i] &= KeyStatus.DOWN;
	}


	/*******************************************************************************

			Clear all data in the button

	*******************************************************************************/
	void clear()
	{
		for (int i = 0; i < MAXMOUSEBUTTON; ++i)
			buttonStatus[i] = KeyStatus.UP;
	}


	/*******************************************************************************

			Properly handle mouse when mouse is down

	*******************************************************************************/
	void handleButtonDown(inout SDL_MouseButtonEvent event)
	{
		// if the button is already down, nothing needs to be done
		if(buttonStatus[event.button] & KeyStatus.DOWN != 0)
			return;
	
		// any button was hit
		buttonStatus[ANYBUTTON] |= KeyStatus.PRESSED;
		
		// set the 'down' and 'pressed' bits
		buttonStatus[event.button] |= KeyStatus.DOWN | KeyStatus.PRESSED;
		
		// raise signal
		arc.internals.input.signals.signals.mouseButtonDown.emit(event.button, Point(x2D, y2D));
	}

	/*******************************************************************************

			Properly handle mouse when button goes up

	*******************************************************************************/
	void handleButtonUp(inout SDL_MouseButtonEvent event)
	{
		// if the button is already up, nothing needs to be done
		if(buttonStatus[event.button] & KeyStatus.DOWN == 0)
			return;
		
		// any button was released
		buttonStatus[ANYBUTTON] |= KeyStatus.RELEASED;
	
		// unset 'down' bit, set the 'released' bit
		buttonStatus[event.button] &= KeyStatus.PRESSED | KeyStatus.RELEASED;
		buttonStatus[event.button] |= KeyStatus.RELEASED;

		// raise signal
		arc.internals.input.signals.signals.mouseButtonUp.emit(event.button, Point(x2D, y2D));
	}

} // struct Mouse

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
