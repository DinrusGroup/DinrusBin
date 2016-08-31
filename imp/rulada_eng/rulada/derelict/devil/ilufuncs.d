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
 * * Neither the names 'Derelict', 'DerelictILU', nor the names of its contributors
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
module derelict.devil.ilufuncs;


private
{
    import derelict.devil.iltypes;
    import derelict.devil.ilutypes;
    import derelict.util.loader;
}


package void loadILU(SharedLib lib)
{
    bindFunc(iluAlienify)("iluAlienify", lib);
    bindFunc(iluBlurAvg)("iluBlurAvg", lib);
    bindFunc(iluBlurGaussian)("iluBlurGaussian", lib);
    bindFunc(iluBuildMipmaps)("iluBuildMipmaps", lib);
    bindFunc(iluColoursUsed)("iluColoursUsed", lib);
    bindFunc(iluCompareImage)("iluCompareImage", lib);
    bindFunc(iluContrast)("iluContrast", lib);
    bindFunc(iluCrop)("iluCrop", lib);
    bindFunc(iluDeleteImage)("iluDeleteImage", lib);
    bindFunc(iluEdgeDetectE)("iluEdgeDetectE", lib);
    bindFunc(iluEdgeDetectP)("iluEdgeDetectP", lib);
    bindFunc(iluEdgeDetectS)("iluEdgeDetectS", lib);
    bindFunc(iluEmboss)("iluEmboss", lib);
    bindFunc(iluEnlargeCanvas)("iluEnlargeCanvas", lib);
    bindFunc(iluEnlargeImage)("iluEnlargeImage", lib);
    bindFunc(iluEqualize)("iluEqualize", lib);
    bindFunc(iluErrorString)("iluErrorString", lib);
    bindFunc(iluConvolution)("iluConvolution", lib);
    bindFunc(iluFlipImage)("iluFlipImage", lib);
    bindFunc(iluGammaCorrect)("iluGammaCorrect", lib);
    bindFunc(iluGenImage)("iluGenImage", lib);
    bindFunc(iluGetImageInfo)("iluGetImageInfo", lib);
    bindFunc(iluGetInteger)("iluGetInteger", lib);
    bindFunc(iluGetIntegerv)("iluGetIntegerv", lib);
    bindFunc(iluGetString)("iluGetString", lib);
    bindFunc(iluImageParameter)("iluImageParameter", lib);
    bindFunc(iluInit)("iluInit", lib);
    bindFunc(iluInvertAlpha)("iluInvertAlpha", lib);
    bindFunc(iluLoadImage)("iluLoadImage", lib);
    bindFunc(iluMirror)("iluMirror", lib);
    bindFunc(iluNegative)("iluNegative", lib);
    bindFunc(iluNoisify)("iluNoisify", lib);
    bindFunc(iluPixelize)("iluPixelize", lib);
    bindFunc(iluRegionfv)("iluRegionfv", lib);
    bindFunc(iluRegioniv)("iluRegioniv", lib);
    bindFunc(iluReplaceColour)("iluReplaceColour", lib);
    bindFunc(iluRotate)("iluRotate", lib);
    bindFunc(iluRotate3D)("iluRotate3D", lib);
    bindFunc(iluSaturate1f)("iluSaturate1f", lib);
    bindFunc(iluSaturate4f)("iluSaturate4f", lib);
    bindFunc(iluScale)("iluScale", lib);
    bindFunc(iluScaleColours)("iluScaleColours", lib);
    bindFunc(iluSetLanguage)("iluSetLanguage", lib);
    bindFunc(iluSharpen)("iluSharpen", lib);
    bindFunc(iluSwapColours)("iluSwapColours", lib);
    bindFunc(iluWave)("iluWave", lib);
}


GenericLoader DerelictILU;
static this() {
    DerelictILU.setup(
        "ilu.dll",
        "libILU.so",
        "",
        &loadILU
    );
}

extern(System):

ILboolean function() iluAlienify;
ILboolean function(ILuint Iter) iluBlurAvg;
ILboolean function(ILuint Iter) iluBlurGaussian;
ILboolean function() iluBuildMipmaps;
ILuint function() iluColoursUsed;
ILboolean function(ILuint Comp) iluCompareImage;
ILboolean function(ILfloat Contrast) iluContrast;
ILboolean function(ILuint XOff, ILuint YOff, ILuint ZOff, ILuint Width, ILuint Height, ILuint Depth) iluCrop;
ILvoid function(ILuint Id) iluDeleteImage;
ILboolean function() iluEdgeDetectE;
ILboolean function() iluEdgeDetectP;
ILboolean function() iluEdgeDetectS;
ILboolean function() iluEmboss;
ILboolean function(ILuint Width, ILuint Height, ILuint Depth) iluEnlargeCanvas;
ILboolean function(ILfloat XDim, ILfloat YDim, ILfloat ZDim) iluEnlargeImage;
ILboolean function() iluEqualize;
ILstring function(ILenum Error) iluErrorString;
ILboolean function(ILint*, ILint, ILint) iluConvolution;
ILboolean function() iluFlipImage;
ILboolean function(ILfloat Gamma) iluGammaCorrect;
ILuint function() iluGenImage;
ILvoid function(ILinfo *Info) iluGetImageInfo;
ILint function(ILenum Mode) iluGetInteger;
ILvoid function(ILenum Mode, ILint *Param) iluGetIntegerv;
ILstring function(ILenum StringName) iluGetString;
ILvoid function(ILenum PName, ILenum Param) iluImageParameter;
ILvoid function() iluInit;
ILboolean function() iluInvertAlpha;
ILuint function( ILstring FileName) iluLoadImage;
ILboolean function() iluMirror;
ILboolean function() iluNegative;
ILboolean function(ILclampf Tolerance) iluNoisify;
ILboolean function(ILuint PixSize) iluPixelize;
ILvoid function(ILpointf *Points, ILuint n) iluRegionfv;
ILvoid function(ILpointi *Points, ILuint n) iluRegioniv;
ILboolean function(ILubyte Red, ILubyte Green, ILubyte Blue, ILfloat Tolerance) iluReplaceColour;
ILboolean function(ILfloat Angle) iluRotate;
ILboolean function(ILfloat x, ILfloat y, ILfloat z, ILfloat Angle) iluRotate3D;
ILboolean function(ILfloat Saturation) iluSaturate1f;
ILboolean function(ILfloat r, ILfloat g, ILfloat b, ILfloat Saturation) iluSaturate4f;
ILboolean function(ILuint Width, ILuint Height, ILuint Depth) iluScale;
ILboolean function(ILfloat r, ILfloat g, ILfloat b) iluScaleColours;
ILboolean function(ILenum) iluSetLanguage;
ILboolean function(ILfloat Factor, ILuint Iter) iluSharpen;
ILboolean function() iluSwapColours;
ILboolean function(ILfloat Angle) iluWave;

alias iluColoursUsed    iluColorsUsed;
alias iluSwapColours    iluSwapColors;
alias iluReplaceColour  iluReplaceColor;
alias iluScaleColours  iluScaleColors;