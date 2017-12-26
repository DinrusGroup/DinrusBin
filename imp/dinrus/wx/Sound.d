module wx.Sound;
public import wx.common;

	//---------------------------------------------------------------------------
	// Constants for Sound.Play
	//---------------------------------------------------------------------------
	
	const uint wxSOUND_SYNC = 0U;
	const uint wxSOUND_ASYNC = 1U;
	const uint wxSOUND_LOOP = 2U;

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxSound_ctor();
		static extern (C) IntPtr wxSound_ctor2(string fileName, bool isResource);
		static extern (C) IntPtr wxSound_ctor3(int size, ubyte* data);
		static extern (C) IntPtr wxSound_dtor(IntPtr self);

		static extern (C) bool wxSound_Play(IntPtr self, uint flags);
		static extern (C) void wxSound_Stop(IntPtr self);
		static extern (C) bool wxSound_IsOk(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias Sound wxSound;
	public class Sound : wxObject
	{

		public this();
		public this(string fileName, bool isResource=false);
		public this(ubyte[] data);
		public this(IntPtr wxobj) ;
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor();
		public bool Play(uint flags=wxSOUND_ASYNC);
		public void Stop();
		public bool IsOk();
		static bool Play(string filename, uint flags=wxSOUND_ASYNC);

	}
