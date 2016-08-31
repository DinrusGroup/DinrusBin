module os.win32.activex;
/***************************************************************
 * $HeadURL: http://svn.dsource.org/projects/core32/trunk/activex/activex.d $
 * $Revision: 39 $
 * $Date: 2009-05-23 02:44:15 +0400 (Сб, 23 май 2009) $
 * $Author: l8night $
 */

private:
//import std.array; /* for ArrayBoundsError */
import std.stdarg;
//import std.string;
//import std.utf;
//import std.io; /* for writefln */

public import os.win32.winnt, os.win32.winnls, os.win32.uuid, os.win32.wtypes, os.win32.basetyps;
public import os.win32.oaidl, os.win32.objbase; /* for VARIANTARG */

pragma(lib, "rulada.lib");


public:
class AXO
{
    private static LCID defaultLCID;

    static this()
    {
        defaultLCID = GetUserDefaultLCID();
        CoInitialize(null);
    }

    static ~this()
    {
        CoUninitialize();
    }

    struct MemberDef
    {
        char [] name;
        DISPID dispid;
        INVOKEKIND invkind;
        FUNCDESC * pFuncDesc;
    }

    private ITypeInfo [FUNCDESC *] allFuncDescs;
    private ITypeInfo typeInfo;
    private IDispatch pIDispatch;
    private MemberDef [] allMembers;
    private char[] [ DISPID ] methods;
    private char[] [ DISPID ] getters;
        private SHORT [ DISPID ] returns;
    private char[] [ DISPID ] setters;
    private char[] [ DISPID ] settersbyref;

    this(char [] appName);

    ~this();

    void loadMembers();

    void loadMembers(ITypeInfo pTypeInfo);

	public void showMembers();
	
    VARIANTARG [] makeArray(TypeInfo [] args, void* ptr);
	
    private DISPID findMember(char [] member, INVOKEKIND ik);

    VARIANT get(char [] member);
	
    void set(char [] member,VARIANTARG arg);
	
    void setByRef(char [] member,VARIANTARG arg);
	
    VARIANT call(char [] member,...);
}

VARIANTARG toVariant(...);


extern(C)
int wcslen(wchar*);

extern(Windows)
{
    alias uint tagINVOKEKIND;
    alias tagINVOKEKIND INVOKEKIND;
    enum :INVOKEKIND
    {
        INVOKE_FUNC    = 1,
        INVOKE_PROPERTYGET    = 2,
        INVOKE_PROPERTYPUT    = 4,
        INVOKE_PROPERTYPUTREF    = 8
    }

    const WORD DISPATCH_METHOD = 0x1;
    const WORD DISPATCH_PROPERTYGET = 0x2;
    const WORD DISPATCH_PROPERTYPUT = 0x4;
    const WORD DISPATCH_PROPERTYPUTREF = 0x8;
    alias GUID_NULL IID_NULL;

    HRESULT CLSIDFromProgID (LPCOLESTR lpszProgID, CLSID * lpclsid);
    LCID GetUserDefaultLCID();
    BSTR SysAllocString(OLECHAR *);
    void SysFreeString(wchar*);
    DWORD FormatMessageA(DWORD dwFlags,LPCVOID lpSource,DWORD dwMessageId,DWORD dwLanguageId,LPSTR lpBuffer,DWORD nSize,va_list *Arguments);
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "auxc");
        } else {
            pragma(link, "DO-win32");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "DD-win32");
        } else {
            pragma(link, "DO-win32");
        }
    }
}
