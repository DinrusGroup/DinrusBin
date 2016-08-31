/***************************************************************
                           timer.h
 ***************************************************************/

module derelict.allegro.timer;

import derelict.allegro.base : al_long;
import derelict.allegro.internal.dintern;
import derelict.allegro.internal._export;


const TIMERS_PER_SECOND   = 1193181;
int SECS_TO_TIMER(int x) { return x * TIMERS_PER_SECOND; }
int MSEC_TO_TIMER(int x) { return x * (TIMERS_PER_SECOND / 1000); }
int BPS_TO_TIMER(int x) { return TIMERS_PER_SECOND / x; }
int BPM_TO_TIMER(int x) { return (60 * TIMERS_PER_SECOND) / x; }

struct TIMER_DRIVER
{
   int id;
   const char *name;
   const char *desc;
   const char *ascii_name;
   int (*init) ();
   void (*exit) ();
   int (*install_int) (void (*proc) (), al_long speed);
   void (*remove_int) (void (*proc) ());
   int (*install_param_int) (void (*proc) (void *param), void *param, al_long speed);
   void (*remove_param_int) (void (*proc) (void *param), void *param);
   int (*can_simulate_retrace) ();
   void (*simulate_retrace) (int enable);
   void (*rest) (uint tyme, void (*callback) ());
}

extern (C) {

mixin(_export!("extern TIMER_DRIVER * timer_driver;"));
// FIXME: is it ok to set length to zero?
// Should work as long as it's only used by C code.
//mixin(_export!("extern _DRIVER_INFO _timer_driver_list[0];"));

int install_timer ();
void remove_timer ();

int install_int_ex (void (*proc) (), al_long speed);
int install_int (void (*proc) (), al_long speed);
void remove_int (void (*proc) ());

int install_param_int_ex (void (*proc) (void *param), void *param, al_long speed);
int install_param_int (void (*proc) (void *param), void *param, al_long speed);
void remove_param_int (void (*proc) (void *param), void *param);

}  // extern (C)

int retrace_count() { volatile return derelict.allegro.internal.dintern.retrace_count; }


extern (C) {

void rest (uint tyme);
void rest_callback (uint tyme, void (*callback) ());

} // extern (C)
