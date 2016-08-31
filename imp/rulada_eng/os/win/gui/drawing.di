// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.drawing;

private import os.win.gui.x.dlib;

private import os.win.gui.x.winapi, os.win.gui.base, os.win.gui.x.utf, os.win.gui.x.com,
	os.win.gui.x.wincom;


/// X and Y coordinate.
struct Point // docmain
{
	union
	{
		struct
		{
			LONG x;
			LONG y;
		}
		POINT point; // package
	}
	
	
	/// Construct a new Point.
	static Point opCall(int x, int y);
	
	/// ditto
	static Point opCall();
	
	
	///
	Dequ opEquals(Point pt);
	
	///
	Point opAdd(Size sz);
	
	
	///
	Point opSub(Size sz);
	
	
	///
	void opAddAssign(Size sz);
	
	///
	void opSubAssign(Size sz);
	
	///
	Point opNeg();
}


/// Width and height.
struct Size // docmain
{
	union
	{
		struct
		{
			int width;
			int height;
		}
		SIZE size; // package
	}
	
	
	/// Construct a new Size.
	static Size opCall(int width, int height);
	
	/// ditto
	static Size opCall();
	
	
	///
	Dequ opEquals(Size sz);
	
	///
	Size opAdd(Size sz);
	
	
	///
	Size opSub(Size sz);
	///
	void opAddAssign(Size sz);
	
	///
	void opSubAssign(Size sz);
}


/// X, Y, width and height rectangle dimensions.
struct Rect // docmain
{
	int x, y, width, height;
	
	// Used internally.
	void getRect(RECT* r);
	
	///
	Point location() ;
	
	/// ditto
	void location(Point pt);
	
	
	///
	Size size() ;
	
	/// ditto
	void size(Size sz);
	
	
	///
	int right();
	
	///
	int bottom() ;
	
	/// Construct a new Rect.
	static Rect opCall(int x, int y, int width, int height);
	/// ditto
	static Rect opCall(Point location, Size size);
	/// ditto
	static Rect opCall();
	
	
	// Used internally.
	static Rect opCall(RECT* rect);
	
	
	/// Construct a new Rect from left, top, right and bottom values.
	static Rect fromLTRB(int left, int top, int right, int bottom);
	
	///
	Dequ opEquals(Rect r);
	
	///
	bool contains(int c_x, int c_y);
	/// ditto
	bool contains(Point pos);
	
	/// ditto
	// Contained entirely within -this-.
	bool contains(Rect r);
	
	///
	void inflate(int i_width, int i_height);
	/// ditto
	void inflate(Size insz);
	///
	// Just tests if there's an intersection.
	bool intersectsWith(Rect r);
	
	///
	void offset(int x, int y);
	
	/// ditto
	void offset(Point pt);
	
	
	/+
	// Modify -this- to include only the intersection
	// of -this- and -r-.
	void intersect(Rect r);
	+/
	
	
	// void offset(Point), void offset(int, int)
	// static Rect union(Rect, Rect)
}


unittest
{
	Rect r = Rect(3, 3, 3, 3);
	
	assert(r.contains(3, 3));
	assert(!r.contains(3, 2));
	assert(r.contains(6, 6));
	assert(!r.contains(6, 7));
	assert(r.contains(r));
	assert(r.contains(Rect(4, 4, 2, 2)));
	assert(!r.contains(Rect(2, 4, 4, 2)));
	assert(!r.contains(Rect(4, 3, 2, 4)));
	
	r.inflate(2, 1);
	assert(r.x == 1);
	assert(r.right == 8);
	assert(r.y == 2);
	assert(r.bottom == 7);
	r.inflate(-2, -1);
	assert(r == Rect(3, 3, 3, 3));
	
	assert(r.intersectsWith(Rect(4, 4, 2, 9)));
	assert(r.intersectsWith(Rect(3, 3, 1, 1)));
	assert(r.intersectsWith(Rect(0, 3, 3, 0)));
	assert(r.intersectsWith(Rect(3, 2, 0, 1)));
	assert(!r.intersectsWith(Rect(3, 1, 0, 1)));
	assert(r.intersectsWith(Rect(5, 6, 1, 1)));
	assert(!r.intersectsWith(Rect(7, 6, 1, 1)));
	assert(!r.intersectsWith(Rect(6, 7, 1, 1)));
}


/// Color value representation
struct Color // docmain
{
	/// Red, green, blue and alpha channel color values.
	ubyte r();
	/// ditto
	ubyte g() ;
	/// ditto
	ubyte b() ;
	/// ditto
	ubyte a() ;
	
	/// Return the numeric color value.
	COLORREF toArgb();
	
	/// Return the numeric red, green and blue color value.
	COLORREF toRgb();
	
	// Used internally.
	HBRUSH createBrush();
	
	deprecated static Color opCall(COLORREF argb);
	
	/// Construct a new color.
	static Color opCall(ubyte alpha, Color c);
	/// ditto
	static Color opCall(ubyte red, ubyte green, ubyte blue);
	/// ditto
	static Color opCall(ubyte alpha, ubyte red, ubyte green, ubyte blue);
	/// ditto
	//alias opCall fromArgb;
	static Color fromArgb(ubyte alpha, ubyte red, ubyte green, ubyte blue);
	
	/// ditto
	static Color fromRgb(COLORREF rgb);
	/// ditto
	static Color fromRgb(ubyte alpha, COLORREF rgb);
	
	/// ditto
	static Color empty();
	
	/// Return a completely transparent color value.
	static Color transparent() ;
	
	deprecated alias blendColor blend;
	
	
	/// Blend colors; alpha channels are ignored.
	// Blends the color channels half way.
	// Does not consider alpha channels and discards them.
	// The new blended color is returned; -this- Color is not modified.
	Color blendColor(Color wc);
	
	/// Alpha blend this color with a background color to return a solid color (100% opaque).
	// Blends with backColor if this color has opacity to produce a solid color.
	// Returns the new solid color, or the original color if no opacity.
	// If backColor has opacity, it is ignored.
	// The new blended color is returned; -this- Color is not modified.
	Color solidColor(Color backColor);
	
	
	package static Color systemColor(int colorIndex);
	
	
	// Gets color index or INVAILD_SYSTEM_COLOR_INDEX.
	package int _systemColorIndex() ;
	
	package const ubyte INVAILD_SYSTEM_COLOR_INDEX = ubyte.max;
	
	
	private:
	union _color
	{
		struct
		{
			align(1):
			ubyte red;
			ubyte green;
			ubyte blue;
			ubyte alpha;
		}
		COLORREF cref;
	}
	static assert(_color.sizeof == uint.sizeof);
	_color color;
	
	ubyte sysIndex = INVAILD_SYSTEM_COLOR_INDEX;
	
	
	void validateColor();
}


///
class SystemColors // docmain
{
	private this();
	
	static:
	
	///
	Color activeBorder() ;
	/// ditto
	Color activeCaption() ;
	/// ditto
	Color activeCaptionText();
	/// ditto
	Color appWorkspace() ;
	/// ditto
	Color control();
	/// ditto
	Color controlDark() ;
	
	/// ditto
	Color controlDarkDark();
	/// ditto
	Color controlLight();
	/// ditto
	Color controlLightLight() ;
	/// ditto
	Color controlText() ;
	/// ditto
	Color desktop() ;
	/// ditto
	Color grayText();
	/// ditto
	Color highlight();
	/// ditto
	Color highlightText() ;
	
	/// ditto
	Color hotTrack() ;
	
	/// ditto
	Color inactiveBorder() ;
	
	/// ditto
	Color inactiveCaption() ;
	/// ditto
	Color inactiveCaptionText() ;
	/// ditto
	Color info() ;
	/// ditto
	Color infoText() ;
	/// ditto
	Color menu() ;
	/// ditto
	Color menuText();
	/// ditto
	Color scrollBar() ;
	/// ditto
	Color window();
	/// ditto
	Color windowFrame();
	/// ditto
	Color windowText();
}


///
class SystemIcons // docmain
{
	private this();
	
	static:
	
	///
	Icon application() ;
	/// ditto
	Icon error() ;
	/// ditto
	Icon question();
	/// ditto
	Icon warning() ;
	/// ditto
	Icon information() ;
}


/+
class ImageFormat
{
	/+
	this(guid);
	
	final guid() ;
	+/
	
	
	static:
	
	ImageFormat bmp() ;
	
	ImageFormat icon();
}
+/


///
abstract class Image // docmain
{
	//flags(); // getter ???
	
	
	/+
	final ImageFormat rawFormat(); // getter
	+/
	
	
	static Bitmap fromHBitmap(HBITMAP hbm) ;
	
	/+
	static Image fromFile(Dstring file);
	+/
	
	
	///
	void draw(Graphics g, Point pt);
	/// ditto
	void drawStretched(Graphics g, Rect r);
	
	
	///
	Size size(); // getter
	
	
	///
	int width();
	
	///
	int height();
	
	int _imgtype(HGDIOBJ* ph) ;
}


///
class Bitmap: Image // docmain
{
	///
	// Load from a bmp file.
	this(Dstring fileName);
	
	// Used internally.
	this(HBITMAP hbm, bool owned = true);
	
	
	///
	final HBITMAP handle();
	
	private void _getInfo(BITMAP* bm);
	///
	final override Size size();
	
	///
	final override int width();
	
	///
	final override int height();
	
	private void _draw(Graphics g, Point pt, HDC memdc);
	
	///
	final override void draw(Graphics g, Point pt);
	
	/// ditto
	// -tempMemGraphics- is used as a temporary Graphics instead of
	// creating and destroying a temporary one for each call.
	final void draw(Graphics g, Point pt, Graphics tempMemGraphics);
	
	private void _drawStretched(Graphics g, Rect r, HDC memdc);
	
	///
	final override void drawStretched(Graphics g, Rect r);
	
	/// ditto
	// -tempMemGraphics- is used as a temporary Graphics instead of
	// creating and destroying a temporary one for each call.
	final void drawStretched(Graphics g, Rect r, Graphics tempMemGraphics);
	///
	void dispose();
	
	~this();
	
	override int _imgtype(HGDIOBJ* ph);
	
	private:
	HBITMAP hbm;
	bool owned = true;
}


///
class Picture: Image // docmain
{
	// Note: requires OleInitialize(null).
	
	
	///
	// Throws exception on failure.
	this(DStream stm);
	/// ditto
	// Throws exception on failure.
	this(Dstring fileName);
	
	
	/// ditto
	this(void[] mem);
	
	private this(os.win.gui.x.wincom.IPicture ipic);
	
	
	///
	// Returns null on failure instead of throwing exception.
	static Picture fromStream(DStream stm);
	
	///
	// Returns null on failure instead of throwing exception.
	static Picture fromFile(Dstring fileName);
	
	///
	static Picture fromMemory(void[] mem);
	
	///
	final void draw(HDC hdc, Point pt) ;
	/// ditto
	final override void draw(Graphics g, Point pt);
	
	///
	final void drawStretched(HDC hdc, Rect r) ;
	/// ditto
	final override void drawStretched(Graphics g, Rect r);
	///
	final OLE_XSIZE_HIMETRIC loghimX() ;
	/// ditto
	final OLE_YSIZE_HIMETRIC loghimY();
	
	///
	final override int width();
	
	///
	final override int height() ;
	
	///
	final override Size size();
	
	
	///
	final int getWidth(HDC hdc) ;
	/// ditto
	final int getWidth(Graphics g);
	
	///
	final int getHeight(HDC hdc);
	/// ditto
	final int getHeight(Graphics g);
	final Size getSize(HDC hdc);
	///
	final Size getSize(Graphics g);
	
	///
	void dispose();
	
	~this();
	
	final HBITMAP toHBitmap(HDC hdc);
	final Bitmap toBitmap(HDC hdc) ;
	
	final Bitmap toBitmap();
	/// ditto
	final Bitmap toBitmap(Graphics g);
	HBITMAP _hbmimgtype;
	
	override int _imgtype(HGDIOBJ* ph);
	
	private:
	os.win.gui.x.wincom.IPicture ipic = null;
	
	
	static os.win.gui.x.wincom.IPicture _fromIStream(os.win.gui.x.wincom.IStream istm);
	
	static os.win.gui.x.wincom.IPicture _fromDStream(DStream stm);
	
	static os.win.gui.x.wincom.IPicture _fromFileName(Dstring fileName);
	
	static os.win.gui.x.wincom.IPicture _fromMemory(void[] mem);
	
}


///
enum TextTrimming: UINT
{
	NONE = 0,
	ELLIPSIS = DT_END_ELLIPSIS, /// ditto
	ELLIPSIS_PATH = DT_PATH_ELLIPSIS, /// ditto
}


///
enum TextFormatFlags: UINT
{
	NO_PREFIX = DT_NOPREFIX,
	DIRECTION_RIGHT_TO_LEFT = DT_RTLREADING, /// ditto
	WORD_BREAK = DT_WORDBREAK, /// ditto
	SINGLE_LINE = DT_SINGLELINE, /// ditto
	NO_CLIP = DT_NOCLIP, /// ditto
	LINE_LIMIT = DT_EDITCONTROL, /// ditto
}


///
enum TextAlignment: UINT
{
	LEFT = DT_LEFT, ///
	RIGHT = DT_RIGHT, /// ditto
	CENTER = DT_CENTER, /// ditto
	
	TOP = DT_TOP,  /// Single line only alignment.
	BOTTOM = DT_BOTTOM, /// ditto
	MIDDLE = DT_VCENTER, /// ditto
}


///
class TextFormat
{
	///
	this();
	/// ditto
	this(TextFormat tf);
	
	/// ditto
	this(TextFormatFlags flags);
	
	///
	static TextFormat genericDefault();
	/// ditto
	static TextFormat genericTypographic() ;
	
	///
	final void alignment(TextAlignment ta) ;
	/// ditto
	final TextAlignment alignment() ;
	
	///
	final void formatFlags(TextFormatFlags tff);
	
	/// ditto
	final TextFormatFlags formatFlags() ;
	
	
	///
	final void trimming(TextTrimming tt) ;
	/// ditto
	final TextTrimming trimming();
	
	// Units of the average character width.
	
	///
	final void tabLength(int tablen);
	
	/// ditto
	final int tabLength();
	// Units of the average character width.
	
	///
	final void leftMargin(int sz);
	
	/// ditto
	final int leftMargin() ;
	
	// Units of the average character width.
	
	///
	final void rightMargin(int sz) ;
	/// ditto
	final int rightMargin() ;
	
	private:
	TextTrimming _trim = TextTrimming.NONE; // TextTrimming.CHARACTER.
	TextFormatFlags _flags = TextFormatFlags.NO_PREFIX | TextFormatFlags.WORD_BREAK;
	TextAlignment _align = TextAlignment.LEFT;
	package DRAWTEXTPARAMS _params = { DRAWTEXTPARAMS.sizeof, 8, 0, 0 };
}


///
// Note: currently only works with the one screen.
class Screen
{
	///
	static Screen primaryScreen() ;
	
	///
	Rect bounds();
	///
	Rect workingArea() ;
	
	
	private:
	this() ;
}


///
class Graphics // docmain
{
	// Used internally.
	this(HDC hdc, bool owned = true);
	
	
	~this();
	
	// Used internally.
	final void drawSizeGrip(int right, int bottom) ;
	
	// Used internally.
	// vSplit=true means the move grip moves left to right; false means top to bottom.
	final void drawMoveGrip(Rect movableArea, bool vSplit = true, size_t count = 5);
	
	package final TextFormat getCachedTextFormat();
	
	// Windows 95/98/Me limits -text- to 8192 characters.
	
	///
	final void drawText(Dstring text, Font font, Color color, Rect r, TextFormat fmt);
	
	/// ditto
	final void drawText(Dstring text, Font font, Color color, Rect r);
	
	///
	final void drawTextDisabled(Dstring text, Font font, Color color, Color backColor, Rect r, TextFormat fmt);
	/// ditto
	final void drawTextDisabled(Dstring text, Font font, Color color, Color backColor, Rect r);
	
	/+
	final Size measureText(Dstring text, Font font);
	+/
	
	
	private const int DEFAULT_MEASURE_SIZE = short.max; // Has to be smaller because it's 16-bits on win9x.
	
	
	///
	final Size measureText(Dstring text, Font font, int maxWidth, TextFormat fmt);
	
	/// ditto
	final Size measureText(Dstring text, Font font, TextFormat fmt);
	/// ditto
	final Size measureText(Dstring text, Font font, int maxWidth);
	
	/// ditto
	final Size measureText(Dstring text, Font font);
	/+
	// Doesn't work... os.win.gui.x.utf.drawTextEx uses a different buffer!
	// ///
	final Dstring getTrimmedText(Dstring text, Font font, Rect r, TextFormat fmt) ;
	// ///
	final Dstring getTrimmedText(Dstring text, Font font, Rect r, TextTrimming trim);
	+/
	
	
	///
	final void drawIcon(Icon icon, Rect r);
	
	/// ditto
	final void drawIcon(Icon icon, int x, int y);
	
	///
	final void fillRectangle(Brush brush, Rect r);
	/// ditto
	final void fillRectangle(Brush brush, int x, int y, int width, int height);
	
	
	// Extra function.
	final void fillRectangle(Color color, Rect r);
	/// ditto
	// Extra function.
	final void fillRectangle(Color color, int x, int y, int width, int height);
	
	///
	final void fillRegion(Brush brush, Region region);
	
	///
	static Graphics fromHwnd(HWND hwnd);
	
	/// Get the entire screen's Graphics for the primary monitor.
	static Graphics getScreen();
	
	///
	final void drawLine(Pen pen, Point start, Point end);
	
	/// ditto
	final void drawLine(Pen pen, int startX, int startY, int endX, int endY);
	
	///
	// First two points is the first line, the other points link a line
	// to the previous point.
	final void drawLines(Pen pen, Point[] points);
	
	///
	final void drawArc(Pen pen, int x, int y, int width, int height, int arcX1, int arcY1, int arcX2, int arcY2);
	
	/// ditto
	final void drawArc(Pen pen, Rect r, Point arc1, Point arc2);
	
	
	///
	final void drawBezier(Pen pen, Point[4] points);
	
	/// ditto
	final void drawBezier(Pen pen, Point pt1, Point pt2, Point pt3, Point pt4);
	
	///
	// First 4 points are the first bezier, each next 3 are the next
	// beziers, using the previous last point as the starting point.
	final void drawBeziers(Pen pen, Point[] points);
	
	
	// TODO: drawCurve(), drawClosedCurve() ...
	
	
	///
	final void drawEllipse(Pen pen, Rect r);
	/// ditto
	final void drawEllipse(Pen pen, int x, int y, int width, int height);
	
	
	// TODO: drawPie()
	
	
	///
	final void drawPolygon(Pen pen, Point[] points);
	
	///
	final void drawRectangle(Pen pen, Rect r);
	/// ditto
	final void drawRectangle(Pen pen, int x, int y, int width, int height);
	
	
	/+
	final void drawRectangle(Color c, Rect r);
	
	final void drawRectangle(Color c, int x, int y, int width, int height);
	+/
	
	
	///
	final void drawRectangles(Pen pen, Rect[] rs);
	
	///
	// Force pending graphics operations.
	final void flush();
	
	///
	final Color getNearestColor(Color c);
	
	///
	final Size getScaleSize(Font f);
	
	
	final bool copyTo(HDC dest, int destX, int destY, int width, int height, int srcX = 0, int srcY = 0, DWORD rop = SRCCOPY);
	
	///
	final bool copyTo(Graphics destGraphics, int destX, int destY, int width, int height, int srcX = 0, int srcY = 0, DWORD rop = SRCCOPY);
	/// ditto
	final bool copyTo(Graphics destGraphics, Rect bounds);
	
	///
	final HDC handle();
	
	///
	void dispose();
	
	
	private:
	HDC hdc;
	bool owned = true;
}


/// Graphics for a surface in memory.
class MemoryGraphics: Graphics // docmain
{
	///
	// Graphics compatible with the current screen.
	this(int width, int height);
	
	/// ditto
	// graphicsCompatible cannot be another MemoryGraphics.
	this(int width, int height, Graphics graphicsCompatible);
	
	// Used internally.
	this(int width, int height, HDC hdcCompatible) ;
	
	
	///
	final int width() ;
	
	///
	final int height() ;
	
	final Size size() ;
	
	///
	final HBITMAP hbitmap() ;
	
	// Needs to copy so it can be selected into other DC`s.
	final HBITMAP toHBitmap(HDC hdc);
	
	
	final Bitmap toBitmap(HDC hdc) ;
	
	///
	final Bitmap toBitmap();
	/// ditto
	final Bitmap toBitmap(Graphics g);
	
	///
	override void dispose();
	
	
	private:
	HGDIOBJ hbmOld;
	HBITMAP hbm;
	int _w, _h;
}


// Use with GetDC()/GetWindowDC()/GetDCEx() so that
// the HDC is properly released instead of deleted.
package class CommonGraphics: Graphics
{
	// Used internally.
	this(HWND hwnd, HDC hdc, bool owned = true);
	
	override void dispose();
	
	package:
	HWND hwnd;
}


///
class Icon: Image // docmain
{
	// Used internally.
	this(HICON hi, bool owned = true);
	
	///
	deprecated static Icon fromHandle(HICON hi);
	// -bm- can be null.
	// NOTE: the bitmaps in -ii- need to be deleted! _deleteBitmaps() is a shortcut.
	private void _getInfo(ICONINFO* ii, BITMAP* bm = null);
	
	
	private void _deleteBitmaps(ICONINFO* ii);
	
	///
	final Bitmap toBitmap();
	
	///
	final override void draw(Graphics g, Point pt);
	
	
	///
	final override void drawStretched(Graphics g, Rect r);
	
	///
	final override Size size() ;
	
	///
	final override int width();
	
	///
	final override int height();
	
	~this();
	
	int _imgtype(HGDIOBJ* ph) ;
	
	
	///
	void dispose();
	
	
	///
	final HICON handle();
	
	private:
	HICON hi;
	bool owned = true;
}


///
enum GraphicsUnit: ubyte // docmain ?
{
	///
	PIXEL,
	/// ditto
	DISPLAY, // 1/75 inch.
	/// ditto
	DOCUMENT, // 1/300 inch.
	/// ditto
	INCH, // 1 inch, der.
	/// ditto
	MILLIMETER, // 25.4 millimeters in 1 inch.
	/// ditto
	POINT, // 1/72 inch.
	//WORLD, // ?
	TWIP, // Extra. 1/1440 inch.
}


/+
// TODO: check if correct implementation.
enum GenericFontFamilies
{
	MONOSPACE = FF_MODERN,
	SANS_SERIF = FF_ROMAN,
	SERIF = FF_SWISS,
}
+/


/+
abstract class FontCollection
{
	abstract FontFamily[] families(); // getter
}


class FontFamily
{
	/+
	this(GenericFontFamilies genericFamily);
	+/
	
	
	this(Dstring name);
	
	
	this(Dstring name, FontCollection fontCollection);
	
	
	final Dstring name() ;	
	
	static FontFamily[] families() ;
	
	
	/+
	// TODO: implement.
	
	static FontFamily genericMonospace() ;
	
	static FontFamily genericSansSerif() ;
	
	static FontFamily genericSerif() ;
	+/
}
+/


///
// Flags.
enum FontStyle: ubyte
{
	REGULAR = 0, ///
	BOLD = 1, /// ditto
	ITALIC = 2, /// ditto
	UNDERLINE = 4, /// ditto
	STRIKEOUT = 8, /// ditto
}


///
enum FontSmoothing
{
	DEFAULT = DEFAULT_QUALITY,
	ON = ANTIALIASED_QUALITY,
	OFF = NONANTIALIASED_QUALITY,
}


///
class Font // docmain
{
	// Used internally.
	static void LOGFONTAtoLogFont(inout LogFont lf, LOGFONTA* plfa) ;
	// Used internally.
	static void LOGFONTWtoLogFont(inout LogFont lf, LOGFONTW* plfw) ;
	
	// Used internally.
	this(HFONT hf, LOGFONTA* plfa, bool owned = true);
	
	// Used internally.
	this(HFONT hf, inout LogFont lf, bool owned = true);
	
	// Used internally.
	this(HFONT hf, bool owned = true) ;
	
	
	// Used internally.
	this(LOGFONTA* plfa, bool owned = true);
	
	// Used internally.
	this(inout LogFont lf, bool owned = true);
	
	package static HFONT _create(inout LogFont lf);
	
	private static void _style(inout LogFont lf, FontStyle style);
	
	
	private static FontStyle _style(inout LogFont lf);
	
	
	package void _info(LOGFONTA* lf) ;
	
	package void _info(LOGFONTW* lf) ;
	
	package void _info(inout LogFont lf);
	
	
	package static LONG getLfHeight(float emSize, GraphicsUnit unit);
	
	package static float getEmSize(HDC hdc, LONG lfHeight, GraphicsUnit toUnit);
	
	package static float getEmSize(LONG lfHeight, GraphicsUnit toUnit);
	
	///
	this(Font font, FontStyle style);
	/// ditto
	this(Dstring name, float emSize, GraphicsUnit unit);
	
	/// ditto
	this(Dstring name, float emSize, FontStyle style = FontStyle.REGULAR,
		GraphicsUnit unit = GraphicsUnit.POINT);
	
	/// ditto
	this(Dstring name, float emSize, FontStyle style,
		GraphicsUnit unit, FontSmoothing smoothing);
	// /// ditto
	// This is a somewhat internal function.
	// -gdiCharSet- is one of *_CHARSET from wingdi.h
	this(Dstring name, float emSize, FontStyle style,
		GraphicsUnit unit, ubyte gdiCharSet,
		FontSmoothing smoothing = FontSmoothing.DEFAULT);
	
	~this();
	
	///
	final HFONT handle();
	
	///
	final GraphicsUnit unit();
	
	
	///
	final float size();
	
	///
	final float getSize(GraphicsUnit unit);
	
	/// ditto
	final float getSize(GraphicsUnit unit, Graphics g);
	
	///
	final FontStyle style() ;
	///
	final Dstring name();
	
	final ubyte gdiCharSet() ;
	
	/+
	private void _initLf(LOGFONTA* lf);
	+/
	
	private void _initLf(inout LogFont lf);
	
	/+
	private void _initLf(Font otherfont, LOGFONTA* lf);
	+/
	
	private void _initLf(Font otherfont, inout LogFont lf);
	
	private:
	HFONT hf;
	GraphicsUnit _unit;
	bool owned = true;
	FontStyle _fstyle;
	
	LONG lfHeight;
	Dstring lfName;
	ubyte lfCharSet;
}


///
enum PenStyle: UINT
{
	SOLID = PS_SOLID, ///
	DASH = PS_DASH, /// ditto
	DOT = PS_DOT, /// ditto
	DASH_DOT = PS_DASHDOT, /// ditto
	DASH_DOT_DOT = PS_DASHDOTDOT, /// ditto
	NULL = PS_NULL, /// ditto
	INSIDE_FRAME = PS_INSIDEFRAME, /// ditto
}


///
// If the pen width is greater than 1 the style cannot have dashes or dots.
class Pen // docmain
{
	// Used internally.
	this(HPEN hp, bool owned = true);
	
	
	///
	this(Color color, int width = 1, PenStyle ps = PenStyle.SOLID);
	
	~this();
	
	///
	final HPEN handle() ;
	
	private:
	HPEN hp;
	bool owned = true;
}


///
class Brush // docmain
{
	// Used internally.
	this(HBRUSH hb, bool owned = true);
	
	protected this();
	
	~this();
	
	///
	final HBRUSH handle() ;
	
	private:
	HBRUSH hb;
	bool owned = true;
}


///
class SolidBrush: Brush // docmain
{
	///
	this(Color c);
	
	
	/+
	final void color(Color c) /;
	+/
	
	
	///
	final Color color() ;
}


// PatternBrush has the win9x/ME limitation of not supporting images larger than 8x8 pixels.
// TextureBrush supports any size images but requires GDI+.


/+
class PatternBrush: Brush
{
	//CreatePatternBrush() ...
}
+/


/+
class TextureBrush: Brush
{
	// GDI+ ...
}
+/


///
enum HatchStyle: LONG
{
	HORIZONTAL = HS_HORIZONTAL, ///
	VERTICAL = HS_VERTICAL, /// ditto
	FORWARD_DIAGONAL = HS_FDIAGONAL, /// ditto
	BACKWARD_DIAGONAL = HS_BDIAGONAL, /// ditto
	CROSS = HS_CROSS, /// ditto
	DIAGONAL_CROSS = HS_DIAGCROSS, /// ditto
}


///
class HatchBrush: Brush // docmain
{
	///
	this(HatchStyle hs, Color c);
	
	
	///
	final Color foregroundColor() ;
	
	
	///
	final HatchStyle hatchStyle() ;
}


///
class Region // docmain
{
	// Used internally.
	this(HRGN hrgn, bool owned = true);
	
	~this();
	
	///
	final HRGN handle() ;
	
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(Region rgn);
	
	private:
	HRGN hrgn;
	bool owned = true;
}

