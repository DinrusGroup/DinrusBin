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
module derelict.openal.alcfuncs;

private
{
    import derelict.openal.alctypes;
    import derelict.util.loader;
}

package void loadALC(SharedLib lib)
{
    bindFunc(alcCreateContext)("alcCreateContext", lib);
    bindFunc(alcMakeContextCurrent)("alcMakeContextCurrent", lib);
    bindFunc(alcProcessContext)("alcProcessContext", lib);
    bindFunc(alcGetCurrentContext)("alcGetCurrentContext", lib);
    bindFunc(alcGetContextsDevice)("alcGetContextsDevice", lib);
    bindFunc(alcSuspendContext)("alcSuspendContext", lib);
    bindFunc(alcDestroyContext)("alcDestroyContext", lib);
    bindFunc(alcOpenDevice)("alcOpenDevice", lib);
    bindFunc(alcCloseDevice)("alcCloseDevice", lib);
    bindFunc(alcGetError)("alcGetError", lib);
    bindFunc(alcIsExtensionPresent)("alcIsExtensionPresent", lib);
    bindFunc(alcGetProcAddress)("alcGetProcAddress", lib);
    bindFunc(alcGetEnumValue)("alcGetEnumValue", lib);
    bindFunc(alcGetString)("alcGetString", lib);
    bindFunc(alcGetIntegerv)("alcGetIntegerv", lib);
    bindFunc(alcCaptureOpenDevice)("alcCaptureOpenDevice", lib);
    bindFunc(alcCaptureCloseDevice)("alcCaptureCloseDevice", lib);
    bindFunc(alcCaptureStart)("alcCaptureStart", lib);
    bindFunc(alcCaptureStop)("alcCaptureStop", lib);
    bindFunc(alcCaptureSamples)("alcCaptureSamples", lib);

}

extern(C):


ALCcontext* function(ALCdevice*, in ALCint*) alcCreateContext;
ALCboolean function(ALCcontext*) alcMakeContextCurrent;
void function(ALCcontext*) alcProcessContext;
void function(ALCcontext*) alcSuspendContext;
void function(ALCcontext*) alcDestroyContext;
ALCcontext* function() alcGetCurrentContext;
ALCdevice* function(ALCcontext*) alcGetContextsDevice;
ALCdevice* function(in ALCchar*) alcOpenDevice;
ALCboolean function(ALCdevice*) alcCloseDevice;
ALCenum function(ALCdevice*) alcGetError;
ALCboolean function(ALCdevice*, in char*) alcIsExtensionPresent;
void* function(ALCdevice*, in char*) alcGetProcAddress;
ALCenum function(ALCdevice*, in char*) alcGetEnumValue;
char* function(ALCdevice*, ALCenum) alcGetString;
void function(ALCdevice*, ALCenum, ALCsizei, ALCint*) alcGetIntegerv;
ALCdevice* function(in char*, ALCuint, ALCenum, ALCsizei) alcCaptureOpenDevice;
ALCboolean function(ALCdevice*) alcCaptureCloseDevice;
void function(ALCdevice*) alcCaptureStart;
void function(ALCdevice*) alcCaptureStop;
void function(ALCdevice*, ALCvoid*, ALCsizei) alcCaptureSamples;