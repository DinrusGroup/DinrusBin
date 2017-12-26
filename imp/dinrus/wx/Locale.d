module wx.Locale;
public import wx.common;
public import wx.Font;

	public enum Language
	{
		wxLANGUAGE_DEFAULT,
		wxLANGUAGE_UNKNOWN,
		
		wxLANGUAGE_ABKHAZIAN,
		wxLANGUAGE_AFAR,
		wxLANGUAGE_AFRIKAANS,
		wxLANGUAGE_ALBANIAN,
		wxLANGUAGE_AMHARIC,
		wxLANGUAGE_ARABIC,
		wxLANGUAGE_ARABIC_ALGERIA,
		wxLANGUAGE_ARABIC_BAHRAIN,
		wxLANGUAGE_ARABIC_EGYPT,
		wxLANGUAGE_ARABIC_IRAQ,
		wxLANGUAGE_ARABIC_JORDAN,
		wxLANGUAGE_ARABIC_KUWAIT,
		wxLANGUAGE_ARABIC_LEBANON,
		wxLANGUAGE_ARABIC_LIBYA,
		wxLANGUAGE_ARABIC_MOROCCO,
		wxLANGUAGE_ARABIC_OMAN,
		wxLANGUAGE_ARABIC_QATAR,
		wxLANGUAGE_ARABIC_SAUDI_ARABIA,
		wxLANGUAGE_ARABIC_SUDAN,
		wxLANGUAGE_ARABIC_SYRIA,
		wxLANGUAGE_ARABIC_TUNISIA,
		wxLANGUAGE_ARABIC_UAE,
		wxLANGUAGE_ARABIC_YEMEN,
		wxLANGUAGE_ARMENIAN,
		wxLANGUAGE_ASSAMESE,
		wxLANGUAGE_AYMARA,
		wxLANGUAGE_AZERI,
		wxLANGUAGE_AZERI_CYRILLIC,
		wxLANGUAGE_AZERI_LATIN,
		wxLANGUAGE_BASHKIR,
		wxLANGUAGE_BASQUE,
		wxLANGUAGE_BELARUSIAN,
		wxLANGUAGE_BENGALI,
		wxLANGUAGE_BHUTANI,
		wxLANGUAGE_BIHARI,
		wxLANGUAGE_BISLAMA,
		wxLANGUAGE_BRETON,
		wxLANGUAGE_BULGARIAN,
		wxLANGUAGE_BURMESE,
		wxLANGUAGE_CAMBODIAN,
		wxLANGUAGE_CATALAN,
		wxLANGUAGE_CHINESE,
		wxLANGUAGE_CHINESE_SIMPLIFIED,
		wxLANGUAGE_CHINESE_TRADITIONAL,
		wxLANGUAGE_CHINESE_HONGKONG,
		wxLANGUAGE_CHINESE_MACAU,
		wxLANGUAGE_CHINESE_SINGAPORE,
		wxLANGUAGE_CHINESE_TAIWAN,
		wxLANGUAGE_CORSICAN,
		wxLANGUAGE_CROATIAN,
		wxLANGUAGE_CZECH,
		wxLANGUAGE_DANISH,
		wxLANGUAGE_DUTCH,
		wxLANGUAGE_DUTCH_BELGIAN,
		wxLANGUAGE_ENGLISH,
		wxLANGUAGE_ENGLISH_UK,
		wxLANGUAGE_ENGLISH_US,
		wxLANGUAGE_ENGLISH_AUSTRALIA,
		wxLANGUAGE_ENGLISH_BELIZE,
		wxLANGUAGE_ENGLISH_BOTSWANA,
		wxLANGUAGE_ENGLISH_CANADA,
		wxLANGUAGE_ENGLISH_CARIBBEAN,
		wxLANGUAGE_ENGLISH_DENMARK,
		wxLANGUAGE_ENGLISH_EIRE,
		wxLANGUAGE_ENGLISH_JAMAICA,
		wxLANGUAGE_ENGLISH_NEW_ZEALAND,
		wxLANGUAGE_ENGLISH_PHILIPPINES,
		wxLANGUAGE_ENGLISH_SOUTH_AFRICA,
		wxLANGUAGE_ENGLISH_TRINIDAD,
		wxLANGUAGE_ENGLISH_ZIMBABWE,
		wxLANGUAGE_ESPERANTO,
		wxLANGUAGE_ESTONIAN,
		wxLANGUAGE_FAEROESE,
		wxLANGUAGE_FARSI,
		wxLANGUAGE_FIJI,
		wxLANGUAGE_FINNISH,
		wxLANGUAGE_FRENCH,
		wxLANGUAGE_FRENCH_BELGIAN,
		wxLANGUAGE_FRENCH_CANADIAN,
		wxLANGUAGE_FRENCH_LUXEMBOURG,
		wxLANGUAGE_FRENCH_MONACO,
		wxLANGUAGE_FRENCH_SWISS,
		wxLANGUAGE_FRISIAN,
		wxLANGUAGE_GALICIAN,
		wxLANGUAGE_GEORGIAN,
		wxLANGUAGE_GERMAN,
		wxLANGUAGE_GERMAN_AUSTRIAN,
		wxLANGUAGE_GERMAN_BELGIUM,
		wxLANGUAGE_GERMAN_LIECHTENSTEIN,
		wxLANGUAGE_GERMAN_LUXEMBOURG,
		wxLANGUAGE_GERMAN_SWISS,
		wxLANGUAGE_GREEK,
		wxLANGUAGE_GREENLANDIC,
		wxLANGUAGE_GUARANI,
		wxLANGUAGE_GUJARATI,
		wxLANGUAGE_HAUSA,
		wxLANGUAGE_HEBREW,
		wxLANGUAGE_HINDI,
		wxLANGUAGE_HUNGARIAN,
		wxLANGUAGE_ICELANDIC,
		wxLANGUAGE_INDONESIAN,
		wxLANGUAGE_INTERLINGUA,
		wxLANGUAGE_INTERLINGUE,
		wxLANGUAGE_INUKTITUT,
		wxLANGUAGE_INUPIAK,
		wxLANGUAGE_IRISH,
		wxLANGUAGE_ITALIAN,
		wxLANGUAGE_ITALIAN_SWISS,
		wxLANGUAGE_JAPANESE,
		wxLANGUAGE_JAVANESE,
		wxLANGUAGE_KANNADA,
		wxLANGUAGE_KASHMIRI,
		wxLANGUAGE_KASHMIRI_INDIA,
		wxLANGUAGE_KAZAKH,
		wxLANGUAGE_KERNEWEK,
		wxLANGUAGE_KINYARWANDA,
		wxLANGUAGE_KIRGHIZ,
		wxLANGUAGE_KIRUNDI,
		wxLANGUAGE_KONKANI,
		wxLANGUAGE_KOREAN,
		wxLANGUAGE_KURDISH,
		wxLANGUAGE_LAOTHIAN,
		wxLANGUAGE_LATIN,
		wxLANGUAGE_LATVIAN,
		wxLANGUAGE_LINGALA,
		wxLANGUAGE_LITHUANIAN,
		wxLANGUAGE_MACEDONIAN,
		wxLANGUAGE_MALAGASY,
		wxLANGUAGE_MALAY,
		wxLANGUAGE_MALAYALAM,
		wxLANGUAGE_MALAY_BRUNEI_DARUSSALAM,
		wxLANGUAGE_MALAY_MALAYSIA,
		wxLANGUAGE_MALTESE,
		wxLANGUAGE_MANIPURI,
		wxLANGUAGE_MAORI,
		wxLANGUAGE_MARATHI,
		wxLANGUAGE_MOLDAVIAN,
		wxLANGUAGE_MONGOLIAN,
		wxLANGUAGE_NAURU,
		wxLANGUAGE_NEPALI,
		wxLANGUAGE_NEPALI_INDIA,
		wxLANGUAGE_NORWEGIAN_BOKMAL,
		wxLANGUAGE_NORWEGIAN_NYNORSK,
		wxLANGUAGE_OCCITAN,
		wxLANGUAGE_ORIYA,
		wxLANGUAGE_OROMO,
		wxLANGUAGE_PASHTO,
		wxLANGUAGE_POLISH,
		wxLANGUAGE_PORTUGUESE,
		wxLANGUAGE_PORTUGUESE_BRAZILIAN,
		wxLANGUAGE_PUNJABI,
		wxLANGUAGE_QUECHUA,
		wxLANGUAGE_RHAETO_ROMANCE,
		wxLANGUAGE_ROMANIAN,
		wxLANGUAGE_RUSSIAN,
		wxLANGUAGE_RUSSIAN_UKRAINE,
		wxLANGUAGE_SAMOAN,
		wxLANGUAGE_SANGHO,
		wxLANGUAGE_SANSKRIT,
		wxLANGUAGE_SCOTS_GAELIC,
		wxLANGUAGE_SERBIAN,
		wxLANGUAGE_SERBIAN_CYRILLIC,
		wxLANGUAGE_SERBIAN_LATIN,
		wxLANGUAGE_SERBO_CROATIAN,
		wxLANGUAGE_SESOTHO,
		wxLANGUAGE_SETSWANA,
		wxLANGUAGE_SHONA,
		wxLANGUAGE_SINDHI,
		wxLANGUAGE_SINHALESE,
		wxLANGUAGE_SISWATI,
		wxLANGUAGE_SLOVAK,
		wxLANGUAGE_SLOVENIAN,
		wxLANGUAGE_SOMALI,
		wxLANGUAGE_SPANISH,
		wxLANGUAGE_SPANISH_ARGENTINA,
		wxLANGUAGE_SPANISH_BOLIVIA,
		wxLANGUAGE_SPANISH_CHILE,
		wxLANGUAGE_SPANISH_COLOMBIA,
		wxLANGUAGE_SPANISH_COSTA_RICA,
		wxLANGUAGE_SPANISH_DOMINICAN_REPUBLIC,
		wxLANGUAGE_SPANISH_ECUADOR,
		wxLANGUAGE_SPANISH_EL_SALVADOR,
		wxLANGUAGE_SPANISH_GUATEMALA,
		wxLANGUAGE_SPANISH_HONDURAS,
		wxLANGUAGE_SPANISH_MEXICAN,
		wxLANGUAGE_SPANISH_MODERN,
		wxLANGUAGE_SPANISH_NICARAGUA,
		wxLANGUAGE_SPANISH_PANAMA,
		wxLANGUAGE_SPANISH_PARAGUAY,
		wxLANGUAGE_SPANISH_PERU,
		wxLANGUAGE_SPANISH_PUERTO_RICO,
		wxLANGUAGE_SPANISH_URUGUAY,
		wxLANGUAGE_SPANISH_US,
		wxLANGUAGE_SPANISH_VENEZUELA,
		wxLANGUAGE_SUNDANESE,
		wxLANGUAGE_SWAHILI,
		wxLANGUAGE_SWEDISH,
		wxLANGUAGE_SWEDISH_FINLAND,
		wxLANGUAGE_TAGALOG,
		wxLANGUAGE_TAJIK,
		wxLANGUAGE_TAMIL,
		wxLANGUAGE_TATAR,
		wxLANGUAGE_TELUGU,
		wxLANGUAGE_THAI,
		wxLANGUAGE_TIBETAN,
		wxLANGUAGE_TIGRINYA,
		wxLANGUAGE_TONGA,
		wxLANGUAGE_TSONGA,
		wxLANGUAGE_TURKISH,
		wxLANGUAGE_TURKMEN,
		wxLANGUAGE_TWI,
		wxLANGUAGE_UIGHUR,
		wxLANGUAGE_UKRAINIAN,
		wxLANGUAGE_URDU,
		wxLANGUAGE_URDU_INDIA,
		wxLANGUAGE_URDU_PAKISTAN,
		wxLANGUAGE_UZBEK,
		wxLANGUAGE_UZBEK_CYRILLIC,
		wxLANGUAGE_UZBEK_LATIN,
		wxLANGUAGE_VIETNAMESE,
		wxLANGUAGE_VOLAPUK,
		wxLANGUAGE_WELSH,
		wxLANGUAGE_WOLOF,
		wxLANGUAGE_XHOSA,
		wxLANGUAGE_YIDDISH,
		wxLANGUAGE_YORUBA,
		wxLANGUAGE_ZHUANG,
		wxLANGUAGE_ZULU,
		
		wxLANGUAGE_USER_DEFINED
	}
	
	//-----------------------------------------------------------------------------
	
	public enum LocaleCategory
	{
		wxLOCALE_CAT_NUMBER,
		wxLOCALE_CAT_DATE,
		wxLOCALE_CAT_MONEY,
		wxLOCALE_CAT_MAX
	}
	
	//-----------------------------------------------------------------------------

	public enum LocaleInfo
	{
		wxLOCALE_THOUSANDS_SEP,
		wxLOCALE_DECIMAL_POINT
	}
	
	//-----------------------------------------------------------------------------

	public enum LocaleInitFlags
	{
		wxLOCALE_LOAD_DEFAULT  = 0x0001,    
		wxLOCALE_CONV_ENCODING = 0x0002    
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxLanguageInfo_ctor();
		static extern (C) void   wxLanguageInfo_dtor(IntPtr self);
		static extern (C) void   wxLanguageInfo_SetLanguage(IntPtr self, int value);
		static extern (C) int    wxLanguageInfo_GetLanguage(IntPtr self);
		static extern (C) void   wxLanguageInfo_SetCanonicalName(IntPtr self, string name);
		static extern (C) IntPtr wxLanguageInfo_GetCanonicalName(IntPtr self);
		static extern (C) void   wxLanguageInfo_SetDescription(IntPtr self, string name);
		static extern (C) IntPtr wxLanguageInfo_GetDescription(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias LanguageInfo wxLanguageInfo;
	public class LanguageInfo : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public static wxObject New(IntPtr ptr);
		override protected void dtor();
		public int language() ;
		public void language(int value) ;
		public string CanonicalName() ;
		public void CanonicalName(string value) ;
		public string Description() ;
		public void Description(string value) ;
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxLocale_ctor();
		static extern (C) IntPtr wxLocale_ctor2(int language, int flags);
		static extern (C) void   wxLocale_dtor(IntPtr self);
		static extern (C) bool   wxLocale_Init(IntPtr self, int language, int flags);
		static extern (C) bool   wxLocale_AddCatalog(IntPtr self, string szDomain);
		static extern (C) bool   wxLocale_AddCatalog2(IntPtr self, string szDomain, int msgIdLanguage, string msgIdCharset);
		static extern (C) void   wxLocale_AddCatalogLookupPathPrefix(IntPtr self, string prefix);
		static extern (C) void   wxLocale_AddLanguage(IntPtr info);
		static extern (C) IntPtr wxLocale_FindLanguageInfo(string locale);
		static extern (C) IntPtr wxLocale_GetCanonicalName(IntPtr self);
		static extern (C) int    wxLocale_GetLanguage(IntPtr self);
		static extern (C) IntPtr wxLocale_GetLanguageInfo(int lang);
		static extern (C) IntPtr wxLocale_GetLanguageName(int lang);
		static extern (C) IntPtr wxLocale_GetLocale(IntPtr self);
		static extern (C) IntPtr wxLocale_GetName(IntPtr self);
		static extern (C) IntPtr wxLocale_GetString(IntPtr self, string szOrigString, string szDomain);
		static extern (C) IntPtr wxLocale_GetHeaderValue(IntPtr self, string szHeader, string szDomain);
		static extern (C) IntPtr wxLocale_GetSysName(IntPtr self);
		static extern (C) int    wxLocale_GetSystemEncoding();
		static extern (C) IntPtr wxLocale_GetSystemEncodingName();
		static extern (C) int    wxLocale_GetSystemLanguage();
		static extern (C) bool   wxLocale_IsLoaded(IntPtr self, string domain);
		static extern (C) bool   wxLocale_IsOk(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias Locale wxLocale;
	public class Locale : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public this(int language);
		public this(int language, LocaleInitFlags flags);
		override protected void dtor();
		public bool Init();
		public bool Init(Language language);
		public bool Init(Language language, LocaleInitFlags flags);
		public bool AddCatalog(string szDomain);
		public bool AddCatalog(string szDomain, Language msgIdLanguage, string msgIdCharset);
		public void AddCatalogLookupPathPrefix(string prefix);
		public static void AddLanguage(LanguageInfo info);
		public static LanguageInfo FindLanguageInfo(string locale);
		public string CanonicalName() ;
		public Language language() ;
		public static LanguageInfo GetLanguageInfo(Language lang);
		public static string GetLanguageName(Language lang);
		public string GetLocale();
		public string Name();
		public string GetString(string szOrigString);
		public string GetString(string szOrigString, string szDomain);
		public string GetHeaderValue(string szHeader);
		public string GetHeaderValue(string szHeader, string szDomain);
		public string SysName() ;
		static FontEncoding SystemEncoding();
		static string SystemEncodingName() ;
		static Language SystemLanguage() ;
		public bool IsLoaded(string domain);
		public bool IsOk() ;
	}
