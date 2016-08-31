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
 * * Neither the names 'Derelict', 'DerelictSDLttf', nor the names of its contributors
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
module derelict.sdl.ttf;

private
{
    import derelict.sdl.sdl;
    import derelict.util.loader;
}

private void load(SharedLib lib)
{
    bindFunc(TTF_Linked_Version)("TTF_Linked_Version", lib);
    bindFunc(TTF_ByteSwappedUNICODE)("TTF_ByteSwappedUNICODE", lib);
    bindFunc(TTF_Init)("TTF_Init", lib);
    bindFunc(TTF_OpenFont)("TTF_OpenFont", lib);
    bindFunc(TTF_OpenFontIndex)("TTF_OpenFontIndex", lib);
    bindFunc(TTF_OpenFontRW)("TTF_OpenFontRW", lib);
    bindFunc(TTF_OpenFontIndexRW)("TTF_OpenFontIndexRW", lib);
    bindFunc(TTF_GetFontStyle)("TTF_GetFontStyle", lib);
    bindFunc(TTF_SetFontStyle)("TTF_SetFontStyle", lib);
    bindFunc(TTF_FontHeight)("TTF_FontHeight", lib);
    bindFunc(TTF_FontAscent)("TTF_FontAscent", lib);
    bindFunc(TTF_FontDescent)("TTF_FontDescent", lib);
    bindFunc(TTF_FontLineSkip)("TTF_FontLineSkip", lib);
    bindFunc(TTF_FontFaces)("TTF_FontFaces", lib);
    bindFunc(TTF_FontFaceIsFixedWidth)("TTF_FontFaceIsFixedWidth", lib);
    bindFunc(TTF_FontFaceFamilyName)("TTF_FontFaceFamilyName", lib);
    bindFunc(TTF_FontFaceStyleName)("TTF_FontFaceStyleName", lib);
    bindFunc(TTF_GlyphMetrics)("TTF_GlyphMetrics", lib);
    bindFunc(TTF_SizeText)("TTF_SizeText", lib);
    bindFunc(TTF_SizeUTF8)("TTF_SizeUTF8", lib);
    bindFunc(TTF_SizeUNICODE)("TTF_SizeUNICODE", lib);
    bindFunc(TTF_RenderText_Solid)("TTF_RenderText_Solid", lib);
    bindFunc(TTF_RenderUTF8_Solid)("TTF_RenderUTF8_Solid", lib);
    bindFunc(TTF_RenderUNICODE_Solid)("TTF_RenderUNICODE_Solid", lib);
    bindFunc(TTF_RenderGlyph_Solid)("TTF_RenderGlyph_Solid", lib);
    bindFunc(TTF_RenderText_Shaded)("TTF_RenderText_Shaded", lib);
    bindFunc(TTF_RenderUTF8_Shaded)("TTF_RenderUTF8_Shaded", lib);
    bindFunc(TTF_RenderUNICODE_Shaded)("TTF_RenderUNICODE_Shaded", lib);
    bindFunc(TTF_RenderGlyph_Shaded)("TTF_RenderGlyph_Shaded", lib);
    bindFunc(TTF_RenderText_Blended)("TTF_RenderText_Blended", lib);
    bindFunc(TTF_RenderUTF8_Blended)("TTF_RenderUTF8_Blended", lib);
    bindFunc(TTF_RenderUNICODE_Blended)("TTF_RenderUNICODE_Blended", lib);
    bindFunc(TTF_RenderGlyph_Blended)("TTF_RenderGlyph_Blended", lib);
    bindFunc(TTF_CloseFont)("TTF_CloseFont", lib);
    bindFunc(TTF_Quit)("TTF_Quit", lib);
    bindFunc(TTF_WasInit)("TTF_WasInit", lib);
}


GenericLoader DerelictSDLttf;
static this() {
    DerelictSDLttf.setup(
        "SDL_ttf.dll",
        "libSDL_ttf.so, libSDL_ttf-2.0.so, libSDL_ttf-2.0.so.0",
        "./Frameworks/SDL_ttf.framework/SDL_ttf, /Library/Frameworks/SDL_ttf.framework/SDL_ttf, /System/Library/Frameworks/SDL_ttf.framework/SDL_ttf",
        &load
    );
}

enum : Uint8
{
    SDL_TTF_MAJOR_VERSION = 2,
    SDL_TTF_MINOR_VERSION = 0,
    SDL_TTF_PATCHLEVEL    = 9,
}
alias SDL_TTF_MAJOR_VERSION TTF_MAJOR_VERSION;
alias SDL_TTF_MINOR_VERSION TTF_MINOR_VERSION;
alias SDL_TTF_PATCHLEVEL TTF_PATCHLEVEL;

enum
{
    UNICODE_BOM_NATIVE = 0xFEFF,
    UNICODE_BOM_SWAPPED = 0xFFFE,
    TTF_STYLE_NORMAL = 0x00,
    TTF_STYLE_BOLD = 0x01,
    TTF_STYLE_ITALIC = 0x02,
    TTF_STYLE_UNDERLINE = 0x04,
}

alias SDL_SetError TTF_SetError;
alias SDL_GetError TTF_GetError;

struct _TTF_Font {}
typedef _TTF_Font TTF_Font;

void SDL_TTF_VERSION(SDL_version* X)
{
    X.major = SDL_TTF_MAJOR_VERSION;
    X.minor = SDL_TTF_MINOR_VERSION;
    X.patch = SDL_TTF_PATCHLEVEL;
}

void TTF_VERSION(SDL_version* X) { SDL_TTF_VERSION(X); }

extern (C)
{
    SDL_version* function() TTF_Linked_Version;
    void function(int) TTF_ByteSwappedUNICODE;
    int function() TTF_Init;
    TTF_Font * function (char*, int) TTF_OpenFont;
    TTF_Font * function (char*, int, long ) TTF_OpenFontIndex;
    TTF_Font * function (SDL_RWops*, int, int) TTF_OpenFontRW;
    TTF_Font * function (SDL_RWops*, int, int, long) TTF_OpenFontIndexRW;
    int function (TTF_Font*) TTF_GetFontStyle;
    void function (TTF_Font*, int style) TTF_SetFontStyle;
    int function(TTF_Font*) TTF_FontHeight;
    int function(TTF_Font*) TTF_FontAscent;
    int function(TTF_Font*) TTF_FontDescent;
    int function(TTF_Font*) TTF_FontLineSkip;
    int function(TTF_Font*) TTF_FontFaces;
    int function(TTF_Font*) TTF_FontFaceIsFixedWidth;
    char* function(TTF_Font*) TTF_FontFaceFamilyName;
    char* function(TTF_Font*) TTF_FontFaceStyleName;
    int function (TTF_Font*, Uint16, int*, int*, int*, int*, int*) TTF_GlyphMetrics;
    int function (TTF_Font*, char*, int*, int*) TTF_SizeText;
    int function (TTF_Font*, char*, int*, int*) TTF_SizeUTF8;
    int function (TTF_Font*, Uint16*, int*, int*) TTF_SizeUNICODE;
    SDL_Surface* function (TTF_Font*, char*, SDL_Color) TTF_RenderText_Solid;
    SDL_Surface* function (TTF_Font*, char*, SDL_Color) TTF_RenderUTF8_Solid;
    SDL_Surface* function (TTF_Font*, Uint16*, SDL_Color) TTF_RenderUNICODE_Solid;
    SDL_Surface* function (TTF_Font*, Uint16, SDL_Color) TTF_RenderGlyph_Solid;
    SDL_Surface* function (TTF_Font*, char*, SDL_Color, SDL_Color) TTF_RenderText_Shaded;
    SDL_Surface* function (TTF_Font*, char*, SDL_Color, SDL_Color) TTF_RenderUTF8_Shaded;
    SDL_Surface* function (TTF_Font*, Uint16*, SDL_Color, SDL_Color) TTF_RenderUNICODE_Shaded;
    SDL_Surface* function (TTF_Font*, Uint16, SDL_Color, SDL_Color) TTF_RenderGlyph_Shaded;
    SDL_Surface* function (TTF_Font*, char*, SDL_Color) TTF_RenderText_Blended;
    SDL_Surface* function (TTF_Font*, char*, SDL_Color) TTF_RenderUTF8_Blended;
    SDL_Surface* function (TTF_Font*, Uint16*, SDL_Color) TTF_RenderUNICODE_Blended;
    SDL_Surface* function (TTF_Font*, Uint16, SDL_Color) TTF_RenderGlyph_Blended;
    void function (TTF_Font*) TTF_CloseFont;
    void function () TTF_Quit;
    int function () TTF_WasInit;
}

alias TTF_RenderText_Shaded TTF_RenderText;
alias TTF_RenderUTF8_Shaded TTF_RenderUTF8;
alias TTF_RenderUNICODE_Shaded TTF_RenderUNICODE;