/******************************************************************************* 

    Implementation of Mouse for Arc Input

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Implementation of Keyboard for Arc Input, not to be used seperately.
		

	Examples:
	--------------------
		Not provided.
	--------------------

*******************************************************************************/

module arc.internals.input.keyboard;

import 
	arc.internals.input.constants,
	arc.internals.input.signals,
	arc.input,
	arc.types; 
	
import derelict.sdl.sdltypes;

/*******************************************************************************

	Holds all data inside the keyboard

*******************************************************************************/
struct KeyBoard
{
	KeyStatus status[ARC_LAST];
	
	const char CHARNULL = cast(char)0;
	
	/// whether any character was hit between two process calls
	bool charHit = false;
	
	/// holds the characters hit between two process calls
	char[] lastChars;


	/*******************************************************************************

			Clear all data in the hit array

	*******************************************************************************/
	void clearHit()
	{
			charHit = false;
			lastChars.length = 0;
			for (int i = 0; i < ARC_LAST; i++)
				status[i] &= KeyStatus.DOWN;
	}

	/*******************************************************************************

			clear all data inside this structure

	*******************************************************************************/
	void clear()
	{
			clearHit();
			for (int i = 0; i < ARC_LAST; i++)
				status[i] = KeyStatus.UP;
	}

	/*******************************************************************************

			Handle keyboard when keys are pressed

	*******************************************************************************/
	void handleKeyDown(SDL_KeyboardEvent event)
	{
		// evaluate if this does make sense
		status[ANYKEY] |= KeyStatus.DOWN | KeyStatus.PRESSED; // anykey hit
		
		// set 'down' and 'pressed' bits
		status[event.keysym.sym] |= KeyStatus.DOWN | KeyStatus.PRESSED;

		charHit = true;

		if ( event.keysym.unicode ) // if character needs to be translated
		{
			lastChars ~= cast(char)(event.keysym.unicode); // store the translated character
		}
		
		// emit signal
		arc.internals.input.signals.signals.keyDown.emit(event.keysym.sym);
	}

	/*******************************************************************************

			Handle keyboard when keys are released

	*******************************************************************************/
	void handleKeyUp(inout SDL_KeyboardEvent event)
	{
		// evaluate if this does make sense
		status[ANYKEY] |= KeyStatus.UP | KeyStatus.RELEASED; // some key was released
		
		// unset 'down' bit, set the 'released' bit
		status[event.keysym.sym] &= KeyStatus.PRESSED | KeyStatus.RELEASED;
		status[event.keysym.sym] |= KeyStatus.RELEASED;
		
		// emit signal
		arc.internals.input.signals.signals.keyUp.emit(event.keysym.sym);
	}
} // struct KeyBoard

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
