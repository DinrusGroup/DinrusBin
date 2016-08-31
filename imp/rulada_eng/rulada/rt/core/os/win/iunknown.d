
module rt.core.os.win.iunknown;

private import rt.core.os.windows;

//pragma(lib, "uuid.lib");
pragma(lib, "rulada.lib");

alias int HRESULT;
alias HRESULT УР;

enum : int
{
	S_OK = 0,
	E_NOINTERFACE = cast(int)0x80004002,
}

alias GUID ГУИД;
struct GUID {          // size is 16
    align(1):
	DWORD Data1;
	WORD   Data2;
	WORD   Data3;
	BYTE  Data4[8];
}

alias GUID IID;
alias IID ИИД;

extern  (C)
{
    extern  IID IID_IUnknown;
}

alias IUnknown ИАноним;
class IUnknown
{

    HRESULT QueryInterface(IID* riid, out IUnknown pvObject)
    {
	if (riid == &IID_IUnknown)
	{
	    pvObject = this;
	    AddRef();
	    return S_OK;
	}
	else
	{   pvObject = null;
	    return E_NOINTERFACE;
	}
    }
	
    ULONG AddRef()
    {
	return ++count;
    }	
	
    ULONG Release()
    {
	if (--count == 0)
	{
	    // free object
	    return 0;
	}
	return count;
    }
	
    цел ОпросиИнтерфейс(ИИД* риид, out ИАноним пвОбъект)
	{
	return cast(цел) QueryInterface(cast(IID*) риид, cast(IUnknown) пвОбъект);
	}
	
	бцел ДобавьСсылку()
	{
	return cast(бцел) AddRef();
	}

	
	бцел Отпусти()
	{
	return cast(бцел) Release();
	}

    int count = 1;
	alias count счёт;
}
