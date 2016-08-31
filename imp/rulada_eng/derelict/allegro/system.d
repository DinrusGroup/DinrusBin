/***************************************************************
                          system.h
 ***************************************************************/
module derelict.allegro.system;

public import derelict.allegro.inline.system_inl;

version (Tango) {
   import tango.stdc.stdlib;
   // for the unittest:
   import tango.stdc.stdio;
   import tango.stdc.errno;
   import tango.stdc.math;
}
else {
   import std.c;
   import os.win32.winsock2: h_errno;
   // for the unittest:
  // import std.c;
   //import std.c.math;
}

import derelict.allegro.base : ALLEGRO_VERSION, ALLEGRO_SUB_VERSION,
                      ALLEGRO_WIP_VERSION, _AL_ID, _DRIVER_INFO;
import derelict.allegro.gfx : BITMAP, RGB, GFX_VTABLE, GFX_MODE;
import derelict.allegro.internal._export;

// for the unittest:
import derelict.allegro.base : allegro_errno;
import derelict.allegro.fmaths : ftofix;


version (linux)
   version = Unix;

private extern (C) alias int function(void function()) atexit_type;


// Phobos and Tango both define functions to retrieve and set errno, but
// Allegro needs the address or errno, not the value.  Allegro's use of errno
// doesn't seem to be thread-safe, so this solution isn't either.
version (Windows) {
   version (DigitalMars) {
      private extern (D) int _h_errno;
      private int* get_errno_pointer() { return &_h_errno; }
   }
   else version (GNU) {
      private extern (C) int* h_getErrno();
      private alias h_errno get_errno_pointer;
   }
}
else version (darwin) {
   private extern (C) int* __error(void);
   private alias __error get_errno_pointer;
}
else {
   // This is confirmed to work on linux, and will hopefully work for
   // other GNU based systems.
   private extern (C) int* __errno_location();
   private alias __errno_location get_errno_pointer;
}


const int ALLEGRO_ERROR_SIZE = 256;

/* In the C code allegro_id is a char array, not a pointer.  And the size
 * depends on with which compiler and which settings allegro was compiled.
 * So we can't safely declare it as a D static array.  And doing
 * char* allegro_id = &misc.allegro_id[0] does not work, since it's not a
 * constant expression.  So we do it in the module constructor instead.
 */
char* allegro_id;
char* allegro_error;  // see comment for allegro_id

const int OSTYPE_UNKNOWN   = 0;
const int OSTYPE_WIN3      = _AL_ID!('W','I','N','3');
const int OSTYPE_WIN95     = _AL_ID!('W','9','5',' ');
const int OSTYPE_WIN98     = _AL_ID!('W','9','8',' ');
const int OSTYPE_WINME     = _AL_ID!('W','M','E',' ');
const int OSTYPE_WINNT     = _AL_ID!('W','N','T',' ');
const int OSTYPE_WIN2000   = _AL_ID!('W','2','K',' ');
const int OSTYPE_WINXP     = _AL_ID!('W','X','P',' ');
const int OSTYPE_WIN2003   = _AL_ID!('W','2','K','3');
const int OSTYPE_WINVISTA  = _AL_ID!('W','V','S','T');
const int OSTYPE_OS2       = _AL_ID!('O','S','2',' ');
const int OSTYPE_WARP      = _AL_ID!('W','A','R','P');
const int OSTYPE_DOSEMU    = _AL_ID!('D','E','M','U');
const int OSTYPE_OPENDOS   = _AL_ID!('O','D','O','S');
const int OSTYPE_LINUX     = _AL_ID!('T','U','X',' ');
const int OSTYPE_SUNOS     = _AL_ID!('S','U','N',' ');
const int OSTYPE_FREEBSD   = _AL_ID!('F','B','S','D');
const int OSTYPE_NETBSD    = _AL_ID!('N','B','S','D');
const int OSTYPE_OPENBSD   = _AL_ID!('O','B','S','D');
const int OSTYPE_IRIX      = _AL_ID!('I','R','I','X');
const int OSTYPE_DARWIN    = _AL_ID!('D','A','R','W');
const int OSTYPE_QNX       = _AL_ID!('Q','N','X',' ');
const int OSTYPE_UNIX      = _AL_ID!('U','N','I','X');
const int OSTYPE_BEOS      = _AL_ID!('B','E','O','S');
const int OSTYPE_MACOS     = _AL_ID!('M','A','C',' ');
const int OSTYPE_MACOSX    = _AL_ID!('M','A','C','X');

mixin(_export!(
   "extern extern (C) {"
      "int os_type;"
      "int os_version;"
      "int os_revision;"
      "int os_multitasking;"
   "}"
));

const int SYSTEM_AUTODETECT  = 0;
const int SYSTEM_NONE        = _AL_ID!('N','O','N','E');


int MAKE_VERSION(ubyte a, ubyte b, ubyte c) { return (a << 16) | (b << 8) | c; }

extern (C)
int _install_allegro_version_check(int system_id, int *errno_ptr,
                                   atexit_type atexit_ptr, int version_);

int install_allegro(int system_id, int *errno_ptr, atexit_type atexit_ptr)
{
   // override argument
   errno_ptr = .get_errno_pointer();

   return _install_allegro_version_check(system_id, errno_ptr, atexit_ptr,
      MAKE_VERSION(ALLEGRO_VERSION, ALLEGRO_SUB_VERSION, ALLEGRO_WIP_VERSION));
}

int allegro_init()
{
   return install_allegro(SYSTEM_AUTODETECT, null, &atexit);
}

extern (C) {
void allegro_exit ();

void allegro_message (in char *msg, ...);
void get_executable_name (char *output, int size);
int set_close_button_callback (void (*proc)());


void check_cpu ();

} // extern (C)

/* CPU Capabilities flags for x86 capable chips */
enum {
   CPU_ID       = 0x0001,
   CPU_FPU      = 0x0002,
   CPU_MMX      = 0x0004,
   CPU_MMXPLUS  = 0x0008,
   CPU_SSE      = 0x0010,
   CPU_SSE2     = 0x0020,
   CPU_3DNOW    = 0x0040,
   CPU_ENH3DNOW = 0x0080,
   CPU_CMOV     = 0x0100,
   CPU_AMD64    = 0x0200,
   CPU_IA64     = 0x0400,
   CPU_SSE3     = 0x0800,
}

/* CPU families - PC */
enum {
   CPU_FAMILY_UNKNOWN  = 0,
   CPU_FAMILY_I386     = 3,
   CPU_FAMILY_I486     = 4,
   CPU_FAMILY_I586     = 5,
   CPU_FAMILY_I686     = 6,
   CPU_FAMILY_ITANIUM  = 7,
   CPU_FAMILY_EXTENDED = 15,
   /* CPUID only returns 15 bits, we need extra information from the CPU */
   /*  model to identify Pentium IV, Xeon and Athlon 64 processors. */
}

/* CPU families - Power PC */
enum {
   CPU_FAMILY_POWERPC = 18,
}

/* CPU models - PC */
/* 486 */
enum {
   CPU_MODEL_I486DX   =  0,
   CPU_MODEL_I486DX50 =  1,
   CPU_MODEL_I486SX   =  2,
   CPU_MODEL_I487SX   =  3,
   CPU_MODEL_I486SL   =  4,
   CPU_MODEL_I486SX2  =  5,
   CPU_MODEL_I486DX2  =  7,
   CPU_MODEL_I486DX4  =  8,
}

/* Intel/586 */
enum {
   CPU_MODEL_PENTIUM             =  1,
   CPU_MODEL_PENTIUMP54C         =  2,
   CPU_MODEL_PENTIUMOVERDRIVEDX4 =  4,
   CPU_MODEL_PENTIUMOVERDRIVE    =  3,
   CPU_MODEL_CYRIX               =  14,
   CPU_MODEL_UNKNOWN             =  15,
}

/* AMD/586 */
enum {
   CPU_MODEL_K5                  =  0,
   CPU_MODEL_K6                  =  6,
}

/* Intel/686 */
enum {
   CPU_MODEL_PENTIUMPROA         =  0,
   CPU_MODEL_PENTIUMPRO          =  1,
   CPU_MODEL_PENTIUMIIKLAMATH    =  3,
   CPU_MODEL_PENTIUMII           =  5,
   CPU_MODEL_CELERON             =  6,
   CPU_MODEL_PENTIUMIIIKATMAI    =  7,
   CPU_MODEL_PENTIUMIIICOPPERMINE=  8,
   CPU_MODEL_PENTIUMIIIMOBILE    =  9,
}

/* AMD/686 */
enum {
   CPU_MODEL_ATHLON              =  2,
   CPU_MODEL_DURON               =  3,
}

/* Information when CPU_FAMILY is 15 */
enum {
   CPU_MODEL_PENTIUMIV           =  0,
   CPU_MODEL_XEON                =  2,

   CPU_MODEL_ATHLON64            =  4,
   CPU_MODEL_OPTERON             =  5,
}

/* Information for Power PC processors */
/* these defines are taken from <mach-o/machine.h> */
enum {
   CPU_MODEL_POWERPC_601      =  1,
   CPU_MODEL_POWERPC_602      =  2,
   CPU_MODEL_POWERPC_603      =  3,
   CPU_MODEL_POWERPC_603e     =  4,
   CPU_MODEL_POWERPC_603ev    =  5,
   CPU_MODEL_POWERPC_604      =  6,
   CPU_MODEL_POWERPC_604e     =  7,
   CPU_MODEL_POWERPC_620      =  8,
   CPU_MODEL_POWERPC_750      =  9,
   CPU_MODEL_POWERPC_7400     =  10,
   CPU_MODEL_POWERPC_7450     =  11,
}

char *cpu_vendor;

mixin(_export!(
   "extern extern (C) {"
      "int cpu_family;"
      "int cpu_model;"
      "int cpu_capabilities;"
   "}"
));


extern (C) struct SYSTEM_DRIVER
{
   int id;
   const char *name;
   const char *desc;
   const char *ascii_name;
   int (*init) ();
   void (*exit) ();
   void (*get_executable_name) (char *output, int size);
   int (*find_resource) (char *dest, in char *resource, int size);
   void (*set_window_title) (in char *name);
   int (*set_close_button_callback) (void (*proc) ());
   void (*message) (in char *msg);
   void (*assert_) (in char *msg);
   void (*save_console_state) ();
   void (*restore_console_state) ();
   BITMAP * (*create_bitmap) (int color_depth, int width, int height);
   void (*created_bitmap) (BITMAP *bmp);
   BITMAP * (*create_sub_bitmap) (BITMAP *parent, int x, int y, int width, int height);
   void (*created_sub_bitmap) (BITMAP *bmp, BITMAP *parent);
   int (*destroy_bitmap) (BITMAP *bitmap);
   void (*read_hardware_palette) ();
   void (*set_palette_range) (in RGB *p, int from, int to, int retracesync);
   GFX_VTABLE * (*get_vtable) (int color_depth);
   int (*set_display_switch_mode) (int mode);
   void (*display_switch_lock) (int lock, int foreground);
   int (*desktop_color_depth) ();
   int (*get_desktop_resolution) (int *width, int *height);
   void (*get_gfx_safe_mode) (int *driver, GFX_MODE *mode);
   void (*yield_timeslice) ();
   void * (*create_mutex) ();
   void (*destroy_mutex) (void *handle);
   void (*lock_mutex) (void *handle);
   void (*unlock_mutex) (void *handle);
   _DRIVER_INFO * (*gfx_drivers) ();
   _DRIVER_INFO * (*digi_drivers) ();
   _DRIVER_INFO * (*midi_drivers) ();
   _DRIVER_INFO * (*keyboard_drivers) ();
   _DRIVER_INFO * (*mouse_drivers) ();
   _DRIVER_INFO * (*joystick_drivers) ();
   _DRIVER_INFO * (*timer_drivers) ();
}

mixin(_export!(
   "extern extern (C) {"
      //"SYSTEM_DRIVER system_none;"
      "SYSTEM_DRIVER * system_driver;"
      //"_DRIVER_INFO _system_driver_list[];"  // see below
   "}"
));

// has to be a pointer, since the length is unknown
//_DRIVER_INFO* _system_driver_list;


/******************************************************************
               D-SPECIFIC INITIALIZATION
 ******************************************************************/
import derelict.allegro.internal.dintern;
static this() {
   allegro_id = derelict.allegro.internal.dintern.allegro_id.ptr;
   allegro_error = derelict.allegro.internal.dintern.allegro_error.ptr;
   cpu_vendor = derelict.allegro.internal.dintern.cpu_vendor.ptr;
   //_system_driver_list = derelict.allegro.misc._system_driver_list.ptr;
}

unittest {
   version (Tango) {
      alias tango.stdc.errno.errno errno;
      alias tango.stdc.errno.errno errno;
   }

   printf("dallegro: system.d unittest starting...\n");

   install_allegro(SYSTEM_NONE, null, &atexit);

   setErrno(0);
   assert(*allegro_errno == 0);
   assert(getErrno() == *allegro_errno);
   pow(-1, 1.5);  // sets EDOM (33)
   assert(*allegro_errno != 0);
   assert(getErrno() == *allegro_errno);

   setErrno(0);
   assert(*allegro_errno == 0);
   assert(getErrno() == *allegro_errno);
   ftofix(100000);    // sets ERANGE (34)
   assert(*allegro_errno != 0);
   assert(getErrno() == *allegro_errno);

   allegro_exit();
   printf("dallegro: system.d unittest succeeded with no errors.\n");
}
