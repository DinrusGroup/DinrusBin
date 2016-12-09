//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.data;

private import viz.common, viz.app;


extern(D) class ФорматыДанных
{
	static class Формат
	{
		final цел id();
		final Ткст имя();
		this(){}
	}
	
	
	static:
	
	Ткст битмап();
	Ткст dib() ;
	Ткст dif() ;
	Ткст enhandedMetaFile() ;
	Ткст fileDrop() ;
	Ткст html() ;
	Ткст locale();
	Ткст metafilePict() ;
	Ткст oemText() ;
	Ткст palette() ;	
	Ткст penData();
	Ткст riff();
	Ткст rtf() ;
	Ткст stringFormat() ;
	Ткст utf8();	
	Ткст symbolicLink();
	Ткст текст();	
	Ткст tiff() ;
	Ткст текстЮникод() ;	
	Ткст waveAudio();
	Формат дайФормат(цел id);
	Формат дайФормат(Ткст имя);
	Формат дайФормат(ИнфОТипе тип);
		
	this()	{}
}

extern(D) struct Данные // docmain
{

	ИнфОТипе инфо();
	проц[] значение();
	static Данные opCall(...);
	T дайЗначение(T)()
	{
		assert(инфо().tsize == T.sizeof);
		return *cast(T*) значение();
	}
	
	Ткст дайТкст();
	alias дайТкст дайЮ8;

	ббайт[] дайТекст();
	Шткст дайТекстВЮникоде();
	цел дайЦел();
	цел дайБцел();
	Ткст[] дайТксты();
	Объект дайОбъект();
}

extern(D) class ОбъектДанных: ИОбъектДанных
{
	Данные получитьДанные(Ткст фмт);	
	Данные получитьДанные(ИнфОТипе тип);
	Данные получитьДанные(Ткст фмт, бул doConvert);
	бул дайИмеющиесяДанные(Ткст фмт);
	бул дайИмеющиесяДанные(ИнфОТипе тип);
	бул дайИмеющиесяДанные(Ткст фмт, бул можноПреобразовать);
	Ткст[] дайФорматы();
	проц установиДанные(Данные объ);
	проц установиДанные(Ткст фмт, Данные объ);
	проц установиДанные(ИнфОТипе тип, Данные объ);
	проц установиДанные(Ткст фмт, бул можноПреобразовать, Данные объ);
}

extern(D) class КомВОбъектДанных: ИОбъектДанных
{
	this(winapi.IDataObject объДанных);	
	~this();
	Данные получитьДанные(Ткст фмт);
	Данные получитьДанные(ИнфОТипе тип);	
	Данные получитьДанные(Ткст фмт, бул doConvert);
	бул дайИмеющиесяДанные(Ткст фмт);
	бул дайИмеющиесяДанные(ИнфОТипе тип);
	бул дайИмеющиесяДанные(Ткст фмт, бул можноПреобразовать);
	Ткст[] дайФорматы();
	проц установиДанные(Данные объ);
	проц установиДанные(Ткст фмт, Данные объ);
	проц установиДанные(ИнфОТипе тип, Данные объ);
	проц установиДанные(Ткст фмт, бул можноПреобразовать, Данные объ);
	final бул такойЖеОбъектДанных_ли(winapi.IDataObject объДанных);
}

extern(D) class DtoComDataObject: ВизКомОбъект, winapi.IDataObject 
{
	this(ИОбъектДанных объДанных);
	
	extern(Windows):
	
	override HRESULT QueryInterface(IID* riid, проц** ppv);	
	HRESULT GetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium);
	HRESULT GetDataHere(FORMATETC* pFormatetc, STGMEDIUM* pmedium);
	HRESULT QueryGetData(FORMATETC* pFormatetc);
	HRESULT GetCanonicalFormatEtc(FORMATETC* pFormatetcIn, FORMATETC* pFormatetcOut);
	HRESULT SetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium, BOOL fRelease);
	HRESULT EnumFormatEtc(DWORD dwDirection, winapi.IEnumFORMATETC* ppenumFormatetc);
	HRESULT DAdvise(FORMATETC* pFormatetc, DWORD advf, winapi.IAdviseSink pAdvSink, DWORD* pdwConnection);
	HRESULT DUnadvise(DWORD dwConnection);
	HRESULT EnumDAdvise(winapi.IEnumSTATDATA* ppenumAdvise);
}

