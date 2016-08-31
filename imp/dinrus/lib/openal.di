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
module lib.openal;
import dinrus;

private
{
//import stdrus;
pragma(lib,"dinrus.lib");
}

const bool AL_VERSION_1_0 = true;
const bool AL_VERSION_1_1 = true;

alias byte ALboolean;
alias char ALchar;
alias byte ALbyte;
alias ubyte ALubyte;
alias short ALshort;
alias ushort ALushort;
alias int ALint;
alias uint ALuint;
alias int ALsizei;
alias int ALenum;
alias float ALfloat;
alias double ALdouble;
alias void ALvoid;

enum : ALboolean
{
    AL_FALSE               = 0,
    AL_TRUE                = 1,
}

enum : ALenum
{
    AL_INVALID              = -1,
    AL_NONE                 = 0,

    AL_SOURCE_RELATIVE      = 0x202,

    AL_CONE_INNER_ANGLE     = 0x1001,
    AL_CONE_OUTER_ANGLE     = 0x1002,

    AL_PITCH                = 0x1003,
    AL_POSITION             = 0x1004,
    AL_DIRECTION            = 0x1005,
    AL_VELOCITY             = 0x1006,
    AL_LOOPING              = 0x1007,
    AL_BUFFER               = 0x1009,
    AL_GAIN                 = 0x100A,
    AL_MIN_GAIN             = 0x100D,
    AL_MAX_GAIN             = 0x100E,
    AL_ORIENTATION          = 0x100F,

    AL_CHANNEL_MASK         = 0x3000,

    AL_SOURCE_STATE         = 0x1010,
    AL_INITIAL              = 0x1011,
    AL_PLAYING              = 0x1012,
    AL_PAUSED               = 0x1013,
    AL_STOPPED              = 0x1014,

    AL_BUFFERS_QUEUED       = 0x1015,
    AL_BUFFERS_PROCESSED    = 0x1016,

    AL_REFERENCE_DISTANCE   = 0x1020,
    AL_ROLLOFF_FACTOR       = 0x1021,
    AL_CONE_OUTER_GAIN      = 0x1022,
    AL_MAX_DISTANCE         = 0x1023,

    AL_SEC_OFFSET           = 0x1024,
    AL_SAMPLE_OFFSET        = 0x1025,
    AL_BYTE_OFFSET          = 0x1026,

    AL_SOURCE_TYPE          = 0x1027,
    AL_STATIC               = 0x1028,
    AL_STREAMING            = 0x1029,
    AL_UNDETERMINED         = 0x1030,

    AL_FORMAT_MONO8         = 0x1100,
    AL_FORMAT_MONO16        = 0x1101,
    AL_FORMAT_STEREO8       = 0x1102,
    AL_FORMAT_STEREO16      = 0x1103,

    AL_FREQUENCEY           = 0x2001,
    AL_BITS                 = 0x2002,
    AL_CHANNELS             = 0x2003,
    AL_SIZE                 = 0x2004,

    AL_UNUSED               = 0x2010,
    AL_PENDING              = 0x2011,
    AL_PROCESSID            = 0x2012,

    AL_NO_ERROR             = AL_FALSE,

    AL_INVALID_NAME         = 0xA001,
    AL_INVALID_ENUM         = 0xA002,
    AL_INVALID_VALUE        = 0xA003,
    AL_INVALID_OPERATION    = 0xA004,
    AL_OUT_OF_MEMORY        = 0xA005,

    AL_VENDOR               = 0xB001,
    AL_VERSION              = 0xB002,
    AL_RENDERER             = 0xB003,
    AL_EXTENSIONS           = 0xB004,

    AL_DOPPLER_FACTOR       = 0xC000,
    AL_DOPPLER_VELOCITY     = 0xC001,
    AL_SPEED_OF_SOUND       = 0xC003,

    AL_DISTANCE_MODEL               = 0xD000,
    AL_INVERSE_DISTANCE             = 0xD001,
    AL_INVERSE_DISTANCE_CLAMPED     = 0xD002,
    AL_LINEAR_DISTANCE              = 0xD003,
    AL_LINEAR_DISTANCE_CLAMPED      = 0xD004,
    AL_EXPONENT_DISTANCE            = 0xD005,
    AL_EXPONENT_DISTANCE_CLAMPED    = 0xD006,
}

package проц грузиАЛК(Биб биб)
{
    вяжи(alcCreateContext)("alcCreateContext", биб);
    вяжи(alcMakeContextCurrent)("alcMakeContextCurrent", биб);
    вяжи(alcProcessContext)("alcProcessContext", биб);
    вяжи(alcGetCurrentContext)("alcGetCurrentContext", биб);
    вяжи(alcGetContextsDevice)("alcGetContextsDevice", биб);
    вяжи(alcSuspendContext)("alcSuspendContext", биб);
    вяжи(alcDestroyContext)("alcDestroyContext", биб);
    вяжи(alcOpenDevice)("alcOpenDevice", биб);
    вяжи(alcCloseDevice)("alcCloseDevice", биб);
    вяжи(alcGetError)("alcGetError", биб);
    вяжи(alcIsExtensionPresent)("alcIsExtensionPresent", биб);
    вяжи(alcGetProcAddress)("alcGetProcAddress", биб);
    вяжи(alcGetEnumValue)("alcGetEnumValue", биб);
    вяжи(alcGetString)("alcGetString", биб);
    вяжи(alcGetIntegerv)("alcGetIntegerv", биб);
    вяжи(alcCaptureOpenDevice)("alcCaptureOpenDevice", биб);
    вяжи(alcCaptureCloseDevice)("alcCaptureCloseDevice", биб);
    вяжи(alcCaptureStart)("alcCaptureStart", биб);
    вяжи(alcCaptureStop)("alcCaptureStop", биб);
    вяжи(alcCaptureSamples)("alcCaptureSamples", биб);

}


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

enum : ALenum
{
	// AL_LOKI_IMA_ADPCM_format
	AL_FORMAT_IMA_ADPCM_MONO16_EXT			= 0x10000,
	AL_FORMAT_IMA_ADPCM_STEREO16_EXT		= 0x10001,
	
	// AL_LOKI_WAVE_format
	AL_FORMAT_WAVE_EXT						= 0x10002,
	
	// AL_EXT_vorbis
	AL_FORMAT_VORBIS_EXT					= 0x10003,
	
	// AL_LOKI_quadriphonic
	AL_FORMAT_QUAD8_LOKI					= 0x10004,
	AL_FORMAT_QUAD16_LOKI					= 0x10005,
	
	// AL_EXT_float32
	AL_FORMAT_MONO_FLOAT32					= 0x10010,
	AL_FORMAT_STEREO_FLOAT32				= 0x10011,
	
	// ALC_LOKI_audio_channel
	ALC_CHAN_MAIN_LOKI						= 0x500001,
	ALC_CHAN_PCM_LOKI						= 0x500002,
	ALC_CHAN_CD_LOKI						= 0x500003,
	
	// ALC_ENUMERATE_ALL_EXT
	ALC_DEFAULT_ALL_DEVICES_SPECIFIER		= 0x1012,
	ALC_ALL_DEVICES_SPECIFIER				= 0x1013,
	
	// AL_EXT_MCFORMATS
	AL_FORMAT_QUAD8							= 0x1204,
	AL_FORMAT_QUAD16                   		= 0x1205,
	AL_FORMAT_QUAD32                   		= 0x1206,
	AL_FORMAT_REAR8                    		= 0x1207,
	AL_FORMAT_REAR16                   		= 0x1208,
	AL_FORMAT_REAR32                   		= 0x1209,
	AL_FORMAT_51CHN8                   		= 0x120A,
	AL_FORMAT_51CHN16                  		= 0x120B,
	AL_FORMAT_51CHN32                  		= 0x120C,
	AL_FORMAT_61CHN8                   		= 0x120D,
	AL_FORMAT_61CHN16                  		= 0x120E,
	AL_FORMAT_61CHN32                  		= 0x120F,
	AL_FORMAT_71CHN8                   		= 0x1210,
	AL_FORMAT_71CHN16                  		= 0x1211,
	AL_FORMAT_71CHN32                  		= 0x1212,
	
	// AL_EXT_IMA4
	AL_FORMAT_MONO_IMA4						= 0x1300,
	AL_FORMAT_STEREO_IMA4					= 0x1301,
}

private проц грузиАЛ(Биб биб)
{
    вяжи(alEnable)("alEnable", биб);
    вяжи(alDisable)("alDisable", биб);
    вяжи(alIsEnabled)("alIsEnabled", биб);

    вяжи(alGetString)("alGetString", биб);
    вяжи(alGetBooleanv)("alGetBooleanv", биб);
    вяжи(alGetIntegerv)("alGetIntegerv", биб);
    вяжи(alGetFloatv)("alGetFloatv", биб);
    вяжи(alGetDoublev)("alGetDoublev", биб);
    вяжи(alGetInteger)("alGetInteger", биб);
    вяжи(alGetFloat)("alGetFloat", биб);
    вяжи(alGetDouble)("alGetDouble", биб);
    вяжи(alGetError)("alGetError", биб);

    вяжи(alIsExtensionPresent)("alIsExtensionPresent", биб);
    вяжи(alGetProcAddress)("alGetProcAddress", биб);
    вяжи(alGetEnumValue)("alGetEnumValue", биб);

    вяжи(alListenerf)("alListenerf", биб);
    вяжи(alListener3f)("alListener3f", биб);
    вяжи(alListenerfv)("alListenerfv", биб);
    вяжи(alListeneri)("alListeneri", биб);
    вяжи(alListener3i)("alListener3i", биб);
    вяжи(alListeneriv)("alListeneriv", биб);

    вяжи(alGetListenerf)("alGetListenerf", биб);
    вяжи(alGetListener3f)("alGetListener3f", биб);
    вяжи(alGetListenerfv)("alGetListenerfv", биб);
    вяжи(alGetListeneri)("alGetListeneri", биб);
    вяжи(alGetListener3i)("alGetListener3i", биб);
    вяжи(alGetListeneriv)("alGetListeneriv", биб);

    вяжи(alGenSources)("alGenSources", биб);
    вяжи(alDeleteSources)("alDeleteSources", биб);
    вяжи(alIsSource)("alIsSource", биб);

    вяжи(alSourcef)("alSourcef", биб);
    вяжи(alSource3f)("alSource3f", биб);
    вяжи(alSourcefv)("alSourcefv", биб);
    вяжи(alSourcei)("alSourcei", биб);
    вяжи(alSource3i)("alSource3i", биб);
    вяжи(alSourceiv)("alSourceiv", биб);

    вяжи(alGetSourcef)("alGetSourcef", биб);
    вяжи(alGetSource3f)("alGetSource3f", биб);
    вяжи(alGetSourcefv)("alGetSourcefv", биб);
    вяжи(alGetSourcei)("alGetSourcei", биб);
    вяжи(alGetSourceiv)("alGetSourceiv", биб);

    вяжи(alSourcePlayv)("alSourcePlayv", биб);
    вяжи(alSourceStopv)("alSourceStopv", биб);
    вяжи(alSourceRewindv)("alSourceRewindv", биб);
    вяжи(alSourcePausev)("alSourcePausev", биб);
    вяжи(alSourcePlay)("alSourcePlay", биб);
    вяжи(alSourcePause)("alSourcePause", биб);
    вяжи(alSourceRewind)("alSourceRewind", биб);
    вяжи(alSourceStop)("alSourceStop", биб);

    вяжи(alSourceQueueBuffers)("alSourceQueueBuffers", биб);
    вяжи(alSourceUnqueueBuffers)("alSourceUnqueueBuffers", биб);

    вяжи(alGenBuffers)("alGenBuffers", биб);
    вяжи(alDeleteBuffers)("alDeleteBuffers", биб);
    вяжи(alIsBuffer)("alIsBuffer", биб);
    вяжи(alBufferData)("alBufferData", биб);

    вяжи(alBufferf)("alBufferf", биб);
    вяжи(alBuffer3f)("alBuffer3f", биб);
    вяжи(alBufferfv)("alBufferfv", биб);
    вяжи(alBufferi)("alBufferi", биб);
    вяжи(alBuffer3i)("alBuffer3i", биб);
    вяжи(alBufferiv)("alBufferiv", биб);

    вяжи(alGetBufferf)("alGetBufferf", биб);
    вяжи(alGetBuffer3f)("alGetBuffer3f", биб);
    вяжи(alGetBufferfv)("alGetBufferfv", биб);
    вяжи(alGetBufferi)("alGetBufferi", биб);
    вяжи(alGetBuffer3i)("alGetBuffer3i", биб);
    вяжи(alGetBufferiv)("alGetBufferiv", биб);

    вяжи(alDopplerFactor)("alDopplerFactor", биб);
    вяжи(alDopplerVelocity)("alDopplerVelocity", биб);
    вяжи(alSpeedOfSound)("alSpeedOfSound", биб);
    вяжи(alDistanceModel)("alDistanceModel", биб);

    грузиАЛК(биб);
}


ЖанБибгр      АЛ;
static this() {
    АЛ.заряжай("OpenAL32.dll", &грузиАЛ);
	АЛ.загружай();
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