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
 * * Neither the names 'Derelict', 'DerelictOgg', nor the names of its contributors
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
module derelict.ogg.ogg;

private
{
    import derelict.util.loader;
    import derelict.ogg.oggtypes;
}

private void loadOgg(SharedLib lib)
{
    // Ogg BITSTREAM PRIMITIVES: bitstream
    bindFunc(oggpack_writeinit)("oggpack_writeinit", lib);
    bindFunc(oggpack_writetrunc)("oggpack_writetrunc", lib);
    bindFunc(oggpack_writealign)("oggpack_writealign", lib);
    bindFunc(oggpack_writecopy)("oggpack_writecopy", lib);
    bindFunc(oggpack_reset)("oggpack_reset", lib);
    bindFunc(oggpack_writeclear)("oggpack_writeclear", lib);
    bindFunc(oggpack_readinit)("oggpack_readinit", lib);
    bindFunc(oggpack_write)("oggpack_write", lib);
    bindFunc(oggpack_look)("oggpack_look", lib);
    bindFunc(oggpack_look1)("oggpack_look1", lib);
    bindFunc(oggpack_adv)("oggpack_adv", lib);
    bindFunc(oggpack_adv1)("oggpack_adv1", lib);
    bindFunc(oggpack_read)("oggpack_read", lib);
    bindFunc(oggpack_read1)("oggpack_read1", lib);
    bindFunc(oggpack_bytes)("oggpack_bytes", lib);
    bindFunc(oggpack_bits)("oggpack_bits", lib);
    bindFunc(oggpack_get_buffer)("oggpack_get_buffer", lib);

    bindFunc(oggpackB_writeinit)("oggpackB_writeinit", lib);
    bindFunc(oggpackB_writetrunc)("oggpackB_writetrunc", lib);
    bindFunc(oggpackB_writealign)("oggpackB_writealign", lib);
    bindFunc(oggpackB_writecopy)("oggpackB_writecopy", lib);
    bindFunc(oggpackB_reset)("oggpackB_reset", lib);
    bindFunc(oggpackB_writeclear)("oggpackB_writeclear", lib);
    bindFunc(oggpackB_readinit)("oggpackB_readinit", lib);
    bindFunc(oggpackB_write)("oggpackB_write", lib);
    bindFunc(oggpackB_look)("oggpackB_look", lib);
    bindFunc(oggpackB_look1)("oggpackB_look1", lib);
    bindFunc(oggpackB_adv)("oggpackB_adv", lib);
    bindFunc(oggpackB_adv1)("oggpackB_adv1", lib);
    bindFunc(oggpackB_read)("oggpackB_read", lib);
    bindFunc(oggpackB_read1)("oggpackB_read1", lib);
    bindFunc(oggpackB_bytes)("oggpackB_bytes", lib);
    bindFunc(oggpackB_bits)("oggpackB_bits", lib);
    bindFunc(oggpackB_get_buffer)("oggpackB_get_buffer", lib);

    // Ogg BITSTREAM PRIMITIVES: encoding
    bindFunc(ogg_stream_packetin)("ogg_stream_packetin", lib);
    bindFunc(ogg_stream_pageout)("ogg_stream_pageout", lib);
    bindFunc(ogg_stream_flush)("ogg_stream_flush", lib);

    // Ogg BITSTREAM PRIMITIVES: decoding
    bindFunc(ogg_sync_init)("ogg_sync_init", lib);
    bindFunc(ogg_sync_clear)("ogg_sync_clear", lib);
    bindFunc(ogg_sync_reset)("ogg_sync_reset", lib);
    bindFunc(ogg_sync_destroy)("ogg_sync_destroy", lib);
    bindFunc(ogg_sync_buffer)("ogg_sync_buffer", lib);
    bindFunc(ogg_sync_wrote)("ogg_sync_wrote", lib);
    bindFunc(ogg_sync_pageseek)("ogg_sync_pageseek", lib);
    bindFunc(ogg_sync_pageout)("ogg_sync_pageout", lib);
    bindFunc(ogg_stream_pagein)("ogg_stream_pagein", lib);
    bindFunc(ogg_stream_packetout)("ogg_stream_packetout", lib);
    bindFunc(ogg_stream_packetpeek)("ogg_stream_packetpeek", lib);

    // Ogg BITSTREAM PRIMITIVES: general
    bindFunc(ogg_stream_init)("ogg_stream_init", lib);
    bindFunc(ogg_stream_clear)("ogg_stream_clear", lib);
    bindFunc(ogg_stream_reset)("ogg_stream_reset", lib);
    bindFunc(ogg_stream_reset_serialno)("ogg_stream_reset_serialno", lib);
    bindFunc(ogg_stream_destroy)("ogg_stream_destroy", lib);
    bindFunc(ogg_stream_eos)("ogg_stream_eos", lib);
    bindFunc(ogg_page_checksum_set)("ogg_page_checksum_set", lib);
    bindFunc(ogg_page_version)("ogg_page_version", lib);
    bindFunc(ogg_page_continued)("ogg_page_continued", lib);
    bindFunc(ogg_page_bos)("ogg_page_bos", lib);
    bindFunc(ogg_page_eos)("ogg_page_eos", lib);
    bindFunc(ogg_page_granulepos)("ogg_page_granulepos", lib);
    bindFunc(ogg_page_serialno)("ogg_page_serialno", lib);
    bindFunc(ogg_page_pageno)("ogg_page_pageno", lib);
    bindFunc(ogg_page_packets)("ogg_page_packets", lib);

    bindFunc(ogg_packet_clear)("ogg_packet_clear", lib);
}


GenericLoader DerelictOgg;
static this() {
    DerelictOgg.setup(
        "ogg.dll, libogg.dll",
        "libogg.so, libogg.so.0",
        "",
        &loadOgg
    );
}


extern (C):
// Ogg BITSTREAM PRIMITIVES: bitstream
void function(oggpack_buffer *b) oggpack_writeinit;
void function(oggpack_buffer *b, int  bits) oggpack_writetrunc;
void function(oggpack_buffer *b) oggpack_writealign;
void function(oggpack_buffer *b, void *source, int bits) oggpack_writecopy;
void function(oggpack_buffer *b) oggpack_reset;
void function(oggpack_buffer *b) oggpack_writeclear;
void function(oggpack_buffer *b, ubyte *buf, int bytes) oggpack_readinit;
void function(oggpack_buffer *b, uint value, int bits) oggpack_write;
int  function(oggpack_buffer *b, int bits) oggpack_look;
int  function(oggpack_buffer *b) oggpack_look1;
void function(oggpack_buffer *b, int bits) oggpack_adv;
void function(oggpack_buffer *b) oggpack_adv1;
int  function(oggpack_buffer *b, int bits) oggpack_read;
int  function(oggpack_buffer *b) oggpack_read1;
int  function(oggpack_buffer *b) oggpack_bytes;
int  function(oggpack_buffer *b) oggpack_bits;
ubyte *function(oggpack_buffer *b) oggpack_get_buffer;

void function(oggpack_buffer *b) oggpackB_writeinit;
void function(oggpack_buffer *b, int  bits) oggpackB_writetrunc;
void function(oggpack_buffer *b) oggpackB_writealign;
void function(oggpack_buffer *b, void *source, int bits) oggpackB_writecopy;
void function(oggpack_buffer *b) oggpackB_reset;
void function(oggpack_buffer *b) oggpackB_writeclear;
void function(oggpack_buffer *b, ubyte *buf, int bytes) oggpackB_readinit;
void function(oggpack_buffer *b, uint value, int bits) oggpackB_write;
int  function(oggpack_buffer *b, int bits) oggpackB_look;
int  function(oggpack_buffer *b) oggpackB_look1;
void function(oggpack_buffer *b, int bits) oggpackB_adv;
void function(oggpack_buffer *b) oggpackB_adv1;
int  function(oggpack_buffer *b, int bits) oggpackB_read;
int  function(oggpack_buffer *b) oggpackB_read1;
int  function(oggpack_buffer *b) oggpackB_bytes;
int  function(oggpack_buffer *b) oggpackB_bits;
ubyte *function(oggpack_buffer *b) oggpackB_get_buffer;


// Ogg BITSTREAM PRIMITIVES: encoding
int     function(ogg_stream_state *os, ogg_packet *op) ogg_stream_packetin;
int     function(ogg_stream_state *os, ogg_page *og) ogg_stream_pageout;
int     function(ogg_stream_state *os, ogg_page *og) ogg_stream_flush;


// Ogg BITSTREAM PRIMITIVES: decoding
int     function(ogg_sync_state *oy) ogg_sync_init;
int     function(ogg_sync_state *oy) ogg_sync_clear;
int     function(ogg_sync_state *oy) ogg_sync_reset;
int     function(ogg_sync_state *oy) ogg_sync_destroy;
byte*   function(ogg_sync_state *oy, int size) ogg_sync_buffer;
int     function(ogg_sync_state *oy, int bytes) ogg_sync_wrote;
int     function(ogg_sync_state *oy,ogg_page *og) ogg_sync_pageseek;
int     function(ogg_sync_state *oy, ogg_page *og) ogg_sync_pageout;
int     function(ogg_stream_state *os, ogg_page *og) ogg_stream_pagein;
int     function(ogg_stream_state *os,ogg_packet *op) ogg_stream_packetout;
int     function(ogg_stream_state *os,ogg_packet *op) ogg_stream_packetpeek;

// Ogg BITSTREAM PRIMITIVES: general
int     function(ogg_stream_state *os,int serialno) ogg_stream_init;
int     function(ogg_stream_state *os) ogg_stream_clear;
int     function(ogg_stream_state *os) ogg_stream_reset;
int     function(ogg_stream_state *os,int serialno) ogg_stream_reset_serialno;
int     function(ogg_stream_state *os) ogg_stream_destroy;
int     function(ogg_stream_state *os) ogg_stream_eos;
void    function(ogg_page *og) ogg_page_checksum_set;
int     function(ogg_page *og) ogg_page_version;
int     function(ogg_page *og) ogg_page_continued;
int     function(ogg_page *og) ogg_page_bos;
int     function(ogg_page *og) ogg_page_eos;
ogg_int64_t function(ogg_page *og) ogg_page_granulepos;
int     function(ogg_page *og) ogg_page_serialno;
int     function(ogg_page *og) ogg_page_pageno;
int     function(ogg_page *og) ogg_page_packets;
void    function(ogg_packet *op) ogg_packet_clear;