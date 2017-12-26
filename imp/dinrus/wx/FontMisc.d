module wx.FontMisc;
public import wx.common;
public import wx.Font;
public import wx.Window;
public import wx.ArrayString;

		//! \cond EXTERN
		static extern (C) IntPtr wxFontMapper_ctor();
		static extern (C) void   wxFontMapper_dtor(IntPtr self);
		
		static extern (C) IntPtr wxFontMapper_Get();
		static extern (C) IntPtr wxFontMapper_Set(IntPtr mapper);
		static extern (C) int    wxFontMapper_GetSupportedEncodingsCount();
		static extern (C) int    wxFontMapper_GetEncoding(int n);
		static extern (C) IntPtr wxFontMapper_GetEncodingName(int encoding);
		static extern (C) IntPtr wxFontMapper_GetEncodingDescription(int encoding);
		static extern (C) int    wxFontMapper_GetEncodingFromName(string name);
		
		static extern (C) int    wxFontMapper_CharsetToEncoding(IntPtr self, string charset, bool interactive);
		static extern (C) bool   wxFontMapper_IsEncodingAvailable(IntPtr self, int encoding, string facename);
		static extern (C) bool   wxFontMapper_GetAltForEncoding(IntPtr self, int encoding, out int alt_encoding, string facename, bool interactive);
		
		static extern (C) void   wxFontMapper_SetDialogParent(IntPtr self, IntPtr parent);
		static extern (C) void   wxFontMapper_SetDialogTitle(IntPtr self, string title);
		//! \endcond
		
		//---------------------------------------------------------------------
		
	alias FontMapper wxFontMapper;
	public class FontMapper : wxObject
	{
		private static FontMapper staticFontMapper;
		
		static void initialize();
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		override protected void dtor();
		static FontMapper Get();
		public static FontMapper Set(FontMapper mapper);
		static int SupportedEncodingsCount() ;
		public static FontEncoding GetEncoding(int n);
		public static string GetEncodingName(FontEncoding encoding);
		public static FontEncoding GetEncodingFromName(string name);
		public FontEncoding CharsetToEncoding(string charset);
		public FontEncoding CharsetToEncoding(string charset, bool interactive);
		public bool IsEncodingAvailable(FontEncoding encoding);
		public bool IsEncodingAvailable(FontEncoding encoding, string facename);
		public bool GetAltForEncoding(FontEncoding encoding, out FontEncoding alt_encoding);
		public bool GetAltForEncoding(FontEncoding encoding, out FontEncoding alt_encoding, string facename);
		public bool GetAltForEncoding(FontEncoding encoding, out FontEncoding alt_encoding, string facename, bool interactive);
		public static string GetEncodingDescription(FontEncoding encoding);
		public void SetDialogParent(Window parent);
		public void SetDialogTitle(string title);
	}
	
	//---------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxEncodingConverter_ctor();
		static extern (C) bool wxEncodingConverter_Init(IntPtr self, int input_enc, int output_enc, int method);
		static extern (C) IntPtr wxEncodingConverter_Convert(IntPtr self, string input);
		//! \endcond
		
		//---------------------------------------------------------------------
		
	alias EncodingConverter wxEncodingConverter;
	public class EncodingConverter : wxObject
	{
		enum CONVERT
		{
			 wxCONVERT_STRICT,
			 wxCONVERT_SUBSTITUTE
		}
		
		public this(IntPtr wxobj);
		public this();
		public bool Init(FontEncoding input_enc, FontEncoding output_enc);
		public bool Init(FontEncoding input_enc, FontEncoding output_enc, int method);
		public string Convert(string input);
	}
	
	//---------------------------------------------------------------------
	
		//! \cond EXTERN
		extern (C) {
		alias bool function(FontEnumerator obj, int encoding, bool fixedWidthOnly) Virtual_EnumerateFacenames;
		alias bool function(FontEnumerator obj, IntPtr facename) Virtual_EnumerateEncodings;
		alias bool function(FontEnumerator obj, IntPtr facename) Virtual_OnFacename;
		alias bool function(FontEnumerator obj, IntPtr facename, IntPtr encoding) Virtual_OnFontEncoding;
		}

		static extern (C) IntPtr wxFontEnumerator_ctor();
		static extern (C) void wxFontEnumerator_dtor(IntPtr self);
		static extern (C) void wxFontEnumerator_RegisterVirtual(IntPtr self, FontEnumerator obj,Virtual_EnumerateFacenames enumerateFacenames, Virtual_EnumerateEncodings enumerateEncodings, Virtual_OnFacename onFacename, Virtual_OnFontEncoding onFontEncoding);
		static extern (C) IntPtr wxFontEnumerator_GetFacenames(IntPtr self);
		static extern (C) IntPtr wxFontEnumerator_GetEncodings(IntPtr self);
		static extern (C) bool wxFontEnumerator_OnFacename(IntPtr self, string facename);
		static extern (C) bool wxFontEnumerator_OnFontEncoding(IntPtr self, string facename, string encoding);
		static extern (C) bool wxFontEnumerator_EnumerateFacenames(IntPtr self, int encoding, bool fixedWidthOnly);
		static extern (C) bool wxFontEnumerator_EnumerateEncodings(IntPtr self, string facename);
		//! \endcond
		
		//---------------------------------------------------------------------
		
	alias FontEnumerator wxFontEnumerator;
	public class FontEnumerator : wxObject
	{
		public this();
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor() ;
		public string[] Facenames();
		public string[] Encodings();
		public /+virtual+/ bool OnFacename(string facename);
		extern(C) private static bool staticDoOnFacename(FontEnumerator obj, IntPtr facename);
		public /+virtual+/ bool OnFontEncoding(string facename, string encoding);
		extern(C) private static bool staticDoOnFontEncoding(FontEnumerator obj, IntPtr facename, IntPtr encoding);
		//---------------------------------------------------------------------
		
		/*public /+virtual+/ bool EnumerateFacenames()
		{
			return EnumerateFacenames(cast(int)FontEncoding.wxFONTENCODING_SYSTEM, false);
		}
		
		public /+virtual+/ bool EnumerateFacenames(FontEncoding encoding)
		{
			return EnumerateFacenames(cast(int)encoding, false);
		}*/
		
		public /+virtual+/ bool EnumerateFacenames(FontEncoding encoding, bool fixedWidthOnly);
		extern(C) private static bool staticDoEnumerateFacenames(FontEnumerator obj, int encoding, bool fixedWidthOnly);
		//---------------------------------------------------------------------
		
		/*public /+virtual+/ bool EnumerateEncodings()
		{
			return EnumerateEncodings(IntPtr.init);
		}*/
		
		public /+virtual+/ bool EnumerateEncodings(string facename);
		extern(C) private static bool staticDoEnumerateEncodings(FontEnumerator obj, IntPtr facename);
	}
