module wx.DND;
public import wx.common;
public import wx.DataObject;
public import wx.Window;

	public enum Drag
	{
		wxDrag_CopyOnly    = 0,
		wxDrag_AllowMove   = 1,
		wxDrag_DefaultMove = 3
	}
	
	//---------------------------------------------------------------------

	public enum DragResult
	{
    		wxDragError,
    		wxDragNone,
    		wxDragCopy,
    		wxDragMove,
    		wxDragLink,
    		wxDragCancel
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		extern (C) {
		alias int function(DropSource obj, int flags) Virtual_DoDragDrop;
		}

		static extern (C) IntPtr wxDropSource_Win_ctor(IntPtr win);
		static extern (C) IntPtr wxDropSource_DataObject_ctor(IntPtr dataObject, IntPtr win);
		static extern (C) void wxDropSource_dtor(IntPtr self);
		static extern (C) void wxDropSource_RegisterVirtual(IntPtr self, DropSource obj, Virtual_DoDragDrop doDragDrop);
		static extern (C) int wxDropSource_DoDragDrop(IntPtr self, int flags);
		static extern (C) void wxDropSource_SetData(IntPtr self, IntPtr dataObject);
		//! \endcond
		
		//---------------------------------------------------------------------

	alias DropSource wxDropSource;
	public class DropSource : wxObject
	{
		protected DataObject m_dataObject = null;
		
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this(Window win = null);
		public this(DataObject dataObject, Window win = null);
		override protected void dtor() ;
		static extern (C) private int staticDoDoDragDrop(DropSource obj,int flags);
		public /+virtual+/ DragResult DoDragDrop(int flags);
		public DataObject dataObject();
		public void dataObject(DataObject value) ;
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		extern (C) {
		alias int  function(DropTarget obj, int x, int y, int def) Virtual_OnDragOver;
		alias bool function(DropTarget obj, int x, int y) Virtual_OnDrop;
		alias int  function(DropTarget obj, int x, int y, int def) Virtual_OnData3;
		alias bool function(DropTarget obj) Virtual_GetData;
		alias void function(DropTarget obj) Virtual_OnLeave;
		alias int  function(DropTarget obj, int x, int y, int def) Virtual_OnEnter;
		}
		//! \endcond
		
		//---------------------------------------------------------------------
		
		//! \cond EXTERN
		static extern (C) IntPtr wxDropTarget_ctor(IntPtr dataObject);
		static extern (C) void wxDropTarget_dtor(IntPtr self);
		static extern (C) void wxDropTarget_RegisterVirtual(IntPtr self, DropTarget obj, Virtual_OnDragOver onDragOver, Virtual_OnDrop onDrop, Virtual_OnData3 onData, Virtual_GetData getData, Virtual_OnLeave onLeave, Virtual_OnEnter onEnter);  
		static extern (C) void   wxDropTarget_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void   wxDropTarget_SetDataObject(IntPtr self, IntPtr dataObject);
		static extern (C) int wxDropTarget_OnEnter(IntPtr self, int x, int y, int def);
		static extern (C) int wxDropTarget_OnDragOver(IntPtr self, int x, int y, int def);
		static extern (C) void   wxDropTarget_OnLeave(IntPtr self);
		static extern (C) bool wxDropTarget_OnDrop(IntPtr self, int x, int y);
		static extern (C) bool wxDropTarget_GetData(IntPtr self);
		//! \endcond
		
		//---------------------------------------------------------------------

	public abstract class DropTarget : wxObject
	{
		protected DataObject m_dataObject = null;
		
		public this(DataObject dataObject = null);
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor() ;
		static extern (C) private int staticDoOnDragOver(DropTarget obj, int x, int y, int def);
		public /+virtual+/ DragResult OnDragOver(int x, int y, DragResult def);
		static extern (C) private bool staticOnDrop(DropTarget obj, int x, int y);
		public /+virtual+/ bool OnDrop(int x, int y);
		static extern (C) private int staticDoOnData(DropTarget obj, int x, int y, int def);
		public abstract DragResult OnData(int x, int y, DragResult def);
		static extern (C) private bool staticGetData(DropTarget obj);
		public /+virtual+/ bool GetData();
		static extern (C) private int staticDoOnEnter(DropTarget obj, int x, int y, int def);
		public /+virtual+/ DragResult OnEnter(int x, int y, DragResult def);
		static extern (C) private void staticOnLeave(DropTarget obj);
		public /+virtual+/ void OnLeave();
		public DataObject dataObject() ;
		public void dataObject(DataObject value);

	//	public static wxObject New(IntPtr ptr);
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) bool wxTextDropTarget_OnDrop(IntPtr self, int x, int y);
		static extern (C) bool wxTextDropTarget_GetData(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	public abstract class TextDropTarget : DropTarget
	{
		public this();
		public abstract bool OnDropText(int x, int y, string text);
		public override DragResult OnData(int x, int y, DragResult def);
		public override bool OnDrop(int x, int y);
		public override bool GetData();
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) bool wxFileDropTarget_OnDrop(IntPtr self, int x, int y);
		static extern (C) bool wxFileDropTarget_GetData(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	public abstract class FileDropTarget : DropTarget
	{
		public this();
		public abstract bool OnDropFiles(int x, int y, string[] filenames);
		public override DragResult OnData(int x, int y, DragResult def);
		public override bool OnDrop(int x, int y);
		public override bool GetData();
	}

