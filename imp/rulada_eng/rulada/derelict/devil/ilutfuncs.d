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
module derelict.devil.ilutfuncs;


private
{
    import derelict.devil.iltypes;
    import derelict.devil.iluttypes;
    import derelict.util.loader;
    import derelict.opengl.gltypes;
    
}

package void loadILUT(SharedLib lib)
{
    bindFunc(ilutDisable)("ilutDisable", lib);
    bindFunc(ilutEnable)("ilutEnable", lib);
    bindFunc(ilutGetBoolean)("ilutGetBoolean", lib);
    bindFunc(ilutGetBooleanv)("ilutGetBooleanv", lib);
    bindFunc(ilutGetInteger)("ilutGetInteger", lib);
    bindFunc(ilutGetIntegerv)("ilutGetIntegerv", lib);
    bindFunc(ilutGetString)("ilutGetString", lib);
    bindFunc(ilutInit)("ilutInit", lib);
    bindFunc(ilutIsDisabled)("ilutIsDisabled", lib);
    bindFunc(ilutIsEnabled)("ilutIsEnabled", lib);
    bindFunc(ilutPopAttrib)("ilutPopAttrib", lib);
    bindFunc(ilutPushAttrib)("ilutPushAttrib", lib);
    bindFunc(ilutSetInteger)("ilutSetInteger", lib);
    bindFunc(ilutRenderer)("ilutRenderer", lib);
    bindFunc(ilutGLBindTexImage)("ilutGLBindTexImage", lib);
    bindFunc(ilutGLBindMipmaps)("ilutGLBindMipmaps", lib);
    bindFunc(ilutGLBuildMipmaps)("ilutGLBuildMipmaps", lib);
    bindFunc(ilutGLLoadImage)("ilutGLLoadImage", lib);
    bindFunc(ilutGLScreen)("ilutGLScreen", lib);
    bindFunc(ilutGLScreenie)("ilutGLScreenie", lib);
    bindFunc(ilutGLSaveImage)("ilutGLSaveImage", lib);
    bindFunc(ilutGLSetTex)("ilutGLSetTex", lib);
    bindFunc(ilutGLTexImage)("ilutGLTexImage", lib);
    bindFunc(ilutGLSubTex)("ilutGLSubTex", lib);
    
    version (Windows)
    {
        bindFunc(ilutConvertToHBitmap)("ilutConvertToHBitmap", lib);
        bindFunc(ilutFreePaddedData)("ilutFreePaddedData", lib);
        bindFunc(ilutGetBmpInfo)("ilutGetBmpInfo", lib);
        bindFunc(ilutGetHPal)("ilutGetHPal", lib);
        bindFunc(ilutGetPaddedData)("ilutGetPaddedData", lib);
        bindFunc(ilutGetWinClipboard)("ilutGetWinClipboard", lib);
        bindFunc(ilutLoadResource)("ilutLoadResource", lib);
        bindFunc(ilutSetHBitmap)("ilutSetHBitmap", lib);
        bindFunc(ilutSetHPal)("ilutSetHPal", lib);
        bindFunc(ilutSetWinClipboard)("ilutSetWinClipboard", lib);
        bindFunc(ilutWinLoadImage)("ilutWinLoadImage", lib);
        bindFunc(ilutWinLoadUrl)("ilutWinLoadUrl", lib);
        bindFunc(ilutWinPrint)("ilutWinPrint", lib);
        bindFunc(ilutWinSaveImage)("ilutWinSaveImage", lib);
    }
    
    version(linux)
    {
	   // TODO
    }
}


GenericLoader DerelictILUT;
static this() {
    DerelictILUT.setup(
        "ilut.dll",
        "libILUT.so",
        "",
        &loadILUT
    );
}


extern(System):

ILboolean function(ILenum) ilutDisable;
ILboolean function(ILenum) ilutEnable;
ILboolean function(ILenum) ilutGetBoolean;
ILvoid function(ILenum, ILboolean*) ilutGetBooleanv;
ILint function(ILenum) ilutGetInteger;
ILvoid function(ILenum, ILint*) ilutGetIntegerv;
ILstring function(ILenum) ilutGetString;
ILvoid function() ilutInit;
ILboolean function(ILenum) ilutIsDisabled;
ILboolean function(ILenum) ilutIsEnabled;
ILvoid function() ilutPopAttrib;
ILvoid function(ILuint) ilutPushAttrib;
ILvoid function(ILenum, ILint) ilutSetInteger;
ILboolean function(ILenum) ilutRenderer;
GLuint function() ilutGLBindTexImage;
GLuint function() ilutGLBindMipmaps;
ILboolean function() ilutGLBuildMipmaps;
GLuint function(ILstring FileName) ilutGLLoadImage;
ILboolean function() ilutGLScreen;
ILboolean function() ilutGLScreenie;
ILboolean function(ILstring, GLuint) ilutGLSaveImage;
ILboolean function(GLuint) ilutGLSetTex;
ILboolean function(GLuint) ilutGLTexImage;
ILboolean function(GLuint, ILuint, ILuint) ilutGLSubTex;

// ImageLib Utility Toolkit's Win32 GDI Functions
version(Windows)
{
    version(Tango)
    {
        private import tango.sys.Common;
    }
    else
    {
        private import os.windows;
    }

    extern(Windows):
    
    HBITMAP function(HDC hDC) ilutConvertToHBitmap;
    ILvoid function(ILubyte *Data) ilutFreePaddedData;
    ILvoid function(BITMAPINFO *Info) ilutGetBmpInfo;
    HPALETTE function() ilutGetHPal;
    ILubyte* function() ilutGetPaddedData;
    ILboolean function() ilutGetWinClipboard;
    ILboolean function(HINSTANCE hInst, ILint ID,  ILstring ResourceType, ILenum Type) ilutLoadResource;
    ILboolean function(HBITMAP Bitmap) ilutSetHBitmap;
    ILboolean function(HPALETTE Pal) ilutSetHPal;
    ILboolean function() ilutSetWinClipboard;
    HBITMAP function( ILstring FileName, HDC hDC) ilutWinLoadImage;
    ILboolean function( ILstring Url) ilutWinLoadUrl;
    ILboolean function(ILuint XPos, ILuint YPos, ILuint Width, ILuint Height, HDC hDC) ilutWinPrint;
    ILboolean function( ILstring FileName, HBITMAP Bitmap) ilutWinSaveImage;   
}

version(Linux)
{
	private import derelict.util.xtypes;
	
	// TODO
}
