module wx.StaticBoxSizer;
public import wx.common;
public import wx.BoxSizer;
public import wx.StaticBox;

		//! \cond EXTERN
		static extern (C) IntPtr wxStaticBoxSizer_ctor(IntPtr box, int orient);
		static extern (C) IntPtr wxStaticBoxSizer_GetStaticBox(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias StaticBoxSizer wxStaticBoxSizer;
	public class StaticBoxSizer : BoxSizer
	{
		public this(IntPtr wxobj);
		public this(StaticBox box, int orient);
		public this(int orient, Window parent, string label);
		public StaticBox staticBox() ;
	}
