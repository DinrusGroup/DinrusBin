/***************************************************************
                           digi.h
 ***************************************************************/

module derelict.allegro.digi;

import derelict.allegro.base : al_ulong;
import derelict.allegro.file : PACKFILE;
import derelict.allegro.internal._export;


const int DIGI_VOICES        = 64;     /* Theoretical maximums: */
                                       /* actual drivers may not be */
                                       /* able to handle this many */

struct SAMPLE                          /* a sample */
{
   int bits;                           /* 8 or 16 */
   int stereo;                         /* sample type flag */
   int freq;                           /* sample frequency */
   int priority;                       /* 0-255 */
   al_ulong len;                       /* length (in samples) */
   al_ulong loop_start;                /* loop start position */
   al_ulong loop_end;                  /* loop finish position */
   al_ulong param;                     /* for internal use by the driver */
   void *data;                         /* sample data */
}


enum {
   DIGI_AUTODETECT     = -1,           /* for passing to install_sound() */
   DIGI_NONE           =  0
}

extern (C)
struct DIGI_DRIVER                     /* driver for playing digital sfx */
{
   int  id;                            /* driver ID code */
   const char *name;                   /* driver name */
   const char *desc;                   /* description string */
   const char *ascii_name;             /* ASCII format name string */
   int  voices;                        /* available voices */
   int  basevoice;                     /* voice number offset */
   int  max_voices;                    /* maximum voices we can support */
   int  def_voices;                    /* default number of voices to use */

   /* setup routines */
   int detect(int input);
   int init(int input, int voices);
   void exit(int input);
   int set_mixer_volume(int volume);
   int get_mixer_volume();

   /* for use by the audiostream functions */
   void* lock_voice(int voice, int start, int end);
   void unlock_voice(int voice);
   int  buffer_size();

   /* voice control functions */
   void (*init_voice) (int voice, in SAMPLE *sample);
   void (*release_voice) (int voice);
   void (*start_voice) (int voice);
   void (*stop_voice) (int voice);
   void (*loop_voice) (int voice, int playmode);

   /* position control functions */
   int (*get_position) (int voice);
   void (*set_position) (int voice, int position);

   /* volume control functions */
   int (*get_volume) (int voice);
   void (*set_volume) (int voice, int volume);
   void (*ramp_volume) (int voice, int tyme, int endvol);
   void (*stop_volume_ramp) (int voice);

   /* pitch control functions */
   int (*get_frequency) (int voice);
   void (*set_frequency) (int voice, int frequency);
   void (*sweep_frequency) (int voice, int tyme, int endfreq);
   void (*stop_frequency_sweep) (int voice);

   /* pan control functions */
   int (*get_pan) (int voice);
   void (*set_pan) (int voice, int pan);
   void (*sweep_pan) (int voice, int tyme, int endpan);
   void (*stop_pan_sweep) (int voice);

   /* effect control functions */
   void (*set_echo) (int voice, int strength, int delay);
   void (*set_tremolo) (int voice, int rate, int depth);
   void (*set_vibrato) (int voice, int rate, int depth);

   /* input functions */
   int rec_cap_bits;
   int rec_cap_stereo;
   int (*rec_cap_rate) (int bits, int stereo);
   int (*rec_cap_parm) (int rate, int bits, int stereo);
   int (*rec_source) (int source);
   int (*rec_start) (int rate, int bits, int stereo);
   void (*rec_stop) ();
   int (*rec_read) (void *buf);
}

// FIXME remove?
//mixin(_export!("extern extern (C) _DRIVER_INFO _digi_driver_list[];"));


mixin(_export!(
   "extern (C) {"
      "extern DIGI_DRIVER * digi_driver;"
      "extern DIGI_DRIVER * digi_input_driver;"
      "extern int digi_card;"
      "extern int digi_input_card;"
   "}"
));

extern (C) {

int detect_digi_driver (int driver_id);

SAMPLE * load_sample (in char *filename);
SAMPLE * load_wav (in char *filename);
SAMPLE * load_wav_pf (PACKFILE *f);
SAMPLE * load_voc (in char *filename);
SAMPLE * load_voc_pf (PACKFILE *f);
int save_sample (in char *filename, SAMPLE *spl);
SAMPLE * create_sample (int bits, int stereo, int freq, int len);
void destroy_sample (SAMPLE *spl);

int play_sample (in SAMPLE *spl, int vol, int pan, int freq, int loop);
void stop_sample (in SAMPLE *spl);
void adjust_sample (in SAMPLE *spl, int vol, int pan, int freq, int loop);

int allocate_voice (in SAMPLE *spl);
void deallocate_voice (int voice);
void reallocate_voice (int voice, in SAMPLE *spl);
void release_voice (int voice);
void voice_start (int voice);
void voice_stop (int voice);
void voice_set_priority (int voice, int priority);
SAMPLE * voice_check (int voice);


enum {
    PLAYMODE_PLAY         = 0,
    PLAYMODE_LOOP         = 1,
    PLAYMODE_FORWARD      = 0,
    PLAYMODE_BACKWARD     = 2,
    PLAYMODE_BIDIR        = 4,
}


void voice_set_playmode (int voice, int playmode);

int voice_get_position (int voice);
void voice_set_position (int voice, int position);

int voice_get_volume (int voice);
void voice_set_volume (int voice, int volume);
void voice_ramp_volume (int voice, int tyme, int endvol);
void voice_stop_volumeramp (int voice);

int voice_get_frequency (int voice);
void voice_set_frequency (int voice, int frequency);
void voice_sweep_frequency (int voice, int tyme, int endfreq);
void voice_stop_frequency_sweep (int voice);

int voice_get_pan (int voice);
void voice_set_pan (int voice, int pan);
void voice_sweep_pan (int voice, int tyme, int endpan);
void voice_stop_pan_sweep (int voice);

void voice_set_echo (int voice, int strength, int delay);
void voice_set_tremolo (int voice, int rate, int depth);
void voice_set_vibrato (int voice, int rate, int depth);

enum {
    SOUND_INPUT_MIC  = 1,
    SOUND_INPUT_LINE = 2,
    SOUND_INPUT_CD   = 3,
}

int get_sound_input_cap_bits ();
int get_sound_input_cap_stereo ();
int get_sound_input_cap_rate (int bits, int stereo);
int get_sound_input_cap_parm (int rate, int bits, int stereo);
int set_sound_input_source (int source);
int start_sound_input (int rate, int bits, int stereo);
void stop_sound_input ();
int read_sound_input (void *buffer);

mixin(_export!("extern void (*digi_recorder) ();"));

void lock_sample (SAMPLE *spl);

void register_sample_file_type (in char *ext, SAMPLE * (*load) (in char *filename), int (*save) (in char *filename, SAMPLE *spl));

}  // extern (C)
