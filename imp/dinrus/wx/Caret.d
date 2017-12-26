module wx.Caret;
public import wx.common;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxCaret_ctor();
		static extern (C) void wxCaret_dtor(IntPtr self);
		static extern (C) bool wxCaret_Create(IntPtr self, IntPtr window, int width, int height);
		static extern (C) bool wxCaret_IsOk(IntPtr self);
		static extern (C) bool wxCaret_IsVisible(IntPtr self);
		static extern (C) void wxCaret_GetPosition(IntPtr self, out int x, out int y);
		static extern (C) void wxCaret_GetSize(IntPtr self, out int width, out int height);
		static extern (C) IntPtr wxCaret_GetWindow(IntPtr self);
		static extern (C) void wxCaret_SetSize(IntPtr self, int width, int height);
		static extern (C) void wxCaret_Move(IntPtr self, int x, int y);
		static extern (C) void wxCaret_Show(IntPtr self, bool show);
		static extern (C) void wxCaret_Hide(IntPtr self);
		static extern (C) int wxCaret_GetBlinkTime();
		static extern (C) void wxCaret_SetBlinkTime(int milliseconds);
		//! \endcond

		//---------------------------------------------------------------------

	alias Caret wxCaret;
	public class Caret : wxObject
	{
		public this();
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this(Window window, Size size);
		public this(Window window, int width, int height);
		override protected void dtor() ;
		public bool Create(Window window, int width, int height);
		public bool IsOk();
		public bool IsVisible() ;
		public Point Position() ;
		public void Position(Point value) ;
		public Size size() ;
		public void size(Size value) ;
		public Window window() ;
		public void Show(bool show);
		public void Hide();
		static int BlinkTime();
		static void BlinkTime(int value) ;
		public static wxObject New(IntPtr ptr);
	}

		//! \cond EXTERN
		static extern (C) IntPtr wxCaretSuspend_ctor(IntPtr win);
		static extern (C) void wxCaretSuspend_dtor(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias CaretSuspend wxCaretSuspend;
	public class CaretSuspend : wxObject
	{
		public this(Window win);
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor() ;
	}
