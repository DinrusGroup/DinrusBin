/*         ______   ___    ___
 *        /\  _  \ /\_ \  /\_ \
 *        \ \ \L\ \\//\ \ \//\ \      __     __   _ __   ___ 
 *         \ \  __ \ \ \ \  \ \ \   /'__`\ /'_ `\/\`'__\/ __`\
 *          \ \ \/\ \ \_\ \_ \_\ \_/\  __//\ \L\ \ \ \//\ \L\ \
 *           \ \_\ \_\/\____\/\____\ \____\ \____ \ \_\\ \____/
 *            \/_/\/_/\/____/\/____/\/____/\/___L\ \/_/ \/___/
 *                                           /\____/
 *                                           \_/__/
 *
 *      Windows-specific header defines.
 *
 *      By Shawn Hargreaves.
 *
 *      D version by torhu.
 *
 *
 *      See readme.txt for copyright information.
 */


module derelict.allegro.platform.alwin;

import derelict.allegro.base : AL_ID, _AL_ID;



/*******************************************/
/*************** gfx drivers ***************/
/*******************************************/
const int GFX_DIRECTX           = _AL_ID!('D','X','A','C');
const int GFX_DIRECTX_ACCEL     = _AL_ID!('D','X','A','C');
const int GFX_DIRECTX_SAFE      = _AL_ID!('D','X','S','A');
const int GFX_DIRECTX_SOFT      = _AL_ID!('D','X','S','O');
const int GFX_DIRECTX_WIN       = _AL_ID!('D','X','W','N');
const int GFX_DIRECTX_OVL       = _AL_ID!('D','X','O','V');
const int GFX_GDI               = _AL_ID!('G','D','I','B');



/********************************************/
/*************** sound drivers **************/
/********************************************/
int DIGI_DIRECTX(int n)   { return AL_ID('D','X','A'+n,' '); }
int DIGI_DIRECTAMX(int n) { return AL_ID('A','X','A'+n,' '); }
int DIGI_WAVOUTID(int n)  { return AL_ID('W','O','A'+n,' '); }
const int MIDI_WIN32MAPPER      = _AL_ID!('W','3','2','M');
int MIDI_WIN32(int n)     { return AL_ID('W','3','2','A'+n); }



/*******************************************/
/************ joystick drivers *************/
/*******************************************/
const int JOY_TYPE_DIRECTX      = _AL_ID!('D','X',' ',' ');
const int JOY_TYPE_WIN32        = _AL_ID!('W','3','2',' ');
