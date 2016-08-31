/******************************************************************************* 

    Implementation of Constants for Arc Input

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Implementation of Constants for Arc Input, not to be used seperately.
		

	Examples:
	--------------------
		Not provided.
	--------------------

*******************************************************************************/

module arc.internals.input.constants;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                      KEY DEFINITIONS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/// possible states a key can be in
enum KeyStatus : uint
{
	UP = 0,  /// key is physically up
	DOWN = 1,  /// key is physically down 
	PRESSED = 2,  /// key has recently been pressed
	RELEASED = 4  /// key has recently been released
}

///   The infamous 'any' key used to represent any key
const int ANYKEY = 0;
const int ARC_QUIT = 12; 

/// Arc keyboard keys
enum
{
		/* The keyboard syms have been cleverly chosen to map to ASCII */
		ARC_UNKNOWN        = 0,
		ARC_FIRST      = 0,
		ARC_BACKSPACE      = 8,
		ARC_TAB        = 9,
		ARC_CLEAR      = 12,
		ARC_RETURN     = 13,
		ARC_PAUSE      = 19,
		ARC_ESCAPE     = 27,
		ARC_SPACE      = 32,
		ARC_EXCLAIM        = 33,
		ARC_QUOTEDBL       = 34,
		ARC_HASH       = 35,
		ARC_DOLLAR     = 36,
		ARC_AMPERSAND      = 38,
		ARC_QUOTE      = 39,
		ARC_LEFTPAREN      = 40,
		ARC_RIGHTPAREN     = 41,
		ARC_ASTERISK       = 42,
		ARC_PLUS       = 43,
		ARC_COMMA      = 44,
		ARC_MINUS      = 45,
		ARC_PERIOD     = 46,
		ARC_SLASH      = 47,
		ARC_0          = 48,
		ARC_1          = 49,
		ARC_2          = 50,
		ARC_3          = 51,
		ARC_4          = 52,
		ARC_5          = 53,
		ARC_6          = 54,
		ARC_7          = 55,
		ARC_8          = 56,
		ARC_9          = 57,
		ARC_COLON      = 58,
		ARC_SEMICOLON      = 59,
		ARC_LESS       = 60,
		ARC_EQUALS     = 61,
		ARC_GREATER        = 62,
		ARC_QUESTION       = 63,
		ARC_AT         = 64,
		/*
			Skip uppercase letters
		*/
		ARC_LEFTBRACKET    = 91,
		ARC_BACKSLASH      = 92,
		ARC_RIGHTBRACKET   = 93,
		ARC_CARET      = 94,
		ARC_UNDERSCORE     = 95,
		ARC_BACKQUOTE      = 96,
		ARC_a          = 97,
		ARC_b          = 98,
		ARC_c          = 99,
		ARC_d          = 100,
		ARC_e          = 101,
		ARC_f          = 102,
		ARC_g          = 103,
		ARC_h          = 104,
		ARC_i          = 105,
		ARC_j          = 106,
		ARC_k          = 107,
		ARC_l          = 108,
		ARC_m          = 109,
		ARC_n          = 110,
		ARC_o          = 111,
		ARC_p          = 112,
		ARC_q          = 113,
		ARC_r          = 114,
		ARC_s          = 115,
		ARC_t          = 116,
		ARC_u          = 117,
		ARC_v          = 118,
		ARC_w          = 119,
		ARC_x          = 120,
		ARC_y          = 121,
		ARC_z          = 122,
		ARC_DELETE     = 127,
		/* End of ASCII mapped keysyms */

		/* International keyboard syms */
		ARC_WORLD_0        = 160,      /* 0xA0 */
		ARC_WORLD_1        = 161,
		ARC_WORLD_2        = 162,
		ARC_WORLD_3        = 163,
		ARC_WORLD_4        = 164,
		ARC_WORLD_5        = 165,
		ARC_WORLD_6        = 166,
		ARC_WORLD_7        = 167,
		ARC_WORLD_8        = 168,
		ARC_WORLD_9        = 169,
		ARC_WORLD_10       = 170,
		ARC_WORLD_11       = 171,
		ARC_WORLD_12       = 172,
		ARC_WORLD_13       = 173,
		ARC_WORLD_14       = 174,
		ARC_WORLD_15       = 175,
		ARC_WORLD_16       = 176,
		ARC_WORLD_17       = 177,
		ARC_WORLD_18       = 178,
		ARC_WORLD_19       = 179,
		ARC_WORLD_20       = 180,
		ARC_WORLD_21       = 181,
		ARC_WORLD_22       = 182,
		ARC_WORLD_23       = 183,
		ARC_WORLD_24       = 184,
		ARC_WORLD_25       = 185,
		ARC_WORLD_26       = 186,
		ARC_WORLD_27       = 187,
		ARC_WORLD_28       = 188,
		ARC_WORLD_29       = 189,
		ARC_WORLD_30       = 190,
		ARC_WORLD_31       = 191,
		ARC_WORLD_32       = 192,
		ARC_WORLD_33       = 193,
		ARC_WORLD_34       = 194,
		ARC_WORLD_35       = 195,
		ARC_WORLD_36       = 196,
		ARC_WORLD_37       = 197,
		ARC_WORLD_38       = 198,
		ARC_WORLD_39       = 199,
		ARC_WORLD_40       = 200,
		ARC_WORLD_41       = 201,
		ARC_WORLD_42       = 202,
		ARC_WORLD_43       = 203,
		ARC_WORLD_44       = 204,
		ARC_WORLD_45       = 205,
		ARC_WORLD_46       = 206,
		ARC_WORLD_47       = 207,
		ARC_WORLD_48       = 208,
		ARC_WORLD_49       = 209,
		ARC_WORLD_50       = 210,
		ARC_WORLD_51       = 211,
		ARC_WORLD_52       = 212,
		ARC_WORLD_53       = 213,
		ARC_WORLD_54       = 214,
		ARC_WORLD_55       = 215,
		ARC_WORLD_56       = 216,
		ARC_WORLD_57       = 217,
		ARC_WORLD_58       = 218,
		ARC_WORLD_59       = 219,
		ARC_WORLD_60       = 220,
		ARC_WORLD_61       = 221,
		ARC_WORLD_62       = 222,
		ARC_WORLD_63       = 223,
		ARC_WORLD_64       = 224,
		ARC_WORLD_65       = 225,
		ARC_WORLD_66       = 226,
		ARC_WORLD_67       = 227,
		ARC_WORLD_68       = 228,
		ARC_WORLD_69       = 229,
		ARC_WORLD_70       = 230,
		ARC_WORLD_71       = 231,
		ARC_WORLD_72       = 232,
		ARC_WORLD_73       = 233,
		ARC_WORLD_74       = 234,
		ARC_WORLD_75       = 235,
		ARC_WORLD_76       = 236,
		ARC_WORLD_77       = 237,
		ARC_WORLD_78       = 238,
		ARC_WORLD_79       = 239,
		ARC_WORLD_80       = 240,
		ARC_WORLD_81       = 241,
		ARC_WORLD_82       = 242,
		ARC_WORLD_83       = 243,
		ARC_WORLD_84       = 244,
		ARC_WORLD_85       = 245,
		ARC_WORLD_86       = 246,
		ARC_WORLD_87       = 247,
		ARC_WORLD_88       = 248,
		ARC_WORLD_89       = 249,
		ARC_WORLD_90       = 250,
		ARC_WORLD_91       = 251,
		ARC_WORLD_92       = 252,
		ARC_WORLD_93       = 253,
		ARC_WORLD_94       = 254,
		ARC_WORLD_95       = 255,      /* 0xFF */

		/* Numeric keypad */
		ARC_KP0        = 256,
		ARC_KP1        = 257,
		ARC_KP2        = 258,
		ARC_KP3        = 259,
		ARC_KP4        = 260,
		ARC_KP5        = 261,
		ARC_KP6        = 262,
		ARC_KP7        = 263,
		ARC_KP8        = 264,
		ARC_KP9        = 265,
		ARC_KP_PERIOD      = 266,
		ARC_KP_DIVIDE      = 267,
		ARC_KP_MULTIPLY    = 268,
		ARC_KP_MINUS       = 269,
		ARC_KP_PLUS        = 270,
		ARC_KP_ENTER       = 271,
		ARC_KP_EQUALS      = 272,

		/* Arrows + Home/End pad */
		ARC_UP         = 273,
		ARC_DOWN       = 274,
		ARC_RIGHT      = 275,
		ARC_LEFT       = 276,
		ARC_INSERT     = 277,
		ARC_HOME       = 278,
		ARC_END        = 279,
		ARC_PAGEUP     = 280,
		ARC_PAGEDOWN       = 281,

		/* Function keys */
		ARC_F1         = 282,
		ARC_F2         = 283,
		ARC_F3         = 284,
		ARC_F4         = 285,
		ARC_F5         = 286,
		ARC_F6         = 287,
		ARC_F7         = 288,
		ARC_F8         = 289,
		ARC_F9         = 290,
		ARC_F10        = 291,
		ARC_F11        = 292,
		ARC_F12        = 293,
		ARC_F13        = 294,
		ARC_F14        = 295,
		ARC_F15        = 296,

		/* Key state modifier keys */
		ARC_NUMLOCK        = 300,
		ARC_CAPSLOCK       = 301,
		ARC_SCROLLOCK      = 302,
		ARC_RSHIFT     = 303,
		ARC_LSHIFT     = 304,
		ARC_RCTRL      = 305,
		ARC_LCTRL      = 306,
		ARC_RALT       = 307,
		ARC_LALT       = 308,
		ARC_RMETA      = 309,
		ARC_LMETA      = 310,
		ARC_LSUPER     = 311,      /* Left "Windows" key */
		ARC_RSUPER     = 312,      /* Right "Windows" key */
		ARC_MODE       = 313,      /* "Alt Gr" key */
		ARC_COMPOSE        = 314,      /* Multi-key compose key */

		/* Miscellaneous function keys */
		ARC_HELP       = 315,
		ARC_PRINT      = 316,
		ARC_SYSREQ     = 317,
		ARC_BREAK      = 318,
		ARC_MENU       = 319,
		ARC_POWER      = 320,      /* Power Macintosh power key */
		ARC_EURO       = 321,      /* Some european keyboards */
		ARC_UNDO       = 322,      /* Atari keyboard has Undo */

		/* Add any other keys here */
		ARC_LAST
}



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                      BUTTON DEFINITIONS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/*******************************************************************************

	All of the buttons a mouse has (start at zero for array operations)
			0. Any button is clicked
			1. Left
			2. Middle
			3. Right

*******************************************************************************/
enum
{
	ANYBUTTON = 0,
	LEFT,
	MIDDLE,
	RIGHT,
	WHEELUP,
	WHEELDOWN,
	MAXMOUSEBUTTON
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
