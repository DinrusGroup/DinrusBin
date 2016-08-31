module win32.activex;
/***************************************************************
 * $HeadURL: http://svn.dsource.org/projects/core32/trunk/activex/activex.d $
 * $Revision: 39 $
 * $Date: 2009-05-23 02:44:15 +0400 (Сб, 23 май 2009) $
 * $Author: l8night $
 */

private:
//import std.array; /* for ArrayBoundsError */
import dinrus;

import win32.winnt, win32.winnls, win32.uuid, win32.wtypes, win32.basetyps;
import win32.oaidl, win32.objbase; /* for VARIANTARG */



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
        ткст name;
        DISPID dispid;
        INVOKEKIND invkind;
        FUNCDESC * pFuncDesc;
    }

    private win32.oaidl.ITypeInfo [FUNCDESC *] allFuncDescs;
    private win32.oaidl.ITypeInfo typeInfo;
    private win32.oaidl.IDispatch pIDispatch;
    private MemberDef [] allMembers;
    private ткст [ DISPID ] methods;
    private ткст [ DISPID ] getters;
        private SHORT [ DISPID ] returns;
    private ткст [ DISPID ] setters;
    private ткст [ DISPID ] settersbyref;

    this(ткст appName)
    {
        шим* prog = вЮ16н(appName);
        CLSID clsid;
        HRESULT hr = CLSIDFromProgID(cast(шим*)prog, &clsid);
        hr = CoCreateInstance(&clsid, null, win32.objbase.CLSCTX_SERVER, &win32.uuid.IID_IDispatch, cast(void**)&pIDispatch);
        loadMembers();
    }

    ~this()
    {
        foreach (FUNCDESC* pFuncDesc, win32.oaidl.ITypeInfo ti; allFuncDescs)
            ti.ReleaseFuncDesc(cast(FUNCDESC *)pFuncDesc);
    }

    void loadMembers()
    {
        HRESULT hr = pIDispatch.GetTypeInfo(0,defaultLCID, &typeInfo);
        loadMembers(typeInfo);
    }

    void loadMembers(win32.oaidl.ITypeInfo pTypeInfo)
    {
        TYPEATTR * pTypeAttr;
        HRESULT hr = pTypeInfo.GetTypeAttr(&pTypeAttr);

        for(uint i;i<pTypeAttr.cImplTypes;++i)
        {
            HREFTYPE pRefType;
            hr = pTypeInfo.GetRefTypeOfImplType(i,&pRefType);
            win32.oaidl.ITypeInfo  ppTInfo;
            hr = pTypeInfo.GetRefTypeInfo(pRefType,&ppTInfo);
            loadMembers(ppTInfo);
        }

        for(uint i;i<pTypeAttr.cFuncs;++i)
        {
            MemberDef mem;
            hr = pTypeInfo.GetFuncDesc(i,& mem.pFuncDesc);
            FUNCDESC * pFuncDesc=mem.pFuncDesc;

            allFuncDescs[pFuncDesc] = pTypeInfo;

            шим * methodName;
            hr = pTypeInfo.GetDocumentation(pFuncDesc.memid, &methodName, null, null, null);

            шим [] tmp;
            uint l=wcslen(methodName);
            tmp.length=l;
            for (uint j;j<l;++j)
                tmp[j]=methodName[j];
            ткст theName_i=вЮ8(tmp);
            ткст theName = theName_i.dup;

            mem.name=theName;
            mem.invkind=pFuncDesc.invkind;

            DISPID dispid/* = pFuncDesc.memid*/;
            //*
            hr = pIDispatch.GetIDsOfNames(cast(REFIID) &IID_NULL, &methodName, 1, defaultLCID, &dispid);
            mem.dispid=dispid;
            /**/
            allMembers ~= mem;
            SysFreeString (methodName);

            switch (mem.invkind)
            {
                case INVOKE_FUNC:
					methods[dispid] = theName;
                    break;
                case INVOKE_PROPERTYGET:
                    getters[dispid] = theName;
                    returns[dispid] = cast(SHORT) pFuncDesc.lprgelemdescParam[0].tdesc.vt;
                    break;
                case INVOKE_PROPERTYPUT:
                    setters[dispid] = theName;
                    break;
                case INVOKE_PROPERTYPUTREF:
                    settersbyref[dispid] = theName;
                    break;
                default:
            }
        }

        pTypeInfo.ReleaseTypeAttr(pTypeAttr);
    }

	public void showMembers()
	{

		пишифнс("\nmethods");		
		foreach(ткст key; methods)
			пишифнс("\t%s", key);

		пишифнс("\ngetters");
		foreach(DISPID value, ткст key; getters)
			пишифнс("\t%s", key);

		пишифнс("\nsetters");
		foreach(DISPID value, ткст key; setters)
			пишифнс("\t%s", key);

		пишифнс("\nsettersbyref");
		foreach(DISPID value, ткст key; settersbyref)
			пишифнс("\t%s", key);

/+		
    private SHORT [ DISPID ] returns;
+/
		
	}
	
    VARIANTARG [] makeArray(TypeInfo [] args, void* ptr)
    {
        VARIANTARG [] array;
        array.length = args.length;

        for (uint i;i<args.length;++i)
        {
            if (args[i] == typeid(VARIANTARG))
                array [i] = va_arg!(VARIANTARG)(ptr);
            else
                throw new Exception( "Ожидались аргументы типа VARIANTARG" );
        }

        return array;
    }

    private DISPID findMember(ткст member, INVOKEKIND ik)
    {
        INVOKEKIND tmp=0xffff;
        foreach(inout MemberDef mem; allMembers)
            if (mem.name==member)
                if (mem.invkind==ik)
                    return mem.dispid;
                else
                    tmp=mem.invkind;

        if (tmp==0xffff)
            throw new Exception(фм("отсутствует член '%s'",member));
        else
		    throw new Exception(фм("член '%s' найден с INVOKEKIND %s",member,tmp));
    }

    VARIANT get(ткст member)
    {
        INVOKEKIND ik=INVOKE_PROPERTYGET;
        DISPID dispid = findMember(member,ik);

        if (!(dispid in getters))
            throw new Exception("можно получить только свойства");

        DISPPARAMS param;
        VARIANT result;
        HRESULT hr = pIDispatch.Invoke(dispid, cast(REFIID) &IID_NULL, defaultLCID,
                                       ik, &param, &result, null, null);
        return result;
    }

    void set(ткст member,VARIANTARG arg)
    {
        INVOKEKIND ik=INVOKE_PROPERTYPUT;
        DISPID dispid = findMember(member,ik);

        if (!(dispid in setters))
            throw new Exception("можно только установить свойства");

        VARIANTARG [] myArgs = (&arg)[0..1];

        DISPPARAMS param;
        param.cArgs=myArgs.length;
        param.rgvarg=myArgs.ptr;

        DISPID dispidNamed = DISPID_PROPERTYPUT;
        param.cNamedArgs = 1;
        param.rgdispidNamedArgs = &dispidNamed;

        HRESULT hr = pIDispatch.Invoke(dispid, cast(REFIID) &IID_NULL, defaultLCID,
                                       ik, &param, null, null, null);
    }

    void setByRef(ткст member,VARIANTARG arg)
    {
        INVOKEKIND ik=INVOKE_PROPERTYPUTREF;
        DISPID dispid = findMember(member,ik);

        if (!(dispid in settersbyref))
            throw new Exception("можно только установить свойства");

        VARIANTARG [] myArgs = (&arg)[0..1];

        DISPPARAMS param;
        param.cArgs=myArgs.length;
        param.rgvarg=myArgs.ptr;

        DISPID dispidNamed = DISPID_PROPERTYPUT;
        param.cNamedArgs = 1;
        param.rgdispidNamedArgs = &dispidNamed;

        VARIANT * result;
        HRESULT hr = pIDispatch.Invoke(dispid, cast(REFIID) &IID_NULL, defaultLCID,
                                       ik, &param, result, null, null);
    }

    VARIANT call(ткст member,...)
    {

        /* Can I change the ткст into a variant? */


        INVOKEKIND ik = INVOKE_FUNC;
        DISPID dispid = findMember(member,ik);

        if (!(dispid in methods))
            throw new Exception("можно только вызывать методы");

        VARIANTARG [] myArgs = makeArray(_arguments,_argptr);

        DISPPARAMS param;
        param.cArgs=myArgs.length;
        param.rgvarg=myArgs.ptr;

		debug пишиф("Calling %s...", member);
		
        VARIANT result;
        HRESULT hr = pIDispatch.Invoke(dispid, cast(REFIID) &IID_NULL, defaultLCID,
                                       ik, &param, &result, null, null);
        return result;
    }
}




VARIANTARG toVariant(...)
{
    VARIANTARG variant;

    if (_arguments.length < 1)
        return VARIANT.init;

    if(_arguments.length == 1)
    {

        /* Strings */

        if (_arguments[0] == typeid(шим[]))
        {
            debug пишиф("шим[]\t");
            variant.vt = VARENUM.VT_BSTR;
            variant.bstrVal = cast(шим*) (va_arg!(char[])(_argptr) ~ "\0");
        }

        else if (_arguments[0] == typeid(char[]))
        {
            debug пишиф("char[]\t");
            variant.vt = VARENUM.VT_BSTR;
            шим[] buf = вЮ16(va_arg!(char[])(_argptr) ~ "\0");
            variant.bstrVal = SysAllocString( cast(шим*)(buf.ptr) );
        }


        /* Unsigned Integers */

        else if (_arguments[0] == typeid(bool))
        {
            debug пишиф("bool\t");
            variant.vt = VARENUM.VT_BOOL;            
            if(va_arg!(bool)(_argptr) == true)
                variant.boolVal = 1;
            else
                variant.boolVal = 0;                
        }
        else if (_arguments[0] == typeid(ubyte))
        {
            debug пишиф("ubyte\t");
            variant.vt = VARENUM.VT_UI1; /* I'm not sure about this. */
            variant.bVal = va_arg!(ubyte)(_argptr);
        }
        else if (_arguments[0] == typeid(ushort))
        {
            debug пишиф("ushort\t");
            variant.vt = VARENUM.VT_UI2; /* I'm not sure about this. */
            variant.uiVal = va_arg!(ushort)(_argptr);
        }
        else if (_arguments[0] == typeid(uint))
        {
            debug пишиф("uint\t");
            variant.vt = VARENUM.VT_UI4; /* I'm not sure about this. */
            variant.ulVal = va_arg!(uint)(_argptr);
        }
        else if (_arguments[0] == typeid(ulong)) /* 8 bits */
        {
            debug пишиф("ulong\t");
            variant.vt = VARENUM.VT_UI4; /* 4 bits -- long won't fit! */
            variant.lVal = va_arg!(ulong)(_argptr);
        }


        /* Signed Integers */

        else if (_arguments[0] == typeid(byte))
        {
            debug пишиф("byte\t");
            variant.vt = VARENUM.VT_I1; /* I'm not sure about this. */
            variant. cVal = va_arg!(byte)(_argptr);
        }
        else if (_arguments[0] == typeid(short))
        {
            debug пишиф("short\t");
            variant.vt = VARENUM.VT_I2; 
            variant.iVal = va_arg!(short)(_argptr);
        }
        else if (_arguments[0] == typeid(int))
        {
            debug пишиф("int\t");
            variant.vt = VARENUM.VT_I4; 
            variant.lVal = va_arg!(int)(_argptr);
        }
        else if (_arguments[0] == typeid(long)) /* 8 bits */
        {
            debug пишиф("long\t");
            variant.vt = VARENUM.VT_I4; /* 4 bits -- long might not fit! */
            variant.lVal = cast(int) va_arg!(long)(_argptr);
        }


        /* Floating Point */

        else if (_arguments[0] == typeid(float))
        {
            debug пишиф("float\t");
            variant.vt = VARENUM.VT_R4; 
            variant.fltVal = va_arg!(float)(_argptr);
        }
        else if (_arguments[0] == typeid(double))
        {
            debug пишиф("double\t");
            variant.vt = VARENUM.VT_R8; 
            variant.dblVal = va_arg!(double)(_argptr);
        }


        /* objects */

		else if (_arguments[0] == typeid(Object)) 
			/* need to be an AXO to work right now */
		{
            debug пишиф("object\t");
			variant.vt = VARENUM.VT_BYREF; //VARENUM.VT_STORED_OBJECT; /* I doubt this is right. */
			variant.byref = cast(void*)( va_arg!(Object)(_argptr) );
				/* need to get some kind of pointer from the AXO object */
		}
		

        else
            throw new Exception("toVariant doesn't know what to do with it.");

    }
    else 
        throw new Exception("[unimplemented feature] toVariant can't use more than one arguemnt yet");

    return variant;
}



extern(C)
int wcslen(шим*);

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
    alias win32.uuid.GUID_NULL IID_NULL;

    HRESULT CLSIDFromProgID (LPCOLESTR lpszProgID, CLSID * lpclsid);
    LCID GetUserDefaultLCID();
    BSTR SysAllocString(OLECHAR *);
    void SysFreeString(шим*);
    DWORD фмMessageA(DWORD dwFlags,LPCVOID lpSource,DWORD dwMessageId,DWORD dwLanguageId,LPSTR lpBuffer,DWORD nSize,va_list *Arguments);
}
