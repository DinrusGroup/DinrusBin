
module viz.common;
public import stdrus, cidrus, sys.DStructs, sys.DConsts, tpl.all, tpl.stream, viz.consts, viz.iface, viz.event, viz.graphics, viz.structs, viz.collections, winapi, sys.DIfaces: ПотокВвода, ПотокВывода;

version = VIZ_UNICODE;

template ФобосТрэтс()
	{
		static if(!is(КортежТипаПараметров!(function() { })))
		{
			// Grabbed from std.traits since Dinrus's meta.Traits lacks these:
			
			template КортежТипаПараметров(alias дг)
			{
				alias КортежТипаПараметров!(typeof(дг)) КортежТипаПараметров;
			}
			
			/** ditto */
			template КортежТипаПараметров(дг)
			{
				static if (is(дг P == function))
					alias P КортежТипаПараметров;
				else static if (is(дг P == delegate))
					alias КортежТипаПараметров!(P) КортежТипаПараметров;
				else static if (is(дг P == P*))
					alias КортежТипаПараметров!(P) КортежТипаПараметров;
				else
					static assert(0, "у аргумента отсутствуют параметры");
			}
		}
	}
	
	mixin ФобосТрэтс;
	
alias ВозврТип!(Объект.opEquals) т_равно; 	

extern(D):
		
class ВизИскл: Исключение // docmain
{
		this(Ткст сооб);		
}

class ИсклЗависанияWindows: ВизИскл
	{
		this(Ткст сооб);
	}
			
Ткст дайТкстОбъекта(Объект o);	
Ткст бцелВГексТкст(бцел num);		
ткст0 небезопВТкст0(Ткст s);

abstract class ЖдиУк
{
	const цел ТАЙМАУТ_ОЖИДАНИЯ = 258; 

	this();		
	this(ук h, бул owned = да);	
	ук указатель();		
	проц указатель(ук h) ;
	проц закрой();
	~this();
	static проц ждиВсе(ЖдиУк[] уки);		
	static проц ждиВсе(ЖдиУк[] уки, бцел msTimeout);		
	static цел ждиЛюбое(ЖдиУк[] уки);
	static цел ждиЛюбое(ЖдиУк[] уки, бцел msTimeout);		
	проц ждиОдно();
	проц ждиОдно(бцел msTimeout);
}

class Курсор // docmain
{

	this(УКурсор hcur, бул owned = да);	
	~this();	
	проц вымести();	
	static проц текущий(Курсор cur);		
	static Курсор текущий() ;	
	static проц клип(Прям к) ;
	static Прям клип() ;	
	final УКурсор указатель() ;
	final проц рисуй(Графика з, Точка тчк);	
	final проц рисуйРастяни(Графика з, Прям к);
	override т_рав opEquals(Объект o);	
	т_рав opEquals(Курсор cur);
	static проц скрой();
	static проц покажи();
	static проц положение(Точка тчк);
	static Точка положение();
}

class Курсоры 
{
	private this();

	Курсор пускПриложения();
	Курсор стрелка() ;
	Курсор крест();
	Курсор дефолтныйКурсор();
	Курсор рука();
	Курсор помощь() ;
	Курсор гСплит();
	Курсор вСплит();		
	Курсор айБим();
	Курсор к_нет() ;
	Курсор sizeAll() ;	
	Курсор sizeNESW();
	Курсор sizeNS();	
	Курсор sizeNWSE() ;	
	Курсор sizeWE();	
	Курсор ждиКурсор();
}

template _getlen(T)
{
	т_мера _getlen(T* tz)
	in
	{
		assert(tz);
	}
	body
	{
		T* p;
		for(p = tz; *p; p++)
		{
		}
		return p - tz;
	}
}


Ткст0 небезопТкст0(Ткст s);
Ткст юникодВАнзи(Шткст0 юникод, т_мера ulen);
Шткст анзиВЮникод(Ткст0 ansi, т_мера len);
Ткст изАнзи(Ткст0 ansi, т_мера len);
Ткст изАнзи0(Ткст0 ansiz);
Ткст0 вАнзи0(Ткст utf8, бул safe = да);
Ткст0 небезопАнзи0(Ткст utf8);
Ткст вАнзи(Ткст utf8, бул safe = да);
Ткст небезопАнзи(Ткст utf8);
Ткст изЮникода(Шткст0 юникод, т_мера len);
Ткст изЮникода0(Шткст0 unicodez);
Шткст0 вЮни0(Ткст utf8);
Шткст вЮни(Ткст utf8);
т_мера вДлинуЮникода(Ткст utf8);

HANDLE загрузиРисунок(экз hinst, Ткст имя, UINT uType, цел cxDesired, цел cyDesired, UINT fuLoa);
УОК создайОкноДоп(DWORD dwExStyle, Ткст имяКласса, Ткст windowName, DWORD dwStyle,
	цел ш, цел в, цел nWidth, цел nHeight, УОК hWndParent, HMENU hMenu, экз hInstance,
	LPVOID lpParam);
УОК создайОкно(Ткст имяКласса, Ткст windowName, DWORD dwStyle, цел ш, цел в,
	цел nWidth, цел nHeight, УОК hWndParent, HMENU hMenu, HANDLE hInstance, LPVOID lpParam);
Ткст дайТекстОкна(УОК уок);
BOOL установиТекстОкна(УОК уок, Ткст str);
Ткст дайИмяФайлаМодуля(HMODULE hmod);
Ткст emGetSelText(УОК уок, т_мера selTextLength);
Ткст дайВыделенныйТекст(УОК уок);
проц emSetPasswordChar(УОК уок, дим pwc);
дим emGetPasswordChar(УОК уок);
LRESULT шлиСооб(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam);
LRESULT шлиСооб(УОК уок, UINT сооб, WPARAM wparam, Ткст lparam, бул safe = да);
LRESULT шлиСообНебезоп(УОК уок, UINT сооб, WPARAM wparam, Ткст lparam);
LRESULT вызовиОкПроц(WNDPROC lpPrevWndFunc, УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam);
UINT регистрируйФорматБуфОбмена(Ткст formatName);
Ткст дайИмяФорматаБуфОбмена(UINT format);
цел рисуйТекстДоп(HDC hdc, Ткст текст, LPRECT lprc, UINT dwDTFormat, LPDRAWTEXTPARAMS lpDTParams);
Ткст дайКоманднуюСтроку();
BOOL установиТекущуюПапку(Ткст pathName);
Ткст дайТекущуюПапку();
Ткст дайИмяКомпьютера();
Ткст дайСистПапку();
Ткст дайИмяПользователя();
DWORD разверниСтрокиСреды(Ткст src, out Ткст результат);
Ткст дайПеременнуюСреды(Ткст имя);
цел окноСообщ(УОК уок, Ткст текст, Ткст заглавие, UINT uType);
ATOM зарегистрируйКласс(inout КлассОкна ко);
BOOL дайИнфОКлассе(экз hinst, Ткст имяКласса, inout КлассОкна ко);
deprecated BOOL getTextExtentPoint32(HDC hdc, Ткст текст, LPSIZE lpSize);
Ткст dragQueryFile(HDROP hDrop, UINT iFile);
UINT dragQueryFile(HDROP hDrop);
HANDLE создайФайл(Ткст фимя, DWORD dwDesiredAccess, DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes, DWORD dwCreationDistribution, DWORD dwFlagsAndAttributes, HANDLE hTemplateFile);
LRESULT дефОкПроц(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam);
LRESULT дефДлгПроц(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam);
LRESULT дефФреймПроц(УОК уок, УОК уокMdiClient, UINT сооб, WPARAM wparam, LPARAM lparam);
LRESULT дефМДИОтпрыскПроц(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam);
LONG dispatchMessage(СООБ* pmsg);
BOOL peekMessage(СООБ* pmsg, УОК уок = HWND.init, UINT wmFilterMin = 0, UINT wmFilterMax = 0, UINT removeMsg = PM_NOREMOVE);
BOOL getMessage(СООБ* pmsg, УОК уок = HWND.init, UINT wmFilterMin = 0, UINT wmFilterMax = 0);
BOOL isDialogMessage(УОК уок, СООБ* pmsg);
HANDLE findFirstChangeNotification(Ткст pathName, BOOL watchSubtree, DWORD notifyFilter);
Ткст getFullPathName(Ткст фимя);
экз загрузиБиблиотекуДоп(Ткст libFileName, DWORD флаги);
BOOL _setMenuItemInfoW(HMENU hMenu, UINT uItem, BOOL fByPosition, LPMENUITEMINFOW lpmii) ;
BOOL _insertMenuItemW(HMENU hMenu, UINT uItem, BOOL fByPosition, LPMENUITEMINFOW lpmii);
Ткст regQueryValueString(HKEY hkey, Ткст valueName, LPDWORD lpType = пусто);
HFONT createFontIndirect(inout ШрифтЛога шл);
цел getLogFont(HFONT hf, inout ШрифтЛога шл);
//Ошибка линковщика? Надо добавлять (_): например, _AddRef(), но в этом случае - несовпадение с интерфейсной декларацией.

extern(Windows):

class ВизКомОбъект: ComObject // package
{
	 extern(Windows):
	
	ULONG AddRef();	
	ULONG Release();

}

class ПотокВИПоток: ВизКомОбъект, winapi.IStream
{
	this(Поток sourceStream);
	
	extern(Windows):
	
	override HRESULT QueryInterface(IID* riid, проц** ppv);		
	HRESULT Read(ук pv, ULONG cb, ULONG* pcbRead);	
	HRESULT Write(ук pv, ULONG cb, ULONG* pcbWritten);
	HRESULT Seek(LARGE_INTEGER dlibMove, DWORD dwOrigin, ULARGE_INTEGER* plibNewPosition);	
	HRESULT SetSize(ULARGE_INTEGER libNewSize);	
	HRESULT CopyTo(winapi.IStream pstm, ULARGE_INTEGER cb, ULARGE_INTEGER* pcbRead, ULARGE_INTEGER* pcbWritten);	
	HRESULT Commit(DWORD grfCommitFlags);	
	HRESULT Revert();	
	HRESULT LockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType);	
	HRESULT UnlockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType);	
	HRESULT Stat(STATSTG* pstatstg, DWORD grfStatFlag);	
	HRESULT Clone(winapi.IStream* ppstm);	

}

class ИПотокПамяти: ВизКомОбъект, winapi.IStream
{
	this(проц[] memory);
	бул впределах(long поз);
	
	extern(Windows):
	
	HRESULT QueryInterface(IID* riid, проц** ppv);	
	HRESULT Read(ук pv, ULONG cb, ULONG* pcbRead);	
	HRESULT Write(ук pv, ULONG cb, ULONG* pcbWritten);
	HRESULT Seek(LARGE_INTEGER dlibMove, DWORD dwOrigin, ULARGE_INTEGER* plibNewPosition);	
	HRESULT SetSize(ULARGE_INTEGER libNewSize);	
	HRESULT CopyTo(winapi.IStream pstm, ULARGE_INTEGER cb, ULARGE_INTEGER* pcbRead, ULARGE_INTEGER* pcbWritten);
	HRESULT Commit(DWORD grfCommitFlags);	
	HRESULT Revert();	
	HRESULT LockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType);	
	HRESULT UnlockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType);	
	HRESULT Stat(STATSTG* pstatstg, DWORD grfStatFlag);	
	HRESULT Clone(winapi.IStream* ppstm);	
	
}

