/***************************************************************
                           stream.h
 ***************************************************************/

module derelict.allegro.stream;

import derelict.allegro.digi : SAMPLE;

alias AUDIOSTREAM АУДИОПОТОК;
struct AUDIOSTREAM
{
   int voice;                          /* the voice we are playing on */
   alias voice голос;
   
   SAMPLE *samp;                       /* the sample we are using */
   alias samp семп;
   
   int len;                            /* buffer length */
   alias len длин;
   
   int bufcount;                       /* number of buffers per sample half */
   alias bufcount члобуф;
   
   int bufnum;                         /* current refill buffer */
   alias bufnum буфном;
   
   int active;                         /* which half is currently playing */
   alias active активн;
   
   void *locked;                       /* the locked buffer */
   alias locked блокировн;
}

extern (C) {
AUDIOSTREAM* play_audio_stream (int len, int bits, int stereo, int freq, int vol, int pan);
alias play_audio_stream воспр_аудиопоток;

void stop_audio_stream (AUDIOSTREAM *stream);
alias stop_audio_stream стоп_аудиопоток;

void* get_audio_stream_buffer (AUDIOSTREAM *stream);
alias get_audio_stream_buffer подкл_буфер_аудиопотока;

void free_audio_stream_buffer (AUDIOSTREAM *stream);
alias free_audio_stream_buffer откл_буфер_аудиопотока;
}
