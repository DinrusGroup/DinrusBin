/*
 * Copyright (c) 2004-2009 Derelict Developers
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
 * * Neither the names 'Derelict', 'DerelictVorbis', nor the names of its contributors
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
module derelict.ogg.vorbisfile;

private
{
    version(Tango)
    {
        import tango.stdc.stdio;
    }
    else
    {
        import std.c;
    }
    import derelict.util.loader;
    import derelict.ogg.oggtypes;
    import derelict.ogg.vorbiscodec;
}


extern (C)
{
    struct ov_callbacks
    {
        size_t function(void* ptr, size_t size, size_t nmemb, void* datasource ) read_func;
        int function(void* datasource, ogg_int64_t offset, int whence ) seek_func;
        int function(void* datasource ) close_func;
        int function(void* datasource ) tell_func;
    }
}

enum
{
    NOTOPEN   =0,
    PARTOPEN  =1,
    OPENED    =2,
    STREAMSET =3,
    INITSET   =4,
}

struct OggVorbis_File
{   void            *datasource;
    int              seekable;
    ogg_int64_t      offset;
    ogg_int64_t      end;
    ogg_sync_state   oy;
    int              links;
    ogg_int64_t     *offsets;
    ogg_int64_t     *dataoffsets;
    int             *serialnos;
    ogg_int64_t     *pcmlengths;
    vorbis_info     *vi;
    vorbis_comment  *vc;
    ogg_int64_t      pcm_offset;
    int              ready_state;
    int              current_serialno;
    int              current_link;
    double           bittrack;
    double           samptrack;
    ogg_stream_state os;
    vorbis_dsp_state vd;
    vorbis_block     vb;

    ov_callbacks callbacks;
}

void loadVorbisFile(SharedLib lib)
{

    bindFunc(ov_clear)("ov_clear", lib);
    // bindFunc(ov_fopen)("ov_fopen", lib);
    bindFunc(ov_open_callbacks)("ov_open_callbacks", lib);

    // bindFunc(ov_test)("ov_test", lib);
    bindFunc(ov_test_callbacks)("ov_test_callbacks", lib);
    bindFunc(ov_test_open)("ov_test_open", lib);

    bindFunc(ov_bitrate)("ov_bitrate", lib);
    bindFunc(ov_bitrate_instant)("ov_bitrate_instant", lib);
    bindFunc(ov_streams)("ov_streams", lib);
    bindFunc(ov_seekable)("ov_seekable", lib);
    bindFunc(ov_serialnumber)("ov_serialnumber", lib);

    bindFunc(ov_raw_total)("ov_raw_total", lib);
    bindFunc(ov_pcm_total)("ov_pcm_total", lib);
    bindFunc(ov_time_total)("ov_time_total", lib);

    bindFunc(ov_raw_seek)("ov_raw_seek", lib);
    bindFunc(ov_pcm_seek)("ov_pcm_seek", lib);
    bindFunc(ov_pcm_seek_page)("ov_pcm_seek_page", lib);
    bindFunc(ov_time_seek)("ov_time_seek", lib);
    bindFunc(ov_time_seek_page)("ov_time_seek_page", lib);

    bindFunc(ov_raw_seek_lap)("ov_raw_seek_lap", lib);
    bindFunc(ov_pcm_seek_lap)("ov_pcm_seek_lap", lib);
    bindFunc(ov_pcm_seek_page_lap)("ov_pcm_seek_page_lap", lib);
    bindFunc(ov_time_seek_lap)("ov_time_seek_lap", lib);
    bindFunc(ov_time_seek_page_lap)("ov_time_seek_page_lap", lib);

    bindFunc(ov_raw_tell)("ov_raw_tell", lib);
    bindFunc(ov_pcm_tell)("ov_pcm_tell", lib);
    bindFunc(ov_time_tell)("ov_time_tell", lib);

    bindFunc(ov_info)("ov_info", lib);
    bindFunc(ov_comment)("ov_comment", lib);

    bindFunc(ov_read_float)("ov_read_float", lib);
    bindFunc(ov_read)("ov_read", lib);
    bindFunc(ov_crosslap)("ov_crosslap", lib);

    bindFunc(ov_halfrate)("ov_halfrate", lib);
    bindFunc(ov_halfrate_p)("ov_halfrate_p", lib);

} // loadVorbisFile()


GenericLoader DerelictVorbisFile;
static this() {
    DerelictVorbisFile.setup(
        "vorbisfile.dll, libvorbisfile.dll",
        "libvorbisfile.so, libvorbisfile.so.3, libvorbisfile.so.3.1.0",
        "",
        &loadVorbisFile
    );
}


//==============================================================================
// Functions
//==============================================================================
extern (C)
{
    int function(OggVorbis_File* vf) ov_clear;
    // int function(char* path, OggVorbis_File* vf) ov_fopen; --> seems to be missing
    // int function(FILE* f, OggVorbis_File* vf, char* initial, int ibytes) ov_open; --> rewritten below
    int function(void* datasource, OggVorbis_File* vf, char* initial, int  ibytes, ov_callbacks callbacks) ov_open_callbacks;

    // int function(FILE* f,OggVorbis_File* vf, byte* initial, int  ibytes) ov_test; --> rewritten below
    int function(void* datasource, OggVorbis_File* vf, char* initial, int  ibytes, ov_callbacks callbacks) ov_test_callbacks;
    int function(OggVorbis_File* vf) ov_test_open;

    int function(OggVorbis_File* vf,int i) ov_bitrate;
    int function(OggVorbis_File* vf) ov_bitrate_instant;
    int function(OggVorbis_File* vf) ov_streams;
    int function(OggVorbis_File* vf) ov_seekable;
    int function(OggVorbis_File* vf,int i) ov_serialnumber;

    ogg_int64_t function(OggVorbis_File* vf,int i) ov_raw_total;
    ogg_int64_t function(OggVorbis_File* vf,int i) ov_pcm_total;
    double function(OggVorbis_File* vf,int i) ov_time_total;

    int function(OggVorbis_File* vf,ogg_int64_t pos) ov_raw_seek;
    int function(OggVorbis_File* vf,ogg_int64_t pos) ov_pcm_seek;
    int function(OggVorbis_File* vf,ogg_int64_t pos) ov_pcm_seek_page;
    int function(OggVorbis_File* vf,double pos) ov_time_seek;
    int function(OggVorbis_File* vf,double pos) ov_time_seek_page;

    int function(OggVorbis_File* vf,ogg_int64_t pos) ov_raw_seek_lap;
    int function(OggVorbis_File* vf,ogg_int64_t pos) ov_pcm_seek_lap;
    int function(OggVorbis_File* vf,ogg_int64_t pos) ov_pcm_seek_page_lap;
    int function(OggVorbis_File* vf,double pos) ov_time_seek_lap;
    int function(OggVorbis_File* vf,double pos) ov_time_seek_page_lap;

    ogg_int64_t function(OggVorbis_File* vf) ov_raw_tell;
    ogg_int64_t function(OggVorbis_File* vf) ov_pcm_tell;
    double function(OggVorbis_File* vf) ov_time_tell;

    vorbis_info* function(OggVorbis_File* vf,int link) ov_info;
    vorbis_comment* function(OggVorbis_File* vf,int link) ov_comment;

    int function(OggVorbis_File* vf, float*** pcm_channels, int samples, int* bitstream) ov_read_float;
    int function(OggVorbis_File* vf, byte* buffer, int length, int bigendianp, int word, int sgned, int* bitstream) ov_read;
    int function(OggVorbis_File* vf1,OggVorbis_File* vf2) ov_crosslap;

    int function(OggVorbis_File* vf,int flag) ov_halfrate;
    int function(OggVorbis_File* vf) ov_halfrate_p;


}   // extern(C)


private extern (C)
{
    size_t Derelict_VorbisRead(void *ptr, size_t byteSize, size_t sizeToRead, void *datasource)
    {   //printf("VorbisRead(%d, %d, %d, %d)\n", ptr, byteSize, sizeToRead, datasource);
        return fread(ptr, byteSize, sizeToRead, cast(FILE*)datasource);
    }
    int Derelict_VorbisSeek(void *datasource, ogg_int64_t offset, int whence)
    {   //printf("VorbisSeek(%d, %d, %d)\n", datasource, offset, whence);
        return fseek(cast(FILE*)datasource, cast(int)offset, whence);
    }
    int Derelict_VorbisClose(void *datasource)
    {   //printf("VorbisClose(%d)\n", datasource);
        return fclose(cast(FILE*)datasource);
    }
    int Derelict_VorbisTell(void *datasource)
    {   //printf("VorbisTell(%d)\n", datasource);
        return ftell(cast(FILE*)datasource);
    }
}

// ov_open is rewritten below because of incompatibility between compilers with FILE struct
// Using this wrapper, it *should* work exactly as it would in c++. --JoeCoder
int ov_open(FILE *f, OggVorbis_File *vf, char *initial, long ibytes)
{
    // Fill the ov_callbacks structure
    ov_callbacks    vorbisCallbacks;    // Structure to hold pointers to callback functions
    vorbisCallbacks.read_func  = &Derelict_VorbisRead;
    vorbisCallbacks.close_func = &Derelict_VorbisClose;
    vorbisCallbacks.seek_func  = &Derelict_VorbisSeek;
    vorbisCallbacks.tell_func  = &Derelict_VorbisTell;

    return ov_open_callbacks(f, vf, initial, cast(int)ibytes, vorbisCallbacks);
}

// ditto for ov_test
int ov_test(FILE *f, OggVorbis_File *vf, char *initial, long ibytes)
{
    // Fill the ov_callbacks structure
    ov_callbacks    vorbisCallbacks;    // Structure to hold pointers to callback functions
    vorbisCallbacks.read_func  = &Derelict_VorbisRead;
    vorbisCallbacks.close_func = &Derelict_VorbisClose;
    vorbisCallbacks.seek_func  = &Derelict_VorbisSeek;
    vorbisCallbacks.tell_func  = &Derelict_VorbisTell;

    return ov_test_callbacks(f, vf, initial, cast(int)ibytes, vorbisCallbacks);
} 