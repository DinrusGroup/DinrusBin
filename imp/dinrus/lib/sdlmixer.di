module lib.sdlmixer;

private
{
import stdrus, lib.sdl;
pragma(lib,"dinrus.lib");
}

private проц грузи(Биб биб)
{
    вяжи(Mix_Linked_Version)("Mix_Linked_Version", биб);
    вяжи(Mix_OpenAudio)("Mix_OpenAudio", биб);
    вяжи(Mix_AllocateChannels)("Mix_AllocateChannels", биб);
    вяжи(Mix_QuerySpec)("Mix_QuerySpec", биб);
    вяжи(Mix_LoadWAV_RW)("Mix_LoadWAV_RW", биб);
    вяжи(Mix_LoadMUS)("Mix_LoadMUS", биб);
    вяжи(Mix_LoadMUS_RW)("Mix_LoadMUS_RW", биб);
    вяжи(Mix_QuickLoad_WAV)("Mix_QuickLoad_WAV", биб);
    вяжи(Mix_QuickLoad_RAW)("Mix_QuickLoad_RAW", биб);
    вяжи(Mix_FreeChunk)("Mix_FreeChunk", биб);
    вяжи(Mix_FreeMusic)("Mix_FreeMusic", биб);
    вяжи(Mix_GetMusicType)("Mix_GetMusicType", биб);
    вяжи(Mix_SetPostMix)("Mix_SetPostMix", биб);
    вяжи(Mix_HookMusic)("Mix_HookMusic", биб);
    вяжи(Mix_HookMusicFinished)("Mix_HookMusicFinished", биб);
    вяжи(Mix_GetMusicHookData)("Mix_GetMusicHookData", биб);
    вяжи(Mix_ChannelFinished)("Mix_ChannelFinished", биб);
    вяжи(Mix_RegisterEffect)("Mix_RegisterEffect", биб);
    вяжи(Mix_UnregisterEffect)("Mix_UnregisterEffect", биб);
    вяжи(Mix_UnregisterAllEffects)("Mix_UnregisterAllEffects", биб);
    вяжи(Mix_SetPanning)("Mix_SetPanning", биб);
    вяжи(Mix_SetPosition)("Mix_SetPosition", биб);
    вяжи(Mix_SetDistance)("Mix_SetDistance", биб);
    // вяжи(Mix_SetReverb)("Mix_SetReverb", биб);
    вяжи(Mix_SetReverseStereo)("Mix_SetReverseStereo", биб);
    вяжи(Mix_ReserveChannels)("Mix_ReserveChannels", биб);
    вяжи(Mix_GroupChannel)("Mix_GroupChannel", биб);
    вяжи(Mix_GroupChannels)("Mix_GroupChannels", биб);
    вяжи(Mix_GroupAvailable)("Mix_GroupAvailable", биб);
    вяжи(Mix_GroupCount)("Mix_GroupCount", биб);
    вяжи(Mix_GroupOldest)("Mix_GroupOldest", биб);
    вяжи(Mix_GroupNewer)("Mix_GroupNewer", биб);
    вяжи(Mix_PlayChannelTimed)("Mix_PlayChannelTimed", биб);
    вяжи(Mix_PlayMusic)("Mix_PlayMusic", биб);
    вяжи(Mix_FadeInMusic)("Mix_FadeInMusic", биб);
    вяжи(Mix_FadeInMusicPos)("Mix_FadeInMusicPos", биб);
    вяжи(Mix_FadeInChannelTimed)("Mix_FadeInChannelTimed", биб);
    вяжи(Mix_Volume)("Mix_Volume", биб);
    вяжи(Mix_VolumeChunk)("Mix_VolumeChunk", биб);
    вяжи(Mix_VolumeMusic)("Mix_VolumeMusic", биб);
    вяжи(Mix_HaltChannel)("Mix_HaltChannel", биб);
    вяжи(Mix_HaltGroup)("Mix_HaltGroup", биб);
    вяжи(Mix_HaltMusic)("Mix_HaltMusic", биб);
    вяжи(Mix_ExpireChannel)("Mix_ExpireChannel", биб);
    вяжи(Mix_FadeOutChannel)("Mix_FadeOutChannel", биб);
    вяжи(Mix_FadeOutGroup)("Mix_FadeOutGroup", биб);
    вяжи(Mix_FadeOutMusic)("Mix_FadeOutMusic", биб);
    вяжи(Mix_FadingMusic)("Mix_FadingMusic", биб);
    вяжи(Mix_FadingChannel)("Mix_FadingChannel", биб);
    вяжи(Mix_Pause)("Mix_Pause", биб);
    вяжи(Mix_Resume)("Mix_Resume", биб);
    вяжи(Mix_Paused)("Mix_Paused", биб);
    вяжи(Mix_PauseMusic)("Mix_PauseMusic", биб);
    вяжи(Mix_ResumeMusic)("Mix_ResumeMusic", биб);
    вяжи(Mix_RewindMusic)("Mix_RewindMusic", биб);
    вяжи(Mix_PausedMusic)("Mix_PausedMusic", биб);
    вяжи(Mix_SetMusicPosition)("Mix_SetMusicPosition", биб);
    вяжи(Mix_Playing)("Mix_Playing", биб);
    вяжи(Mix_PlayingMusic)("Mix_PlayingMusic", биб);
    вяжи(Mix_SetMusicCMD)("Mix_SetMusicCMD", биб);
    вяжи(Mix_SetSynchroValue)("Mix_SetSynchroValue", биб);
    вяжи(Mix_GetSynchroValue)("Mix_GetSynchroValue", биб);
    вяжи(Mix_GetChunk)("Mix_GetChunk", биб);
    вяжи(Mix_CloseAudio)("Mix_CloseAudio", биб);
}

ЖанБибгр СДЛМиксер;
static this() {
    СДЛМиксер.заряжай("SDL_mixer.dll", &грузи);
	СДЛМиксер.загружай();
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

alias сдлУстановиОш Mix_SetError;
alias сдлДайОш Mix_GetError;

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
    return Mix_LoadWAV_RW(сдлЧЗИзФайла(вТкст0(file), вТкст0("rb")), 1);
}

int Mix_PlayChannel(int канал, Mix_Chunk* chunk, int loops)
{
    return Mix_PlayChannelTimed(канал, chunk, loops, -1);
}

int Mix_FadeInChannel(int канал, Mix_Chunk* chunk, int loops, int ms)
{
    return Mix_FadeInChannelTimed(канал, chunk, loops, ms, -1);
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
    void function(void (*channel_finished)(int канал)) Mix_ChannelFinished;
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