/// The wxArrayString wrapper class
module wx.ArrayString;
public import wx.common;

		//! \cond EXTERN
		static extern (C) IntPtr wxArrayString_ctor();
		static extern (C) void   wxArrayString_dtor(IntPtr self);
		static extern (C) void   wxArrayString_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void   wxArrayString_Add(IntPtr self, string toadd);
		static extern (C) IntPtr wxArrayString_Item(IntPtr self, int num);
		static extern (C) int    wxArrayString_GetCount(IntPtr self);
		//! \endcond
		
	alias ArrayString wxArrayString;
	public class ArrayString : wxObject
	{
		
		public this(IntPtr wxobj);			
		public this(IntPtr wxobj, bool memOwn);
		public this();
		public string[] toArray();
		public string Item(int num);
		public void Add(string toadd);
		public int Count();
		override protected void dtor() ;
	}
	
