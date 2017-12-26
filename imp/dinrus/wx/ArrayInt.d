/// The wxArrayInt wrapper class
module wx.ArrayInt;
public import wx.common;

		//! \cond EXTERN
		static extern (C) IntPtr wxArrayInt_ctor();
		static extern (C) void   wxArrayInt_dtor(IntPtr self);
		static extern (C) void   wxArrayInt_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void   wxArrayInt_Add(IntPtr self, int toadd);
		static extern (C) int    wxArrayInt_Item(IntPtr self, int num);
		static extern (C) int    wxArrayInt_GetCount(IntPtr self);
		//! \endcond
		
	alias ArrayInt wxArrayInt;
	public class ArrayInt : wxObject
	{
		public this(IntPtr wxobj);			
		public this(IntPtr wxobj, bool memOwn);
		public this();
		public int[] toArray();
		public void Add(int toadd);
		public int Item(int num);
		public int Count() ;
		override protected void dtor();
	}
	
