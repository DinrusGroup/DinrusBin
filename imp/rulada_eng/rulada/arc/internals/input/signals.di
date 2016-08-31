module arc.internals.input.signals; 

import
	arc.math.point,
	arc.math.arcfl,
	arc.templates.flexsignal;

//
// signals
//
/// Input signals 
class InputSignals
{
	///
	mixin FlexSignal!(int) keyDown;
	///
	mixin FlexSignal!(int) keyUp;
	
	///
	mixin FlexSignal!(int, Point) mouseButtonUp;
	
	///
	mixin FlexSignal!(int, Point) mouseButtonDown;
	
	///
	mixin FlexSignal!(Point) mouseMove; 

	///
	mixin FlexSignal!(ubyte, ubyte) joyButtonDown;
	
	///
	mixin FlexSignal!(ubyte, ubyte) joyButtonUp;
	
	///
	mixin FlexSignal!(ubyte, ubyte, arcfl) joyAxisMove;
	
	// this signal is emitted when the number of joysticks that are plugged in changes
	// the first parameter is the previous number of joysticks, and the second is the current
	// on a hotplug event, nothing else is done but emitting this signal, it is up to the user to respond
	mixin FlexSignal!(ubyte, ubyte) joyHotPlug; 
}

InputSignals signals;

static this()
{
	signals = new InputSignals;
}


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
