/***************************************************************
                           midi.h
 ***************************************************************/

module derelict.allegro.midi;

import derelict.allegro.base : _AL_ID, al_long;
import derelict.allegro.internal.dintern;
import derelict.allegro.internal._export;


enum {                          /* Theoretical maximums: */
   MIDI_VOICES      = 64,       /* actual drivers may not be */
   MIDI_TRACKS      = 32,       /* able to handle this many */
}


struct MIDI                            /* a midi file */
{
   int divisions;                      /* number of ticks per quarter note */
   struct _MIDI_TRACK {
      ubyte *data;                     /* MIDI message stream */
      int len;                         /* length of the track data */
   }
   _MIDI_TRACK track[MIDI_TRACKS];
}

const int MIDI_AUTODETECT     = -1;
const int MIDI_NONE           =  0;
const int MIDI_DIGMID         = _AL_ID!('D','I','G','I');


extern (C)
struct MIDI_DRIVER                     /* driver for playing midi music */
{
   int  id;                            /* driver ID code */
   const char *name;                   /* driver name */
   const char *desc;                   /* description string */
   const char *ascii_name;             /* ASCII format name string */
   int  voices;                        /* available voices */
   int  basevoice;                     /* voice number offset */
   int  max_voices;                    /* maximum voices we can support */
   int  def_voices;                    /* default number of voices to use */
   int  xmin, xmax;                    /* reserved voice range */

   /* setup routines */
   int (*detect) (int input);
   int (*init) (int input, int voices);
   void (*exit) (int input);
   int (*set_mixer_volume) (int volume);
   int (*get_mixer_volume) ();

   /* raw MIDI output to MPU-401, etc. */
   void (*raw_midi) (int data);

   /* dynamic patch loading routines */
   int (*load_patches) (in char *patches, in char *drums);
   void (*adjust_patches) (in char *patches, in char *drums);

   /* note control functions */
   void (*key_on) (int inst, int note, int bend, int vol, int pan);
   void (*key_off) (int voice);
   void (*set_volume) (int voice, int vol);
   void (*set_pitch) (int voice, int note, int bend);
   void (*set_pan) (int voice, int pan);
   void (*set_vibrato) (int voice, int amount);
}


mixin(_export!(
   "extern extern (C) {"
      //_DRIVER_INFO _midi_driver_list[];
   
      "MIDI_DRIVER *midi_driver;"
      "MIDI_DRIVER *midi_input_driver;"
      "int midi_card;"
      "int midi_input_card;"
   "}"
));

/* current position in the midi file, in beats */
al_long midi_pos() { volatile return derelict.allegro.internal.dintern.midi_pos; }

/* current position in the midi file, in seconds */
al_long midi_time() { volatile return derelict.allegro.internal.dintern.midi_time; }

mixin(_export!(
   "extern extern (C) {"
      "al_long midi_loop_start;"           /* where to loop back to at EOF */
      "al_long midi_loop_end;"             /* loop when we hit this position */
   "}"
));


extern (C) {

int detect_midi_driver (int driver_id);

MIDI * load_midi (in char *filename);
void destroy_midi (MIDI *midi);
int play_midi (MIDI *midi, int loop);
int play_looped_midi (MIDI *midi, int loop_start, int loop_end);
void stop_midi ();
void midi_pause ();
void midi_resume ();
int midi_seek (int target);
int get_midi_length (MIDI *midi);
void midi_out (ubyte *data, int length);
int load_midi_patches ();

mixin(_export!(
   "extern {"
      "void (*midi_msg_callback) (int msg, int byte1, int byte2);"
      "void (*midi_meta_callback) (int type, in ubyte *data, int length);"
      "void (*midi_sysex_callback) (in ubyte *data, int length);"
   
      "void (*midi_recorder) (ubyte data);"
   "}"
));

void lock_midi (MIDI *midi);

}  // extern (C)
