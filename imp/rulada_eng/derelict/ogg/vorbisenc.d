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
module derelict.ogg.vorbisenc;

private {
    import derelict.util.loader;
    import derelict.ogg.oggtypes;
    import derelict.ogg.vorbiscodec;
}

// deprecated rate management supported only for compatability
enum
{
    OV_ECTL_RATEMANAGE_GET       =0x10,
    OV_ECTL_RATEMANAGE_SET       =0x11,
    OV_ECTL_RATEMANAGE_AVG       =0x12,
    OV_ECTL_RATEMANAGE_HARD      =0x13,
}

struct ovectl_ratemanage_arg {
    int    management_active;

    int    bitrate_hard_min;
    int    bitrate_hard_max;
    double bitrate_hard_window;

    int    bitrate_av_lo;
    int    bitrate_av_hi;
    double bitrate_av_window;
    double bitrate_av_window_center;
};

// new rate setup
enum
{
    OV_ECTL_RATEMANAGE2_GET      =0x14,
    OV_ECTL_RATEMANAGE2_SET      =0x15,
}

struct ovectl_ratemanage2_arg {
    int    management_active;

    int    bitrate_limit_min_kbps;
    int    bitrate_limit_max_kbps;
    int    bitrate_limit_reservoir_bits;
    double bitrate_limit_reservoir_bias;

    int    bitrate_average_kbps;
    double bitrate_average_damping;
};

enum
{
    OV_ECTL_LOWPASS_GET          =0x20,
    OV_ECTL_LOWPASS_SET          =0x21,
    OV_ECTL_IBLOCK_GET           =0x30,
    OV_ECTL_IBLOCK_SET           =0x31,
}


private void loadVorbis(SharedLib lib)
{
    bindFunc(vorbis_encode_init)("vorbis_encode_init", lib);
    bindFunc(vorbis_encode_setup_managed)("vorbis_encode_setup_managed", lib);
    bindFunc(vorbis_encode_setup_vbr)("vorbis_encode_setup_vbr", lib);
    bindFunc(vorbis_encode_init_vbr)("vorbis_encode_init_vbr", lib);
    bindFunc(vorbis_encode_setup_init)("vorbis_encode_setup_init", lib);
    bindFunc(vorbis_encode_ctl)("vorbis_encode_ctl", lib);
}


GenericLoader DerelictVorbisEnc;
static this() {
    DerelictVorbisEnc.setup(
        "vorbisenc.dll, libvorbisenc.dll",
        "libvorbisenc.so, libvorbisenc.so.0, libvorbisenc.so.0.3.0",
        "",
        &loadVorbis
    );
}

extern(C)
{
    int function (vorbis_info *vi, int  channels, int  rate, int  max_bitrate, int  nominal_bitrate, int  min_bitrate) vorbis_encode_init;
    int function(vorbis_info *vi, int  channels, int  rate, int  max_bitrate, int  nominal_bitrate, int  min_bitrate) vorbis_encode_setup_managed;
    int function(vorbis_info *vi, int channels, int rate, float base_quality) vorbis_encode_setup_vbr;
    int function(vorbis_info *vi, int channels, int rate, float base_quality) vorbis_encode_init_vbr;
    int function(vorbis_info *vi) vorbis_encode_setup_init;
    int function(vorbis_info *vi,int number, void *arg) vorbis_encode_ctl;
}