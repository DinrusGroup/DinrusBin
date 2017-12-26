module wx.common;

version = Unicode;
version = __WXMSW__;

public import base: wchar_t;

interface IDisposable
{
	void Dispose();
}

interface ICloneable
{
	Object Clone();
}

	/// An implementation-specific type that is used to represent a pointer or a handle.
	typedef void* IntPtr;

version(Unicode)
	alias wchar_t wxChar;
else //version(ANSI)
	alias ubyte wxChar;

string assumeUnique(char[] s) { return s; } // DMD 2.006


class NullPointerException : Exception
{
	this(string msg) ;
}

class NullReferenceException : Exception
{
	this(string msg) ;
}

class ArgumentException : Exception
{
	this(string msg);
}

class InvalidOperationException : Exception
{
	this(string msg);
}

class ArgumentNullException : Exception
{
	this(string msg) ;
}

public import wx.wxObject;
public import wx.wxString;


alias Point wxPoint;
struct Point
{
	int X,Y;

	/** struct constructor */
	static Point opCall(int x,int y);
}

alias Size wxSize;
struct Size
{
	int Width,Height;

	/** struct constructor */
	static Size opCall(int w,int h) ;
}

alias Rectangle wxRectangle;
struct Rectangle
{
	int X,Y,Width,Height;
	int  Left();
	void Left(int value);
	int  Top();
	void Top(int value) ;

	int  Right() ;
	void Right(int value);
	int  Bottom();
	void Bottom(int value);

	/** struct constructor */
	static Rectangle opCall(int x,int y,int w,int h);
}

alias Rect wxRect;
alias Rectangle Rect;

alias new_Rectangle new_Rect;


deprecated Point new_Point(int x,int y);
deprecated Size new_Size(int w,int h);
deprecated Rectangle new_Rectangle(int x,int y,int w,int h);


