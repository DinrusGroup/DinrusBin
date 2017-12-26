module wx.Sizer;
public import wx.common;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) void wxSizer_AddWindow(IntPtr self, IntPtr window, int proportion, int flag, int border, IntPtr userData);
		static extern (C) void wxSizer_AddSizer(IntPtr self, IntPtr sizer, int proportion, int flag, int border, IntPtr userData);
		static extern (C) void wxSizer_Add(IntPtr self, int width, int height, int proportion, int flag, int border, IntPtr userData);

		static extern (C) void wxSizer_Fit(IntPtr self, IntPtr window, inout Size size);
		static extern (C) void wxSizer_FitInside(IntPtr self, IntPtr window);
		static extern (C) void wxSizer_Layout(IntPtr self);

		static extern (C) void wxSizer_InsertWindow(IntPtr self, int before, IntPtr window, int option, uint flag, int border, IntPtr userData);
		static extern (C) void wxSizer_InsertSizer(IntPtr self, int before, IntPtr sizer, int option, uint flag, int border, IntPtr userData);
		static extern (C) void wxSizer_Insert(IntPtr self, int before, int width, int height, int option, uint flag, int border, IntPtr userData);

		static extern (C) void wxSizer_PrependWindow(IntPtr self, IntPtr window, int option, uint flag, int border, IntPtr userData);
		static extern (C) void wxSizer_PrependSizer(IntPtr self, IntPtr sizer, int option, uint flag, int border, IntPtr userData);
		static extern (C) void wxSizer_Prepend(IntPtr self, int width, int height, int option, uint flag, int border, IntPtr userData);

		//static extern (C) bool wxSizer_RemoveWindow(IntPtr self, IntPtr window);
		static extern (C) bool wxSizer_RemoveSizer(IntPtr self, IntPtr sizer);
		static extern (C) bool wxSizer_Remove(IntPtr self, int pos);

		static extern (C) void wxSizer_Clear(IntPtr self, bool delete_windows);
		static extern (C) void wxSizer_DeleteWindows(IntPtr self);

		static extern (C) void wxSizer_SetMinSize(IntPtr self, inout Size size);

		static extern (C) bool wxSizer_SetItemMinSizeWindow(IntPtr self, IntPtr window, inout Size size);
		static extern (C) bool wxSizer_SetItemMinSizeSizer(IntPtr self, IntPtr sizer, inout Size size);
		static extern (C) bool wxSizer_SetItemMinSize(IntPtr self, int pos, inout Size size);

		static extern (C) void wxSizer_GetSize(IntPtr self, out Size size);
		static extern (C) void wxSizer_GetPosition(IntPtr self, out Point pt);
		static extern (C) void wxSizer_GetMinSize(IntPtr self, out Size size);

		static extern (C) void wxSizer_RecalcSizes(IntPtr self);
		static extern (C) void wxSizer_CalcMin(IntPtr self, out Size size);

		static extern (C) void wxSizer_SetSizeHints(IntPtr self, IntPtr window);
		static extern (C) void wxSizer_SetVirtualSizeHints(IntPtr self, IntPtr window);
		static extern (C) void wxSizer_SetDimension(IntPtr self, int x, int y, int width, int height);

		static extern (C) void wxSizer_ShowWindow(IntPtr self, IntPtr window, bool show);
		static extern (C) void wxSizer_HideWindow(IntPtr self, IntPtr window);
		static extern (C) void wxSizer_ShowSizer(IntPtr self, IntPtr sizer, bool show);
		static extern (C) void wxSizer_HideSizer(IntPtr self, IntPtr sizer);

		static extern (C) bool wxSizer_IsShownWindow(IntPtr self, IntPtr window);
		static extern (C) bool wxSizer_IsShownSizer(IntPtr self, IntPtr sizer);

		static extern (C) bool wxSizer_DetachWindow(IntPtr self, IntPtr window);
		static extern (C) bool wxSizer_DetachSizer(IntPtr self, IntPtr sizer);
		static extern (C) bool wxSizer_Detach(IntPtr self, int index);
		//! \endcond

		//---------------------------------------------------------------------

	public abstract class Sizer : wxObject
	{
		public this(IntPtr wxobj);
		public void Add(Window window, int proportion=0, int flag=0, int border=0, wxObject userData=null);
		public void Add(Sizer sizer, int proportion=0, int flag=0, int border=0, wxObject userData=null);
		public void Add(int width, int height, int proportion=0, int flag=0, int border=0, wxObject userData=null);
		public void AddSpacer(int size);
		public void AddStretchSpacer(int proportion = 1);
		public Size Fit(Window window);
		public void FitInside(Window window);
		public void Layout();
		public void Insert(uint index, Window window, int proportion=0, int flag=0,
						   int border=0, wxObject userData=null);
		public void Insert(uint index, Sizer sizer, int proportion=0, int flag=0,
						   int border=0, wxObject userData=null);
		public void Insert(uint index, int width, int height, int proportion=0,
						   int flag=0, int border=0, wxObject userData=null);
		public void Prepend(Window window, int proportion=0, int flag=0, int border=0,
							wxObject userData=null);
		public void Prepend(Sizer sizer, int proportion=0, int flag=0, int border=0,
							wxObject userData=null);
		public void Prepend(int width, int height, int proportion=0, int flag=0,
						    int border=0, wxObject userData=null);
		public void PrependSpacer(int size);
		public void PrependStretchSpacer(int proportion = 1);
		//public bool Remove(Window window);
		public bool Remove(Sizer sizer);
		public bool Remove(int pos);
		public void SetMinSize(Size size);
		public bool SetItemMinSize(Window window, Size size);
		public bool SetItemMinSize(Sizer sizer, Size size);
		public bool SetItemMinSize(int pos, Size size);
		public Size size();
		public Point Position();
		public Size MinSize();
		public /+virtual+/ void RecalcSizes();
		public /+virtual+/ Size CalcMin();
		public void SetSizeHints(Window window);
		public void SetVirtualSizeHints(Window window);
		public void SetDimension(int x, int y, int width, int height);
		public void Show(Window window, bool show);
		public void Show(Sizer sizer, bool show);
		public void Show(bool show);
		public void Clear(bool delete_windows);
		public void DeleteWindows();
		public void Hide(Window window);
		public void Hide(Sizer sizer);
		public bool IsShown(Window window);
		public bool IsShown(Sizer sizer);
		public bool Detach(Window window);
		public bool Detach(Sizer sizer);
		public bool Detach(int index);
	}
