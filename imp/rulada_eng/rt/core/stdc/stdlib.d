/**
 * D header file for C99.
 *
 * Copyright: Public Domain
 * License:   Public Domain
 * Authors:   Sean Kelly
 * Standards: ISO/IEC 9899:1999 (E)
 */
module rt.core.stdc.stdlib;

private import rt.core.stdc.config;
public import rt.core.stdc.stddef; // for size_t, wchar_t

// Преобразовать:
alias  atof алфнапз;//алфавитн. в плав. запят.
alias     atoi алфнац;// алф. в целое
alias  atol алфнадл; // алф. в дол
alias    atoll алфнадлдл; // алф. в дол дол

alias  strtod стрнад; // стр в дол 
alias   strtof стрнапз;// стр в плав
alias    strtold стрнадлд;// стр в дол дво
alias  strtol стрнадл; // стр в дол
alias    strtoll стрнадлдл; // стр в дол дол
alias strtoul стрнабдл; // стр в беззн. дол
alias   strtoull стрнабдлдл; // стр в беззн. дол дол

//Генерировать случайные числа:
alias     rand случ;
alias    srand сслуч;

// Распределение памяти:
alias   malloc празмести;
alias   calloc сразмести;
alias   realloc перемести;
alias    free освободи;

// Окончание программы:
alias    abort аборт;
alias    exit выход;
alias     atexit навыходе;
alias    _Exit _Выход;

// Система:
alias   getenv дайсреду;
alias     system система;

// Алгоритмы поиска/сортировки:
alias   bsearch бпоиск;
alias    qsort бсорт;

// Абсолютное значение:
alias     abs абс;
alias  labs длабс;
alias    llabs ддлабс ;

// Деление:
alias   div дели;
alias  ldiv делидл;
alias lldiv делиддл;

// Многобайтн./широкосимв. кодировки:
alias     mblen мбдлин;
alias     mbtowc мбнашк;
alias     wctomb шкнамб;
alias  mbstowcs мбснашкс;
alias  wcstombs шкснамбс;

//Типы:
alias  ldiv_t т_делидл;
alias lldiv_t т_делиддл;
alias div_t т_дели;

//Постоянные:
alias EXIT_SUCCESS ВЫХОД_НОРМА;
alias EXIT_FAILURE ВЫХОД_КРАХ;
alias RAND_MAX     СЛУЧ_МАКС;
alias MB_CUR_MAX   МБ_ТЕК_МАКС;

extern  (C):

struct div_t
{
    int quot,
        rem;
}


struct ldiv_t
{
    int quot,
        rem;
}
struct lldiv_t
{
    long quot,
         rem;
}

const EXIT_SUCCESS = 0;
const EXIT_FAILURE = 1;
const RAND_MAX     = 32767;
const MB_CUR_MAX   = 1;


double  atof(in char* nptr);
int     atoi(in char* nptr);
c_long  atol(in char* nptr);
long    atoll(in char* nptr);

double  strtod(in char* nptr, char** endptr);
float   strtof(in char* nptr, char** endptr);
real    strtold(in char* nptr, char** endptr);
c_long  strtol(in char* nptr, char** endptr, int base);
long    strtoll(in char* nptr, char** endptr, int base);
c_ulong strtoul(in char* nptr, char** endptr, int base);
ulong   strtoull(in char* nptr, char** endptr, int base);

int     rand();
void    srand(uint seed);

void*   malloc(size_t size);
void*   calloc(size_t nmemb, size_t size);
void*   realloc(void* ptr, size_t size);
void    free(void* ptr);

void    abort();
void    exit(int status);
int     atexit(void function() func);
void    _Exit(int status);

char*   getenv(in char* name);
int     system(in char* string);

void*   bsearch(in void* key, in void* base, size_t nmemb, size_t size, int function(in void*, in void*) compar);
void    qsort(void* base, size_t nmemb, size_t size, int function(in void*, in void*) compar);

int     abs(int j);
c_long  labs(c_long j);
long    llabs(long j);

div_t   div(int numer, int denom);
ldiv_t  ldiv(c_long numer, c_long denom);
lldiv_t lldiv(long numer, long denom);

int     mblen(in char* s, size_t n);
int     mbtowc(wchar_t* pwc, in char* s, size_t n);
int     wctomb(char*s, wchar_t wc);
size_t  mbstowcs(wchar_t* pwcs, in char* s, size_t n);
size_t  wcstombs(char* s, in wchar_t* pwcs, size_t n);

version( DigitalMars )
{
    void* alloca(size_t size); // non-standard
	alias alloca разместалф;
}