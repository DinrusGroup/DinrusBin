module wx.ClientData;
public import wx.common;

		//! \cond EXTERN
		static extern (C) IntPtr wxClientData_ctor();
		static extern (C) void wxClientData_dtor(IntPtr self);
		static extern (C) void wxClientData_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		//! \endcond
		
		//---------------------------------------------------------------------
        
	alias ClientData wxClientData;
	public class ClientData : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		override protected void dtor();
		static wxObject New(IntPtr ptr) ;
	}
    
	//---------------------------------------------------------------------
    
		//! \cond EXTERN
		static extern (C) IntPtr wxStringClientData_ctor(string data);
		static extern (C) void   wxStringClientData_dtor(IntPtr self);
		static extern (C) void   wxStringClientData_SetData(IntPtr self, string data);
		static extern (C) IntPtr wxStringClientData_GetData(IntPtr self);
		//! \endcond
		
		//---------------------------------------------------------------------
        
	alias StringClientData wxStringClientData;
	public class StringClientData : ClientData
	{
		public this();
		public this(string data);
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor();
		public string Data() ;
		public void Data(string value) ;
	}

