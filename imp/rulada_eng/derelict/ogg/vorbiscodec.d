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
module derelict.ogg.vorbiscodec;

//==============================================================================
// Loader
//==============================================================================
private {
    import derelict.util.loader;
    import derelict.ogg.oggtypes;
}

enum
{
    OV_FALSE      = -1,
    OV_EOF        = -2,
    OV_HOLE       = -3,
    OV_EREAD      = -128,
    OV_EFAULT     = -129,
    OV_EIMPL      = -130,
    OV_EINVAL     = -131,
    OV_ENOTVORBIS = -132,
    OV_EBADHEADER = -133,
    OV_EVERSION   = -134,
    OV_ENOTAUDIO  = -135,
    OV_EBADPACKET = -136,
    OV_EBADLINK   = -137,
    OV_ENOSEEK    = -138,
}

struct vorbis_info
{   int _version; // Renamed from "version", since that's a keyword in D
    int channels;
    int rate;
    int bitrate_upper;
    int bitrate_nominal;
    int bitrate_lower;
    int bitrate_window;

    void *codec_setup;
}

struct vorbis_dsp_state
{   int analysisp;
    vorbis_info *vi;

    float **pcm;
    float **pcmret;
    int      pcm_storage;
    int      pcm_current;
    int      pcm_returned;

    int  preextrapolate;
    int  eofflag;

    int  lW;
    int  W;
    int  nW;
    int  centerW;

    ogg_int64_t granulepos;
    ogg_int64_t sequence;

    ogg_int64_t glue_bits;
    ogg_int64_t time_bits;
    ogg_int64_t floor_bits;
    ogg_int64_t res_bits;

    void       *backend_state;
}


struct vorbis_block
{
    float  **pcm;
    oggpack_buffer opb;
    int   lW;
    int   W;
    int   nW;
    int   pcmend;
    int   mode;
    int         eofflag;
    ogg_int64_t granulepos;
    ogg_int64_t sequence;
    vorbis_dsp_state *vd;
    void               *localstore;
    int                 localtop;
    int                 localalloc;
    int                 totaluse;
    alloc_chain *reap;
    int  glue_bits;
    int  time_bits;
    int  floor_bits;
    int  res_bits;

    void *internal;
}

struct alloc_chain
{     void *ptr;
      alloc_chain *next;
}

struct vorbis_comment
{
    char **user_comments;
    int   *comment_lengths;
    int    comments;
    char  *vendor;
}

private void loadVorbis(SharedLib lib)
{
    // Vorbis PRIMITIVES: general
    bindFunc(vorbis_info_init)("vorbis_info_init", lib);
    bindFunc(vorbis_info_clear)("vorbis_info_clear", lib);
    bindFunc(vorbis_info_blocksize)("vorbis_info_blocksize", lib);
    bindFunc(vorbis_comment_init)("vorbis_comment_init", lib);
    bindFunc(vorbis_comment_add)("vorbis_comment_add", lib);
    bindFunc(vorbis_comment_add_tag)("vorbis_comment_add_tag", lib);
    bindFunc(vorbis_comment_query)("vorbis_comment_query", lib);
    bindFunc(vorbis_comment_query_count)("vorbis_comment_query_count", lib);
    bindFunc(vorbis_comment_clear)("vorbis_comment_clear", lib);
    bindFunc(vorbis_block_init)("vorbis_block_init", lib);
    bindFunc(vorbis_block_clear)("vorbis_block_clear", lib);
    bindFunc(vorbis_dsp_clear)("vorbis_dsp_clear", lib);
    bindFunc(vorbis_granule_time)("vorbis_granule_time", lib);

    // Vorbis PRIMITIVES: analysis/DSP layer
    bindFunc(vorbis_analysis_init)("vorbis_analysis_init", lib);
    bindFunc(vorbis_commentheader_out)("vorbis_commentheader_out", lib);
    bindFunc(vorbis_analysis_headerout)("vorbis_analysis_headerout", lib);

    bindFunc(vorbis_analysis_buffer)("vorbis_analysis_buffer", lib);
    bindFunc(vorbis_analysis_wrote)("vorbis_analysis_wrote", lib);
    bindFunc(vorbis_analysis_blockout)("vorbis_analysis_blockout", lib);
    bindFunc(vorbis_analysis)("vorbis_analysis", lib);

    bindFunc(vorbis_bitrate_addblock)("vorbis_bitrate_addblock", lib);
    bindFunc(vorbis_bitrate_flushpacket)("vorbis_bitrate_flushpacket", lib);

    // Vorbis PRIMITIVES: synthesis layer
    bindFunc(vorbis_synthesis_headerin)("vorbis_synthesis_idheader", lib);
    bindFunc(vorbis_synthesis_headerin)("vorbis_synthesis_headerin", lib);
    bindFunc(vorbis_synthesis_init)("vorbis_synthesis_init", lib);
    bindFunc(vorbis_synthesis_restart)("vorbis_synthesis_restart", lib);
    bindFunc(vorbis_synthesis)("vorbis_synthesis", lib);
    bindFunc(vorbis_synthesis_trackonly)("vorbis_synthesis_trackonly", lib);
    bindFunc(vorbis_synthesis_blockin)("vorbis_synthesis_blockin", lib);
    bindFunc(vorbis_synthesis_pcmout)("vorbis_synthesis_pcmout", lib);
    bindFunc(vorbis_synthesis_lapout)("vorbis_synthesis_lapout", lib);
    bindFunc(vorbis_synthesis_read)("vorbis_synthesis_read", lib);
    bindFunc(vorbis_packet_blocksize)("vorbis_packet_blocksize", lib);
    bindFunc(vorbis_synthesis_halfrate)("vorbis_synthesis_halfrate", lib);
    bindFunc(vorbis_synthesis_halfrate_p)("vorbis_synthesis_halfrate_p", lib);
}


GenericLoader DerelictVorbis;
static this() {
    DerelictVorbis.setup(
        "vorbis.dll, libvorbis.dll",
        "libvorbis.so, libvorbis.so.0, libvorbis.so.0.3.0",
        "",
        &loadVorbis
    );
}


//==============================================================================
// Functions
//==============================================================================

extern (C)
{
    // Vorbis PRIMITIVES: general
    void function(vorbis_info* vi) vorbis_info_init;
    void function(vorbis_info* vi) vorbis_info_clear;
    int  function(vorbis_info* vi,int zo) vorbis_info_blocksize;
    void function(vorbis_comment* vc) vorbis_comment_init;
    void function(vorbis_comment* vc, byte* comment) vorbis_comment_add;
    void function(vorbis_comment* vc, byte* tag, byte* contents) vorbis_comment_add_tag;
    byte* function(vorbis_comment* vc, byte* tag, int count) vorbis_comment_query;
    int function(vorbis_comment* vc, byte* tag) vorbis_comment_query_count;
    void function(vorbis_comment* vc) vorbis_comment_clear;
    int function(vorbis_dsp_state* v, vorbis_block* vb) vorbis_block_init;
    int function(vorbis_block* vb) vorbis_block_clear;
    void function(vorbis_dsp_state* v) vorbis_dsp_clear;
    double function(vorbis_dsp_state* v, ogg_int64_t granulepos) vorbis_granule_time;

    // Vorbis PRIMITIVES: analysis/DSP layer
    int function(vorbis_dsp_state* v,vorbis_info* vi) vorbis_analysis_init;
    int function(vorbis_comment* vc, ogg_packet* op) vorbis_commentheader_out;
    int function(vorbis_dsp_state* v, vorbis_comment* vc, ogg_packet* op, ogg_packet* op_comm, ogg_packet* op_code) vorbis_analysis_headerout;
    float** function(vorbis_dsp_state* v,int vals) vorbis_analysis_buffer;
    int function(vorbis_dsp_state* v,int vals) vorbis_analysis_wrote;
    int function(vorbis_dsp_state* v,vorbis_block* vb) vorbis_analysis_blockout;
    int function(vorbis_block* vb,ogg_packet* op) vorbis_analysis;
    int function(vorbis_block* vb) vorbis_bitrate_addblock;
    int function(vorbis_dsp_state* vd, ogg_packet* op) vorbis_bitrate_flushpacket;

    // Vorbis PRIMITIVES: synthesis layer
    int function(ogg_packet* op) vorbis_synthesis_idheader;
    int function(vorbis_info* vi,vorbis_comment* vc, ogg_packet* op) vorbis_synthesis_headerin;
    int function(vorbis_dsp_state* v,vorbis_info* vi) vorbis_synthesis_init;
    int function(vorbis_dsp_state* v) vorbis_synthesis_restart;
    int function(vorbis_block* vb,ogg_packet* op) vorbis_synthesis;
    int function(vorbis_block* vb,ogg_packet* op) vorbis_synthesis_trackonly;
    int function(vorbis_dsp_state* v,vorbis_block* vb) vorbis_synthesis_blockin;
    int function(vorbis_dsp_state* v,float*** pcm) vorbis_synthesis_pcmout;
    int function(vorbis_dsp_state* v,float*** pcm) vorbis_synthesis_lapout;
    int function(vorbis_dsp_state* v,int samples) vorbis_synthesis_read;
    int function(vorbis_info* vi,ogg_packet* op) vorbis_packet_blocksize;
    int function(vorbis_info* v,int flag) vorbis_synthesis_halfrate;
    int function(vorbis_info* v) vorbis_synthesis_halfrate_p;
}