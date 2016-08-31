// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.resources;

private import os.win.gui.x.dlib;

private import os.win.gui.x.utf, os.win.gui.x.winapi, os.win.gui.base, os.win.gui.drawing;


version(DFL_NO_RESOURCES)
{
}
else
{
	///
	class Resources // docmain
	{
		///
		this(HINSTANCE inst, WORD language = 0, bool owned = false);
		
		/// ditto
		// Note: libName gets unloaded and may take down all its resources with it.
		this(Dstring libName, WORD language = 0);
		
		/+ // Let's not depend on Application; the user can do so if they wish.
		/// ditto
		this(WORD language = 0);
		+/
		
		
		///
		void dispose();
		
		///
		final WORD language() ;
		
		///
		final Icon getIcon(int id, bool defaultSize = true);
		
		/// ditto
		final Icon getIcon(Dstring name, bool defaultSize = true);
		
		/// ditto
		final Icon getIcon(int id, int width, int height);
		/// ditto
		final Icon getIcon(Dstring name, int width, int height);
		deprecated alias getIcon loadIcon;
		
		
		///
		final Bitmap getBitmap(int id);
		
		/// ditto
		final Bitmap getBitmap(Dstring name);
		deprecated alias getBitmap loadBitmap;
		
		
		///
		final Cursor getCursor(int id);
		
		/// ditto
		final Cursor getCursor(Dstring name);
		deprecated alias getCursor loadCursor;
		
		
		///
		final Dstring getString(int id);
		deprecated alias getString loadString;
		
		
		// Used internally
		// NOTE: win9x doesn't like these strings to be on the heap!
		final void[] _getData(LPCWSTR type, LPCWSTR name);
		///
		final void[] getData(int type, int id);
		
		/// ditto
		final void[] getData(Dstring type, int id);
		/// ditto
		final void[] getData(int type, Dstring name);
		/// ditto
		final void[] getData(Dstring type, Dstring name);
		
		~this();
		
		private:
		
		HINSTANCE hinst;
		WORD lang = 0;
		bool _owned = false;
		
		
		void _noload(Dstring type);
	}
}

