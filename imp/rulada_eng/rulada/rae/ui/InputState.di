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

module rae.ui.InputState;

import tango.util.log.Trace;//Thread safe console output.

//import rae.core.globals;
//import rae.ui.Widget;
//import rae.ui.Window;
import rae.canvas.IRootWindow;
public import rae.ui.EventType;
public import rae.ui.KeySym;

version(gtk)
{
	import gtkD.gdk.Keymap;
}

version(glfw)
{
	import glfw.glfw;
}

enum MouseButton
{
	LEFT = 1,
	MIDDLE,
	RIGHT,
	FOURTH,
	FIFTH
}

/*
enum 
{
	SHZ_unknown = -1,
	SHZ_reserved = 0,
	SHZ_a,
	SHZ_b,
	SHZ_c,
	SHZ_d,
	SHZ_e,
	SHZ_f,
	SHZ_g,
	SHZ_h,
	SHZ_i,
	SHZ_j,
	SHZ_k,
	SHZ_l,
	SHZ_m,
	SHZ_n,
	SHZ_o,
	SHZ_p,
	SHZ_q,
	SHZ_r,
	SHZ_s,
	SHZ_t,
	SHZ_u,
	SHZ_v,
	SHZ_w,
	SHZ_x,
	SHZ_y,
	SHZ_z,
	SHZ_0,
	SHZ_1,
	SHZ_2,
	SHZ_3,
	SHZ_4,
	SHZ_5,
	SHZ_6,
	SHZ_7,
	SHZ_8,
	SHZ_9,
	SHZ_escape,
	SHZ_F1,
	SHZ_F2,
	SHZ_F3,
	SHZ_F4,
	SHZ_F5,
	SHZ_F6,
	SHZ_F7,
	SHZ_F8,
	SHZ_F9,
	SHZ_F10,
	SHZ_F11,
	SHZ_F12,
	SHZ_F13,
	SHZ_F14,
	SHZ_F15,
	SHZ_F16,
	SHZ_F17,
	SHZ_F18,
	SHZ_F19,
	SHZ_F20,
	SHZ_F21,
	SHZ_F22,
	SHZ_F23,
	SHZ_F24,
	SHZ_F25,
	SHZ_lshift,
	SHZ_rshift,
	SHZ_lctrl,
	SHZ_rctrl,
	SHZ_lalt,
	SHZ_ralt,
	SHZ_tab,
	SHZ_enter,
	SHZ_backspace,
	SHZ_insert,
	SHZ_delete,
	SHZ_pageup,
	SHZ_pagedown,
	SHZ_home,
	SHZ_end,
	SHZ_kp_0,
	SHZ_kp_1,
	SHZ_kp_2,
	SHZ_kp_3,
	SHZ_kp_4,
	SHZ_kp_5,
	SHZ_kp_6,
	SHZ_kp_7,
	SHZ_kp_8,
	SHZ_kp_9,
	SHZ_kp_divide,
	SHZ_kp_multiply,
	SHZ_kp_subtract,
	SHZ_kp_add,
	SHZ_kp_decimal,
	SHZ_kp_equal,
	SHZ_kp_enter,
	SHZ_space,
	SHZ_down,
	SHZ_up,
	SHZ_left,
	SHZ_right
}
*/


class InputState
{
/*
	version(glfw)
	{
	static int convertKeyFromNative(int nativekey)
	{
		switch(nativekey)
		{
			default:
			case GLFW_KEY_UNKNOWN:
			return SHZ_unknown;
			case '0':
			return SHZ_0;
			case '1':
			return SHZ_1;
			case '2':
			return SHZ_2;
			case '3':
			return SHZ_3;
			case '4':
			return SHZ_4;
			case '5':
			return SHZ_5;
			case '6':
			return SHZ_6;
			case '7':
			return SHZ_7;
			case '8':
			return SHZ_8;
			case '9':
			return SHZ_9;
			case 'A':
			return SHZ_a;
			case 'B':
			return SHZ_b;
			case 'C':
			return SHZ_c;
			case 'D':
			return SHZ_d;
			case 'E':
			return SHZ_e;
			case 'F':
			return SHZ_f;
			case 'G':
			return SHZ_g;
			case 'H':
			return SHZ_h;
			case 'I':
			return SHZ_i;
			case 'J':
			return SHZ_j;
			case 'K':
			return SHZ_k;
			case 'L':
			return SHZ_l;
			case 'M':
			return SHZ_m;
			case 'N':
			return SHZ_n;
			case 'O':
			return SHZ_o;
			case 'P':
			return SHZ_p;
			case 'Q':
			return SHZ_q;
			case 'R':
			return SHZ_r;
			case 'S':
			return SHZ_s;
			case 'T':
			return SHZ_t;
			case 'U':
			return SHZ_u;
			case 'V':
			return SHZ_v;
			case 'W':
			return SHZ_w;
			case 'X':
			return SHZ_x;
			case 'Y':
			return SHZ_y;
			case 'Z':
			return SHZ_z;
			case GLFW_KEY_SPACE:
			return SHZ_space;
			case GLFW_KEY_ESC:
			return SHZ_escape;
			case GLFW_KEY_F1:
			return SHZ_F1;
			case GLFW_KEY_F2:
			return SHZ_F2;
			case GLFW_KEY_F3:
			return SHZ_F3;
			case GLFW_KEY_F4:
			return SHZ_F4;
			case GLFW_KEY_F5:
			return SHZ_F5;
			case GLFW_KEY_F6:
			return SHZ_F6;
			case GLFW_KEY_F7:
			return SHZ_F7;
			case GLFW_KEY_F8:
			return SHZ_F8;
			case GLFW_KEY_F9:
			return SHZ_F9;
			case GLFW_KEY_F10:
			return SHZ_F10;
			case GLFW_KEY_F11:
			return SHZ_F11;
			case GLFW_KEY_F12:
			return SHZ_F12;
			case GLFW_KEY_F13:
			return SHZ_F13;
			case GLFW_KEY_F14:
			return SHZ_F14;
			case GLFW_KEY_F15:
			return SHZ_F15;
			case GLFW_KEY_F16:
			return SHZ_F16;
			case GLFW_KEY_F17:
			return SHZ_F17;
			case GLFW_KEY_F18:
			return SHZ_F18;
			case GLFW_KEY_F19:
			return SHZ_F19;
			case GLFW_KEY_F20:
			return SHZ_F20;
			case GLFW_KEY_F21:
			return SHZ_F21;
			case GLFW_KEY_F22:
			return SHZ_F22;
			case GLFW_KEY_F23:
			return SHZ_F23;
			case GLFW_KEY_F24:
			return SHZ_F24;
			case GLFW_KEY_F25:
			return SHZ_F25;
			case GLFW_KEY_UP:
			return SHZ_up;
			case GLFW_KEY_DOWN:
			return SHZ_down;
			case GLFW_KEY_LEFT:
			return SHZ_left;
			case GLFW_KEY_RIGHT:
			return SHZ_right;
			case GLFW_KEY_LSHIFT:
			return SHZ_lshift;
			case GLFW_KEY_RSHIFT:
			return SHZ_rshift;
			case GLFW_KEY_LCTRL:
			return SHZ_lctrl;
			case GLFW_KEY_RCTRL:
			return SHZ_rctrl;
			case GLFW_KEY_LALT:
			return SHZ_lalt;
			case GLFW_KEY_RALT:
			return SHZ_ralt;
			case GLFW_KEY_TAB:
			return SHZ_tab;
			case GLFW_KEY_ENTER:
			return SHZ_enter;
			case GLFW_KEY_BACKSPACE:
			return SHZ_backspace;
			case GLFW_KEY_INSERT:
			return SHZ_insert;
			case GLFW_KEY_DEL:
			return SHZ_delete;
			case GLFW_KEY_PAGEUP:
			return SHZ_pageup;
			case GLFW_KEY_PAGEDOWN:
			return SHZ_pagedown;
			case GLFW_KEY_HOME:
			return SHZ_home;
			case GLFW_KEY_END:
			return SHZ_end;
			case GLFW_KEY_KP_0:
			return SHZ_kp_0;
			case GLFW_KEY_KP_1:
			return SHZ_kp_1;
			case GLFW_KEY_KP_2:
			return SHZ_kp_2;
			case GLFW_KEY_KP_3:
			return SHZ_kp_3;
			case GLFW_KEY_KP_4:
			return SHZ_kp_4;
			case GLFW_KEY_KP_5:
			return SHZ_kp_5;
			case GLFW_KEY_KP_6:
			return SHZ_kp_6;
			case GLFW_KEY_KP_7:
			return SHZ_kp_7;
			case GLFW_KEY_KP_8:
			return SHZ_kp_8;
			case GLFW_KEY_KP_9:
			return SHZ_kp_9;
			case GLFW_KEY_KP_DIVIDE:
			return SHZ_kp_divide;
			case GLFW_KEY_KP_MULTIPLY:
			return SHZ_kp_multiply;
			case GLFW_KEY_KP_SUBTRACT:
			return SHZ_kp_subtract;
			case GLFW_KEY_KP_ADD:
			return SHZ_kp_add;
			case GLFW_KEY_KP_DECIMAL:
			return SHZ_kp_decimal;
			case GLFW_KEY_KP_EQUAL:
			return SHZ_kp_equal;
			case GLFW_KEY_KP_ENTER:
			return SHZ_kp_enter;
		}
		return SHZ_unknown;
	}
	
	static int convertKeyToChar(int shz_key)
	{
		switch(shz_key)
		{
			default:
			break;
			case SHZ_space:
			return ' ';
			case SHZ_0:
			return '0';
			case SHZ_1:
			return '1';
			case SHZ_2:
			return '2';
			case SHZ_3:
			return '3';
			case SHZ_4:
			return '4';
			case SHZ_5:
			return '5';
			case SHZ_6:
			return '6';
			case SHZ_7:
			return '7';
			case SHZ_8:
			return '8';
			case SHZ_9:
			return '9';
			case SHZ_a:
			return 'a';
			case SHZ_b:
			return 'b';
			case SHZ_c:
			return 'c';
			case SHZ_d:
			return 'd';
			case SHZ_e:
			return 'e';
			case SHZ_f:
			return 'f';
			case SHZ_g:
			return 'g';
			case SHZ_h:
			return 'h';
			case SHZ_i:
			return 'i';
			case SHZ_j:
			return 'j';
			case SHZ_k:
			return 'k';
			case SHZ_l:
			return 'l';
			case SHZ_m:
			return 'm';
			case SHZ_n:
			return 'n';
			case SHZ_o:
			return 'o';
			case SHZ_p:
			return 'p';
			case SHZ_q:
			return 'q';
			case SHZ_r:
			return 'r';
			case SHZ_s:
			return 's';
			case SHZ_t:
			return 't';
			case SHZ_u:
			return 'u';
			case SHZ_v:
			return 'v';
			case SHZ_w:
			return 'w';
			case SHZ_x:
			return 'x';
			case SHZ_y:
			return 'y';
			case SHZ_z:
			return 'z';
		}
		return -1;
	}
	
	}//version(glfw)
	
	*/
	
	//bool isMotionEvent;
	/*bool isButtonPress1Event;
	bool isButtonRelease1Event;
	bool isButtonPress2Event;
	bool isButtonPress3Event;
	bool isButtonPress4Event;
	bool isButtonPress5Event;*/
	//bool isWheelEvent;
	
	this()
	{
		
	}
	
	static dchar keyValueToUnicode(uint keyval)
	{
		version(gtk)
		{
			return cast(dchar) Keymap.gdkKeyvalToUnicode(keyval);
		}
		else
		{
			//Trace.formatln("inputState.keyValueToUnicode not defined.");
			//throw new Exception("inputState.keyValueToUnicode not defined.");
			return keyval;
		}
	}
	
	void keyEvent( IRootWindow set_window, SEventType set_eventType, int set_key )
	{
		isHandled = false;
		window = set_window;
		eventType = set_eventType;
		
		version(gtk)
		{
			key.value = set_key;
			key.unicode = keyValueToUnicode(set_key);
		}
		version(glfw)
		{
			key.value = set_key;
			key.unicode = cast(dchar) set_key;
		}
	}
	
	void mouseEvent( IRootWindow set_window, SEventType set_eventType, int set_button, double set_x, double set_y )
	{
		debug(mouse) Trace.formatln("InputState.mouseEvent() START. x: {}, y: {}", set_x, set_y );
		debug(mouse) scope(exit) Trace.formatln("InputState.mouseEvent() END.");
	
		isHandled = false;
		window = set_window;
		eventType = set_eventType;
		if( eventType == SEventType.SCROLL_UP || eventType == SEventType.SCROLL_DOWN )
		{
			mouse.eventButton = 0;
			mouse.amount = cast(float) set_button;//event.button is reused in the scroll events as the relative amount of scroll. For now.
			//Maybe change it later to a dedicated scrollEvent() method here.
		}
		else
			mouse.eventButton = set_button;
			
		if( eventType == SEventType.MOUSE_BUTTON_PRESS )
		{
			mouse.button[set_button] = true;
			mouse.xOnButtonPress[set_button] = set_x;
			mouse.yOnButtonPress[set_button] = set_y;
		}
		else if( eventType == SEventType.MOUSE_BUTTON_RELEASE )
		{
			mouse.button[set_button] = false;
		}
		//else
		//{
			//Trace.formatln("InputState NO PRESS.");
		//}
		
		mouse.xRel = set_x - mouse.x;
		mouse.yRel = set_y - mouse.y;
		
		//Trace.formatln("\nInputState.mouseEvent() START. x: {}, y: {}", set_x, set_y );
			
			//We have to update all our buttons, as we don't know which ones
			//were clicked, and many could have been clicked...
			for( uint i = 0; i < 6; i++ )
			{
				mouse.xRelOnButtonPress[i] = set_x - mouse.xOnButtonPress[i];
				mouse.yRelOnButtonPress[i] = set_y - mouse.yOnButtonPress[i];
			}
			//mouse.xRelOnButtonPress[set_button] = mouse.xOnButtonPress[set_button];
			//mouse.yRelOnButtonPress[set_button] = set_y - mouse.yOnButtonPress[set_button];
			
			//Trace.formatln( "InputState: xOnButtonPress: {} yOnButtonPress: {}", mouse.xOnButtonPress[set_button], mouse.yOnButtonPress[set_button] );
			//Trace.formatln( "InputState: xRelOnButtonPress: {} yRelOnButtonPress: {}", mouse.xRelOnButtonPress[set_button], mouse.yRelOnButtonPress[set_button] );
			
		
		mouse.x = set_x;
		mouse.y = set_y;
		mouse.xLocal = set_x;
		mouse.yLocal = set_y;
	}
	
	IRootWindow window = null;
	
	SEventType eventType = SEventType.UNDEFINED;
	bool isHandled = false;
	
	struct Mouse
	{
		uint eventButton = 0;
		bool button[6];
		double x = 0.0;
		double y = 0.0;
		double xLocal = 0.0;//These change all the time.
		double yLocal = 0.0;
		double xRel = 0.0;
		double yRel = 0.0;
		double xRelLocal = 0.0;
		double yRelLocal = 0.0;
		
		float amount = 0.0f;
		//onButtonPress locations:
		double xOnButtonPress[6] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		double yOnButtonPress[6] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		double xRelOnButtonPress[6] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		double yRelOnButtonPress[6] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	}
	
	Mouse mouse;
	
	struct Keyboard
	{
		int value = 0;//SHZ_unknown;
		dchar unicode = 0;
	}
	Keyboard key;
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
