// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.menu;

private import os.win.gui.x.dlib;

private import os.win.gui.x.winapi, os.win.gui.control, os.win.gui.base, os.win.gui.event;
private import os.win.gui.x.utf, os.win.gui.drawing, os.win.gui.application, os.win.gui.collections;


version(DFL_NO_MENUS)
{
}
else
{
	///
	class ContextMenu: Menu // docmain
	{
		///
		final void show(Control control, Point pos);
		
		
		//EventHandler popup;
		Event!(ContextMenu, EventArgs) popup; ///
		
		
		// Used internally.
		this(HMENU hmenu, bool owned = true);
		
		this();
		
		
		~this();
		
		
		protected override void onReflectedMessage(inout Message m);
		
		
		private:
		void _init();
	}


	///
	class MenuItem: Menu // docmain
	{
		///
		final void text(Dstring txt);
		/// ditto
		final Dstring text() ;
		
		
		///
		final void parent(Menu m) ;
		/// ditto
		final Menu parent() ;
		
		package final void _setParent(Menu newParent);
		
		private void _setParent();
		
		package final void _unsetParent();
		
		///
		final void barBreak(bool byes) ;
		
		/// ditto
		final bool barBreak();
		
		// Can't be break().
		
		///
		final void breakItem(bool byes) ;
		
		/// ditto
		final bool breakItem() ;
		
		
		///
		final void checked(bool byes);
		
		/// ditto
		final bool checked() ;
		
		///
		final void defaultItem(bool byes) ;
		
		/// ditto
		final bool defaultItem() ;
		
		///
		final void enabled(bool byes);
		
		/// ditto
		final bool enabled() ;
		
		///
		final void index(int idx);
		
		/// ditto
		final int index() ;
		
		override bool isParent();
		
		deprecated final void mergeOrder(int ord);
		deprecated final int mergeOrder() ;
		
		// TODO: mergeType().
		
		
		///
		// Returns a NUL char if none.
		final char mnemonic() ;		
		/+
		// TODO: implement owner drawn menus.
		
		final void ownerDraw(bool byes);
		
		final bool ownerDraw() ;
		+/
		
		
		///
		final void radioCheck(bool byes) ;
		
		/// ditto
		final bool radioCheck() ;
		
		// TODO: shortcut(), showShortcut().
		
		
		/+
		// TODO: need to fake this ?
		
		final void visible(bool byes) ;
		
		final bool visible();
		+/
		
		
		///
		final void performClick();
		
		///
		final void performSelect();
		
		// Used internally.
		this(HMENU hmenu, bool owned = true) ;
		
		///
		this(MenuItem[] items);
		
		/// ditto
		this(Dstring text);
		/// ditto
		this(Dstring text, MenuItem[] items);
		
		/// ditto
		this();
		
		~this();
		
		
		override Dstring toString();
		
		override Dequ opEquals(Object o);
		
		Dequ opEquals(Dstring val);
		
		override int opCmp(Object o);
		
		int opCmp(Dstring val);
		
		protected override void onReflectedMessage(inout Message m);
				
		
		//EventHandler click;
		Event!(MenuItem, EventArgs) click; ///
		//EventHandler popup;
		Event!(MenuItem, EventArgs) popup; ///
		//EventHandler select;
		Event!(MenuItem, EventArgs) select; ///
		
		
		protected:
		
		///
		final int menuID();
		
		package final int _menuID();
		
		
		///
		void onClick(EventArgs ea);
		
		///
		void onPopup(EventArgs ea);
		
		///
		void onSelect(EventArgs ea);
		
		private:
		
		int mid; // Menu ID.
		Dstring mtext;
		Menu mparent;
		UINT fType = 0; // MFT_*
		UINT fState = 0;
		int mindex = -1; //0;
		//int mergeord = 0;
		
		const Dstring SEPARATOR_TEXT = "-";
		
		static assert(!MFS_UNCHECKED);
		static assert(!MFT_STRING);
		
		
		void _init();
		
		void _type(UINT newType) ;
		
		
		UINT _type() ;
		
		void _state(UINT newState) ;
		
		UINT _state() ;
	}


	///
	abstract class Menu: DObject // docmain
	{
		// Retain DFL 0.9.2 compatibility.
		deprecated static void setDFL092();
		version(SET_DFL_092)
			private const bool _compat092 = true;
		else version(DFL_NO_COMPAT)
			private const bool _compat092 = false;
		else
			private static bool _compat092();
		
		///
		static class MenuItemCollection
		{
			protected this(Menu owner);
			
			package final void _additem(MenuItem mi);
			
			
			// Note: clear() doesn't call this. Update: does now.
			package final void _delitem(int idx);
			
			/+
			void insert(int index, MenuItem mi);
			+/
			
			
			void add(MenuItem mi);
			void add(Dstring value);
			
			void addRange(MenuItem[] items);
			void addRange(Dstring[] items);
			
			// TODO: finish.
			
			
			package:
			
			Menu _owner;
			MenuItem[] items; // Kept populated so the menu can be moved around.
			
			
			void _added(size_t idx, MenuItem val);
			
			void _removing(size_t idx, MenuItem val);
			
			public:
			
			mixin ListWrapArray!(MenuItem, items,
				_blankListCallback!(MenuItem), _added,
				_removing, _blankListCallback!(MenuItem),
				true, false, false,
				true) _wraparray; // CLEAR_EACH
		}
		
		
		// Extra.
		deprecated final void opCatAssign(MenuItem mi);
		
		private void _init();
		
		// Menu item that isn't popup (yet).
		protected this();
		
		// Used internally.
		this(HMENU hmenu, bool owned = true);
		
		
		// Used internally.
		this(HMENU hmenu, MenuItem[] items) ;
		
		
		// Don't call directly.
		this(MenuItem[] items);
		
		~this();
		
		///
		final void tag(Object o) ;
		/// ditto
		final Object tag() ;
		
		///
		final HMENU handle() ;
		
		///
		final MenuItemCollection menuItems();
		
		///
		bool isParent();
		
		///
		protected void onReflectedMessage(inout Message m);
		package final void _reflectMenu(inout Message m);
		
		
		/+ package +/ protected void _setInfo(UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii, Dstring typeData = null) ;		
		/+ package +/ protected void _insert(UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii, Dstring typeData = null);
		
		/+ package +/ protected void _remove(UINT uPosition, UINT uFlags) ;
		
		package HMENU hmenu;
		
		private:
		bool owned = true;
		MenuItemCollection items;
		Object ttag;
	}


	///
	class MainMenu: Menu // docmain
	{
		// Used internally.
		this(HMENU hmenu, bool owned = true);
		
		
		///
		this();
		/// ditto
		this(MenuItem[] items);
		
		
		/+ package +/ protected override void _setInfo(UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii, Dstring typeData = null) ;
		
		/+ package +/ protected override void _insert(UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii, Dstring typeData = null) ;
		
		/+ package +/ protected override void _remove(UINT uPosition, UINT uFlags) ;
		
		private:
		
		HWND hwnd = HWND.init;
		
		
		package final void _setHwnd(HWND hwnd);
	}
}

