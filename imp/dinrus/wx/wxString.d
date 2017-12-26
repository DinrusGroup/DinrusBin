module wx.wxString;
public import wx.common;


		//! \cond EXTERN
		static extern (C) IntPtr  wxString_ctor(string str);
		static extern (C) IntPtr  wxString_ctor2(wxChar* str, size_t len);
		static extern (C) void    wxString_dtor(IntPtr self);
		static extern (C) size_t  wxString_Length(IntPtr self);
		static extern (C) wxChar* wxString_Data(IntPtr self);
		static extern (C) wxChar  wxString_GetChar(IntPtr self, size_t i);
		static extern (C) void    wxString_SetChar(IntPtr self, size_t i, wxChar c);

		static extern (C) size_t  wxString_ansi_len(IntPtr self);
		static extern (C) size_t  wxString_ansi_str(IntPtr self, ubyte *buffer, size_t buflen);
		static extern (C) size_t  wxString_wide_len(IntPtr self);
		static extern (C) size_t  wxString_wide_str(IntPtr self, wchar_t *buffer, size_t buflen);
		static extern (C) size_t  wxString_utf8_len(IntPtr self);
		static extern (C) size_t  wxString_utf8_str(IntPtr self, char *buffer, size_t buflen);
		//! \endcond

		//---------------------------------------------------------------------

	/// wxString is a class representing a character string.
	public class wxString : wxObject
	{
		public this(IntPtr wxobj);
		package this(IntPtr wxobj, bool memOwn);
		public this();
		public this(string str);
		public this(wxChar* wxstr, size_t wxlen);
		override protected void dtor();
		public size_t length() ;
		public wxChar* data() ;
		public wxChar opIndex(size_t i);
		public void opIndexAssign(wxChar c, size_t i) ;
		public string opCast() ;
		public ubyte[] toAnsi();
		public wchar_t[] toWide();
		version (D_Version2)
		{
				public override string toString();
		}
		else // D_Version1
		{
				public string toString();
		}
	}

