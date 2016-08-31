/***************************************************************
                           unicode.h
 ***************************************************************/

module derelict.allegro.unicode;

version (Tango) {
   import tango.stdc.stdarg;
   import tango.stdc.stdlib;
}
else {
   import std.c;
   //import std.c.stdlib;
}

import derelict.allegro.base : _AL_ID, al_long;
import derelict.allegro.internal.dintern;
import derelict.allegro.internal.dversion;
import derelict.allegro.internal._export;


const int U_ASCII      = _AL_ID!('A','S','C','8');
const int U_ASCII_CP   = _AL_ID!('A','S','C','P');
const int U_UNICODE    = _AL_ID!('U','N','I','C');
const int U_UTF8       = _AL_ID!('U','T','F','8');
const int U_CURRENT    = _AL_ID!('c','u','r','.');

extern (C) {

void set_uformat (int type);
int get_uformat ();
void register_uformat (int type, int (*u_getc)(in char *s),
                       int (*u_getx) (char **s),
                       int (*u_setc) (char *s, int c),
                       int (*u_width) (char *s), int (*u_cwidth)(in int c),
                       int (*u_isok) (int c), int u_width_max);
void set_ucodepage (in ushort *table, in ushort *extras);

int need_uconvert (in char *s, int type, int newtype);
int uconvert_size (in char *s, int type, int newtype);
void do_uconvert (in char *s, int type, char *buf, int newtype, int size);
char * uconvert (in char *s, int type, char *buf, int newtype, int size);
int uwidth_max (int type);

} // extern (C)


char* uconvert_ascii(in char* s, char[] buf)
{
   return uconvert(s, U_ASCII, buf.ptr, U_CURRENT, buf.length);
}

char* uconvert_toascii(in char* s, char[] buf)
{
   return uconvert(s, U_CURRENT, buf.ptr, U_ASCII, buf.length);
}

// FIXME: is this safe?  Should be ok, since it's not a string.
// This is undocumented, used by the allegro test apps.
const char EMPTY_STRING = '\0';

stringz empty_string;

mixin(_export!(
   "extern extern (C) {"
      "int (*ugetc) (in char *s);"
      "int (*ugetx) (char **s);"
      "int (*ugetxc) (in char **s);"
      "int (*usetc) (char *s, int c);"
      "int (*uwidth) (in char *s);"
      "int (*ucwidth) (int c);"
      "int (*uisok) (int c);"
   "}"
));

extern (C) {

int uoffset (in char *s, int idx);
int ugetat (in char *s, int idx);
int usetat (char *s, int idx, int c);
int uinsert (char *s, int idx, int c);
int uremove (char *s, int idx);
int utolower (int c);
int utoupper (int c);
int uisspace (int c);
int uisdigit (int c);
int ustrsize (in char *s);
int ustrsizez (in char *s);
char * _ustrdup (in char *src, void * (*malloc_func) (size_t));
char * ustrzcpy (char *dest, int size, in char *src);
char * ustrzcat (char *dest, int size, in char *src);
int ustrlen (in char *s);
int ustrcmp (in char *s1, in char *s2);
char * ustrzncpy (char *dest, int size, in char *src, int n);
char * ustrzncat (char *dest, int size, in char *src, int n);
int ustrncmp (in char *s1, in char *s2, int n);
int ustricmp (in char *s1, in char *s2);
int ustrnicmp (in char *s1, in char *s2, int n);
char * ustrlwr (char *s);
char * ustrupr (char *s);
char * ustrchr (in char *s, int c);
char * ustrrchr (in char *s, int c);
char * ustrstr (in char *s1, in char *s2);
char * ustrpbrk (in char *s, in char *set);
char * ustrtok (char *s, in char *set);
char * ustrtok_r (char *s, in char *set, char **last);
double uatof (in char *s);
al_long ustrtol (in char *s, char **endp, int base);
double ustrtod (in char *s, char **endp);
stringz ustrerror (int err);
int uszprintf (char *buf, int size, in char *format, ...);
int uvszprintf (char *buf, int size, in char *format, va_list args);
int usprintf (char *buf, in char *format, ...);

} // extern (C)

char* ustrdup(in char * src) { return _ustrdup(src, &malloc); }

// FIXME: make these functions safe by using GC'd memory?
char* ustrcpy(char *dest, in char *src)
{
   return ustrzcpy(dest, int.max, src);
}

char* ustrcat(char *dest, in char *src)
{
   return ustrzcat(dest, int.max, src);
}

char* ustrncpy(char *dest, in char *src, int n)
{
   return ustrzncpy(dest, int.max, src, n);
}

char* ustrncat(char *dest, in char *src, int n)
{
   return ustrzncat(dest, int.max, src, n);
}

int uvsprintf(char *buf, in char *format, va_list args)
{
   return uvszprintf(buf, int.max, format, args);
}


static this()
{
   empty_string = derelict.allegro.internal.dintern.empty_string.ptr;
}
