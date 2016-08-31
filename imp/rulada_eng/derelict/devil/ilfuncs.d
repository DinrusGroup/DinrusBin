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
module derelict.devil.ilfuncs;


private
{
    import derelict.devil.iltypes;
    import derelict.util.loader;
}


package void loadIL(SharedLib lib)
{
    bindFunc(ilActiveImage)("ilActiveImage", lib);
    bindFunc(ilActiveLayer)("ilActiveLayer", lib);
    bindFunc(ilActiveMipmap)("ilActiveMipmap", lib);
    bindFunc(ilApplyPal)("ilApplyPal", lib);
    bindFunc(ilApplyProfile)("ilApplyProfile", lib);
    bindFunc(ilBindImage)("ilBindImage", lib);
    bindFunc(ilBlit)("ilBlit", lib);
    bindFunc(ilClearColour)("ilClearColour", lib);
    bindFunc(ilClearImage)("ilClearImage", lib);
    bindFunc(ilCloneCurImage)("ilCloneCurImage", lib);
    bindFunc(ilCompressFunc)("ilCompressFunc", lib);
    bindFunc(ilConvertImage)("ilConvertImage", lib);
    bindFunc(ilConvertPal)("ilConvertPal", lib);
    bindFunc(ilCopyImage)("ilCopyImage", lib);
    bindFunc(ilCopyPixels)("ilCopyPixels", lib);
    bindFunc(ilCreateSubImage)("ilCreateSubImage", lib);
    bindFunc(ilDefaultImage)("ilDefaultImage", lib);
    bindFunc(ilDeleteImage)("ilDeleteImage", lib);
    bindFunc(ilDeleteImages)("ilDeleteImages", lib);
    bindFunc(ilDisable)("ilDisable", lib);
    bindFunc(ilEnable)("ilEnable", lib);
    bindFunc(ilFormatFunc)("ilFormatFunc", lib);
    bindFunc(ilGenImages)("ilGenImages", lib);
    bindFunc(ilGenImage)("ilGenImage", lib);
    bindFunc(ilGetAlpha)("ilGetAlpha", lib);
    bindFunc(ilGetBoolean)("ilGetBoolean", lib);
    bindFunc(ilGetBooleanv)("ilGetBooleanv", lib);
    bindFunc(ilGetData)("ilGetData", lib);
    bindFunc(ilGetDXTCData)("ilGetDXTCData", lib);
    bindFunc(ilGetError)("ilGetError", lib);
    bindFunc(ilGetInteger)("ilGetInteger", lib);
    bindFunc(ilGetIntegerv)("ilGetIntegerv", lib);
    bindFunc(ilGetLumpPos)("ilGetLumpPos", lib);
    bindFunc(ilGetPalette)("ilGetPalette", lib);
    bindFunc(ilGetString)("ilGetString", lib);
    bindFunc(ilHint)("ilHint", lib);
    bindFunc(ilInit)("ilInit", lib);
    bindFunc(ilIsDisabled)("ilIsDisabled", lib);
    bindFunc(ilIsEnabled)("ilIsEnabled", lib);
    bindFunc(ilDetermineTypeF)("ilDetermineTypeF", lib);
    bindFunc(ilIsImage)("ilIsImage", lib);
    bindFunc(ilIsValid)("ilIsValid", lib);
    bindFunc(ilIsValidF)("ilIsValidF", lib);
    bindFunc(ilIsValidL)("ilIsValidL", lib);
    bindFunc(ilKeyColour)("ilKeyColour", lib);
    bindFunc(ilLoad)("ilLoad", lib);
    bindFunc(ilLoadF)("ilLoadF", lib);
    bindFunc(ilLoadImage)("ilLoadImage", lib);
    bindFunc(ilLoadL)("ilLoadL", lib);
    bindFunc(ilLoadPal)("ilLoadPal", lib);
    bindFunc(ilModAlpha)("ilModAlpha", lib);
    bindFunc(ilOriginFunc)("ilOriginFunc", lib);
    bindFunc(ilOverlayImage)("ilOverlayImage", lib);
    bindFunc(ilPopAttrib)("ilPopAttrib", lib);
    bindFunc(ilPushAttrib)("ilPushAttrib", lib);
    bindFunc(ilRegisterFormat)("ilRegisterFormat", lib);
    bindFunc(ilRegisterLoad)("ilRegisterLoad", lib);
    bindFunc(ilRegisterMipNum)("ilRegisterMipNum", lib);
    bindFunc(ilRegisterNumImages)("ilRegisterNumImages", lib);
    bindFunc(ilRegisterOrigin)("ilRegisterOrigin", lib);
    bindFunc(ilRegisterPal)("ilRegisterPal", lib);
    bindFunc(ilRegisterSave)("ilRegisterSave", lib);
    bindFunc(ilRegisterType)("ilRegisterType", lib);
    bindFunc(ilRemoveLoad)("ilRemoveLoad", lib);
    bindFunc(ilRemoveSave)("ilRemoveSave", lib);
    bindFunc(ilResetRead)("ilResetRead", lib);
    bindFunc(ilResetWrite)("ilResetWrite", lib);
    bindFunc(ilSave)("ilSave", lib);
    bindFunc(ilSaveF)("ilSaveF", lib);
    bindFunc(ilSaveImage)("ilSaveImage", lib);
    bindFunc(ilSaveL)("ilSaveL", lib);
    bindFunc(ilSavePal)("ilSavePal", lib);
    bindFunc(ilSetAlpha)("ilSetAlpha", lib);
    bindFunc(ilSetData)("ilSetData", lib);
    bindFunc(ilSetDuration)("ilSetDuration", lib);
    bindFunc(ilSetInteger)("ilSetInteger", lib);
    bindFunc(ilSetMemory)("ilSetMemory", lib);
    bindFunc(ilSetPixels)("ilSetPixels", lib);
    bindFunc(ilSetRead)("ilSetRead", lib);
    bindFunc(ilSetString)("ilSetString", lib);
    bindFunc(ilSetWrite)("ilSetWrite", lib);
    bindFunc(ilShutDown)("ilShutDown", lib);
    bindFunc(ilTexImage)("ilTexImage", lib);
    bindFunc(ilTypeFromExt)("ilTypeFromExt", lib);
    bindFunc(ilTypeFunc)("ilTypeFunc", lib);
    bindFunc(ilLoadData)("ilLoadData", lib);
    bindFunc(ilLoadDataF)("ilLoadDataF", lib);
    bindFunc(ilLoadDataL)("ilLoadDataL", lib);
    bindFunc(ilSaveData)("ilSaveData", lib);
}


GenericLoader DerelictIL;
static this() {
    DerelictIL.setup(
        "devil.dll",
        "libIL.so",
        "",
        &loadIL
    );
}

extern(System):

ILboolean function (ILuint) ilActiveImage;
ILboolean function(ILuint) ilActiveLayer;
ILboolean function(ILuint) ilActiveMipmap;
ILboolean function(in ILstring) ilApplyPal;
ILboolean function(ILstring, ILstring) ilApplyProfile;
ILvoid function(ILuint) ilBindImage;
ILboolean function(ILuint, ILint, ILint, ILint, ILuint, ILuint, ILuint, ILuint, ILuint, ILuint) ilBlit;
ILvoid function(ILclampf, ILclampf, ILclampf, ILclampf) ilClearColour;
ILboolean function() ilClearImage;
ILuint function() ilCloneCurImage;
ILboolean function(ILenum) ilCompressFunc;
ILboolean function(ILenum, ILenum) ilConvertImage;
ILboolean function(ILenum) ilConvertPal;
ILboolean function(ILuint) ilCopyImage;
ILuint function(ILuint, ILuint, ILuint, ILuint, ILuint, ILuint, ILenum, ILenum, ILvoid*) ilCopyPixels;
ILuint function(ILenum, ILuint) ilCreateSubImage;
ILboolean function() ilDefaultImage;
ILvoid function(ILuint) ilDeleteImage;
ILvoid function(ILsizei, in ILuint*) ilDeleteImages;
ILboolean function(ILenum) ilDisable;
ILboolean function(ILenum) ilEnable;
ILboolean function(ILenum) ilFormatFunc;
ILvoid function(ILsizei, ILuint*) ilGenImages;
ILuint function() ilGenImage;
ILubyte* function(ILenum) ilGetAlpha;
ILboolean function(ILenum) ilGetBoolean;
ILvoid function(ILenum, ILboolean*) ilGetBooleanv;
ILubyte* function() ilGetData;
ILuint function(ILvoid*, ILuint, ILenum) ilGetDXTCData;
ILenum function() ilGetError;
ILint function(ILenum) ilGetInteger;
ILvoid function(ILenum, ILint*) ilGetIntegerv;
ILuint function() ilGetLumpPos;
ILubyte* function() ilGetPalette;
ILstring function(ILenum) ilGetString;
ILvoid function(ILenum, ILenum) ilHint;
ILvoid function() ilInit;
ILboolean function(ILenum) ilIsDisabled;
ILboolean function(ILenum) ilIsEnabled;
ILenum function(ILHANDLE) ilDetermineTypeF;
ILboolean function(ILuint) ilIsImage;
ILboolean function(ILenum, ILstring) ilIsValid;
ILboolean function(ILenum, ILHANDLE) ilIsValidF;
ILboolean function(ILenum, ILvoid*, ILuint) ilIsValidL;
ILvoid function(ILclampf, ILclampf, ILclampf, ILclampf) ilKeyColour;
ILboolean function(ILenum, in ILstring) ilLoad;
ILboolean function(ILenum, ILHANDLE) ilLoadF;
ILboolean function(in ILstring) ilLoadImage;
ILboolean function(ILenum, in ILvoid*, ILuint) ilLoadL;
ILboolean function(in ILstring) ilLoadPal;
ILvoid function(ILdouble) ilModAlpha;
ILboolean function(ILenum) ilOriginFunc;
ILboolean function(ILuint, ILint, ILint, ILint) ilOverlayImage;
ILvoid function() ilPopAttrib;
ILvoid function(ILuint) ilPushAttrib;
ILvoid function(ILenum) ilRegisterFormat;
ILboolean function(in ILstring, IL_LOADPROC) ilRegisterLoad;
ILboolean function(ILuint) ilRegisterMipNum;
ILboolean function(ILuint) ilRegisterNumImages;
ILvoid function(ILenum) ilRegisterOrigin;
ILvoid function(ILvoid*, ILuint, ILenum) ilRegisterPal;
ILboolean function(in ILstring, IL_SAVEPROC) ilRegisterSave;
ILvoid function(ILenum) ilRegisterType;
ILboolean function(in ILstring) ilRemoveLoad;
ILboolean function(in ILstring) ilRemoveSave;
ILvoid function() ilResetRead;
ILvoid function() ilResetWrite;
ILboolean function(ILenum, in ILstring) ilSave;
ILuint function(ILenum, ILHANDLE) ilSaveF;
ILboolean function(in ILstring) ilSaveImage;
ILuint function(ILenum, ILvoid*, ILuint) ilSaveL;
ILboolean function(in ILstring) ilSavePal;
ILboolean function(ILdouble) ilSetAlpha;
ILboolean function(ILvoid*) ilSetData;
ILboolean function(ILuint) ilSetDuration;
ILvoid function(ILenum, ILint) ilSetInteger;
ILvoid function(mAlloc, mFree) ilSetMemory;
ILvoid function(ILint, ILint, ILint, ILuint, ILuint, ILuint, ILenum, ILenum, ILvoid*) ilSetPixels;
ILvoid function(fOpenRProc, fCloseRProc, fEofProc, fGetcProc, fReadProc, fSeekRProc, fTellRProc) ilSetRead;
ILvoid function(ILenum, in char*) ilSetString;
ILvoid function(fOpenWProc, fCloseWProc, fPutcProc, fSeekWProc, fTellWProc, fWriteProc) ilSetWrite;
ILvoid function() ilShutDown;
ILboolean function(ILuint, ILuint, ILuint, ILubyte, ILenum, ILenum, ILvoid*) ilTexImage;
ILenum function(in ILstring) ilTypeFromExt;
ILboolean function(ILenum) ilTypeFunc;
ILboolean function(in ILstring, ILuint, ILuint, ILuint, ILubyte) ilLoadData;
ILboolean function(ILHANDLE, ILuint, ILuint, ILuint, ILubyte) ilLoadDataF;
ILboolean function(ILvoid*, ILuint, ILuint, ILuint, ILuint, ILubyte) ilLoadDataL;
ILboolean function(in ILstring) ilSaveData;

alias ilClearColour     ilClearColor;
alias ilKeyColour       ilKeyColor;
