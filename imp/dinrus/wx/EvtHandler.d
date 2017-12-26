module wx.EvtHandler;
public import wx.common;
public import wx.Event;
public import wx.TaskBarIcon;
private import wx.App;

	alias void delegate(Object sender, Event e) EventListener;

//! \cond VERSION
version(WXD_STYLEDTEXTCTRL)
//! \endcond
public import wx.StyledTextCtrl;
	
	//---------------------------------------------------------------------

	public class SListener
	{
		public EventListener listener;
		public wxObject owner;
		public int eventType;
		public bool active;
		
		public this( EventListener listener, wxObject owner, int eventType );
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		extern (C) {
		alias void function(EvtHandler obj,IntPtr wxEvent, int iListener) EvtMarshalDelegate;
		}

		struct clientdata {
			EvtMarshalDelegate listener;
			wxObject obj;
		};
		
//		extern (C) {
//		alias void function() ObjectDeletedHandler;
//		}
//
//		public ObjectDeletedHandler ObjectDeleted;


		static extern (C) void wxEvtHandler_proxy(IntPtr self, clientdata* data);
		static extern (C) void wxEvtHandler_Connect(IntPtr self, int evtType, int id, int lastId, int iListener);
		
		static extern (C) bool wxEvtHandler_ProcessEvent(IntPtr self, IntPtr evt);
		
		static extern (C) void wxEvtHandler_AddPendingEvent(IntPtr self, IntPtr evt); 
		//! \endcond
		

	alias EvtHandler wxEvtHandler;
	/// A class that can handle events from the windowing system.
	/// wxWindow (and therefore all window classes) are derived from this
	/// class.
	public class EvtHandler : wxObject
	{
		private SListener[] listeners;
		
		clientdata data;
		//---------------------------------------------------------------------
		
		// We store hard references to event handlers, since wxWidgets will
		// clean them up.
		private static EvtHandler[IntPtr] evtHandlers;
		
		//---------------------------------------------------------------------
			
		//---------------------------------------------------------------------

		/*private*/public this(IntPtr wxobj) ;
		~this();
		public void AddCommandListener(int eventType, int id, EventListener listener);
		public void AddCommandListener(int eventType, int id, EventListener listener, wxObject owner);
		public void AddCommandRangeListener(int eventType, int id, int lastId, EventListener listener);
		public void AddCommandRangeListener(int eventType, int id, int lastId, EventListener listener, wxObject owner);
		public void AddEventListener(int eventType, EventListener listener);
		public void AddEventListener(int eventType, EventListener listener, wxObject owner);
		public void AddMenuListener(int id, EventListener listener);
		public void AddMenuListener(int id, EventListener listener, wxObject owner);
		public bool ProcessEvent(Event evt) ;
		public bool RemoveHandler(EventListener listener, wxObject owner);
		public void AddPendingEvent(Event evt);
		static extern (C) private void staticMarshalEvent(EvtHandler obj, IntPtr wxEvent, int iListner);
		private void MarshalEvent(IntPtr wxEvent, int iListener);
		private /*static*/ void OnObjectDeleted(Object sender, Event evt);
		private static void AddEvtHander(EvtHandler eh);
		private static void RemoveEvtHandler(IntPtr ptr);
		public void EVT_SIZE(EventListener lsnr);
		public void EVT_CLOSE(EventListener lsnr);
		public void EVT_PAINT(EventListener lsnr);
		public void EVT_ERASE_BACKGROUND(EventListener lsnr);
		public void EVT_IDLE(EventListener lsnr);
		public void EVT_MOVE(EventListener lsnr);
		public void EVT_SOCKET(EventListener lsnr);
		public void EVT_KILL_FOCUS(EventListener lsnr);
		public void EVT_SET_FOCUS(EventListener lsnr);   ;
		public void EVT_ENTER_WINDOW(EventListener lsnr);
		public void EVT_LEAVE_WINDOW(EventListener lsnr);
		public void EVT_LEFT_DOWN(EventListener lsnr);
		public void EVT_RIGHT_DOWN(EventListener lsnr);
		public void EVT_MIDDLE_DOWN(EventListener lsnr);
		public void EVT_LEFT_DCLICK(EventListener lsnr);
		public void EVT_RIGHT_DCLICK(EventListener lsnr);
		public void EVT_MIDDLE_DCLICK(EventListener lsnr);
		public void EVT_MOUSEWHEEL(EventListener lsnr);
		public void EVT_MOTION(EventListener lsnr);
		public void EVT_LEFT_UP(EventListener lsnr);
		public void EVT_RIGHT_UP(EventListener lsnr);
		public void EVT_MIDDLE_UP(EventListener lsnr);
		public void EVT_UPDATE_UI(int id, EventListener lsnr);
		public void EVT_TIMER(int id, EventListener lsnr);
		public void EVT_MENU(int id, EventListener lsnr);
		public void EVT_MENU_RANGE(int id, int lastId, EventListener lsnr) ;
		public void EVT_BUTTON(int id, EventListener lsnr);
		public void EVT_CHECKBOX(int id, EventListener lsnr);
		public void EVT_LISTBOX(int id, EventListener lsnr);
		public void EVT_LISTBOX_DCLICK(int id, EventListener lsnr);
		public void EVT_CHOICE(int id, EventListener lsnr);
		public void EVT_COMBOBOX(int id, EventListener lsnr);
		public void EVT_TEXT(int id, EventListener lsnr);
		public void EVT_TEXT_ENTER(int id, EventListener lsnr);
		public void EVT_RADIOBOX(int id, EventListener lsnr);
		public void EVT_RADIOBUTTON(int id, EventListener lsnr);
		public void EVT_SLIDER(int id, EventListener lsnr);
		public void EVT_SPINCTRL(int id, EventListener lsnr);
		public void EVT_SPIN_UP(int id, EventListener lsnr);
		public void EVT_SPIN_DOWN(int id, EventListener lsnr);
		public void EVT_SPIN(int id, EventListener lsnr);
		public void EVT_TOGGLEBUTTON(int id, EventListener lsnr);
		public void EVT_KEY_DOWN(EventListener lsnr);
		public void EVT_KEY_UP(EventListener lsnr);
		public void EVT_CHAR(EventListener lsnr);
		public void EVT_CALENDAR_SEL_CHANGED(int id, EventListener lsnr);
		public void EVT_CALENDAR_DAY(int id, EventListener lsnr);
		public void EVT_CALENDAR_MONTH(int id, EventListener lsnr);
		public void EVT_CALENDAR_YEAR(int id, EventListener lsnr);
		public void EVT_CALENDAR_DOUBLECLICKED(int id, EventListener lsnr);
		public void EVT_CALENDAR_WEEKDAY_CLICKED(int id, EventListener lsnr);
		public void EVT_FIND(int id, EventListener lsnr);
		public void EVT_FIND_NEXT(int id, EventListener lsnr);
		public void EVT_FIND_REPLACE(int id, EventListener lsnr);
		public void EVT_FIND_REPLACE_ALL(int id, EventListener lsnr);
		public void EVT_FIND_CLOSE(int id, EventListener lsnr);
		public void EVT_TREE_BEGIN_DRAG(int id, EventListener lsnr);
		public void EVT_TREE_BEGIN_RDRAG(int id, EventListener lsnr);
		public void EVT_TREE_BEGIN_LABEL_EDIT(int id, EventListener lsnr);
		public void EVT_TREE_END_LABEL_EDIT(int id, EventListener lsnr);
		public void EVT_TREE_DELETE_ITEM(int id, EventListener lsnr);
		public void EVT_TREE_GET_INFO(int id, EventListener lsnr);
		public void EVT_TREE_SET_INFO(int id, EventListener lsnr);
		public void EVT_TREE_ITEM_EXPANDED(int id, EventListener lsnr);
		public void EVT_TREE_ITEM_EXPANDING(int id, EventListener lsnr);
		public void EVT_TREE_ITEM_COLLAPSED(int id, EventListener lsnr);
		public void EVT_TREE_ITEM_COLLAPSING(int id, EventListener lsnr);
		public void EVT_TREE_SEL_CHANGED(int id, EventListener lsnr);
		public void EVT_TREE_SEL_CHANGING(int id, EventListener lsnr);
		public void EVT_TREE_KEY_DOWN(int id, EventListener lsnr);
		public void EVT_TREE_ITEM_ACTIVATED(int id, EventListener lsnr);
		public void EVT_TREE_ITEM_RIGHT_CLICK(int id, EventListener lsnr);
		public void EVT_TREE_ITEM_MIDDLE_CLICK(int id, EventListener lsnr);
		public void EVT_TREE_END_DRAG(int id, EventListener lsnr);
		public void EVT_LIST_BEGIN_DRAG(int id, EventListener lsnr);
		public void EVT_LIST_BEGIN_RDRAG(int id, EventListener lsnr);
		public void EVT_LIST_BEGIN_LABEL_EDIT(int id, EventListener lsnr);
		public void EVT_LIST_END_LABEL_EDIT(int id, EventListener lsnr);   
		public void EVT_LIST_DELETE_ITEM(int id, EventListener lsnr);
		public void EVT_LIST_DELETE_ALL_ITEMS(int id, EventListener lsnr);
		public void EVT_LIST_GET_INFO(int id, EventListener lsnr);
		public void EVT_LIST_SET_INFO(int id, EventListener lsnr);
		public void EVT_LIST_ITEM_SELECTED(int id, EventListener lsnr);
		public void EVT_LIST_ITEM_DESELECTED(int id, EventListener lsnr);   
		public void EVT_LIST_ITEM_ACTIVATED(int id, EventListener lsnr);
		public void EVT_LIST_ITEM_FOCUSED(int id, EventListener lsnr);
		public void EVT_LIST_ITEM_MIDDLE_CLICK(int id, EventListener lsnr);
		public void EVT_LIST_ITEM_RIGHT_CLICK(int id, EventListener lsnr);
		public void EVT_LIST_KEY_DOWN(int id, EventListener lsnr);
		public void EVT_LIST_INSERT_ITEM(int id, EventListener lsnr);
		public void EVT_LIST_COL_CLICK(int id, EventListener lsnr);
		public void EVT_LIST_COL_RIGHT_CLICK(int id, EventListener lsnr);
		public void EVT_LIST_COL_BEGIN_DRAG(int id, EventListener lsnr);
		public void EVT_LIST_COL_DRAGGING(int id, EventListener lsnr);
		public void EVT_LIST_COL_END_DRAG(int id, EventListener lsnr);
		public void EVT_LIST_CACHE_HINT(int id, EventListener lsnr);
		public void EVT_NOTEBOOK_PAGE_CHANGED(int id, EventListener lsnr);
		public void EVT_NOTEBOOK_PAGE_CHANGING(int id, EventListener lsnr);
		public void EVT_LISTBOOK_PAGE_CHANGED(int id, EventListener lsnr);
		public void EVT_LISTBOOK_PAGE_CHANGING(int id, EventListener lsnr);
version(__WXMSW__){
		public void EVT_TAB_SEL_CHANGED(int id, EventListener lsnr);
		public void EVT_TAB_SEL_CHANGING(int id, EventListener lsnr);
}	
		public void EVT_GRID_CELL_LEFT_CLICK(EventListener lsnr);
		public void EVT_GRID_CELL_RIGHT_CLICK(EventListener lsnr);
		public void EVT_GRID_CELL_LEFT_DCLICK(EventListener lsnr);
		public void EVT_GRID_CELL_RIGHT_DCLICK(EventListener lsnr);
		public void EVT_GRID_LABEL_LEFT_CLICK(EventListener lsnr);
		public void EVT_GRID_LABEL_RIGHT_CLICK(EventListener lsnr);
		public void EVT_GRID_LABEL_LEFT_DCLICK(EventListener lsnr);
		public void EVT_GRID_LABEL_RIGHT_DCLICK(EventListener lsnr);
		public void EVT_GRID_ROW_SIZE(EventListener lsnr);
		public void EVT_GRID_COL_SIZE(EventListener lsnr);
		public void EVT_GRID_RANGE_SELECT(EventListener lsnr);
		public void EVT_GRID_CELL_CHANGE(EventListener lsnr);
		public void EVT_GRID_SELECT_CELL(EventListener lsnr);
		public void EVT_GRID_EDITOR_SHOWN(EventListener lsnr);
		public void EVT_GRID_EDITOR_HIDDEN(EventListener lsnr);
		public void EVT_GRID_EDITOR_CREATED(EventListener lsnr);
		public void EVT_ACTIVATE(EventListener lsnr);
		public void EVT_DISPLAY_CHANGED(EventListener lsnr);
		public void EVT_SASH_DRAGGED(int id, EventListener lsnr);
		public void EVT_SASH_DRAGGED_RANGE(int id, int lastId, EventListener lsnr);
		public void EVT_QUERY_LAYOUT_INFO(EventListener lsnr);
		public void EVT_CALCULATE_LAYOUT(EventListener lsnr);
		public void EVT_CHECKLISTBOX(int id, EventListener lsnr);
		public void EVT_CONTEXT_MENU(EventListener lsnr);
		public void EVT_SYS_COLOUR_CHANGED(EventListener lsnr);
		public void EVT_QUERY_NEW_PALETTE(EventListener lsnr);
		public void EVT_PALETTE_CHANGED(EventListener lsnr);
		public void EVT_INIT_DIALOG(EventListener lsnr);
		public void EVT_SIZING(EventListener lsnr);
		public void EVT_MOVING(EventListener lsnr);
		public void EVT_HELP(int id, EventListener lsnr);
		public void EVT_DETAILED_HELP(int id, EventListener lsnr);

//! \cond VERSION
version(WXD_STYLEDTEXTCTRL){
//! \endcond

		// StyledTextCtrl specific events
		
		public void EVT_STC_CHANGE(int id, EventListener lsnr) ;
		public void EVT_STC_STYLENEEDED(int id, EventListener lsnr)   ;
		public void EVT_STC_CHARADDED(int id, EventListener lsnr)    ;
		public void EVT_STC_SAVEPOINTREACHED(int id, EventListener lsnr);
		public void EVT_STC_SAVEPOINTLEFT(int id, EventListener lsnr)   ;
		public void EVT_STC_ROMODIFYATTEMPT(int id, EventListener lsnr)   ;		
		public void EVT_STC_KEY(int id, EventListener lsnr)    ;
		public void EVT_STC_DOUBLECLICK(int id, EventListener lsnr)  ;
		public void EVT_STC_UPDATEUI(int id, EventListener lsnr) ;
		public void EVT_STC_MODIFIED(int id, EventListener lsnr)   ;
		public void EVT_STC_MACRORECORD(int id, EventListener lsnr)    ;
		public void EVT_STC_MARGINCLICK(int id, EventListener lsnr)  ;
		public void EVT_STC_NEEDSHOWN(int id, EventListener lsnr) ;
		//public void EVT_STC_POSCHANGED(int id, EventListener lsnr)        
		//	{ AddCommandListener(StyledTextCtrl.wxEVT_STC_POSCHANGED, id, lsnr); }
		public void EVT_STC_PAINTED(int id, EventListener lsnr) ;
		public void EVT_STC_USERLISTSELECTION(int id, EventListener lsnr) ;
		public void EVT_STC_URIDROPPED(int id, EventListener lsnr)    ;
		public void EVT_STC_DWELLSTART(int id, EventListener lsnr) ;
		public void EVT_STC_DWELLEND(int id, EventListener lsnr) ;
		public void EVT_STC_START_DRAG(int id, EventListener lsnr)  ;
		public void EVT_STC_DRAG_OVER(int id, EventListener lsnr)   ;
		public void EVT_STC_DO_DROP(int id, EventListener lsnr)  ;
		public void EVT_STC_ZOOM(int id, EventListener lsnr)   ;
		public void EVT_STC_HOTSPOT_CLICK(int id, EventListener lsnr)  ;
		public void EVT_STC_HOTSPOT_DCLICK(int id, EventListener lsnr)  ;
		public void EVT_STC_CALLTIP_CLICK(int id, EventListener lsnr) ;	
//! \cond VERSION
} // version(WXD_STYLEDTEXTCTRL)
//! \endcond

		public void EVT_TASKBAR_MOVE(EventListener lsnr);
		public void EVT_TASKBAR_LEFT_DOWN(EventListener lsnr);
		public void EVT_TASKBAR_LEFT_UP(EventListener lsnr) ;
		public void EVT_TASKBAR_RIGHT_DOWN(EventListener lsnr) ;
		public void EVT_TASKBAR_RIGHT_UP(EventListener lsnr)   ;
		public void EVT_TASKBAR_LEFT_DCLICK(EventListener lsnr)   ;
		public void EVT_TASKBAR_RIGHT_DCLICK(EventListener lsnr)   ;

		public static wxObject New(IntPtr ptr) ;
	}
