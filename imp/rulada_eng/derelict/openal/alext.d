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
module derelict.openal.alext;

private
{
	import derelict.openal.altypes;
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