/*
 * Copyright (c) 2005-2006 Derelict Developers
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the names 'Derelict', 'DerelictIL', nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
module derelict.bassmod.bassmodtypes;

alias ubyte BOOL;
alias ushort WORD;
alias uint DWORD;

// synchronizer handle
alias uint HSYNC;
alias void function(HSYNC handle, DWORD data, DWORD user) SYNCPROC;
/* Sync callback function. NOTE: a sync callback function should be very
quick as other syncs can't be processed until it has finished.
handle : The sync that has occured
data   : Additional data associated with the sync's occurance */
version(Windows){
	extern(Windows):}
else
	extern(C):


// Error codes returned by BASSMOD_GetErrorCode()
const DWORD BASS_OK             = 0;   // all is OK
const DWORD BASS_ERROR_MEM      = 1;   // memory error
const DWORD BASS_ERROR_FILEOPEN = 2;   // can't open the file
const DWORD BASS_ERROR_DRIVER   = 3;   // can't find a free/valid driver
const DWORD BASS_ERROR_HANDLE   = 5;   // invalid handle
const DWORD BASS_ERROR_FORMAT   = 6;   // unsupported format
const DWORD BASS_ERROR_POSITION = 7;   // invalid playback position
const DWORD BASS_ERROR_INIT     = 8;   // BASS_Init has not been successfully called
const DWORD BASS_ERROR_ALREADY  = 14;  // already initialized/loaded
const DWORD BASS_ERROR_ILLTYPE  = 19;  // an illegal type was specified
const DWORD BASS_ERROR_ILLPARAM = 20;  // an illegal parameter was specified
const DWORD BASS_ERROR_DEVICE   = 23;  // illegal device number
const DWORD BASS_ERROR_NOPLAY   = 24;  // not playing
const DWORD BASS_ERROR_NOMUSIC  = 28;  // no MOD music has been loaded
const DWORD BASS_ERROR_NOSYNC   = 30;  // synchronizers have been disabled
const DWORD BASS_ERROR_NOTAVAIL = 37;  // requested data is not available
const DWORD BASS_ERROR_DECODE   = 38;  // the channel is a "decoding channel"
const DWORD BASS_ERROR_FILEFORM = 41;  // unsupported file format
const DWORD BASS_ERROR_UNKNOWN  = -1;  // some other mystery error

// Device setup flags
const DWORD BASS_DEVICE_8BITS   = 1;   // use 8 bit resolution, else 16 bit
const DWORD BASS_DEVICE_MONO    = 2;   // use mono, else stereo
const DWORD BASS_DEVICE_NOSYNC  = 16;  // disable synchronizers

// Music flags
const DWORD BASS_MUSIC_RAMP     = 1;   // normal ramping
const DWORD BASS_MUSIC_RAMPS    = 2;   // sensitive ramping
const DWORD BASS_MUSIC_LOOP     = 4;   // loop music
const DWORD BASS_MUSIC_FT2MOD   = 16;  // play .MOD as FastTracker 2 does
const DWORD BASS_MUSIC_PT1MOD   = 32;  // play .MOD as ProTracker 1 does
const DWORD BASS_MUSIC_POSRESET = 256; // stop all notes when moving position
const DWORD BASS_MUSIC_SURROUND = 512; // surround sound
const DWORD BASS_MUSIC_SURROUND2= 1024;    // surround sound (mode 2)
const DWORD BASS_MUSIC_STOPBACK = 2048;    // stop the music on a backwards jump effect
const DWORD BASS_MUSIC_CALCLEN  = 8192;    // calculate playback length
const DWORD BASS_MUSIC_NONINTER = 16384;   // non-interpolated mixing
const DWORD BASS_MUSIC_NOSAMPLE = 0x400000;// don't load the samples

const DWORD BASS_UNICODE        = 0x80000000;

/* Sync types (with BASSMOD_MusicSetSync() "param" and SYNCPROC "data"
definitions) & flags. */
const DWORD BASS_SYNC_MUSICPOS  = 0;
const DWORD BASS_SYNC_POS       = 0;
/* Sync when the music reaches a position.
param: LOWORD=order (0=first, -1=all) HIWORD=row (0=first, -1=all)
data : LOWORD=order HIWORD=row */
const DWORD BASS_SYNC_MUSICINST = 1;
/* Sync when an instrument (sample for the non-instrument based formats)
is played in the music (not including retrigs).
param: LOWORD=instrument (1=first) HIWORD=note (0=c0...119=b9, -1=all)
data : LOWORD=note HIWORD=volume (0-64) */
const DWORD BASS_SYNC_END       = 2;
/* Sync when the music reaches the end.
param: not used
data : 1 = the sync is triggered by a backward jump, otherwise not used */
const DWORD BASS_SYNC_MUSICFX   = 3;
/* Sync when the "sync" effect (XM/MTM/MOD: E8x/Wxx, IT/S3M: S2x) is used.
param: 0:data=pos, 1:data="x" value
data : param=0: LOWORD=order HIWORD=row, param=1: "x" value */
const DWORD BASS_SYNC_ONETIME   = 0x80000000;  // FLAG: sync only once, else continuously

// BASSMOD_MusicIsActive return values
const DWORD BASS_ACTIVE_STOPPED = 0;
const DWORD BASS_ACTIVE_PLAYING = 1;
const DWORD BASS_ACTIVE_PAUSED  = 3;
