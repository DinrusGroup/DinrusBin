/// this module is an implementation detail of arc.input, don't use it seperately
module arc.internals.input.joystick;

import
	arc.internals.input.constants,
	arc.internals.input.signals,
	arc.types;

import 
	derelict.sdl.sdltypes,
	derelict.sdl.sdl;

import std.string : toString;

/*******************************************************************************

	Structure that holds all state concerning joysticks as well as 
	internal operations

*******************************************************************************/

struct Joysticks
{
	/*******************************************************************************

		Structure representing state of a joystick

	*******************************************************************************/
	struct Joystick
	{
		struct ButtonIterator
		{
			KeyStatus status;
			Joystick* joystick;
			
			int opApply(int delegate(inout ubyte) dg)
			{
				int result = 0;
				if (joystick is null)
					return result;
				
				for (ubyte i = 0; i < joystick.buttonStatus.length; i++)
				{
					if (status != KeyStatus.UP && joystick.buttonStatus[i] & status != 0
						|| status == KeyStatus.UP && joystick.buttonStatus[i] & KeyStatus.DOWN == 0 )
					{
						result = dg(i);
						if (result)
							break;
					}
				}
				return result;				
			}
		}
		
		ButtonIterator makeButtonIterator(KeyStatus status)
		{
			ButtonIterator iter;
			iter.joystick = this;
			iter.status = status;
			return iter;
		}
		
		/// iterate over axes moved since last call to process
		int foreachAxisMoved(int delegate(inout ubyte, inout arcfl) dg)
		{   
			int result = 0;
			if (joystick is null)
				return result;
				
			for (ubyte i = 0; i < axisMoved.length; i++)
			{
				if (axisMoved[i] != 0.0f)
					result = dg(i, axisMoved[i]);
				if (result)
					return result;
			}
			
			return result;
		}
						
		/// numbuttons
		ubyte numButtons() { return this.isOpen ? SDL_JoystickNumButtons(this.joystick) : 0;}

		/// numaxes
		ubyte numAxes() { return this.isOpen ? SDL_JoystickNumAxes(this.joystick) : 0; }

		/// name
		char[] name() {	return this.isOpen ? toString(SDL_JoystickName( SDL_JoystickIndex(this.joystick) )) : ""; }
		
		/// if a joystick is not open, it won't receive any input
		bool isOpen() {	return (joystick !is null && SDL_JoystickIndex(joystick) != - 1);	}
		
		/// close joystick
		void close()
		{
			if (this.isOpen())
			{
				SDL_JoystickClose(this.joystick);
				buttonStatus.length = 0;
				axisMoved.length = 0;
			}
			joystick = null;
		}
		
		/// constructor returns an opened stick if possible and reserves space for internal
		/// buttons and axes state
		static Joystick opCall(ubyte index)
		{
			Joystick result;
			with(result)
			{
				joystick = SDL_JoystickOpen(index);
				if (isOpen)
				{
					buttonStatus.length = numButtons;
					buttonStatus[0..$] = KeyStatus.UP;
					axisMoved.length = numAxes;
					axisMoved[0..$] = 0.0f;
				}
			}
											
			return result;
		}
		
		KeyStatus[] buttonStatus;
		arcfl[] axisMoved;
		
		private SDL_Joystick* joystick = null;
	}
	
	/// 
	Joystick[] 	joystickInfo; 
	/// used internally to determine hotplug event
	ubyte 		numJoysticks = 0; 
	/// SDL docs recommend to ignore axes movement smaller than 10 percent, for most joysticks are likely
	/// to produce some noise. This also allows for a value of 0.0f on an axis to signify no movement
	short		axisThreshold = 3200;
	/// used internally to skip joystick handling if no sticks are opened	
	bool 		isJoyStickEnabled = false; 
	bool			initialized = false;
	
	/// initialize sdl joystick subsystem
	void init()
	{
		SDL_Init(SDL_INIT_JOYSTICK);
		initialized = true;
	}
		
	/// resets axis movements and button status changes that happened since last call to process
	void clear()
	{
		foreach(inout stick; joystickInfo)
		{
			if (stick.joystick is null)
				continue;
			
			foreach(inout b; stick.buttonStatus)
				b &= KeyStatus.DOWN;
			stick.axisMoved[0..$] = 0.0f;
		}
		
		ubyte nstick = SDL_NumJoysticks();
		
		if (nstick != numJoysticks)
		{
			arc.internals.input.signals.signals.joyHotPlug.emit(numJoysticks, nstick);
			numJoysticks = nstick;
		}		
	}
	
	/// num joysticks open
	int numSticksOpen()
	{
		int result = 0;
		foreach(stick; joystickInfo)
			if (stick.isOpen)
				result++;
		return result;
	}

	/// iterates over all joysticks that are opened via their numerical index	
	int opApply(int delegate(inout ubyte) dg)
	{   
		int result = 0;
		
		for (ubyte i = 0; i < joystickInfo.length; i++)
		{
			if (joystickInfo[i].isOpen)
				result = dg(i);
			if (result)
				return result;
		}
		
		return result;
	}	
	
	///	emit signal and set state for this event
	void handleButtonDown(inout SDL_Event event)
	{
		// if the button is already down, nothing needs to be done
		if(joystickInfo[event.jbutton.which].buttonStatus[event.jbutton.button] & KeyStatus.DOWN != 0)
			return;
	
		// set the 'down' and 'pressed' bits
		joystickInfo[event.jbutton.which].buttonStatus[event.jbutton.button] |= KeyStatus.DOWN | KeyStatus.PRESSED;
		
		// raise signal
		arc.internals.input.signals.signals.joyButtonDown.emit(event.jbutton.which, event.jbutton.button);
	}
	
	///	ditto
	void handleButtonUp(inout SDL_Event event)
	{
		// if the button is already up, nothing needs to be done
		if(joystickInfo[event.jbutton.which].buttonStatus[event.jbutton.button] & KeyStatus.DOWN == 0)
			return;
		
		// unset 'down' bit, set the 'released' bit
		joystickInfo[event.jbutton.which].buttonStatus[event.jbutton.button] &= KeyStatus.PRESSED | KeyStatus.RELEASED;
		joystickInfo[event.jbutton.which].buttonStatus[event.jbutton.button] |= KeyStatus.RELEASED;
		
		// raise signal
		arc.internals.input.signals.signals.joyButtonUp.emit(event.jbutton.which, event.jbutton.button);
	}
	
	///	ditto
	void handleAxisMove(inout SDL_Event event)
	{
		arcfl pos = (cast(real)event.jaxis.value) / cast(real)short.max;
		joystickInfo[event.jaxis.which].axisMoved[event.jaxis.axis] = pos;
		arc.internals.input.signals.signals.joyAxisMove.emit(event.jaxis.which, event.jaxis.axis, pos);
	}
} 

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
