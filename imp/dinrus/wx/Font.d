
module wx.Font;
public import wx.common;
public import wx.GDIObject;

	// Font encodings - taken from wx/fontenc.h
	// Author: Vadim Zeitlin, (C) Vadim Zeitlin
	public enum FontEncoding
	{
		wxFONTENCODING_SYSTEM = -1,     // system default
		wxFONTENCODING_DEFAULT,         // current default encoding

		// ISO8859 standard defines a number of single-byte charsets
		wxFONTENCODING_ISO8859_1,           // West European (Latin1)
		wxFONTENCODING_ISO8859_2,           // Central and East European (Latin2)
		wxFONTENCODING_ISO8859_3,           // Esperanto (Latin3)
		wxFONTENCODING_ISO8859_4,           // Baltic (old) (Latin4)
		wxFONTENCODING_ISO8859_5,           // Cyrillic
		wxFONTENCODING_ISO8859_6,           // Arabic
		wxFONTENCODING_ISO8859_7,           // Greek
		wxFONTENCODING_ISO8859_8,           // Hebrew
		wxFONTENCODING_ISO8859_9,           // Turkish (Latin5)
		wxFONTENCODING_ISO8859_10,          // Variation of Latin4 (Latin6)
		wxFONTENCODING_ISO8859_11,          // Thai
		wxFONTENCODING_ISO8859_12,          // doesn't exist currently, but put it
		// here anyhow to make all ISO8859
		// consecutive numbers
		wxFONTENCODING_ISO8859_13,          // Baltic (Latin7)
		wxFONTENCODING_ISO8859_14,          // Latin8
		wxFONTENCODING_ISO8859_15,          // Latin9 (a.k.a. Latin0, includes euro)
		wxFONTENCODING_ISO8859_MAX,

		// Cyrillic charset soup (see http://czyborra.com/charsets/cyrillic.html)
		wxFONTENCODING_KOI8,                // we don't support any of KOI8 variants
		wxFONTENCODING_ALTERNATIVE,         // same as MS-DOS CP866
		wxFONTENCODING_BULGARIAN,           // used under Linux in Bulgaria
		// what would we do without Microsoft? They have their own encodings
		// for DOS
		wxFONTENCODING_CP437,               // original MS-DOS codepage
		wxFONTENCODING_CP850,               // CP437 merged with Latin1
		wxFONTENCODING_CP852,               // CP437 merged with Latin2
		wxFONTENCODING_CP855,               // another cyrillic encoding
		wxFONTENCODING_CP866,               // and another one
		// and for Windows
		wxFONTENCODING_CP874,               // WinThai
		wxFONTENCODING_CP932,               // Japanese (shift-JIS)
		wxFONTENCODING_CP936,               // Chinese simplified (GB)
		wxFONTENCODING_CP949,               // Korean (Hangul charset)
		wxFONTENCODING_CP950,               // Chinese (traditional - Big5)
		wxFONTENCODING_CP1250,              // WinLatin2
		wxFONTENCODING_CP1251,              // WinCyrillic
		wxFONTENCODING_CP1252,              // WinLatin1
		wxFONTENCODING_CP1253,              // WinGreek (8859-7)
		wxFONTENCODING_CP1254,              // WinTurkish
		wxFONTENCODING_CP1255,              // WinHebrew
		wxFONTENCODING_CP1256,              // WinArabic
		wxFONTENCODING_CP1257,              // WinBaltic (same as Latin 7)
		wxFONTENCODING_CP12_MAX,

		wxFONTENCODING_UTF7,                // UTF-7 Unicode encoding
		wxFONTENCODING_UTF8,                // UTF-8 Unicode encoding

		// Far Eastern encodings
		// Chinese
		wxFONTENCODING_GB2312 = wxFONTENCODING_CP936,       // Simplified Chinese
		wxFONTENCODING_BIG5 = wxFONTENCODING_CP950,         // Traditional Chinese

		// Japanese (see http://zsigri.tripod.com/fontboard/cjk/jis.html)
		wxFONTENCODING_Shift_JIS = wxFONTENCODING_CP932,    // Shift JIS
		wxFONTENCODING_EUC_JP,                              // Extended Unix Codepage for Japanese

		wxFONTENCODING_UNICODE,         // Unicode - currently used only by
		// wxEncodingConverter class

		wxFONTENCODING_MAX
	}

	public enum FontFamily
	{
		// Text font families
		wxDEFAULT    = 70,
		wxDECORATIVE,
		wxROMAN,
		wxSCRIPT,
		wxSWISS,
		wxMODERN,
		wxTELETYPE,  
		wxMAX,
        
		// Proportional or Fixed width fonts (not yet used)
		wxVARIABLE   = 80,
		wxFIXED,
        
		wxNORMAL     = 90,
		wxLIGHT,
		wxBOLD,
		// Also wxNORMAL for normal (non-italic text)
		wxITALIC,
		wxSLANT
	}

	public enum FontWeight
	{
		wxNORMAL = 90,
		wxLIGHT,
		wxBOLD,
		wxMAX
	}

	public enum FontStyle
	{
		wxNORMAL = 90,
		wxITALIC = 93,
		wxSLANT  = 94,
		wxMAX
	}
	
	public enum FontFlag
	{
		wxFONTFLAG_DEFAULT          = 0,

		wxFONTFLAG_ITALIC           = 1 << 0,
		wxFONTFLAG_SLANT            = 1 << 1,

		wxFONTFLAG_LIGHT            = 1 << 2,
		wxFONTFLAG_BOLD             = 1 << 3,

		wxFONTFLAG_ANTIALIASED      = 1 << 4,
		wxFONTFLAG_NOT_ANTIALIASED  = 1 << 5,

		wxFONTFLAG_UNDERLINED       = 1 << 6,
		wxFONTFLAG_STRIKETHROUGH    = 1 << 7,

		wxFONTFLAG_MASK = wxFONTFLAG_ITALIC             |
			wxFONTFLAG_SLANT              |
			wxFONTFLAG_LIGHT              |
			wxFONTFLAG_BOLD               |
			wxFONTFLAG_ANTIALIASED        |
			wxFONTFLAG_NOT_ANTIALIASED    |
			wxFONTFLAG_UNDERLINED         |
			wxFONTFLAG_STRIKETHROUGH
	}

		//! \cond EXTERN
		static extern (C)        IntPtr wxFont_NORMAL_FONT();
		static extern (C)        IntPtr wxFont_SMALL_FONT();
		static extern (C)        IntPtr wxFont_ITALIC_FONT();
		static extern (C)        IntPtr wxFont_SWISS_FONT();
		static extern (C) IntPtr wxNullFont_Get();

		static extern (C)        IntPtr wxFont_ctorDef();
		static extern (C)        IntPtr wxFont_ctor(int pointSize, int family, int style, int weight, bool underline, string faceName, FontEncoding encoding);
		static extern (C) void   wxFont_dtor(IntPtr self);
		static extern (C) bool   wxFont_Ok(IntPtr self);
		static extern (C) int    wxFont_GetPointSize(IntPtr self);
		static extern (C) int    wxFont_GetFamily(IntPtr self);
		static extern (C) int    wxFont_GetStyle(IntPtr self);
		static extern (C) int    wxFont_GetWeight(IntPtr self);
		static extern (C) bool   wxFont_GetUnderlined(IntPtr self);
		static extern (C) IntPtr wxFont_GetFaceName(IntPtr self);
		static extern (C) int    wxFont_GetEncoding(IntPtr self);
		static extern (C)        IntPtr wxFont_GetNativeFontInfo(IntPtr self);
		static extern (C) bool   wxFont_IsFixedWidth(IntPtr self);
		static extern (C) IntPtr wxFont_GetNativeFontInfoDesc(IntPtr self);
		static extern (C) IntPtr wxFont_GetNativeFontInfoUserDesc(IntPtr self);
		static extern (C) void   wxFont_SetPointSize(IntPtr self, int pointSize);
		static extern (C) void   wxFont_SetFamily(IntPtr self, int family);
		static extern (C) void   wxFont_SetStyle(IntPtr self, int style);
		static extern (C) void   wxFont_SetWeight(IntPtr self, int weight);
		static extern (C) void   wxFont_SetFaceName(IntPtr self, string faceName);
		static extern (C) void   wxFont_SetUnderlined(IntPtr self, bool underlined);
		static extern (C) void   wxFont_SetEncoding(IntPtr self, int encoding);
		static extern (C) void   wxFont_SetNativeFontInfoUserDesc(IntPtr self, IntPtr info);
		static extern (C) IntPtr wxFont_GetFamilyString(IntPtr self);
		static extern (C) IntPtr wxFont_GetStyleString(IntPtr self);
		static extern (C) IntPtr wxFont_GetWeightString(IntPtr self);
		static extern (C) void   wxFont_SetNoAntiAliasing(IntPtr self, bool no);
		static extern (C) bool   wxFont_GetNoAntiAliasing(IntPtr self);
		static extern (C) int    wxFont_GetDefaultEncoding();
		static extern (C) void   wxFont_SetDefaultEncoding(int encoding);
	
		static extern (C) IntPtr wxFont_New(string strNativeFontDesc);
		//! \endcond

		//---------------------------------------------------------------------

	alias Font wxFont;
	public class Font : GDIObject, ICloneable
	{
		// in wxWidgets 2.8 fonts are dynamic, and crash if accessed too early
		public static Font wxNORMAL_FONT();
		public static Font wxSMALL_FONT()  ;
		public static Font wxITALIC_FONT() ;
		public static Font wxSWISS_FONT() ;
		public static Font wxNullFont;

		//override public void Dispose();
		public this(IntPtr wxobj);
		public this(IntPtr wxobj, bool memOwn);
		public this();
		public this(int pointSize, FontFamily family, FontStyle style, FontWeight weight, bool underline = false, string face = "", FontEncoding encoding = FontEncoding.wxFONTENCODING_DEFAULT);
		~this();
		public int PointSize() ;
		public void PointSize(int value) ;
		public FontFamily Family() ;
		public void Family(FontFamily value) ;
		public FontStyle Style() ;
		public void Style(FontStyle value) ;
		public FontEncoding Encoding() ;
		public void Encoding(FontEncoding value) ;
		public FontWeight Weight() ;
		public void Weight(FontWeight value) ;
		public bool Underlined() ;
		public void Underlined(bool value) ;
		public string FaceName() ;
		public void FaceName(string value) ;
		public string FamilyString() ;
		public string StyleString() ;
		public string WeightString() ;
		public bool IsFixedWidth() ;
		public bool Ok();
		public IntPtr NativeFontInfo();
		public string NativeFontInfoUserDesc() ;
		public string NativeFontInfoDesc();
		public static Font New(string strNativeFontDesc);
		public Object Clone();
		public this(Font other) ;
		public static wxObject New(IntPtr ptr) ;
	}
