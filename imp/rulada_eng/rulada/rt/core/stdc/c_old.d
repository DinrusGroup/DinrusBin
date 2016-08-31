module rt.core.c;

public import rt.core.stdc.errno_;
public import rt.core.stdc.fenv;
public import rt.core
/* Exact sizes */

alias  byte   int8_t;
alias ubyte  uint8_t;
alias  short  int16_t;
alias ushort uint16_t;
alias  int    int32_t;
alias uint   uint32_t;
alias  long   int64_t;
alias ulong  uint64_t;

/* At least sizes */

alias  byte   int_least8_t;
alias ubyte  uint_least8_t;
alias  short  int_least16_t;
alias ushort uint_least16_t;
alias  int    int_least32_t;
alias uint   uint_least32_t;
alias  long   int_least64_t;
alias ulong  uint_least64_t;

/* Fastest minimum width sizes */

alias  byte  int_fast8_t;
alias ubyte uint_fast8_t;
alias  int   int_fast16_t;
alias uint  uint_fast16_t;
alias  int   int_fast32_t;
alias uint  uint_fast32_t;
alias  long  int_fast64_t;
alias ulong uint_fast64_t;

/* Integer pointer holders */

alias int   intptr_t;
alias uint uintptr_t;

/* Greatest width integer types */

alias  long  intmax_t;
alias ulong uintmax_t;

/*
extern  (C):

version (Windows)
{
    /// Entire floating point environment

    struct fenv_t
    {
	ushort status;
	ushort control;
	ushort round;
	ushort reserved[2];
    }

    extern  fenv_t _FE_DFL_ENV;

    /// Default floating point environment
    fenv_t* FE_DFL_ENV = &_FE_DFL_ENV;

    alias int fexcept_t;	/// Floating point status flags

    int fetestexcept(int excepts);		///
    int feraiseexcept(int excepts);		///
    int feclearexcept(int excepts);		///
    //int fegetexcept(fexcept_t *flagp,int excepts);	///
    //int fesetexcept(fexcept_t *flagp,int excepts);	///
    int fegetround();			///
    int fesetround(int round);		///
    int fegetprec();			///
    int fesetprec(int prec);		///
    int fegetenv(fenv_t *envp);		///
    int fesetenv(fenv_t *envp);		///
    //void feprocentry(fenv_t *envp);	///
    //void feprocexit(const fenv_t *envp);	///

    int fegetexceptflag(fexcept_t *flagp,int excepts);	///
    int fesetexceptflag(fexcept_t *flagp,int excepts);	///
    int feholdexcept(fenv_t *envp);		///
    int feupdateenv(fenv_t *envp);		///

}
else version (linux)
{
    /// Entire floating point environment

    struct fenv_t
    {
	ushort __control_word;
	ushort __unused1;
	ushort __status_word;
	ushort __unused2;
	ushort __tags;
	ushort __unused3;
	uint __eip;
	ushort __cs_selector;
	ushort __opcode;
	uint __data_offset;
	ushort __data_selector;
	ushort __unused5;
    }

    /// Default floating point environment
    fenv_t* FE_DFL_ENV = cast(fenv_t*)(-1);

    alias int fexcept_t;	/// Floating point status flags

    int fetestexcept(int excepts);		///
    int feraiseexcept(int excepts);		///
    int feclearexcept(int excepts);		///
    //int fegetexcept(fexcept_t *flagp,int excepts);	///
    //int fesetexcept(fexcept_t *flagp,int excepts);	///
    int fegetround();			///
    int fesetround(int round);		///
    int fegetprec();			///
    int fesetprec(int prec);		///
    int fegetenv(fenv_t *envp);		///
    int fesetenv(fenv_t *envp);		///
    //void feprocentry(fenv_t *envp);	///
    //void feprocexit(const fenv_t *envp);	///

    int fegetexceptflag(fexcept_t *flagp,int excepts);	///
    int fesetexceptflag(fexcept_t *flagp,int excepts);	///
    int feholdexcept(fenv_t *envp);		///
    int feupdateenv(fenv_t *envp);		///
}
else version (OSX)
{
    /// Entire floating point environment

    struct fenv_t
    {
	ushort __control;
	ushort __status;
	uint __mxcsr;
	char[8] __reserved;
    }

    extern  fenv_t _FE_DFL_ENV;

    /// Default floating point environment
    fenv_t* FE_DFL_ENV = &_FE_DFL_ENV;

    alias int fexcept_t;	/// Floating point status flags

    int fetestexcept(int excepts);		///
    int feraiseexcept(int excepts);		///
    int feclearexcept(int excepts);		///
    //int fegetexcept(fexcept_t *flagp,int excepts);	///
    //int fesetexcept(fexcept_t *flagp,int excepts);	///
    int fegetround();			///
    int fesetround(int round);		///
    int fegetprec();			///
    int fesetprec(int prec);		///
    int fegetenv(fenv_t *envp);		///
    int fesetenv(fenv_t *envp);		///
    //void feprocentry(fenv_t *envp);	///
    //void feprocexit(const fenv_t *envp);	///

    int fegetexceptflag(fexcept_t *flagp,int excepts);	///
    int fesetexceptflag(fexcept_t *flagp,int excepts);	///
    int feholdexcept(fenv_t *envp);		///
    int feupdateenv(fenv_t *envp);		///
}
else version (FreeBSD)
{
    /// Entire floating point environment

    struct fenv_t
    {
	struct X87
	{
	    uint __control;
	    uint __status;
	    uint __tag;
	    char[16] other;
	}

	X87 __x87;
	uint __mxcsr;
    }

    extern  fenv_t __fe_defl_env;

    /// Default floating point environment
    fenv_t* FE_DFL_ENV = &__fe_defl_env;

    alias ushort fexcept_t;	/// Floating point status flags
}
else version (Solaris)
{
    /// Entire floating point environment

    struct fenv_t
    {
       struct __fex_handler_t
       {
           int __mode;
           void (*__handler)();
       }

       __fex_handler_t[12] __handlers;
       uint __fsr;
    }

    /// Default floating point environment
    extern  fenv_t __fenv_dfl_env;

    fenv_t* FE_DFL_ENV = &__fenv_dfl_env;

    alias int fexcept_t;       /// Floating point status flags

    int fetestexcept(int excepts);             ///
    int feraiseexcept(int excepts);            ///
    int feclearexcept(int excepts);            ///
    //int fegetexcept(fexcept_t *flagp,int excepts);   ///
    //int fesetexcept(fexcept_t *flagp,int excepts);   ///
    int fegetround();                  ///
    int fesetround(int round);         ///
    int fegetprec();                   ///
    int fesetprec(int prec);           ///
    int fegetenv(fenv_t *envp);                ///
    int fesetenv(fenv_t *envp);                ///
    //void feprocentry(fenv_t *envp);  ///
    //void feprocexit(const fenv_t *envp);     ///

    int fegetexceptflag(fexcept_t *flagp,int excepts); ///
    int fesetexceptflag(fexcept_t *flagp,int excepts); ///
    int feholdexcept(fenv_t *envp);            ///
    int feupdateenv(fenv_t *envp);             ///
}
else
{
    static assert(0);
}



/// The various floating point exceptions
enum
{
    FE_INVALID		= 1,		///
    FE_DENORMAL		= 2,		///
    FE_DIVBYZERO	= 4,		///
    FE_OVERFLOW		= 8,		///
    FE_UNDERFLOW	= 0x10,		///
    FE_INEXACT		= 0x20,		///
    FE_ALL_EXCEPT	= 0x3F,		/// Mask of all the exceptions
}

/// Rounding modes
enum
{
    FE_TONEAREST	= 0,		///
    FE_UPWARD		= 0x800,	///
    FE_DOWNWARD		= 0x400,	///
    FE_TOWARDZERO	= 0xC00,	///
}

/// Floating point precision
enum
{
    FE_FLTPREC	= 0,			///
    FE_DBLPREC	= 0x200,		///
    FE_LDBLPREC	= 0x300,		///
}
*/
/******************************* rt.core.c.locale ***************************************/

	/// Structure giving information about numeric and monetary notation.
struct lconv{
	/// The decimal-point character used to format nonmonetary quantities.
	char* decimal_point;

	/** The character used to separate groups of digits before the
	 * decimal-point character in formatted nonmonetary quantities.
	 **/
	char* thousands_sep;

	/** A string whose elements indicate the size of each group of digits
	 * in formatted nonmonetary quantities.
	 **/
	char* grouping;

	/** The international currency symbol applicable to the current locale.
	 * The first three characters contain the alphabetic international
	 * currency symbol in accordance with those specified in ISO 4217.
	 * The fourth character	(immediately preceding the null character)
	 * is the character used to separate the international currency symbol
	 * from the monetary quantity.
	 **/
	char* int_curr_symbol;

	/// The local currency symbol applicable to the current locale.
	char* currency_symbol;

	/// The decimal-point used to format monetary quantities.
	char* mon_decimal_point;

	/** The separator for groups of digits before the decimal-point in
	 * formatted monetary quantities.
	 **/
	char* mon_thousands_sep;

	/** A string whose elements indicate the size of each group of digits
	 * in formatted monetary quantities.
	 **/
	char* mon_grouping;

	/** The string used to indicate a nonnegative-valued formatted
	 * monetary quantity.
	 **/
	char* positive_sign;

	/** The string used to indicate a negative-valued formatted monetary
	 * quantity.
	 **/
	char* negative_sign;

	/** The number of fractional digits (those after the decimal-point) to
	 * be displayed in an internationally formatted monetary quantity.
	 **/
	char int_frac_digits;

	/** The number of fractional digits (those after the decimal-point) to
	 * be displayed in a locally formatted monetary quantity.
	 **/
	char frac_digits;

	/// 1 if currency_symbol precedes a positive value, 0 if succeeds.
	char p_cs_precedes;
	
	/// 1 if a space separates currency_symbol from a positive value.
	char p_sep_by_space;
	
	/// 1 if currency_symbol precedes a negative value, 0 if succeeds.
	char n_cs_precedes;

	/// 1 if a space separates currency_symbol from a negative value.
	char n_sep_by_space;

  /* Positive and negative sign positions:
     0 Parentheses surround the quantity and currency_symbol.
     1 The sign string precedes the quantity and currency_symbol.
     2 The sign string follows the quantity and currency_symbol.
     3 The sign string immediately precedes the currency_symbol.
     4 The sign string immediately follows the currency_symbol.  */
  char p_sign_posn;
  char n_sign_posn;
  
	/// 1 if int_curr_symbol precedes a positive value, 0 if succeeds.
	char int_p_cs_precedes;
	
	/// 1 iff a space separates int_curr_symbol from a positive value.
	char int_p_sep_by_space;
	
	/// 1 if int_curr_symbol precedes a negative value, 0 if succeeds.
	char int_n_cs_precedes;
	
	/// 1 iff a space separates int_curr_symbol from a negative value.
	char int_n_sep_by_space;

  /* Positive and negative sign positions:
     0 Parentheses surround the quantity and int_curr_symbol.
     1 The sign string precedes the quantity and int_curr_symbol.
     2 The sign string follows the quantity and int_curr_symbol.
     3 The sign string immediately precedes the int_curr_symbol.
     4 The sign string immediately follows the int_curr_symbol.  */
  char int_p_sign_posn;
  char int_n_sign_posn;
}

/** Affects the behavior of C's character handling functions and C's multibyte
 * and wide character functions.
 **/
const LC_CTYPE = 0; 

/** Affects the decimal-point character for C's formatted input/output functions
 * and C's string conversion functions, as well as C's nonmonetary formatting
 * information returned by the localeconv function.
 **/
const LC_NUMERIC = 1;

/// Affects the behavior of the strftime and wcsftime functions.
const LC_TIME = 2;

/// Affects the behavior of the strcoll and strxfrm functions.
const LC_COLLATE = 3;

/** Affects the monetary formatting information returned by the localeconv
 * function.
 **/
const LC_MONETARY = 4;

/// The program's entire locale.
const LC_ALL = 6;

/** The setlocale function selects the appropriate portion of the program's
 * locale as specified by the category and locale arguments.
 **/
char* setlocale(int category, char* locale);

/** The localeconv function sets the components of an object with type
 * lconv with values appropriate for the formatting of numeric quantities
 * (monetary and otherwise) according to the rules of the current locale.
 **/
lconv* localeconv();


/********************************** c *************************************/

extern  (C):

alias float float_t;	///
alias double double_t;	///

const double HUGE_VAL  = double.infinity;	///
const float HUGE_VALF = float.infinity;	/// ditto
const real HUGE_VALL = real.infinity;	/// ditto

const float INFINITY = float.infinity;	///
const float NAN = float.nan;	///

enum
{
    FP_NANS,	// extension
    FP_NANQ,	// extension
    FP_INFINITE,	///
    FP_NAN = FP_NANQ,	///
    FP_NORMAL = 3,	///
    FP_SUBNORMAL = 4,	///
    FP_ZERO = 5,	///
    FP_EMPTY = 6,	// extension
    FP_UNSUPPORTED = 7, // extension
}

enum
{
    FP_FAST_FMA  = 0,	///
    FP_FAST_FMAF = 0,	///
    FP_FAST_FMAL = 0,	///
}

const int FP_ILOGB0   = int.min;	///
const int FP_ILOGBNAN = int.min;	///

const int MATH_ERRNO     = 1;	///
const int MATH_ERREXCEPT = 2;	///
const int math_errhandling   = MATH_ERRNO | MATH_ERREXCEPT;	///

double acos(double x);	///
float  acosf(float x);	/// ditto
real   acosl(real x);	/// ditto

double asin(double x);	///
float  asinf(float x);	/// ditto
real   asinl(real x);	/// ditto

double atan(double x);	///
float  atanf(float x);	/// ditto
real   atanl(real x);	/// ditto

double atan2(double y, double x);	///
float  atan2f(float y, float x);	/// ditto
real   atan2l(real y, real x);		/// ditto

double cos(double x);	///
float  cosf(float x);	/// ditto
real   cosl(real x);	/// ditto

double sin(double x);	///
float  sinf(float x);	/// ditto
real   sinl(real x);	/// ditto

double tan(double x);	///
float  tanf(float x);	/// ditto
real   tanl(real x);	/// ditto

double acosh(double x);	///
float  acoshf(float x);	/// ditto
real   acoshl(real x);	/// ditto

double asinh(double x);	///
float  asinhf(float x);	/// ditto
real   asinhl(real x);	/// ditto

double atanh(double x);	///
float  atanhf(float x);	/// ditto
real   atanhl(real x);	/// ditto

double cosh(double x);	///
float  coshf(float x);	/// ditto
real   coshl(real x);	/// ditto

double sinh(double x);	///
float  sinhf(float x);	/// ditto
real   sinhl(real x);	/// ditto

double tanh(double x);	///
float  tanhf(float x);	/// ditto
real   tanhl(real x);	/// ditto

double exp(double x);	///
float  expf(float x);	/// ditto
real   expl(real x);	/// ditto

double exp2(double x);	///
float  exp2f(float x);	/// ditto
real   exp2l(real x);	/// ditto

double expm1(double x);	///
float  expm1f(float x);	/// ditto
real   expm1l(real x);	/// ditto

double frexp(double value, int *exp);	///
float  frexpf(float value, int *exp);	/// ditto
real   frexpl(real value, int *exp);	/// ditto

int    ilogb(double x);	///
int    ilogbf(float x);	/// ditto
int    ilogbl(real x);	/// ditto

double ldexp(double x, int exp);	///
float  ldexpf(float x, int exp);	/// ditto
real   ldexpl(real x, int exp);		/// ditto

double log(double x);	///
float  logf(float x);	/// ditto
real   logl(real x);	/// ditto

double log10(double x);	///
float  log10f(float x);	/// ditto
real   log10l(real x);	/// ditto

double log1p(double x);	///
float  log1pf(float x);	/// ditto
real   log1pl(real x);	/// ditto

double log2(double x);	///
float  log2f(float x);	/// ditto
real   log2l(real x);	/// ditto

double logb(double x);	///
float  logbf(float x);	/// ditto
real   logbl(real x);	/// ditto

double modf(double value, double *iptr);	///
float  modff(float value, float *iptr);		/// ditto
real   modfl(real value, real *iptr);		/// ditto

double scalbn(double x, int n);	///
float  scalbnf(float x, int n);	/// ditto
real   scalbnl(real x, int n);	/// ditto

double scalbln(double x, int n);	///
float  scalblnf(float x, int n);	/// ditto
real   scalblnl(real x, int n);		/// ditto

double cbrt(double x);	///
float  cbrtf(float x);	/// ditto
real   cbrtl(real x);	/// ditto

double fabs(double x);	///
float  fabsf(float x);	/// ditto
real   fabsl(real x);	/// ditto

double hypot(double x, double y);	///
float  hypotf(float x, float y);	/// ditto
real   hypotl(real x, real y);		/// ditto

double pow(double x, double y);	///
float  powf(float x, float y);	/// ditto
real   powl(real x, real y);	/// ditto

double sqrt(double x);	///
float  sqrtf(float x);	/// ditto
real   sqrtl(real x);	/// ditto

double erf(double x);	///
float  erff(float x);	/// ditto
real   erfl(real x);	/// ditto

double erfc(double x);	///
float  erfcf(float x);	/// ditto
real   erfcl(real x);	/// ditto

double lgamma(double x);	///
float  lgammaf(float x);	/// ditto
real   lgammal(real x);		/// ditto

double tgamma(double x);	///
float  tgammaf(float x);	/// ditto
real   tgammal(real x);		/// ditto

double ceil(double x);	///
float  ceilf(float x);	/// ditto
real   ceill(real x);	/// ditto

double floor(double x);	///
float  floorf(float x);	/// ditto
real   floorl(real x);	/// ditto

double nearbyint(double x);	///
float  nearbyintf(float x);	/// ditto
real   nearbyintl(real x);	/// ditto

double rint(double x);	///
float  rintf(float x);	/// ditto
real   rintl(real x);	/// ditto

int    lrint(double x);	///
int    lrintf(float x);	/// ditto
int    lrintl(real x);	/// ditto

long   llrint(double x);	///
long   llrintf(float x);	/// ditto
long   llrintl(real x);		/// ditto

double round(double x);	///
float  roundf(float x);	/// ditto
real   roundl(real x);	/// ditto

int    lround(double x);	///
int    lroundf(float x);	/// ditto
int    lroundl(real x);		/// ditto

long   llround(double x);	///
long   llroundf(float x);	/// ditto
long   llroundl(real x);	/// ditto

double trunc(double x);	///
float  truncf(float x);	/// ditto
real   truncl(real x);	/// ditto

double fmod(double x, double y);	///
float  fmodf(float x, float y);		/// ditto
real   fmodl(real x, real y);		/// ditto

double remainder(double x, double y);	///
float  remainderf(float x, float y);	/// ditto
real   remainderl(real x, real y);	/// ditto

double remquo(double x, double y, int *quo);	///
float  remquof(float x, float y, int *quo);	/// ditto
real   remquol(real x, real y, int *quo);	/// ditto

double copysign(double x, double y);	///
float  copysignf(float x, float y);	/// ditto
real   copysignl(real x, real y);	/// ditto

double nan(char *tagp);		///
float  nanf(char *tagp);	/// ditto
real   nanl(char *tagp);	/// ditto

double nextafter(double x, double y);	///
float  nextafterf(float x, float y);	/// ditto
real   nextafterl(real x, real y);	/// ditto

double nexttoward(double x, real y);	///
float  nexttowardf(float x, real y);	/// ditto
real   nexttowardl(real x, real y);	/// ditto

double fdim(double x, double y);	///
float  fdimf(float x, float y);		/// ditto
real   fdiml(real x, real y);		/// ditto

double fmax(double x, double y);	///
float  fmaxf(float x, float y);		/// ditto
real   fmaxl(real x, real y);		/// ditto

double fmin(double x, double y);	///
float  fminf(float x, float y);		/// ditto
real   fminl(real x, real y);		/// ditto

double fma(double x, double y, double z);	///
float  fmaf(float x, float y, float z);		/// ditto
real   fmal(real x, real y, real z);		/// ditto

///
int isgreater(real x, real y)		{ return !(x !>  y); }
///
int isgreaterequal(real x, real y)	{ return !(x !>= y); }
///
int isless(real x, real y)		{ return !(x !<  y); }
///
int islessequal(real x, real y)		{ return !(x !<= y); }
///
int islessgreater(real x, real y)	{ return !(x !<> y); }
///
int isunordered(real x, real y)		{ return (x !<>= y); }

/************************************* c **************************************************/

void exit(int);
void _c_exit();
void _cexit();
void _exit(int);
void abort();
void _dodtors();
int getpid();

int system(char *);

enum { _P_WAIT, _P_NOWAIT, _P_OVERLAY };

int execl(char *, char *,...);
int execle(char *, char *,...);
int execlp(char *, char *,...);
int execlpe(char *, char *,...);
int execv(char *, char **);
int execve(char *, char **, char **);
int execvp(char *, char **);
int execvpe(char *, char **, char **);


enum { WAIT_CHILD, WAIT_GRANDCHILD }

int cwait(int *,int,int);
int wait(int *);

version (Windows)
{
    uint _beginthread(void function(void *),uint,void *);

    extern  (Windows) alias uint (*stdfp)(void *);

    uint _beginthreadex(void* security, uint stack_size,
	    stdfp start_addr, void* arglist, uint initflag,
	    uint* thrdaddr);

    void _endthread();
    void _endthreadex(uint);

    int spawnl(int, char *, char *,...);
    int spawnle(int, char *, char *,...);
    int spawnlp(int, char *, char *,...);
    int spawnlpe(int, char *, char *,...);
    int spawnv(int, char *, char **);
    int spawnve(int, char *, char **, char **);
    int spawnvp(int, char *, char **);
    int spawnvpe(int, char *, char **, char **);


    int _wsystem(wchar_t *);
    int _wspawnl(int, wchar_t *, wchar_t *, ...);
    int _wspawnle(int, wchar_t *, wchar_t *, ...);
    int _wspawnlp(int, wchar_t *, wchar_t *, ...);
    int _wspawnlpe(int, wchar_t *, wchar_t *, ...);
    int _wspawnv(int, wchar_t *, wchar_t **);
    int _wspawnve(int, wchar_t *, wchar_t **, wchar_t **);
    int _wspawnvp(int, wchar_t *, wchar_t **);
    int _wspawnvpe(int, wchar_t *, wchar_t **, wchar_t **);

    int _wexecl(wchar_t *, wchar_t *, ...);
    int _wexecle(wchar_t *, wchar_t *, ...);
    int _wexeclp(wchar_t *, wchar_t *, ...);
    int _wexeclpe(wchar_t *, wchar_t *, ...);
    int _wexecv(wchar_t *, wchar_t **);
    int _wexecve(wchar_t *, wchar_t **, wchar_t **);
    int _wexecvp(wchar_t *, wchar_t **);
    int _wexecvpe(wchar_t *, wchar_t **, wchar_t **);
}

/*********************************rt.core.c *****************************************************/

alias void* va_list;

template va_start(T)
{
    void va_start(out va_list ap, inout T parmn)
    {
	ap = cast(va_list)(cast(void*)&parmn + ((T.sizeof + int.sizeof - 1) & ~(int.sizeof - 1)));
    }
}

template va_arg(T)
{
    T va_arg(inout va_list ap)
    {
	T arg = *cast(T*)ap;
	ap = cast(va_list)(cast(void*)ap + ((T.sizeof + int.sizeof - 1) & ~(int.sizeof - 1)));
	return arg;
    }
}

void va_end(va_list ap)
{

}

void va_copy(out va_list dest, va_list src)
{
    dest = src;
}

/********************************************** c *****************************************************/

version (Win32)
{
    alias wchar wchar_t;
}
else version (linux)
{
    alias dchar wchar_t;
}
else version (OSX)
{
    alias dchar wchar_t;
}
else version (FreeBSD)
{
    alias dchar wchar_t;
}
else version (Solaris)
{
    alias dchar wchar_t;
}
else
{
    static assert(0);
}

/**********************************************c ****************************************************************/

version (Win32)
{   // Meaning Digital Mars C for Win32

    const int _NFILE = 60;	///
    const int BUFSIZ = 0x4000;	///
    const int EOF = -1;		///
    const int FOPEN_MAX = 20;	///
    const int FILENAME_MAX = 256;  /// 255 plus NULL
    const int TMP_MAX = 32767;	///
    const int _SYS_OPEN = 20;	///
    const int SYS_OPEN = _SYS_OPEN;	///
    const wchar WEOF = 0xFFFF;		///

    struct _iobuf
    {
	align (1):

	char	*_ptr;
	int	_cnt;
	char	*_base;
	int	_flag;
	int	_file;
	int	_charbuf;
	int	_bufsiz;
	int	__tmpnum;
    }

    enum { SEEK_SET, SEEK_CUR, SEEK_END }

    alias _iobuf FILE;	///

    enum
    {
	_F_RDWR = 0x0003,
	_F_READ = 0x0001,
	_F_WRIT = 0x0002,
	_F_BUF  = 0x0004,
	_F_LBUF = 0x0008,
	_F_ERR  = 0x0010,
	_F_EOF  = 0x0020,
	_F_BIN  = 0x0040,
	_F_IN   = 0x0080,
	_F_OUT  = 0x0100,
	_F_TERM = 0x0200,
    }

    extern  FILE _iob[_NFILE];
    extern  void function() _fcloseallp;
    extern  ubyte __fhnd_info[_NFILE];

    enum
    {
	FHND_APPEND	= 0x04,
	FHND_DEVICE	= 0x08,
	FHND_TEXT	= 0x10,
	FHND_BYTE	= 0x20,
	FHND_WCHAR	= 0x40,
    }

    enum
    {
	_IOREAD	= 1,
	_IOWRT	= 2,
	_IONBF	= 4,
	_IOMYBUF = 8,
	_IOEOF	= 0x10,
	_IOERR	= 0x20,
	_IOLBF	= 0x40,
	_IOSTRG	= 0x40,
	_IORW	= 0x80,
	_IOFBF	= 0,
	_IOAPP	= 0x200,
	_IOTRAN	= 0x100,
    }

    const FILE *stdin  = &_iob[0];	///
    const FILE *stdout = &_iob[1];	///
    const FILE *stderr = &_iob[2];	///
    const FILE *stdaux = &_iob[3];	///
    const FILE *stdprn = &_iob[4];	///

    alias int fpos_t;	///
    const char[] _P_tmpdir = "\\";
    const wchar[] _wP_tmpdir = "\\";
    const int L_tmpnam = _P_tmpdir.length + 12;

    ///
    int  ferror(FILE *fp)	{ return fp._flag&_IOERR;	}
    ///
    int  feof(FILE *fp)	{ return fp._flag&_IOEOF;	}
    ///
    void clearerr(FILE *fp)	{ fp._flag &= ~(_IOERR|_IOEOF); }
    ///
    void rewind(FILE *fp)	{ fseek(fp,0L,SEEK_SET); fp._flag&=~_IOERR; }
    int  _bufsize(FILE *fp)	{ return fp._bufsiz; }
    ///
    int  fileno(FILE *fp)	{ return fp._file; }
    int  _snprintf(char *,size_t,char *,...);
    int  _vsnprintf(char *,size_t,char *,va_list);
}
else version (linux)
{
    const int EOF = -1;
    const int FOPEN_MAX = 16;
    const int FILENAME_MAX = 4095;
    const int TMP_MAX = 238328;
    const int L_tmpnam = 20;

    struct _iobuf
    {
	align (1):

	char*	_read_ptr;
	char*	_read_end;
	char*	_read_base;
	char*	_write_base;
	char*	_write_ptr;
	char*	_write_end;
	char*	_buf_base;
	char*	_buf_end;
	char*	_save_base;
	char*	_backup_base;
	char*	_save_end;
	void*	_markers;
	_iobuf*	_chain;
	int	_fileno;
	int	_blksize;
	int	_old_offset;
	ushort	_cur_column;
	byte	_vtable_offset;
	char[1]	_shortbuf;
	void*	_lock;
    }

    enum { SEEK_SET, SEEK_CUR, SEEK_END }

    alias _iobuf FILE;	///

    enum
    {
	_F_RDWR = 0x0003,
	_F_READ = 0x0001,
	_F_WRIT = 0x0002,
	_F_BUF  = 0x0004,
	_F_LBUF = 0x0008,
	_F_ERR  = 0x0010,
	_F_EOF  = 0x0020,
	_F_BIN  = 0x0040,
	_F_IN   = 0x0080,
	_F_OUT  = 0x0100,
	_F_TERM = 0x0200,
    }

    enum
    {
	_IOFBF = 0,
	_IOLBF = 1,
	_IONBF = 2,
    }

    alias int fpos_t;
    extern  FILE *stdin;
    extern  FILE *stdout;
    extern  FILE *stderr;

    FILE * fopen64(in char *,in char *);	///

    int  ferror(FILE *fp);
    int  feof(FILE *fp);
    void clearerr(FILE *fp);
    void rewind(FILE *fp);
    int  _bufsize(FILE *fp);
    int  fileno(FILE *fp);
    int  snprintf(char *,size_t,char *,...);
    int  vsnprintf(char *,size_t,char *,va_list);
}
else version (OSX)
{
    const int EOF = -1;
    const int BUFSIZ = 1024;
    const int FOPEN_MAX = 20;
    const int FILENAME_MAX = 1024;
    const int TMP_MAX = 308915776;
    const int L_tmpnam = 1024;

    struct __sbuf
    {
	char* _base;
	int _size;
    }

    struct _iobuf
    {
	align (1):

	char* _p;
	int _r;
	int _w;
	short _flags;
	short _file;
	__sbuf _bf;
	int _lbfsize;
	void* _cookie;
	int function(void*) _close;
	int function(void*, char*, int) _read;
	fpos_t function(void*, fpos_t, int) _seek;
	int function(void*, char*, int) _write;
	__sbuf _ub;
	void* _extra;
	int _ur;
	char[3] _ubuf;
	char[1] _nbuf;
	__sbuf _lb;
	int _blksize;
	fpos_t _offset;
    }

    enum { SEEK_SET, SEEK_CUR, SEEK_END }

    alias _iobuf FILE;	///

    enum
    {
	_F_RDWR = 0x0003,
	_F_READ = 0x0001,
	_F_WRIT = 0x0002,
	_F_BUF  = 0x0004,
	_F_LBUF = 0x0008,
	_F_ERR  = 0x0010,
	_F_EOF  = 0x0020,
	_F_BIN  = 0x0040,
	_F_IN   = 0x0080,
	_F_OUT  = 0x0100,
	_F_TERM = 0x0200,
    }

    enum
    {
	_IOFBF = 0,
	_IOLBF = 1,
	_IONBF = 2,
    }

    alias long fpos_t;

    extern  FILE *__stdinp;
    extern  FILE *__stdoutp;
    extern  FILE *__stderrp;

    alias __stdinp stdin;
    alias __stdoutp stdout;
    alias __stderrp stderr;

    int  ferror(FILE *fp);
    int  feof(FILE *fp);
    void clearerr(FILE *fp);
    void rewind(FILE *fp);
    int  _bufsize(FILE *fp);
    int  fileno(FILE *fp);
    int  snprintf(char *,size_t,char *,...);
    int  vsnprintf(char *,size_t,char *,va_list);
}
else version (FreeBSD)
{
    const int EOF = -1;
    const int BUFSIZ = 1024;
    const int FOPEN_MAX = 20;
    const int FILENAME_MAX = 1024;
    const int TMP_MAX = 308915776;
    const int L_tmpnam = 1024;

    struct __sbuf
    {
	char* _base;
	int _size;
    }

    struct _iobuf
    {
	align (1):

	char* _p;
	int _r;
	int _w;
	short _flags;
	short _file;
	__sbuf _bf;
	int _lbfsize;
	void* _cookie;
	int function(void*) _close;
	int function(void*, char*, int) _read;
	fpos_t function(void*, fpos_t, int) _seek;
	int function(void*, char*, int) _write;
	__sbuf _ub;
	void* _extra;
	int _ur;
	char[3] _ubuf;
	char[1] _nbuf;
	__sbuf _lb;
	int _blksize;
	fpos_t _offset;
    }

    enum { SEEK_SET, SEEK_CUR, SEEK_END }

    alias _iobuf FILE;	///

    enum
    {
	_F_RDWR = 0x0003,
	_F_READ = 0x0001,
	_F_WRIT = 0x0002,
	_F_BUF  = 0x0004,
	_F_LBUF = 0x0008,
	_F_ERR  = 0x0010,
	_F_EOF  = 0x0020,
	_F_BIN  = 0x0040,
	_F_IN   = 0x0080,
	_F_OUT  = 0x0100,
	_F_TERM = 0x0200,
    }

    enum
    {
	_IOFBF = 0,
	_IOLBF = 1,
	_IONBF = 2,
    }

    alias long fpos_t;

    extern  FILE *__stdinp;
    extern  FILE *__stdoutp;
    extern  FILE *__stderrp;

    alias __stdinp stdin;
    alias __stdoutp stdout;
    alias __stderrp stderr;

    int  ferror(FILE *fp);
    int  feof(FILE *fp);
    void clearerr(FILE *fp);
    void rewind(FILE *fp);
    int  _bufsize(FILE *fp);
    int  fileno(FILE *fp);
    int  snprintf(char *,size_t,char *,...);
    int  vsnprintf(char *,size_t,char *,va_list);
}
else version (Solaris)
{
    const int EOF = -1;
    const int BUFSIZ = 1024;
    const int FOPEN_MAX = 20;
    const int FILENAME_MAX = 1024;
    const int TMP_MAX = 17576;
    const int L_tmpnam = 25;
    const int _NFILE = 20;

    struct __sbuf
    {
       char* _base;
       int _size;
    }

    struct _iobuf
    {
       align (1):

       int _cnt;
       ubyte* _ptr;
       ubyte* _base;
       ubyte _flag;
       ubyte _magic;
       ubyte[2] __bitflags;
    }

    enum { SEEK_SET, SEEK_CUR, SEEK_END }

    alias _iobuf FILE; ///

    enum
    {
       _IOFBF = 0000,
       _IOLBF = 0100,
       _IONBF = 0200,
    }

    alias long fpos_t;

    extern  FILE _iob[_NFILE];

    const FILE *stdin  = &_iob[0];     ///
    const FILE *stdout = &_iob[1];     ///
    const FILE *stderr = &_iob[2];     ///

    int  ferror(FILE *fp);
    int  feof(FILE *fp);
    void clearerr(FILE *fp);
    void rewind(FILE *fp);
    int  _bufsize(FILE *fp);
    int  fileno(FILE *fp);
    int  snprintf(char *,size_t,char *,...);
    int  vsnprintf(char *,size_t,char *,va_list);
}
else
{
    static assert(0);
}

char *	 tmpnam(char *);	///
FILE *	 fopen(in char *,in char *);	///
FILE *	 _fsopen(in char *,in char *,int );	///
FILE *	 freopen(in char *,in char *,FILE *);	///
int	 fseek(FILE *,int,int);	///
int	 ftell(FILE *);	///
char *	 fgets(char *,int,FILE *);	///
int	 fgetc(FILE *);	///
int	 _fgetchar();	///
int	 fflush(FILE *);	///
int	 fclose(FILE *);	///
int	 fputs(char *,FILE *);	///
char *	 gets(char *);	///
int	 fputc(int,FILE *);	///
int	 _fputchar(int);	///
int	 puts(char *);	///
int	 ungetc(int,FILE *);	///
int	 fread(void *,int,int,FILE *);	///
size_t	 fwrite(void *,size_t,size_t,FILE *);	///
//int	 printf(char *,...);	///
int	 fprintf(FILE *,char *,...);	///
int	 vfprintf(FILE *,char *,va_list);	///
int	 vprintf(char *,va_list);	///
int	 sprintf(char *,char *,...);	///
int	 vsprintf(char *,char *,va_list);	///
int	 scanf(char *,...);	///
int	 fscanf(FILE *,char *,...);	///
int	 sscanf(char *,char *,...);	///
void	 setbuf(FILE *,char *);	///
int	 setvbuf(FILE *,char *,int,size_t);	///
int	 remove(char *);	///
int	 rename(char *,char *);	///
void	 perror(char *);	///
int	 fgetpos(FILE *,fpos_t *);	///
int	 fsetpos(FILE *,fpos_t *);	///
FILE *	 tmpfile();	///
int	 _rmtmp();
int      _fillbuf(FILE *);
int      _flushbu(int, FILE *);

int  getw(FILE *FHdl);	///
int  putw(int Word, FILE *FilePtr);	///

///
int  getchar()		{ return getc(stdin);		}
///
int  putchar(int c)	{ return putc(c,stdout);	}
///
int  getc(FILE *fp)	{ return fgetc(fp);		}
///
int  putc(int c,FILE *fp) { return fputc(c,fp);		}

int      unlink(char *);	///
FILE *	 fdopen(int, char *);	///
int	 fgetchar();	///
int	 fputchar(int);	///
int	 fcloseall();	///
int	 filesize(char *);	///
int	 flushall();	///
int	 getch();	///
int	 getche();	///
int      kbhit();	///
char *   tempnam (char *dir, char *pfx);	///

wchar_t *  _wtmpnam(wchar_t *);	///
FILE *  _wfopen(wchar_t *, wchar_t *);
FILE *  _wfsopen(wchar_t *, wchar_t *, int);
FILE *  _wfreopen(wchar_t *, wchar_t *, FILE *);
wchar_t *  fgetws(wchar_t *, int, FILE *);	///
int  fputws(wchar_t *, FILE *);	///
wchar_t *  _getws(wchar_t *);
int  _putws(wchar_t *);
int  wprintf(wchar_t *, ...);	///
int  fwprintf(FILE *, wchar_t *, ...);	///
int  vwprintf(wchar_t *, va_list);	///
int  vfwprintf(FILE *, wchar_t *, va_list);	///
int  swprintf(wchar_t *, wchar_t *, ...);	///
int  vswprintf(wchar_t *, wchar_t *, va_list);	///
int  _snwprintf(wchar_t *, size_t, wchar_t *, ...);
int  _vsnwprintf(wchar_t *, size_t, wchar_t *, va_list);
int  wscanf(wchar_t *, ...);	///
int  fwscanf(FILE *, wchar_t *, ...);	///
int  swscanf(wchar_t *, wchar_t *, ...);	///
int  _wremove(wchar_t *);
void  _wperror(wchar_t *);
FILE *  _wfdopen(int, wchar_t *);
wchar_t *  _wtempnam(wchar_t *, wchar_t *);
wchar_t  fgetwc(FILE *);	///
wchar_t  _fgetwchar_t();
wchar_t  fputwc(wchar_t, FILE *);	///
wchar_t  _fputwchar_t(wchar_t);
wchar_t  ungetwc(wchar_t, FILE *);	///

///
wchar_t	 getwchar_t()		{ return fgetwc(stdin); }
///
wchar_t	 putwchar_t(wchar_t c)	{ return fputwc(c,stdout); }
///
//wchar_t	 getwc(FILE *fp)	{ return fgetwc(fp); }
///
//wchar_t	 putwc(wchar_t c, FILE *fp)	{ return fputwc(c, fp); }

int fwide(FILE* fp, int mode);	///

/*****************************************c*****************************************************/

version (Windows)
{
    enum
    {
	_MAX_PATH   = 260,
	_MAX_DRIVE  = 3,
	_MAX_DIR    = 256,
	_MAX_FNAME  = 256,
	_MAX_EXT    = 256,
    }
}

///
struct div_t { int  quot,rem; }
///
struct ldiv_t { int quot,rem; }
///
struct lldiv_t { long quot,rem; }

    div_t div(int,int);	///
    ldiv_t ldiv(int,int); /// ditto
    lldiv_t lldiv(long, long); /// ditto

    const int EXIT_SUCCESS = 0;	///
    const int EXIT_FAILURE = 1;	/// ditto

    int    atexit(void (*)());	///
    //void   exit(int);	/// ditto
    //void   _exit(int);	/// ditto

    //int system(char *);

    void *alloca(uint);	///

    //void *calloc(size_t, size_t);	///
    void *malloc(size_t);	/// ditto
    //void *realloc(void *, size_t);	/// ditto
    //void free(void *);	/// ditto

    void *bsearch(void *,void *,size_t,size_t,
       int function(void *,void *));	///
    void qsort(void *base, size_t nelems, size_t elemsize,
	int (*compare)(void *elem1, void *elem2));	/// ditto

    char* getenv(char*);	///
    int   setenv(char*, char*, int); /// extension to ISO C standard, not available on all platforms
    void  unsetenv(char*); /// extension to ISO C standard, not available on all platforms

    int    rand();	///
    void   srand(uint);	/// ditto
    int    random(int num);	/// ditto
    void   randomize();	/// ditto

    int getErrno();	/// ditto
    int setErrno(int);	/// ditto


double atof(char *);	///
int    atoi(char *);	/// ditto
int    atol(char *);	/// ditto
float  strtof(char *,char **);	/// ditto
double strtod(char *,char **);	/// ditto
real   strtold(char *,char **);	/// ditto
long   strtol(char *,char **,int);	/// ditto
uint   strtoul(char *,char **,int);	/// ditto
long   atoll(char *);	/// ditto
long   strtoll(char *,char **,int);	/// ditto
ulong  strtoull(char *,char **,int);	/// ditto

char* itoa(int, char*, int);	///
char* ultoa(uint, char*, int);	/// ditto

int mblen(char *s, size_t n);	///
int mbtowc(wchar_t *pwc, char *s, size_t n);	/// ditto
int wctomb(char *s, wchar_t wc);	/// ditto
size_t mbstowcs(wchar_t *pwcs, char *s, size_t n);	/// ditto
size_t wcstombs(char *s, wchar_t *pwcs, size_t n);	/// ditto

/******************************************* c ********************************************/

//void* memcpy(void* s1, void* s2, size_t n);	///
//void* memmove(void* s1, void* s2, size_t n);	///
char* strcpy(char* s1, char* s2);		///
char* strncpy(char* s1, char* s2, size_t n);	///
char* strncat(char*  s1, char*  s2, size_t n);	///
int strcoll(char* s1, char* s2);		///
int strncmp(char* s1, char* s2, size_t n);	///
size_t strxfrm(char*  s1, char*  s2, size_t n);	///
void* memchr(void* s, int c, size_t n);		///
char* strchr(char* s, int c);			///
size_t strcspn(char* s1, char* s2);		///
char* strpbrk(char* s1, char* s2);		///
char* strrchr(char* s, int c);			///
size_t strspn(char* s1, char* s2);		///
char* strstr(char* s1, char* s2);		///
char* strtok(char*  s1, char*  s2);		///
void* memset(void* s, int c, size_t n);		///
char* strerror(int errnum);			///
size_t strlen(char* s);				///
int strcmp(char* s1, char* s2);			///
char* strcat(char* s1, char* s2);		///
//int memcmp(void* s1, void* s2, size_t n);	///

version (Windows)
{
    int memicmp(char* s1, char* s2, size_t n);	///
}

version (linux)
{
    char* strerror_r(int errnum, char* buf, size_t buflen);	///
}

version (OSX)
{
    int strerror_r(int errnum, char* buf, size_t buflen);	///
}

version (FreeBSD)
{
    int strerror_r(int errnum, char* buf, size_t buflen);	///
}

version (Solaris)
{
    int strerror_r(int errnum, char* buf, size_t buflen);	///
}

/***************************************rt.core.c.time *******************************************************/

alias int clock_t;

version (Windows)
{   const clock_t CLOCKS_PER_SEC = 1000;
    const clock_t CLK_TCK        = 1000;

    struct tm
    {  int     tm_sec,
               tm_min,
               tm_hour,
               tm_mday,
               tm_mon,
               tm_year,
               tm_wday,
               tm_yday,
               tm_isdst;
    }
}
else version (linux)
{   const clock_t CLOCKS_PER_SEC = 1000000;
    extern  (C) int sysconf(int);
    extern  clock_t CLK_TCK;
    /*static this()
    {
	CLK_TCK = cast(clock_t) sysconf(2);
    }*/

    struct tm
    {  int     tm_sec,
               tm_min,
               tm_hour,
               tm_mday,
               tm_mon,
               tm_year,
               tm_wday,
               tm_yday,
               tm_isdst;
    }
}
else version (OSX)
{
    const clock_t CLOCKS_PER_SEC = 100;
    const clock_t CLK_TCK        = 100;

    struct tm
    {  int     tm_sec,
               tm_min,
               tm_hour,
               tm_mday,
               tm_mon,
               tm_year,
               tm_wday,
               tm_yday,
               tm_isdst;
    }
}
else version (FreeBSD)
{
    const clock_t CLOCKS_PER_SEC = 128;
    const clock_t CLK_TCK        = 128; // deprecated, use sysconf(_SC_CLK_TCK)

    struct tm
    {   int     tm_sec,
               tm_min,
               tm_hour,
               tm_mday,
               tm_mon,
               tm_year,
               tm_wday,
               tm_yday,
               tm_isdst;
	int tm_gmtoff;
	char* tm_zone;
    }
}
else version (Solaris)
{
    const clock_t CLOCKS_PER_SEC = 1000000;
    clock_t CLK_TCK        = 0; // deprecated, use sysconf(_SC_CLK_TCK)

    extern  (C) int sysconf(int);
    static this()
    {
       CLK_TCK = _sysconf(3);
    }

    struct tm
    {   int     tm_sec,
               tm_min,
               tm_hour,
               tm_mday,
               tm_mon,
               tm_year,
               tm_wday,
               tm_yday,
               tm_isdst;
    }
}
else
{
    static assert(0);
}

const uint TIMEOFFSET     = 315558000;

alias int time_t;

extern  int daylight;
extern  int timezone;
extern  int altzone;
extern  char *tzname[2];

clock_t clock();
time_t time(time_t *);
time_t mktime(tm *);
char *asctime(tm *);
char *ctime(time_t *);
tm *localtime(time_t *);
tm *gmtime(time_t *);
size_t strftime(char *, size_t, char *, tm *);
char *_strdate(char *dstring);
char *_strtime(char *timestr);
double difftime(time_t t1, time_t t2);
void _tzset();
void tzset();

void sleep(time_t);
void usleep(uint);
void msleep(uint);

wchar_t *_wasctime(tm *);
wchar_t *_wctime(time_t *);
size_t wcsftime(wchar_t *, size_t, wchar_t *, tm *);
wchar_t *_wstrdate(wchar_t *);
wchar_t *_wstrtime(wchar_t *);