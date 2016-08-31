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
 *      Unix-specific header defines.
 *
 *      By Michael Bukin.
 *
 *      D version by torhu.
 *
 *      See readme.txt for copyright information.
 */

module derelict.allegro.platform.alunix;

import derelict.allegro.base : _AL_ID;



/************************************/
/*********** Sound drivers **********/
/************************************/
const int DIGI_OSS             = _AL_ID!('O','S','S','D');
const int MIDI_OSS             = _AL_ID!('O','S','S','M');
const int DIGI_ESD             = _AL_ID!('E','S','D','D');
const int DIGI_ARTS            = _AL_ID!('A','R','T','S');
const int DIGI_ALSA            = _AL_ID!('A','L','S','A');
const int MIDI_ALSA            = _AL_ID!('A','M','I','D');
const int DIGI_JACK            = _AL_ID!('J','A','C','K');



/************************************/
/************ X-specific ************/
/************************************/
const int GFX_XWINDOWS            = _AL_ID!('X','W','I','N');
const int GFX_XWINDOWS_FULLSCREEN = _AL_ID!('X','W','F','S');
const int GFX_XDGA2               = _AL_ID!('D','G','A','2');
const int GFX_XDGA2_SOFT          = _AL_ID!('D','G','A','S');



/****************************************/
/************ Linux-specific ************/
/****************************************/
const int GFX_VGA                 = _AL_ID!('V','G','A',' ');
const int GFX_MODEX               = _AL_ID!('M','O','D','X');
const int GFX_FBCON               = _AL_ID!('F','B',' ',' ');
const int GFX_VBEAF               = _AL_ID!('V','B','A','F');
const int GFX_SVGALIB             = _AL_ID!('S','V','G','A');

const int JOY_TYPE_LINUX_ANALOGUE = _AL_ID!('L','N','X','A');



extern (C)
deprecated void split_modex_screen(int lyne);
