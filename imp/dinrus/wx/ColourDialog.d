module wx.ColourDialog;
public import wx.common;
public import wx.Colour;
public import wx.Dialog;

		//! \cond EXTERN
		static extern (C) IntPtr wxColourData_ctor();

		static extern (C) void   wxColourData_SetChooseFull(IntPtr self, bool flag);
		static extern (C) bool   wxColourData_GetChooseFull(IntPtr self);

		static extern (C) void   wxColourData_SetColour(IntPtr self, IntPtr colour);
		static extern (C) IntPtr wxColourData_GetColour(IntPtr self);

		static extern (C) void   wxColourData_SetCustomColour(IntPtr self, int i, IntPtr colour);
		static extern (C) IntPtr wxColourData_GetCustomColour(IntPtr self, int i);
		//! \endcond

		//---------------------------------------------------------------------
        
	alias ColourData wxColourData;
	public class ColourData : wxObject
	{
		private this(IntPtr wxobj) ;
		public this();
		public bool ChooseFull() ;
		public void ChooseFull(bool value);
		public Colour colour() ;
		public void colour(Colour value) ;
		public Colour GetCustomColour(int i);
		public void SetCustomColour(int i, Colour colour);
		public static wxObject New(IntPtr ptr) ;
	}
	
	//---------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxColourDialog_ctor();
		static extern (C) bool   wxColourDialog_Create(IntPtr self, IntPtr parent, IntPtr data);
		static extern (C) IntPtr wxColourDialog_GetColourData(IntPtr self);
		static extern (C) int    wxColourDialog_ShowModal(IntPtr self);
		
		static extern (C) IntPtr wxColourDialog_GetColourFromUser(IntPtr parent, IntPtr colInit);
		//! \endcond
	
		//---------------------------------------------------------------------
	
	alias ColourDialog wxColourDialog;
	public class ColourDialog : Dialog
	{
		public this(IntPtr wxobj);
		public this();
		public this(Window parent, ColourData data = null);
		public bool Create(Window parent, ColourData data = null);
		public ColourData colourData() ;
		public override int ShowModal();
	}

		public static Colour GetColourFromUser(Window parent=null, Colour colInit=null);
