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
 * * Neither the names 'Derelict', 'DerelictSDLMixer', nor the names of its contributors
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
module derelict.sdl.mixer;

private
{
    import derelict.sdl.sdl;
    import derelict.util.loader;
    import derelict.util.wrapper;
}

private void load(SharedLib lib)
{
    bindFunc(Mix_Linked_Version)("Mix_Linked_Version", lib);
    bindFunc(Mix_OpenAudio)("Mix_OpenAudio", lib);
    bindFunc(Mix_AllocateChannels)("Mix_AllocateChannels", lib);
    bindFunc(Mix_QuerySpec)("Mix_QuerySpec", lib);
    bindFunc(Mix_LoadWAV_RW)("Mix_LoadWAV_RW", lib);
    bindFunc(Mix_LoadMUS)("Mix_LoadMUS", lib);
    bindFunc(Mix_LoadMUS_RW)("Mix_LoadMUS_RW", lib);
    bindFunc(Mix_QuickLoad_WAV)("Mix_QuickLoad_WAV", lib);
    bindFunc(Mix_QuickLoad_RAW)("Mix_QuickLoad_RAW", lib);
    bindFunc(Mix_FreeChunk)("Mix_FreeChunk", lib);
    bindFunc(Mix_FreeMusic)("Mix_FreeMusic", lib);
    bindFunc(Mix_GetMusicType)("Mix_GetMusicType", lib);
    bindFunc(Mix_SetPostMix)("Mix_SetPostMix", lib);
    bindFunc(Mix_HookMusic)("Mix_HookMusic", lib);
    bindFunc(Mix_HookMusicFinished)("Mix_HookMusicFinished", lib);
    bindFunc(Mix_GetMusicHookData)("Mix_GetMusicHookData", lib);
    bindFunc(Mix_ChannelFinished)("Mix_ChannelFinished", lib);
    bindFunc(Mix_RegisterEffect)("Mix_RegisterEffect", lib);
    bindFunc(Mix_UnregisterEffect)("Mix_UnregisterEffect", lib);
    bindFunc(Mix_UnregisterAllEffects)("Mix_UnregisterAllEffects", lib);
    bindFunc(Mix_SetPanning)("Mix_SetPanning", lib);
    bindFunc(Mix_SetPosition)("Mix_SetPosition", lib);
    bindFunc(Mix_SetDistance)("Mix_SetDistance", lib);
    // bindFunc(Mix_SetReverb)("Mix_SetReverb", lib);
    bindFunc(Mix_SetReverseStereo)("Mix_SetReverseStereo", lib);
    bindFunc(Mix_ReserveChannels)("Mix_ReserveChannels", lib);
    bindFunc(Mix_GroupChannel)("Mix_GroupChannel", lib);
    bindFunc(Mix_GroupChannels)("Mix_GroupChannels", lib);
    bindFunc(Mix_GroupAvailable)("Mix_GroupAvailable", lib);
    bindFunc(Mix_GroupCount)("Mix_GroupCount", lib);
    bindFunc(Mix_GroupOldest)("Mix_GroupOldest", lib);
    bindFunc(Mix_GroupNewer)("Mix_GroupNewer", lib);
    bindFunc(Mix_PlayChannelTimed)("Mix_PlayChannelTimed", lib);
    bindFunc(Mix_PlayMusic)("Mix_PlayMusic", lib);
    bindFunc(Mix_FadeInMusic)("Mix_FadeInMusic", lib);
    bindFunc(Mix_FadeInMusicPos)("Mix_FadeInMusicPos", lib);
    bindFunc(Mix_FadeInChannelTimed)("Mix_FadeInChannelTimed", lib);
    bindFunc(Mix_Volume)("Mix_Volume", lib);
    bindFunc(Mix_VolumeChunk)("Mix_VolumeChunk", lib);
    bindFunc(Mix_VolumeMusic)("Mix_VolumeMusic", lib);
    bindFunc(Mix_HaltChannel)("Mix_HaltChannel", lib);
    bindFunc(Mix_HaltGroup)("Mix_HaltGroup", lib);
    bindFunc(Mix_HaltMusic)("Mix_HaltMusic", lib);
    bindFunc(Mix_ExpireChannel)("Mix_ExpireChannel", lib);
    bindFunc(Mix_FadeOutChannel)("Mix_FadeOutChannel", lib);
    bindFunc(Mix_FadeOutGroup)("Mix_FadeOutGroup", lib);
    bindFunc(Mix_FadeOutMusic)("Mix_FadeOutMusic", lib);
    bindFunc(Mix_FadingMusic)("Mix_FadingMusic", lib);
    bindFunc(Mix_FadingChannel)("Mix_FadingChannel", lib);
    bindFunc(Mix_Pause)("Mix_Pause", lib);
    bindFunc(Mix_Resume)("Mix_Resume", lib);
    bindFunc(Mix_Paused)("Mix_Paused", lib);
    bindFunc(Mix_PauseMusic)("Mix_PauseMusic", lib);
    bindFunc(Mix_ResumeMusic)("Mix_ResumeMusic", lib);
    bindFunc(Mix_RewindMusic)("Mix_RewindMusic", lib);
    bindFunc(Mix_PausedMusic)("Mix_PausedMusic", lib);
    bindFunc(Mix_SetMusicPosition)("Mix_SetMusicPosition", lib);
    bindFunc(Mix_Playing)("Mix_Playing", lib);
    bindFunc(Mix_PlayingMusic)("Mix_PlayingMusic", lib);
    bindFunc(Mix_SetMusicCMD)("Mix_SetMusicCMD", lib);
    bindFunc(Mix_SetSynchroValue)("Mix_SetSynchroValue", lib);
    bindFunc(Mix_GetSynchroValue)("Mix_GetSynchroValue", lib);
    bindFunc(Mix_GetChunk)("Mix_GetChunk", lib);
    bindFunc(Mix_CloseAudio)("Mix_CloseAudio", lib);
}

GenericLoader DerelictSDLMixer;
static this() {
    DerelictSDLMixer.setup(
        "SDL_mixer.dll",
        "libSDL_mixer.so, libSDL_mixer-1.2.so, libSDL_mixer-1.2.so.0",
        "../Frameworks/SDL_mixer.framework/SDL_mixer, /Library/Frameworks/SDL_mixer.framework/SDL_mixer, /System/Library/Frameworks/SDL_mixer.framework/SDL_mixer",
        &load
    );
}

enum : Uint8
{
    SDL_MIXER_MAJOR_VERSION     = 1,
    SDL_MIXER_MINOR_VERSION     = 2,
    SDL_MIXER_PATCHLEVEL        = 8,
}
alias SDL_MIXER_MAJOR_VERSION MIX_MAJOR_VERSION;
alias SDL_MIXER_MINOR_VERSION MIX_MINOR_VERSION;
alias SDL_MIXER_PATCHLEVEL MIX_PATCH_LEVEL;

alias SDL_SetError Mix_SetError;
alias SDL_GetError Mix_GetError;

struct Mix_Chunk
{
   int allocated;
   Uint8* abuf;
   Uint32 alen;
   Uint8 volume;
};

enum Mix_Fading
{
   MIX_NO_FADING,
   MIX_FADING_OUT,
   MIX_FADING_IN
};

enum Mix_MusicType
{
   MUS_NONE,
   MUS_CMD,
   MUS_WAV,
   MUS_MOD,
   MUS_MID,
   MUS_OGG,
   MUS_MP3,
   MUS_MP3_MAD,
};

struct _Mix_Music {}
typedef _Mix_Music Mix_Music;

enum
{
    MIX_CHANNELS              = 8,
    MIX_DEFAULT_FREQUENCY     = 22050,
    MIX_DEFAULT_CHANNELS      = 2,
    MIX_MAX_VOLUME            = 128,
    MIX_CHANNEL_POST          = -2,
}

version (LittleEndian) {
    enum { MIX_DEFAULT_FORMAT = AUDIO_S16LSB }
} else {
    enum { MIX_DEFAULT_FORMAT = AUDIO_S16MSB }
}

const char[] MIX_EFFECTSMAXSPEED    = "MIX_EFFECTSMAXSPEED";

extern(C)
{
    typedef void function(int chan, void* stream, int len, void* udata) Mix_EffectFunc_t;
    typedef void function(int chan, void* udata) Mix_EffectDone_t;
}

void SDL_MIXER_VERSION(SDL_version* X)
{
    X.major = SDL_MIXER_MAJOR_VERSION;
    X.minor = SDL_MIXER_MINOR_VERSION;
    X.patch = SDL_MIXER_PATCHLEVEL;
}
alias SDL_MIXER_VERSION MIX_VERSION;


Mix_Chunk* Mix_LoadWAV(char[] file)
{
    return Mix_LoadWAV_RW(SDL_RWFromFile(toCString(file), toCString("rb")), 1);
}

int Mix_PlayChannel(int channel, Mix_Chunk* chunk, int loops)
{
    return Mix_PlayChannelTimed(channel, chunk, loops, -1);
}

int Mix_FadeInChannel(int channel, Mix_Chunk* chunk, int loops, int ms)
{
    return Mix_FadeInChannelTimed(channel, chunk, loops, ms, -1);
}

extern (C)
{
    SDL_version* function() Mix_Linked_Version;
    int function (int, Uint16, int, int) Mix_OpenAudio;
    int function(int) Mix_AllocateChannels;
    int function(int*, Uint16*, int*) Mix_QuerySpec;
    Mix_Chunk* function(SDL_RWops*, int) Mix_LoadWAV_RW;
    Mix_Music* function(char*) Mix_LoadMUS;
    Mix_Music* function(SDL_RWops*) Mix_LoadMUS_RW;
    Mix_Chunk* function(Uint8*) Mix_QuickLoad_WAV;
    Mix_Chunk* function(Uint8*, Uint32) Mix_QuickLoad_RAW;
    void function(Mix_Chunk*) Mix_FreeChunk;
    void function(Mix_Music*) Mix_FreeMusic;
    Mix_MusicType function(Mix_Music*) Mix_GetMusicType;
    void function(void (*mix_func)(void*, Uint8*, int), void*) Mix_SetPostMix;
    void function(void (*mix_func)(void*, Uint8*, int), void*) Mix_HookMusic;
    void function(void (*music_finished)()) Mix_HookMusicFinished;
    void*  function() Mix_GetMusicHookData;
    void function(void (*channel_finished)(int channel)) Mix_ChannelFinished;
    int function(int, Mix_EffectFunc_t, Mix_EffectDone_t, void*) Mix_RegisterEffect;
    int function(int, Mix_EffectFunc_t) Mix_UnregisterEffect;
    int function(int) Mix_UnregisterAllEffects;
    int function(int, Uint8, Uint8) Mix_SetPanning;
    int function(int, Sint16, Uint8) Mix_SetPosition;
    int function(int, Uint8) Mix_SetDistance;
    // int function(int, Uint8) Mix_SetReverb;
    int function(int, int) Mix_SetReverseStereo;
    int function(int) Mix_ReserveChannels;
    int function(int, int) Mix_GroupChannel;
    int function(int, int, int) Mix_GroupChannels;
    int function(int) Mix_GroupAvailable;
    int function(int) Mix_GroupCount;
    int function(int) Mix_GroupOldest;
    int function(int) Mix_GroupNewer;
    int function(int, Mix_Chunk*, int, int) Mix_PlayChannelTimed;
    int function(Mix_Music*, int) Mix_PlayMusic;
    int function(Mix_Music*, int, int) Mix_FadeInMusic;
    int function(Mix_Music*, int, int, double) Mix_FadeInMusicPos;
    int function(int, Mix_Chunk*, int, int, int) Mix_FadeInChannelTimed;
    int function(int, int) Mix_Volume;
    int function(Mix_Chunk*, int) Mix_VolumeChunk;
    int function(int) Mix_VolumeMusic;
    int function(int) Mix_HaltChannel;
    int function(int) Mix_HaltGroup;
    int function() Mix_HaltMusic;
    int function(int, int) Mix_ExpireChannel;
    int function(int, int) Mix_FadeOutChannel;
    int function(int, int) Mix_FadeOutGroup;
    int function(int) Mix_FadeOutMusic;
    Mix_Fading function() Mix_FadingMusic;
    Mix_Fading function(int) Mix_FadingChannel;
    void function(int) Mix_Pause;
    void function(int) Mix_Resume;
    int function(int) Mix_Paused;
    void function() Mix_PauseMusic;
    void function() Mix_ResumeMusic;
    void function() Mix_RewindMusic;
    int function() Mix_PausedMusic;
    int function(double) Mix_SetMusicPosition;
    int function(int) Mix_Playing;
    int function() Mix_PlayingMusic;
    int function(char*) Mix_SetMusicCMD;
    int function(int) Mix_SetSynchroValue;
    int function() Mix_GetSynchroValue;
    Mix_Chunk* function(int) Mix_GetChunk;
    void function() Mix_CloseAudio;
}