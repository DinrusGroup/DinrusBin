module derelict.opengl.glut;

/*
 * Copyright (c) 1999-2000 Pawel W. Olszta. All Rights Reserved.
 * Written by Pawel W. Olszta, <olszta@sourceforge.net>
 * Creation date: Thu Dec 2 1999
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * PAWEL W. OLSZTA BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/*
 *Uncomment the following line to enable new freeglut features
 */
//version = FREEGLUT_EXTRAS;

private
{
    import derelict.opengl.gltypes;
    import derelict.util.loader;
}
/*
 * The freeglut and GLUT API versions
 */
const GLuint FREEGLUT				= 1;
const GLuint GLUT_API_VERSION			= 4;
const GLuint FREEGLUT_VERSION_2_0		= 1;
const GLuint GLUT_XLIB_IMPLEMENTATION		= 13;

/*
 * GLUT API macro definitions -- the special key codes:
 */
const GLuint GLUT_KEY_F1			= 0x0001;
const GLuint GLUT_KEY_F2			= 0x0002;
const GLuint GLUT_KEY_F3			= 0x0003;
const GLuint GLUT_KEY_F4			= 0x0004;
const GLuint GLUT_KEY_F5			= 0x0005;
const GLuint GLUT_KEY_F6			= 0x0006;
const GLuint GLUT_KEY_F7			= 0x0007;
const GLuint GLUT_KEY_F8			= 0x0008;
const GLuint GLUT_KEY_F9			= 0x0009;
const GLuint GLUT_KEY_F10			= 0x000A;
const GLuint GLUT_KEY_F11			= 0x000B;
const GLuint GLUT_KEY_F12			= 0x000C;
const GLuint GLUT_KEY_LEFT			= 0x0064;
const GLuint GLUT_KEY_UP			= 0x0065;
const GLuint GLUT_KEY_RIGHT			= 0x0066;
const GLuint GLUT_KEY_DOWN			= 0x0067;
const GLuint GLUT_KEY_PAGE_UP			= 0x0068;
const GLuint GLUT_KEY_PAGE_DOWN			= 0x0069;
const GLuint GLUT_KEY_HOME			= 0x006A;
const GLuint GLUT_KEY_END			= 0x006B;
const GLuint GLUT_KEY_INSERT			= 0x006C;

/*
 * GLUT API macro definitions -- mouse state definitions
 */
const GLuint GLUT_LEFT_BUTTON			= 0x0000;
const GLuint GLUT_MIDDLE_BUTTON			= 0x0001;
const GLuint GLUT_RIGHT_BUTTON			= 0x0002;
const GLuint GLUT_DOWN				= 0x0000;
const GLuint GLUT_UP				= 0x0001;
const GLuint GLUT_LEFT				= 0x0000;
const GLuint GLUT_ENTERED			= 0x0001;

/*
 * GLUT API macro definitions -- the display mode definitions
 */
const GLuint GLUT_RGB				= 0x0000;
const GLuint GLUT_RGBA				= 0x0000;
const GLuint GLUT_INDEX				= 0x0001;
const GLuint GLUT_SINGLE			= 0x0000;
const GLuint GLUT_DOUBLE			= 0x0002;
const GLuint GLUT_ACCUM				= 0x0004;
const GLuint GLUT_ALPHA				= 0x0008;
const GLuint GLUT_DEPTH				= 0x0010;
const GLuint GLUT_STENCIL			= 0x0020;
const GLuint GLUT_MULTISAMPLE			= 0x0080;
const GLuint GLUT_STEREO			= 0x0100;
const GLuint GLUT_LUMINANCE			= 0x0200;

/*
 * GLUT API macro definitions -- windows and menu related definitions
 */
const GLuint GLUT_MENU_NOT_IN_USE		= 0x0000;
const GLuint GLUT_MENU_IN_USE			= 0x0001;
const GLuint GLUT_NOT_VISIBLE			= 0x0000;
const GLuint GLUT_VISIBLE			= 0x0001;
const GLuint GLUT_HIDDEN			= 0x0000;
const GLuint GLUT_FULLY_RETAINED		= 0x0001;
const GLuint GLUT_PARTIALLY_RETAINED		= 0x0002;
const GLuint GLUT_FULLY_COVERED			= 0x0003;

/*
 * GLUT API macro definitions
 * Steve Baker suggested to make it binary compatible with GLUT:
 */
version (Windows)
 {
	const void* GLUT_STROKE_ROMAN		= cast(void*)0x0000;
	const void* GLUT_STROKE_MONO_ROMAN	= cast(void*)0x0001;
	const void* GLUT_BITMAP_9_BY_15	= cast(void*)0x0002;
	const void* GLUT_BITMAP_8_BY_13	= cast(void*)0x0003;
	const void* GLUT_BITMAP_TIMES_ROMAN_10= cast(void*)0x0004;
	const void* GLUT_BITMAP_TIMES_ROMAN_24= cast(void*)0x0005;
	const void* GLUT_BITMAP_HELVETICA_10	= cast(void*)0x0006;
	const void* GLUT_BITMAP_HELVETICA_12	= cast(void*)0x0007;
	const void* GLUT_BITMAP_HELVETICA_18	= cast(void*)0x0008;
} 
else 
{
	// Those pointers will be used by following definitions:
	const void* GLUT_STROKE_ROMAN		= cast(void*)&glutStrokeRoman;
	const void* GLUT_STROKE_MONO_ROMAN	= cast(void*)&glutStrokeMonoRoman;
	const void* GLUT_BITMAP_9_BY_15	= cast(void*)&glutBitmap9By15;
	const void* GLUT_BITMAP_8_BY_13	= cast(void*)&glutBitmap8By13;
	const void* GLUT_BITMAP_TIMES_ROMAN_10= cast(void*)&glutBitmapTimesRoman10;
	const void* GLUT_BITMAP_TIMES_ROMAN_24= cast(void*)&glutBitmapTimesRoman24;
	const void* GLUT_BITMAP_HELVETICA_10	= cast(void*)&glutBitmapHelvetica10;
	const void* GLUT_BITMAP_HELVETICA_12	= cast(void*)&glutBitmapHelvetica12;
	const void* GLUT_BITMAP_HELVETICA_18	= cast(void*)&glutBitmapHelvetica18;
}

// GLUT API macro definitions -- the glutGet parameters
const GLuint GLUT_WINDOW_X			= 0x0064;
const GLuint GLUT_WINDOW_Y			= 0x0065;
const GLuint GLUT_WINDOW_WIDTH			= 0x0066;
const GLuint GLUT_WINDOW_HEIGHT			= 0x0067;
const GLuint GLUT_WINDOW_BUFFER_SIZE		= 0x0068;
const GLuint GLUT_WINDOW_STENCIL_SIZE		= 0x0069;
const GLuint GLUT_WINDOW_DEPTH_SIZE		= 0x006A;
const GLuint GLUT_WINDOW_RED_SIZE		= 0x006B;
const GLuint GLUT_WINDOW_GREEN_SIZE		= 0x006C;
const GLuint GLUT_WINDOW_BLUE_SIZE		= 0x006D;
const GLuint GLUT_WINDOW_ALPHA_SIZE		= 0x006E;
const GLuint GLUT_WINDOW_ACCUM_RED_SIZE		= 0x006F;
const GLuint GLUT_WINDOW_ACCUM_GREEN_SIZE	= 0x0070;
const GLuint GLUT_WINDOW_ACCUM_BLUE_SIZE	= 0x0071;
const GLuint GLUT_WINDOW_ACCUM_ALPHA_SIZE	= 0x0072;
const GLuint GLUT_WINDOW_DOUBLEBUFFER		= 0x0073;
const GLuint GLUT_WINDOW_RGBA			= 0x0074;
const GLuint GLUT_WINDOW_PARENT			= 0x0075;
const GLuint GLUT_WINDOW_NUM_CHILDREN		= 0x0076;
const GLuint GLUT_WINDOW_COLORMAP_SIZE		= 0x0077;
const GLuint GLUT_WINDOW_NUM_SAMPLES		= 0x0078;
const GLuint GLUT_WINDOW_STEREO			= 0x0079;
const GLuint GLUT_WINDOW_CURSOR			= 0x007A;

const GLuint GLUT_SCREEN_WIDTH			= 0x00C8;
const GLuint GLUT_SCREEN_HEIGHT			= 0x00C9;
const GLuint GLUT_SCREEN_WIDTH_MM		= 0x00CA;
const GLuint GLUT_SCREEN_HEIGHT_MM		= 0x00CB;
const GLuint GLUT_MENU_NUM_ITEMS		= 0x012C;
const GLuint GLUT_DISPLAY_MODE_POSSIBLE		= 0x0190;
const GLuint GLUT_INIT_WINDOW_X			= 0x01F4;
const GLuint GLUT_INIT_WINDOW_Y			= 0x01F5;
const GLuint GLUT_INIT_WINDOW_WIDTH		= 0x01F6;
const GLuint GLUT_INIT_WINDOW_HEIGHT		= 0x01F7;
const GLuint GLUT_INIT_DISPLAY_MODE		= 0x01F8;
const GLuint GLUT_ELAPSED_TIME			= 0x02BC;
const GLuint GLUT_WINDOW_FORMAT_ID		= 0x007B;
const GLuint GLUT_INIT_STATE			= 0x007C;

// GLUT API macro definitions -- the glutDeviceGet parameters
const GLuint GLUT_HAS_KEYBOARD			= 0x0258;
const GLuint GLUT_HAS_MOUSE			= 0x0259;
const GLuint GLUT_HAS_SPACEBALL			= 0x025A;
const GLuint GLUT_HAS_DIAL_AND_BUTTON_BOX	= 0x025B;
const GLuint GLUT_HAS_TABLET			= 0x025C;
const GLuint GLUT_NUM_MOUSE_BUTTONS		= 0x025D;
const GLuint GLUT_NUM_SPACEBALL_BUTTONS		= 0x025E;
const GLuint GLUT_NUM_BUTTON_BOX_BUTTONS	= 0x025F;
const GLuint GLUT_NUM_DIALS			= 0x0260;
const GLuint GLUT_NUM_TABLET_BUTTONS		= 0x0261;
const GLuint GLUT_DEVICE_IGNORE_KEY_REPEAT	= 0x0262;
const GLuint GLUT_DEVICE_KEY_REPEAT		= 0x0263;
const GLuint GLUT_HAS_JOYSTICK			= 0x0264;
const GLuint GLUT_OWNS_JOYSTICK			= 0x0265;
const GLuint GLUT_JOYSTICK_BUTTONS		= 0x0266;
const GLuint GLUT_JOYSTICK_AXES			= 0x0267;
const GLuint GLUT_JOYSTICK_POLL_RATE		= 0x0268;

// GLUT API macro definitions -- the glutLayerGet parameters
const GLuint GLUT_OVERLAY_POSSIBLE		= 0x0320;
const GLuint GLUT_LAYER_IN_USE			= 0x0321;
const GLuint GLUT_HAS_OVERLAY			= 0x0322;
const GLuint GLUT_TRANSPARENT_INDEX		= 0x0323;
const GLuint GLUT_NORMAL_DAMAGED		= 0x0324;
const GLuint GLUT_OVERLAY_DAMAGED		= 0x0325;

// GLUT API macro definitions -- the glutVideoResizeGet parameters
const GLuint GLUT_VIDEO_RESIZE_POSSIBLE		= 0x0384;
const GLuint GLUT_VIDEO_RESIZE_IN_USE		= 0x0385;
const GLuint GLUT_VIDEO_RESIZE_X_DELTA		= 0x0386;
const GLuint GLUT_VIDEO_RESIZE_Y_DELTA		= 0x0387;
const GLuint GLUT_VIDEO_RESIZE_WIDTH_DELTA	= 0x0388;
const GLuint GLUT_VIDEO_RESIZE_HEIGHT_DELTA	= 0x0389;
const GLuint GLUT_VIDEO_RESIZE_X		= 0x038A;
const GLuint GLUT_VIDEO_RESIZE_Y		= 0x038B;
const GLuint GLUT_VIDEO_RESIZE_WIDTH		= 0x038C;
const GLuint GLUT_VIDEO_RESIZE_HEIGHT		= 0x038D;

// GLUT API macro definitions -- the glutUseLayer parameters
const GLuint GLUT_NORMAL			= 0x0000;
const GLuint GLUT_OVERLAY			= 0x0001;

// GLUT API macro definitions -- the glutGetModifiers parameters
const GLuint GLUT_ACTIVE_SHIFT			= 0x0001;
const GLuint GLUT_ACTIVE_CTRL			= 0x0002;
const GLuint GLUT_ACTIVE_ALT			= 0x0004;

// GLUT API macro definitions -- the glutSetCursor parameters
const GLuint GLUT_CURSOR_RIGHT_ARROW		= 0x0000;
const GLuint GLUT_CURSOR_LEFT_ARROW		= 0x0001;
const GLuint GLUT_CURSOR_INFO			= 0x0002;
const GLuint GLUT_CURSOR_DESTROY		= 0x0003;
const GLuint GLUT_CURSOR_HELP			= 0x0004;
const GLuint GLUT_CURSOR_CYCLE			= 0x0005;
const GLuint GLUT_CURSOR_SPRAY			= 0x0006;
const GLuint GLUT_CURSOR_WAIT			= 0x0007;
const GLuint GLUT_CURSOR_TEXT			= 0x0008;
const GLuint GLUT_CURSOR_CROSSHAIR		= 0x0009;
const GLuint GLUT_CURSOR_UP_DOWN		= 0x000A;
const GLuint GLUT_CURSOR_LEFT_RIGHT		= 0x000B;
const GLuint GLUT_CURSOR_TOP_SIDE		= 0x000C;
const GLuint GLUT_CURSOR_BOTTOM_SIDE		= 0x000D;
const GLuint GLUT_CURSOR_LEFT_SIDE		= 0x000E;
const GLuint GLUT_CURSOR_RIGHT_SIDE		= 0x000F;
const GLuint GLUT_CURSOR_TOP_LEFT_CORNER	= 0x0010;
const GLuint GLUT_CURSOR_TOP_RIGHT_CORNER	= 0x0011;
const GLuint GLUT_CURSOR_BOTTOM_RIGHT_CORNER	= 0x0012;
const GLuint GLUT_CURSOR_BOTTOM_LEFT_CORNER	= 0x0013;
const GLuint GLUT_CURSOR_INHERIT		= 0x0064;
const GLuint GLUT_CURSOR_NONE			= 0x0065;
const GLuint GLUT_CURSOR_FULL_CROSSHAIR		= 0x0066;

// GLUT API macro definitions -- RGB color component specification definitions
const GLuint GLUT_RED				= 0x0000;
const GLuint GLUT_GREEN				= 0x0001;
const GLuint GLUT_BLUE				= 0x0002;

// GLUT API macro definitions -- additional keyboard and joystick definitions
const GLuint GLUT_KEY_REPEAT_OFF		= 0x0000;
const GLuint GLUT_KEY_REPEAT_ON			= 0x0001;
const GLuint GLUT_KEY_REPEAT_DEFAULT		= 0x0002;

const GLuint GLUT_JOYSTICK_BUTTON_A		= 0x0001;
const GLuint GLUT_JOYSTICK_BUTTON_B		= 0x0002;
const GLuint GLUT_JOYSTICK_BUTTON_C		= 0x0004;
const GLuint GLUT_JOYSTICK_BUTTON_D		= 0x0008;

// GLUT API macro definitions -- game mode definitions
const GLuint GLUT_GAME_MODE_ACTIVE		= 0x0000;
const GLuint GLUT_GAME_MODE_POSSIBLE		= 0x0001;
const GLuint GLUT_GAME_MODE_WIDTH		= 0x0002;
const GLuint GLUT_GAME_MODE_HEIGHT		= 0x0003;
const GLuint GLUT_GAME_MODE_PIXEL_DEPTH		= 0x0004;
const GLuint GLUT_GAME_MODE_REFRESH_RATE	= 0x0005;
const GLuint GLUT_GAME_MODE_DISPLAY_CHANGED	= 0x0006;

// FreeGlut extra definitions
version (FREEGLUT_EXTRAS) 
{
	/*
	 * GLUT API Extension macro definitions -- behaviour when the user clicks on an "x" to close a window
	 */
	const GLuint GLUT_ACTION_EXIT		= 0;
	const GLuint GLUT_ACTION_GLUTMAINLOOP_RETURNS= 1;
	const GLuint GLUT_ACTION_CONTINUE_EXECUTION= 2;

	/*
	 * Create a new rendering context when the user opens a new window?
	 */
	const GLuint GLUT_CREATE_NEW_CONTEXT	= 0;
	const GLuint GLUT_USE_CURRENT_CONTEXT	= 1;

	/*
	 * Direct/Indirect rendering context options (has meaning only in Unix/X11)
	 */
	const GLuint GLUT_FORCE_INDIRECT_CONTEXT= 0;
	const GLuint GLUT_ALLOW_DIRECT_CONTEXT	= 1;
	const GLuint GLUT_TRY_DIRECT_CONTEXT	= 2;
	const GLuint GLUT_FORCE_DIRECT_CONTEXT	= 3;

	/*
	 * GLUT API Extension macro definitions -- the glutGet parameters
	 */
	const GLuint GLUT_ACTION_ON_WINDOW_CLOSE= 0x01F9;
	const GLuint GLUT_WINDOW_BORDER_WIDTH	= 0x01FA;
	const GLuint GLUT_WINDOW_HEADER_HEIGHT	= 0x01FB;
	const GLuint GLUT_VERSION		= 0x01FC;
	const GLuint GLUT_RENDERING_CONTEXT	= 0x01FD;
	const GLuint GLUT_DIRECT_RENDERING	= 0x01FE;

	/*
	 * New tokens for glutInitDisplayMode.
	 * Only one GLUT_AUXn bit may be used at a time.
	 * Value 0x0400 is defined in OpenGLUT.
	 */
	const GLuint GLUT_AUX1			= 0x1000;
	const GLuint GLUT_AUX2			= 0x2000;
	const GLuint GLUT_AUX3			= 0x4000;
	const GLuint GLUT_AUX4			= 0x8000;
}

/*
 * Functions
 */
private void load(SharedLib lib)
{
	bindFunc(glutInit)("glutInit", lib);
	bindFunc(glutInitWindowPosition)("glutInitWindowPosition", lib);
	bindFunc(glutInitWindowSize)("glutInitWindowSize", lib);
	bindFunc(glutInitDisplayMode)("glutInitDisplayMode", lib);
	bindFunc(glutInitDisplayString)("glutInitDisplayString", lib);
	bindFunc(glutMainLoop)("glutMainLoop", lib);
	bindFunc(glutCreateWindow)("glutCreateWindow", lib);
	bindFunc(glutCreateSubWindow)("glutCreateSubWindow", lib);
	bindFunc(glutDestroyWindow)("glutDestroyWindow", lib);
	bindFunc(glutSetWindow)("glutSetWindow", lib);
	bindFunc(glutGetWindow)("glutGetWindow", lib);
	bindFunc(glutSetWindowTitle)("glutSetWindowTitle", lib);
	bindFunc(glutSetIconTitle)("glutSetIconTitle", lib);
	bindFunc(glutReshapeWindow)("glutReshapeWindow", lib);
	bindFunc(glutPositionWindow)("glutPositionWindow", lib);
	bindFunc(glutShowWindow)("glutShowWindow", lib);
	bindFunc(glutHideWindow)("glutHideWindow", lib);
	bindFunc(glutIconifyWindow)("glutIconifyWindow", lib);
	bindFunc(glutPushWindow)("glutPushWindow", lib);
	bindFunc(glutPopWindow)("glutPopWindow", lib);
	bindFunc(glutFullScreen)("glutFullScreen", lib);
	bindFunc(glutPostWindowRedisplay)("glutPostWindowRedisplay", lib);
	bindFunc(glutPostRedisplay)("glutPostRedisplay", lib);
	bindFunc(glutSwapBuffers)("glutSwapBuffers", lib);
	bindFunc(glutWarpPointer)("glutWarpPointer", lib);
	bindFunc(glutSetCursor)("glutSetCursor", lib);
	bindFunc(glutEstablishOverlay)("glutEstablishOverlay", lib);
	bindFunc(glutRemoveOverlay)("glutRemoveOverlay", lib);
	bindFunc(glutUseLayer)("glutUseLayer", lib);
	bindFunc(glutPostOverlayRedisplay)("glutPostOverlayRedisplay", lib);
	bindFunc(glutPostWindowOverlayRedisplay)("glutPostWindowOverlayRedisplay", lib);
	bindFunc(glutHideOverlay)("glutHideOverlay", lib);
	bindFunc(glutCreateMenu)("glutCreateMenu", lib);
	bindFunc(glutDestroyMenu)("glutDestroyMenu", lib);
	bindFunc(glutGetMenu)("glutGetMenu", lib);
	bindFunc(glutSetMenu)("glutSetMenu", lib);
	bindFunc(glutAddMenuEntry)("glutAddMenuEntry", lib);
	bindFunc(glutAddSubMenu)("glutAddSubMenu", lib);
	bindFunc(glutChangeToMenuEntry)("glutChangeToMenuEntry", lib);
	bindFunc(glutChangeToSubMenu)("glutChangeToSubMenu", lib);
	bindFunc(glutRemoveMenuItem)("glutRemoveMenuItem", lib);
	bindFunc(glutAttachMenu)("glutAttachMenu", lib);
	bindFunc(glutDetachMenu)("glutDetachMenu", lib);
	bindFunc(glutTimerFunc)("glutTimerFunc", lib);
	bindFunc(glutIdleFunc)("glutIdleFunc", lib);
	bindFunc(glutKeyboardFunc)("glutKeyboardFunc", lib);
	bindFunc(glutSpecialFunc)("glutSpecialFunc", lib);
	bindFunc(glutReshapeFunc)("glutReshapeFunc", lib);
	bindFunc(glutVisibilityFunc)("glutVisibilityFunc", lib);
	bindFunc(glutDisplayFunc)("glutDisplayFunc", lib);
	bindFunc(glutMouseFunc)("glutMouseFunc", lib);
	bindFunc(glutMotionFunc)("glutMotionFunc", lib);
	bindFunc(glutPassiveMotionFunc)("glutPassiveMotionFunc", lib);
	bindFunc(glutEntryFunc)("glutEntryFunc", lib);
	bindFunc(glutKeyboardUpFunc)("glutKeyboardUpFunc", lib);
	bindFunc(glutSpecialUpFunc)("glutSpecialUpFunc", lib);
	bindFunc(glutJoystickFunc)("glutJoystickFunc", lib);
	bindFunc(glutMenuStateFunc)("glutMenuStateFunc", lib);
	bindFunc(glutMenuStatusFunc)("glutMenuStatusFunc", lib);
	bindFunc(glutOverlayDisplayFunc)("glutOverlayDisplayFunc", lib);
	bindFunc(glutWindowStatusFunc)("glutWindowStatusFunc", lib);
	bindFunc(glutSpaceballMotionFunc)("glutSpaceballMotionFunc", lib);
	bindFunc(glutSpaceballRotateFunc)("glutSpaceballRotateFunc", lib);
	bindFunc(glutSpaceballButtonFunc)("glutSpaceballButtonFunc", lib);
	bindFunc(glutButtonBoxFunc)("glutButtonBoxFunc", lib);
	bindFunc(glutDialsFunc)("glutDialsFunc", lib);
	bindFunc(glutTabletMotionFunc)("glutTabletMotionFunc", lib);
	bindFunc(glutTabletButtonFunc)("glutTabletButtonFunc", lib);
	bindFunc(glutGet)("glutGet", lib);
	bindFunc(glutDeviceGet)("glutDeviceGet", lib);
	bindFunc(glutGetModifiers)("glutGetModifiers", lib);
	bindFunc(glutLayerGet)("glutLayerGet", lib);
	bindFunc(glutBitmapCharacter)("glutBitmapCharacter", lib);
	bindFunc(glutBitmapWidth)("glutBitmapWidth", lib);
	bindFunc(glutStrokeCharacter)("glutStrokeCharacter", lib);
	bindFunc(glutStrokeWidth)("glutStrokeWidth", lib);
	bindFunc(glutBitmapLength)("glutBitmapLength", lib);
	bindFunc(glutStrokeLength)("glutStrokeLength", lib);
	bindFunc(glutWireCube)("glutWireCube", lib);
	bindFunc(glutSolidCube)("glutSolidCube", lib);
	bindFunc(glutWireSphere)("glutWireSphere", lib);
	bindFunc(glutSolidSphere)("glutSolidSphere", lib);
	bindFunc(glutWireCone)("glutWireCone", lib);
	bindFunc(glutSolidCone)("glutSolidCone", lib);
	bindFunc(glutWireTorus)("glutWireTorus", lib);
	bindFunc(glutSolidTorus)("glutSolidTorus", lib);
	bindFunc(glutWireDodecahedron)("glutWireDodecahedron", lib);
	bindFunc(glutSolidDodecahedron)("glutSolidDodecahedron", lib);
	bindFunc(glutWireOctahedron)("glutWireOctahedron", lib);
	bindFunc(glutSolidOctahedron)("glutSolidOctahedron", lib);
	bindFunc(glutWireTetrahedron)("glutWireTetrahedron", lib);
	bindFunc(glutSolidTetrahedron)("glutSolidTetrahedron", lib);
	bindFunc(glutWireIcosahedron)("glutWireIcosahedron", lib);
	bindFunc(glutSolidIcosahedron)("glutSolidIcosahedron", lib);
	bindFunc(glutWireTeapot)("glutWireTeapot", lib);
	bindFunc(glutSolidTeapot)("glutSolidTeapot", lib);
	bindFunc(glutGameModeString)("glutGameModeString", lib);
	bindFunc(glutEnterGameMode)("glutEnterGameMode", lib);
	bindFunc(glutLeaveGameMode)("glutLeaveGameMode", lib);
	bindFunc(glutGameModeGet)("glutGameModeGet", lib);
	bindFunc(glutVideoResizeGet)("glutVideoResizeGet", lib);
	bindFunc(glutSetupVideoResizing)("glutSetupVideoResizing", lib);
	bindFunc(glutStopVideoResizing)("glutStopVideoResizing", lib);
	bindFunc(glutVideoResize)("glutVideoResize", lib);
	bindFunc(glutVideoPan)("glutVideoPan", lib);
	bindFunc(glutSetColor)("glutSetColor", lib);
	bindFunc(glutGetColor)("glutGetColor", lib);
	bindFunc(glutCopyColormap)("glutCopyColormap", lib);
	bindFunc(glutIgnoreKeyRepeat)("glutIgnoreKeyRepeat", lib);
	bindFunc(glutSetKeyRepeat)("glutSetKeyRepeat", lib);
	bindFunc(glutForceJoystickFunc)("glutForceJoystickFunc", lib);
	bindFunc(glutExtensionSupported)("glutExtensionSupported", lib);
	bindFunc(glutReportErrors)("glutReportErrors", lib);

	version (FREEGLUT_EXTRAS)
	{
		bindFunc(glutMainLoopEvent)("glutMainLoopEvent", lib);
		bindFunc(glutLeaveMainLoop)("glutLeaveMainLoop", lib);
		bindFunc(glutMouseWheelFunc)("glutMouseWheelFunc", lib);
		bindFunc(glutCloseFunc)("glutCloseFunc", lib);
		bindFunc(glutWMCloseFunc)("glutWMCloseFunc", lib);
		bindFunc(glutMenuDestroyFunc)("glutMenuDestroyFunc", lib);
		bindFunc(glutSetOption)("glutSetOption", lib);
		bindFunc(glutGetWindowData)("glutGetWindowData", lib);
		bindFunc(glutSetWindowData)("glutSetWindowData", lib);
		bindFunc(glutGetMenuData)("glutGetMenuData", lib);
		bindFunc(glutSetMenuData)("glutSetMenuData", lib);
		bindFunc(glutBitmapHeight)("glutBitmapHeight", lib);
		bindFunc(glutStrokeHeight)("glutStrokeHeight", lib);
		bindFunc(glutBitmapString)("glutBitmapString", lib);
		bindFunc(glutStrokeString)("glutStrokeString", lib);
		bindFunc(glutWireRhombicDodecahedron)("glutWireRhombicDodecahedron", lib);
		bindFunc(glutSolidRhombicDodecahedron)("glutSolidRhombicDodecahedron", lib);
		bindFunc(glutWireSierpinskiSponge)("glutWireSierpinskiSponge", lib);
		bindFunc(glutSolidSierpinskiSponge)("glutSolidSierpinskiSponge", lib);
		bindFunc(glutWireCylinder)("glutWireCylinder", lib);
		bindFunc(glutSolidCylinder)("glutSolidCylinder", lib);
		bindFunc(glutGetProcAddress)("glutGetProcAddress", lib);
	}
}

GenericLoader DerelictGLUT;
static this() 
{
    DerelictGLUT.setup(
        "glut32.dll",
        "libglut.so",
        // on Mac, the GLU functions are in the OpenGL framework
        "/System/Library/Frameworks/GLUT.framework",
        &load
    );
}
typedef void function(GLchar, GLint, GLint) KB_callback;
typedef void function() Display_callback;
typedef void function() GLUTproc;

private alias void function() fn_V;
private alias void function(GLubyte, GLint, GLint) fn_VuBII;
private alias void function(GLint) fn_VI;
private alias void function(GLint, GLint) fn_VII;
private alias void function(GLint, GLint, GLint) fn_VIII;
private alias void function(GLint, GLint, GLint, GLint) fn_VIIII;
private alias void function(GLuint, GLint, GLint, GLint) fn_VuIIII;

version (Windows) {
	extern (Windows):
} else {
	extern (System):
}
 void function(GLint*, GLchar**) glutInit;
 void function(GLint, GLint) glutInitWindowPosition;
 void function(GLint, GLint) glutInitWindowSize;
 void function(GLuint) glutInitDisplayMode;
 void function(GLchar*) glutInitDisplayString;
 void function() glutMainLoop;
 GLint function(GLchar*) glutCreateWindow;
 GLint function(GLint, GLint, GLint, GLint, GLint) glutCreateSubWindow;
 void function(GLint) glutDestroyWindow;
 void function(GLint) glutSetWindow;
 GLint function() glutGetWindow;
 void function(GLchar*) glutSetWindowTitle;
 void function(GLchar*) glutSetIconTitle;
 void function(GLint, GLint) glutReshapeWindow;
 void function(GLint, GLint) glutPositionWindow;
 void function() glutShowWindow;
 void function() glutHideWindow;
 void function() glutIconifyWindow;
 void function() glutPushWindow;
 void function() glutPopWindow;
 void function() glutFullScreen;
 void function(GLint) glutPostWindowRedisplay;
 void function() glutPostRedisplay;
 void function() glutSwapBuffers;
 void function(GLint, GLint) glutWarpPointer;
 void function(GLint) glutSetCursor;
 void function() glutEstablishOverlay;
 void function() glutRemoveOverlay;
 void function(GLenum) glutUseLayer;
 void function() glutPostOverlayRedisplay;
 void function(GLint) glutPostWindowOverlayRedisplay;
 void function() glutShowOverlay;
 void function() glutHideOverlay;
 GLint function(fn_VI) glutCreateMenu;
 void function(GLint) glutDestroyMenu;
 GLint function() glutGetMenu;
 void function(GLint) glutSetMenu;
 void function(GLchar*, GLint) glutAddMenuEntry;
 void function(GLchar*, GLint) glutAddSubMenu;
 void function(GLint, GLchar*, GLint) glutChangeToMenuEntry;
 void function(GLint, GLchar*, GLint) glutChangeToSubMenu;
 void function(GLint) glutRemoveMenuItem;
 void function(GLint) glutAttachMenu;
 void function(GLint) glutDetachMenu;
 void function(GLuint, fn_VI, GLint) glutTimerFunc;
 void function(fn_V) glutIdleFunc;
 void function(KB_callback) glutKeyboardFunc;
 void function(fn_VIII) glutSpecialFunc;
 void function(fn_VII) glutReshapeFunc;
 void function(fn_VI) glutVisibilityFunc;
 void function(Display_callback) glutDisplayFunc;
 void function(fn_VIIII) glutMouseFunc;
 void function(fn_VII) glutMotionFunc;
 void function(fn_VII) glutPassiveMotionFunc;
 void function(fn_VI) glutEntryFunc;
 void function(fn_VuBII) glutKeyboardUpFunc;
 void function(KB_callback) glutSpecialUpFunc;
 void function(fn_VuIIII, GLint) glutJoystickFunc;
 void function(fn_VI) glutMenuStateFunc;
 void function(fn_VIII) glutMenuStatusFunc;
 void function(Display_callback) glutOverlayDisplayFunc;
 void function(fn_VI) glutWindowStatusFunc;
 void function(fn_VIII) glutSpaceballMotionFunc;
 void function(fn_VIII) glutSpaceballRotateFunc;
 void function(fn_VII) glutSpaceballButtonFunc;
 void function(fn_VII) glutButtonBoxFunc;
 void function(fn_VII) glutDialsFunc;
 void function(fn_VII) glutTabletMotionFunc;
 void function(fn_VIIII) glutTabletButtonFunc;
 GLint function(GLenum) glutGet;
 GLint function(GLenum) glutDeviceGet;
 GLint function() glutGetModifiers;
 GLint function(GLenum) glutLayerGet;
 void function(void*, GLint) glutBitmapCharacter;
 GLint function(void*, GLint) glutBitmapWidth;
 void function(void*, GLint) glutStrokeCharacter;
 GLint function(void*, GLint) glutStrokeWidth;
 GLint function(void*, GLubyte*) glutBitmapLength;
 GLint function(void*, GLubyte*) glutStrokeLength;
 void function(GLdouble) glutWireCube;
 void function(GLdouble) glutSolidCube;
 void function(GLdouble, GLint, GLint) glutWireSphere;
 void function(GLdouble, GLint, GLint) glutSolidSphere;
 void function(GLdouble, GLdouble, GLint, GLint) glutWireCone;
 void function(GLdouble, GLdouble, GLint, GLint) glutSolidCone;
 void function(GLdouble, GLdouble, GLint, GLint) glutWireTorus;
 void function(GLdouble, GLdouble, GLint, GLint) glutSolidTorus;
 void function() glutWireDodecahedron;
 void function() glutSolidDodecahedron;
 void function() glutWireOctahedron;
 void function() glutSolidOctahedron;
 void function() glutWireTetrahedron;
 void function() glutSolidTetrahedron;
 void function() glutWireIcosahedron;
 void function() glutSolidIcosahedron;
 void function(GLdouble) glutWireTeapot;
 void function(GLdouble) glutSolidTeapot;
 void function(GLchar*) glutGameModeString;
 GLint function() glutEnterGameMode;
 void function() glutLeaveGameMode;
 GLint function(GLenum) glutGameModeGet;
 GLint function(GLenum) glutVideoResizeGet;
 void function() glutSetupVideoResizing;
 void function() glutStopVideoResizing;
 void function(GLint, GLint, GLint, GLint) glutVideoResize;
 void function(GLint, GLint, GLint, GLint) glutVideoPan;
 void function(GLint, GLfloat, GLfloat, GLfloat) glutSetColor;
 GLfloat function(GLint, GLint) glutGetColor;
 void function(GLint) glutCopyColormap;
 void function(GLint) glutIgnoreKeyRepeat;
 void function(GLint) glutSetKeyRepeat;
 void function() glutForceJoystickFunc;
 GLint function(GLchar*) glutExtensionSupported;
 void function() glutReportErrors;


/*
 * FreeGlut extra functions
 */
version (FREEGLUT_EXTRAS)
{
	 void function() glutMainLoopEvent;
		void function() glutLeaveMainLoop;
		void function(fn_VIIII) glutMouseWheelFunc;
		void function(fn_V) glutCloseFunc;
		void function(fn_V) glutWMCloseFunc;
		void function(fn_V) glutMenuDestroyFunc;
		void function(GLenum, GLint) glutSetOption;
		void* function() glutGetWindowData;
		void function(void*) glutSetWindowData;
		void* function() glutGetMenuData;
		void function(void*) glutSetMenuData;
		GLint function(void*) glutBitmapHeight;
		GLfloat function(void*) glutStrokeHeight;
		void function(void*, GLchar*) glutBitmapString;
		void function(void*, GLchar*) glutStrokeString;
		void function() glutWireRhombicDodecahedron;
		void function() glutSolidRhombicDodecahedron;
		void function(GLint, GLdouble[3], GLdouble) glutWireSierpinskiSponge;
		void function(GLint, GLdouble[3], GLdouble) glutSolidSierpinskiSponge;
		void function(GLdouble, GLdouble, GLint, GLint) glutWireCylinder;
		void function(GLdouble, GLdouble, GLint, GLint) glutSolidCylinder;
		GLUTproc function(GLchar*) glutGetProcAddress;

}