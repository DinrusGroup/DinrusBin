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
module derelict.openal.alfuncs;


private
{
    import derelict.openal.altypes;
    import derelict.openal.alctypes;
    import derelict.openal.alcfuncs;
    import derelict.util.loader;
}

private void loadAL(SharedLib lib)
{
    bindFunc(alEnable)("alEnable", lib);
    bindFunc(alDisable)("alDisable", lib);
    bindFunc(alIsEnabled)("alIsEnabled", lib);

    bindFunc(alGetString)("alGetString", lib);
    bindFunc(alGetBooleanv)("alGetBooleanv", lib);
    bindFunc(alGetIntegerv)("alGetIntegerv", lib);
    bindFunc(alGetFloatv)("alGetFloatv", lib);
    bindFunc(alGetDoublev)("alGetDoublev", lib);
    bindFunc(alGetInteger)("alGetInteger", lib);
    bindFunc(alGetFloat)("alGetFloat", lib);
    bindFunc(alGetDouble)("alGetDouble", lib);
    bindFunc(alGetError)("alGetError", lib);

    bindFunc(alIsExtensionPresent)("alIsExtensionPresent", lib);
    bindFunc(alGetProcAddress)("alGetProcAddress", lib);
    bindFunc(alGetEnumValue)("alGetEnumValue", lib);

    bindFunc(alListenerf)("alListenerf", lib);
    bindFunc(alListener3f)("alListener3f", lib);
    bindFunc(alListenerfv)("alListenerfv", lib);
    bindFunc(alListeneri)("alListeneri", lib);
    bindFunc(alListener3i)("alListener3i", lib);
    bindFunc(alListeneriv)("alListeneriv", lib);

    bindFunc(alGetListenerf)("alGetListenerf", lib);
    bindFunc(alGetListener3f)("alGetListener3f", lib);
    bindFunc(alGetListenerfv)("alGetListenerfv", lib);
    bindFunc(alGetListeneri)("alGetListeneri", lib);
    bindFunc(alGetListener3i)("alGetListener3i", lib);
    bindFunc(alGetListeneriv)("alGetListeneriv", lib);

    bindFunc(alGenSources)("alGenSources", lib);
    bindFunc(alDeleteSources)("alDeleteSources", lib);
    bindFunc(alIsSource)("alIsSource", lib);

    bindFunc(alSourcef)("alSourcef", lib);
    bindFunc(alSource3f)("alSource3f", lib);
    bindFunc(alSourcefv)("alSourcefv", lib);
    bindFunc(alSourcei)("alSourcei", lib);
    bindFunc(alSource3i)("alSource3i", lib);
    bindFunc(alSourceiv)("alSourceiv", lib);

    bindFunc(alGetSourcef)("alGetSourcef", lib);
    bindFunc(alGetSource3f)("alGetSource3f", lib);
    bindFunc(alGetSourcefv)("alGetSourcefv", lib);
    bindFunc(alGetSourcei)("alGetSourcei", lib);
    bindFunc(alGetSourceiv)("alGetSourceiv", lib);

    bindFunc(alSourcePlayv)("alSourcePlayv", lib);
    bindFunc(alSourceStopv)("alSourceStopv", lib);
    bindFunc(alSourceRewindv)("alSourceRewindv", lib);
    bindFunc(alSourcePausev)("alSourcePausev", lib);
    bindFunc(alSourcePlay)("alSourcePlay", lib);
    bindFunc(alSourcePause)("alSourcePause", lib);
    bindFunc(alSourceRewind)("alSourceRewind", lib);
    bindFunc(alSourceStop)("alSourceStop", lib);

    bindFunc(alSourceQueueBuffers)("alSourceQueueBuffers", lib);
    bindFunc(alSourceUnqueueBuffers)("alSourceUnqueueBuffers", lib);

    bindFunc(alGenBuffers)("alGenBuffers", lib);
    bindFunc(alDeleteBuffers)("alDeleteBuffers", lib);
    bindFunc(alIsBuffer)("alIsBuffer", lib);
    bindFunc(alBufferData)("alBufferData", lib);

    bindFunc(alBufferf)("alBufferf", lib);
    bindFunc(alBuffer3f)("alBuffer3f", lib);
    bindFunc(alBufferfv)("alBufferfv", lib);
    bindFunc(alBufferi)("alBufferi", lib);
    bindFunc(alBuffer3i)("alBuffer3i", lib);
    bindFunc(alBufferiv)("alBufferiv", lib);

    bindFunc(alGetBufferf)("alGetBufferf", lib);
    bindFunc(alGetBuffer3f)("alGetBuffer3f", lib);
    bindFunc(alGetBufferfv)("alGetBufferfv", lib);
    bindFunc(alGetBufferi)("alGetBufferi", lib);
    bindFunc(alGetBuffer3i)("alGetBuffer3i", lib);
    bindFunc(alGetBufferiv)("alGetBufferiv", lib);

    bindFunc(alDopplerFactor)("alDopplerFactor", lib);
    bindFunc(alDopplerVelocity)("alDopplerVelocity", lib);
    bindFunc(alSpeedOfSound)("alSpeedOfSound", lib);
    bindFunc(alDistanceModel)("alDistanceModel", lib);

    loadALC(lib);
}


GenericLoader           DerelictAL;
static this() {
    DerelictAL.setup(
        "OpenAL32.dll",
        "libal.so, libAL.so, libopenal.so, libopenal.so.1, libopenal.so.0",
        "",
        &loadAL
    );
}


extern(C):

void function(ALenum) alEnable;
void function(ALenum) alDisable;
ALboolean function(ALenum) alIsEnabled;

char* function(ALenum) alGetString;
void function(ALenum, ALboolean*) alGetBooleanv;
void function(ALenum, ALint*) alGetIntegerv;
void function(ALenum, ALfloat*) alGetFloatv;
void function(ALenum, ALdouble*) alGetDoublev;
ALboolean function(ALenum) alGetBoolean;
ALint function(ALenum) alGetInteger;
ALfloat function(ALenum) alGetFloat;
ALdouble function(ALenum) alGetDouble;
ALenum function() alGetError;

ALboolean function(in char*) alIsExtensionPresent;
ALboolean function(in char*) alGetProcAddress;
ALenum function(in char*) alGetEnumValue;

void function(ALenum, ALfloat) alListenerf;
void function(ALenum, ALfloat, ALfloat, ALfloat) alListener3f;
void function(ALenum, in ALfloat*) alListenerfv;
void function(ALenum, ALint) alListeneri;
void function(ALenum, ALint, ALint, ALint) alListener3i;
void function(ALenum, in ALint*) alListeneriv;

void function(ALenum, ALfloat*) alGetListenerf;
void function(ALenum, ALfloat*, ALfloat*, ALfloat*) alGetListener3f;
void function(ALenum, ALfloat*) alGetListenerfv;
void function(ALenum, ALint*) alGetListeneri;
void function(ALenum, ALint*, ALint*, ALint*) alGetListener3i;
void function(ALenum, ALint*) alGetListeneriv;

void function(ALsizei, ALuint*) alGenSources;
void function(ALsizei, in ALuint*) alDeleteSources;
ALboolean function(ALuint) alIsSource;

void function(ALuint, ALenum, ALfloat) alSourcef;
void function(ALuint, ALenum, ALfloat, ALfloat, ALfloat) alSource3f;
void function(ALuint, ALenum, in ALfloat*) alSourcefv;
void function(ALuint, ALenum, ALint) alSourcei;
void function(ALuint, ALenum, ALint, ALint, ALint) alSource3i;
void function(ALuint, ALenum, in ALint*) alSourceiv;


void function(ALuint, ALenum, ALfloat*) alGetSourcef;
void function(ALuint, ALenum, ALfloat*, ALfloat*, ALfloat*) alGetSource3f;
void function(ALuint, ALenum, ALfloat*) alGetSourcefv;
void function(ALuint, ALenum, ALint*) alGetSourcei;
void function(ALuint, ALenum, ALint*, ALint*, ALint*) alGetSource3i;
void function(ALuint, ALenum, ALint*) alGetSourceiv;

void function(ALsizei, in ALuint*) alSourcePlayv;
void function(ALsizei, in ALuint*) alSourceStopv;
void function(ALsizei, in ALuint*) alSourceRewindv;
void function(ALsizei, in ALuint*) alSourcePausev;
void function(ALuint) alSourcePlay;
void function(ALuint) alSourcePause;
void function(ALuint) alSourceRewind;
void function(ALuint) alSourceStop;

void function(ALuint, ALsizei, ALuint*) alSourceQueueBuffers;
void function(ALuint, ALsizei, ALuint*) alSourceUnqueueBuffers;

void function(ALsizei, ALuint*) alGenBuffers;
void function(ALsizei, in ALuint*) alDeleteBuffers;
ALboolean function(ALuint) alIsBuffer;
void function(ALuint, ALenum, in ALvoid*, ALsizei, ALsizei) alBufferData;

void function(ALuint, ALenum, ALfloat) alBufferf;
void function(ALuint, ALenum, ALfloat, ALfloat, ALfloat) alBuffer3f;
void function(ALuint, ALenum, in ALfloat*) alBufferfv;
void function(ALuint, ALenum, ALint) alBufferi;
void function(ALuint, ALenum, ALint, ALint, ALint) alBuffer3i;
void function(ALuint, ALenum, in ALint*) alBufferiv;

void function(ALuint, ALenum, ALfloat*) alGetBufferf;
void function(ALuint, ALenum, ALfloat*, ALfloat*, ALfloat*) alGetBuffer3f;
void function(ALuint, ALenum, ALfloat*) alGetBufferfv;
void function(ALuint, ALenum, ALint*) alGetBufferi;
void function(ALuint, ALenum, ALint*, ALint*, ALint*) alGetBuffer3i;
void function(ALuint, ALenum, ALint*) alGetBufferiv;

void function(ALfloat) alDopplerFactor;
void function(ALfloat) alDopplerVelocity;
void function(ALfloat) alSpeedOfSound;
void function(ALenum) alDistanceModel;