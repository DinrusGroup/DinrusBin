module wx.Clipboard;
public import wx.common;
public import wx.DataFormat;
public import wx.DataObject;

		//! \cond EXTERN
		static extern (C) IntPtr wxClipboard_ctor();
		static extern (C) bool   wxClipboard_Open(IntPtr self);
		static extern (C) void   wxClipboard_Close(IntPtr self);
		static extern (C) bool   wxClipboard_IsOpened(IntPtr self);
		static extern (C) bool   wxClipboard_AddData(IntPtr self, IntPtr data);
		static extern (C) bool   wxClipboard_SetData(IntPtr self, IntPtr data);
		static extern (C) bool   wxClipboard_IsSupported(IntPtr self, IntPtr format);
		static extern (C) bool   wxClipboard_GetData(IntPtr self, IntPtr data);
		static extern (C) void   wxClipboard_Clear(IntPtr self);
		static extern (C) bool   wxClipboard_Flush(IntPtr self);
		static extern (C) void   wxClipboard_UsePrimarySelection(IntPtr self, bool primary);
		static extern (C) IntPtr wxClipboard_Get();
		//! \endcond

		//-----------------------------------------------------------------------------

	alias Clipboard wxClipboard;
	public class Clipboard : wxObject
	{
		static Clipboard TheClipboard = null;

		// this crashed in GTK+, since it needs a valid context first
		// so it's called by App in the OnInit() handler now
		static void initialize();
		public this(IntPtr wxobj);
		public  this();
		public bool Open();
		public void Close();
		public bool IsOpened();
		public bool AddData(DataObject data);
		public bool SetData(DataObject data);
		public bool GetData(DataObject data);
		public bool IsSupported(DataFormat format);
		public void Clear();
		public bool Flush();
		public /+virtual+/ void UsePrimarySelection(bool primary);
	}

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxClipboardLocker_ctor(IntPtr clipboard);
		static extern (C) void   wxClipboardLocker_dtor(IntPtr self);
		static extern (C) bool   wxClipboardLocker_IsOpen(IntPtr self);
		//! \endcond

		//-----------------------------------------------------------------------------

	/* re-implement using D */
	public scope class ClipboardLocker // not wxObject
	{
		public this(Clipboard clipboard = null);
		public ~this();

		private Clipboard m_clipboard;
/*
		private IntPtr wxobj;

		public this();
		public this(Clipboard clipboard);
		public ~this();

		//-----------------------------------------------------------------------------

		public bool IsOpen() ;
*/
	}
