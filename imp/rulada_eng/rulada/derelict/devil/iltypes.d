/*
 * Copyright (c) 2004-2008 Derelict Developers
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the names 'Derelict', 'DerelictIL', nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
module derelict.devil.iltypes;

alias uint      ILenum;
alias ubyte     ILboolean;
alias uint      ILbitfield;
alias byte      ILbyte;
alias short     ILshort;
alias int       ILint;
alias int       ILsizei;
alias ubyte     ILubyte;
alias ushort    ILushort;
alias uint      ILuint;
alias float     ILfloat;
alias float     ILclampf;
alias double    ILdouble;
alias double    ILclampd;
alias void      ILvoid;

//alias wchar_t*    ILstring;
version(DerelictIL_Unicode)
{
    alias wchar ILchar;
    alias wchar* ILstring;
}
else
{
    alias char ILchar;
    alias char* ILstring;
}

enum : ILboolean
{
    IL_FALSE=0,
    IL_TRUE=1,
}

enum : ILenum
{
    // Matches OpenGL's right now.
    IL_COLOUR_INDEX=0x1900,
    IL_COLOR_INDEX=0x1900,
    IL_RGB=0x1907,
    IL_RGBA=0x1908,
    IL_BGR=0x80E0,
    IL_BGRA=0x80E1,
    IL_LUMINANCE=0x1909,
    IL_LUMINANCE_ALPHA=0x190A,

    IL_BYTE=0x1400,
    IL_UNSIGNED_BYTE=0x1401,
    IL_SHORT=0x1402,
    IL_UNSIGNED_SHORT=0x1403,
    IL_INT=0x1404,
    IL_UNSIGNED_INT=0x1405,
    IL_FLOAT=0x1406,
    IL_DOUBLE=0x140A,
    IL_HALF = 0x140B,

    IL_VENDOR=0x1F00,
    IL_LOAD_EXT=0x1F01,
    IL_SAVE_EXT=0x1F02,

    //
    // IL-specific//
    IL_VERSION_1_7_3=1,
    IL_VERSION=173,

    // Attribute Bits
    IL_ORIGIN_BIT=0x00000001,
    IL_FILE_BIT=0x00000002,
    IL_PAL_BIT=0x00000004,
    IL_FORMAT_BIT=0x00000008,
    IL_TYPE_BIT=0x00000010,
    IL_COMPRESS_BIT=0x00000020,
    IL_LOADFAIL_BIT=0x00000040,
    IL_FORMAT_SPECIFIC_BIT=0x00000080,
    IL_ALL_ATTRIB_BITS=0x000FFFFF,

    // Palette types
    IL_PAL_NONE=0x0400,
    IL_PAL_RGB24=0x0401,
    IL_PAL_RGB32=0x0402,
    IL_PAL_RGBA32=0x0403,
    IL_PAL_BGR24=0x0404,
    IL_PAL_BGR32=0x0405,
    IL_PAL_BGRA32=0x0406,

    // Image types
    IL_TYPE_UNKNOWN=0x0000,
    IL_BMP=0x0420,
    IL_CUT=0x0421,
    IL_DOOM=0x0422,
    IL_DOOM_FLAT=0x0423,
    IL_ICO=0x0424,
    IL_JPG=0x0425,
    IL_JFIF=0x0425,
    IL_LBM=0x0426,
    IL_PCD=0x0427,
    IL_PCX=0x0428,
    IL_PIC=0x0429,
    IL_PNG=0x042A,
    IL_PNM=0x042B,
    IL_SGI=0x042C,
    IL_TGA=0x042D,
    IL_TIF=0x042E,
    IL_CHEAD=0x042F,
    IL_RAW=0x0430,
    IL_MDL=0x0431,
    IL_WAL=0x0432,
    IL_LIF=0x0434,
    IL_MNG=0x0435,
    IL_JNG=0x0435,
    IL_GIF=0x0436,
    IL_DDS=0x0437,
    IL_DCX=0x0438,
    IL_PSD=0x0439,
    IL_EXIF=0x043A,
    IL_PSP=0x043B,
    IL_PIX=0x043C,
    IL_PXR=0x043D,
    IL_XPM=0x043E,
    IL_HDR=0x043F,
    IL_ICNS=0x0440,
    IL_JP2=0x0441,
    IL_EXR=0x0442,
    IL_WDP=0x0443,
    IL_JASC_PAL=0x0475,

    // Error Types
    IL_NO_ERROR=0x0000,
    IL_INVALID_ENUM=0x0501,
    IL_OUT_OF_MEMORY=0x0502,
    IL_FORMAT_NOT_SUPPORTED=0x0503,
    IL_INTERNAL_ERROR=0x0504,
    IL_INVALID_VALUE=0x0505,
    IL_ILLEGAL_OPERATION=0x0506,
    IL_ILLEGAL_FILE_VALUE=0x0507,
    IL_INVALID_FILE_HEADER=0x0508,
    IL_INVALID_PARAM=0x0509,
    IL_COULD_NOT_OPEN_FILE=0x050A,
    IL_INVALID_EXTENSION=0x050B,
    IL_FILE_ALREADY_EXISTS=0x050C,
    IL_OUT_FORMAT_SAME=0x050D,
    IL_STACK_OVERFLOW=0x050E,
    IL_STACK_UNDERFLOW=0x050F,
    IL_INVALID_CONVERSION=0x0510,
    IL_BAD_DIMENSIONS=0x0511,
    IL_FILE_READ_ERROR=0x0512,
    IL_FILE_WRITE_ERROR=0x0512,

    IL_LIB_GIF_ERROR=0x05E1,
    IL_LIB_JPEG_ERROR=0x05E2,
    IL_LIB_PNG_ERROR=0x05E3,
    IL_LIB_TIFF_ERROR=0x05E4,
    IL_LIB_MNG_ERROR=0x05E5,
    IL_LIB_JP2_ERROR=0x05E6,
    IL_UNKNOWN_ERROR=0x05FF,

    // Origin Definitions
    IL_ORIGIN_SET=0x0600,
    IL_ORIGIN_LOWER_LEFT=0x0601,
    IL_ORIGIN_UPPER_LEFT=0x0602,
    IL_ORIGIN_MODE=0x0603,

    // Format and Type Mode Definitions
    IL_FORMAT_SET=0x0610,
    IL_FORMAT_MODE=0x0611,
    IL_TYPE_SET=0x0612,
    IL_TYPE_MODE=0x0613,

    // File definitions
    IL_FILE_OVERWRITE=0x0620,
    IL_FILE_MODE=0x0621,

    // Palette definitions
    IL_CONV_PAL=0x0630,

    // Load fail definitions
    IL_DEFAULT_ON_FAIL=0x0632,

    // Key colour definitions
    IL_USE_KEY_COLOUR=0x0635,
    IL_USE_KEY_COLOR=0x0635,

    // Interlace definitions
    IL_SAVE_INTERLACED=0x0639,
    IL_INTERLACE_MODE=0x063A,

    // Quantization definitions
    IL_QUANTIZATION_MODE=0x0640,
    IL_WU_QUANT=0x0641,
    IL_NEU_QUANT=0x0642,
    IL_NEU_QUANT_SAMPLE=0x0643,
    IL_MAX_QUANT_INDEXS=0x0644,

    // Hints
    IL_FASTEST=0x0660,
    IL_LESS_MEM=0x0661,
    IL_DONT_CARE=0x0662,
    IL_MEM_SPEED_HINT=0x0665,
    IL_USE_COMPRESSION=0x0666,
    IL_NO_COMPRESSION=0x0667,
    IL_COMPRESSION_HINT=0x0668,

    // Subimage types
    IL_SUB_NEXT=0x0680,
    IL_SUB_MIPMAP=0x0681,
    IL_SUB_LAYER=0x0682,

    // Compression definitions
    IL_COMPRESS_MODE=0x0700,
    IL_COMPRESS_NONE=0x0701,
    IL_COMPRESS_RLE=0x0702,
    IL_COMPRESS_LZO=0x0703,
    IL_COMPRESS_ZLIB=0x0704,

    // File format-specific values
    IL_TGA_CREATE_STAMP=0x0710,
    IL_JPG_QUALITY=0x0711,
    IL_PNG_INTERLACE=0x0712,
    IL_TGA_RLE=0x0713,
    IL_BMP_RLE=0x0714,
    IL_SGI_RLE=0x0715,
    IL_TGA_ID_STRING=0x0717,
    IL_TGA_AUTHNAME_STRING=0x0718,
    IL_TGA_AUTHCOMMENT_STRING=0x0719,
    IL_PNG_AUTHNAME_STRING=0x071A,
    IL_PNG_TITLE_STRING=0x071B,
    IL_PNG_DESCRIPTION_STRING=0x071C,
    IL_TIF_DESCRIPTION_STRING=0x071D,
    IL_TIF_HOSTCOMPUTER_STRING=0x071E,
    IL_TIF_DOCUMENTNAME_STRING=0x071F,
    IL_TIF_AUTHNAME_STRING=0x0720,
    IL_JPG_SAVE_FORMAT=0x0721,
    IL_CHEAD_HEADER_STRING=0x0722,
    IL_PCD_PICNUM=0x0723,
    IL_PNG_ALPHA_INDEX=0x0724,

    // DXTC definitions
    IL_DXTC_FORMAT=0x0705,
    IL_DXT1=0x0706,
    IL_DXT2=0x0707,
    IL_DXT3=0x0708,
    IL_DXT4=0x0709,
    IL_DXT5=0x070A,
    IL_DXT_NO_COMP=0x070B,
    IL_KEEP_DXTC_DATA=0x070C,
    IL_DXTC_DATA_FORMAT=0x070D,
    IL_3DC=0x070E,
    IL_RXGB=0x070F,
    IL_ATI1N=0x0710,

    // Cube map definitions
    IL_CUBEMAP_POSITIVEX=0x00000400,
    IL_CUBEMAP_NEGATIVEX=0x00000800,
    IL_CUBEMAP_POSITIVEY=0x00001000,
    IL_CUBEMAP_NEGATIVEY=0x00002000,
    IL_CUBEMAP_POSITIVEZ=0x00004000,
    IL_CUBEMAP_NEGATIVEZ=0x00008000,

    // Values
    IL_VERSION_NUM=0x0DE2,
    IL_IMAGE_WIDTH=0x0DE4,
    IL_IMAGE_HEIGHT=0x0DE5,
    IL_IMAGE_DEPTH=0x0DE6,
    IL_IMAGE_SIZE_OF_DATA=0x0DE7,
    IL_IMAGE_BPP=0x0DE8,
    IL_IMAGE_BYTES_PER_PIXEL=0x0DE8,
    IL_IMAGE_BITS_PER_PIXEL=0x0DE9,
    IL_IMAGE_FORMAT=0x0DEA,
    IL_IMAGE_TYPE=0x0DEB,
    IL_PALETTE_TYPE=0x0DEC,
    IL_PALETTE_SIZE=0x0DED,
    IL_PALETTE_BPP=0x0DEE,
    IL_PALETTE_NUM_COLS=0x0DEF,
    IL_PALETTE_BASE_TYPE=0x0DF0,
    IL_NUM_IMAGES=0x0DF1,
    IL_NUM_MIPMAPS=0x0DF2,
    IL_NUM_LAYERS=0x0DF3,
    IL_ACTIVE_IMAGE=0x0DF4,
    IL_ACTIVE_MIPMAP=0x0DF5,
    IL_ACTIVE_LAYER=0x0DF6,
    IL_CUR_IMAGE=0x0DF7,
    IL_IMAGE_DURATION=0x0DF8,
    IL_IMAGE_PLANESIZE=0x0DF9,
    IL_IMAGE_BPC=0x0DFA,
    IL_IMAGE_OFFX=0x0DFB,
    IL_IMAGE_OFFY=0x0DFC,
    IL_IMAGE_CUBEFLAGS=0x0DFD,
    IL_IMAGE_ORIGIN=0x0DFE,
    IL_IMAGE_CHANNELS=0x0DFF,
}

enum : ILint
{
    IL_SEEK_SET=0,
    IL_SEEK_CUR=1,
    IL_SEEK_END=2,
    IL_EOF=1,
}

alias void* ILHANDLE;


extern(System):
// Callback functions for file reading
alias ILvoid function(ILHANDLE) fCloseRProc;
alias ILboolean function(ILHANDLE) fEofProc;
alias ILint function(ILHANDLE) fGetcProc;
alias ILHANDLE function(in ILstring) fOpenRProc;
alias ILint function(void*, ILuint, ILuint, ILHANDLE) fReadProc;
alias ILint function(ILHANDLE, ILint, ILint) fSeekRProc;
alias ILint function(ILHANDLE) fTellRProc;

// Callback functions for file writing
alias ILvoid function(ILHANDLE) fCloseWProc;
alias ILHANDLE function(in ILstring) fOpenWProc;
alias ILint function(ILubyte, ILHANDLE) fPutcProc;
alias ILint function(ILHANDLE, ILint, ILint) fSeekWProc;
alias ILint function(ILHANDLE) fTellWProc;
alias ILint function(in void*, ILuint, ILuint, ILHANDLE) fWriteProc;

// Callback functions for allocation and deallocation
alias ILvoid* function(ILuint) mAlloc;
alias ILvoid function(in ILvoid*) mFree;

// Registered format procedures
alias ILenum function(in ILstring) IL_LOADPROC;
alias ILenum function(in ILstring) IL_SAVEPROC;