/**
 * This module содержит a definition for the IUnknown interface, used with COM.
 *
 * Copyright: Copyright (C) 2005-2006 Digital Mars, www.digitalmars.com.
 *            все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Walter Bright, Sean Kelly
 */
module sys.win32.IUnknown;


private
{
    import sys.win32.Types;
    extern (C) extern IID IID_IUnknown;
}


interface IUnknown
{
    HRESULT QueryInterface( REFIID iid, out IUnknown об );
    ULONG AddRef();
    ULONG Release();
}


/**
 * This implementation may be mixed преобр_в COM classes в_ avoопр код duplication.
 */
template IUnknownImpl()
{
    HRESULT QueryInterface( REFIID iid, out IUnknown об )
    {
        if ( iid == &IID_IUnknown )
        {
            AddRef();
            об = this;
            return S_OK;
        }
        else
        {
            об = пусто;
            return E_NOINTERFACE;
        }
    }

    ULONG AddRef()
    {
        return ++m_count;
    }

    ULONG Release()
    {
        if( --m_count == 0 )
        {
            // free объект
            return 0;
        }
        return m_count;
    }

private:
    ULONG m_count = 1;
}
