
module wx.Validator;
public import wx.common;
public import wx.EvtHandler;

		//! \cond EXTERN
		static extern (C) IntPtr wxValidator_ctor();
		static extern (C) IntPtr wxDefaultValidator_Get();
		//! \endcond
		
		//---------------------------------------------------------------------
		
	alias Validator wxValidator;
	public class Validator : EvtHandler
	{
		static Validator wxDefaultValidator;
		static this();
		public this();
		public this(IntPtr wxobj) ;
	}
