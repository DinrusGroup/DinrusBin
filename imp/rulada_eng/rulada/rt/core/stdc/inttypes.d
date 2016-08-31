/**
 * D header file for C99.
 *
 * Copyright: Public Domain
 * License:   Public Domain
 * Authors:   Sean Kelly
 * Standards: ISO/IEC 9899:1999 (E)
 */
module rt.core.stdc.inttypes;

public import rt.core.stdc.stddef; // for wchar_t
public import rt.core.stdc.stdint; // required by spec

extern  (C):

struct imaxdiv_t
{
    intmax_t    quot,
                rem;
}

private alias char* _cstr;

const _cstr PRId8            = "hhd";
const _cstr PRId16           = "hd";
const _cstr PRId32           = "ld";
const _cstr PRId64           = "lld";

const _cstr PRIdLEAST8       = "hhd";
const _cstr PRIdLEAST16      = "hd";
const _cstr PRIdLEAST32      = "ld";
const _cstr PRIdLEAST64      = "lld";

const _cstr PRIdFAST8        = "hhd";
const _cstr PRIdFAST16       = "d";
const _cstr PRIdFAST32       = "ld";
const _cstr PRIdFAST64       = "lld";

const _cstr PRIi8            = "hhi";
const _cstr PRIi16           = "hi";
const _cstr PRIi32           = "li";
const _cstr PRIi64           = "lli";

const _cstr PRIiLEAST8       = "hhi";
const _cstr PRIiLEAST16      = "hi";
const _cstr PRIiLEAST32      = "li";
const _cstr PRIiLEAST64      = "lli";

const _cstr PRIiFAST8        = "hhi";
const _cstr PRIiFAST16       = "i";
const _cstr PRIiFAST32       = "li";
const _cstr PRIiFAST64       = "lli";

const _cstr PRIo8            = "hho";
const _cstr PRIo16           = "ho";
const _cstr PRIo32           = "lo";
const _cstr PRIo64           = "llo";

const _cstr PRIoLEAST8       = "hho";
const _cstr PRIoLEAST16      = "ho";
const _cstr PRIoLEAST32      = "lo";
const _cstr PRIoLEAST64      = "llo";

const _cstr PRIoFAST8        = "hho";
const _cstr PRIoFAST16       = "o";
const _cstr PRIoFAST32       = "lo";
const _cstr PRIoFAST64       = "llo";

const _cstr PRIu8            = "hhu";
const _cstr PRIu16           = "hu";
const _cstr PRIu32           = "lu";
const _cstr PRIu64           = "llu";

const _cstr PRIuLEAST8       = "hhu";
const _cstr PRIuLEAST16      = "hu";
const _cstr PRIuLEAST32      = "lu";
const _cstr PRIuLEAST64      = "llu";

const _cstr PRIuFAST8        = "hhu";
const _cstr PRIuFAST16       = "u";
const _cstr PRIuFAST32       = "lu";
const _cstr PRIuFAST64       = "llu";

const _cstr PRIx8            = "hhx";
const _cstr PRIx16           = "hx";
const _cstr PRIx32           = "lx";
const _cstr PRIx64           = "llx";

const _cstr PRIxLEAST8       = "hhx";
const _cstr PRIxLEAST16      = "hx";
const _cstr PRIxLEAST32      = "lx";
const _cstr PRIxLEAST64      = "llx";

const _cstr PRIxFAST8        = "hhx";
const _cstr PRIxFAST16       = "x";
const _cstr PRIxFAST32       = "lx";
const _cstr PRIxFAST64       = "llx";

const _cstr PRIX8            = "hhX";
const _cstr PRIX16           = "hX";
const _cstr PRIX32           = "lX";
const _cstr PRIX64           = "llX";

const _cstr PRIXLEAST8       = "hhX";
const _cstr PRIXLEAST16      = "hX";
const _cstr PRIXLEAST32      = "lX";
const _cstr PRIXLEAST64      = "llX";

const _cstr PRIXFAST8        = "hhX";
const _cstr PRIXFAST16       = "X";
const _cstr PRIXFAST32       = "lX";
const _cstr PRIXFAST64       = "llX";

const _cstr SCNd8            = "hhd";
const _cstr SCNd16           = "hd";
const _cstr SCNd32           = "ld";
const _cstr SCNd64           = "lld";

const _cstr SCNdLEAST8       = "hhd";
const _cstr SCNdLEAST16      = "hd";
const _cstr SCNdLEAST32      = "ld";
const _cstr SCNdLEAST64      = "lld";

const _cstr SCNdFAST8        = "hhd";
const _cstr SCNdFAST16       = "d";
const _cstr SCNdFAST32       = "ld";
const _cstr SCNdFAST64       = "lld";

const _cstr SCNi8            = "hhd";
const _cstr SCNi16           = "hi";
const _cstr SCNi32           = "li";
const _cstr SCNi64           = "lli";

const _cstr SCNiLEAST8       = "hhd";
const _cstr SCNiLEAST16      = "hi";
const _cstr SCNiLEAST32      = "li";
const _cstr SCNiLEAST64      = "lli";

const _cstr SCNiFAST8        = "hhd";
const _cstr SCNiFAST16       = "i";
const _cstr SCNiFAST32       = "li";
const _cstr SCNiFAST64       = "lli";

const _cstr SCNo8            = "hhd";
const _cstr SCNo16           = "ho";
const _cstr SCNo32           = "lo";
const _cstr SCNo64           = "llo";

const _cstr SCNoLEAST8       = "hhd";
const _cstr SCNoLEAST16      = "ho";
const _cstr SCNoLEAST32      = "lo";
const _cstr SCNoLEAST64      = "llo";

const _cstr SCNoFAST8        = "hhd";
const _cstr SCNoFAST16       = "o";
const _cstr SCNoFAST32       = "lo";
const _cstr SCNoFAST64       = "llo";

const _cstr SCNu8            = "hhd";
const _cstr SCNu16           = "hu";
const _cstr SCNu32           = "lu";
const _cstr SCNu64           = "llu";

const _cstr SCNuLEAST8       = "hhd";
const _cstr SCNuLEAST16      = "hu";
const _cstr SCNuLEAST32      = "lu";
const _cstr SCNuLEAST64      = "llu";

const _cstr SCNuFAST8        = "hhd";
const _cstr SCNuFAST16       = "u";
const _cstr SCNuFAST32       = "lu";
const _cstr SCNuFAST64       = "llu";

const _cstr SCNx8            = "hhd";
const _cstr SCNx16           = "hx";
const _cstr SCNx32           = "lx";
const _cstr SCNx64           = "llx";

const _cstr SCNxLEAST8       = "hhd";
const _cstr SCNxLEAST16      = "hx";
const _cstr SCNxLEAST32      = "lx";
const _cstr SCNxLEAST64      = "llx";

const _cstr SCNxFAST8        = "hhd";
const _cstr SCNxFAST16       = "x";
const _cstr SCNxFAST32       = "lx";
const _cstr SCNxFAST64       = "llx";

version( X86_64 )
{
    const _cstr PRIdMAX      = PRId64;
    const _cstr PRIiMAX      = PRIi64;
    const _cstr PRIoMAX      = PRIo64;
    const _cstr PRIuMAX      = PRIu64;
    const _cstr PRIxMAX      = PRIx64;
    const _cstr PRIXMAX      = PRIX64;

    const _cstr SCNdMAX      = SCNd64;
    const _cstr SCNiMAX      = SCNi64;
    const _cstr SCNoMAX      = SCNo64;
    const _cstr SCNuMAX      = SCNu64;
    const _cstr SCNxMAX      = SCNx64;

    const _cstr PRIdPTR      = PRId64;
    const _cstr PRIiPTR      = PRIi64;
    const _cstr PRIoPTR      = PRIo64;
    const _cstr PRIuPTR      = PRIu64;
    const _cstr PRIxPTR      = PRIx64;
    const _cstr PRIXPTR      = PRIX64;

    const _cstr SCNdPTR      = SCNd64;
    const _cstr SCNiPTR      = SCNi64;
    const _cstr SCNoPTR      = SCNo64;
    const _cstr SCNuPTR      = SCNu64;
    const _cstr SCNxPTR      = SCNx64;
}
else
{
    const _cstr PRIdMAX      = PRId32;
    const _cstr PRIiMAX      = PRIi32;
    const _cstr PRIoMAX      = PRIo32;
    const _cstr PRIuMAX      = PRIu32;
    const _cstr PRIxMAX      = PRIx32;
    const _cstr PRIXMAX      = PRIX32;

    const _cstr SCNdMAX      = SCNd32;
    const _cstr SCNiMAX      = SCNi32;
    const _cstr SCNoMAX      = SCNo32;
    const _cstr SCNuMAX      = SCNu32;
    const _cstr SCNxMAX      = SCNx32;

    const _cstr PRIdPTR      = PRId32;
    const _cstr PRIiPTR      = PRIi32;
    const _cstr PRIoPTR      = PRIo32;
    const _cstr PRIuPTR      = PRIu32;
    const _cstr PRIxPTR      = PRIx32;
    const _cstr PRIXPTR      = PRIX32;

    const _cstr SCNdPTR      = SCNd32;
    const _cstr SCNiPTR      = SCNi32;
    const _cstr SCNoPTR      = SCNo32;
    const _cstr SCNuPTR      = SCNu32;
    const _cstr SCNxPTR      = SCNx32;
}

intmax_t  imaxabs(intmax_t j);
imaxdiv_t imaxdiv(intmax_t numer, intmax_t denom);
intmax_t  strtoimax(in char* nptr, char** endptr, int base);
uintmax_t strtoumax(in char* nptr, char** endptr, int base);
intmax_t  wcstoimax(in wchar_t* nptr, wchar_t** endptr, int base);
uintmax_t wcstoumax(in wchar_t* nptr, wchar_t** endptr, int base);
