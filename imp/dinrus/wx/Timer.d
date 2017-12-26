module wx.Timer;
public import wx.common;
public import wx.EvtHandler;

	//---------------------------------------------------------------------------
	// Constants for Timer.Play
	//---------------------------------------------------------------------------
	
	/// generate notifications periodically until the timer is stopped (default)
	const bool wxTIMER_CONTINOUS = false;

	/// only send the notification once and then stop the timer
	const bool wxTIMER_ONE_SHOT = true;

	//-----------------------------------------------------------------------------

		extern (C) {
		alias void function (Timer) Virtual_Notify;
		}
		
		//! \cond EXTERN
		static extern (C) IntPtr wxTimer_ctor();
		static extern (C) IntPtr wxTimer_ctor2(IntPtr owner, int id);
		static extern (C) void   wxTimer_RegisterVirtual(IntPtr self, Timer obj, 
			Virtual_Notify notify);
		static extern (C) IntPtr wxTimer_dtor(IntPtr self);

		static extern (C) int wxTimer_GetInterval(IntPtr self);
		static extern (C) bool wxTimer_IsOneShot(IntPtr self);
		static extern (C) bool wxTimer_IsRunning(IntPtr self);
		static extern (C) void wxTimer_BaseNotify(IntPtr self);
		static extern (C) void wxTimer_SetOwner(IntPtr self, IntPtr owner, int id);
		static extern (C) bool wxTimer_Start(IntPtr self, int milliseconds, bool oneShot);
		static extern (C) void wxTimer_Stop(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias Timer wxTimer;
	public class Timer : EvtHandler
	{

		public this();
		public this(EvtHandler owner, int id=-1);
		public this(IntPtr wxobj) ;
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor() ;
		static extern(C) private void staticNotify(Timer obj);
		protected /+virtual+/ void Notify();
		public int Interval();
		public bool IsOneShot();
		public bool IsRunning();
		public void SetOwner(EvtHandler owner, int id=-1);
		public bool Start(int milliseconds=-1, bool oneShot=false);
		public void Stop();

	}
