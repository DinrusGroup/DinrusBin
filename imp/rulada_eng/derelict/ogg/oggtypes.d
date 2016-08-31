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
module derelict.ogg.oggtypes;

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