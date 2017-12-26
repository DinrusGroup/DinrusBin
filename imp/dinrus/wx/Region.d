
module wx.Region;
public import wx.common;
public import wx.GDIObject;
public import wx.Bitmap;
public import wx.Colour;

    public enum RegionContain {
        wxOutRegion = 0,
        wxPartRegion,
        wxInRegion
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxRegion_ctor();
        static extern (C) IntPtr wxRegion_ctorByCoords(int x, int y, int w, int h);
        static extern (C) IntPtr wxRegion_ctorByCorners(inout Point topLeft, inout Point bottomRight);
        static extern (C) IntPtr wxRegion_ctorByRect(inout Rectangle rect);
        static extern (C) IntPtr wxRegion_ctorByPoly(int n, inout Point[] points, int fillStyle);
        static extern (C) IntPtr wxRegion_ctorByBitmap(IntPtr bmp, IntPtr transColour, int tolerance);
        static extern (C) IntPtr wxRegion_ctorByRegion(IntPtr region);

        static extern (C) void   wxRegion_dtor(IntPtr self);

        static extern (C) void   wxRegion_Clear(IntPtr self);
        static extern (C) bool   wxRegion_Offset(IntPtr self, int x, int y);

        static extern (C) bool   wxRegion_Union(IntPtr self, int x, int y, int width, int height);
        static extern (C) bool   wxRegion_UnionRect(IntPtr self, inout Rectangle rect);
        static extern (C) bool   wxRegion_UnionRegion(IntPtr self, IntPtr region);
        static extern (C) bool   wxRegion_UnionBitmap(IntPtr self, IntPtr bmp, IntPtr transColour, int tolerance);

        static extern (C) bool   wxRegion_Intersect(IntPtr self, int x, int y, int width, int height);
        static extern (C) bool   wxRegion_IntersectRect(IntPtr self, inout Rectangle rect);
        static extern (C) bool   wxRegion_IntersectRegion(IntPtr self, IntPtr region);

        static extern (C) bool   wxRegion_Subtract(IntPtr self, int x, int y, int width, int height);
        static extern (C) bool   wxRegion_SubtractRect(IntPtr self, inout Rectangle rect);
        static extern (C) bool   wxRegion_SubtractRegion(IntPtr self, IntPtr region);

        static extern (C) bool   wxRegion_Xor(IntPtr self, int x, int y, int width, int height);
        static extern (C) bool   wxRegion_XorRect(IntPtr self, inout Rectangle rect);
        static extern (C) bool   wxRegion_XorRegion(IntPtr self, IntPtr region);

        static extern (C) RegionContain wxRegion_ContainsCoords(IntPtr self, int x, int y);
        static extern (C) RegionContain wxRegion_ContainsPoint(IntPtr self, inout Point pt);
        static extern (C) RegionContain wxRegion_ContainsRectCoords(IntPtr self, int x, int y, int width, int height);
        static extern (C) RegionContain wxRegion_ContainsRect(IntPtr self, inout Rectangle rect);

        static extern (C) void   wxRegion_GetBox(IntPtr self, inout Rectangle rect);
        static extern (C) bool   wxRegion_IsEmpty(IntPtr self);
        static extern (C) IntPtr wxRegion_ConvertToBitmap(IntPtr self);
		//! \endcond

        //---------------------------------------------------------------------

    alias Region wxRegion;
    public class Region : GDIObject
    {

        public this(IntPtr wxobj);
        public this();
        public this(int x, int y, int w, int h);
        public this(Point topLeft, Point bottomRight);
        public this(Rectangle rect);
        version(__WXMAC__) {} else
        public this(Point[] points, int fillStyle);
        public this(Bitmap bmp, Colour transColour, int tolerance);
        public this(Region reg);
        public void Clear();
        version(__WXMAC__) {} else
        public bool Offset(int x, int y);
        public bool Union(int x, int y, int width, int height) ;
        public bool Union(Rectangle rect);
        public bool Union(Region reg);
        public bool Union(Bitmap bmp, Colour transColour, int tolerance);
        public bool Intersect(int x, int y, int width, int height);
        public bool Intersect(Rectangle rect);
        public bool Intersect(Region region);
        public bool Subtract(int x, int y, int width, int height);
        public bool Subtract(Rectangle rect);
        public bool Subtract(Region region);
        public bool Xor(int x, int y, int width, int height);
        public bool Xor(Rectangle rect);
        public bool Xor(Region region);
        public RegionContain Contains(int x, int y);
        public RegionContain Contains(Point pt);
        public RegionContain Contains(int x, int y, int width, int height);
        public RegionContain Contains(Rectangle rect);
        public Rectangle GetBox();
        public bool IsEmpty() ;
        public Bitmap ConvertToBitmap();
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxRegionIterator_ctor();
        static extern (C) IntPtr wxRegionIterator_ctorByRegion(IntPtr region);

        static extern (C) void   wxRegionIterator_Reset(IntPtr self);
        static extern (C) void   wxRegionIterator_ResetToRegion(IntPtr self, IntPtr region);

        static extern (C) bool   wxRegionIterator_HaveRects(IntPtr self);
        
        static extern (C) int    wxRegionIterator_GetX(IntPtr self);
        static extern (C) int    wxRegionIterator_GetY(IntPtr self);

        static extern (C) int    wxRegionIterator_GetW(IntPtr self);
        static extern (C) int    wxRegionIterator_GetWidth(IntPtr self);
        static extern (C) int    wxRegionIterator_GetH(IntPtr self);
        static extern (C) int    wxRegionIterator_GetHeight(IntPtr self);

        static extern (C) void   wxRegionIterator_GetRect(IntPtr self, inout Rectangle rect);
		//! \endcond

        //---------------------------------------------------------------------

    alias RegionIterator wxRegionIterator;
    public class RegionIterator : wxObject
    {
        public this(IntPtr wxobj) ;
        public this();
        public this(Region reg);
        public void Reset();
        public void ResetToRegion(Region region);
        public bool HaveRects();
        public int X() ;
        public int Y() ;
        public int Width();
        public int Height() ;
        public Rectangle Rect() ;
    }
