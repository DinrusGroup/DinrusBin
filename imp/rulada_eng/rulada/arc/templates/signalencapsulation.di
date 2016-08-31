/******************************************************************************* 

	This template exposes connect/disconnect methods for a FlexSignal
	without allowing access to the signal itself.
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		This template exposes connect/disconnect methods for a FlexSignal
	without allowing access to the signal itself. Hopefully this can be
	replaced when D gets const.

	Bugs:
		It is important that the mixin is put after the declaration of the Signal.
		
	Examples:      
	---------------------
		class Foo
		{
			private FlexSignal!() signal_;
			mixin FlexSignalAccess!(signal_) signal;
		}
	---------------------

*******************************************************************************/

module arc.templates.signalencapsulation;

import arc.templates.signalobj;

/// This template exposes connect/disconnect methods for a FlexSignal without allowing access to the signal itself.
template FlexSignalAccess(alias signal)
{
	alias typeof(signal) signaltype;
	alias signaltype.slot_t slot_t;
	
	slot_t connect(slot_t f) { return signal.connect(f); }
	slot_t disconnect(slot_t f) { return signal.disconnect(f); }
	slot_key fconnect(DT)(DT f) { return signal.fconnect(f); }
	void fdisconnect(DT)(DT f) { signal.fdisconnect(f); }
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
