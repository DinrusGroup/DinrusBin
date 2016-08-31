/*******************************************************************************

        copyright:      Copyright (c) 2007 the Dinrus team. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: July 2007

        author:         Cyborg16, Sean Kelly

*******************************************************************************/

module sys.win32.SpecialPath;

private import text.convert.Utf;
private import sys.Common;
private import sys.win32.CodePage;
private import stringz;


pragma(lib, "drTango");

version(Win32SansUnicode)
    extern(Windows) цел SHGetSpecialFolderPathA(HWND, LPCSTR, цел, BOOL);
else
    extern(Windows) цел SHGetSpecialFolderPathW(HWND, LPCWSTR, цел, BOOL);

enum
{
    CSIDL_DESKTOP = 0,
    CSIDL_INTERNET,
    CSIDL_PROGRAMS,
    CSIDL_CONTROLS,
    CSIDL_PRINTERS,
    CSIDL_PERSONAL,
    CSIDL_FAVORITES,
    CSIDL_STARTUP,
    CSIDL_RECENT,
    CSIDL_ОтправкаTO,
    CSIDL_BITBUCKET,
    CSIDL_STARTMENU, // = 11
    CSIDL_DESKTOPDIRECTORY = 16,
    CSIDL_DRIVES,
    CSIDL_NETWORK,
    CSIDL_NETHOOD,
    CSIDL_FONTS,
    CSIDL_TEMPLATES,
    CSIDL_COMMON_STARTMENU,
    CSIDL_COMMON_PROGRAMS,
    CSIDL_COMMON_STARTUP,
    CSIDL_COMMON_DESKTOPDIRECTORY,
    CSIDL_APPDATA,
    CSIDL_PRINTHOOD,
    CSIDL_LOCAL_APPDATA,
    CSIDL_ALTSTARTUP,
    CSIDL_COMMON_ALTSTARTUP,
    CSIDL_COMMON_FAVORITES,
    CSIDL_INTERNET_CACHE,
    CSIDL_COOKIES,
    CSIDL_HISTORY,
    CSIDL_COMMON_APPDATA,
    CSIDL_WINDOWS,
    CSIDL_SYSTEM,
    CSIDL_PROGRAM_FILES,
    CSIDL_MYPICTURES,
    CSIDL_PROFILE,
    CSIDL_SYSTEMX86,
    CSIDL_PROGRAM_FILESX86,
    CSIDL_PROGRAM_FILES_COMMON,
    CSIDL_PROGRAM_FILES_COMMONX86,
    CSIDL_COMMON_TEMPLATES,
    CSIDL_COMMON_DOCUMENTS,
    CSIDL_COMMON_ADMINTOOLS,
    CSIDL_ADMINTOOLS,
    CSIDL_CONNECTIONS, // =49
    CSIDL_COMMON_MUSIC = 53,
    CSIDL_COMMON_PICTURES,
    CSIDL_COMMON_VIDEO,
    CSIDL_RESOURCES,
    CSIDL_RESOURCES_LOCALIZED,
    CSIDL_COMMON_OEM_LINKS,
    CSIDL_CDBURN_AREA, // = 59
    CSIDL_COMPUTERSNEARME = 61,
    CSIDL_FLAG_DONT_VERIFY = 0x4000,
    CSIDL_FLAG_CREATE = 0x8000,
    CSIDL_FLAG_MASK = 0xFF00
}

/**
 * Get a special путь (on Windows).
 *
 * Параметры:
 *  csопрl = Enum of путь в_ получи
 *
 * Throws:
 *
 *
 * Возвращает:
 *  A ткст containing the путь
 */
ткст getSpecialPath( цел csопрl )
{
    version( Win32SansUnicode )
    {
        сим* spath = (new сим[MAX_PATH]).ptr;
        scope(exit) delete spath;

        if( !SHGetSpecialFolderPathA( пусто, spath, csопрl, да ) )
            throw new Исключение( "getSpecialPath :: " ~ СисОш.последнСооб );
        ткст dpath = new сим[MAX_PATH];
        return CodePage.из_(изТкст0(spath), dpath);
    }
    else
    {
        шим* spath = (new шим[MAX_PATH]).ptr;
        scope(exit) delete spath;

        if( !SHGetSpecialFolderPathW( пусто, spath, csопрl, да ) )
            throw new Исключение( "getSpecialPath :: " ~ СисОш.последнСооб );
        return вТкст(изТкст16н(spath));
    }
}
