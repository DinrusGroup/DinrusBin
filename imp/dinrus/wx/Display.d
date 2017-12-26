module wx.Display;
public import wx.common;

public import wx.VideoMode;
public import wx.Window;

//version(LDC) { pragma(ldc, "verbose") }

		//! \cond EXTERN
		static extern (C) IntPtr wxDisplay_ctor(int index);
		//static extern (C) IntPtr wxDisplay_ctor(inout VideoMode mode);
		static extern (C) int wxDisplay_GetCount();
		static extern (C) int wxDisplay_GetFromPoint(inout Point pt);
		static extern (C) int wxDisplay_GetFromWindow(IntPtr window);
		static extern (C) void wxDisplay_GetGeometry(IntPtr self, out Rectangle rect);
		static extern (C) IntPtr wxDisplay_GetName(IntPtr self);
		static extern (C) bool wxDisplay_IsPrimary(IntPtr self);
		static extern (C) void wxDisplay_GetCurrentMode(IntPtr self, out VideoMode mode);
		static extern (C) bool wxDisplay_ChangeMode(IntPtr self, VideoMode mode);


		static extern (C) int wxDisplay_GetNumModes(IntPtr self, VideoMode mode);
		static extern (C) void wxDisplay_GetModes(IntPtr self, VideoMode mode, inout VideoMode[] modes);

		
		static extern (C) void wxDisplay_ResetMode(IntPtr self);
		static extern (C) void wxDisplay_dtor(IntPtr self);
		//! \endcond

	alias Display wxDisplay;
	public class Display : wxObject
	{
		//------------------------------------------------------------------------

		// Symbolic constant used by all Find()-like functions returning positive
		// integer on success as failure indicator. While this is global in
		// wxWidgets it makes more sense to be in each class that uses it??? 
		// Or maybe move it to Window.cs.
		public const int wxNOT_FOUND = -1;
		
		//------------------------------------------------------------------------
		
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this(int index);
		override protected void dtor() ;
		static int Count() ;
		public static Display[] GetDisplays();
		/+virtual+/ public VideoMode[] GetModes();
		/+virtual+/ public VideoMode[] GetModes(VideoMode mode);
		public static int GetFromPoint(Point pt);
		/+virtual+/ public int GetFromWindow(Window window);
		/+virtual+/ public Rectangle Geometry();
		/+virtual+/ public string Name();
		/+virtual+/ public bool IsPrimary();
		/+virtual+/ public VideoMode CurrentMode();
		/+virtual+/ public bool ChangeMode(VideoMode mode);
		/+virtual+/ public void ResetMode();
	}

