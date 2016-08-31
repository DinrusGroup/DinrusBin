module rae.ui.EventType;

//I do hate D forward referencing error.

enum SEventType
{
	UNDEFINED,
	MOUSE_MOTION,
	MOUSE_BUTTON_PRESS,
	MOUSE_BUTTON_RELEASE,
	KEY_PRESS,
	KEY_RELEASE,
	KEY_HOLD,
	ENTER_NOTIFY,
	LEAVE_NOTIFY,
	SCROLL_UP,
	SCROLL_DOWN
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
