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
 * * Neither the names 'Derelict', 'DerelictILUT', nor the names of its contributors
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
module derelict.devil.iluttypes;


private import derelict.devil.iltypes;

enum : ILenum
{
    ILUT_VERSION_1_7_3=1,
    ILUT_VERSION=173,

    // Attribute Bits
    ILUT_OPENGL_BIT=0x00000001,
    ILUT_D3D_BIT=0x00000002,
    ILUT_ALL_ATTRIB_BITS=0x000FFFFF,

    // Error Types
    ILUT_INVALID_ENUM=0x0501,
    ILUT_OUT_OF_MEMORY=0x0502,
    ILUT_INVALID_VALUE=0x0505,
    ILUT_ILLEGAL_OPERATION=0x0506,
    ILUT_INVALID_PARAM=0x0509,
    ILUT_COULD_NOT_OPEN_FILE=0x050A,
    ILUT_STACK_OVERFLOW=0x050E,
    ILUT_STACK_UNDERFLOW=0x050F,
    ILUT_BAD_DIMENSIONS=0x0511,
    ILUT_NOT_SUPPORTED=0x0550,

    // State Definitions
    ILUT_PALETTE_MODE=0x0600,
    ILUT_OPENGL_CONV=0x0610,
    ILUT_D3D_MIPLEVELS=0x0620,
    ILUT_MAXTEX_WIDTH=0x0630,
    ILUT_MAXTEX_HEIGHT=0x0631,
    ILUT_MAXTEX_DEPTH=0x0632,
    ILUT_GL_USE_S3TC=0x0634,
    ILUT_D3D_USE_DXTC=0x0634,
    ILUT_GL_GEN_S3TC=0x0635,
    ILUT_D3D_GEN_DXTC=0x0635,
    ILUT_S3TC_FORMAT=0x0705,
    ILUT_DXTC_FORMAT=0x0705,
    ILUT_D3D_POOL=0x0706,
    ILUT_D3D_ALPHA_KEY_COLOR=0x0707,
    ILUT_D3D_ALPHA_KEY_COLOUR=0x0707,
    ILUT_FORCE_INTEGER_FORMAT=0x0636,
    
    ILUT_GL_AUTODETECT_TEXTURE_TARGET=0x0807,

    // Values
    ILUT_VERSION_NUM=IL_VERSION_NUM,
    ILUT_VENDOR=IL_VENDOR,

    // The different rendering api's...more to be added later?
    ILUT_OPENGL=0,
    ILUT_ALLEGRO=1,
    ILUT_WIN32=2,
    ILUT_DIRECT3D8=3,
    ILUT_DIRECT3D9=4,
    ILUT_X11=5,
}