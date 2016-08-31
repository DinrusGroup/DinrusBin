// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.imagelist;

import os.win.gui.base, os.win.gui.drawing, os.win.gui.x.winapi;
import os.win.gui.collections;


version(DFL_NO_IMAGELIST)
{
}
else
{
	///
	class ImageList // docmain
	{
		///
		class ImageCollection
		{
			protected this();
			
			
			void insert(int index, Image img);
			
			
			final void addStrip(Image img);
			
			package:
			
			Image[] _images;
			
			
			static class StripPart: Image
			{
				override Size size();
				
				override void draw(Graphics g, Point pt);
				
				
				override void drawStretched(Graphics g, Rect r);
				
				Image origImg; // Hold this so the HBITMAP doesn't get collected.
				HBITMAP hbm;
				Rect partBounds;
			}
			
			
			void _adding(size_t idx, Image val);
			
			void _added(size_t idx, Image val);
			
			void _removed(size_t idx, Image val);
			
			public:
			
			mixin ListWrapArray!(Image, _images,
				_adding, _added,
				_blankListCallback!(Image), _removed,
				false, false, false);
		}
		
		
		this();
		
		///
		final void colorDepth(ColorDepth depth) ;
		/// ditto
		final ColorDepth colorDepth() ;
		
		///
		final void transparentColor(Color tc);
		/// ditto
		final Color transparentColor() ;
		
		///
		final void imageSize(Size sz) ;
		/// ditto
		final Size imageSize() ;
		
		///
		final ImageCollection images();
		
		///
		final void tag(Object t);
		
		/// ditto
		final Object tag() ;
		
		/+ // Actually, forget about these; just draw with the actual images.
		///
		final void draw(Graphics g, Point pt, int index);
		
		/// ditto
		final void draw(Graphics g, int x, int y, int index);
		
		/// ditto
		// stretch
		final void draw(Graphics g, int x, int y, int width, int height, int index);
		+/
		
		
		///
		final bool isHandleCreated();
		deprecated alias isHandleCreated handleCreated;
		
		
		///
		final HIMAGELIST handle() ;
		///
		void dispose();
		
		/// ditto
		void dispose(bool disposing);
		
		~this();
		
		private:
		
		ColorDepth _depth = ColorDepth.DEPTH_8BIT;
		Color _transcolor;
		ImageCollection _cimages;
		HIMAGELIST _hil;
		int _w = 16, _h = 16;
		Object _tag;
		
		
		void _createimagelist();
		
		void _unableimg();
		
		int _addimg(Image img);
		
		int _addhbitmap(HBITMAP hbm);
	}


	private extern(Windows)
	{
		// This was the only way I could figure out how to use the current actctx (Windows issue).
		
		HIMAGELIST imageListCreate(
			int cx, int cy, UINT flags, int cInitial, int cGrow);
		
		int imageListAddIcon(
			HIMAGELIST himl, HICON hicon);
		
		int imageListAddMasked(
			HIMAGELIST himl, HBITMAP hbmImage, COLORREF crMask);
		
		BOOL imageListRemove(
			HIMAGELIST himl, int i);
		
		BOOL imageListDestroy(
			HIMAGELIST himl);
	}
}

