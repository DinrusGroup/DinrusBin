//-----------------------------------------------------------------------------
// wxD - DC.d
// (C) 2005 bero <berobero@users.sourceforge.net>
// based on
// wx.NET - DC.cs
//
/// The wxDC wrapper class.
//
// Written by Jason Perkins (jason@379.com)
// (C) 2003 by 379, Inc.
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: DC.d,v 1.10 2007/01/08 23:19:13 afb Exp $
//-----------------------------------------------------------------------------


module wx.DC;
public import wx.common;
public import wx.Window;
public import wx.Pen;
public import wx.Brush;
public import wx.ArrayInt;

		//! \cond EXTERN
		static extern (C) void   wxDC_dtor(IntPtr self);
		static extern (C) void   wxDC_DrawBitmap(IntPtr self, IntPtr bmp, int x, int y, bool transparent);
		static extern (C) void   wxDC_DrawPolygon(IntPtr self, int n, Point* points, int xoffset, int yoffset, int fill_style);
		static extern (C) void   wxDC_DrawLine(IntPtr self, int x1, int y1, int x2, int y2);
		static extern (C) void   wxDC_DrawRectangle(IntPtr self, int x1, int y1, int x2, int y2);
		static extern (C) void   wxDC_DrawText(IntPtr self, string text, int x, int y);
		static extern (C) void   wxDC_DrawEllipse(IntPtr self, int x, int y, int width, int height);
		static extern (C) void   wxDC_DrawPoint(IntPtr self, int x, int y);
		static extern (C) void   wxDC_DrawRoundedRectangle(IntPtr self, int x, int y, int width, int height, double radius);
	
		static extern (C) void   wxDC_SetBackgroundMode(IntPtr self, FillStyle mode);
	
		static extern (C) void   wxDC_SetTextBackground(IntPtr self, IntPtr colour);
		static extern (C) IntPtr wxDC_GetTextBackground(IntPtr self);
	
		static extern (C) void   wxDC_SetBrush(IntPtr self, IntPtr brush);
		static extern (C) IntPtr wxDC_GetBrush(IntPtr self);
	
		static extern (C) void   wxDC_SetBackground(IntPtr self, IntPtr brush);
		static extern (C) IntPtr wxDC_GetBackground(IntPtr self);
	
		static extern (C) void   wxDC_SetPen(IntPtr self, IntPtr pen);
		static extern (C) IntPtr wxDC_GetPen(IntPtr self);
	
		static extern (C) void   wxDC_SetTextForeground(IntPtr self, IntPtr colour);
		static extern (C) IntPtr wxDC_GetTextForeground(IntPtr self);
	
		static extern (C) void   wxDC_SetFont(IntPtr self, IntPtr font);
		static extern (C) IntPtr wxDC_GetFont(IntPtr self);
	
		static extern (C) void   wxDC_GetTextExtent(IntPtr self, string str, out int x, out int y, out int descent, out int externalLeading, IntPtr theFont);
		static extern (C) void   wxDC_Clear(IntPtr self);
	
		static extern (C) void   wxDC_DestroyClippingRegion(IntPtr self);
		static extern (C) void   wxDC_SetClippingRegion(IntPtr self, int x, int y, int width, int height);
		static extern (C) void   wxDC_SetClippingRegionPos(IntPtr self, inout Point pos, inout Size size);
		static extern (C) void   wxDC_SetClippingRegionRect(IntPtr self, inout Rectangle rect);
		static extern (C) void   wxDC_SetClippingRegionReg(IntPtr self, IntPtr reg);
	
		static extern (C) int    wxDC_GetLogicalFunction(IntPtr self);
		static extern (C) void   wxDC_SetLogicalFunction(IntPtr self, int func);
	
		static extern (C) bool   wxDC_BeginDrawing(IntPtr self);
		static extern (C) bool   wxDC_Blit(IntPtr self, int xdest, int ydest, int width, int height, IntPtr source, int xsrc, int ysrc, int rop, bool useMask, int xsrcMask, int ysrcMask);
		static extern (C) void   wxDC_EndDrawing(IntPtr self);
		
		static extern (C) bool   wxDC_FloodFill(IntPtr self, int x, int y, IntPtr col, int style);
		
		static extern (C) bool   wxDC_GetPixel(IntPtr self, int x, int y, IntPtr col);
		
		static extern (C) void   wxDC_CrossHair(IntPtr self, int x, int y);
		
		static extern (C) void   wxDC_DrawArc(IntPtr self, int x1, int y1, int x2, int y2, int xc, int yc);
		
		static extern (C) void   wxDC_DrawCheckMark(IntPtr self, int x, int y, int width, int height);
		
		static extern (C) void   wxDC_DrawEllipticArc(IntPtr self, int x, int y, int w, int h, double sa, double ea);
		
		static extern (C) void   wxDC_DrawLines(IntPtr self, int n, Point* points, int xoffset, int yoffset);
		
		static extern (C) void   wxDC_DrawCircle(IntPtr self, int x, int y, int radius);
		
		static extern (C) void   wxDC_DrawIcon(IntPtr self, IntPtr icon, int x, int y);
		
		static extern (C) void   wxDC_DrawRotatedText(IntPtr self, string text, int x, int y, double angle);
		
		static extern (C) void   wxDC_DrawLabel(IntPtr self, string text, IntPtr image, inout Rectangle rect, int alignment, int indexAccel, inout Rectangle rectBounding);
		static extern (C) void   wxDC_DrawLabel2(IntPtr self, string text, inout Rectangle rect, int alignment, int indexAccel);
		
		static extern (C) void   wxDC_DrawSpline(IntPtr self, int x1, int y1, int x2, int y2, int x3, int y3);
		static extern (C) void   wxDC_DrawSpline2(IntPtr self, int n, Point* points);
		
		static extern (C) bool   wxDC_StartDoc(IntPtr self, string message);
		static extern (C) void   wxDC_EndDoc(IntPtr self);
		static extern (C) void   wxDC_StartPage(IntPtr self);
		static extern (C) void   wxDC_EndPage(IntPtr self);
		
		static extern (C) void   wxDC_GetClippingBox(IntPtr self, out int x, out int y, out int w, out int h);
		static extern (C) void   wxDC_GetClippingBox2(IntPtr self, out Rectangle rect);
		
		static extern (C) void   wxDC_GetMultiLineTextExtent(IntPtr self, string text, out int width, out int height, out int heightline, IntPtr font);
		
		static extern (C) bool   wxDC_GetPartialTextExtents(IntPtr self, string text, IntPtr widths);
		
		static extern (C) void   wxDC_GetSize(IntPtr self, out int width, out int height);
		static extern (C) void   wxDC_GetSize2(IntPtr self, inout Size size);
		static extern (C) void   wxDC_GetSizeMM(IntPtr self, out int width, out int height);
		static extern (C) void   wxDC_GetSizeMM2(IntPtr self, inout Size size);
		
		static extern (C) int    wxDC_DeviceToLogicalX(IntPtr self, int x);
		static extern (C) int    wxDC_DeviceToLogicalY(IntPtr self, int y);
		static extern (C) int    wxDC_DeviceToLogicalXRel(IntPtr self, int x);
		static extern (C) int    wxDC_DeviceToLogicalYRel(IntPtr self, int y);
		static extern (C) int    wxDC_LogicalToDeviceX(IntPtr self, int x);
		static extern (C) int    wxDC_LogicalToDeviceY(IntPtr self, int y);
		static extern (C) int    wxDC_LogicalToDeviceXRel(IntPtr self, int x);
		static extern (C) int    wxDC_LogicalToDeviceYRel(IntPtr self, int y);
		
		static extern (C) bool   wxDC_Ok(IntPtr self);
		
		static extern (C) int    wxDC_GetBackgroundMode(IntPtr self);
		
		static extern (C) int    wxDC_GetMapMode(IntPtr self);
		static extern (C) void   wxDC_SetMapMode(IntPtr self, int mode);
		
		static extern (C) void   wxDC_GetUserScale(IntPtr self, out double x, out double y);
		static extern (C) void   wxDC_SetUserScale(IntPtr self, double x, double y);
		
		static extern (C) void   wxDC_GetLogicalScale(IntPtr self, out double x, out double y);
		static extern (C) void   wxDC_SetLogicalScale(IntPtr self, double x, double y);
		
		static extern (C) void   wxDC_GetLogicalOrigin(IntPtr self, out int x, out int y);
		static extern (C) void   wxDC_GetLogicalOrigin2(IntPtr self, inout Point pt);
		static extern (C) void   wxDC_SetLogicalOrigin(IntPtr self, int x, int y);
		
		static extern (C) void   wxDC_GetDeviceOrigin(IntPtr self, out int x, out int y);
		static extern (C) void   wxDC_GetDeviceOrigin2(IntPtr self, inout Point pt);
		static extern (C) void   wxDC_SetDeviceOrigin(IntPtr self, int x, int y);
		
		static extern (C) void   wxDC_SetAxisOrientation(IntPtr self, bool xLeftRight, bool yBottomUp);
		
		static extern (C) void   wxDC_CalcBoundingBox(IntPtr self, int x, int y);
		static extern (C) void   wxDC_ResetBoundingBox(IntPtr self);
		
		static extern (C) int    wxDC_MinX(IntPtr self);
		static extern (C) int    wxDC_MaxX(IntPtr self);
		static extern (C) int    wxDC_MinY(IntPtr self);
		static extern (C) int    wxDC_MaxY(IntPtr self);
		//! \endcond

	alias DC wxDC;
	public class DC : wxObject
	{
		//---------------------------------------------------------------------

		public this(IntPtr wxobj) ;
		override protected void dtor() ;
		public void BackgroundMode(FillStyle value);
		public FillStyle BackgroundMode() ;
		public void brush(Brush value);
		public Brush brush() ;
		public void Background(Brush value) ;
		public Brush Background() ;
		public void DrawBitmap(Bitmap bmp, int x, int y, bool useMask);
		public void DrawBitmap(Bitmap bmp, int x, int y);
		public void DrawBitmap(Bitmap bmp, Point pt, bool useMask);
		public void DrawBitmap(Bitmap bmp, Point pt);
		public void DrawEllipse(int x, int y, int width, int height);
		public void DrawEllipse(Point pt, Size sz);
		public void DrawEllipse(Rectangle rect);
		public void DrawPoint(int x, int y);
		public void DrawPoint(Point pt);
		public void DrawLine(Point p1, Point p2);
		public void DrawLine(int x1, int y1, int x2, int y2);
		public void DrawPolygon(Point[] points);
		public void DrawPolygon(Point[] points, int xoffset, int yoffset);
		public void DrawPolygon(Point[] points, int xoffset, int yoffset, FillStyle fill_style);
		public void DrawPolygon(int n, Point[] points);
		public void DrawPolygon(int n, Point[] points, int xoffset, int yoffset);
		public void DrawPolygon(int n, Point[] points, int xoffset, int yoffset, FillStyle fill_style);
		public void DrawRectangle(int x1, int y1, int x2, int y2);
		public void DrawRectangle(Point pt, Size sz);
		public void DrawRectangle(Rectangle rect);
		public void DrawText(string text, int x, int y);
		public void DrawText(string text, Point pos);
		public void DrawRoundedRectangle(int x, int y, int width, int height, double radius);
		public void DrawRoundedRectangle(Point pt, Size sz, double radius);
		public void DrawRoundedRectangle(Rectangle r, double radius);
		public void pen(Pen value);
		public Pen pen();
		public Colour TextForeground();
		public void TextForeground(Colour value) ;
		public Colour TextBackground() ;
		public void TextBackground(Colour value) ;
		public Font font() ;
		public void font(Font value);
		public /+virtual+/ void Clear();
		public void GetTextExtent(string str, out int x, out int y);
		public void GetTextExtent(string str, out int x, out int y, out int descent, out int externalLeading, Font theFont);
		public void DestroyClippingRegion();
		public void SetClippingRegion(int x, int y, int width, int height);
		public void SetClippingRegion(Point pos, Size size);
		public void SetClippingRegion(Rectangle rect);
		public void SetClippingRegion(Region reg);
		public Logic LogicalFunction();
		public void LogicalFunction(Logic value);
		public void BeginDrawing();
		public bool Blit(int xdest, int ydest, int width, int height, DC source, int xsrc, int ysrc, int rop, bool useMask, int xsrcMask, int ysrcMask);
		public bool Blit(int xdest, int ydest, int width, int height, DC source);
		public bool Blit(int xdest, int ydest, int width, int height, DC source, int xsrc, int ysrc);		
		public bool Blit(int xdest, int ydest, int width, int height, DC source, int xsrc, int ysrc, int rop);		
		public bool Blit(int xdest, int ydest, int width, int height, DC source, int xsrc, int ysrc, int rop, bool useMask);
		public bool Blit(int xdest, int ydest, int width, int height, DC source, int xsrc, int ysrc, int rop, bool useMask, int xsrcMask);
		public bool Blit(Point destPt, Size sz, DC source, Point srcPt, int rop, bool useMask, Point srcPtMask);
		public bool Blit(Point destPt, Size sz, DC source, Point srcPt);
		public bool Blit(Point destPt, Size sz, DC source, Point srcPt, int rop);
		public bool Blit(Point destPt, Size sz, DC source, Point srcPt, int rop, bool useMask);
		public void EndDrawing();
		public bool FloodFill(int x, int y, Colour col);
		public bool FloodFill(int x, int y, Colour col, int style);
		public bool FloodFill(Point pt, Colour col);
		public bool FloodFill(Point pt, Colour col, int style);
		public bool GetPixel(int x, int y, Colour col);
		public bool GetPixel(Point pt, Colour col);
		public void CrossHair(int x, int y);
		public void CrossHair(Point pt);
		public void DrawArc(int x1, int y1, int x2, int y2, int xc, int yc);
		public void DrawArc(Point pt1, Point pt2, Point centre);
		public void DrawCheckMark(int x, int y, int width, int height);
		public void DrawCheckMark(Rectangle rect);
		public void DrawEllipticArc(int x, int y, int w, int h, double sa, double ea);
		public void DrawEllipticArc(Point pt, Size sz, double sa, double ea);
		public void DrawLines(Point[] points, int xoffset, int yoffset);
		public void DrawLines(Point[] points);
		public void DrawLines(Point[] points, int xoffset);
		public void DrawCircle(int x, int y, int radius);
		public void DrawCircle(Point pt, int radius);
		public void DrawIcon(Icon icon, int x, int y);
		public void DrawIcon(Icon icon, Point pt);
		public void DrawRotatedText(string text, int x, int y, double angle);
		public void DrawRotatedText(string text, Point pt, double angle);
		public /+virtual+/ void DrawLabel(string text, Bitmap image, Rectangle rect, int alignment, int indexAccel, inout Rectangle rectBounding);
		public /+virtual+/ void DrawLabel(string text, Bitmap image, Rectangle rect);
		public /+virtual+/ void DrawLabel(string text, Bitmap image, Rectangle rect, int alignment);
		public /+virtual+/ void DrawLabel(string text, Bitmap image, Rectangle rect, int alignment, int indexAccel);
		public void DrawLabel(string text, Rectangle rect, int alignment, int indexAccel);
		public void DrawLabel(string text, Rectangle rect);
		public void DrawLabel(string text, Rectangle rect, int alignment);
		public void DrawSpline(int x1, int y1, int x2, int y2, int x3, int y3);
		public void DrawSpline(Point[] points);
		public /+virtual+/ bool StartDoc(string message);
		public /+virtual+/ void EndDoc();
		public /+virtual+/ void StartPage();
		public /+virtual+/ void EndPage();
		public void GetClippingBox(out int x, out int y, out int w, out int h);
		public void GetClippingBox(out Rectangle rect);
		public /+virtual+/ void GetMultiLineTextExtent(string text, out int width, out int height, out int heightline, Font font);
		public /+virtual+/ void GetMultiLineTextExtent(string text, out int width, out int height);
		public /+virtual+/ void GetMultiLineTextExtent(string text, out int width, out int height, out int heightline);
		public bool GetPartialTextExtents(string text, int[] widths);
		public void GetSize(out int width, out int height);
		public Size size();
		public void GetSizeMM(out int width, out int height);
		public Size SizeMM() ;
		public int DeviceToLogicalX(int x);
		public int DeviceToLogicalY(int y);
		public int DeviceToLogicalXRel(int x);
		public int DeviceToLogicalYRel(int y);
		public int LogicalToDeviceX(int x);
		public int LogicalToDeviceY(int y);
		public int LogicalToDeviceXRel(int x);
		public int LogicalToDeviceYRel(int y);
		public /+virtual+/ bool Ok();
		public int MapMode();
		public void MapMode(int value);
		public /+virtual+/ void GetUserScale(out double x, out double y);
		public /+virtual+/ void SetUserScale(double x, double y);
		public /+virtual+/ void GetLogicalScale(out double x, out double y);
		public /+virtual+/ void SetLogicalScale(double x, double y);
		public void GetLogicalOrigin(out int x, out int y);
		public Point LogicalOrigin();
		public void SetLogicalOrigin(int x, int y);
		public void GetDeviceOrigin(out int x, out int y);
		public Point DeviceOrigin();
		public void SetDeviceOrigin(int x, int y);
		public void SetAxisOrientation(bool xLeftRight, bool yBottomUp);
		public /+virtual+/ void CalcBoundingBox(int x, int y);
		public void ResetBoundingBox();
		public int MinX();
		public int MaxX() ;
		public int MinY() ;
		public int MaxY() ;
		public static wxObject New(IntPtr ptr) ;
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxWindowDC_ctor();
		static extern (C) IntPtr wxWindowDC_ctor2(IntPtr win);
		static extern (C) bool wxWindowDC_CanDrawBitmap(IntPtr self);
		static extern (C) bool wxWindowDC_CanGetTextExtent(IntPtr self);
		static extern (C) int wxWindowDC_GetCharWidth(IntPtr self);
		static extern (C) int wxWindowDC_GetCharHeight(IntPtr self);
		static extern (C) void wxWindowDC_Clear(IntPtr self);
		static extern (C) void wxWindowDC_SetFont(IntPtr self, IntPtr font);
		static extern (C) void wxWindowDC_SetPen(IntPtr self, IntPtr pen);
		static extern (C) void wxWindowDC_SetBrush(IntPtr self, IntPtr brush);
		static extern (C) void wxWindowDC_SetBackground(IntPtr self, IntPtr brush);
		static extern (C) void wxWindowDC_SetLogicalFunction(IntPtr self, int func);
		static extern (C) void wxWindowDC_SetTextForeground(IntPtr self, IntPtr colour);
		static extern (C) void wxWindowDC_SetTextBackground(IntPtr self, IntPtr colour);
		static extern (C) void wxWindowDC_SetBackgroundMode(IntPtr self, int mode);
		static extern (C) void wxWindowDC_SetPalette(IntPtr self, IntPtr palette);
		static extern (C) void wxWindowDC_GetPPI(IntPtr self, inout Size size);
		static extern (C) int wxWindowDC_GetDepth(IntPtr self);
		//! \endcond
		
		//---------------------------------------------------------------------
	
	alias WindowDC wxWindowDC;
	public class WindowDC : DC
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public this(Window win);
		public bool CanDrawBitmap();
		public bool CanGetTextExtent();
		public int GetCharWidth();
		public int GetCharHeight();
		public int CharHeight() ;
		public int CharWidth() ;
		public override void Clear();
		public void SetFont(Font font);
		public void SetPen(Pen pen);
		public void SetBrush(Brush brush);
		public void SetBackground(Brush brush);
		public void SetLogicalFunction(int func);
		public void SetTextForeground(Colour colour);
		public void SetTextBackground(Colour colour);
		public void SetBackgroundMode(int mode)	;
		public void SetPalette(Palette palette);
		public Size GetPPI();
		public int GetDepth();
	}
	
		//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxClientDC_ctor();
		static extern (C) IntPtr wxClientDC_ctor2(IntPtr window);
		//! \endcond

		//---------------------------------------------------------------------
		
	alias ClientDC wxClientDC;
	public class ClientDC : WindowDC
	{
		public this(IntPtr wxobj) ;
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public this(Window window);
	}
    
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxPaintDC_ctor();
		static extern (C) IntPtr wxPaintDC_ctor2(IntPtr window);
		//! \endcond

		//---------------------------------------------------------------------

	alias PaintDC wxPaintDC;
	public class PaintDC : WindowDC
	{
		public this(IntPtr wxobj) ;
		private this(IntPtr wxobj, bool memOwn);;
		public this(Window window);
	}
