module wx.wxObject;
public import wx.common;

//! \cond STD
version (Tango)
import tango.core.Version;
//! \endcond

		//! \cond EXTERN
		extern (C) {
		alias void function(IntPtr ptr) Virtual_Dispose;
		}
	
		static extern (C) IntPtr wxObject_GetTypeName(IntPtr obj);
		static extern (C) void   wxObject_dtor(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------
		// this is for Locale gettext support...
		
		//! \cond EXTERN
		static extern (C) IntPtr wxGetTranslation_func(string str);
		//! \endcond
		
		public static string GetTranslation(string str);
		public static string _(string str);
		//---------------------------------------------------------------------
/+
	template findObject(class T)
	T find(IntPtr ptr){
		Object o = wxObject.FindObject(ptr);
		if (o) return cast(T)o;
		else new T(ptr);
	}
+/
	/// This is the root class of all wxWidgets classes.
	/// It declares a virtual destructor which ensures that destructors get
	/// called for all derived class objects where necessary.
	/**
	  * wxObject is the hub of a dynamic object creation scheme, enabling a
	  * program to create instances of a class only knowing its string class
	  * name, and to query the class hierarchy.
	  **/
	public class wxObject : IDisposable
	{
		public IntPtr wxobj = IntPtr.init;

		private static wxObject[IntPtr] objects;
		
		protected bool memOwn = false;

		public this(IntPtr wxobj);
		private this(IntPtr wxobj,bool memOwn);
		public static IntPtr SafePtr(wxObject obj);
		private static string GetTypeName(IntPtr wxobj);
		public string GetTypeName();
		private static void AddObject(wxObject obj);

		alias static wxObject function(IntPtr wxobj) newfunc;

		public static wxObject FindObject(IntPtr ptr, newfunc New);
		public static wxObject FindObject(IntPtr ptr);
		public static bool RemoveObject(IntPtr ptr);
		static extern(C) private void VirtualDispose(IntPtr ptr);
		private void realVirtualDispose();
		protected void dtor() ;
		public /+virtual+/ void Dispose();		
		~this();
		protected bool disposed() ;
	}

