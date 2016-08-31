/*
 * Copyright (c) 2004-2009 Derelict Developers
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
 * * Neither the names 'Derelict', 'DerelictAL', nor the names of its contributors
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
module derelict.openal.alctypes;

const bool ALC_VERSION_0_1 = true;

alias void ALCdevice;
alias void ALCcontext;

alias byte ALCboolean;
alias char ALCchar;
alias byte ALCbyte;
alias ubyte ALCubyte;
alias short ALCshort;
alias ushort ALCushort;
alias int ALCint;
alias uint ALCuint;
alias int ALCsizei;
alias int ALCenum;
alias float ALCfloat;
alias double ALCdouble;
alias void ALCvoid;

enum : ALCboolean
{
    ALC_FALSE           = 0,
    ALC_TRUE            = 1,
}

enum : ALCenum
{
    ALC_FREQUENCY           = 0x1007,
    ALC_REFRESH             = 0x1008,
    ALC_SYNC                = 0x1009,

    ALC_MONO_SOURCES        = 0x1010,
    ALC_STEREO_SOURCES      = 0x1011,

    ALC_NO_ERROR            = ALC_FALSE,
    ALC_INVALID_DEVICE      = 0xA001,
    ALC_INVALID_CONTEXT     = 0xA002,
    ALC_INVALID_ENUM        = 0xA003,
    ALC_INVALID_VALUE       = 0xA004,
    ALC_OUT_OF_MEMORY       = 0xA005,

    ALC_DEFAULT_DEVICE_SPECIFIER        = 0x1004,
    ALC_DEVICE_SPECIFIER                = 0x1005,
    ALC_EXTENSIONS                      = 0x1006,

    ALC_MAJOR_VERSION                   = 0x1000,
    ALC_MINOR_VERSION                   = 0x1001,

    ALC_ATTRIBUTES_SIZE                 = 0x1002,
    ALC_ALL_ATTRIBUTES                  = 0x1003,

    ALC_CAPTURE_DEVICE_SPECIFIER            = 0x310,
    ALC_CAPTURE_DEFAULT_DEVICE_SPECIFIER    = 0x311,
    ALC_CAPTURE_SAMPLES                     = 0x312,
}