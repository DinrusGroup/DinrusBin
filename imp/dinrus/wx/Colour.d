module wx.Colour;
public import wx.common;




		//! \cond EXTERN
		static extern (C) IntPtr wxColour_ctor();
		static extern (C) IntPtr wxColour_ctorByName(string name);
		static extern (C) IntPtr wxColour_ctorByParts(ubyte red, ubyte green, ubyte blue);
		static extern (C) void   wxColour_dtor(IntPtr self);
		//static extern (C) void   wxColour_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);

		static extern (C) ubyte   wxColour_Red(IntPtr self);
		static extern (C) ubyte   wxColour_Blue(IntPtr self);
		static extern (C) ubyte   wxColour_Green(IntPtr self);

		static extern (C) bool   wxColour_Ok(IntPtr self);
		static extern (C) void   wxColour_Set(IntPtr self, ubyte red, ubyte green, ubyte blue);
		
		static extern (C) IntPtr wxColour_CreateByName(string name);
		//! \endcond

		//---------------------------------------------------------------------

	alias Colour wxColour;
	public class Colour : wxObject
	{
		public static Colour wxBLACK;
		public static Colour wxWHITE;
		public static Colour wxRED;
		public static Colour wxBLUE;
		public static Colour wxGREEN;
		public static Colour wxCYAN;
		public static Colour wxLIGHT_GREY;
		public static Colour wxNullColour;

		//---------------------------------------------------------------------

		public this(IntPtr wxobj);			
		public this(IntPtr wxobj, bool memOwn);
		public this() ;
		public this(string name);
		public this(ubyte red, ubyte green, ubyte blue);
		public override void Dispose();
		public ubyte Red() ;
		public ubyte Green();
		public ubyte Blue();
		public bool Ok();
		public void Set(ubyte red, ubyte green, ubyte blue);
		version(__WXGTK__){
		public static Colour CreateByName(string name);
		} // version(__WXGTK__)

		public static wxObject New(IntPtr ptr) ;
	}
