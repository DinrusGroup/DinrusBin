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
module derelict.bassmod.bassmodfuncs;


private
{
    import derelict.bassmod.bassmodtypes;
    import derelict.util.loader;
}
typedef DWORD function() pfBASSMOD_GetVersion;
typedef DWORD function() pfBASSMOD_ErrorGetCode;
typedef char* function(int) pfBASSMOD_GetDeviceDescription;
typedef BOOL function(int, DWORD, DWORD) pfBASSMOD_Init;
typedef void function() pfBASSMOD_Free;
typedef float function() pfBASSMOD_GetCPU;
typedef BOOL function(DWORD) pfBASSMOD_SetVolume;
typedef int function() pfBASSMOD_GetVolume;

typedef BOOL function(BOOL, void*, DWORD, DWORD, DWORD) pfBASSMOD_MusicLoad;
typedef void function() pfBASSMOD_MusicFree;
typedef char* function() pfBASSMOD_MusicGetName;
typedef DWORD function(BOOL) pfBASSMOD_MusicGetLength;
typedef BOOL function() pfBASSMOD_MusicPlay;
typedef BOOL function(DWORD, int, BOOL) pfBASSMOD_MusicPlayEx;
typedef DWORD function(void*, DWORD) pfBASSMOD_MusicDecode;
typedef BOOL function(DWORD) pfBASSMOD_MusicSetAmplify;
typedef BOOL function(DWORD) pfBASSMOD_MusicSetPanSep;
typedef BOOL function(DWORD) pfBASSMOD_MusicSetPositionScaler;
typedef BOOL function(DWORD, DWORD) pfBASSMOD_MusicSetVolume;
typedef DWORD function(DWORD) pfBASSMOD_MusicGetVolume;

typedef DWORD function() pfBASSMOD_MusicIsActive;
typedef BOOL function() pfBASSMOD_MusicStop;
typedef BOOL function() pfBASSMOD_MusicPause;
typedef BOOL function(DWORD) pfBASSMOD_MusicSetPosition;
typedef DWORD function() pfBASSMOD_MusicGetPosition;
typedef HSYNC function(DWORD, DWORD, SYNCPROC, DWORD) pfBASSMOD_MusicSetSync;
typedef BOOL function(HSYNC) pfBASSMOD_MusicRemoveSync;

pfBASSMOD_GetVersion			BASSMOD_GetVersion;
pfBASSMOD_ErrorGetCode			BASSMOD_ErrorGetCode;
pfBASSMOD_GetDeviceDescription	BASSMOD_GetDeviceDescription;
pfBASSMOD_Init					BASSMOD_Init;
pfBASSMOD_Free					BASSMOD_Free;
pfBASSMOD_GetCPU				BASSMOD_GetCPU;
pfBASSMOD_SetVolume				BASSMOD_SetVolume;
pfBASSMOD_GetVolume				BASSMOD_GetVolume;

pfBASSMOD_MusicLoad               BASSMOD_MusicLoad;
pfBASSMOD_MusicFree               BASSMOD_MusicFree;
pfBASSMOD_MusicGetName            BASSMOD_MusicGetName;
pfBASSMOD_MusicGetLength          BASSMOD_MusicGetLength;
pfBASSMOD_MusicPlay               BASSMOD_MusicPlay;
pfBASSMOD_MusicPlayEx             BASSMOD_MusicPlayEx;
pfBASSMOD_MusicDecode             BASSMOD_MusicDecode;
pfBASSMOD_MusicSetAmplify         BASSMOD_MusicSetAmplify;
pfBASSMOD_MusicSetPanSep          BASSMOD_MusicSetPanSep;
pfBASSMOD_MusicSetPositionScaler  BASSMOD_MusicSetPositionScaler;
pfBASSMOD_MusicSetVolume          BASSMOD_MusicSetVolume;
pfBASSMOD_MusicGetVolume          BASSMOD_MusicGetVolume;

pfBASSMOD_MusicIsActive    BASSMOD_MusicIsActive;
pfBASSMOD_MusicStop        BASSMOD_MusicStop;
pfBASSMOD_MusicPause       BASSMOD_MusicPause;
pfBASSMOD_MusicSetPosition BASSMOD_MusicSetPosition;
pfBASSMOD_MusicGetPosition BASSMOD_MusicGetPosition;
pfBASSMOD_MusicSetSync     BASSMOD_MusicSetSync;
pfBASSMOD_MusicRemoveSync  BASSMOD_MusicRemoveSync;


package void loadBASSMOD(SharedLib lib)
{
    bindFunc(BASSMOD_GetVersion)("BASSMOD_GetVersion", lib);
    bindFunc(BASSMOD_ErrorGetCode)("BASSMOD_ErrorGetCode", lib);
    bindFunc(BASSMOD_GetDeviceDescription)("BASSMOD_GetDeviceDescription", lib);
    bindFunc(BASSMOD_Init)("BASSMOD_Init", lib);
    bindFunc(BASSMOD_Free)("BASSMOD_Free", lib);
    bindFunc(BASSMOD_GetCPU)("BASSMOD_GetCPU", lib);
    bindFunc(BASSMOD_SetVolume)("BASSMOD_SetVolume", lib);
    bindFunc(BASSMOD_GetVolume)("BASSMOD_GetVolume", lib);

    bindFunc(BASSMOD_MusicLoad)("BASSMOD_MusicLoad", lib);
    bindFunc(BASSMOD_MusicFree)("BASSMOD_MusicFree", lib);
    bindFunc(BASSMOD_MusicGetName)("BASSMOD_MusicGetName", lib);
    bindFunc(BASSMOD_MusicGetLength)("BASSMOD_MusicGetLength", lib);
    bindFunc(BASSMOD_MusicPlay)("BASSMOD_MusicPlay", lib);
    bindFunc(BASSMOD_MusicPlayEx)("BASSMOD_MusicPlayEx", lib);
    bindFunc(BASSMOD_MusicDecode)("BASSMOD_MusicDecode", lib);
    bindFunc(BASSMOD_MusicSetAmplify)("BASSMOD_MusicSetAmplify", lib);
    bindFunc(BASSMOD_MusicSetPanSep)("BASSMOD_MusicSetPanSep", lib);
    bindFunc(BASSMOD_MusicSetPositionScaler)("BASSMOD_MusicSetPositionScaler", lib);
    bindFunc(BASSMOD_MusicSetVolume)("BASSMOD_MusicSetVolume", lib);
    bindFunc(BASSMOD_MusicGetVolume)("BASSMOD_MusicGetVolume", lib);

    bindFunc(BASSMOD_MusicIsActive)("BASSMOD_MusicIsActive", lib);
    bindFunc(BASSMOD_MusicStop)("BASSMOD_MusicStop", lib);
    bindFunc(BASSMOD_MusicPause)("BASSMOD_MusicPause", lib);
    bindFunc(BASSMOD_MusicSetPosition)("BASSMOD_MusicSetPosition", lib);
    bindFunc(BASSMOD_MusicGetPosition)("BASSMOD_MusicGetPosition", lib);
    bindFunc(BASSMOD_MusicSetSync)("BASSMOD_MusicSetSync", lib);
    bindFunc(BASSMOD_MusicRemoveSync)("BASSMOD_MusicRemoveSync", lib);
}


GenericLoader DerelictBASSMOD;
static this() {
	DerelictBASSMOD.setup(
		"bassmod.dll",
		"bassmod.so", // ??
		"",
		&loadBASSMOD
	);
}


version(Windows){
    extern(Windows):}
else
    extern(C):


