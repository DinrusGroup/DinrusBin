// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.data;

private import os.win.gui.x.dlib;

private import os.win.gui.base, os.win.gui.x.winapi, os.win.gui.x.wincom, os.win.gui.application,
	os.win.gui.x.utf, os.win.gui.x.com;


///
class DataFormats // docmain
{
	///
	static class Format // docmain
	{
		/// Data format ID number.
		final int id();
		
		/// Data format name.
		final Dstring name() ;
		
		
		package:
		int _id;
		Dstring _name;
		
		
		this();
	}
	
	
	static:
	
	/// Predefined data formats.
	Dstring bitmap() ;
	
	/+
	/// ditto
	Dstring commaSeparatedValue();
	+/
	
	/// ditto
	Dstring dib() ;
	
	/// ditto
	Dstring dif();
	/// ditto
	Dstring enhandedMetaFile() ;
	/// ditto
	Dstring fileDrop() ;
	/// ditto
	Dstring html() ;
	
	/// ditto
	Dstring locale();
	
	/// ditto
	Dstring metafilePict() ;
	
	/// ditto
	Dstring oemText() ;
	
	/// ditto
	Dstring palette() ;
	/// ditto
	Dstring penData() ;
	
	/// ditto
	Dstring riff();
	
	/// ditto
	Dstring rtf();
	
	/+
	/// ditto
	Dstring serializable();
	+/
	
	/// ditto
	Dstring stringFormat() ;
	/// ditto
	Dstring utf8() ;
	/// ditto
	Dstring symbolicLink() ;
	
	/// ditto
	Dstring text() ;
	/// ditto
	Dstring tiff() ;
	/// ditto
	Dstring unicodeText();
	
	/// ditto
	Dstring waveAudio() ;
	
	// Assumes _init() was already called and
	// -id- is not in -fmts-.
	private Format _didntFindId(int id);
	
	
	///
	Format getFormat(int id);
	
	/// ditto
	// Creates the format name if it doesn't exist.
	Format getFormat(Dstring name);
	
	/// ditto
	// Extra.
	Format getFormat(TypeInfo type);
	
	private:
	Format[int] fmts; // Indexed by identifier. Must _init() before accessing!
	
	
	void _init();
	
	// Does not get the name of one of the predefined constant ones.
	Dstring getName(int id);
	
	package Format getFormatFromType(TypeInfo type);
	
	private Dstring[] getHDropStrings(void[] value);
	
	// Convert clipboard -value- to Data.
	Data getDataFromFormat(int id, void[] value);
	
	void[] getCbFileDrop(Dstring[] fileNames);
	// Value the clipboard wants.
	void[] getClipboardValueFromData(int id, Data data);
	
	this();
}


private template stopAtNull(T)
{
	T[] stopAtNull(T[] array)
	{
		int i;
		for(i = 0; i != array.length; i++)
		{
			if(!array[i])
				return array[0 .. i];
		}
		//return null;
		throw new DflException("Invalid data"); // ?
	}
}


/// Data structure for holding data in a raw format with type information.
struct Data // docmain
{
	/// Information about the data type.
	TypeInfo info() ;
	
	
	/// The data's raw value.
	void[] value();
	
	/// Construct a new Data structure.
	static Data opCall(...);
	
	///
	T getValue(T)()
	{
		assert(_info.tsize == T.sizeof);
		return *cast(T*)_value;
	}
	
	/// ditto
	// UTF-8.
	Dstring getString();
	
	/// ditto
	alias getString getUtf8;
	/// ditto
	deprecated alias getString getUTF8;
	
	/// ditto
	// ANSI text.
	ubyte[] getText();
	
	/// ditto
	Dwstring getUnicodeText();
	
	/// ditto
	int getInt();
	
	/// ditto
	int getUint();
	
	/// ditto
	Dstring[] getStrings();
	
	/// ditto
	Object getObject();
	
	private:
	TypeInfo _info;
	void* _value;
}


/+
interface IDataFormat
{
	
}
+/


/// Interface to a data object. The data can have different formats by setting different formats.
interface IDataObject // docmain
{
	///
	Data getData(Dstring fmt);
	/// ditto
	Data getData(TypeInfo type);
	/// ditto
	Data getData(Dstring fmt, bool doConvert);
	
	///
	bool getDataPresent(Dstring fmt); // Check.
	/// ditto
	bool getDataPresent(TypeInfo type); // Check.
	/// ditto
	bool getDataPresent(Dstring fmt, bool canConvert); // Check.
	
	///
	Dstring[] getFormats();
	//Dstring[] getFormats(bool onlyNative);
	
	///
	void setData(Data obj);
	/// ditto
	void setData(Dstring fmt, Data obj);
	/// ditto
	void setData(TypeInfo type, Data obj);
	/// ditto
	void setData(Dstring fmt, bool canConvert, Data obj);
}


///
class DataObject: os.win.gui.data.IDataObject // docmain
{
	///
	Data getData(Dstring fmt);
	
	/// ditto
	Data getData(TypeInfo type);
	/// ditto
	Data getData(Dstring fmt, bool doConvert);
	
	
	///
	bool getDataPresent(Dstring fmt);
	/// ditto
	bool getDataPresent(TypeInfo type);
	/// ditto
	bool getDataPresent(Dstring fmt, bool canConvert);
	
	
	///
	Dstring[] getFormats();
	
	// TO-DO: remove...
	deprecated final Dstring[] getFormats(bool onlyNative);
	
	package final void _setData(Dstring fmt, Data obj, bool replace = true);
	///
	void setData(Data obj);
	
	/// ditto
	void setData(Dstring fmt, Data obj);
	
	/// ditto
	void setData(TypeInfo type, Data obj);
	
	/// ditto
	void setData(Dstring fmt, bool canConvert, Data obj);
	
	
	private:
	struct Pair
	{
		Dstring fmt;
		Data obj;
	}
	
	
	Pair[] all;
	
	
	void fixPairEntry(inout Pair pr);
	
	int find(Dstring fmt, bool fix = true);
}


private struct _DataConvert
{
	Data data;
}


package void _canConvertFormats(Dstring fmt, void delegate(Dstring cfmt) callback);

package Data _doConvertFormat(Data dat, Dstring toFmt);
class ComToDdataObject: os.win.gui.data.IDataObject // package
{
	this(os.win.gui.x.wincom.IDataObject dataObj);
	
	~this();
	
	
	private Data _getData(int id);
	
	Data getData(Dstring fmt);
	
	Data getData(TypeInfo type);
	
	
	Data getData(Dstring fmt, bool doConvert);
	
	
	private bool _getDataPresent(int id);
	
	bool getDataPresent(Dstring fmt);
	
	bool getDataPresent(TypeInfo type);
	
	bool getDataPresent(Dstring fmt, bool canConvert);
	
	Dstring[] getFormats();
	
	// TO-DO: remove...
	deprecated final Dstring[] getFormats(bool onlyNative);
	
	private void _setData(int id, Data obj);
	
	void setData(Data obj);
	
	void setData(Dstring fmt, Data obj);
	
	void setData(TypeInfo type, Data obj);
	
	void setData(Dstring fmt, bool canConvert, Data obj);
	
	final bool isSameDataObject(os.win.gui.x.wincom.IDataObject dataObj);
	
	
	private:
	os.win.gui.x.wincom.IDataObject dataObj;
}


package class EnumDataObjectFORMATETC: DflComObject, IEnumFORMATETC
{
	this(os.win.gui.data.IDataObject dataObj, Dstring[] fmts, ULONG start);
	
	this(os.win.gui.data.IDataObject dataObj);
	
	extern(Windows):
	override HRESULT QueryInterface(IID* riid, void** ppv);
	
	HRESULT Next(ULONG celt, FORMATETC* rgelt, ULONG* pceltFetched);
	
	HRESULT Skip(ULONG celt);
	
	HRESULT Reset();
	
	
	HRESULT Clone(IEnumFORMATETC* ppenum);
	
	extern(D):
	
	private:
	os.win.gui.data.IDataObject dataObj;
	Dstring[] fmts;
	ULONG idx;
}


class DtoComDataObject: DflComObject, os.win.gui.x.wincom.IDataObject // package
{
	this(os.win.gui.data.IDataObject dataObj);
	
	
	extern(Windows):
	
	override HRESULT QueryInterface(IID* riid, void** ppv);
	
	HRESULT GetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium);
	
	HRESULT GetDataHere(FORMATETC* pFormatetc, STGMEDIUM* pmedium);
	
	HRESULT QueryGetData(FORMATETC* pFormatetc);
	
	HRESULT GetCanonicalFormatEtc(FORMATETC* pFormatetcIn, FORMATETC* pFormatetcOut);
	
	HRESULT SetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium, BOOL fRelease);
	
	HRESULT EnumFormatEtc(DWORD dwDirection, IEnumFORMATETC* ppenumFormatetc);
	
	HRESULT DAdvise(FORMATETC* pFormatetc, DWORD advf, IAdviseSink pAdvSink, DWORD* pdwConnection);
	
	HRESULT DUnadvise(DWORD dwConnection);
	
	HRESULT EnumDAdvise(IEnumSTATDATA* ppenumAdvise);
	
	extern(D):
	
	private:
	os.win.gui.data.IDataObject dataObj;
}

