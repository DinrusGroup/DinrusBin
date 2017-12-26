//-----------------------------------------------------------------------------
// wxD - VidMode.d
// (C) 2005 bero <berobero@users.sourceforge.net>
// based on
// wx.NET - VidMode.cs
//
/// The VideoMode class
//
// Michael S. Muegel mike _at_ muegel dot org
//
// Given this is such a simple structure I did a full port of it's C++ 
// counterpart instead of using a wrapper.
//
// Changes/Additions to C++ version:
//    + ToString() method for simple formatting of display properties
//    + Implemented IComparable to allow for simple sorting of modes
//    + Did not implement IsOK -- maybee I did not understand it but
//      it seems impossible to not be true.
//
// Note that == and the Matches method differ in how they work. == is
// true equality of all properties. Matches implements the wxWidgets
// concept of display equivalence.
//
// VideoMode is immutable: it can not be modified once created, either manually
// via it's constructor or more likely by calling a method in Display.
//
// Licensed under the wxWidgets license, see LICENSE.txt for details.
// $Id: VideoMode.d,v 1.15 2009/04/28 11:11:50 afb Exp $
//-----------------------------------------------------------------------------

module wx.VideoMode;
public import wx.common;


//    [StructLayout(LayoutKind.Sequential)]

        deprecated public VideoMode new_VideoMode(int width, int height, int depth, int freq);

    public struct VideoMode // : IComparable
    {
        /** struct constructor */
        public static VideoMode opCall(int width, int height, int depth, int freq)
        {
            VideoMode v;
            v.w = width;
            v.h = height;
            v.bpp = depth;
            v.refresh = freq;
            return v;
        }

        public bool Matches(VideoMode other);
        public int Width() ;
        public int Height() ;
        public int Depth() ;
        public int RefreshFrequency() ;

		public string toString();	
        private int w, h;
        private int bpp;
        private int refresh;
    }
