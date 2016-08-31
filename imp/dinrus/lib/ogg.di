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
module lib.ogg;
import dinrus;

private
{
    //import stdrus;
}


alias long      ogg_int64_t;
alias int       ogg_int32_t;
alias uint      ogg_uint32_t;
alias short     ogg_int16_t;
alias ushort    ogg_uint16_t;

struct oggpack_buffer
{
    int endbyte;
    int endbit;
    ubyte* buffer;
    ubyte* ptr;
    int storage;
}

struct ogg_page
{
    ubyte *header;
    int  header_len;
    ubyte *_body;       // originally named "body", but that's a keyword in D.
    int  body_len;
}

struct ogg_stream_state
{
    ubyte  *body_data;
    int     body_storage;
    int     body_fill;
    int     body_returned;
    int     *lacing_vals;
    ogg_int64_t *granule_vals;
    int     lacing_storage;
    int     lacing_fill;
    int     lacing_packet;
    int     lacing_returned;
    ubyte   header[282];
    int     header_fill;
    int     e_o_s;
    int     b_o_s;
    int     serialno;
    int     pageno;
    ogg_int64_t  packetno;
    ogg_int64_t   granulepos;
}

struct ogg_packet
{
    ubyte *packet;
    int   bytes;
    int   b_o_s;
    int   e_o_s;
    ogg_int64_t  granulepos;
    ogg_int64_t  packetno;
}

struct ogg_sync_state
{
    ubyte *data;
    int storage;
    int fill;
    int returned;

    int unsynced;
    int headerbytes;
    int bodybytes;
}

private проц грузи(Биб биб)
{
    // Ogg BITSTREAM PRIMITIVES: bitstream
    вяжи(oggpack_writeinit)("oggpack_writeinit", биб);
    вяжи(oggpack_writetrunc)("oggpack_writetrunc", биб);
    вяжи(oggpack_writealign)("oggpack_writealign", биб);
    вяжи(oggpack_writecopy)("oggpack_writecopy", биб);
    вяжи(oggpack_reset)("oggpack_reset", биб);
    вяжи(oggpack_writeclear)("oggpack_writeclear", биб);
    вяжи(oggpack_readinit)("oggpack_readinit", биб);
    вяжи(oggpack_write)("oggpack_write", биб);
    вяжи(oggpack_look)("oggpack_look", биб);
    вяжи(oggpack_look1)("oggpack_look1", биб);
    вяжи(oggpack_adv)("oggpack_adv", биб);
    вяжи(oggpack_adv1)("oggpack_adv1", биб);
    вяжи(oggpack_read)("oggpack_read", биб);
    вяжи(oggpack_read1)("oggpack_read1", биб);
    вяжи(oggpack_bytes)("oggpack_bytes", биб);
    вяжи(oggpack_bits)("oggpack_bits", биб);
    вяжи(oggpack_get_buffer)("oggpack_get_buffer", биб);

    вяжи(oggpackB_writeinit)("oggpackB_writeinit", биб);
    вяжи(oggpackB_writetrunc)("oggpackB_writetrunc", биб);
    вяжи(oggpackB_writealign)("oggpackB_writealign", биб);
    вяжи(oggpackB_writecopy)("oggpackB_writecopy", биб);
    вяжи(oggpackB_reset)("oggpackB_reset", биб);
    вяжи(oggpackB_writeclear)("oggpackB_writeclear", биб);
    вяжи(oggpackB_readinit)("oggpackB_readinit", биб);
    вяжи(oggpackB_write)("oggpackB_write", биб);
    вяжи(oggpackB_look)("oggpackB_look", биб);
    вяжи(oggpackB_look1)("oggpackB_look1", биб);
    вяжи(oggpackB_adv)("oggpackB_adv", биб);
    вяжи(oggpackB_adv1)("oggpackB_adv1", биб);
    вяжи(oggpackB_read)("oggpackB_read", биб);
    вяжи(oggpackB_read1)("oggpackB_read1", биб);
    вяжи(oggpackB_bytes)("oggpackB_bytes", биб);
    вяжи(oggpackB_bits)("oggpackB_bits", биб);
    вяжи(oggpackB_get_buffer)("oggpackB_get_buffer", биб);

    // Ogg BITSTREAM PRIMITIVES: encoding
    вяжи(ogg_stream_packetin)("ogg_stream_packetin", биб);
    вяжи(ogg_stream_pageout)("ogg_stream_pageout", биб);
    вяжи(ogg_stream_flush)("ogg_stream_flush", биб);

    // Ogg BITSTREAM PRIMITIVES: decoding
    вяжи(ogg_sync_init)("ogg_sync_init", биб);
    вяжи(ogg_sync_clear)("ogg_sync_clear", биб);
    вяжи(ogg_sync_reset)("ogg_sync_reset", биб);
    вяжи(ogg_sync_destroy)("ogg_sync_destroy", биб);
    вяжи(ogg_sync_buffer)("ogg_sync_buffer", биб);
    вяжи(ogg_sync_wrote)("ogg_sync_wrote", биб);
    вяжи(ogg_sync_pageseek)("ogg_sync_pageseek", биб);
    вяжи(ogg_sync_pageout)("ogg_sync_pageout", биб);
    вяжи(ogg_stream_pagein)("ogg_stream_pagein", биб);
    вяжи(ogg_stream_packetout)("ogg_stream_packetout", биб);
    вяжи(ogg_stream_packetpeek)("ogg_stream_packetpeek", биб);

    // Ogg BITSTREAM PRIMITIVES: general
    вяжи(ogg_stream_init)("ogg_stream_init", биб);
    вяжи(ogg_stream_clear)("ogg_stream_clear", биб);
    вяжи(ogg_stream_reset)("ogg_stream_reset", биб);
    вяжи(ogg_stream_reset_serialno)("ogg_stream_reset_serialno", биб);
    вяжи(ogg_stream_destroy)("ogg_stream_destroy", биб);
    вяжи(ogg_stream_eos)("ogg_stream_eos", биб);
    вяжи(ogg_page_checksum_set)("ogg_page_checksum_set", биб);
    вяжи(ogg_page_version)("ogg_page_version", биб);
    вяжи(ogg_page_continued)("ogg_page_continued", биб);
    вяжи(ogg_page_bos)("ogg_page_bos", биб);
    вяжи(ogg_page_eos)("ogg_page_eos", биб);
    вяжи(ogg_page_granulepos)("ogg_page_granulepos", биб);
    вяжи(ogg_page_serialno)("ogg_page_serialno", биб);
    вяжи(ogg_page_pageno)("ogg_page_pageno", биб);
    вяжи(ogg_page_packets)("ogg_page_packets", биб);

    вяжи(ogg_packet_clear)("ogg_packet_clear", биб);
}


ЖанБибгр Огг;
static this() {
    Огг.заряжай( "ogg.dll, libogg.dll", &грузи );
	Огг.загружай();
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