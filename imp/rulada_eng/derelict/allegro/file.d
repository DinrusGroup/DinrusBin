/***************************************************************
                           file.h
 ***************************************************************/

module derelict.allegro.file;

version (Tango) {
	import tango.stdc.stdint : uint64_t;
	import tango.stdc.time : time_t;
}
else {
	import std.c : uint64_t;
	import std.c: time_t;
}

import derelict.allegro.base : al_long;


extern (C) {

char * fix_filename_case (char *path);
char * fix_filename_slashes (char *path);
char * canonicalize_filename (char *dest, in char *filename, int size);
char * make_absolute_filename (char *dest, in char *path, in char *filename, int size);
char * make_relative_filename (char *dest, in char *path, in char *filename, int size);
int is_relative_filename (in char *filename);
char * replace_filename (char *dest, in char *path, in char *filename, int size);
char * replace_extension (char *dest, in char *filename, in char *ext, int size);
char * append_filename (char *dest, in char *path, in char *filename, int size);
char * get_filename (in char *path);
char * get_extension (in char *filename);
void put_backslash (char *filename);
int file_exists (in char *filename, int attrib, int *aret);
int exists (in char *filename);
uint64_t file_size_ex (in char *filename);
time_t file_time (in char *filename);
int delete_file (in char *filename);
int for_each_file_ex (in char *name, int in_attrib, int out_attrib, int (*callback) (in char *filename, int attrib, void *param), void *param);
int set_allegro_resource_path (int priority, in char *path);
int find_allegro_resource (char *dest, in char *resource, in char *ext, in char *datafile, in char *objectname, in char *envvar, in char *subdir, int size);

} // extern (C)


struct al_ffblk         /* file info block for the al_find*() routines */
{
   int attrib;          /* actual attributes of the file found */
   time_t time;         /* modification time of file */
   al_long size;        /* size of file */
   char name[512];      /* name of file */
   void *ff_data;       /* private hook */
};

extern (C) {

uint64_t al_ffblk_get_size (al_ffblk *info);

int al_findfirst(in char *pattern, al_ffblk *info, int attrib);
int al_findnext(al_ffblk *info);
void al_findclose(al_ffblk *info);

} // extern (C)


const char* F_READ          = "r";
const char* F_WRITE         = "w";
const char* F_READ_PACKED   = "rp";
const char* F_WRITE_PACKED  = "wp";
const char* F_WRITE_NOPACK  = "w!";

enum : al_long {
    F_BUF_SIZE      = 4096,           /* 4K buffer for caching data */
    F_PACK_MAGIC    = 0x736C6821L,    /* magic number for packed files */
    F_NOPACK_MAGIC  = 0x736C682EL,    /* magic number for autodetect */
    F_EXE_MAGIC     = 0x736C682BL,    /* magic number for appended data */
}

enum {
   PACKFILE_FLAG_WRITE      = 1,     /* the file is being written */
   PACKFILE_FLAG_PACK       = 2,     /* data is compressed */
   PACKFILE_FLAG_CHUNK      = 4,     /* file is a sub-chunk */
   PACKFILE_FLAG_EOF        = 8,     /* reached the end-of-file */
   PACKFILE_FLAG_ERROR      = 16,    /* an error has occurred */
   PACKFILE_FLAG_OLD_CRYPT  = 32,    /* backward compatibility mode */
   PACKFILE_FLAG_EXEDAT     = 64,    /* reading from our executable */
}

struct LZSS_PACK_DATA;
struct LZSS_UNPACK_DATA;


struct _al_normal_packfile_details
{
   int hndl;                           /* DOS file handle */
   int flags;                          /* PACKFILE_FLAG_* constants */
   ubyte *buf_pos;                     /* position in buffer */
   int buf_size;                       /* number of bytes in the buffer */
   al_long todo;                       /* number of bytes still on the disk */
   PACKFILE *parent;                   /* nested, parent file */
   LZSS_PACK_DATA *pack_data;          /* for LZSS compression */
   LZSS_UNPACK_DATA *unpack_data;      /* for LZSS decompression */
   char *filename;                     /* name of the file */
   char *passdata;                     /* encryption key data */
   char *passpos;                      /* current key position */
   ubyte buf[F_BUF_SIZE];              /* the actual data buffer */
}

alias PACKFILE УПФАЙЛ;
struct PACKFILE                           /* our very own FILE structure... */
{
   const PACKFILE_VTABLE *vtable;
   void *userdata;
   int is_normal_packfile;

   /* The following is only to be used for the "normal" PACKFILE vtable,
    * i.e. what is implemented by Allegro itself. If is_normal_packfile is
    * false then the following is not even allocated. This must be the last
    * member in the structure.
    */
   _al_normal_packfile_details normal;
}


struct PACKFILE_VTABLE
{
   extern (C) {
      int (*pf_fclose)(void *userdata);
      int (*pf_getc)(void *userdata);
      int (*pf_ungetc)(int c, void *userdata);
      al_long (*pf_fread)(void *p, al_long n, void *userdata);
      int (*pf_putc)(int c, void *userdata);
      al_long (*pf_fwrite)(in void *p, al_long n, void *userdata);
      int (*pf_fseek)(void *userdata, int offset);
      int (*pf_feof)(void *userdata);
      int (*pf_ferror)(void *userdata);
   }
}


/* FIXME: This only seems to be used by allegro itself.  It's not used in any
 * examples, and it's not mentioned in the docs.  The sizeof(buf) also makes it
 * an accident waiting to happen.  Even moreso for D
 * than for C.
 */
//#define uconvert_tofilename(s, buf)      uconvert(s, U_CURRENT, buf, get_file_encoding(), sizeof(buf))

extern (C) {

void set_file_encoding (int encoding);
int get_file_encoding ();

void packfile_password(in char *password);
PACKFILE * pack_fopen(in char *filename, in char *mode);
PACKFILE * pack_fopen_vtable(in PACKFILE_VTABLE *vtable, void *userdata);
int pack_fclose(PACKFILE *f);
int pack_fseek(PACKFILE *f, int offset);
PACKFILE * pack_fopen_chunk(PACKFILE *f, int pack);
PACKFILE * pack_fclose_chunk(PACKFILE *f);
int pack_getc(PACKFILE *f);
int pack_putc(int c, PACKFILE *f);
int pack_feof(PACKFILE *f);
int pack_ferror(PACKFILE *f);
int pack_igetw(PACKFILE *f);
al_long pack_igetl(PACKFILE *f);
int pack_iputw(int w, PACKFILE *f);
al_long pack_iputl(al_long l, PACKFILE *f);
int pack_mgetw(PACKFILE *f);
al_long pack_mgetl(PACKFILE *f);
int pack_mputw(int w, PACKFILE *f);
al_long pack_mputl(al_long l, PACKFILE *f);
al_long pack_fread(void *p, al_long n, PACKFILE *f);
al_long pack_fwrite(in void *p, al_long n, PACKFILE *f);
int pack_ungetc(int c, PACKFILE *f);
char * pack_fgets(char *p, int max, PACKFILE *f);
int pack_fputs(in char *p, PACKFILE *f);
void * pack_get_userdata(PACKFILE *f);

} // extern (C)
