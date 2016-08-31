/**
 *  Windows is a registered trademark of Microsoft Corporation in the United
 *  States and other countries.
 *
 * Copyright: Copyright Digital Mars 2000 - 2009.
 * License:   <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
 * Authors:   Walter Bright, Sean Kelly
 *
 *          Copyright Digital Mars 2000 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module winapi;
public import sys.uuid;

extern (D)
{
WORD HIWORD(int l) { return cast(WORD)((l >> 16) & 0xFFFF); }
WORD LOWORD(int l) { return cast(WORD)l; }
bool FAILED(int status) { return status < 0; }
bool SUCCEEDED(int Status) { return Status >= 0; }
}

extern (Windows)
{

/+
    alias uint ULONG;
    alias ULONG *PULONG;
    alias ushort USHORT;
    alias USHORT *PUSHORT;
    alias ubyte UCHAR;
    alias UCHAR *PUCHAR;
    alias char *PSZ;
    alias wchar WCHAR;

    alias void VOID;
    alias char CHAR;
    alias short SHORT;
    alias int LONG;
    alias CHAR *LPSTR;
    alias CHAR *PSTR;

    alias CHAR *LPCSTR;
    alias CHAR *PCSTR;

    alias LPSTR LPTCH, PTCH;
    alias LPSTR PTSTR, LPTSTR;
    alias LPCSTR LPCTSTR;

    alias WCHAR* LPWSTR;

    alias WCHAR *LPCWSTR, PCWSTR;

    alias uint DWORD;
    alias ulong DWORD64;
    alias int BOOL;
    alias ubyte BYTE;
    alias ushort WORD;
    alias float FLOAT;
    alias FLOAT *PFLOAT;
    alias BOOL *PBOOL;
    alias BOOL *LPBOOL;
    alias BYTE *PBYTE;
    alias BYTE *LPBYTE;
    alias int *PINT;
    alias int *LPINT;
    alias WORD *PWORD;
    alias WORD *LPWORD;
    alias int *LPLONG;
    alias DWORD *PDWORD;
    alias DWORD *LPDWORD;
    alias void *LPVOID;
    alias void *LPCVOID;

    alias int INT;
    alias uint UINT;
    alias uint *PUINT;

// ULONG_PTR must be able to store a pointer as an integral type
version (Win64)
{
    alias  long INT_PTR;
    alias ulong UINT_PTR;
    alias  long LONG_PTR;
    alias ulong ULONG_PTR;
    alias  long * PINT_PTR;
    alias ulong * PUINT_PTR;
    alias  long * PLONG_PTR;
    alias ulong * PULONG_PTR;
}
else // Win32
{
    alias  int INT_PTR;
    alias uint UINT_PTR;
    alias  int LONG_PTR;
    alias uint ULONG_PTR;
    alias  int * PINT_PTR;
    alias uint * PUINT_PTR;
    alias  int * PLONG_PTR;
    alias uint * PULONG_PTR;
}

    typedef void *HANDLE;
    alias void *PVOID;
    alias HANDLE HGLOBAL;
    alias HANDLE HLOCAL;
    alias LONG HRESULT;
    alias LONG SCODE;
    alias HANDLE HINSTANCE;
    alias HINSTANCE HMODULE;
    alias HANDLE HWND;

    alias HANDLE HGDIOBJ;
    alias HANDLE HACCEL;
    alias HANDLE HBITMAP;
    alias HANDLE HBRUSH;
    alias HANDLE HCOLORSPACE;
    alias HANDLE HDC;
    alias HANDLE HGLRC;
    alias HANDLE HDESK;
    alias HANDLE HENHMETAFILE;
    alias HANDLE HFONT;
    alias HANDLE HICON;
    alias HANDLE HMENU;
    alias HANDLE HMETAFILE;
    alias HANDLE HPALETTE;
    alias HANDLE HPEN;
    alias HANDLE HRGN;
    alias HANDLE HRSRC;
    alias HANDLE HSTR;
    alias HANDLE HTASK;
    alias HANDLE HWINSTA;
    alias HANDLE HKL;
    alias HICON HCURSOR;

    alias HANDLE HKEY;
    alias HKEY *PHKEY;
    alias DWORD ACCESS_MASK;
    alias ACCESS_MASK *PACCESS_MASK;
    alias ACCESS_MASK REGSAM;

    alias int function() FARPROC;

    alias UINT WPARAM;
    alias LONG LPARAM;
    alias LONG LRESULT;

    alias DWORD   COLORREF;
    alias DWORD   *LPCOLORREF;
    alias WORD    ATOM;

version (0)
{   // Properly prototyped versions
    alias BOOL function(HWND, UINT, WPARAM, LPARAM) DLGPROC;
    alias VOID function(HWND, UINT, UINT, DWORD) TIMERPROC;
    alias BOOL function(HDC, LPARAM, int) GRAYSTRINGPROC;
    alias BOOL function(HWND, LPARAM) WNDENUMPROC;
    alias LRESULT function(int code, WPARAM wParam, LPARAM lParam) HOOKPROC;
    alias VOID function(HWND, UINT, DWORD, LRESULT) SENDASYNCPROC;
    alias BOOL function(HWND, LPCSTR, HANDLE) PROPENUMPROCA;
    alias BOOL function(HWND, LPCWSTR, HANDLE) PROPENUMPROCW;
    alias BOOL function(HWND, LPSTR, HANDLE, DWORD) PROPENUMPROCEXA;
    alias BOOL function(HWND, LPWSTR, HANDLE, DWORD) PROPENUMPROCEXW;
    alias int function(LPSTR lpch, int ichCurrent, int cch, int code)
       EDITWORDBREAKPROCA;
    alias int function(LPWSTR lpch, int ichCurrent, int cch, int code)
       EDITWORDBREAKPROCW;
    alias BOOL function(HDC hdc, LPARAM lData, WPARAM wData, int cx, int cy)
       DRAWSTATEPROC;
}
else
{
    alias FARPROC DLGPROC;
    alias FARPROC TIMERPROC;
    alias FARPROC GRAYSTRINGPROC;
    alias FARPROC WNDENUMPROC;
    alias FARPROC HOOKPROC;
    alias FARPROC SENDASYNCPROC;
    alias FARPROC EDITWORDBREAKPROCA;
    alias FARPROC EDITWORDBREAKPROCW;
    alias FARPROC PROPENUMPROCA;
    alias FARPROC PROPENUMPROCW;
    alias FARPROC PROPENUMPROCEXA;
    alias FARPROC PROPENUMPROCEXW;
    alias FARPROC DRAWSTATEPROC;
}
+/

	struct TRACKMOUSEEVENT
	{
		DWORD cbSize;
		DWORD dwFlags;
		HWND hwndTrack;
		DWORD dwHoverTime;
	}
	alias TRACKMOUSEEVENT* LPTRACKMOUSEEVENT;
	
	
		struct INITCOMMONCONTROLSEX
	{
		DWORD dwSize;
		DWORD dwICC;
	}
	alias INITCOMMONCONTROLSEX* LPINITCOMMONCONTROLSEX;
	alias INITCOMMONCONTROLSEX* PINITCOMMONCONTROLSEX;
	
	
		enum: DWORD
	{
		// IE3+
		ICC_LISTVIEW_CLASSES = 0x00000001,
		ICC_TREEVIEW_CLASSES = 0x00000002,
		ICC_BAR_CLASSES = 0x00000004, // tool/status/track
		ICC_TAB_CLASSES = 0x00000008,
		ICC_UPDOWN_CLASS = 0x00000010,
		ICC_PROGRESS_CLASS = 0x00000020,
		ICC_HOTKEY_CLASS = 0x00000040,
		ICC_ANIMATE_CLASS = 0x00000080,
		ICC_WIN95_CLASSES = 0x000000FF,
		ICC_DATE_CLASSES = 0x00000100,
		ICC_USEREX_CLASSES = 0x00000200,
		ICC_COOL_CLASSES = 0x00000400,
		
		ICC_STANDARD_CLASSES = 0x00004000,
		
		// IE4+
		ICC_INTERNET_CLASSES = 0x00000800,
		ICC_PAGESCROLLER_CLASS = 0x00001000,
		ICC_NATIVEFNTCTL_CLASS = 0x00002000,
	}
	
	

enum : uint
{
    MAX_PATH = 260,
    HINSTANCE_ERROR = 32,
}

enum
{
    ERROR_SUCCESS =                    0,
    ERROR_INVALID_FUNCTION =           1,
    ERROR_FILE_NOT_FOUND =             2,
    ERROR_PATH_NOT_FOUND =             3,
    ERROR_TOO_MANY_OPEN_FILES =        4,
    ERROR_ACCESS_DENIED =              5,
    ERROR_INVALID_HANDLE =             6,
    ERROR_NO_MORE_FILES =              18,
    ERROR_MORE_DATA =          234,
    ERROR_NO_MORE_ITEMS =          259,
}

enum
{
    DLL_PROCESS_ATTACH = 1,
    DLL_THREAD_ATTACH =  2,
    DLL_THREAD_DETACH =  3,
    DLL_PROCESS_DETACH = 0,
}

enum
{
    FILE_BEGIN           = 0,
    FILE_CURRENT         = 1,
    FILE_END             = 2,
}

enum : uint
{
    DELETE =                           0x00010000,
    READ_CONTROL =                     0x00020000,
    WRITE_DAC =                        0x00040000,
    WRITE_OWNER =                      0x00080000,
    SYNCHRONIZE =                      0x00100000,

    STANDARD_RIGHTS_REQUIRED =         0x000F0000,
    STANDARD_RIGHTS_READ =             READ_CONTROL,
    STANDARD_RIGHTS_WRITE =            READ_CONTROL,
    STANDARD_RIGHTS_EXECUTE =          READ_CONTROL,
    STANDARD_RIGHTS_ALL =              0x001F0000,
    SPECIFIC_RIGHTS_ALL =              0x0000FFFF,
    ACCESS_SYSTEM_SECURITY =           0x01000000,
    MAXIMUM_ALLOWED =                  0x02000000,

    GENERIC_READ                     = 0x80000000,
    GENERIC_WRITE                    = 0x40000000,
    GENERIC_EXECUTE                  = 0x20000000,
    GENERIC_ALL                      = 0x10000000,
}

enum
{
    FILE_SHARE_READ                 = 0x00000001,
    FILE_SHARE_WRITE                = 0x00000002,
    FILE_SHARE_DELETE               = 0x00000004,
    FILE_ATTRIBUTE_READONLY         = 0x00000001,
    FILE_ATTRIBUTE_HIDDEN           = 0x00000002,
    FILE_ATTRIBUTE_SYSTEM           = 0x00000004,
    FILE_ATTRIBUTE_DIRECTORY        = 0x00000010,
    FILE_ATTRIBUTE_ARCHIVE          = 0x00000020,
    FILE_ATTRIBUTE_NORMAL           = 0x00000080,
    FILE_ATTRIBUTE_TEMPORARY        = 0x00000100,
    FILE_ATTRIBUTE_COMPRESSED       = 0x00000800,
    FILE_ATTRIBUTE_OFFLINE          = 0x00001000,
    FILE_NOTIFY_CHANGE_FILE_NAME    = 0x00000001,
    FILE_NOTIFY_CHANGE_DIR_NAME     = 0x00000002,
    FILE_NOTIFY_CHANGE_ATTRIBUTES   = 0x00000004,
    FILE_NOTIFY_CHANGE_SIZE         = 0x00000008,
    FILE_NOTIFY_CHANGE_LAST_WRITE   = 0x00000010,
    FILE_NOTIFY_CHANGE_LAST_ACCESS  = 0x00000020,
    FILE_NOTIFY_CHANGE_CREATION     = 0x00000040,
    FILE_NOTIFY_CHANGE_SECURITY     = 0x00000100,
    FILE_ACTION_ADDED               = 0x00000001,
    FILE_ACTION_REMOVED             = 0x00000002,
    FILE_ACTION_MODIFIED            = 0x00000003,
    FILE_ACTION_RENAMED_OLD_NAME    = 0x00000004,
    FILE_ACTION_RENAMED_NEW_NAME    = 0x00000005,
    FILE_CASE_SENSITIVE_SEARCH      = 0x00000001,
    FILE_CASE_PRESERVED_NAMES       = 0x00000002,
    FILE_UNICODE_ON_DISK            = 0x00000004,
    FILE_PERSISTENT_ACLS            = 0x00000008,
    FILE_FILE_COMPRESSION           = 0x00000010,
    FILE_VOLUME_IS_COMPRESSED       = 0x00008000,
}

enum : DWORD
{
    MAILSLOT_NO_MESSAGE = cast(DWORD)-1,
    MAILSLOT_WAIT_FOREVER = cast(DWORD)-1,
}

enum : uint
{
    FILE_FLAG_WRITE_THROUGH         = 0x80000000,
    FILE_FLAG_OVERLAPPED            = 0x40000000,
    FILE_FLAG_NO_BUFFERING          = 0x20000000,
    FILE_FLAG_RANDOM_ACCESS         = 0x10000000,
    FILE_FLAG_SEQUENTIAL_SCAN       = 0x08000000,
    FILE_FLAG_DELETE_ON_CLOSE       = 0x04000000,
    FILE_FLAG_BACKUP_SEMANTICS      = 0x02000000,
    FILE_FLAG_POSIX_SEMANTICS       = 0x01000000,
}

enum
{
    CREATE_NEW          = 1,
    CREATE_ALWAYS       = 2,
    OPEN_EXISTING       = 3,
    OPEN_ALWAYS         = 4,
    TRUNCATE_EXISTING   = 5,
}



 const   HANDLE INVALID_HANDLE_VALUE     = cast(HANDLE)-1;
   const  DWORD INVALID_SET_FILE_POINTER  = cast(DWORD)-1;
  const  DWORD INVALID_FILE_SIZE         = cast(DWORD)0xFFFFFFFF;


struct OVERLAPPED {
    DWORD   Internal;
    DWORD   InternalHigh;
    DWORD   Offset;
    DWORD   OffsetHigh;
    HANDLE  hEvent;
}
alias OVERLAPPED *LPOVERLAPPED;

struct SECURITY_ATTRIBUTES {
    DWORD nLength;
    void *lpSecurityDescriptor;
    BOOL bInheritHandle;
}

alias SECURITY_ATTRIBUTES* PSECURITY_ATTRIBUTES, LPSECURITY_ATTRIBUTES;

struct FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
}
alias FILETIME* PFILETIME, LPFILETIME;

struct WIN32_FIND_DATA {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD dwReserved0;
    DWORD dwReserved1;
    char   cFileName[MAX_PATH];
    char   cAlternateFileName[ 14 ];
}

struct WIN32_FIND_DATAW {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD dwReserved0;
    DWORD dwReserved1;
    wchar  cFileName[MAX_PATH];
    wchar  cAlternateFileName[ 14 ];
}

// Critical Section

struct _LIST_ENTRY
{
    _LIST_ENTRY *Flink;
    _LIST_ENTRY *Blink;
}
alias _LIST_ENTRY LIST_ENTRY;

struct _RTL_CRITICAL_SECTION_DEBUG
{
    WORD   Type;
    WORD   CreatorBackTraceIndex;
    _RTL_CRITICAL_SECTION *CriticalSection;
    LIST_ENTRY ProcessLocksList;
    DWORD EntryCount;
    DWORD ContentionCount;
    DWORD Spare[ 2 ];
}
alias _RTL_CRITICAL_SECTION_DEBUG RTL_CRITICAL_SECTION_DEBUG;

struct _RTL_CRITICAL_SECTION
{
    RTL_CRITICAL_SECTION_DEBUG * DebugInfo;

    //
    //  The following three fields control entering and exiting the critical
    //  section for the resource
    //

    LONG LockCount;
    LONG RecursionCount;
    HANDLE OwningThread;        // from the thread's ClientId->UniqueThread
    HANDLE LockSemaphore;
    ULONG_PTR SpinCount;        // force size on 64-bit systems when packed
}
alias _RTL_CRITICAL_SECTION CRITICAL_SECTION;


enum
{
    STD_INPUT_HANDLE =    cast(DWORD)-10,
    STD_OUTPUT_HANDLE =   cast(DWORD)-11,
    STD_ERROR_HANDLE =    cast(DWORD)-12,
}

extern (Windows)
{
BOOL SetCurrentDirectoryA(LPCSTR lpPathName);
DWORD GetCurrentDirectoryA(DWORD nBufferLength, LPSTR lpBuffer);
BOOL CreateDirectoryA(LPCSTR lpPathName, LPSECURITY_ATTRIBUTES lpSecurityAttributes);
BOOL CreateDirectoryW(LPCWSTR lpPathName, LPSECURITY_ATTRIBUTES lpSecurityAttributes);
BOOL CreateDirectoryExA(LPCSTR lpTemplateDirectory, LPCSTR lpNewDirectory, LPSECURITY_ATTRIBUTES lpSecurityAttributes);
BOOL CreateDirectoryExW(LPCWSTR lpTemplateDirectory, LPCWSTR lpNewDirectory, LPSECURITY_ATTRIBUTES lpSecurityAttributes);
BOOL RemoveDirectoryA(LPCSTR lpPathName);
BOOL RemoveDirectoryW(LPCWSTR lpPathName);

BOOL   CloseHandle(HANDLE hObject);

HANDLE CreateFileA(in char* lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode,
    SECURITY_ATTRIBUTES *lpSecurityAttributes, DWORD dwCreationDisposition,
    DWORD dwFlagsAndAttributes, HANDLE hTemplateFile);
HANDLE CreateFileW(LPCWSTR lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode,
    SECURITY_ATTRIBUTES *lpSecurityAttributes, DWORD dwCreationDisposition,
    DWORD dwFlagsAndAttributes, HANDLE hTemplateFile);

BOOL   DeleteFileA(in char *lpFileName);
BOOL   DeleteFileW(LPCWSTR lpFileName);

BOOL   FindClose(HANDLE hFindFile);
HANDLE FindFirstFileA(in char *lpFileName, WIN32_FIND_DATA* lpFindFileData);
HANDLE FindFirstFileW(in LPCWSTR lpFileName, WIN32_FIND_DATAW* lpFindFileData);
BOOL   FindNextFileA(HANDLE hFindFile, WIN32_FIND_DATA* lpFindFileData);
BOOL   FindNextFileW(HANDLE hFindFile, WIN32_FIND_DATAW* lpFindFileData);
BOOL   GetExitCodeThread(HANDLE hThread, DWORD *lpExitCode);
DWORD  GetLastError();
DWORD  GetFileAttributesA(in char *lpFileName);
DWORD  GetFileAttributesW(in wchar *lpFileName);
DWORD  GetFileSize(HANDLE hFile, DWORD *lpFileSizeHigh);
BOOL   CopyFileA(LPCSTR lpExistingFileName, LPCSTR lpNewFileName, BOOL bFailIfExists);
BOOL   CopyFileW(LPCWSTR lpExistingFileName, LPCWSTR lpNewFileName, BOOL bFailIfExists);
BOOL   MoveFileA(in char *from, in char *to);
BOOL   MoveFileW(LPCWSTR lpExistingFileName, LPCWSTR lpNewFileName);
BOOL   ReadFile(HANDLE hFile, void *lpBuffer, DWORD nNumberOfBytesToRead,
    DWORD *lpNumberOfBytesRead, OVERLAPPED *lpOverlapped);
DWORD  SetFilePointer(HANDLE hFile, LONG lDistanceToMove,
    LONG *lpDistanceToMoveHigh, DWORD dwMoveMethod);
BOOL   WriteFile(HANDLE hFile, in void *lpBuffer, DWORD nNumberOfBytesToWrite,
    DWORD *lpNumberOfBytesWritten, OVERLAPPED *lpOverlapped);
DWORD  GetModuleFileNameA(HMODULE hModule, LPSTR lpFilename, DWORD nSize);
HANDLE GetStdHandle(DWORD nStdHandle);
BOOL   SetStdHandle(DWORD nStdHandle, HANDLE hHandle);
}

struct MEMORYSTATUS {
    DWORD dwLength;
    DWORD dwMemoryLoad;
    DWORD dwTotalPhys;
    DWORD dwAvailPhys;
    DWORD dwTotalPageFile;
    DWORD dwAvailPageFile;
    DWORD dwTotalVirtual;
    DWORD dwAvailVirtual;
};
alias MEMORYSTATUS *LPMEMORYSTATUS;

HMODULE LoadLibraryA(LPCSTR lpLibFileName);
FARPROC GetProcAddress(HMODULE hModule, LPCSTR lpProcName);
DWORD GetVersion();
BOOL FreeLibrary(HMODULE hLibModule);
void FreeLibraryAndExitThread(HMODULE hLibModule, DWORD dwExitCode);
BOOL DisableThreadLibraryCalls(HMODULE hLibModule);

//
// Registry Specific Access Rights.
//

enum
{
    KEY_QUERY_VALUE =         0x0001,
    KEY_SET_VALUE =           0x0002,
    KEY_CREATE_SUB_KEY =      0x0004,
    KEY_ENUMERATE_SUB_KEYS =  0x0008,
    KEY_NOTIFY =              0x0010,
    KEY_CREATE_LINK =         0x0020,

    KEY_READ =       cast(int)((STANDARD_RIGHTS_READ | KEY_QUERY_VALUE | KEY_ENUMERATE_SUB_KEYS | KEY_NOTIFY)   & ~SYNCHRONIZE),
    KEY_WRITE =      cast(int)((STANDARD_RIGHTS_WRITE | KEY_SET_VALUE | KEY_CREATE_SUB_KEY) & ~SYNCHRONIZE),
    KEY_EXECUTE =    cast(int)(KEY_READ & ~SYNCHRONIZE),
    KEY_ALL_ACCESS = cast(int)((STANDARD_RIGHTS_ALL | KEY_QUERY_VALUE | KEY_SET_VALUE | KEY_CREATE_SUB_KEY | KEY_ENUMERATE_SUB_KEYS | KEY_NOTIFY | KEY_CREATE_LINK) & ~SYNCHRONIZE),
}

//
// Key creation/open disposition
//

enum : int
{
    REG_CREATED_NEW_KEY =         0x00000001,   // New Registry Key created
    REG_OPENED_EXISTING_KEY =     0x00000002,   // Existing Key opened
}

//
//
// Predefined Value Types.
//
enum
{
    REG_NONE =                    0,   // No value type
    REG_SZ =                      1,   // Unicode nul terminated string
    REG_EXPAND_SZ =               2,   // Unicode nul terminated string
                                            // (with environment variable references)
    REG_BINARY =                  3,   // Free form binary
    REG_DWORD =                   4,   // 32-bit number
    REG_DWORD_LITTLE_ENDIAN =     4,   // 32-bit number (same as REG_DWORD)
    REG_DWORD_BIG_ENDIAN =        5,   // 32-bit number
    REG_LINK =                    6,   // Symbolic Link (unicode)
    REG_MULTI_SZ =                7,   // Multiple Unicode strings
    REG_RESOURCE_LIST =           8,   // Resource list in the resource map
    REG_FULL_RESOURCE_DESCRIPTOR = 9,  // Resource list in the hardware description
    REG_RESOURCE_REQUIREMENTS_LIST = 10,
    REG_QWORD =         11,
    REG_QWORD_LITTLE_ENDIAN =   11,
}

/*
 * MessageBox() Flags
 */
enum
{
    MB_OK =                       0x00000000,
    MB_OKCANCEL =                 0x00000001,
    MB_ABORTRETRYIGNORE =         0x00000002,
    MB_YESNOCANCEL =              0x00000003,
    MB_YESNO =                    0x00000004,
    MB_RETRYCANCEL =              0x00000005,


    MB_ICONHAND =                 0x00000010,
    MB_ICONQUESTION =             0x00000020,
    MB_ICONEXCLAMATION =          0x00000030,
    MB_ICONASTERISK =             0x00000040,


    MB_USERICON =                 0x00000080,
    MB_ICONWARNING =              MB_ICONEXCLAMATION,
    MB_ICONERROR =                MB_ICONHAND,


    MB_ICONINFORMATION =          MB_ICONASTERISK,
    MB_ICONSTOP =                 MB_ICONHAND,

    MB_DEFBUTTON1 =               0x00000000,
    MB_DEFBUTTON2 =               0x00000100,
    MB_DEFBUTTON3 =               0x00000200,

    MB_DEFBUTTON4 =               0x00000300,


    MB_APPLMODAL =                0x00000000,
    MB_SYSTEMMODAL =              0x00001000,
    MB_TASKMODAL =                0x00002000,

    MB_HELP =                     0x00004000, // Help Button


    MB_NOFOCUS =                  0x00008000,
    MB_SETFOREGROUND =            0x00010000,
    MB_DEFAULT_DESKTOP_ONLY =     0x00020000,


    MB_TOPMOST =                  0x00040000,
    MB_RIGHT =                    0x00080000,
    MB_RTLREADING =               0x00100000,


    MB_TYPEMASK =                 0x0000000F,
    MB_ICONMASK =                 0x000000F0,
    MB_DEFMASK =                  0x00000F00,
    MB_MODEMASK =                 0x00003000,
    MB_MISCMASK =                 0x0000C000,
}


int MessageBoxA(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType);
int MessageBoxExA(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType, WORD wLanguageId);
int MessageBoxW(HWND hWnd, LPCWSTR lpText, LPCWSTR lpCaption, UINT uType);
int MessageBoxExW(HWND hWnd, LPCWSTR lpText, LPCWSTR lpCaption, UINT uType, WORD wLanguageId);

  const HKEY  HKEY_CLASSES_ROOT =           cast(HKEY)(0x80000000);
  const HKEY  HKEY_CURRENT_USER =           cast(HKEY)(0x80000001);
  const HKEY  HKEY_LOCAL_MACHINE =          cast(HKEY)(0x80000002);
  const HKEY  HKEY_USERS =                  cast(HKEY)(0x80000003);
  const HKEY  HKEY_PERFORMANCE_DATA =       cast(HKEY)(0x80000004);
 const HKEY   HKEY_PERFORMANCE_TEXT =       cast(HKEY)(0x80000050);
  const HKEY  HKEY_PERFORMANCE_NLSTEXT =    cast(HKEY)(0x80000060);
  const HKEY  HKEY_CURRENT_CONFIG =         cast(HKEY)(0x80000005);
   const HKEY HKEY_DYN_DATA =               cast(HKEY)(0x80000006);



enum
{
    REG_OPTION_RESERVED =         (0x00000000),   // Parameter is reserved

    REG_OPTION_NON_VOLATILE =     (0x00000000),   // Key is preserved
                                                    // when system is rebooted

    REG_OPTION_VOLATILE =         (0x00000001),   // Key is not preserved
                                                    // when system is rebooted

    REG_OPTION_CREATE_LINK =      (0x00000002),   // Created key is a
                                                    // symbolic link

    REG_OPTION_BACKUP_RESTORE =   (0x00000004),   // open for backup or restore
                                                    // special access rules
                                                    // privilege required

    REG_OPTION_OPEN_LINK =        (0x00000008),   // Open symbolic link

    REG_LEGAL_OPTION = (REG_OPTION_RESERVED | REG_OPTION_NON_VOLATILE | REG_OPTION_VOLATILE | REG_OPTION_CREATE_LINK | REG_OPTION_BACKUP_RESTORE | REG_OPTION_OPEN_LINK),
}

extern (Windows) LONG RegDeleteKeyA(HKEY hKey, LPCSTR lpSubKey);
extern (Windows) LONG RegDeleteValueA(HKEY hKey, LPCSTR lpValueName);

extern (Windows) LONG  RegEnumKeyExA(HKEY hKey, DWORD dwIndex, LPSTR lpName, LPDWORD lpcbName, LPDWORD lpReserved, LPSTR lpClass, LPDWORD lpcbClass, FILETIME* lpftLastWriteTime);
extern (Windows) LONG RegEnumValueA(HKEY hKey, DWORD dwIndex, LPSTR lpValueName, LPDWORD lpcbValueName, LPDWORD lpReserved,
    LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData);

extern (Windows) LONG RegCloseKey(HKEY hKey);
extern (Windows) LONG RegFlushKey(HKEY hKey);

extern (Windows) LONG RegOpenKeyA(HKEY hKey, LPCSTR lpSubKey, PHKEY phkResult);
extern (Windows) LONG RegOpenKeyExA(HKEY hKey, LPCSTR lpSubKey, DWORD ulOptions, REGSAM samDesired, PHKEY phkResult);

extern (Windows) LONG RegQueryInfoKeyA(HKEY hKey, LPSTR lpClass, LPDWORD lpcbClass,
    LPDWORD lpReserved, LPDWORD lpcSubKeys, LPDWORD lpcbMaxSubKeyLen, LPDWORD lpcbMaxClassLen,
    LPDWORD lpcValues, LPDWORD lpcbMaxValueNameLen, LPDWORD lpcbMaxValueLen, LPDWORD lpcbSecurityDescriptor,
    PFILETIME lpftLastWriteTime);

extern (Windows) LONG RegQueryValueA(HKEY hKey, LPCSTR lpSubKey, LPSTR lpValue,
    LPLONG lpcbValue);

extern (Windows) LONG RegCreateKeyExA(HKEY hKey, LPCSTR lpSubKey, DWORD Reserved, LPSTR lpClass,
   DWORD dwOptions, REGSAM samDesired, SECURITY_ATTRIBUTES* lpSecurityAttributes,
    PHKEY phkResult, LPDWORD lpdwDisposition);

extern (Windows) LONG RegSetValueExA(HKEY hKey, LPCSTR lpValueName, DWORD Reserved, DWORD dwType, BYTE* lpData, DWORD cbData);

struct MEMORY_BASIC_INFORMATION {
    PVOID BaseAddress;
    PVOID AllocationBase;
    DWORD AllocationProtect;
    DWORD RegionSize;
    DWORD State;
    DWORD Protect;
    DWORD Type;
}
alias MEMORY_BASIC_INFORMATION* PMEMORY_BASIC_INFORMATION;

enum
{
    SECTION_QUERY       = 0x0001,
    SECTION_MAP_WRITE   = 0x0002,
    SECTION_MAP_READ    = 0x0004,
    SECTION_MAP_EXECUTE = 0x0008,
    SECTION_EXTEND_SIZE = 0x0010,

    SECTION_ALL_ACCESS = cast(int)(STANDARD_RIGHTS_REQUIRED|SECTION_QUERY| SECTION_MAP_WRITE | SECTION_MAP_READ | SECTION_MAP_EXECUTE | SECTION_EXTEND_SIZE),
    PAGE_NOACCESS          = 0x01,
    PAGE_READONLY          = 0x02,
    PAGE_READWRITE         = 0x04,
    PAGE_WRITECOPY         = 0x08,
    PAGE_EXECUTE           = 0x10,
    PAGE_EXECUTE_READ      = 0x20,
    PAGE_EXECUTE_READWRITE = 0x40,
    PAGE_EXECUTE_WRITECOPY = 0x80,
    PAGE_GUARD            = 0x100,
    PAGE_NOCACHE          = 0x200,
    MEM_COMMIT           = 0x1000,
    MEM_RESERVE          = 0x2000,
    MEM_DECOMMIT         = 0x4000,
    MEM_RELEASE          = 0x8000,
    MEM_FREE            = 0x10000,
    MEM_PRIVATE         = 0x20000,
    MEM_MAPPED          = 0x40000,
    MEM_RESET           = 0x80000,
    MEM_TOP_DOWN       = 0x100000,
    SEC_FILE           = 0x800000,
    SEC_IMAGE         = 0x1000000,
    SEC_RESERVE       = 0x4000000,
    SEC_COMMIT        = 0x8000000,
    SEC_NOCACHE      = 0x10000000,
    MEM_IMAGE        = SEC_IMAGE,
}

enum
{
    FILE_MAP_COPY =       SECTION_QUERY,
    FILE_MAP_WRITE =      SECTION_MAP_WRITE,
    FILE_MAP_READ =       SECTION_MAP_READ,
    FILE_MAP_ALL_ACCESS = SECTION_ALL_ACCESS,
}


//
// Define access rights to files and directories
//

//
// The FILE_READ_DATA and FILE_WRITE_DATA constants are also defined in
// devioctl.h as FILE_READ_ACCESS and FILE_WRITE_ACCESS. The values for these
// constants *MUST* always be in sync.
// The values are redefined in devioctl.h because they must be available to
// both DOS and NT.
//

enum
{
    FILE_READ_DATA =            ( 0x0001 ),   // file & pipe
    FILE_LIST_DIRECTORY =       ( 0x0001 ),    // directory

    FILE_WRITE_DATA =           ( 0x0002 ),    // file & pipe
    FILE_ADD_FILE =             ( 0x0002 ),    // directory

    FILE_APPEND_DATA =          ( 0x0004 ),    // file
    FILE_ADD_SUBDIRECTORY =     ( 0x0004 ),    // directory
    FILE_CREATE_PIPE_INSTANCE = ( 0x0004 ),    // named pipe

    FILE_READ_EA =              ( 0x0008 ),    // file & directory

    FILE_WRITE_EA =             ( 0x0010 ),    // file & directory

    FILE_EXECUTE =              ( 0x0020 ),    // file
    FILE_TRAVERSE =             ( 0x0020 ),    // directory

    FILE_DELETE_CHILD =         ( 0x0040 ),    // directory

    FILE_READ_ATTRIBUTES =      ( 0x0080 ),    // all

    FILE_WRITE_ATTRIBUTES =     ( 0x0100 ),    // all

    FILE_ALL_ACCESS =       cast(int)(STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE | 0x1FF),

    FILE_GENERIC_READ =         cast(int)(STANDARD_RIGHTS_READ  | FILE_READ_DATA |  FILE_READ_ATTRIBUTES |                 FILE_READ_EA |  SYNCHRONIZE),

    FILE_GENERIC_WRITE =        cast(int)(STANDARD_RIGHTS_WRITE | FILE_WRITE_DATA |  FILE_WRITE_ATTRIBUTES |                      FILE_WRITE_EA  |  FILE_APPEND_DATA |  SYNCHRONIZE),

    FILE_GENERIC_EXECUTE =      cast(int)(STANDARD_RIGHTS_EXECUTE | FILE_READ_ATTRIBUTES |                 FILE_EXECUTE |  SYNCHRONIZE),
}

extern (Windows)
{
 BOOL  FreeResource(HGLOBAL hResData);
 LPVOID LockResource(HGLOBAL hResData);
 BOOL GlobalUnlock(HGLOBAL hMem);
 HGLOBAL GlobalFree(HGLOBAL hMem);
 UINT GlobalCompact(DWORD dwMinFree);
 void GlobalFix(HGLOBAL hMem);
 void GlobalUnfix(HGLOBAL hMem);
 LPVOID GlobalWire(HGLOBAL hMem);
 BOOL GlobalUnWire(HGLOBAL hMem);
 void GlobalMemoryStatus(LPMEMORYSTATUS lpBuffer);
 HLOCAL LocalAlloc(UINT uFlags, UINT uBytes);
 HLOCAL LocalReAlloc(HLOCAL hMem, UINT uBytes, UINT uFlags);
 LPVOID LocalLock(HLOCAL hMem);
 HLOCAL LocalHandle(LPCVOID pMem);
 BOOL LocalUnlock(HLOCAL hMem);
 UINT LocalSize(HLOCAL hMem);
 UINT LocalFlags(HLOCAL hMem);
 HLOCAL LocalFree(HLOCAL hMem);
 UINT LocalShrink(HLOCAL hMem, UINT cbNewSize);
 UINT LocalCompact(UINT uMinFree);
 BOOL FlushInstructionCache(HANDLE hProcess, LPCVOID lpBaseAddress, DWORD dwSize);
 LPVOID VirtualAlloc(LPVOID lpAddress, DWORD dwSize, DWORD flAllocationType, DWORD flProtect);
 BOOL VirtualFree(LPVOID lpAddress, DWORD dwSize, DWORD dwFreeType);
 BOOL VirtualProtect(LPVOID lpAddress, DWORD dwSize, DWORD flNewProtect, PDWORD lpflOldProtect);
 DWORD VirtualQuery(LPCVOID lpAddress, PMEMORY_BASIC_INFORMATION lpBuffer, DWORD dwLength);
 LPVOID VirtualAllocEx(HANDLE hProcess, LPVOID lpAddress, DWORD dwSize, DWORD flAllocationType, DWORD flProtect);
 BOOL VirtualFreeEx(HANDLE hProcess, LPVOID lpAddress, DWORD dwSize, DWORD dwFreeType);
 BOOL VirtualProtectEx(HANDLE hProcess, LPVOID lpAddress, DWORD dwSize, DWORD flNewProtect, PDWORD lpflOldProtect);
 DWORD VirtualQueryEx(HANDLE hProcess, LPCVOID lpAddress, PMEMORY_BASIC_INFORMATION lpBuffer, DWORD dwLength);
}

struct SYSTEMTIME
{
    WORD wYear;
    WORD wMonth;
    WORD wDayOfWeek;
    WORD wDay;
    WORD wHour;
    WORD wMinute;
    WORD wSecond;
    WORD wMilliseconds;
}

struct TIME_ZONE_INFORMATION {
    LONG Bias;
    WCHAR StandardName[ 32 ];
    SYSTEMTIME StandardDate;
    LONG StandardBias;
    WCHAR DaylightName[ 32 ];
    SYSTEMTIME DaylightDate;
    LONG DaylightBias;
}

enum
{
    TIME_ZONE_ID_UNKNOWN =  0,
    TIME_ZONE_ID_STANDARD = 1,
    TIME_ZONE_ID_DAYLIGHT = 2,
}

extern (Windows) void GetSystemTime(SYSTEMTIME* lpSystemTime);
extern (Windows) BOOL GetFileTime(HANDLE hFile, FILETIME *lpCreationTime, FILETIME *lpLastAccessTime, FILETIME *lpLastWriteTime);
extern (Windows) void GetSystemTimeAsFileTime(FILETIME* lpSystemTimeAsFileTime);
extern (Windows) BOOL SetSystemTime(SYSTEMTIME* lpSystemTime);
extern (Windows) BOOL SetFileTime(HANDLE hFile, in FILETIME *lpCreationTime, in FILETIME *lpLastAccessTime, in FILETIME *lpLastWriteTime);
extern (Windows) void GetLocalTime(SYSTEMTIME* lpSystemTime);
extern (Windows) BOOL SetLocalTime(SYSTEMTIME* lpSystemTime);
extern (Windows) BOOL SystemTimeToTzSpecificLocalTime(TIME_ZONE_INFORMATION* lpTimeZoneInformation, SYSTEMTIME* lpUniversalTime, SYSTEMTIME* lpLocalTime);
extern (Windows) DWORD GetTimeZoneInformation(TIME_ZONE_INFORMATION* lpTimeZoneInformation);
extern (Windows) BOOL SetTimeZoneInformation(TIME_ZONE_INFORMATION* lpTimeZoneInformation);

extern (Windows) BOOL SystemTimeToFileTime(in SYSTEMTIME *lpSystemTime, FILETIME* lpFileTime);
extern (Windows) BOOL FileTimeToLocalFileTime(in FILETIME *lpFileTime, FILETIME* lpLocalFileTime);
extern (Windows) BOOL LocalFileTimeToFileTime(in FILETIME *lpLocalFileTime, FILETIME* lpFileTime);
extern (Windows) BOOL FileTimeToSystemTime(in FILETIME *lpFileTime, SYSTEMTIME* lpSystemTime);
extern (Windows) LONG CompareFileTime(in FILETIME *lpFileTime1, in FILETIME *lpFileTime2);
extern (Windows) BOOL FileTimeToDosDateTime(in FILETIME *lpFileTime, WORD* lpFatDate, WORD* lpFatTime);
extern (Windows) BOOL DosDateTimeToFileTime(WORD wFatDate, WORD wFatTime, FILETIME* lpFileTime);
extern (Windows) DWORD GetTickCount();
extern (Windows) BOOL SetSystemTimeAdjustment(DWORD dwTimeAdjustment, BOOL bTimeAdjustmentDisabled);
extern (Windows) BOOL GetSystemTimeAdjustment(DWORD* lpTimeAdjustment, DWORD* lpTimeIncrement, BOOL* lpTimeAdjustmentDisabled);
extern (Windows) DWORD FormatMessageA(DWORD dwFlags, LPCVOID lpSource, DWORD dwMessageId, DWORD dwLanguageId, LPSTR lpBuffer, DWORD nSize, void* *Arguments);extern (Windows) DWORD FormatMessageW(DWORD dwFlags, LPCVOID lpSource, DWORD dwMessageId, DWORD dwLanguageId, LPWSTR lpBuffer, DWORD nSize, void* *Arguments);

enum
{
    FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100,
    FORMAT_MESSAGE_IGNORE_INSERTS =  0x00000200,
    FORMAT_MESSAGE_FROM_STRING =     0x00000400,
    FORMAT_MESSAGE_FROM_HMODULE =    0x00000800,
    FORMAT_MESSAGE_FROM_SYSTEM =     0x00001000,
    FORMAT_MESSAGE_ARGUMENT_ARRAY =  0x00002000,
    FORMAT_MESSAGE_MAX_WIDTH_MASK =  0x000000FF,
};


//
//  Language IDs.
//
//  The following two combinations of primary language ID and
//  sublanguage ID have special semantics:
//
//    Primary Language ID   Sublanguage ID      Result
//    -------------------   ---------------     ------------------------
//    LANG_NEUTRAL          SUBLANG_NEUTRAL     Language neutral
//    LANG_NEUTRAL          SUBLANG_DEFAULT     User default language
//    LANG_NEUTRAL          SUBLANG_SYS_DEFAULT System default language
//

//
//  Primary language IDs.
//

enum
{
    LANG_NEUTRAL                     = 0x00,

    LANG_AFRIKAANS                   = 0x36,
    LANG_ALBANIAN                    = 0x1c,
    LANG_ARABIC                      = 0x01,
    LANG_BASQUE                      = 0x2d,
    LANG_BELARUSIAN                  = 0x23,
    LANG_BULGARIAN                   = 0x02,
    LANG_CATALAN                     = 0x03,
    LANG_CHINESE                     = 0x04,
    LANG_CROATIAN                    = 0x1a,
    LANG_CZECH                       = 0x05,
    LANG_DANISH                      = 0x06,
    LANG_DUTCH                       = 0x13,
    LANG_ENGLISH                     = 0x09,
    LANG_ESTONIAN                    = 0x25,
    LANG_FAEROESE                    = 0x38,
    LANG_FARSI                       = 0x29,
    LANG_FINNISH                     = 0x0b,
    LANG_FRENCH                      = 0x0c,
    LANG_GERMAN                      = 0x07,
    LANG_GREEK                       = 0x08,
    LANG_HEBREW                      = 0x0d,
    LANG_HUNGARIAN                   = 0x0e,
    LANG_ICELANDIC                   = 0x0f,
    LANG_INDONESIAN                  = 0x21,
    LANG_ITALIAN                     = 0x10,
    LANG_JAPANESE                    = 0x11,
    LANG_KOREAN                      = 0x12,
    LANG_LATVIAN                     = 0x26,
    LANG_LITHUANIAN                  = 0x27,
    LANG_NORWEGIAN                   = 0x14,
    LANG_POLISH                      = 0x15,
    LANG_PORTUGUESE                  = 0x16,
    LANG_ROMANIAN                    = 0x18,
    LANG_RUSSIAN                     = 0x19,
    LANG_SERBIAN                     = 0x1a,
    LANG_SLOVAK                      = 0x1b,
    LANG_SLOVENIAN                   = 0x24,
    LANG_SPANISH                     = 0x0a,
    LANG_SWEDISH                     = 0x1d,
    LANG_THAI                        = 0x1e,
    LANG_TURKISH                     = 0x1f,
    LANG_UKRAINIAN                   = 0x22,
    LANG_VIETNAMESE                  = 0x2a,
}
//
//  Sublanguage IDs.
//
//  The name immediately following SUBLANG_ dictates which primary
//  language ID that sublanguage ID can be combined with to form a
//  valid language ID.
//
enum
{
    SUBLANG_NEUTRAL =                  0x00,    // language neutral
    SUBLANG_DEFAULT =                  0x01,    // user default
    SUBLANG_SYS_DEFAULT =              0x02,    // system default

    SUBLANG_ARABIC_SAUDI_ARABIA =      0x01,    // Arabic (Saudi Arabia)
    SUBLANG_ARABIC_IRAQ =              0x02,    // Arabic (Iraq)
    SUBLANG_ARABIC_EGYPT =             0x03,    // Arabic (Egypt)
    SUBLANG_ARABIC_LIBYA =             0x04,    // Arabic (Libya)
    SUBLANG_ARABIC_ALGERIA =           0x05,    // Arabic (Algeria)
    SUBLANG_ARABIC_MOROCCO =           0x06,    // Arabic (Morocco)
    SUBLANG_ARABIC_TUNISIA =           0x07,    // Arabic (Tunisia)
    SUBLANG_ARABIC_OMAN =              0x08,    // Arabic (Oman)
    SUBLANG_ARABIC_YEMEN =             0x09,    // Arabic (Yemen)
    SUBLANG_ARABIC_SYRIA =             0x0a,    // Arabic (Syria)
    SUBLANG_ARABIC_JORDAN =            0x0b,    // Arabic (Jordan)
    SUBLANG_ARABIC_LEBANON =           0x0c,    // Arabic (Lebanon)
    SUBLANG_ARABIC_KUWAIT =            0x0d,    // Arabic (Kuwait)
    SUBLANG_ARABIC_UAE =               0x0e,    // Arabic (U.A.E)
    SUBLANG_ARABIC_BAHRAIN =           0x0f,    // Arabic (Bahrain)
    SUBLANG_ARABIC_QATAR =             0x10,    // Arabic (Qatar)
    SUBLANG_CHINESE_TRADITIONAL =      0x01,    // Chinese (Taiwan)
    SUBLANG_CHINESE_SIMPLIFIED =       0x02,    // Chinese (PR China)
    SUBLANG_CHINESE_HONGKONG =         0x03,    // Chinese (Hong Kong)
    SUBLANG_CHINESE_SINGAPORE =        0x04,    // Chinese (Singapore)
    SUBLANG_DUTCH =                    0x01,    // Dutch
    SUBLANG_DUTCH_BELGIAN =            0x02,    // Dutch (Belgian)
    SUBLANG_ENGLISH_US =               0x01,    // English (USA)
    SUBLANG_ENGLISH_UK =               0x02,    // English (UK)
    SUBLANG_ENGLISH_AUS =              0x03,    // English (Australian)
    SUBLANG_ENGLISH_CAN =              0x04,    // English (Canadian)
    SUBLANG_ENGLISH_NZ =               0x05,    // English (New Zealand)
    SUBLANG_ENGLISH_EIRE =             0x06,    // English (Irish)
    SUBLANG_ENGLISH_SOUTH_AFRICA =     0x07,    // English (South Africa)
    SUBLANG_ENGLISH_JAMAICA =          0x08,    // English (Jamaica)
    SUBLANG_ENGLISH_CARIBBEAN =        0x09,    // English (Caribbean)
    SUBLANG_ENGLISH_BELIZE =           0x0a,    // English (Belize)
    SUBLANG_ENGLISH_TRINIDAD =         0x0b,    // English (Trinidad)
    SUBLANG_FRENCH =                   0x01,    // French
    SUBLANG_FRENCH_BELGIAN =           0x02,    // French (Belgian)
    SUBLANG_FRENCH_CANADIAN =          0x03,    // French (Canadian)
    SUBLANG_FRENCH_SWISS =             0x04,    // French (Swiss)
    SUBLANG_FRENCH_LUXEMBOURG =        0x05,    // French (Luxembourg)
    SUBLANG_GERMAN =                   0x01,    // German
    SUBLANG_GERMAN_SWISS =             0x02,    // German (Swiss)
    SUBLANG_GERMAN_AUSTRIAN =          0x03,    // German (Austrian)
    SUBLANG_GERMAN_LUXEMBOURG =        0x04,    // German (Luxembourg)
    SUBLANG_GERMAN_LIECHTENSTEIN =     0x05,    // German (Liechtenstein)
    SUBLANG_ITALIAN =                  0x01,    // Italian
    SUBLANG_ITALIAN_SWISS =            0x02,    // Italian (Swiss)
    SUBLANG_KOREAN =                   0x01,    // Korean (Extended Wansung)
    SUBLANG_KOREAN_JOHAB =             0x02,    // Korean (Johab)
    SUBLANG_NORWEGIAN_BOKMAL =         0x01,    // Norwegian (Bokmal)
    SUBLANG_NORWEGIAN_NYNORSK =        0x02,    // Norwegian (Nynorsk)
    SUBLANG_PORTUGUESE =               0x02,    // Portuguese
    SUBLANG_PORTUGUESE_BRAZILIAN =     0x01,    // Portuguese (Brazilian)
    SUBLANG_SERBIAN_LATIN =            0x02,    // Serbian (Latin)
    SUBLANG_SERBIAN_CYRILLIC =         0x03,    // Serbian (Cyrillic)
    SUBLANG_SPANISH =                  0x01,    // Spanish (Castilian)
    SUBLANG_SPANISH_MEXICAN =          0x02,    // Spanish (Mexican)
    SUBLANG_SPANISH_MODERN =           0x03,    // Spanish (Modern)
    SUBLANG_SPANISH_GUATEMALA =        0x04,    // Spanish (Guatemala)
    SUBLANG_SPANISH_COSTA_RICA =       0x05,    // Spanish (Costa Rica)
    SUBLANG_SPANISH_PANAMA =           0x06,    // Spanish (Panama)
    SUBLANG_SPANISH_DOMINICAN_REPUBLIC = 0x07,  // Spanish (Dominican Republic)
    SUBLANG_SPANISH_VENEZUELA =        0x08,    // Spanish (Venezuela)
    SUBLANG_SPANISH_COLOMBIA =         0x09,    // Spanish (Colombia)
    SUBLANG_SPANISH_PERU =             0x0a,    // Spanish (Peru)
    SUBLANG_SPANISH_ARGENTINA =        0x0b,    // Spanish (Argentina)
    SUBLANG_SPANISH_ECUADOR =          0x0c,    // Spanish (Ecuador)
    SUBLANG_SPANISH_CHILE =            0x0d,    // Spanish (Chile)
    SUBLANG_SPANISH_URUGUAY =          0x0e,    // Spanish (Uruguay)
    SUBLANG_SPANISH_PARAGUAY =         0x0f,    // Spanish (Paraguay)
    SUBLANG_SPANISH_BOLIVIA =          0x10,    // Spanish (Bolivia)
    SUBLANG_SPANISH_EL_SALVADOR =      0x11,    // Spanish (El Salvador)
    SUBLANG_SPANISH_HONDURAS =         0x12,    // Spanish (Honduras)
    SUBLANG_SPANISH_NICARAGUA =        0x13,    // Spanish (Nicaragua)
    SUBLANG_SPANISH_PUERTO_RICO =      0x14,    // Spanish (Puerto Rico)
    SUBLANG_SWEDISH =                  0x01,    // Swedish
    SUBLANG_SWEDISH_FINLAND =          0x02,    // Swedish (Finland)
}
//
//  Sorting IDs.
//

enum
{
    SORT_DEFAULT                   = 0x0,    // sorting default

    SORT_JAPANESE_XJIS             = 0x0,    // Japanese XJIS order
    SORT_JAPANESE_UNICODE          = 0x1,    // Japanese Unicode order

    SORT_CHINESE_BIG5              = 0x0,    // Chinese BIG5 order
    SORT_CHINESE_PRCP              = 0x0,    // PRC Chinese Phonetic order
    SORT_CHINESE_UNICODE           = 0x1,    // Chinese Unicode order
    SORT_CHINESE_PRC               = 0x2,    // PRC Chinese Stroke Count order

    SORT_KOREAN_KSC                = 0x0,    // Korean KSC order
    SORT_KOREAN_UNICODE            = 0x1,    // Korean Unicode order

    SORT_GERMAN_PHONE_BOOK         = 0x1,    // German Phone Book order
}

// end_r_winnt

//
//  A language ID is a 16 bit value which is the combination of a
//  primary language ID and a secondary language ID.  The bits are
//  allocated as follows:
//
//       +-----------------------+-------------------------+
//       |     Sublanguage ID    |   Primary Language ID   |
//       +-----------------------+-------------------------+
//        15                   10 9                       0   bit
//
//
//  Language ID creation/extraction macros:
//
//    MAKELANGID    - construct language id from a primary language id and
//                    a sublanguage id.
//    PRIMARYLANGID - extract primary language id from a language id.
//    SUBLANGID     - extract sublanguage id from a language id.
//

int MAKELANGID(int p, int s) { return ((cast(WORD)s) << 10) | cast(WORD)p; }
WORD PRIMARYLANGID(int lgid) { return cast(WORD)(lgid & 0x3ff); }
WORD SUBLANGID(int lgid)     { return cast(WORD)(lgid >> 10); }


struct FLOATING_SAVE_AREA {
    DWORD   ControlWord;
    DWORD   StatusWord;
    DWORD   TagWord;
    DWORD   ErrorOffset;
    DWORD   ErrorSelector;
    DWORD   DataOffset;
    DWORD   DataSelector;
    BYTE    RegisterArea[80 ];
    DWORD   Cr0NpxState;
}

enum
{
    SIZE_OF_80387_REGISTERS =      80,
//
// The following flags control the contents of the CONTEXT structure.
//
    CONTEXT_i386 =    0x00010000,    // this assumes that i386 and
    CONTEXT_i486 =    0x00010000,    // i486 have identical context records

    CONTEXT_CONTROL =         (CONTEXT_i386 | 0x00000001), // SS:SP, CS:IP, FLAGS, BP
    CONTEXT_INTEGER =         (CONTEXT_i386 | 0x00000002), // AX, BX, CX, DX, SI, DI
    CONTEXT_SEGMENTS =        (CONTEXT_i386 | 0x00000004), // DS, ES, FS, GS
    CONTEXT_FLOATING_POINT =  (CONTEXT_i386 | 0x00000008), // 387 state
    CONTEXT_DEBUG_REGISTERS = (CONTEXT_i386 | 0x00000010), // DB 0-3,6,7

    CONTEXT_FULL = (CONTEXT_CONTROL | CONTEXT_INTEGER | CONTEXT_SEGMENTS),
}

struct CONTEXT
{

    //
    // The flags values within this flag control the contents of
    // a CONTEXT record.
    //
    // If the context record is used as an input parameter, then
    // for each portion of the context record controlled by a flag
    // whose value is set, it is assumed that that portion of the
    // context record contains valid context. If the context record
    // is being used to modify a threads context, then only that
    // portion of the threads context will be modified.
    //
    // If the context record is used as an IN OUT parameter to capture
    // the context of a thread, then only those portions of the thread's
    // context corresponding to set flags will be returned.
    //
    // The context record is never used as an OUT only parameter.
    //

    DWORD ContextFlags;

    //
    // This section is specified/returned if CONTEXT_DEBUG_REGISTERS is
    // set in ContextFlags.  Note that CONTEXT_DEBUG_REGISTERS is NOT
    // included in CONTEXT_FULL.
    //

    DWORD   Dr0;
    DWORD   Dr1;
    DWORD   Dr2;
    DWORD   Dr3;
    DWORD   Dr6;
    DWORD   Dr7;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_FLOATING_POINT.
    //

    FLOATING_SAVE_AREA FloatSave;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_SEGMENTS.
    //

    DWORD   SegGs;
    DWORD   SegFs;
    DWORD   SegEs;
    DWORD   SegDs;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_INTEGER.
    //

    DWORD   Edi;
    DWORD   Esi;
    DWORD   Ebx;
    DWORD   Edx;
    DWORD   Ecx;
    DWORD   Eax;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_CONTROL.
    //

    DWORD   Ebp;
    DWORD   Eip;
    DWORD   SegCs;              // MUST BE SANITIZED
    DWORD   EFlags;             // MUST BE SANITIZED
    DWORD   Esp;
    DWORD   SegSs;
}

enum ADDRESS_MODE
{
    AddrMode1616,
    AddrMode1632,
    AddrModeReal,
    AddrModeFlat
}

struct ADDRESS
{
    DWORD         Offset;
    WORD          Segment;
    ADDRESS_MODE  Mode;
}

struct ADDRESS64
{
    DWORD64       Offset;
    WORD          Segment;
    ADDRESS_MODE  Mode;
}

struct KDHELP
{
    DWORD       Thread;
    DWORD       ThCallbackStack;
    DWORD       NextCallback;
    DWORD       FramePointer;
    DWORD       KiCallUserMode;
    DWORD       KeUserCallbackDispatcher;
    DWORD       SystemRangeStart;
    DWORD       ThCallbackBStore;
    DWORD       KiUserExceptionDispatcher;
    DWORD       StackBase;
    DWORD       StackLimit;
    DWORD[5]    Reserved;
}

struct KDHELP64
{
    DWORD64     Thread;
    DWORD       ThCallbackStack;
    DWORD       ThCallbackBStore;
    DWORD       NextCallback;
    DWORD       FramePointer;
    DWORD64     KiCallUserMode;
    DWORD64     KeUserCallbackDispatcher;
    DWORD64     SystemRangeStart;
    DWORD64     KiUserExceptionDispatcher;
    DWORD64     StackBase;
    DWORD64     StackLimit;
    DWORD64[5]  Reserved;
}

struct STACKFRAME
{
    ADDRESS     AddrPC;
    ADDRESS     AddrReturn;
    ADDRESS     AddrFrame;
    ADDRESS     AddrStack;
    PVOID       FuncTableEntry;
    DWORD[4]    Params;
    BOOL        Far;
    BOOL        Virtual;
    DWORD[3]    Reserved;
    KDHELP      KdHelp;
    ADDRESS     AddrBStore;
}

struct STACKFRAME64
{
    ADDRESS64   AddrPC;
    ADDRESS64   AddrReturn;
    ADDRESS64   AddrFrame;
    ADDRESS64   AddrStack;
    ADDRESS64   AddrBStore;
    PVOID       FuncTableEntry;
    DWORD64[4]  Params;
    BOOL        Far;
    BOOL        Virtual;
    DWORD64[3]  Reserved;
    KDHELP64    KdHelp;
}

enum
{
    THREAD_BASE_PRIORITY_LOWRT =  15,  // value that gets a thread to LowRealtime-1
    THREAD_BASE_PRIORITY_MAX =    2,   // maximum thread base priority boost
    THREAD_BASE_PRIORITY_MIN =    -2,  // minimum thread base priority boost
    THREAD_BASE_PRIORITY_IDLE =   -15, // value that gets a thread to idle

    THREAD_PRIORITY_LOWEST =          THREAD_BASE_PRIORITY_MIN,
    THREAD_PRIORITY_BELOW_NORMAL =    (THREAD_PRIORITY_LOWEST+1),
    THREAD_PRIORITY_NORMAL =          0,
    THREAD_PRIORITY_HIGHEST =         THREAD_BASE_PRIORITY_MAX,
    THREAD_PRIORITY_ABOVE_NORMAL =    (THREAD_PRIORITY_HIGHEST-1),
    THREAD_PRIORITY_ERROR_RETURN =    int.max,

    THREAD_PRIORITY_TIME_CRITICAL =   THREAD_BASE_PRIORITY_LOWRT,
    THREAD_PRIORITY_IDLE =            THREAD_BASE_PRIORITY_IDLE,
}

extern (Windows) HANDLE GetCurrentThread();
extern (Windows) BOOL GetProcessTimes(HANDLE hProcess, LPFILETIME lpCreationTime, LPFILETIME lpExitTime, LPFILETIME lpKernelTime, LPFILETIME lpUserTime);
extern (Windows) HANDLE GetCurrentProcess();
extern (Windows) DWORD GetCurrentProcessId();
extern (Windows) BOOL DuplicateHandle (HANDLE sourceProcess, HANDLE sourceThread,
        HANDLE targetProcessHandle, HANDLE *targetHandle, DWORD access,
        BOOL inheritHandle, DWORD options);
extern (Windows) DWORD GetCurrentThreadId();
extern (Windows) BOOL SetThreadPriority(HANDLE hThread, int nPriority);
extern (Windows) BOOL SetThreadPriorityBoost(HANDLE hThread, BOOL bDisablePriorityBoost);
extern (Windows) BOOL GetThreadPriorityBoost(HANDLE hThread, PBOOL pDisablePriorityBoost);
extern (Windows) BOOL GetThreadTimes(HANDLE hThread, LPFILETIME lpCreationTime, LPFILETIME lpExitTime, LPFILETIME lpKernelTime, LPFILETIME lpUserTime);
extern (Windows) int GetThreadPriority(HANDLE hThread);
extern (Windows) BOOL GetThreadContext(HANDLE hThread, CONTEXT* lpContext);
extern (Windows) BOOL SetThreadContext(HANDLE hThread, CONTEXT* lpContext);
extern (Windows) DWORD SuspendThread(HANDLE hThread);
extern (Windows) DWORD ResumeThread(HANDLE hThread);
extern (Windows) DWORD WaitForSingleObject(HANDLE hHandle, DWORD dwMilliseconds);
extern (Windows) DWORD WaitForMultipleObjects(DWORD nCount, HANDLE *lpHandles, BOOL bWaitAll, DWORD dwMilliseconds);
extern (Windows) void Sleep(DWORD dwMilliseconds);

// Synchronization

extern (Windows)
{
LONG  InterlockedIncrement(LPLONG lpAddend);
LONG  InterlockedDecrement(LPLONG lpAddend);
LONG  InterlockedExchange(LPLONG Target, LONG Value);
LONG  InterlockedExchangeAdd(LPLONG Addend, LONG Value);
PVOID InterlockedCompareExchange(PVOID *Destination, PVOID Exchange, PVOID Comperand);

void InitializeCriticalSection(CRITICAL_SECTION * lpCriticalSection);
void EnterCriticalSection(CRITICAL_SECTION * lpCriticalSection);
BOOL TryEnterCriticalSection(CRITICAL_SECTION * lpCriticalSection);
void LeaveCriticalSection(CRITICAL_SECTION * lpCriticalSection);
void DeleteCriticalSection(CRITICAL_SECTION * lpCriticalSection);

}



extern (Windows) BOOL QueryPerformanceCounter(long* lpPerformanceCount);
extern (Windows) BOOL QueryPerformanceFrequency(long* lpFrequency);

enum
{
    WM_NOTIFY =                       0x004E,
    WM_INPUTLANGCHANGEREQUEST =       0x0050,
    WM_INPUTLANGCHANGE =              0x0051,
    WM_TCARD =                        0x0052,
    WM_HELP =                         0x0053,
    WM_USERCHANGED =                  0x0054,
    WM_NOTIFYFORMAT =                 0x0055,

    NFR_ANSI =                             1,
    NFR_UNICODE =                          2,
    NF_QUERY =                             3,
    NF_REQUERY =                           4,

    WM_CONTEXTMENU =                  0x007B,
    WM_STYLECHANGING =                0x007C,
    WM_STYLECHANGED =                 0x007D,
    WM_DISPLAYCHANGE =                0x007E,
    WM_GETICON =                      0x007F,
    WM_SETICON =                      0x0080,



    WM_NCCREATE =                     0x0081,
    WM_NCDESTROY =                    0x0082,
    WM_NCCALCSIZE =                   0x0083,
    WM_NCHITTEST =                    0x0084,
    WM_NCPAINT =                      0x0085,
    WM_NCACTIVATE =                   0x0086,
    WM_GETDLGCODE =                   0x0087,

    WM_NCMOUSEMOVE =                  0x00A0,
    WM_NCLBUTTONDOWN =                0x00A1,
    WM_NCLBUTTONUP =                  0x00A2,
    WM_NCLBUTTONDBLCLK =              0x00A3,
    WM_NCRBUTTONDOWN =                0x00A4,
    WM_NCRBUTTONUP =                  0x00A5,
    WM_NCRBUTTONDBLCLK =              0x00A6,
    WM_NCMBUTTONDOWN =                0x00A7,
    WM_NCMBUTTONUP =                  0x00A8,
    WM_NCMBUTTONDBLCLK =              0x00A9,

    WM_KEYFIRST =                     0x0100,
    WM_KEYDOWN =                      0x0100,
    WM_KEYUP =                        0x0101,
    WM_CHAR =                         0x0102,
    WM_DEADCHAR =                     0x0103,
    WM_SYSKEYDOWN =                   0x0104,
    WM_SYSKEYUP =                     0x0105,
    WM_SYSCHAR =                      0x0106,
    WM_SYSDEADCHAR =                  0x0107,
    WM_KEYLAST =                      0x0108,


    WM_IME_STARTCOMPOSITION =         0x010D,
    WM_IME_ENDCOMPOSITION =           0x010E,
    WM_IME_COMPOSITION =              0x010F,
    WM_IME_KEYLAST =                  0x010F,


    WM_INITDIALOG =                   0x0110,
    WM_COMMAND =                      0x0111,
    WM_SYSCOMMAND =                   0x0112,
    WM_TIMER =                        0x0113,
    WM_HSCROLL =                      0x0114,
    WM_VSCROLL =                      0x0115,
    WM_INITMENU =                     0x0116,
    WM_INITMENUPOPUP =                0x0117,
    WM_MENUSELECT =                   0x011F,
    WM_MENUCHAR =                     0x0120,
    WM_ENTERIDLE =                    0x0121,

    WM_CTLCOLORMSGBOX =               0x0132,
    WM_CTLCOLOREDIT =                 0x0133,
    WM_CTLCOLORLISTBOX =              0x0134,
    WM_CTLCOLORBTN =                  0x0135,
    WM_CTLCOLORDLG =                  0x0136,
    WM_CTLCOLORSCROLLBAR =            0x0137,
    WM_CTLCOLORSTATIC =               0x0138,



    WM_MOUSEFIRST =                   0x0200,
    WM_MOUSEMOVE =                    0x0200,
    WM_LBUTTONDOWN =                  0x0201,
    WM_LBUTTONUP =                    0x0202,
    WM_LBUTTONDBLCLK =                0x0203,
    WM_RBUTTONDOWN =                  0x0204,
    WM_RBUTTONUP =                    0x0205,
    WM_RBUTTONDBLCLK =                0x0206,
    WM_MBUTTONDOWN =                  0x0207,
    WM_MBUTTONUP =                    0x0208,
    WM_MBUTTONDBLCLK =                0x0209,



    WM_MOUSELAST =                    0x0209,








    WM_PARENTNOTIFY =                 0x0210,
    MENULOOP_WINDOW =                 0,
    MENULOOP_POPUP =                  1,
    WM_ENTERMENULOOP =                0x0211,
    WM_EXITMENULOOP =                 0x0212,


    WM_NEXTMENU =                     0x0213,
}

enum
{
/*
 * Dialog Box Command IDs
 */
    IDOK =                1,
    IDCANCEL =            2,
    IDABORT =             3,
    IDRETRY =             4,
    IDIGNORE =            5,
    IDYES =               6,
    IDNO =                7,

    IDCLOSE =         8,
    IDHELP =          9,


// end_r_winuser



/*
 * Control Manager Structures and Definitions
 */



// begin_r_winuser

/*
 * Edit Control Styles
 */
    ES_LEFT =             0x0000,
    ES_CENTER =           0x0001,
    ES_RIGHT =            0x0002,
    ES_MULTILINE =        0x0004,
    ES_UPPERCASE =        0x0008,
    ES_LOWERCASE =        0x0010,
    ES_PASSWORD =         0x0020,
    ES_AUTOVSCROLL =      0x0040,
    ES_AUTOHSCROLL =      0x0080,
    ES_NOHIDESEL =        0x0100,
    ES_OEMCONVERT =       0x0400,
    ES_READONLY =         0x0800,
    ES_WANTRETURN =       0x1000,

    ES_NUMBER =           0x2000,


// end_r_winuser



/*
 * Edit Control Notification Codes
 */
    EN_SETFOCUS =         0x0100,
    EN_KILLFOCUS =        0x0200,
    EN_CHANGE =           0x0300,
    EN_UPDATE =           0x0400,
    EN_ERRSPACE =         0x0500,
    EN_MAXTEXT =          0x0501,
    EN_HSCROLL =          0x0601,
    EN_VSCROLL =          0x0602,


/* Edit control EM_SETMARGIN parameters */
    EC_LEFTMARGIN =       0x0001,
    EC_RIGHTMARGIN =      0x0002,
    EC_USEFONTINFO =      0xffff,




// begin_r_winuser

/*
 * Edit Control Messages
 */
    EM_GETSEL =               0x00B0,
    EM_SETSEL =               0x00B1,
    EM_GETRECT =              0x00B2,
    EM_SETRECT =              0x00B3,
    EM_SETRECTNP =            0x00B4,
    EM_SCROLL =               0x00B5,
    EM_LINESCROLL =           0x00B6,
    EM_SCROLLCARET =          0x00B7,
    EM_GETMODIFY =            0x00B8,
    EM_SETMODIFY =            0x00B9,
    EM_GETLINECOUNT =         0x00BA,
    EM_LINEINDEX =            0x00BB,
    EM_SETHANDLE =            0x00BC,
    EM_GETHANDLE =            0x00BD,
    EM_GETTHUMB =             0x00BE,
    EM_LINELENGTH =           0x00C1,
    EM_REPLACESEL =           0x00C2,
    EM_GETLINE =              0x00C4,
    EM_LIMITTEXT =            0x00C5,
    EM_CANUNDO =              0x00C6,
    EM_UNDO =                 0x00C7,
    EM_FMTLINES =             0x00C8,
    EM_LINEFROMCHAR =         0x00C9,
    EM_SETTABSTOPS =          0x00CB,
    EM_SETPASSWORDCHAR =      0x00CC,
    EM_EMPTYUNDOBUFFER =      0x00CD,
    EM_GETFIRSTVISIBLELINE =  0x00CE,
    EM_SETREADONLY =          0x00CF,
    EM_SETWORDBREAKPROC =     0x00D0,
    EM_GETWORDBREAKPROC =     0x00D1,
    EM_GETPASSWORDCHAR =      0x00D2,

    EM_SETMARGINS =           0x00D3,
    EM_GETMARGINS =           0x00D4,
    EM_SETLIMITTEXT =         EM_LIMITTEXT, /* ;win40 Name change */
    EM_GETLIMITTEXT =         0x00D5,
    EM_POSFROMCHAR =          0x00D6,
    EM_CHARFROMPOS =          0x00D7,



// end_r_winuser


/*
 * EDITWORDBREAKPROC code values
 */
    WB_LEFT =            0,
    WB_RIGHT =           1,
    WB_ISDELIMITER =     2,

// begin_r_winuser

/*
 * Button Control Styles
 */
    BS_PUSHBUTTON =       0x00000000,
    BS_DEFPUSHBUTTON =    0x00000001,
    BS_CHECKBOX =         0x00000002,
    BS_AUTOCHECKBOX =     0x00000003,
    BS_RADIOBUTTON =      0x00000004,
    BS_3STATE =           0x00000005,
    BS_AUTO3STATE =       0x00000006,
    BS_GROUPBOX =         0x00000007,
    BS_USERBUTTON =       0x00000008,
    BS_AUTORADIOBUTTON =  0x00000009,
    BS_OWNERDRAW =        0x0000000B,
    BS_LEFTTEXT =         0x00000020,

    BS_TEXT =             0x00000000,
    BS_ICON =             0x00000040,
    BS_BITMAP =           0x00000080,
    BS_LEFT =             0x00000100,
    BS_RIGHT =            0x00000200,
    BS_CENTER =           0x00000300,
    BS_TOP =              0x00000400,
    BS_BOTTOM =           0x00000800,
    BS_VCENTER =          0x00000C00,
    BS_PUSHLIKE =         0x00001000,
    BS_MULTILINE =        0x00002000,
    BS_NOTIFY =           0x00004000,
    BS_FLAT =             0x00008000,
    BS_RIGHTBUTTON =      BS_LEFTTEXT,



/*
 * User Button Notification Codes
 */
    BN_CLICKED =          0,
    BN_PAINT =            1,
    BN_HILITE =           2,
    BN_UNHILITE =         3,
    BN_DISABLE =          4,
    BN_DOUBLECLICKED =    5,

    BN_PUSHED =           BN_HILITE,
    BN_UNPUSHED =         BN_UNHILITE,
    BN_DBLCLK =           BN_DOUBLECLICKED,
    BN_SETFOCUS =         6,
    BN_KILLFOCUS =        7,

/*
 * Button Control Messages
 */
    BM_GETCHECK =        0x00F0,
    BM_SETCHECK =        0x00F1,
    BM_GETSTATE =        0x00F2,
    BM_SETSTATE =        0x00F3,
    BM_SETSTYLE =        0x00F4,

    BM_CLICK =           0x00F5,
    BM_GETIMAGE =        0x00F6,
    BM_SETIMAGE =        0x00F7,

    BST_UNCHECKED =      0x0000,
    BST_CHECKED =        0x0001,
    BST_INDETERMINATE =  0x0002,
    BST_PUSHED =         0x0004,
    BST_FOCUS =          0x0008,


/*
 * Static Control Constants
 */
    SS_LEFT =             0x00000000,
    SS_CENTER =           0x00000001,
    SS_RIGHT =            0x00000002,
    SS_ICON =             0x00000003,
    SS_BLACKRECT =        0x00000004,
    SS_GRAYRECT =         0x00000005,
    SS_WHITERECT =        0x00000006,
    SS_BLACKFRAME =       0x00000007,
    SS_GRAYFRAME =        0x00000008,
    SS_WHITEFRAME =       0x00000009,
    SS_USERITEM =         0x0000000A,
    SS_SIMPLE =           0x0000000B,
    SS_LEFTNOWORDWRAP =   0x0000000C,

    SS_OWNERDRAW =        0x0000000D,
    SS_BITMAP =           0x0000000E,
    SS_ENHMETAFILE =      0x0000000F,
    SS_ETCHEDHORZ =       0x00000010,
    SS_ETCHEDVERT =       0x00000011,
    SS_ETCHEDFRAME =      0x00000012,
    SS_TYPEMASK =         0x0000001F,

    SS_NOPREFIX =         0x00000080, /* Don't do "&" character translation */

    SS_NOTIFY =           0x00000100,
    SS_CENTERIMAGE =      0x00000200,
    SS_RIGHTJUST =        0x00000400,
    SS_REALSIZEIMAGE =    0x00000800,
    SS_SUNKEN =           0x00001000,
    SS_ENDELLIPSIS =      0x00004000,
    SS_PATHELLIPSIS =     0x00008000,
    SS_WORDELLIPSIS =     0x0000C000,
    SS_ELLIPSISMASK =     0x0000C000,


// end_r_winuser


/*
 * Static Control Mesages
 */
    STM_SETICON =         0x0170,
    STM_GETICON =         0x0171,

    STM_SETIMAGE =        0x0172,
    STM_GETIMAGE =        0x0173,
    STN_CLICKED =         0,
    STN_DBLCLK =          1,
    STN_ENABLE =          2,
    STN_DISABLE =         3,

    STM_MSGMAX =          0x0174,
}


enum
{
/*
 * Window Messages
 */

    WM_NULL =                         0x0000,
    WM_CREATE =                       0x0001,
    WM_DESTROY =                      0x0002,
    WM_MOVE =                         0x0003,
    WM_SIZE =                         0x0005,

    WM_ACTIVATE =                     0x0006,
/*
 * WM_ACTIVATE state values
 */
    WA_INACTIVE =     0,
    WA_ACTIVE =       1,
    WA_CLICKACTIVE =  2,

    WM_SETFOCUS =                     0x0007,
    WM_KILLFOCUS =                    0x0008,
    WM_ENABLE =                       0x000A,
    WM_SETREDRAW =                    0x000B,
    WM_SETTEXT =                      0x000C,
    WM_GETTEXT =                      0x000D,
    WM_GETTEXTLENGTH =                0x000E,
    WM_PAINT =                        0x000F,
    WM_CLOSE =                        0x0010,
    WM_QUERYENDSESSION =              0x0011,
    WM_QUIT =                         0x0012,
    WM_QUERYOPEN =                    0x0013,
    WM_ERASEBKGND =                   0x0014,
    WM_SYSCOLORCHANGE =               0x0015,
    WM_ENDSESSION =                   0x0016,
    WM_SHOWWINDOW =                   0x0018,
    WM_WININICHANGE =                 0x001A,

    WM_SETTINGCHANGE =                WM_WININICHANGE,



    WM_DEVMODECHANGE =                0x001B,
    WM_ACTIVATEAPP =                  0x001C,
    WM_FONTCHANGE =                   0x001D,
    WM_TIMECHANGE =                   0x001E,
    WM_CANCELMODE =                   0x001F,
    WM_SETCURSOR =                    0x0020,
    WM_MOUSEACTIVATE =                0x0021,
    WM_CHILDACTIVATE =                0x0022,
    WM_QUEUESYNC =                    0x0023,

    WM_GETMINMAXINFO =                0x0024,
}

struct RECT
{
    LONG    left;
    LONG    top;
    LONG    right;
    LONG    bottom;
}
alias RECT* PRECT, NPRECT, LPRECT;

struct PAINTSTRUCT {
    HDC         hdc;
    BOOL        fErase;
    RECT        rcPaint;
    BOOL        fRestore;
    BOOL        fIncUpdate;
    BYTE        rgbReserved[32];
}
alias PAINTSTRUCT* PPAINTSTRUCT, NPPAINTSTRUCT, LPPAINTSTRUCT;

// flags for GetDCEx()

enum
{
    DCX_WINDOW =           0x00000001,
    DCX_CACHE =            0x00000002,
    DCX_NORESETATTRS =     0x00000004,
    DCX_CLIPCHILDREN =     0x00000008,
    DCX_CLIPSIBLINGS =     0x00000010,
    DCX_PARENTCLIP =       0x00000020,
    DCX_EXCLUDERGN =       0x00000040,
    DCX_INTERSECTRGN =     0x00000080,
    DCX_EXCLUDEUPDATE =    0x00000100,
    DCX_INTERSECTUPDATE =  0x00000200,
    DCX_LOCKWINDOWUPDATE = 0x00000400,
    DCX_VALIDATE =         0x00200000,
}

extern (Windows)
{
 BOOL UpdateWindow(HWND hWnd);
 HWND SetActiveWindow(HWND hWnd);
 HWND GetForegroundWindow();
 BOOL PaintDesktop(HDC hdc);
 BOOL SetForegroundWindow(HWND hWnd);
 HWND WindowFromDC(HDC hDC);
 HDC GetDC(HWND hWnd);
 HDC GetDCEx(HWND hWnd, HRGN hrgnClip, DWORD flags);
 HDC GetWindowDC(HWND hWnd);
 int ReleaseDC(HWND hWnd, HDC hDC);
 HDC BeginPaint(HWND hWnd, LPPAINTSTRUCT lpPaint);
 BOOL EndPaint(HWND hWnd, PAINTSTRUCT *lpPaint);
 BOOL GetUpdateRect(HWND hWnd, LPRECT lpRect, BOOL bErase);
 int GetUpdateRgn(HWND hWnd, HRGN hRgn, BOOL bErase);
 int SetWindowRgn(HWND hWnd, HRGN hRgn, BOOL bRedraw);
 int GetWindowRgn(HWND hWnd, HRGN hRgn);
 int ExcludeUpdateRgn(HDC hDC, HWND hWnd);
 BOOL InvalidateRect(HWND hWnd, RECT *lpRect, BOOL bErase);
 BOOL ValidateRect(HWND hWnd, RECT *lpRect);
 BOOL InvalidateRgn(HWND hWnd, HRGN hRgn, BOOL bErase);
 BOOL ValidateRgn(HWND hWnd, HRGN hRgn);
 BOOL RedrawWindow(HWND hWnd, RECT *lprcUpdate, HRGN hrgnUpdate, UINT flags);
}

// flags for RedrawWindow()
enum
{
    RDW_INVALIDATE =          0x0001,
    RDW_INTERNALPAINT =       0x0002,
    RDW_ERASE =               0x0004,
    RDW_VALIDATE =            0x0008,
    RDW_NOINTERNALPAINT =     0x0010,
    RDW_NOERASE =             0x0020,
    RDW_NOCHILDREN =          0x0040,
    RDW_ALLCHILDREN =         0x0080,
    RDW_UPDATENOW =           0x0100,
    RDW_ERASENOW =            0x0200,
    RDW_FRAME =               0x0400,
    RDW_NOFRAME =             0x0800,
}

extern (Windows)
{
 BOOL GetClientRect(HWND hWnd, LPRECT lpRect);
 BOOL GetWindowRect(HWND hWnd, LPRECT lpRect);
 BOOL AdjustWindowRect(LPRECT lpRect, DWORD dwStyle, BOOL bMenu);
 BOOL AdjustWindowRectEx(LPRECT lpRect, DWORD dwStyle, BOOL bMenu, DWORD dwExStyle);
 HFONT CreateFontA(int, int, int, int, int, DWORD,
                             DWORD, DWORD, DWORD, DWORD, DWORD,
                             DWORD, DWORD, LPCSTR);
 HFONT CreateFontW(int, int, int, int, int, DWORD,
                             DWORD, DWORD, DWORD, DWORD, DWORD,
                             DWORD, DWORD, LPCWSTR);
}

enum
{
    OUT_DEFAULT_PRECIS =          0,
    OUT_STRING_PRECIS =           1,
    OUT_CHARACTER_PRECIS =        2,
    OUT_STROKE_PRECIS =           3,
    OUT_TT_PRECIS =               4,
    OUT_DEVICE_PRECIS =           5,
    OUT_RASTER_PRECIS =           6,
    OUT_TT_ONLY_PRECIS =          7,
    OUT_OUTLINE_PRECIS =          8,
    OUT_SCREEN_OUTLINE_PRECIS =   9,

    CLIP_DEFAULT_PRECIS =     0,
    CLIP_CHARACTER_PRECIS =   1,
    CLIP_STROKE_PRECIS =      2,
    CLIP_MASK =               0xf,
    CLIP_LH_ANGLES =          (1<<4),
    CLIP_TT_ALWAYS =          (2<<4),
    CLIP_EMBEDDED =           (8<<4),

    DEFAULT_QUALITY =         0,
    DRAFT_QUALITY =           1,
    PROOF_QUALITY =           2,

    NONANTIALIASED_QUALITY =  3,
    ANTIALIASED_QUALITY =     4,


    DEFAULT_PITCH =           0,
    FIXED_PITCH =             1,
    VARIABLE_PITCH =          2,

    MONO_FONT =               8,


    ANSI_CHARSET =            0,
    DEFAULT_CHARSET =         1,
    SYMBOL_CHARSET =          2,
    SHIFTJIS_CHARSET =        128,
    HANGEUL_CHARSET =         129,
    GB2312_CHARSET =          134,
    CHINESEBIG5_CHARSET =     136,
    OEM_CHARSET =             255,

    JOHAB_CHARSET =           130,
    HEBREW_CHARSET =          177,
    ARABIC_CHARSET =          178,
    GREEK_CHARSET =           161,
    TURKISH_CHARSET =         162,
    VIETNAMESE_CHARSET =      163,
    THAI_CHARSET =            222,
    EASTEUROPE_CHARSET =      238,
    RUSSIAN_CHARSET =         204,

    MAC_CHARSET =             77,
    BALTIC_CHARSET =          186,

    FS_LATIN1 =               0x00000001L,
    FS_LATIN2 =               0x00000002L,
    FS_CYRILLIC =             0x00000004L,
    FS_GREEK =                0x00000008L,
    FS_TURKISH =              0x00000010L,
    FS_HEBREW =               0x00000020L,
    FS_ARABIC =               0x00000040L,
    FS_BALTIC =               0x00000080L,
    FS_VIETNAMESE =           0x00000100L,
    FS_THAI =                 0x00010000L,
    FS_JISJAPAN =             0x00020000L,
    FS_CHINESESIMP =          0x00040000L,
    FS_WANSUNG =              0x00080000L,
    FS_CHINESETRAD =          0x00100000L,
    FS_JOHAB =                0x00200000L,
    FS_SYMBOL =               cast(int)0x80000000L,


/* Font Families */
    FF_DONTCARE =         (0<<4), /* Don't care or don't know. */
    FF_ROMAN =            (1<<4), /* Variable stroke width, serifed. */
                                    /* Times Roman, Century Schoolbook, etc. */
    FF_SWISS =            (2<<4), /* Variable stroke width, sans-serifed. */
                                    /* Helvetica, Swiss, etc. */
    FF_MODERN =           (3<<4), /* Constant stroke width, serifed or sans-serifed. */
                                    /* Pica, Elite, Courier, etc. */
    FF_SCRIPT =           (4<<4), /* Cursive, etc. */
    FF_DECORATIVE =       (5<<4), /* Old English, etc. */

/* Font Weights */
    FW_DONTCARE =         0,
    FW_THIN =             100,
    FW_EXTRALIGHT =       200,
    FW_LIGHT =            300,
    FW_NORMAL =           400,
    FW_MEDIUM =           500,
    FW_SEMIBOLD =         600,
    FW_BOLD =             700,
    FW_EXTRABOLD =        800,
    FW_HEAVY =            900,

    FW_ULTRALIGHT =       FW_EXTRALIGHT,
    FW_REGULAR =          FW_NORMAL,
    FW_DEMIBOLD =         FW_SEMIBOLD,
    FW_ULTRABOLD =        FW_EXTRABOLD,
    FW_BLACK =            FW_HEAVY,

    PANOSE_COUNT =               10,
    PAN_FAMILYTYPE_INDEX =        0,
    PAN_SERIFSTYLE_INDEX =        1,
    PAN_WEIGHT_INDEX =            2,
    PAN_PROPORTION_INDEX =        3,
    PAN_CONTRAST_INDEX =          4,
    PAN_STROKEVARIATION_INDEX =   5,
    PAN_ARMSTYLE_INDEX =          6,
    PAN_LETTERFORM_INDEX =        7,
    PAN_MIDLINE_INDEX =           8,
    PAN_XHEIGHT_INDEX =           9,

    PAN_CULTURE_LATIN =           0,
}

struct RGBQUAD {
        BYTE    rgbBlue;
        BYTE    rgbGreen;
        BYTE    rgbRed;
        BYTE    rgbReserved;
}
alias RGBQUAD* LPRGBQUAD;

struct BITMAPINFOHEADER
{
        DWORD      biSize;
        LONG       biWidth;
        LONG       biHeight;
        WORD       biPlanes;
        WORD       biBitCount;
        DWORD      biCompression;
        DWORD      biSizeImage;
        LONG       biXPelsPerMeter;
        LONG       biYPelsPerMeter;
        DWORD      biClrUsed;
        DWORD      biClrImportant;
}
alias BITMAPINFOHEADER* LPBITMAPINFOHEADER, PBITMAPINFOHEADER;

struct BITMAPINFO {
    BITMAPINFOHEADER    bmiHeader;
    RGBQUAD             bmiColors[1];
}
alias BITMAPINFO* LPBITMAPINFO, PBITMAPINFO;

struct PALETTEENTRY {
    BYTE        peRed;
    BYTE        peGreen;
    BYTE        peBlue;
    BYTE        peFlags;
}
alias PALETTEENTRY* PPALETTEENTRY, LPPALETTEENTRY;

struct LOGPALETTE {
    WORD        palVersion;
    WORD        palNumEntries;
    PALETTEENTRY        palPalEntry[1];
}
alias LOGPALETTE* PLOGPALETTE, NPLOGPALETTE, LPLOGPALETTE;

/* Pixel format descriptor */
struct PIXELFORMATDESCRIPTOR
{
    WORD  nSize;
    WORD  nVersion;
    DWORD dwFlags;
    BYTE  iPixelType;
    BYTE  cColorBits;
    BYTE  cRedBits;
    BYTE  cRedShift;
    BYTE  cGreenBits;
    BYTE  cGreenShift;
    BYTE  cBlueBits;
    BYTE  cBlueShift;
    BYTE  cAlphaBits;
    BYTE  cAlphaShift;
    BYTE  cAccumBits;
    BYTE  cAccumRedBits;
    BYTE  cAccumGreenBits;
    BYTE  cAccumBlueBits;
    BYTE  cAccumAlphaBits;
    BYTE  cDepthBits;
    BYTE  cStencilBits;
    BYTE  cAuxBuffers;
    BYTE  iLayerType;
    BYTE  bReserved;
    DWORD dwLayerMask;
    DWORD dwVisibleMask;
    DWORD dwDamageMask;
}
alias PIXELFORMATDESCRIPTOR* PPIXELFORMATDESCRIPTOR, LPPIXELFORMATDESCRIPTOR;


extern (Windows)
{
 BOOL   RoundRect(HDC, int, int, int, int, int, int);
 BOOL   ResizePalette(HPALETTE, UINT);
 int    SaveDC(HDC);
 int    SelectClipRgn(HDC, HRGN);
 int    ExtSelectClipRgn(HDC, HRGN, int);
 int    SetMetaRgn(HDC);
 HGDIOBJ   SelectObject(HDC, HGDIOBJ);
 HPALETTE   SelectPalette(HDC, HPALETTE, BOOL);
 COLORREF   SetBkColor(HDC, COLORREF);
 int     SetBkMode(HDC, int);
 LONG    SetBitmapBits(HBITMAP, DWORD, void *);
 UINT    SetBoundsRect(HDC,   RECT *, UINT);
 int     SetDIBits(HDC, HBITMAP, UINT, UINT, void *, BITMAPINFO *, UINT);
 int     SetDIBitsToDevice(HDC, int, int, DWORD, DWORD, int,
        int, UINT, UINT, void *, BITMAPINFO *, UINT);
 DWORD   SetMapperFlags(HDC, DWORD);
 int     SetGraphicsMode(HDC hdc, int iMode);
 int     SetMapMode(HDC, int);
 HMETAFILE     SetMetaFileBitsEx(UINT, BYTE *);
 UINT    SetPaletteEntries(HPALETTE, UINT, UINT, PALETTEENTRY *);
 COLORREF   SetPixel(HDC, int, int, COLORREF);
 BOOL     SetPixelV(HDC, int, int, COLORREF);
 BOOL    SetPixelFormat(HDC, int, PIXELFORMATDESCRIPTOR *);
 int     SetPolyFillMode(HDC, int);
 BOOL    StretchBlt(HDC, int, int, int, int, HDC, int, int, int, int, DWORD);
 BOOL    SetRectRgn(HRGN, int, int, int, int);
 int     StretchDIBits(HDC, int, int, int, int, int, int, int, int,
         void *, BITMAPINFO *, UINT, DWORD);
 int     SetROP2(HDC, int);
 int     SetStretchBltMode(HDC, int);
 UINT    SetSystemPaletteUse(HDC, UINT);
 int     SetTextCharacterExtra(HDC, int);
 COLORREF   SetTextColor(HDC, COLORREF);
 UINT    SetTextAlign(HDC, UINT);
 BOOL    SetTextJustification(HDC, int, int);
 BOOL    UpdateColors(HDC);
}

/* Text Alignment Options */
enum
{
    TA_NOUPDATECP =                0,
    TA_UPDATECP =                  1,

    TA_LEFT =                      0,
    TA_RIGHT =                     2,
    TA_CENTER =                    6,

    TA_TOP =                       0,
    TA_BOTTOM =                    8,
    TA_BASELINE =                  24,

    TA_RTLREADING =                256,
    TA_MASK =       (TA_BASELINE+TA_CENTER+TA_UPDATECP+TA_RTLREADING),
}

struct POINT
{
    LONG  x;
    LONG  y;
}
alias POINT* PPOINT, NPPOINT, LPPOINT;


extern (Windows)
{
 BOOL    MoveToEx(HDC, int, int, LPPOINT);
 BOOL    TextOutA(HDC, int, int, LPCSTR, int);
 BOOL    TextOutW(HDC, int, int, LPCWSTR, int);
}

extern (Windows) void PostQuitMessage(int nExitCode);
extern (Windows) LRESULT DefWindowProcA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);

alias LRESULT function (HWND, UINT, WPARAM, LPARAM) WNDPROC;

struct WNDCLASSEXA {
    UINT        cbSize;
    /* Win 3.x */
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCSTR      lpszMenuName;
    LPCSTR      lpszClassName;
    /* Win 4.0 */
    HICON       hIconSm;
}
alias WNDCLASSEXA* PWNDCLASSEXA, NPWNDCLASSEXA, LPWNDCLASSEXA;


struct WNDCLASSA {
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCSTR      lpszMenuName;
    LPCSTR      lpszClassName;
}
alias WNDCLASSA* PWNDCLASSA, NPWNDCLASSA, LPWNDCLASSA;
alias WNDCLASSA WNDCLASS;


/*
 * Window Styles
 */
enum : uint
{
    WS_OVERLAPPED =       0x00000000,
    WS_POPUP =            0x80000000,
    WS_CHILD =            0x40000000,
    WS_MINIMIZE =         0x20000000,
    WS_VISIBLE =          0x10000000,
    WS_DISABLED =         0x08000000,
    WS_CLIPSIBLINGS =     0x04000000,
    WS_CLIPCHILDREN =     0x02000000,
    WS_MAXIMIZE =         0x01000000,
    WS_CAPTION =          0x00C00000,  /* WS_BORDER | WS_DLGFRAME  */
    WS_BORDER =           0x00800000,
    WS_DLGFRAME =         0x00400000,
    WS_VSCROLL =          0x00200000,
    WS_HSCROLL =          0x00100000,
    WS_SYSMENU =          0x00080000,
    WS_THICKFRAME =       0x00040000,
    WS_GROUP =            0x00020000,
    WS_TABSTOP =          0x00010000,

    WS_MINIMIZEBOX =      0x00020000,
    WS_MAXIMIZEBOX =      0x00010000,

    WS_TILED =            WS_OVERLAPPED,
    WS_ICONIC =           WS_MINIMIZE,
    WS_SIZEBOX =          WS_THICKFRAME,

/*
 * Common Window Styles
 */
    WS_OVERLAPPEDWINDOW = (WS_OVERLAPPED |            WS_CAPTION |  WS_SYSMENU |  WS_THICKFRAME |            WS_MINIMIZEBOX |                 WS_MAXIMIZEBOX),
    WS_TILEDWINDOW =      WS_OVERLAPPEDWINDOW,
    WS_POPUPWINDOW =      (WS_POPUP |  WS_BORDER |  WS_SYSMENU),
    WS_CHILDWINDOW =      (WS_CHILD),
}

/*
 * Class styles
 */
enum
{
    CS_VREDRAW =          0x0001,
    CS_HREDRAW =          0x0002,
    CS_KEYCVTWINDOW =     0x0004,
    CS_DBLCLKS =          0x0008,
    CS_OWNDC =            0x0020,
    CS_CLASSDC =          0x0040,
    CS_PARENTDC =         0x0080,
    CS_NOKEYCVT =         0x0100,
    CS_NOCLOSE =          0x0200,
    CS_SAVEBITS =         0x0800,
    CS_BYTEALIGNCLIENT =  0x1000,
    CS_BYTEALIGNWINDOW =  0x2000,
    CS_GLOBALCLASS =      0x4000,


    CS_IME =              0x00010000,
}

extern (Windows)
{
 HICON LoadIconA(HINSTANCE hInstance, LPCSTR lpIconName);
 HICON LoadIconW(HINSTANCE hInstance, LPCWSTR lpIconName);
 HCURSOR LoadCursorA(HINSTANCE hInstance, LPCSTR lpCursorName);
 HCURSOR LoadCursorW(HINSTANCE hInstance, LPCWSTR lpCursorName);
}



const LPSTR IDI_APPLICATION =     cast(LPSTR)(32512);

const LPSTR IDC_ARROW =           cast(LPSTR)(32512);
const LPSTR IDC_CROSS =           cast(LPSTR)(32515);



/*
 * Color Types
 */

const CTLCOLOR_MSGBOX =         0;
const CTLCOLOR_EDIT =           1;
const CTLCOLOR_LISTBOX =        2;
const CTLCOLOR_BTN =            3;
const CTLCOLOR_DLG =            4;
const CTLCOLOR_SCROLLBAR =      5;
const CTLCOLOR_STATIC =         6;
const CTLCOLOR_MAX =            7;

const COLOR_SCROLLBAR =         0;
const COLOR_BACKGROUND =        1;
const COLOR_ACTIVECAPTION =     2;
const COLOR_INACTIVECAPTION =   3;
const COLOR_MENU =              4;
const COLOR_WINDOW =            5;
const COLOR_WINDOWFRAME =       6;
const COLOR_MENUTEXT =          7;
const COLOR_WINDOWTEXT =        8;
const COLOR_CAPTIONTEXT =       9;
const COLOR_ACTIVEBORDER =      10;
const COLOR_INACTIVEBORDER =    11;
const COLOR_APPWORKSPACE =      12;
const COLOR_HIGHLIGHT =         13;
const COLOR_HIGHLIGHTTEXT =     14;
const COLOR_BTNFACE =           15;
const COLOR_BTNSHADOW =         16;
const COLOR_GRAYTEXT =          17;
const COLOR_BTNTEXT =           18;
const COLOR_INACTIVECAPTIONTEXT = 19;
const COLOR_BTNHIGHLIGHT =      20;


const COLOR_3DDKSHADOW =        21;
const COLOR_3DLIGHT =           22;
const COLOR_INFOTEXT =          23;
const COLOR_INFOBK =            24;

const COLOR_DESKTOP =       COLOR_BACKGROUND;
const COLOR_3DFACE =            COLOR_BTNFACE;
const COLOR_3DSHADOW =          COLOR_BTNSHADOW;
const COLOR_3DHIGHLIGHT =       COLOR_BTNHIGHLIGHT;
const COLOR_3DHILIGHT =         COLOR_BTNHIGHLIGHT;
const COLOR_BTNHILIGHT =        COLOR_BTNHIGHLIGHT;


enum : int
{
    CW_USEDEFAULT = cast(int)0x80000000
}

/*
 * Special value for CreateWindow, et al.
 */
const HWND  HWND_DESKTOP = cast(HWND)0;

extern (Windows) ATOM RegisterClassA(WNDCLASSA *lpWndClass);

extern (Windows) HWND CreateWindowExA(
    DWORD dwExStyle,
    LPCSTR lpClassName,
    LPCSTR lpWindowName,
    DWORD dwStyle,
    int X,
    int Y,
    int nWidth,
    int nHeight,
    HWND hWndParent ,
    HMENU hMenu,
    HINSTANCE hInstance,
    LPVOID lpParam);


HWND CreateWindowA(
    LPCSTR lpClassName,
    LPCSTR lpWindowName,
    DWORD dwStyle,
    int X,
    int Y,
    int nWidth,
    int nHeight,
    HWND hWndParent ,
    HMENU hMenu,
    HINSTANCE hInstance,
    LPVOID lpParam)
{
    return CreateWindowExA(0, lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
}

/*
 * Message structure
 */
struct MSG {
    HWND        hwnd;
    UINT        message;
    WPARAM      wParam;
    LPARAM      lParam;
    DWORD       time;
    POINT       pt;
}
alias MSG* PMSG, NPMSG, LPMSG;

extern (Windows)
{
 BOOL GetMessageA(LPMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax);
 BOOL TranslateMessage(MSG *lpMsg);
 LONG DispatchMessageA(MSG *lpMsg);
 BOOL PeekMessageA(MSG *lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg);
 HWND GetFocus();
}

extern (Windows) DWORD ExpandEnvironmentStringsA(LPCSTR lpSrc, LPSTR lpDst, DWORD nSize);

extern (Windows)
{
 BOOL IsValidCodePage(UINT CodePage);
 UINT GetACP();
 UINT GetOEMCP();
 //BOOL GetCPInfo(UINT CodePage, LPCPINFO lpCPInfo);
 BOOL IsDBCSLeadByte(BYTE TestChar);
 BOOL IsDBCSLeadByteEx(UINT CodePage, BYTE TestChar);
 int MultiByteToWideChar(UINT CodePage, DWORD dwFlags, LPCSTR lpMultiByteStr, int cchMultiByte, LPWSTR lpWideCharStr, int cchWideChar);
 int WideCharToMultiByte(UINT CodePage, DWORD dwFlags, LPCWSTR lpWideCharStr, int cchWideChar, LPSTR lpMultiByteStr, int cchMultiByte, LPCSTR lpDefaultChar, LPBOOL lpUsedDefaultChar);
}

extern (Windows) HANDLE CreateFileMappingA(HANDLE hFile, LPSECURITY_ATTRIBUTES lpFileMappingAttributes, DWORD flProtect, DWORD dwMaximumSizeHigh, DWORD dwMaximumSizeLow, LPCSTR lpName);
extern (Windows) HANDLE CreateFileMappingW(HANDLE hFile, LPSECURITY_ATTRIBUTES lpFileMappingAttributes, DWORD flProtect, DWORD dwMaximumSizeHigh, DWORD dwMaximumSizeLow, LPCWSTR lpName);

extern (Windows) BOOL GetMailslotInfo(HANDLE hMailslot, LPDWORD lpMaxMessageSize, LPDWORD lpNextSize, LPDWORD lpMessageCount, LPDWORD lpReadTimeout);
extern (Windows) BOOL SetMailslotInfo(HANDLE hMailslot, DWORD lReadTimeout);
extern (Windows) LPVOID MapViewOfFile(HANDLE hFileMappingObject, DWORD dwDesiredAccess, DWORD dwFileOffsetHigh, DWORD dwFileOffsetLow, DWORD dwNumberOfBytesToMap);
extern (Windows) LPVOID MapViewOfFileEx(HANDLE hFileMappingObject, DWORD dwDesiredAccess, DWORD dwFileOffsetHigh, DWORD dwFileOffsetLow, DWORD dwNumberOfBytesToMap, LPVOID lpBaseAddress);
extern (Windows) BOOL FlushViewOfFile(LPCVOID lpBaseAddress, DWORD dwNumberOfBytesToFlush);
extern (Windows) BOOL UnmapViewOfFile(LPCVOID lpBaseAddress);

extern (Windows)  HGDIOBJ   GetStockObject(int);
extern (Windows) BOOL ShowWindow(HWND hWnd, int nCmdShow);

/* Stock Logical Objects */
enum
{   WHITE_BRUSH =         0,
    LTGRAY_BRUSH =        1,
    GRAY_BRUSH =          2,
    DKGRAY_BRUSH =        3,
    BLACK_BRUSH =         4,
    NULL_BRUSH =          5,
    HOLLOW_BRUSH =        NULL_BRUSH,
    WHITE_PEN =           6,
    BLACK_PEN =           7,
    NULL_PEN =            8,
    OEM_FIXED_FONT =      10,
    ANSI_FIXED_FONT =     11,
    ANSI_VAR_FONT =       12,
    SYSTEM_FONT =         13,
    DEVICE_DEFAULT_FONT = 14,
    DEFAULT_PALETTE =     15,
    SYSTEM_FIXED_FONT =   16,
    DEFAULT_GUI_FONT =    17,
    STOCK_LAST =          17,
}

/*
 * ShowWindow() Commands
 */
enum
{   SW_HIDE =             0,
    SW_SHOWNORMAL =       1,
    SW_NORMAL =           1,
    SW_SHOWMINIMIZED =    2,
    SW_SHOWMAXIMIZED =    3,
    SW_MAXIMIZE =         3,
    SW_SHOWNOACTIVATE =   4,
    SW_SHOW =             5,
    SW_MINIMIZE =         6,
    SW_SHOWMINNOACTIVE =  7,
    SW_SHOWNA =           8,
    SW_RESTORE =          9,
    SW_SHOWDEFAULT =      10,
    SW_MAX =              10,
}

struct TEXTMETRICA
{
    LONG        tmHeight;
    LONG        tmAscent;
    LONG        tmDescent;
    LONG        tmInternalLeading;
    LONG        tmExternalLeading;
    LONG        tmAveCharWidth;
    LONG        tmMaxCharWidth;
    LONG        tmWeight;
    LONG        tmOverhang;
    LONG        tmDigitizedAspectX;
    LONG        tmDigitizedAspectY;
    BYTE        tmFirstChar;
    BYTE        tmLastChar;
    BYTE        tmDefaultChar;
    BYTE        tmBreakChar;
    BYTE        tmItalic;
    BYTE        tmUnderlined;
    BYTE        tmStruckOut;
    BYTE        tmPitchAndFamily;
    BYTE        tmCharSet;
}

extern (Windows)  BOOL   GetTextMetricsA(HDC, TEXTMETRICA*);

/*
 * Scroll Bar Constants
 */
enum
{   SB_HORZ =             0,
    SB_VERT =             1,
    SB_CTL =              2,
    SB_BOTH =             3,
}

/*
 * Scroll Bar Commands
 */
enum
{   SB_LINEUP =           0,
    SB_LINELEFT =         0,
    SB_LINEDOWN =         1,
    SB_LINERIGHT =        1,
    SB_PAGEUP =           2,
    SB_PAGELEFT =         2,
    SB_PAGEDOWN =         3,
    SB_PAGERIGHT =        3,
    SB_THUMBPOSITION =    4,
    SB_THUMBTRACK =       5,
    SB_TOP =              6,
    SB_LEFT =             6,
    SB_BOTTOM =           7,
    SB_RIGHT =            7,
    SB_ENDSCROLL =        8,
}

extern (Windows) int SetScrollPos(HWND hWnd, int nBar, int nPos, BOOL bRedraw);
extern (Windows) int GetScrollPos(HWND hWnd, int nBar);
extern (Windows) BOOL SetScrollRange(HWND hWnd, int nBar, int nMinPos, int nMaxPos, BOOL bRedraw);
extern (Windows) BOOL GetScrollRange(HWND hWnd, int nBar, LPINT lpMinPos, LPINT lpMaxPos);
extern (Windows) BOOL ShowScrollBar(HWND hWnd, int wBar, BOOL bShow);
extern (Windows) BOOL EnableScrollBar(HWND hWnd, UINT wSBflags, UINT wArrows);

/*
 * LockWindowUpdate API
 */

extern (Windows) BOOL LockWindowUpdate(HWND hWndLock);
extern (Windows) BOOL ScrollWindow(HWND hWnd, int XAmount, int YAmount, RECT* lpRect, RECT* lpClipRect);
extern (Windows) BOOL ScrollDC(HDC hDC, int dx, int dy, RECT* lprcScroll, RECT* lprcClip, HRGN hrgnUpdate, LPRECT lprcUpdate);
extern (Windows) int ScrollWindowEx(HWND hWnd, int dx, int dy, RECT* prcScroll, RECT* prcClip, HRGN hrgnUpdate, LPRECT prcUpdate, UINT flags);

/*
 * Virtual Keys, Standard Set
 */
enum
{   VK_LBUTTON =        0x01,
    VK_RBUTTON =        0x02,
    VK_CANCEL =         0x03,
    VK_MBUTTON =        0x04, /* NOT contiguous with L & RBUTTON */

    VK_BACK =           0x08,
    VK_TAB =            0x09,

    VK_CLEAR =          0x0C,
    VK_RETURN =         0x0D,

    VK_SHIFT =          0x10,
    VK_CONTROL =        0x11,
    VK_MENU =           0x12,
    VK_PAUSE =          0x13,
    VK_CAPITAL =        0x14,


    VK_ESCAPE =         0x1B,

    VK_SPACE =          0x20,
    VK_PRIOR =          0x21,
    VK_NEXT =           0x22,
    VK_END =            0x23,
    VK_HOME =           0x24,
    VK_LEFT =           0x25,
    VK_UP =             0x26,
    VK_RIGHT =          0x27,
    VK_DOWN =           0x28,
    VK_SELECT =         0x29,
    VK_PRINT =          0x2A,
    VK_EXECUTE =        0x2B,
    VK_SNAPSHOT =       0x2C,
    VK_INSERT =         0x2D,
    VK_DELETE =         0x2E,
    VK_HELP =           0x2F,

/* VK_0 thru VK_9 are the same as ASCII '0' thru '9' (0x30 - 0x39) */
/* VK_A thru VK_Z are the same as ASCII 'A' thru 'Z' (0x41 - 0x5A) */

    VK_LWIN =           0x5B,
    VK_RWIN =           0x5C,
    VK_APPS =           0x5D,

    VK_NUMPAD0 =        0x60,
    VK_NUMPAD1 =        0x61,
    VK_NUMPAD2 =        0x62,
    VK_NUMPAD3 =        0x63,
    VK_NUMPAD4 =        0x64,
    VK_NUMPAD5 =        0x65,
    VK_NUMPAD6 =        0x66,
    VK_NUMPAD7 =        0x67,
    VK_NUMPAD8 =        0x68,
    VK_NUMPAD9 =        0x69,
    VK_MULTIPLY =       0x6A,
    VK_ADD =            0x6B,
    VK_SEPARATOR =      0x6C,
    VK_SUBTRACT =       0x6D,
    VK_DECIMAL =        0x6E,
    VK_DIVIDE =         0x6F,
    VK_F1 =             0x70,
    VK_F2 =             0x71,
    VK_F3 =             0x72,
    VK_F4 =             0x73,
    VK_F5 =             0x74,
    VK_F6 =             0x75,
    VK_F7 =             0x76,
    VK_F8 =             0x77,
    VK_F9 =             0x78,
    VK_F10 =            0x79,
    VK_F11 =            0x7A,
    VK_F12 =            0x7B,
    VK_F13 =            0x7C,
    VK_F14 =            0x7D,
    VK_F15 =            0x7E,
    VK_F16 =            0x7F,
    VK_F17 =            0x80,
    VK_F18 =            0x81,
    VK_F19 =            0x82,
    VK_F20 =            0x83,
    VK_F21 =            0x84,
    VK_F22 =            0x85,
    VK_F23 =            0x86,
    VK_F24 =            0x87,

    VK_NUMLOCK =        0x90,
    VK_SCROLL =         0x91,

/*
 * VK_L* & VK_R* - left and right Alt, Ctrl and Shift virtual keys.
 * Used only as parameters to GetAsyncKeyState() and GetKeyState().
 * No other API or message will distinguish left and right keys in this way.
 */
    VK_LSHIFT =         0xA0,
    VK_RSHIFT =         0xA1,
    VK_LCONTROL =       0xA2,
    VK_RCONTROL =       0xA3,
    VK_LMENU =          0xA4,
    VK_RMENU =          0xA5,


    VK_PROCESSKEY =     0xE5,


    VK_ATTN =           0xF6,
    VK_CRSEL =          0xF7,
    VK_EXSEL =          0xF8,
    VK_EREOF =          0xF9,
    VK_PLAY =           0xFA,
    VK_ZOOM =           0xFB,
    VK_NONAME =         0xFC,
    VK_PA1 =            0xFD,
    VK_OEM_CLEAR =      0xFE,
}

extern (Windows) LRESULT SendMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);

alias UINT function (HWND, UINT, WPARAM, LPARAM) LPOFNHOOKPROC;

struct OPENFILENAMEA {
   DWORD        lStructSize;
   HWND         hwndOwner;
   HINSTANCE    hInstance;
   LPCSTR       lpstrFilter;
   LPSTR        lpstrCustomFilter;
   DWORD        nMaxCustFilter;
   DWORD        nFilterIndex;
   LPSTR        lpstrFile;
   DWORD        nMaxFile;
   LPSTR        lpstrFileTitle;
   DWORD        nMaxFileTitle;
   LPCSTR       lpstrInitialDir;
   LPCSTR       lpstrTitle;
   DWORD        Flags;
   WORD         nFileOffset;
   WORD         nFileExtension;
   LPCSTR       lpstrDefExt;
   LPARAM       lCustData;
   LPOFNHOOKPROC lpfnHook;
   LPCSTR       lpTemplateName;
}
alias OPENFILENAMEA *LPOPENFILENAMEA;

struct OPENFILENAMEW {
   DWORD        lStructSize;
   HWND         hwndOwner;
   HINSTANCE    hInstance;
   LPCWSTR      lpstrFilter;
   LPWSTR       lpstrCustomFilter;
   DWORD        nMaxCustFilter;
   DWORD        nFilterIndex;
   LPWSTR       lpstrFile;
   DWORD        nMaxFile;
   LPWSTR       lpstrFileTitle;
   DWORD        nMaxFileTitle;
   LPCWSTR      lpstrInitialDir;
   LPCWSTR      lpstrTitle;
   DWORD        Flags;
   WORD         nFileOffset;
   WORD         nFileExtension;
   LPCWSTR      lpstrDefExt;
   LPARAM       lCustData;
   LPOFNHOOKPROC lpfnHook;
   LPCWSTR      lpTemplateName;
}
alias OPENFILENAMEW *LPOPENFILENAMEW;

BOOL          GetOpenFileNameA(LPOPENFILENAMEA);
BOOL          GetOpenFileNameW(LPOPENFILENAMEW);

BOOL          GetSaveFileNameA(LPOPENFILENAMEA);
BOOL          GetSaveFileNameW(LPOPENFILENAMEW);

short         GetFileTitleA(LPCSTR, LPSTR, WORD);
short         GetFileTitleW(LPCWSTR, LPWSTR, WORD);

enum
{
    PM_NOREMOVE =         0x0000,
    PM_REMOVE =           0x0001,
    PM_NOYIELD =          0x0002,
}

/* Bitmap Header Definition */
struct BITMAP
{
    LONG        bmType;
    LONG        bmWidth;
    LONG        bmHeight;
    LONG        bmWidthBytes;
    WORD        bmPlanes;
    WORD        bmBitsPixel;
    LPVOID      bmBits;
}
alias BITMAP* PBITMAP, NPBITMAP, LPBITMAP;


extern (Windows)  HDC       CreateCompatibleDC(HDC);

extern (Windows)  int     GetObjectA(HGDIOBJ, int, LPVOID);
extern (Windows)  int     GetObjectW(HGDIOBJ, int, LPVOID);
extern (Windows)  BOOL   DeleteDC(HDC);

struct LOGFONTA
{
    LONG      lfHeight;
    LONG      lfWidth;
    LONG      lfEscapement;
    LONG      lfOrientation;
    LONG      lfWeight;
    BYTE      lfItalic;
    BYTE      lfUnderline;
    BYTE      lfStrikeOut;
    BYTE      lfCharSet;
    BYTE      lfOutPrecision;
    BYTE      lfClipPrecision;
    BYTE      lfQuality;
    BYTE      lfPitchAndFamily;
    CHAR      lfFaceName[32 ];
}
alias LOGFONTA* PLOGFONTA, NPLOGFONTA, LPLOGFONTA;

extern (Windows) HMENU LoadMenuA(HINSTANCE hInstance, LPCSTR lpMenuName);
extern (Windows) HMENU LoadMenuW(HINSTANCE hInstance, LPCWSTR lpMenuName);

extern (Windows) HMENU GetSubMenu(HMENU hMenu, int nPos);

extern (Windows) HBITMAP LoadBitmapA(HINSTANCE hInstance, LPCSTR lpBitmapName);
extern (Windows) HBITMAP LoadBitmapW(HINSTANCE hInstance, LPCWSTR lpBitmapName);

LPSTR MAKEINTRESOURCEA(int i) { return cast(LPSTR)(cast(DWORD)(cast(WORD)(i))); }

extern (Windows)  HFONT     CreateFontIndirectA(LOGFONTA *);

extern (Windows) BOOL MessageBeep(UINT uType);
extern (Windows) int ShowCursor(BOOL bShow);
extern (Windows) BOOL SetCursorPos(int X, int Y);
extern (Windows) HCURSOR SetCursor(HCURSOR hCursor);
extern (Windows) BOOL GetCursorPos(LPPOINT lpPoint);
extern (Windows) BOOL ClipCursor( RECT *lpRect);
extern (Windows) BOOL GetClipCursor(LPRECT lpRect);
extern (Windows) HCURSOR GetCursor();
extern (Windows) BOOL CreateCaret(HWND hWnd, HBITMAP hBitmap , int nWidth, int nHeight);
extern (Windows) UINT GetCaretBlinkTime();
extern (Windows) BOOL SetCaretBlinkTime(UINT uMSeconds);
extern (Windows) BOOL DestroyCaret();
extern (Windows) BOOL HideCaret(HWND hWnd);
extern (Windows) BOOL ShowCaret(HWND hWnd);
extern (Windows) BOOL SetCaretPos(int X, int Y);
extern (Windows) BOOL GetCaretPos(LPPOINT lpPoint);
extern (Windows) BOOL ClientToScreen(HWND hWnd, LPPOINT lpPoint);
extern (Windows) BOOL ScreenToClient(HWND hWnd, LPPOINT lpPoint);
extern (Windows) int MapWindowPoints(HWND hWndFrom, HWND hWndTo, LPPOINT lpPoints, UINT cPoints);
extern (Windows) HWND WindowFromPoint(POINT Point);
extern (Windows) HWND ChildWindowFromPoint(HWND hWndParent, POINT Point);


extern (Windows) BOOL TrackPopupMenu(HMENU hMenu, UINT uFlags, int x, int y,
    int nReserved, HWND hWnd, RECT *prcRect);

align (2) struct DLGTEMPLATE {
    DWORD style;
    DWORD dwExtendedStyle;
    WORD cdit;
    short x;
    short y;
    short cx;
    short cy;
}
alias DLGTEMPLATE *LPDLGTEMPLATEA;
alias DLGTEMPLATE *LPDLGTEMPLATEW;


alias LPDLGTEMPLATEA LPDLGTEMPLATE;

alias  DLGTEMPLATE *LPCDLGTEMPLATEA;
alias  DLGTEMPLATE *LPCDLGTEMPLATEW;


alias LPCDLGTEMPLATEA LPCDLGTEMPLATE;


extern (Windows) int DialogBoxParamA(HINSTANCE hInstance, LPCSTR lpTemplateName,
    HWND hWndParent, DLGPROC lpDialogFunc, LPARAM dwInitParam);
extern (Windows) int DialogBoxIndirectParamA(HINSTANCE hInstance,
    LPCDLGTEMPLATEA hDialogTemplate, HWND hWndParent, DLGPROC lpDialogFunc,
    LPARAM dwInitParam);

enum : DWORD
{
    SRCCOPY =             cast(DWORD)0x00CC0020, /* dest = source                   */
    SRCPAINT =            cast(DWORD)0x00EE0086, /* dest = source OR dest           */
    SRCAND =              cast(DWORD)0x008800C6, /* dest = source AND dest          */
    SRCINVERT =           cast(DWORD)0x00660046, /* dest = source XOR dest          */
    SRCERASE =            cast(DWORD)0x00440328, /* dest = source AND (NOT dest)   */
    NOTSRCCOPY =          cast(DWORD)0x00330008, /* dest = (NOT source)             */
    NOTSRCERASE =         cast(DWORD)0x001100A6, /* dest = (NOT src) AND (NOT dest) */
    MERGECOPY =           cast(DWORD)0x00C000CA, /* dest = (source AND pattern)     */
    MERGEPAINT =          cast(DWORD)0x00BB0226, /* dest = (NOT source) OR dest     */
    PATCOPY =             cast(DWORD)0x00F00021, /* dest = pattern                  */
    PATPAINT =            cast(DWORD)0x00FB0A09, /* dest = DPSnoo                   */
    PATINVERT =           cast(DWORD)0x005A0049, /* dest = pattern XOR dest         */
    DSTINVERT =           cast(DWORD)0x00550009, /* dest = (NOT dest)               */
    BLACKNESS =           cast(DWORD)0x00000042, /* dest = BLACK                    */
    WHITENESS =           cast(DWORD)0x00FF0062, /* dest = WHITE                    */
}

enum
{
    SND_SYNC =            0x0000, /* play synchronously (default) */
    SND_ASYNC =           0x0001, /* play asynchronously */
    SND_NODEFAULT =       0x0002, /* silence (!default) if sound not found */
    SND_MEMORY =          0x0004, /* pszSound points to a memory file */
    SND_LOOP =            0x0008, /* loop the sound until next sndPlaySound */
    SND_NOSTOP =          0x0010, /* don't stop any currently playing sound */

    SND_NOWAIT =    0x00002000, /* don't wait if the driver is busy */
    SND_ALIAS =       0x00010000, /* name is a registry alias */
    SND_ALIAS_ID =  0x00110000, /* alias is a predefined ID */
    SND_FILENAME =    0x00020000, /* name is file name */
    SND_RESOURCE =    0x00040004, /* name is resource name or atom */

    SND_PURGE =           0x0040, /* purge non-static events for task */
    SND_APPLICATION =     0x0080, /* look for application specific association */


    SND_ALIAS_START =   0,     /* alias base */
}

extern (Windows)  BOOL   PlaySoundA(LPCSTR pszSound, HMODULE hmod, DWORD fdwSound);
extern (Windows)  BOOL   PlaySoundW(LPCWSTR pszSound, HMODULE hmod, DWORD fdwSound);

extern (Windows)  int     GetClipBox(HDC, LPRECT);
extern (Windows)  int     GetClipRgn(HDC, HRGN);
extern (Windows)  int     GetMetaRgn(HDC, HRGN);
extern (Windows)  HGDIOBJ   GetCurrentObject(HDC, UINT);
extern (Windows)  BOOL    GetCurrentPositionEx(HDC, LPPOINT);
extern (Windows)  int     GetDeviceCaps(HDC, int);

struct LOGPEN
  {
    UINT        lopnStyle;
    POINT       lopnWidth;
    COLORREF    lopnColor;
}
alias LOGPEN* PLOGPEN, NPLOGPEN, LPLOGPEN;

enum
{
    PS_SOLID =            0,
    PS_DASH =             1, /* -------  */
    PS_DOT =              2, /* .......  */
    PS_DASHDOT =          3, /* _._._._  */
    PS_DASHDOTDOT =       4, /* _.._.._  */
    PS_NULL =             5,
    PS_INSIDEFRAME =      6,
    PS_USERSTYLE =        7,
    PS_ALTERNATE =        8,
    PS_STYLE_MASK =       0x0000000F,

    PS_ENDCAP_ROUND =     0x00000000,
    PS_ENDCAP_SQUARE =    0x00000100,
    PS_ENDCAP_FLAT =      0x00000200,
    PS_ENDCAP_MASK =      0x00000F00,

    PS_JOIN_ROUND =       0x00000000,
    PS_JOIN_BEVEL =       0x00001000,
    PS_JOIN_MITER =       0x00002000,
    PS_JOIN_MASK =        0x0000F000,

    PS_COSMETIC =         0x00000000,
    PS_GEOMETRIC =        0x00010000,
    PS_TYPE_MASK =        0x000F0000,
}

extern (Windows)  HPALETTE   CreatePalette(LOGPALETTE *);
extern (Windows)  HPEN      CreatePen(int, int, COLORREF);
extern (Windows)  HPEN      CreatePenIndirect(LOGPEN *);
extern (Windows)  HRGN      CreatePolyPolygonRgn(POINT *, INT *, int, int);
extern (Windows)  HBRUSH    CreatePatternBrush(HBITMAP);
extern (Windows)  HRGN      CreateRectRgn(int, int, int, int);
extern (Windows)  HRGN      CreateRectRgnIndirect(RECT *);
extern (Windows)  HRGN      CreateRoundRectRgn(int, int, int, int, int, int);
extern (Windows)  BOOL      CreateScalableFontResourceA(DWORD, LPCSTR, LPCSTR, LPCSTR);
extern (Windows)  BOOL      CreateScalableFontResourceW(DWORD, LPCWSTR, LPCWSTR, LPCWSTR);

COLORREF RGB(int r, int g, int b)
{
    return cast(COLORREF)
    ((cast(BYTE)r|(cast(WORD)(cast(BYTE)g)<<8))|((cast(DWORD)cast(BYTE)b)<<16));
}

extern (Windows)  BOOL   LineTo(HDC, int, int);
extern (Windows)  BOOL   DeleteObject(HGDIOBJ);
extern (Windows) int FillRect(HDC hDC,  RECT *lprc, HBRUSH hbr);


extern (Windows) BOOL EndDialog(HWND hDlg, int nResult);
extern (Windows) HWND GetDlgItem(HWND hDlg, int nIDDlgItem);

extern (Windows) BOOL SetDlgItemInt(HWND hDlg, int nIDDlgItem, UINT uValue, BOOL bSigned);
extern (Windows) UINT GetDlgItemInt(HWND hDlg, int nIDDlgItem, BOOL *lpTranslated,
    BOOL bSigned);

extern (Windows) BOOL SetDlgItemTextA(HWND hDlg, int nIDDlgItem, LPCSTR lpString);
extern (Windows) BOOL SetDlgItemTextW(HWND hDlg, int nIDDlgItem, LPCWSTR lpString);

extern (Windows) UINT GetDlgItemTextA(HWND hDlg, int nIDDlgItem, LPSTR lpString, int nMaxCount);
extern (Windows) UINT GetDlgItemTextW(HWND hDlg, int nIDDlgItem, LPWSTR lpString, int nMaxCount);

extern (Windows) BOOL CheckDlgButton(HWND hDlg, int nIDButton, UINT uCheck);
extern (Windows) BOOL CheckRadioButton(HWND hDlg, int nIDFirstButton, int nIDLastButton,
    int nIDCheckButton);

extern (Windows) UINT IsDlgButtonChecked(HWND hDlg, int nIDButton);

extern (Windows) HWND SetFocus(HWND hWnd);

extern (Windows) int wsprintfA(LPSTR, LPCSTR, ...);
extern (Windows) int wsprintfW(LPWSTR, LPCWSTR, ...);

enum : uint
{
    INFINITE =              uint.max,
    WAIT_OBJECT_0 =         0,
    WAIT_ABANDONED_0 =      0x80,
    WAIT_TIMEOUT =          0x102,
    WAIT_IO_COMPLETION =    0xc0,
    WAIT_ABANDONED =        0x80,
    WAIT_FAILED =           uint.max,
}

extern (Windows) HANDLE CreateSemaphoreA(LPSECURITY_ATTRIBUTES lpSemaphoreAttributes, LONG lInitialCount, LONG lMaximumCount, LPCTSTR lpName);
extern (Windows) HANDLE OpenSemaphoreA(DWORD dwDesiredAccess, BOOL bInheritHandle, LPCTSTR lpName);
extern (Windows) BOOL ReleaseSemaphore(HANDLE hSemaphore, LONG lReleaseCount, LPLONG lpPreviousCount);

struct COORD {
    SHORT X;
    SHORT Y;
}
alias COORD *PCOORD;

struct SMALL_RECT {
    SHORT Left;
    SHORT Top;
    SHORT Right;
    SHORT Bottom;
}
alias SMALL_RECT *PSMALL_RECT;

struct KEY_EVENT_RECORD {
    BOOL bKeyDown;
    WORD wRepeatCount;
    WORD wVirtualKeyCode;
    WORD wVirtualScanCode;
    union {
        WCHAR UnicodeChar;
        CHAR   AsciiChar;
    }
    DWORD dwControlKeyState;
}
alias KEY_EVENT_RECORD *PKEY_EVENT_RECORD;

//
// ControlKeyState flags
//

enum
{
    RIGHT_ALT_PRESSED =     0x0001, // the right alt key is pressed.
    LEFT_ALT_PRESSED =      0x0002, // the left alt key is pressed.
    RIGHT_CTRL_PRESSED =    0x0004, // the right ctrl key is pressed.
    LEFT_CTRL_PRESSED =     0x0008, // the left ctrl key is pressed.
    SHIFT_PRESSED =         0x0010, // the shift key is pressed.
    NUMLOCK_ON =            0x0020, // the numlock light is on.
    SCROLLLOCK_ON =         0x0040, // the scrolllock light is on.
    CAPSLOCK_ON =           0x0080, // the capslock light is on.
    ENHANCED_KEY =          0x0100, // the key is enhanced.
}

struct MOUSE_EVENT_RECORD {
    COORD dwMousePosition;
    DWORD dwButtonState;
    DWORD dwControlKeyState;
    DWORD dwEventFlags;
}
alias MOUSE_EVENT_RECORD *PMOUSE_EVENT_RECORD;

//
// ButtonState flags
//
enum
{
    FROM_LEFT_1ST_BUTTON_PRESSED =    0x0001,
    RIGHTMOST_BUTTON_PRESSED =        0x0002,
    FROM_LEFT_2ND_BUTTON_PRESSED =    0x0004,
    FROM_LEFT_3RD_BUTTON_PRESSED =    0x0008,
    FROM_LEFT_4TH_BUTTON_PRESSED =    0x0010,
}

//
// EventFlags
//

enum
{
    MOUSE_MOVED =   0x0001,
    DOUBLE_CLICK =  0x0002,
}

struct WINDOW_BUFFER_SIZE_RECORD {
    COORD dwSize;
}
alias WINDOW_BUFFER_SIZE_RECORD *PWINDOW_BUFFER_SIZE_RECORD;

struct MENU_EVENT_RECORD {
    UINT dwCommandId;
}
alias MENU_EVENT_RECORD *PMENU_EVENT_RECORD;

struct FOCUS_EVENT_RECORD {
    BOOL bSetFocus;
}
alias FOCUS_EVENT_RECORD *PFOCUS_EVENT_RECORD;

struct INPUT_RECORD {
    WORD EventType;
    union {
        KEY_EVENT_RECORD KeyEvent;
        MOUSE_EVENT_RECORD MouseEvent;
        WINDOW_BUFFER_SIZE_RECORD WindowBufferSizeEvent;
        MENU_EVENT_RECORD MenuEvent;
        FOCUS_EVENT_RECORD FocusEvent;
    }
}
alias INPUT_RECORD *PINPUT_RECORD;

//
//  EventType flags:
//

enum
{
    KEY_EVENT =         0x0001, // Event contains key event record
    MOUSE_EVENT =       0x0002, // Event contains mouse event record
    WINDOW_BUFFER_SIZE_EVENT = 0x0004, // Event contains window change event record
    MENU_EVENT = 0x0008, // Event contains menu event record
    FOCUS_EVENT = 0x0010, // event contains focus change
}

struct CHAR_INFO {
    union {
        WCHAR UnicodeChar;
        CHAR   AsciiChar;
    }
    WORD Attributes;
}
alias CHAR_INFO *PCHAR_INFO;

//
// Attributes flags:
//

enum
{
    FOREGROUND_BLUE =      0x0001, // text color contains blue.
    FOREGROUND_GREEN =     0x0002, // text color contains green.
    FOREGROUND_RED =       0x0004, // text color contains red.
    FOREGROUND_INTENSITY = 0x0008, // text color is intensified.
    BACKGROUND_BLUE =      0x0010, // background color contains blue.
    BACKGROUND_GREEN =     0x0020, // background color contains green.
    BACKGROUND_RED =       0x0040, // background color contains red.
    BACKGROUND_INTENSITY = 0x0080, // background color is intensified.
}

struct CONSOLE_SCREEN_BUFFER_INFO {
    COORD dwSize;
    COORD dwCursorPosition;
    WORD  wAttributes;
    SMALL_RECT srWindow;
    COORD dwMaximumWindowSize;
}
alias CONSOLE_SCREEN_BUFFER_INFO *PCONSOLE_SCREEN_BUFFER_INFO;

struct CONSOLE_CURSOR_INFO {
    DWORD  dwSize;
    BOOL   bVisible;
}
alias CONSOLE_CURSOR_INFO *PCONSOLE_CURSOR_INFO;

enum
{
    ENABLE_PROCESSED_INPUT = 0x0001,
    ENABLE_LINE_INPUT =      0x0002,
    ENABLE_ECHO_INPUT =      0x0004,
    ENABLE_WINDOW_INPUT =    0x0008,
    ENABLE_MOUSE_INPUT =     0x0010,
}

enum
{
    ENABLE_PROCESSED_OUTPUT =    0x0001,
    ENABLE_WRAP_AT_EOL_OUTPUT =  0x0002,
}

BOOL PeekConsoleInputA(HANDLE hConsoleInput, PINPUT_RECORD lpBuffer, DWORD nLength, LPDWORD lpNumberOfEventsRead);
BOOL PeekConsoleInputW(HANDLE hConsoleInput, PINPUT_RECORD lpBuffer, DWORD nLength, LPDWORD lpNumberOfEventsRead);
BOOL ReadConsoleInputA(HANDLE hConsoleInput, PINPUT_RECORD lpBuffer, DWORD nLength, LPDWORD lpNumberOfEventsRead);
BOOL ReadConsoleInputW(HANDLE hConsoleInput, PINPUT_RECORD lpBuffer, DWORD nLength, LPDWORD lpNumberOfEventsRead);
BOOL WriteConsoleInputA(HANDLE hConsoleInput, in INPUT_RECORD *lpBuffer, DWORD nLength, LPDWORD lpNumberOfEventsWritten);
BOOL WriteConsoleInputW(HANDLE hConsoleInput, in INPUT_RECORD *lpBuffer, DWORD nLength, LPDWORD lpNumberOfEventsWritten);
BOOL ReadConsoleOutputA(HANDLE hConsoleOutput, PCHAR_INFO lpBuffer, COORD dwBufferSize, COORD dwBufferCoord, PSMALL_RECT lpReadRegion);
BOOL ReadConsoleOutputW(HANDLE hConsoleOutput, PCHAR_INFO lpBuffer, COORD dwBufferSize, COORD dwBufferCoord, PSMALL_RECT lpReadRegion);
BOOL WriteConsoleOutputA(HANDLE hConsoleOutput, in CHAR_INFO *lpBuffer, COORD dwBufferSize, COORD dwBufferCoord, PSMALL_RECT lpWriteRegion);
BOOL WriteConsoleOutputW(HANDLE hConsoleOutput, in CHAR_INFO *lpBuffer, COORD dwBufferSize, COORD dwBufferCoord, PSMALL_RECT lpWriteRegion);
BOOL ReadConsoleOutputCharacterA(HANDLE hConsoleOutput, LPSTR lpCharacter, DWORD nLength, COORD dwReadCoord, LPDWORD lpNumberOfCharsRead);
BOOL ReadConsoleOutputCharacterW(HANDLE hConsoleOutput, LPWSTR lpCharacter, DWORD nLength, COORD dwReadCoord, LPDWORD lpNumberOfCharsRead);
BOOL ReadConsoleOutputAttribute(HANDLE hConsoleOutput, LPWORD lpAttribute, DWORD nLength, COORD dwReadCoord, LPDWORD lpNumberOfAttrsRead);
BOOL WriteConsoleOutputCharacterA(HANDLE hConsoleOutput, LPCSTR lpCharacter, DWORD nLength, COORD dwWriteCoord, LPDWORD lpNumberOfCharsWritten);
BOOL WriteConsoleOutputCharacterW(HANDLE hConsoleOutput, LPCWSTR lpCharacter, DWORD nLength, COORD dwWriteCoord, LPDWORD lpNumberOfCharsWritten);
BOOL WriteConsoleOutputAttribute(HANDLE hConsoleOutput, in WORD *lpAttribute, DWORD nLength, COORD dwWriteCoord, LPDWORD lpNumberOfAttrsWritten);
BOOL FillConsoleOutputCharacterA(HANDLE hConsoleOutput, CHAR cCharacter, DWORD  nLength, COORD  dwWriteCoord, LPDWORD lpNumberOfCharsWritten);
BOOL FillConsoleOutputCharacterW(HANDLE hConsoleOutput, WCHAR cCharacter, DWORD  nLength, COORD  dwWriteCoord, LPDWORD lpNumberOfCharsWritten);
BOOL FillConsoleOutputAttribute(HANDLE hConsoleOutput, WORD   wAttribute, DWORD  nLength, COORD  dwWriteCoord, LPDWORD lpNumberOfAttrsWritten);
BOOL GetConsoleMode(HANDLE hConsoleHandle, LPDWORD lpMode);
BOOL GetNumberOfConsoleInputEvents(HANDLE hConsoleInput, LPDWORD lpNumberOfEvents);
BOOL GetConsoleScreenBufferInfo(HANDLE hConsoleOutput, PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo);
COORD GetLargestConsoleWindowSize( HANDLE hConsoleOutput);
BOOL GetConsoleCursorInfo(HANDLE hConsoleOutput, PCONSOLE_CURSOR_INFO lpConsoleCursorInfo);
BOOL GetNumberOfConsoleMouseButtons( LPDWORD lpNumberOfMouseButtons);
BOOL SetConsoleMode(HANDLE hConsoleHandle, DWORD dwMode);
BOOL SetConsoleActiveScreenBuffer(HANDLE hConsoleOutput);
BOOL FlushConsoleInputBuffer(HANDLE hConsoleInput);
BOOL SetConsoleScreenBufferSize(HANDLE hConsoleOutput, COORD dwSize);
BOOL SetConsoleCursorPosition(HANDLE hConsoleOutput, COORD dwCursorPosition);
BOOL SetConsoleCursorInfo(HANDLE hConsoleOutput, in CONSOLE_CURSOR_INFO *lpConsoleCursorInfo);
BOOL ScrollConsoleScreenBufferA(HANDLE hConsoleOutput, in SMALL_RECT *lpScrollRectangle, in SMALL_RECT *lpClipRectangle, COORD dwDestinationOrigin, in CHAR_INFO *lpFill);
BOOL ScrollConsoleScreenBufferW(HANDLE hConsoleOutput, in SMALL_RECT *lpScrollRectangle, in SMALL_RECT *lpClipRectangle, COORD dwDestinationOrigin, in CHAR_INFO *lpFill);
BOOL SetConsoleWindowInfo(HANDLE hConsoleOutput, BOOL bAbsolute, in SMALL_RECT *lpConsoleWindow);
BOOL SetConsoleTextAttribute(HANDLE hConsoleOutput, WORD wAttributes);
alias BOOL function(DWORD CtrlType) PHANDLER_ROUTINE;
BOOL SetConsoleCtrlHandler(PHANDLER_ROUTINE HandlerRoutine, BOOL Add);
BOOL GenerateConsoleCtrlEvent( DWORD dwCtrlEvent, DWORD dwProcessGroupId);
BOOL AllocConsole();
BOOL FreeConsole();
DWORD GetConsoleTitleA(LPSTR lpConsoleTitle, DWORD nSize);
DWORD GetConsoleTitleW(LPWSTR lpConsoleTitle, DWORD nSize);
BOOL SetConsoleTitleA(LPCSTR lpConsoleTitle);
BOOL SetConsoleTitleW(LPCWSTR lpConsoleTitle);
BOOL ReadConsoleA(HANDLE hConsoleInput, LPVOID lpBuffer, DWORD nNumberOfCharsToRead, LPDWORD lpNumberOfCharsRead, LPVOID lpReserved);
BOOL ReadConsoleW(HANDLE hConsoleInput, LPVOID lpBuffer, DWORD nNumberOfCharsToRead, LPDWORD lpNumberOfCharsRead, LPVOID lpReserved);
BOOL WriteConsoleA(HANDLE hConsoleOutput, in  void *lpBuffer, DWORD nNumberOfCharsToWrite, LPDWORD lpNumberOfCharsWritten, LPVOID lpReserved);
BOOL WriteConsoleW(HANDLE hConsoleOutput, in  void *lpBuffer, DWORD nNumberOfCharsToWrite, LPDWORD lpNumberOfCharsWritten, LPVOID lpReserved);
HANDLE CreateConsoleScreenBuffer(DWORD dwDesiredAccess, DWORD dwShareMode, in SECURITY_ATTRIBUTES *lpSecurityAttributes, DWORD dwFlags, LPVOID lpScreenBufferData);
UINT GetConsoleCP();
BOOL SetConsoleCP( UINT wCodePageID);
UINT GetConsoleOutputCP();
BOOL SetConsoleOutputCP(UINT wCodePageID);

enum
{
    CONSOLE_TEXTMODE_BUFFER = 1,
}

enum
{
    SM_CXSCREEN =             0,
    SM_CYSCREEN =             1,
    SM_CXVSCROLL =            2,
    SM_CYHSCROLL =            3,
    SM_CYCAPTION =            4,
    SM_CXBORDER =             5,
    SM_CYBORDER =             6,
    SM_CXDLGFRAME =           7,
    SM_CYDLGFRAME =           8,
    SM_CYVTHUMB =             9,
    SM_CXHTHUMB =             10,
    SM_CXICON =               11,
    SM_CYICON =               12,
    SM_CXCURSOR =             13,
    SM_CYCURSOR =             14,
    SM_CYMENU =               15,
    SM_CXFULLSCREEN =         16,
    SM_CYFULLSCREEN =         17,
    SM_CYKANJIWINDOW =        18,
    SM_MOUSEPRESENT =         19,
    SM_CYVSCROLL =            20,
    SM_CXHSCROLL =            21,
    SM_DEBUG =                22,
    SM_SWAPBUTTON =           23,
    SM_RESERVED1 =            24,
    SM_RESERVED2 =            25,
    SM_RESERVED3 =            26,
    SM_RESERVED4 =            27,
    SM_CXMIN =                28,
    SM_CYMIN =                29,
    SM_CXSIZE =               30,
    SM_CYSIZE =               31,
    SM_CXFRAME =              32,
    SM_CYFRAME =              33,
    SM_CXMINTRACK =           34,
    SM_CYMINTRACK =           35,
    SM_CXDOUBLECLK =          36,
    SM_CYDOUBLECLK =          37,
    SM_CXICONSPACING =        38,
    SM_CYICONSPACING =        39,
    SM_MENUDROPALIGNMENT =    40,
    SM_PENWINDOWS =           41,
    SM_DBCSENABLED =          42,
    SM_CMOUSEBUTTONS =        43,


    SM_CXFIXEDFRAME =         SM_CXDLGFRAME,
    SM_CYFIXEDFRAME =         SM_CYDLGFRAME,
    SM_CXSIZEFRAME =          SM_CXFRAME,
    SM_CYSIZEFRAME =          SM_CYFRAME,

    SM_SECURE =               44,
    SM_CXEDGE =               45,
    SM_CYEDGE =               46,
    SM_CXMINSPACING =         47,
    SM_CYMINSPACING =         48,
    SM_CXSMICON =             49,
    SM_CYSMICON =             50,
    SM_CYSMCAPTION =          51,
    SM_CXSMSIZE =             52,
    SM_CYSMSIZE =             53,
    SM_CXMENUSIZE =           54,
    SM_CYMENUSIZE =           55,
    SM_ARRANGE =              56,
    SM_CXMINIMIZED =          57,
    SM_CYMINIMIZED =          58,
    SM_CXMAXTRACK =           59,
    SM_CYMAXTRACK =           60,
    SM_CXMAXIMIZED =          61,
    SM_CYMAXIMIZED =          62,
    SM_NETWORK =              63,
    SM_CLEANBOOT =            67,
    SM_CXDRAG =               68,
    SM_CYDRAG =               69,
    SM_SHOWSOUNDS =           70,
    SM_CXMENUCHECK =          71,
    SM_CYMENUCHECK =          72,
    SM_SLOWMACHINE =          73,
    SM_MIDEASTENABLED =       74,
    SM_CMETRICS =             75,
}

int GetSystemMetrics(int nIndex);

enum : DWORD
{
    STILL_ACTIVE = (0x103),
}

DWORD TlsAlloc();
LPVOID TlsGetValue(DWORD);
BOOL TlsSetValue(DWORD, LPVOID);
BOOL TlsFree(DWORD);
UINT SetTimer(HWND hWnd, UINT nIDEvent, UINT uElapse, TIMERPROC lpТаймерFunc);
BOOL KillTimer(HWND hWnd, UINT uIDEvent);




alias UINT SOCKET;
alias int socklen_t;

const SOCKET INVALID_SOCKET = cast(SOCKET)~0;
const int SOCKET_ERROR = -1;

const int WSADESCRIPTION_LEN = 256;
const int WSASYS_STATUS_LEN = 128;

struct WSADATA
{
	WORD wVersion;
	WORD wHighVersion;
	char szDescription[WSADESCRIPTION_LEN + 1];
	char szSystemStatus[WSASYS_STATUS_LEN + 1];
	USHORT iMaxSockets;
	USHORT iMaxUdpDg;
	char* lpVendorInfo;
}
alias WSADATA* LPWSADATA;


const int IOCPARM_MASK =  0x7F;
const int IOC_IN =        cast(int)0x80000000;
const int FIONBIO =       cast(int)(IOC_IN | ((UINT.sizeof & IOCPARM_MASK) << 16) | (102 << 8) | 126);


	int WSAStartup(WORD wVersionRequested, LPWSADATA lpWSAData);
	int WSACleanup();
	SOCKET socket(int af, int type, int protocol);
	int ioctlsocket(SOCKET s, int cmd, uint* argp);
	int bind(SOCKET s, sockaddr* name, int namelen);
	int connect(SOCKET s, sockaddr* name, int namelen);
	int listen(SOCKET s, int backlog);
	SOCKET accept(SOCKET s, sockaddr* addr, int* addrlen);
	int closesocket(SOCKET s);
	int shutdown(SOCKET s, int how);
	int getpeername(SOCKET s, sockaddr* name, int* namelen);
	int getsockname(SOCKET s, sockaddr* name, int* namelen);
	int send(SOCKET s, void* buf, int len, int flags);
	int sendto(SOCKET s, void* buf, int len, int flags, sockaddr* to, int tolen);
	int recv(SOCKET s, void* buf, int len, int flags);
	int recvfrom(SOCKET s, void* buf, int len, int flags, sockaddr* from, int* fromlen);
	int getsockopt(SOCKET s, int level, int optname, void* optval, int* optlen);
	int setsockopt(SOCKET s, int level, int optname, void* optval, int optlen);
	uint inet_addr(char* cp);
	int select(int nfds, fd_set* readfds, fd_set* writefds, fd_set* errorfds, timeval* timeout);
	char* inet_ntoa(in_addr ina);
	hostent* gethostbyname(char* name);
	hostent* gethostbyaddr(void* addr, int len, int type);
	protoent* getprotobyname(char* name);
	protoent* getprotobynumber(int number);
	servent* getservbyname(char* name, char* proto);
	servent* getservbyport(int port, char* proto);
	int gethostname(char* name, int namelen);
	int getaddrinfo(char* nodename, char* servname, addrinfo* hints, addrinfo** res);
	void freeaddrinfo(addrinfo* ai);
	int getnameinfo(sockaddr* sa, socklen_t salen, char* host, DWORD hostlen, char* serv, DWORD servlen, int flags);

enum: int
{
	WSAEWOULDBLOCK =     10035,
	WSAEINTR =           10004,
	WSAHOST_NOT_FOUND =  11001,
}

int WSAGetLastError();


enum: int
{
	AF_UNSPEC =     0,
	
	AF_UNIX =       1,
	AF_INET =       2,
	AF_IMPLINK =    3,
	AF_PUP =        4,
	AF_CHAOS =      5,
	AF_NS =         6,
	AF_IPX =        AF_NS,
	AF_ISO =        7,
	AF_OSI =        AF_ISO,
	AF_ECMA =       8,
	AF_DATAKIT =    9,
	AF_CCITT =      10,
	AF_SNA =        11,
	AF_DECnet =     12,
	AF_DLI =        13,
	AF_LAT =        14,
	AF_HYLINK =     15,
	AF_APPLETALK =  16,
	AF_NETBIOS =    17,
	AF_VOICEVIEW =  18,
	AF_FIREFOX =    19,
	AF_UNKNOWN1 =   20,
	AF_BAN =        21,
	AF_ATM =        22,
	AF_INET6 =      23,
	AF_CLUSTER =    24,
	AF_12844 =      25,
	AF_IRDA =       26,
	AF_NETDES =     28,
	
	AF_MAX =        29,
	
	
	PF_UNSPEC     = AF_UNSPEC,
	
	PF_UNIX =       AF_UNIX,
	PF_INET =       AF_INET,
	PF_IMPLINK =    AF_IMPLINK,
	PF_PUP =        AF_PUP,
	PF_CHAOS =      AF_CHAOS,
	PF_NS =         AF_NS,
	PF_IPX =        AF_IPX,
	PF_ISO =        AF_ISO,
	PF_OSI =        AF_OSI,
	PF_ECMA =       AF_ECMA,
	PF_DATAKIT =    AF_DATAKIT,
	PF_CCITT =      AF_CCITT,
	PF_SNA =        AF_SNA,
	PF_DECnet =     AF_DECnet,
	PF_DLI =        AF_DLI,
	PF_LAT =        AF_LAT,
	PF_HYLINK =     AF_HYLINK,
	PF_APPLETALK =  AF_APPLETALK,
	PF_VOICEVIEW =  AF_VOICEVIEW,
	PF_FIREFOX =    AF_FIREFOX,
	PF_UNKNOWN1 =   AF_UNKNOWN1,
	PF_BAN =        AF_BAN,
	PF_INET6 =      AF_INET6,
	
	PF_MAX        = AF_MAX,
}


enum: int
{
	SOL_SOCKET = 0xFFFF,
}


enum: int
{
	SO_DEBUG =        0x0001,
	SO_ACCEPTCONN =   0x0002,
	SO_REUSEADDR =    0x0004,
	SO_KEEPALIVE =    0x0008,
	SO_DONTROUTE =    0x0010,
	SO_BROADCAST =    0x0020,
	SO_USELOOPBACK =  0x0040,
	SO_LINGER =       0x0080,
	SO_DONTLINGER =   ~SO_LINGER,
	SO_OOBINLINE =    0x0100,
	SO_SNDBUF =       0x1001,
	SO_RCVBUF =       0x1002,
	SO_SNDLOWAT =     0x1003,
	SO_RCVLOWAT =     0x1004,
	SO_SNDTIMEO =     0x1005,
	SO_RCVTIMEO =     0x1006,
	SO_ERROR =        0x1007,
	SO_TYPE =         0x1008,
	SO_EXCLUSIVEADDRUSE = ~SO_REUSEADDR,
	
	TCP_NODELAY =    1,
	
	IP_MULTICAST_LOOP =  0x4,
	IP_ADD_MEMBERSHIP =  0x5,
	IP_DROP_MEMBERSHIP = 0x6,
	
	IPV6_UNICAST_HOPS =    4,
	IPV6_MULTICAST_IF =    9,
	IPV6_MULTICAST_HOPS =  10,
	IPV6_MULTICAST_LOOP =  11,
	IPV6_ADD_MEMBERSHIP =  12,
	IPV6_DROP_MEMBERSHIP = 13,
	IPV6_JOIN_GROUP =      IPV6_ADD_MEMBERSHIP,
	IPV6_LEAVE_GROUP =     IPV6_DROP_MEMBERSHIP,
}


const uint FD_SETSIZE = 64;


struct fd_set
{
	UINT fd_count;
	SOCKET[FD_SETSIZE] fd_array;
}


// Removes.
void FD_CLR(SOCKET fd, fd_set* set)
{
	uint c = set.fd_count;
	SOCKET* start = set.fd_array.ptr;
	SOCKET* stop = start + c;
	
	for(; start != stop; start++)
	{
		if(*start == fd)
			goto found;
	}
	return; //not found
	
	found:
	for(++start; start != stop; start++)
	{
		*(start - 1) = *start;
	}
	
	set.fd_count = c - 1;
}


// Tests.
int FD_ISSET(SOCKET fd, fd_set* set)
{
	SOCKET* start = set.fd_array.ptr;
	SOCKET* stop = start + set.fd_count;
	
	for(; start != stop; start++)
	{
		if(*start == fd)
			return true;
	}
	return false;
}


// Adds.
void FD_SET(SOCKET fd, fd_set* set)
{
	uint c = set.fd_count;
	set.fd_array.ptr[c] = fd;
	set.fd_count = c + 1;
}


// Resets to zero.
void FD_ZERO(fd_set* set)
{
	set.fd_count = 0;
}


struct linger
{
	USHORT l_onoff;
	USHORT l_linger;
}


struct protoent
{
	char* p_name;
	char** p_aliases;
	SHORT p_proto;
}


struct servent
{
	char* s_name;
	char** s_aliases;
	SHORT s_port;
	char* s_proto;
}


/+
union in6_addr
{
	private union _u_t
	{
		BYTE[16] Byte;
		WORD[8] Word;
	}
	_u_t u;
}


struct in_addr6
{
	BYTE[16] s6_addr;
}
+/


version(BigEndian)
{
	uint16_t htons(uint16_t x)
	{
		return x;
	}
	
	
	uint32_t htonl(uint32_t x)
	{
		return x;
	}
}
else version(LittleEndian)
{
	private import stdrus: развербит;
	
	
	uint16_t htons(uint16_t x)
	{
		return cast(uint16_t)((x >> 8) | (x << 8));
	}


	uint32_t htonl(uint32_t x)
	{
		return развербит(x);
	}
}
else
{
	static assert(0);
}


uint16_t ntohs(uint16_t x)
{
	return htons(x);
}


uint32_t ntohl(uint32_t x)
{
	return htonl(x);
}


enum: int
{
	SOCK_STREAM =     1,
	SOCK_DGRAM =      2,
	SOCK_RAW =        3,
	SOCK_RDM =        4,
	SOCK_SEQPACKET =  5,
}


enum: int
{
	IPPROTO_IP =    0,
	IPPROTO_ICMP =  1,
	IPPROTO_IGMP =  2,
	IPPROTO_GGP =   3,
	IPPROTO_TCP =   6,
	IPPROTO_PUP =   12,
	IPPROTO_UDP =   17,
	IPPROTO_IDP =   22,
	IPPROTO_IPV6 =  41,
	IPPROTO_ND =    77,
	IPPROTO_RAW =   255,
	
	IPPROTO_MAX =   256,
}


enum: int
{
	MSG_OOB =        0x1,
	MSG_PEEK =       0x2,
	MSG_DONTROUTE =  0x4,
        MSG_NOSIGNAL =   0x0, /// not supported on win32, would be 0x4000 if it was
}


enum: int
{
	SD_RECEIVE =  0,
	SD_SEND =     1,
	SD_BOTH =     2,
}


enum: uint
{
	INADDR_ANY =        0,
	INADDR_LOOPBACK =   0x7F000001,
	INADDR_BROADCAST =  0xFFFFFFFF,
	INADDR_NONE =       0xFFFFFFFF,
	ADDR_ANY =          INADDR_ANY,
}


enum: int
{
	AI_PASSIVE = 0x1,
	AI_CANONNAME = 0x2,
	AI_NUMERICHOST = 0x4,
}


struct timeval
{
	int32_t tv_sec;
	int32_t tv_usec;
}


union in_addr
{
	private union _S_un_t
	{
		private struct _S_un_b_t
		{
			uint8_t s_b1, s_b2, s_b3, s_b4;
		}
		_S_un_b_t S_un_b;
		
		private struct _S_un_w_t
		{
			uint16_t s_w1, s_w2;
		}
		_S_un_w_t S_un_w;
		
		uint32_t S_addr;
	}
	_S_un_t S_un;
	
	uint32_t s_addr;
	
	struct
	{
		uint8_t s_net, s_host;
		
		union
		{
			uint16_t s_imp;
			
			struct
			{
				uint8_t s_lh, s_impno;
			}
		}
	}
}


union in6_addr
{
	private union _in6_u_t
	{
		uint8_t[16] u6_addr8;
		uint16_t[8] u6_addr16;
		uint32_t[4] u6_addr32;
	}
	_in6_u_t in6_u;
	
	uint8_t[16] s6_addr8;
	uint16_t[8] s6_addr16;
	uint32_t[4] s6_addr32;
	
	alias s6_addr8 s6_addr;
}


const in6_addr IN6ADDR_ANY = { s6_addr8: [0] };
const in6_addr IN6ADDR_LOOPBACK = { s6_addr8: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] };
//alias IN6ADDR_ANY IN6ADDR_ANY_INIT;
//alias IN6ADDR_LOOPBACK IN6ADDR_LOOPBACK_INIT;
	
const uint INET_ADDRSTRLEN = 16;
const uint INET6_ADDRSTRLEN = 46;


struct sockaddr
{
	int16_t sa_family;               
	ubyte[14] sa_data;             
}


struct sockaddr_in
{
	int16_t sin_family = AF_INET;
	uint16_t sin_port;
	in_addr sin_addr;
	ubyte[8] sin_zero;
}


struct sockaddr_in6
{
	int16_t sin6_family = AF_INET6;
	uint16_t sin6_port;
	uint32_t sin6_flowinfo;
	in6_addr sin6_addr;
	uint32_t sin6_scope_id;
}


struct addrinfo
{
	int32_t ai_flags; 
	int32_t ai_family;
	int32_t ai_socktype;
	int32_t ai_protocol;
	size_t ai_addrlen;
	char* ai_canonname;
	sockaddr* ai_addr;
	addrinfo* ai_next;
}


struct hostent
{
	char* h_name;
	char** h_aliases;
	int16_t h_addrtype;
	int16_t h_length;
	char** h_addr_list;
	
	
	char* h_addr()
	{
		return h_addr_list[0];
	}
  }
}
/************************************** os.win.com *********************************************************/

//alias WCHAR OLECHAR;
alias OLECHAR *LPOLESTR;
alias OLECHAR *LPCOLESTR;

enum
{
	rmm = 23,	// OLE 2 version number info
	rup = 639,
}

enum : int
{
	S_OK = 0,
	S_FALSE = 0x00000001,
	NOERROR = 0,
	E_NOTIMPL     = cast(int)0x80004001,
	E_NOINTERFACE = cast(int)0x80004002,
	E_POINTER     = cast(int)0x80004003,
	E_ABORT       = cast(int)0x80004004,
	E_FAIL        = cast(int)0x80004005,
	E_HANDLE      = cast(int)0x80070006,
	CLASS_E_NOAGGREGATION = cast(int)0x80040110,
	E_OUTOFMEMORY = cast(int)0x8007000E,
	E_INVALIDARG  = cast(int)0x80070057,
	E_UNEXPECTED  = cast(int)0x8000FFFF,
}

struct GUID {          // size is 16
    align(1):
	DWORD Data1;
	WORD  Data2;
	WORD  Data3;
	BYTE  Data4[8];
}
alias IID ИИД;
enum
{
	CLSCTX_INPROC_SERVER	= 0x1,
	CLSCTX_INPROC_HANDLER	= 0x2,
	CLSCTX_LOCAL_SERVER	= 0x4,
	CLSCTX_INPROC_SERVER16	= 0x8,
	CLSCTX_REMOTE_SERVER	= 0x10,
	CLSCTX_INPROC_HANDLER16	= 0x20,
	CLSCTX_INPROC_SERVERX86	= 0x40,
	CLSCTX_INPROC_HANDLERX86 = 0x80,

	CLSCTX_INPROC = (CLSCTX_INPROC_SERVER|CLSCTX_INPROC_HANDLER),
	CLSCTX_ALL = (CLSCTX_INPROC_SERVER| CLSCTX_INPROC_HANDLER| CLSCTX_LOCAL_SERVER),
	CLSCTX_SERVER = (CLSCTX_INPROC_SERVER|CLSCTX_LOCAL_SERVER),
}

alias GUID IID;
alias GUID CLSID;
/+
extern (C)
{
    extern IID IID_IUnknown;
    extern IID IID_IClassFactory;
    extern IID IID_IMarshal;
    extern IID IID_IMallocSpy;
    extern IID IID_IStdMarshalInfo;
    extern IID IID_IExternalConnection;
    extern IID IID_IMultiQI;
    extern IID IID_IEnumUnknown;
    extern IID IID_IBindCtx;
    extern IID IID_IEnumMoniker;
    extern IID IID_IRunnableObject;
    extern IID IID_IRunningObjectTable;
    extern IID IID_IPersist;
    extern IID IID_IPersistStream;
    extern IID IID_IMoniker;
    extern IID IID_IROTData;
    extern IID IID_IEnumString;
    extern IID IID_ISequentialStream;
    extern IID IID_IStream;
    extern IID IID_IEnumSTATSTG;
    extern IID IID_IStorage;
    extern IID IID_IPersistFile;
    extern IID IID_IPersistStorage;
    extern IID IID_ILockBytes;
    extern IID IID_IEnumFORMATETC;
    extern IID IID_IEnumSTATDATA;
    extern IID IID_IRootStorage;
    extern IID IID_IAdviseSink;
    extern IID IID_IAdviseSink2;
    extern IID IID_IDataObject;
    extern IID IID_IDataAdviseHolder;
    extern IID IID_IMessageFilter;
    extern IID IID_IRpcChannelBuffer;
    extern IID IID_IRpcProxyBuffer;
    extern IID IID_IRpcStubBuffer;
    extern IID IID_IPSFactoryBuffer;
    extern IID IID_IPropertyStorage;
    extern IID IID_IPropertySetStorage;
    extern IID IID_IEnumSTATPROPSTG;
    extern IID IID_IEnumSTATPROPSETSTG;
    extern IID IID_IFillLockBytes;
    extern IID IID_IProgressNotify;
    extern IID IID_ILayoutStorage;
    extern IID GUID_NULL;
    extern IID IID_IRpcChannel;
    extern IID IID_IRpcStub;
    extern IID IID_IStubManager;
    extern IID IID_IRpcProxy;
    extern IID IID_IProxyManager;
    extern IID IID_IPSFactory;
    extern IID IID_IInternalMoniker;
    extern IID IID_IDfReserved1;
    extern IID IID_IDfReserved2;
    extern IID IID_IDfReserved3;
    extern IID IID_IStub;
    extern IID IID_IProxy;
    extern IID IID_IEnumGeneric;
    extern IID IID_IEnumHolder;
    extern IID IID_IEnumCallback;
    extern IID IID_IOleManager;
    extern IID IID_IOlePresObj;
    extern IID IID_IDebug;
    extern IID IID_IDebugStream;
    extern IID IID_StdOle;
    extern IID IID_ICreateTypeInfo;
    extern IID IID_ICreateTypeInfo2;
    extern IID IID_ICreateTypeLib;
    extern IID IID_ICreateTypeLib2;
    extern IID IID_IDispatch;
    extern IID IID_IEnumVARIANT;
    extern IID IID_ITypeComp;
    extern IID IID_ITypeInfo;
    extern IID IID_ITypeInfo2;
    extern IID IID_ITypeLib;
    extern IID IID_ITypeLib2;
    extern IID IID_ITypeChangeEvents;
    extern IID IID_IErrorInfo;
    extern IID IID_ICreateErrorInfo;
    extern IID IID_ISupportErrorInfo;
    extern IID IID_IOleAdviseHolder;
    extern IID IID_IOleCache;
    extern IID IID_IOleCache2;
    extern IID IID_IOleCacheControl;
    extern IID IID_IParseDisplayName;
    extern IID IID_IOleContainer;
    extern IID IID_IOleClientSite;
    extern IID IID_IOleObject;
    extern IID IID_IOleWindow;
    extern IID IID_IOleLink;
    extern IID IID_IOleItemContainer;
    extern IID IID_IOleInPlaceUIWindow;
    extern IID IID_IOleInPlaceActiveObject;
    extern IID IID_IOleInPlaceFrame;
    extern IID IID_IOleInPlaceObject;
    extern IID IID_IOleInPlaceSite;
    extern IID IID_IContinue;
    extern IID IID_IViewObject;
    extern IID IID_IViewObject2;
    extern IID IID_IDropSource;
    extern IID IID_IDropTarget;
    extern IID IID_IEnumOLEVERB;
}
+/
extern (System)
{

extern (Windows)
{
DWORD   CoBuildVersion();

int StringFromGUID2(GUID *rguid, LPOLESTR lpsz, int cbMax);

/* init/uninit */

HRESULT CoInitialize(LPVOID pvReserved);
void    CoUninitialize();
DWORD   CoGetCurrentProcess();


HRESULT CoCreateInstance(CLSID *rclsid, IUnknown UnkOuter,
                    DWORD dwClsContext, IID* riid, void* ppv);

//HINSTANCE CoLoadLibrary(LPOLESTR lpszLibName, BOOL bAutoFree);
void    CoFreeLibrary(HINSTANCE hInst);
void    CoFreeAllLibraries();
void    CoFreeUnusedLibraries();
}

interface IUnknown
{
    HRESULT QueryInterface(IID* riid, void** pvObject);
    ULONG AddRef();
    ULONG Release();
}

interface IClassFactory : IUnknown
{
    HRESULT CreateInstance(IUnknown UnkOuter, IID* riid, void** pvObject);
    HRESULT LockServer(BOOL fLock);
}

class ComObject : IUnknown
{
extern (System):
    HRESULT QueryInterface(IID* riid, void** ppv)
    {
	if (*riid == cast(IID) IID_IUnknown)
	{
	    *ppv = cast(void*)cast(IUnknown)this;
	    AddRef();
	    return S_OK;
	}
	else
	{   *ppv = null;
	    return E_NOINTERFACE;
	}
    }

    ULONG AddRef()
    {
	return InterlockedIncrement(&count);
    }

    ULONG Release()
    {
	LONG lRef = InterlockedDecrement(&count);
	if (lRef == 0)
	{
	    // free object

	    // If we delete this object, then the postinvariant called upon
	    // return from Release() will fail.
	    // Just let the GC reap it.
	    //delete this;

	    return 0;
	}
	return cast(ULONG)lRef;
    }

    LONG count = 0;		// object reference count
}

}

/****************************************** os.win.stat ************************************************/

extern (C):

// linux version is in linux

version (Windows)
{
const S_IFMT   = 0xF000;
const S_IFDIR  = 0x4000;
const S_IFCHR  = 0x2000;
const S_IFIFO  = 0x1000;
const S_IFREG  = 0x8000;
const S_IREAD  = 0x0100;
const S_IWRITE = 0x0080;
const S_IEXEC  = 0x0040;
const S_IFBLK  = 0x6000;
const S_IFNAM  = 0x5000;

int S_ISREG(int m)  { return (m & S_IFMT) == S_IFREG; }
int S_ISBLK(int m)  { return (m & S_IFMT) == S_IFBLK; }
int S_ISNAM(int m)  { return (m & S_IFMT) == S_IFNAM; }
int S_ISDIR(int m)  { return (m & S_IFMT) == S_IFDIR; }
int S_ISCHR(int m)  { return (m & S_IFMT) == S_IFCHR; }

struct struct_stat
{
    short st_dev;
    ushort st_ino;
    ushort st_mode;
    short st_nlink;
    ushort st_uid;
    ushort st_gid;
    short st_rdev;
    short dummy;
    int st_size;
    int st_atime;
    int st_mtime;
    int st_ctime;
}

int  stat(char *, struct_stat *);
int  fstat(int, struct_stat *);
int  _wstat(wchar *, struct_stat *);
}


extern(Windows):
	
	struct SIZE
	{
		LONG cx;
		LONG cy;
	}
	alias SIZE* LPSIZE;
	
	
	struct POINTL
	{
		LONG x;
		LONG y;
	}
	alias POINTL* LPPOINTL;
	
	
	alias RECT* LPCRECT;
	
	
	
	alias HRESULT THEMEAPI;
	
	
	union LARGE_INTEGER
	{
		struct
		{
			DWORD LowPart;
			LONG HighPart;
		}
		private struct _U
		{
			DWORD LowPart;
			LONG HighPart;
		}
		_U u;
		LONGLONG QuadPart;
	}
	
	
	union ULARGE_INTEGER
	{
		struct
		{
			DWORD LowPart;
			DWORD HighPart;
		}
		private struct _U
		{
			DWORD LowPart;
			DWORD HighPart;
		}
		_U u;
		DWORDLONG QuadPart;
	}
	

	enum: UINT
	{
		SWP_NOSIZE = 0x0001,
		SWP_NOMOVE = 0x0002,
		SWP_NOZORDER = 0x0004,
		SWP_NOREDRAW = 0x0008,
		SWP_NOACTIVATE = 0x0010,
		SWP_FRAMECHANGED = 0x0020,
		SWP_SHOWWINDOW = 0x0040,
		SWP_HIDEWINDOW = 0x0080,
		SWP_NOCOPYBITS = 0x0100,
		SWP_NOOWNERZORDER = 0x0200,
		SWP_NOSENDCHANGING = 0x0400,
		SWP_DRAWFRAME = SWP_FRAMECHANGED,
		SWP_NOREPOSITION = SWP_NOOWNERZORDER,
		SWP_DEFERERASE = 0x2000,
		SWP_ASYNCWINDOWPOS = 0x4000,
	}
	
	
	enum: UINT
	{
		GW_HWNDFIRST = 0,
		GW_HWNDLAST = 1,
		GW_HWNDNEXT = 2,
		GW_HWNDPREV = 3,
		GW_OWNER = 4,
		GW_CHILD = 5,
	}
	
	
	enum: UINT
	{
		DI_MASK = 0x0001,
		DI_IMAGE = 0x0002,
		DI_COMPAT = 0x0004,
		DI_DEFAULTSIZE = 0x0008,
		DI_NORMAL = DI_IMAGE | DI_MASK,
	}
	
	
	enum: цел
	{
		GCL_MENUNAME = -8,
		GCL_HBRBACKGROUND = -10,
		GCL_HCURSOR = -12,
		GCL_HICON = -14,
		GCL_HMODULE = -16,
		GCL_CBWNDEXTRA = -18,
		GCL_CBCLSEXTRA = -20,
		GCL_WNDPROC = -24,
		GCL_STYLE = -26,
		GCW_ATOM = -32,
		GCL_HICONSM = -34,
	}
	
	
	enum: UINT
	{
		SC_SIZE = 0xF000,
		SC_MOVE = 0xF010,
		SC_MINIMIZE = 0xF020,
		SC_MAXIMIZE = 0xF030,
		SC_CLOSE = 0xF060,
		SC_VSCROLL = 0xF070,
		SC_HSCROLL = 0xF080,
		SC_RESTORE = 0xF120,
		SC_SEPARATOR = 0xF00F,
	}
	
	
	enum: цел
	{
		GWL_WNDPROC = -4,
		GWL_HINSTANCE = -6,
		GWL_HWNDPARENT = -8,
		GWL_STYLE = -16,
		GWL_EXSTYLE = -20,
		GWL_USERDATA = -21,
		GWL_ID = -12,
		
		DWL_MSGRESULT = 0,
		DWL_DLGPROC = 4,
		DWL_USER = 8,
	}
	
	
	enum: UINT
	{
		WM_SETFONT = 0x0030,
		WM_GETFONT = 0x0031,
		WM_COMPACTING = 0x0041,
		WM_USER = 0x0400,
		WM_NEXTDLGCTL = 0x0028,
		WM_CAPTURECHANGED = 0x0215,
		WM_WINDOWPOSCHANGING = 0x0046, 
		WM_WINDOWPOSCHANGED = 0x0047,
		WM_DRAWITEM = 0x002B,
		WM_DROPFILES = 0x0233,
		WM_PALETTECHANGED = 0x0311,
		
		WM_CLEAR = 0x0303,
		
		WM_CUT = 0x0300,
		WM_COPY = 0x0301,
		WM_PASTE = 0x0302,
		
		WM_MDIACTIVATE = 0x0222,
		WM_MDITILE = 0x0226,
		WM_MDICASCADE = 0x0227,
		WM_MDIICONARRANGE = 0x0228,
		WM_MDIGETACTIVE = 0x0229,
		
		WM_MOUSEWHEEL = 0x020A,
		WM_MOUSEHOVER = 0x02A1,
		WM_MOUSELEAVE = 0x02A3,
		
		
		WM_PRINT = 0x0317,
		WM_PRINTCLIENT = 0x0318,
		
		WM_MEASUREITEM = 0x002C,
		
		DM_SETDEFID = WM_USER + 1,
	}
	
	
	enum: UINT
	{
		BFFM_INITIALIZED = 1,
		BFFM_SETSELECTIONA = WM_USER + 102,
		BFFM_SETSELECTIONW = WM_USER + 103,
	}
	
	
	enum: UINT
	{
		NM_FIRST = 0,
		NM_CLICK = NM_FIRST - 2,
		NM_CUSTOMDRAW = NM_FIRST - 12,
	}
	
	
	struct NMMOUSE
	{
		NMHDR hdr;
		DWORD dwItemSpec;
		DWORD dwItemData;
		POINT pt;
		LPARAM dwHitInfo;
	}
	alias NMMOUSE* LPNMMOUSE;
	
	
	enum: UINT
	{
		TTM_ACTIVATE = WM_USER + 1,
		TTM_SETDELAYTIME = WM_USER + 3,
		TTM_ADDTOOLA = WM_USER + 4,
		TTM_DELTOOLA = WM_USER + 5,
		TTM_GETTOOLINFOA = WM_USER + 8,
		TTM_GETTEXTA = WM_USER + 11,
		TTM_UPDATETIPTEXTA = WM_USER + 12,
		TTM_ENUMTOOLSA = WM_USER + 14,
		TTM_GETCURRENTTOOLA = WM_USER + 15,
		TTM_ADDTOOLW = WM_USER + 50,
		TTM_GETTEXTW = WM_USER + 56,
		TTM_UPDATETIPTEXTW = WM_USER + 57,
	}
	
	
	enum: WPARAM
	{
		TTDT_AUTOMATIC = 0,
		TTDT_RESHOW = 1,
		TTDT_AUTOPOP = 2,
		TTDT_INITIAL = 3,
	}
	
	
	// Rich edit.
	enum: UINT
	{
		ES_DISABLENOSCROLL = 0x00002000,
		
		EM_CANPASTE = WM_USER + 50,
		EM_EXGETSEL = WM_USER + 52,
		EM_EXLIMITTEXT = WM_USER + 53,
		EM_EXLINEFROMCHAR = WM_USER + 54,
		EM_EXSETSEL = WM_USER + 55,
		EM_GETCHARFORMAT = WM_USER + 58,
		EM_GETSELTEXT = WM_USER + 62,
		EM_PASTESPECIAL = WM_USER + 64,
		EM_SETBKGNDCOLOR = WM_USER + 67,
		EM_SETCHARFORMAT = WM_USER + 68,
		EM_SETEVENTMASK = WM_USER + 69,
		EM_STREAMIN = WM_USER + 73,
		EM_STREAMOUT = WM_USER + 74,
		EM_GETTEXTRANGE = WM_USER + 75,
		
		// 2.0
		EM_SETUNDOLIMIT = WM_USER + 82,
		EM_REDO = WM_USER + 84,
		EM_CANREDO = WM_USER + 85,
		EM_GETUNDONAME = WM_USER + 86,
		EM_GETREDONAME = WM_USER + 87,
		EM_STOPGROUPTYPING = WM_USER + 88,
		EM_SETTEXTMODE = WM_USER + 89,
		EM_GETTEXTMODE = WM_USER + 90,
		
		EM_AUTOURLDETECT = WM_USER + 91,
		EM_GETAUTOURLDETECT = WM_USER + 92,
		EM_SETPALETTE = WM_USER + 93,
		EM_GETTEXTEX = WM_USER + 94,
		EM_GETTEXTLENGTHEX = WM_USER + 95,
		EM_SHOWSCROLLBAR = WM_USER + 96,
		EM_SETTEXTEX = WM_USER + 97,
		
		EN_LINK = 0x070B,
	}
	
	
	// Rich edit.
	enum: UINT
	{
		SF_TEXT = 0x0001,
		SF_RTF = 0x0002,
		SF_RTFNOOBJS = 0x0003,
		SF_TEXTIZED = 0x0004,
		
		SFF_SELECTION = 0x8000,
		SFF_PLAINRTF = 0x4000,
		
		SCF_SELECTION = 0x0001,
		SCF_WORD = 0x0002,
		SCF_ALL = 0x0004,
		
		CFM_BOLD = 0x00000001,
		CFM_ITALIC = 0x00000002,
		CFM_UNDERLINE = 0x00000004,
		CFM_STRIKEOUT = 0x00000008,
		CFM_PROTECTED = 0x00000010,
		CFM_LINK = 0x00000020,
		CFM_SIZE = 0x80000000,
		CFM_COLOR = 0x40000000,
		CFM_FACE = 0x20000000,
		CFM_OFFSET = 0x10000000,
		CFM_CHARSET = 0x08000000,
		CFM_SMALLCAPS = 0x0040,
		CFM_ALLCAPS = 0x0080,
		CFM_HIDDEN = 0x0100,
		CFM_OUTLINE = 0x0200,
		CFM_SHADOW = 0x0400,
		CFM_EMBOSS = 0x0800,
		CFM_IMPRINT = 0x1000,
		CFM_DISABLED = 0x2000,
		CFM_REVISED = 0x4000,
		CFM_BACKCOLOR = 0x04000000,
		CFM_LCID = 0x02000000,
		CFM_UNDERLINETYPE = 0x00800000,
		CFM_WEIGHT = 0x00400000,
		CFM_SPACING = 0x00200000,
		CFM_KERNING = 0x00100000,
		CFM_STYLE = 0x00080000,
		CFM_ANIMATION = 0x00040000,
		CFM_REVAUTHOR = 0x00008000,
		
		CFE_BOLD = 0x0001,
		CFE_ITALIC = 0x0002,
		CFE_UNDERLINE = 0x0004,
		CFE_STRIKEOUT = 0x0008,
		CFE_PROTECTED = 0x0010,
		CFE_LINK = 0x0020,
		CFE_AUTOCOLOR = 0x40000000,
		CFE_AUTOBACKCOLOR	= CFM_BACKCOLOR,
		CFE_SUBSCRIPT = 0x00010000,
		CFE_SUPERSCRIPT = 0x00020000,
		
		CFM_SUBSCRIPT = CFE_SUBSCRIPT | CFE_SUPERSCRIPT,
		CFM_SUPERSCRIPT = CFM_SUBSCRIPT,
		
		CFU_UNDERLINE = 1,
		
		ENM_NONE = 0x00000000,
		ENM_CHANGE = 0x00000001,
		ENM_UPDATE = 0x00000002,
		ENM_LINK = 0x04000000,
		ENM_PROTECTED = 0x00200000,
	}
	
	
	enum: DWORD
	{
		PRF_CLIENT = 0x00000004,
	}
	
	
	enum: DWORD
	{
		STAP_ALLOW_NONCLIENT = 0x00000001,
		STAP_ALLOW_CONTROLS = 0x00000002,
		STAP_ALLOW_WEBCONTENT = 0x00000004,
	}
	
	
	enum: LPARAM
	{
		ENDSESSION_LOGOFF = 0x80000000,
	}
	
	
	enum: цел
	{
		BLACKONWHITE = 1,
		WHITEONBLACK = 2,
		COLORONCOLOR = 3,
		HALFTONE = 4,
	}
	
	
	enum: UINT
	{
		CDN_FIRST = cast(UINT)-601,
		CDN_LAST = cast(UINT)-699,
		CDN_INITDONE = CDN_FIRST - 0x0000,
		CDN_SELCHANGE = CDN_FIRST - 0x0001,
		CDN_FOLDERCHANGE = CDN_FIRST - 0x0002,
		CDN_SHAREVIOLATION = CDN_FIRST - 0x0003,
		CDN_HELP = CDN_FIRST - 0x0004,
		CDN_FILEOK = CDN_FIRST - 0x0005,
		CDN_TYPECHANGE = CDN_FIRST - 0x0006,
		CDN_INCLUDEITEM = CDN_FIRST - 0x0007,
	}
	
	
	enum: DWORD
	{
		OFN_READONLY = 0x00000001,
		OFN_OVERWRITEPROMPT = 0x00000002,
		OFN_HIDEREADONLY = 0x00000004,
		OFN_NOCHANGEDIR = 0x00000008,
		OFN_SHOWHELP = 0x00000010,
		OFN_ENABLEHOOK = 0x00000020,
		OFN_ENABLETEMPLATE = 0x00000040,
		OFN_ENABLETEMPLATEHANDLE = 0x00000080,
		OFN_NOVALIDATE = 0x00000100,
		OFN_ALLOWMULTISELECT = 0x00000200,
		OFN_EXTENSIONDIFFERENT = 0x00000400,
		OFN_PATHMUSTEXIST = 0x00000800,
		OFN_FILEMUSTEXIST = 0x00001000,
		OFN_CREATEPROMPT = 0x00002000,
		OFN_SHAREAWARE = 0x00004000,
		OFN_NOREADONLYRETURN = 0x00008000,
		OFN_NOTESTFILECREATE = 0x00010000,
		OFN_NONETWORKBUTTON = 0x00020000,
		OFN_NOLONGNAMES = 0x00040000,
		OFN_EXPLORER = 0x00080000,
		OFN_NODEREFERENCELINKS = 0x00100000,
		OFN_LONGNAMES = 0x00200000,
		OFN_ENABLEINCLUDENOTIFY = 0x00400000,
		OFN_ENABLESIZING = 0x00800000,
		OFN_DONTADDTORECENT = 0x02000000,
		OFN_FORCESHOWHIDDEN = 0x10000000,
	}
	
	
	enum: DWORD
	{
		CF_SCREENFONTS = 0x00000001,
		CF_PRINTERFONTS = 0x00000002,
		CF_BOTH = CF_SCREENFONTS | CF_PRINTERFONTS,
		CF_SHOWHELP = 0x00000004,
		CF_ENABLEHOOK = 0x00000008,
		CF_ENABLETEMPLATE = 0x00000010,
		CF_ENABLETEMPLATEHANDLE = 0x00000020,
		CF_INITTOLOGFONTSTRUCT = 0x00000040,
		CF_USESTYLE = 0x00000080,
		CF_EFFECTS = 0x00000100,
		CF_APPLY = 0x00000200,
		CF_ANSIONLY = 0x00000400,
		CF_SCRIPTSONLY = CF_ANSIONLY,
		CF_NOVECTORFONTS = 0x00000800,
		CF_NOOEMFONTS = CF_NOVECTORFONTS,
		CF_NOSIMULATIONS = 0x00001000,
		CF_LIMITSIZE = 0x00002000,
		CF_FIXEDPITCHONLY = 0x00004000,
		CF_WYSIWYG = 0x00008000,
		CF_FORCEFONTEXIST = 0x00010000,
		CF_SCALABLEONLY = 0x00020000,
		CF_TTONLY = 0x00040000,
		CF_NOFACESEL = 0x00080000,
		CF_NOSTYLESEL = 0x00100000,
		CF_NOSIZESEL = 0x00200000,
		CF_SELECTSCRIPT = 0x00400000,
		CF_NOSCRIPTSEL = 0x00800000,
		CF_NOVERTFONTS = 0x01000000,
	}
	
	
	enum: UINT
	{
		ODT_MENU = 1,
		ODT_LISTBOX = 2,
		ODT_COMBOBOX = 3,
		ODT_BUTTON = 4,
		ODT_STATIC = 5,
	}
	
	
	enum: цел
	{
		HC_ACTION = 0,
	}
	
	
	enum: цел
	{
		WH_GETMESSAGE = 3,
		WH_CALLWNDPROC = 4,
		WH_CALLWNDPROCRET = 12,
	}
	
	
	struct CWPSTRUCT
	{
		LPARAM lParam;
		WPARAM wParam;
		UINT message;
		HWND hwnd;
	}
	alias CWPSTRUCT* LPCWPSTRUCT;
	
	
	struct CWPRETSTRUCT
	{
		LRESULT lResult;
		LPARAM lParam;
		WPARAM wParam;
		DWORD message;
		HWND hwnd;
	}
	alias CWPRETSTRUCT* LPCWPRETSTRUCT;
	
	
	enum: UINT
	{
		MDITILE_VERTICAL = 0x0000,
		MDITILE_HORIZONTAL = 0x0001,
		MDITILE_SKIPDISABLED = 0x0002,
		MDITILE_ZORDER = 0x0004,
	}
	
	
	enum: DWORD
	{
		WS_EX_NOPARENTNOTIFY = 0x00000004,
		WS_EX_ACCEPTFILES = 0x00000010,
		WS_EX_TRANSPARENT = 0x00000020,
		WS_EX_RTLREADING = 0x00002000,
		WS_EX_APPWINDOW = 0x00040000,
		WS_EX_DLGMODALFRAME = 0x00000001,
		WS_EX_CONTROLPARENT = 0x00010000,
		WS_EX_WINDOWEDGE = 0x00000100,
		WS_EX_CLIENTEDGE = 0x00000200,
		WS_EX_TOOLWINDOW = 0x00000080,
		WS_EX_STATICEDGE = 0x00020000,
		WS_EX_CONTEXTHELP = 0x00000400,
		WS_EX_MDICHILD = 0x00000040,
		WS_EX_LAYERED = 0x00080000,
		WS_EX_TOPMOST = 0x00000008,
	}
	
	
	enum: DWORD
	{
		TTS_ALWAYSTIP = 0x01,
		TTS_NOPREFIX = 0x02,
		TTS_NOANIMATE = 0x10, // IE5+
		TTS_NOFADE = 0x20, // IE5+
		TTS_BALLOON = 0x40, // IE5+
	}
	
	
	enum
	{
		TTF_IDISHWND = 0x0001,
		TTF_CENTERTIP = 0x0002,
		TTF_RTLREADING = 0x0004,
		TTF_SUBCLASS = 0x0010,
		TTF_TRACK = 0x0020, // IE3+
		TTF_ABSOLUTE = 0x0080, // IE3+
		TTF_TRANSPARENT = 0x0100, // IE3+
		TTF_DI_SETITEM = 0x8000, // IE3+
	}
	
	
	enum: WPARAM
	{
		SIZE_RESTORED = 0,
		SIZE_MINIMIZED = 1,
		SIZE_MAXIMIZED = 2,
		SIZE_MAXSHOW = 3,
		SIZE_MAXHIDE = 4,
	}
	
	
	enum: DWORD
	{
		LWA_COLORKEY = 1,
		LWA_ALPHA = 2,
		
		AW_HOR_POSITIVE = 0x00000001,
		AW_HOR_NEGATIVE = 0x00000002,
		AW_VER_POSITIVE = 0x00000004,
		AW_VER_NEGATIVE = 0x00000008,
		AW_CENTER = 0x00000010,
		AW_HIDE = 0x00010000,
		AW_ACTIVATE = 0x00020000,
		AW_SLIDE = 0x00040000,
		AW_BLEND = 0x00080000,
	}
	
	
	enum: UINT
	{
		MF_STRING = 0x00000000,
		MF_UNCHECKED = 0x00000000,
		MF_BYCOMMAND = 0x00000000,
		MF_GRAYED = 0x00000001,
		MF_CHECKED = 0x00000008,
		MF_POPUP = 0x00000010,
		MF_MENUBARBREAK = 0x00000020,
		MF_MENUBREAK = 0x00000040,
		MF_BYPOSITION = 0x00000400,
		MF_SEPARATOR = 0x00000800,
		MF_DEFAULT = 0x00001000,
		MF_SYSMENU = 0x00002000,
		
		MFT_STRING = MF_STRING,
		MFT_MENUBARBREAK = MF_MENUBARBREAK,
		MFT_MENUBREAK = MF_MENUBREAK,
		MFT_RADIOCHECK = 0x00000200,
		MFT_SEPARATOR = MF_SEPARATOR,
		
		MFS_UNCHECKED = MF_UNCHECKED,
		MFS_CHECKED = MF_CHECKED,
		MFS_DEFAULT = MF_DEFAULT,
		MFS_GRAYED = MF_GRAYED,
		
		MIIM_STATE = 0x00000001,
		MIIM_ID = 0x00000002,
		MIIM_SUBMENU = 0x00000004,
		MIIM_TYPE = 0x00000010,
	}
	
	
	enum: цел
	{
		RGN_AND = 1,
		RGN_OR = 2,
		RGN_XOR = 3,
		RGN_DIFF = 4,
		RGN_COPY = 5,
	}
	
	
	//alias UINT CLIPFORMAT; // ?
	alias WORD CLIPFORMAT; // ?
	
	
	// enum can't derive from HWND.
	const HWND HWND_TOP = cast(HWND)0;
	const HWND HWND_BOTTOM = cast(HWND)1;
	const HWND HWND_TOPMOST = cast(HWND)-1;
	const HWND HWND_NOTOPMOST = cast(HWND)-2;
	
	
	
	enum: UINT
	{
		CBS_SIMPLE = 0x0001,
		CBS_DROPDOWN = 0x0002,
		CBS_DROPDOWNLIST = 0x0003,
		CBS_AUTOHSCROLL = 0x0040,
		CBS_OWNERDRAWFIXED = 0x0010,
		CBS_OWNERDRAWVARIABLE = 0x0020,
	}
	
	
	enum: DWORD
	{
		TME_HOVER =   1,
		TME_LEAVE =   2,
		TME_QUERY =   0x40000000,
		TME_CANCEL =  0x80000000,
	}
	
	
	const DWORD HOVER_DEFAULT = 0xFFFFFFFF;
	
	
	enum: UINT
	{
		TPM_LEFTBUTTON = 0x0000,
		TPM_RIGHTBUTTON = 0x0002,
		TPM_LEFTALIGN = 0x0000,
		TPM_CENTERALIGN = 0x0004,
		TPM_RIGHTALIGN = 0x0008,
		TPM_TOPALIGN = 0x0000,
		TPM_VCENTERALIGN = 0x0010,
		TPM_BOTTOMALIGN = 0x0020,
		TPM_HORIZONTAL = 0x0000,
		TPM_VERTICAL = 0x0040,
		TPM_NONOTIFY = 0x0080,
		TPM_RETURNCMD = 0x0100,
		TPM_RECURSE = 0x0001,
	}
	
	
	enum
	{
		ICON_SMALL = 0,
		ICON_BIG = 1,
	}
	
	enum: UINT
	{
		SPI_GETNONCLIENTMETRICS = 41,
		SPI_GETWORKAREA = 48,
		SPI_GETANIMATION = 72,
		SPI_GETWHEELSCROLLLINES = 104,
		SPI_GETWHEELSCROLLCHARS = 108,
		// ...
	}
	
	
	enum: DWORD
	{
		ABM_GETTASKBARPOS = 0x00000005,
		// ...
	}
	
	
	enum: UINT
	{
		ABE_LEFT = 0,
		ABE_TOP = 1,
		ABE_RIGHT = 2,
		ABE_BOTTOM = 3,
	}
	
	
	const LPSTR IDC_APPSTARTING =  cast(LPSTR)32650;
	const LPSTR IDC_HAND = cast(LPSTR)32649; // Windows 98+
	const LPSTR IDC_HELP = cast(LPSTR)32651;
	const LPSTR IDC_IBEAM = cast(LPSTR)32513;
	const LPSTR IDC_NO = cast(LPSTR)32648;
	const LPSTR IDC_SIZEALL = cast(LPSTR)32646;
	const LPSTR IDC_SIZENESW = cast(LPSTR)32643;
	const LPSTR IDC_SIZENS = cast(LPSTR)32645;
	const LPSTR IDC_SIZENWSE = cast(LPSTR)32642;
	const LPSTR IDC_SIZEWE = cast(LPSTR)32644;
	const LPSTR IDC_WAIT = cast(LPSTR)32514;
	
	
	enum: WORD
	{
		MK_LBUTTON = 0x0001,
		MK_RBUTTON = 0x0002,
		MK_SHIFT = 0x0004,
		MK_CONTROL = 0x0008,
		MK_MBUTTON = 0x0010,
	}
	
	
	enum: UINT
	{
		GMEM_MOVEABLE = 0x0002,
		GMEM_DDESHARE = 0x2000,
		GMEM_SHARE = 0x2000,
	}
	
	
	enum
	{
		LOGPIXELSX = 88,
		LOGPIXELSY = 90,
	}
	
	
	enum
	{
		MB_SERVICE_NOTIFICATION = 0x00200000,
	}
	
	
	enum
	{
		DLGC_WANTARROWS = 0x0001,
		DLGC_WANTTAB = 0x0002,
		DLGC_WANTALLKEYS = 0x0004,
		DLGC_HASSETSEL = 0x0008,
		DLGC_RADIOBUTTON = 0x0040,
		DLGC_WANTCHARS = 0x0080,
		DLGC_STATIC = 0x0100,
	}
	
	
	enum
	{
		LB_OKAY = 0,
		LB_ERR = -1,
		LB_ERRSPACE = -2,
	}
	
	
	enum: UINT
	{
		LB_GETCOUNT = 0x018B,
		LB_GETITEMDATA = 0x0199,
		LB_ADDSTRING = 0x0180,
		LB_SETITEMDATA = 0x019A,
		LB_RESETCONTENT = 0x0184,
		LB_INSERTSTRING = 0x0181,
		LB_DELETESTRING = 0x0182,
		LB_GETHORIZONTALEXTENT = 0x0193,
		LB_SETHORIZONTALEXTENT = 0x0194,
		LB_SETITEMHEIGHT = 0x01A0,
		LB_GETITEMHEIGHT = 0x01A1,
		LB_GETSELCOUNT = 0x0190,
		LB_GETSELITEMS = 0x0191,
		LB_SETCURSEL = 0x0186,
		LB_GETCURSEL = 0x0188,
		LB_SETTOPINDEX = 0x0197,
		LB_GETTOPINDEX = 0x018E,
		LB_SELITEMRANGE = 0x0183,
		LB_SETSEL = 0x0185,
		LB_FINDSTRING = 0x018F,
		LB_FINDSTRINGEXACT = 0x01A2,
		LB_GETITEMRECT = 0x0198,
		LB_GETSEL = 0x0187,
		LB_ITEMFROMPOINT = 0x01A9,
		LB_ADDFILE = 0x0196,
		LB_DIR = 0x018D,
	}
	
	
	enum: DWORD
	{
		LBS_NOINTEGRALHEIGHT = 0x0100,
		LBS_MULTICOLUMN = 0x0200,
		LBS_DISABLENOSCROLL = 0x1000,
		LBS_NOSEL = 0x4000,
		LBS_EXTENDEDSEL = 0x0800,
		LBS_MULTIPLESEL = 0x0008,
		LBS_SORT = 0x0002,
		LBS_USETABSTOPS = 0x0080,
		LBS_OWNERDRAWVARIABLE = 0x0020,
		LBS_OWNERDRAWFIXED = 0x0010,
		LBS_NOTIFY = 0x0001,
		LBS_HASSTRINGS = 0x0040,
	}
	
	
	enum
	{
		LBN_ERRSPACE = -2,
		LBN_SELCHANGE = 1,
		LBN_DBLCLK = 2,
		LBN_SELCANCEL = 3,
		LBN_SETFOCUS = 4,
		LBN_KILLFOCUS = 5,
	}
	
	
	enum
	{
		CB_OKAY = 0,
		CB_ERR = -1,
		CB_ERRSPACE = -2,
	}
	
	
	enum: UINT
	{
		CB_SETCURSEL = 0x014E,
		CB_GETCURSEL = 0x0147,
		CB_FINDSTRING = 0x014C,
		CB_FINDSTRINGEXACT = 0x0158,
		CB_SETITEMHEIGHT = 0x0153,
		CB_GETITEMHEIGHT = 0x0154,
		CB_ADDSTRING = 0x0143,
		CB_DELETESTRING = 0x0144,
		CB_DIR = 0x0145,
		CB_INSERTSTRING = 0x014A,
		CB_RESETCONTENT = 0x014B,
		CB_SETITEMDATA = 0x0151,
		CB_GETDROPPEDWIDTH = 0x015f,
		CB_SETDROPPEDWIDTH = 0x0160,
		CB_LIMITTEXT = 0x0141,
		CB_GETEDITSEL = 0x0140,
		CB_SETEDITSEL = 0x0142,
		CB_SHOWDROPDOWN = 0x014F,
		CB_GETDROPPEDSTATE = 0x0157,
	}
	
	
	enum: DWORD
	{
		CBS_SORT = 0x0100,
		CBS_HASSTRINGS = 0x0200,
		CBS_NOINTEGRALHEIGHT = 0x0400,
	}
	
	
	enum
	{
		CBN_SELCHANGE = 1,
		CBN_SETFOCUS = 3,
		CBN_KILLFOCUS = 4,
		CBN_EDITCHANGE = 5,
	}
	
	
	enum: UINT
	{
		TVE_COLLAPSE = 0x0001,
		TVE_EXPAND = 0x0002,
		TVE_TOGGLE = 0x0003,
	}
	
	
	enum: UINT
	{
		TVIS_SELECTED = 0x0002,
		TVIS_EXPANDED = 0x0020,
	}
	
	
	enum: UINT
	{
		TVIF_TEXT = 0x0001,
		TVIF_IMAGE = 0x0002,
		TVIF_PARAM = 0x0004,
		TVIF_STATE = 0x0008,
		TVIF_HANDLE = 0x0010,
		TVIF_SELECTEDIMAGE = 0x0020,
		TVIF_CHILDREN = 0x0040,
		TVIF_INTEGRAL = 0x0080, // IE4+
	}
	
	
	const цел I_CHILDRENCALLBACK = -1;
	
	
	enum: UINT
	{
		TVGN_FIRSTVISIBLE = 0x0005,
		TVGN_CARET = 0x0009,
	}
	
	
	enum: UINT
	{
		TV_FIRST = 0x1100,
		
		TVM_INSERTITEMA = TV_FIRST + 0,
		TVM_DELETEITEM = TV_FIRST + 1,
		TVM_EXPAND = TV_FIRST + 2,
		TVM_GETITEMRECT = TV_FIRST + 4,
		TVM_GETINDENT = TV_FIRST + 6,
		TVM_SETINDENT = TV_FIRST + 7,
		TVM_SETIMAGELIST = TV_FIRST + 9,
		TVM_GETNEXTITEM = TV_FIRST + 10,
		TVM_SELECTITEM = TV_FIRST + 11,
		TVM_GETITEMA = TV_FIRST + 12,
		TVM_SETITEMA = TV_FIRST + 13,
		TVM_EDITLABELA = TV_FIRST + 14,
		TVM_GETVISIBLECOUNT = TV_FIRST + 16,
		TVM_HITTEST = TV_FIRST + 17,
		TVM_ENSUREVISIBLE = TV_FIRST + 20,
		TVM_SETITEMHEIGHT = TV_FIRST + 27, // IE4+
		TVM_GETITEMHEIGHT = TV_FIRST + 28, // IE4+
		TVM_INSERTITEMW = TV_FIRST + 50,
		TVM_SETITEMW = TV_FIRST + 63,
		
		TVN_FIRST = cast(UINT)-400,
		
		TVN_SELCHANGINGA = TVN_FIRST - 1,
		TVN_SELCHANGEDA = TVN_FIRST - 2,
		TVN_GETDISPINFOA = TVN_FIRST - 3,
		TVN_ITEMEXPANDINGA = TVN_FIRST - 5,
		TVN_ITEMEXPANDEDA = TVN_FIRST - 6,
		TVN_BEGINLABELEDITA = TVN_FIRST - 10,
		TVN_ENDLABELEDITA = TVN_FIRST - 11,
		
		TVN_SELCHANGINGW = TVN_FIRST - 50,
		TVN_SELCHANGEDW = TVN_FIRST - 51,
		TVN_GETDISPINFOW = TVN_FIRST - 52,
		TVN_ITEMEXPANDINGW = TVN_FIRST - 54,
		TVN_ITEMEXPANDEDW = TVN_FIRST - 55,
		TVN_BEGINLABELEDITW = TVN_FIRST - 59,
		TVN_ENDLABELEDITW = TVN_FIRST - 60,
	}
	
	
	enum: DWORD
	{
		TVS_HASBUTTONS = 0x0001,
		TVS_HASLINES = 0x0002,
		TVS_LINESATROOT = 0x0004,
		TVS_EDITLABELS = 0x0008,
		TVS_SHOWSELALWAYS = 0x0020,
		TVS_CHECKBOXES = 0x0100, // IE3+
		TVS_TRACKSELECT = 0x0200, // IE3+
		TVS_FULLROWSELECT = 0x1000, // IE4+
		TVS_NOSCROLL = 0x2000, // IE4+
		TVS_SINGLEEXPAND = 0x0400, // IE4+
	}
	
	
	version(D_Version2)
	{
		/+ // DMD 2.012: Error: cannot implicitly convert expression (cast(HANDLE)cast(проц*)-65536u) of type const(HANDLE) to цел
		const HTREEITEM TVI_ROOT = cast(HTREEITEM)-0x10000;
		const HTREEITEM TVI_FIRST = cast(HTREEITEM)-0x0FFFF;
		const HTREEITEM TVI_LAST = cast(HTREEITEM)-0x0FFFE;
		const HTREEITEM TVI_SORT = cast(HTREEITEM)-0x0FFFD;
		+/
		enum: HTREEITEM
		{
			TVI_ROOT = cast(HTREEITEM)-0x10000,
			TVI_FIRST = cast(HTREEITEM)-0x0FFFF,
			TVI_LAST = cast(HTREEITEM)-0x0FFFE,
			TVI_SORT = cast(HTREEITEM)-0x0FFFD,
		}
	}
	else
	{
		const HTREEITEM TVI_ROOT = cast(HTREEITEM)-0x10000;
		const HTREEITEM TVI_FIRST = cast(HTREEITEM)-0x0FFFF;
		const HTREEITEM TVI_LAST = cast(HTREEITEM)-0x0FFFE;
		const HTREEITEM TVI_SORT = cast(HTREEITEM)-0x0FFFD;
	}
	
	
	enum: UINT
	{
		TVC_UNKNOWN = 0x0000,
		TVC_BYMOUSE = 0x0001,
		TVC_BYKEYBOARD = 0x0002,
	}
	
	
	enum: WPARAM
	{
		TVSIL_NORMAL = 0,
		TVSIL_STATE = 2,
	}
	
	
	enum: UINT
	{
		SB_SETTEXTA = WM_USER + 1,
		SB_SETPARTS = WM_USER + 4,
		SB_SIMPLE = WM_USER + 9,
		SB_SETTEXTW = WM_USER + 11,
	}
	
	
	enum: DWORD
	{
		SBARS_SIZEGRIP = 0x0100,
	}
	
	
	enum: WPARAM
	{
		SBT_NOBORDERS = 0x0100,
		SBT_POPOUT = 0x0200,
		SBT_RTLREADING = 0x0400,
		SBT_OWNERDRAW = 0x1000,
	}
	
	
	enum: LRESULT
	{
		CDRF_DODEFAULT = 0x0,
		CDRF_NEWFONT = 0x2,
		CDRF_NOTIFYITEMDRAW = 0x20,
		CDRF_NOTIFYITEMERASE = 0x80,
	}
	
	
	enum: DWORD
	{
		CDDS_ITEM = 0x00010000,
	}
	
	
	enum: UINT
	{
		CDIS_SELECTED = 0x0001,
	}
	
	
	const LPWSTR LPSTR_TEXTCALLBACKW = cast(LPWSTR)-1L;
	const LPSTR LPSTR_TEXTCALLBACKA = cast(LPSTR)-1L;
	
	
	enum: UINT
	{
		CCM_FIRST = 0x2000,
		CCM_SETVERSION = CCM_FIRST + 0x7,
	}
	
	
	enum: UINT
	{
		LVM_FIRST = 0x1000,
		
		LVM_SETBKCOLOR = LVM_FIRST + 1,
		LVM_SETIMAGELIST = LVM_FIRST + 3,
		LVM_SETITEMA = LVM_FIRST + 6,
		LVM_INSERTITEMA = LVM_FIRST + 7,
		LVM_DELETEITEM = LVM_FIRST + 8,
		LVM_DELETEALLITEMS = LVM_FIRST + 9,
		LVM_SETCALLBACKMASK = LVM_FIRST + 11,
		LVM_GETNEXTITEM = LVM_FIRST + 12,
		LVM_GETITEMRECT = LVM_FIRST + 14,
		LVM_ENSUREVISIBLE = LVM_FIRST + 19,
		LVM_REDRAWITEMS = LVM_FIRST + 21,
		LVM_ARRANGE = LVM_FIRST + 22,
		LVM_EDITLABELA = LVM_FIRST + 23,
		LVM_GETCOLUMNA = LVM_FIRST + 25,
		LVM_SETCOLUMNA = LVM_FIRST + 26,
		LVM_INSERTCOLUMNA = LVM_FIRST + 27,
		LVM_DELETECOLUMN = LVM_FIRST + 28,
		LVM_SETCOLUMNWIDTH = LVM_FIRST + 30,
		LVM_SETTEXTCOLOR = LVM_FIRST + 36,
		LVM_SETTEXTBKCOLOR = LVM_FIRST + 38,
		LVM_SETITEMSTATE = LVM_FIRST + 43,
		LVM_GETITEMSTATE = LVM_FIRST + 44,
		LVM_SETITEMTEXTA = LVM_FIRST + 46,
		LVM_SORTITEMS = LVM_FIRST + 48,
		LVM_SETEXTENDEDLISTVIEWSTYLE = LVM_FIRST + 54,
		LVM_GETEXTENDEDLISTVIEWSTYLE = LVM_FIRST + 55,
		LVM_INSERTITEMW = LVM_FIRST + 77,
		LVM_SETCOLUMNW = LVM_FIRST + 96,
		LVM_INSERTCOLUMNW = LVM_FIRST + 97,
		LVM_SETITEMTEXTW = LVM_FIRST + 116,
		LVM_EDITLABELW = LVM_FIRST + 118,
	}
	
	
	enum: UINT
	{
		LVIS_OVERLAYMASK = 0x0F00,
		LVIS_STATEIMAGEMASK = 0xF000,
	}
	
	
	enum: цел
	{
		LVSCW_AUTOSIZE = -1,
		LVSCW_AUTOSIZE_USEHEADER = -2,
	}
	
	
	enum: UINT
	{
		LVNI_ALL = 0x0000,
		LVNI_FOCUSED = 0x0001,
		LVNI_SELECTED = 0x0002,
		LVNI_CUT = 0x0004,
		LVNI_DROPHILITED = 0x0008,
		
		LVNI_ABOVE = 0x0100,
		LVNI_BELOW = 0x0200,
		LVNI_TOLEFT = 0x0400,
		LVNI_TORIGHT = 0x0800,
	}
	
	
	enum: UINT
	{
		LVN_FIRST = cast(UINT)-100,
		
		LVN_ITEMCHANGING = (LVN_FIRST - 0),
		LVN_ITEMCHANGED = (LVN_FIRST - 1),
		
		LVN_BEGINLABELEDITA = LVN_FIRST - 5,
		LVN_BEGINLABELEDITW = LVN_FIRST - 75,
		
		LVN_ENDLABELEDITA = LVN_FIRST - 6,
		LVN_ENDLABELEDITW = LVN_FIRST - 76,
		
		LVN_COLUMNCLICK = LVN_FIRST - 8,
		
		LVN_GETDISPINFOA = LVN_FIRST - 50,
		LVN_GETDISPINFOW = LVN_FIRST - 77,
	}
	
	
	enum: UINT
	{
		LVCF_FMT = 0x0001,
		LVCF_WIDTH = 0x0002,
		LVCF_TEXT = 0x0004,
		LVCF_SUBITEM = 0x0008,
	}
	
	
	enum: цел
	{
		LVCFMT_LEFT = 0x0000,
		LVCFMT_RIGHT = 0x0001,
		LVCFMT_CENTER = 0x0002,
		LVCFMT_JUSTIFYMASK = 0x0003,
	}
	
	
	enum: UINT
	{
		LVIF_TEXT = 0x0001,
		LVIF_IMAGE = 0x0002,
		LVIF_PARAM = 0x0004,
		LVIF_STATE = 0x0008,
	}
	
	
	enum: UINT
	{
		LVIS_FOCUSED = 0x0001,
		LVIS_SELECTED = 0x0002,
		LVIS_CUT = 0x0004,
		LVIS_DROPHILITED = 0x0008,
	}
	
	
	enum: цел
	{
		LVA_DEFAULT = 0x0000,
		LVA_ALIGNLEFT = 0x0001,
		LVA_ALIGNTOP = 0x0002,
		LVA_SNAPTOGRID = 0x0005,
	}
	
	
	enum: цел
	{
		LVIR_BOUNDS = 0,
		LVIR_ICON = 1,
		LVIR_LABEL = 2,
		LVIR_SELECTBOUNDS = 3,
	}
	
	
	enum: UINT
	{
		LVS_ALIGNTOP = 0x0000,
		LVS_ALIGNLEFT = 0x0800,
		
		LVS_ICON = 0x0000,
		LVS_REPORT = 0x0001,
		LVS_SMALLICON = 0x0002,
		LVS_LIST = 0x0003,
		LVS_SINGLESEL = 0x0004,
		LVS_SHOWSELALWAYS = 0x0008,
		LVS_SORTASCENDING = 0x0010,
		LVS_SORTDESCENDING = 0x0020,
		LVS_SHAREIMAGELISTS = 0x0040,
		LVS_NOLABELWRAP = 0x0080,
		LVS_AUTOARRANGE = 0x0100,
		LVS_EDITLABELS = 0x0200,
		LVS_OWNERDATA = 0x1000,
		LVS_NOSCROLL = 0x2000,
	}
	
	
	enum: DWORD
	{
		LVS_EX_GRIDLINES = 0x00000001,
		LVS_EX_SUBITEMIMAGES = 0x00000002,
		LVS_EX_CHECKBOXES = 0x00000004,
		LVS_EX_TRACKSELECT = 0x00000008,
		LVS_EX_HEADERDRAGDROP = 0x00000010,
		LVS_EX_FULLROWSELECT = 0x00000020,
		LVS_EX_ONECLICKACTIVATE = 0x00000040,
		LVS_EX_TWOCLICKACTIVATE = 0x00000080,
		
		// IE4+
		LVS_EX_FLATSB = 0x00000100,
		LVS_EX_REGIONAL = 0x00000200,
		LVS_EX_INFOTIP = 0x00000400,
		LVS_EX_UNDERLINEHOT = 0x00000800,
		LVS_EX_UNDERLINECOLD = 0x00001000,
		LVS_EX_MULTIWORKAREAS = 0x00002000,
	}
	
	
	enum
	{
		LVSIL_NORMAL = 0,
		LVSIL_SMALL = 1,
		LVSIL_STATE = 2,
	}
	
	
	enum
	{
		I_IMAGECALLBACK = -1,
	}
	
	
	enum: UINT
	{
		TCM_FIRST = 0x1300,
		
		TCM_SETITEMA = TCM_FIRST + 6,
		TCM_INSERTITEMA = TCM_FIRST + 7,
		TCM_DELETEITEM = TCM_FIRST + 8,
		TCM_DELETEALLITEMS = TCM_FIRST + 9,
		TCM_GETITEMRECT = TCM_FIRST + 10,
		TCM_GETCURSEL = TCM_FIRST + 11,
		TCM_SETCURSEL = TCM_FIRST + 12,
		TCM_SETITEMEXTRA = TCM_FIRST + 14,
		TCM_ADJUSTRECT = TCM_FIRST + 40,
		TCM_SETITEMSIZE = TCM_FIRST + 41,
		TCM_SETPADDING = TCM_FIRST + 43,
		TCM_GETROWCOUNT = TCM_FIRST + 44,
		TCM_SETTOOLTIPS = TCM_FIRST + 46,
		TCM_SETITEMW = TCM_FIRST + 61,
		TCM_INSERTITEMW = TCM_FIRST + 62,
	}
	
	
	enum: UINT
	{
		TCIF_TEXT = 0x0001,
		TCIF_IMAGE = 0x0002,
		TCIF_RTLREADING = 0x0004,
		TCIF_PARAM = 0x0008,
	}
	
	
	enum: DWORD
	{
		TCS_FORCEICONLEFT = 0x0010,
		TCS_FORCELABELLEFT = 0x0020,
		TCS_TABS = 0x0000,
		TCS_BUTTONS = 0x0100,
		TCS_SINGLELINE = 0x0000,
		TCS_MULTILINE = 0x0200,
		TCS_RIGHTJUSTIFY = 0x0000,
		TCS_FIXEDWIDTH = 0x0400,
		TCS_RAGGEDRIGHT = 0x0800,
		TCS_FOCUSONBUTTONDOWN = 0x1000,
		TCS_OWNERDRAWFIXED = 0x2000,
		TCS_TOOLTIPS = 0x4000,
		TCS_FOCUSNEVER = 0x8000,
		
		// IE3+
		TCS_SCROLLOPPOSITE = 0x0001,
		TCS_BOTTOM = 0x0002,
		TCS_RIGHT = 0x0002,
		TCS_MULTISELECT = 0x0004,
		TCS_HOTTRACK = 0x0040,
		TCS_VERTICAL = 0x0080,
		
		// IE4+
		TCS_FLATBUTTONS = 0x0008,
	}
	
	
	enum: UINT
	{
		TCN_FIRST = cast(UINT)-550,
		
		TCN_SELCHANGE = TCN_FIRST - 1,
		TCN_SELCHANGING = TCN_FIRST - 2,
	}
	
	
	enum
	{
		HTERROR = -2,
		HTTRANSPARENT = -1,
		HTNOWHERE = 0,
		HTCLIENT = 1,
		HTCAPTION = 2,
		HTSYSMENU = 3,
		HTGROWBOX = 4,
		HTMENU = 5,
		HTHSCROLL = 6,
		HTVSCROLL = 7,
		HTMINBUTTON = 8,
		HTMAXBUTTON = 9,
		HTLEFT = 10,
		HTRIGHT = 11,
		HTTOP = 12,
		HTTOPLEFT = 13,
		HTTOPRIGHT = 14,
		HTBOTTOM = 15,
		HTBOTTOMLEFT = 16,
		HTBOTTOMRIGHT = 17,
		HTBORDER = 18,
		HTOBJECT = 19,
		HTCLOSE = 20,
		HTHELP = 21,
		HTSIZE = HTGROWBOX,
		HTREDUCE = HTMINBUTTON,
		HTZOOM = HTMAXBUTTON,
		HTSIZEFIRST = HTLEFT,
		HTSIZELAST = HTBOTTOMRIGHT,
	}
	
	
	enum
	{
		WVR_VALIDRECTS = 0x0400,
	}
	
	
	enum: UINT
	{
		NIF_MESSAGE = 0x00000001,
		NIF_ICON = 0x00000002,
		NIF_TIP = 0x00000004,
	}
	
	
	enum: DWORD
	{
		NIM_ADD = 0x00000000,
		NIM_MODIFY = 0x00000001,
		NIM_DELETE = 0x00000002,
	}
	
	
	enum: DWORD
	{
		VER_PLATFORM_WIN32s = 0,
		VER_PLATFORM_WIN32_WINDOWS = 1,
		VER_PLATFORM_WIN32_NT = 2,
	}
	
	
	enum: UINT
	{
		SIF_RANGE = 0x0001,
		SIF_PAGE = 0x0002,
		SIF_POS = 0x0004,
		SIF_DISABLENOSCROLL = 0x0008,
		SIF_ALL = 23,
	}
	
	
	enum: UINT
	{
		DFC_SCROLL = 3,
	}
	
	
	enum: UINT
	{
		DFCS_SCROLLSIZEGRIP = 0x0008,
	}
	
	
	enum: UINT
	{
		LR_LOADFROMFILE = 0x0010,
		LR_DEFAULTSIZE = 0x0040,
		LR_COPYFROMRESOURCE = 0x4000,
		LR_SHARED = 0x8000,
	}
	
	
	enum: COLORREF
	{
		CLR_INVALID = 0xFFFFFFFF,
		CLR_NONE = CLR_INVALID,
	}
	
	
	enum: UINT
	{
		DT_TOP = 0x00000000,
		DT_LEFT = 0x00000000,
		DT_CENTER = 0x00000001,
		DT_RIGHT = 0x00000002,
		DT_VCENTER = 0x00000004,
		DT_BOTTOM = 0x00000008,
		DT_WORDBREAK = 0x00000010,
		DT_SINGLELINE = 0x00000020,
		DT_EXPANDTABS = 0x00000040,
		DT_TABSTOP = 0x00000080,
		DT_NOCLIP = 0x00000100,
		DT_EXTERNALLEADING = 0x00000200,
		DT_CALCRECT = 0x00000400,
		DT_NOPREFIX = 0x00000800,
		DT_INTERNAL = 0x00001000,
		DT_EDITCONTROL = 0x00002000,
		DT_PATH_ELLIPSIS = 0x00004000,
		DT_END_ELLIPSIS = 0x00008000,
		DT_MODIFYSTRING = 0x00010000,
		DT_RTLREADING = 0x00020000,
		DT_WORD_ELLIPSIS = 0x00040000,
	}
	
	
	enum: UINT
	{
		CF_TEXT = 1,
		CF_BITMAP = 2,
		CF_METAFILEPICT = 3,
		CF_SYLK = 4,
		CF_DIF = 5,
		CF_TIFF = 6,
		CF_OEMTEXT = 7,
		CF_DIB = 8,
		CF_PALETTE = 9,
		CF_PENDATA = 10,
		CF_RIFF = 11,
		CF_WAVE = 12,
		CF_UNICODETEXT = 13,
		CF_ENHMETAFILE = 14,
		CF_HDROP = 15,
		CF_LOCALE = 16,
	}
	
	
	enum: UINT
	{
		BIF_RETURNONLYFSDIRS = 0x0001,
		BIF_NEWDIALOGSTYLE = 0x0040,
		BIF_NONEWFOLDERBUTTON = 0x0200, // shell32.dll 6.0+
	}
	
	
	enum
	{
		TRANSPARENT = 1,
		OPAQUE = 2,
	}
	
	
	enum: UINT
	{
		ETO_OPAQUE = 0x0002,
		ETO_CLIPPED = 0x0004,
	}
	

	enum: UINT
	{
		IMAGE_BITMAP = 0,
		IMAGE_ICON = 1,
		IMAGE_CURSOR = 2,
	}
	
	
	const LPCSTR IDI_HAND = cast(LPCSTR)32513;
	const LPCSTR IDI_QUESTION = cast(LPCSTR)32514;
	const LPCSTR IDI_EXCLAMATION = cast(LPCSTR)32515;
	const LPCSTR IDI_ASTERISK = cast(LPCSTR)32516;
	const LPCSTR IDI_INFORMATION = IDI_ASTERISK;
	

	//private import os.win.base.native: RT_STRING;// 

	
	enum: LONG
	{
		HS_HORIZONTAL = 0,
		HS_VERTICAL = 1,
		HS_FDIAGONAL = 2,
		HS_BDIAGONAL = 3,
		HS_CROSS = 4,
		HS_DIAGCROSS = 5,
	}
	
	
	enum: DWORD
	{
		LOAD_LIBRARY_AS_DATAFILE = 0x00000002,
	}
	
	
	enum: UINT
	{
		PBM_SETRANGE = WM_USER + 1,
		PBM_SETPOS = WM_USER + 2,
		PBM_DELTAPOS = WM_USER + 3,
		PBM_SETSTEP = WM_USER + 4,
		PBM_STEPIT = WM_USER + 5,
	}
	
	
	const DWORD MAX_COMPUTERNAME_LENGTH = 15;
	
	const DWORD LF_FACESIZE = 32;
	
	
	typedef HANDLE HIMAGELIST;
	
	
	enum: UINT
	{
		ILD_NORMAL = 0,
	}
	
	
	enum: UINT
	{
		//ILC_COLOR = ,
		ILC_COLOR4 = 0x0004,
		ILC_COLOR8 = 0x0008,
		ILC_COLOR16 = 0x0010,
		ILC_COLOR24 = 0x0018,
		ILC_COLOR32 = 0x0020,
		
		ILC_MASK = 0x0001,
	}
	
	
	// Rich edit.
	alias DWORD function(/+ DWORD_PTR +/ DWORD dwCookie, LPBYTE pbBuff, LONG cb, LONG* pcb) EDITSTREAMCALLBACK;
	
	
	alias DWORD LCID;
	
	
	struct WINDOWPOS
	{
		HWND hwnd;
		HWND hwndInsertAfter;
		цел  x;
		цел  y;
		цел  cx;
		цел  cy;
		UINT флаги;                
	}
	alias WINDOWPOS* LPWINDOWPOS;
	alias WINDOWPOS* PWINDOWPOS;
	
	
	struct WNDCLASSW
	{
		UINT стиль;
		WNDPROC lpfnWndProc;
		цел cbClsExtra;
		цел cbWndExtra;
		HANDLE hInstance;
		HICON hIcon;
		HCURSOR hCursor;
		HBRUSH hbrBackground;
		LPCWSTR lpszMenuName;
		LPCWSTR lpszClassName;
	}
	alias WNDCLASSW* LPWNDCLASSW;
	
	
	struct OSVERSIONINFOA
	{
		DWORD dwOSVersionInfoSize;
		DWORD dwMajorVersion;
		DWORD dwMinorVersion;
		DWORD dwBuildNumber;
		DWORD dwPlatformId;
		CHAR[128] szCSDVersion;
	}
	alias OSVERSIONINFOA* LPOSVERSIONINFOA;
	
	
	const HWND HWND_MESSAGE = cast(HWND)-3; // Win2000/XP only.
	
	
	struct NOTIFYICONDATA
	{
		 DWORD cbSize; 
		 HWND hWnd; 
		 UINT uID; 
		 UINT uFlags; 
		 UINT uCallbackMessage; 
		 HICON hIcon; 
		 char[64] szTip; 
	}
	alias NOTIFYICONDATA* PNOTIFYICONDATA;
	
	
	// Unaligned!
	struct SHITEMID
	{
		align(1):
		USHORT cb; // Размер including cb.
		BYTE[1] abID;
	}
	alias SHITEMID* PSHITEMID;
	alias SHITEMID* LPSHITEMID;
	alias SHITEMID* LPCSHITEMID;
	
	
	struct ITEMIDLIST
	{
		SHITEMID mkid;
	}
	alias ITEMIDLIST* PITEMIDLIST;
	alias ITEMIDLIST* LPITEMIDLIST;
	alias ITEMIDLIST* LPCITEMIDLIST;
	
	
	alias цел function(HWND hwnd, UINT uMsg, LPARAM lParam, LPARAM lpData) BFFCALLBACK;
	
	
	struct BROWSEINFOA
	{
		HWND hwndOwner;
		LPCITEMIDLIST pidlRoot;
		LPSTR pszDisplayName;
		LPCSTR lpszTitle;
		UINT ulFlags;
		BFFCALLBACK lpfn;
		LPARAM lParam;
		цел iImage;
	}
	alias BROWSEINFOA* PBROWSEINFOA;
	alias BROWSEINFOA* LPBROWSEINFOA;
	
	
	struct BROWSEINFOW
	{
		HWND hwndOwner;
		LPCITEMIDLIST pidlRoot;
		LPWSTR pszDisplayName;
		LPCWSTR lpszTitle;
		UINT ulFlags;
		BFFCALLBACK lpfn;
		LPARAM lParam;
		цел iImage;
	}
	alias BROWSEINFOW* PBROWSEINFOW;
	alias BROWSEINFOW* LPBROWSEINFOW;
	
	
	struct LOGBRUSH
	{
		UINT lbStyle;
		COLORREF lbColor;
		LONG lbHatch;
	}
	alias LOGBRUSH* LPLOGBRUSH;
	
	
	struct DRAWTEXTPARAMS
	{ 
		UINT cbSize; 
		цел iTabLength; 
		цел iLeftMargin; 
		цел iRightMargin; 
		UINT uiLengthDrawn; 
	}
	alias DRAWTEXTPARAMS* LPDRAWTEXTPARAMS;
	
	
	struct NMHDR
	{ 
		HWND hwndFrom;
		UINT idFrom;
		UINT code;
	}
	alias NMHDR* LPNMHDR;
	
	
	struct NMCUSTOMDRAW
	{
		NMHDR hdr;
		DWORD dwDrawStage;
		HDC hdc;
		RECT rc;
		/+ DWORD_PTR +/ DWORD dwItemSpec;
		UINT uItemState;
		LPARAM lItemlParam;
	}
	alias NMCUSTOMDRAW* LPNMCUSTOMDRAW;
	
	
	struct NMTVCUSTOMDRAW
	{
		NMCUSTOMDRAW nmcd;
		COLORREF clrText;
		COLORREF clrTextBk;
		цел iLevel; // IE4+
	}
	alias NMTVCUSTOMDRAW* LPNMTVCUSTOMDRAW;
	
	
	struct NM_LISTVIEW
	{
		NMHDR hdr;
		цел iItem;
		цел iSubItem;
		UINT uNewState;
		UINT uOldState;
		UINT uChanged;
		POINT ptAction;
		LPARAM lParam;
	}
	
	
	struct LVITEMA
	{
		UINT mask;
		цел iItem;
		цел iSubItem;
		UINT state;
		UINT stateMask;
		LPSTR pszText;
		цел cchTextMax;
		цел iImage;
		LPARAM lParam;
	}
	alias LVITEMA* LPLVITEMA;
	alias LVITEMA* PLVITEMA;
	alias LVITEMA LV_ITEMA;
	alias LVITEMA* LPLV_ITEMA;
	alias LVITEMA* PLV_ITEMA;
	
	
	struct LVITEMW
	{
		UINT mask;
		цел iItem;
		цел iSubItem;
		UINT state;
		UINT stateMask;
		LPWSTR pszText;
		цел cchTextMax;
		цел iImage;
		LPARAM lParam;
	}
	alias LVITEMW* LPLVITEMW;
	alias LVITEMW* PLVITEMW;
	alias LVITEMW LV_ITEMW;
	alias LVITEMW* LPLV_ITEMW;
	alias LVITEMW* PLV_ITEMW;
	
	
	struct LVDISPINFOA
	{
		NMHDR hdr;
		LVITEMA item;
	}
	alias LVDISPINFOA* LPLVDISPINFOA;
	alias LVDISPINFOA* PLVDISPINFOA;
	alias LVDISPINFOA LV_DISPINFOA;
	alias LVDISPINFOA* LPLV_DISPINFOA;
	alias LVDISPINFOA* PLV_DISPINFOA;
	
	
	struct LVDISPINFOW
	{
		NMHDR hdr;
		LVITEMW item;
	}
	alias LVDISPINFOW* LPLVDISPINFOW;
	alias LVDISPINFOW* PLVDISPINFOW;
	alias LVDISPINFOW LV_DISPINFOW;
	alias LVDISPINFOW* LPLV_DISPINFOW;
	alias LVDISPINFOW* PLV_DISPINFOW;
	
	
	struct LVCOLUMNA
	{
		UINT mask;
		цел fmt;
		цел cx;
		LPSTR pszText;
		цел cchTextMax;
		цел iSubItem;
	}
	alias LVCOLUMNA* LPLVCOLUMNA;
	alias LVCOLUMNA* PLVCOLUMNA;
	alias LVCOLUMNA LV_COLUMNA;
	alias LVCOLUMNA* LPLV_COLUMNA;
	alias LVCOLUMNA* PLV_COLUMNA;
	
	
	struct LVCOLUMNW
	{
		UINT mask;
		цел fmt;
		цел cx;
		LPWSTR pszText;
		цел cchTextMax;
		цел iSubItem;
	}
	alias LVCOLUMNW* LPLVCOLUMNW;
	alias LVCOLUMNW* PLVCOLUMNW;
	alias LVCOLUMNW LV_COLUMNW;
	alias LVCOLUMNW* LPLV_COLUMNW;
	alias LVCOLUMNW* PLV_COLUMNW;
	
	
	struct TBBUTTON
	{
		цел iBitmap;
		цел idCommand;
		BYTE fsState;
		BYTE fsStyle;
		BYTE[2] bReserved;
		DWORD dwData;
		цел iString;
	}
	alias TBBUTTON* PTBBUTTON, LPTBBUTTON, LPCTBBUTTON;
	
	
	struct NMTOOLBARA
	{
		NMHDR hdr;
		цел iItem;
		TBBUTTON tbButton;
		цел cchText;
		LPSTR pszText;
		RECT rcButton;
	}
	alias NMTOOLBARA* LPNMTOOLBARA;
	
	
	struct NMTOOLBARW
	{
		NMHDR hdr;
		цел iItem;
		TBBUTTON tbButton;
		цел cchText;
		LPWSTR pszText;
		RECT rcButton;
	}
	alias NMTOOLBARW* LPNMTOOLBARW;
	
	
	enum: BYTE
	{
		TBSTYLE_BUTTON = 0x00,
		TBSTYLE_SEP = 0x01,
		TBSTYLE_CHECK = 0x02,
		TBSTYLE_GROUP = 0x04,
		TBSTYLE_DROPDOWN = 0x08,
		TBSTYLE_AUTOSIZE = 0x10,
		
		/+
		// The following are too big for TBBUTTON.fsStyle
		TBSTYLE_TOOLTIPS = 0x0100,
		TBSTYLE_WRAPABLE = 0x0200,
		TBSTYLE_ALTDRAG = 0x0400,
		+/
	}
	
	
	enum: BYTE
	{
		//BTNS_AUTOSIZE = TBSTYLE_AUTOSIZE,
		
		BTNS_WHOLEDROPDOWN = 0x80,
	}
	
	
	enum: BYTE
	{
		TBSTATE_CHECKED = 0x01,
		TBSTATE_PRESSED = 0x02,
		TBSTATE_ENABLED = 0x04,
		TBSTATE_HIDDEN = 0x08,
		TBSTATE_INDETERMINATE = 0x10,
		TBSTATE_WRAP = 0x20,
		TBSTATE_ELLIPSES = 0x40,
		TBSTATE_MARKED = 0x80,
	}
	
	
	/*enum: LRESULT
	{
		TBDDRET_DEFAULT = 0,
		TBDDRET_NODEFAULT = 1,
		TBDDRET_TREATPRESSED = 2,
	}*/
	
	
	enum: UINT
	{
		TB_SETSTATE = WM_USER + 17,
		TB_ADDBUTTONSA = WM_USER + 20,
		TB_INSERTBUTTONA = WM_USER + 21,
		TB_DELETEBUTTON = WM_USER + 22,
		TB_GETITEMRECT = WM_USER + 29,
		TB_BUTTONSTRUCTSIZE = WM_USER + 30,
		TB_SETBUTTONSIZE = WM_USER + 31,
		TB_AUTOSIZE = WM_USER + 33,
		TB_SETIMAGELIST = WM_USER + 48,
		TB_INSERTBUTTONW = WM_USER + 67,
		TB_ADDBUTTONSW = WM_USER + 68,
		TB_SETPADDING = WM_USER + 87,
	}
	
	
	enum: UINT
	{
		TBN_FIRST = cast(UINT)-700,
		TBN_DROPDOWN = TBN_FIRST - 10,
	}
	
	
	struct TVITEMA
	{
		UINT mask;
		HTREEITEM hItem;
		UINT state;
		UINT stateMask;
		LPSTR pszText;
		цел cchTextMax;
		цел iImage;
		цел iSelectedImage;
		цел cChildren;
		LPARAM lParam;
	}
	alias TVITEMA* LPTVITEMA;
	alias TVITEMA* PTVITEMA;
	alias TVITEMA TV_ITEMA;
	alias TVITEMA* LPTV_ITEMA;
	alias TVITEMA* PTV_ITEMA;
	
	
	struct TVITEMW
	{
		UINT mask;
		HTREEITEM hItem;
		UINT state;
		UINT stateMask;
		LPWSTR pszText;
		цел cchTextMax;
		цел iImage;
		цел iSelectedImage;
		цел cChildren;
		LPARAM lParam;
	}
	alias TVITEMW* LPTVITEMW;
	alias TVITEMW* PTVITEMW;
	alias TVITEMW TV_ITEMW;
	alias TVITEMW* LPTV_ITEMW;
	alias TVITEMW* PTV_ITEMW;
	
	
	struct TVHITTESTINFO
	{
		POINT pt;
		UINT флаги;
		HTREEITEM hItem;
	}
	alias TVHITTESTINFO* LPTVHITTESTINFO;
	
	
	struct TVINSERTSTRUCTA
	{
		HTREEITEM hParent;
		HTREEITEM hInsertAfter;
		TV_ITEMA item;
	}
	alias TVINSERTSTRUCTA* LPTVINSERTSTRUCTA;
	alias TVINSERTSTRUCTA TV_INSERTSTRUCTA;
	alias TVINSERTSTRUCTA* LPTV_INSERTSTRUCTA;
	
	
	struct NMTREEVIEWA
	{
		NMHDR hdr;
		UINT действие;
		TVITEMA itemOld;
		TVITEMA itemNew;
		POINT ptDrag;
	}
	alias NMTREEVIEWA* LPNMTREEVIEWA;
	alias NMTREEVIEWA NM_TREEVIEW;
	alias NMTREEVIEWA* LPNM_TREEVIEW;
	
	
	struct NMTVDISPINFOA
	{
		NMHDR hdr;
		TVITEMA item;
	}
	alias NMTVDISPINFOA* LPNMTVDISPINFOA;
	alias NMTVDISPINFOA TV_DISPINFOA;
	alias NMTVDISPINFOA* LPTV_DISPINFOA;
	
	
	struct NMTVDISPINFOW
	{
		NMHDR hdr;
		TVITEMW item;
	}
	alias NMTVDISPINFOW* LPNMTVDISPINFOW;
	alias NMTVDISPINFOW TV_DISPINFOW;
	alias NMTVDISPINFOW* LPTV_DISPINFOW;
	
	
	struct TCITEMA
	{
		UINT mask;
		UINT lpReserved1;
		UINT lpReserved2;
		LPSTR pszText;
		цел cchTextMax;
		цел iImage;
		LPARAM lParam;
	}
	alias TCITEMA* LPTCITEMA;
	alias TCITEMA TC_ITEMA;
	alias TCITEMA* LPTC_ITEMA;
	
	
	struct TCITEMW
	{
		UINT mask;
		UINT lpReserved1;
		UINT lpReserved2;
		LPWSTR pszText;
		цел cchTextMax;
		цел iImage;
		LPARAM lParam;
	}
	alias TCITEMW* LPTCITEMW;
	alias TCITEMW TC_ITEMW;
	alias TCITEMW* LPTC_ITEMW;
	
	
	// Rich edit.
	struct CHARRANGE
	{
		LONG cpMin; 
		LONG cpMax; 
	}
	
	
	// Rich edit.
	struct EDITSTREAM
	{
		/+ DWORD_PTR +/ DWORD dwCookie;
		DWORD dwError;
		EDITSTREAMCALLBACK pfnCallback;
	}
	
	
	// Rich edit.
	struct CHARFORMAT2A
	{
		UINT cbSize;
		DWORD dwMask;
		DWORD dwEffects;
		LONG yHeight;
		LONG yOffset;
		COLORREF crTextColor;
		BYTE bCharSet;
		BYTE bPitchAndFamily;
		char[LF_FACESIZE] szFaceName;
		WORD wWeight;
		SHORT sSpacing;
		COLORREF crBackColor;
		LCID lcid;
		DWORD dwReserved;
		SHORT sStyle;
		WORD wKerning;
		BYTE bUnderlineType;
		BYTE bAnimation;
		BYTE bRevAuthor;
		BYTE bReserved1;
	}
	static assert(CHARFORMAT2A.sizeof == 84);
	
	
	// Rich edit.
	struct ENLINK
	{
		NMHDR nmhdr;
		UINT сооб;
		WPARAM wParam;
		LPARAM lParam;
		CHARRANGE chrg;
	}
	
	
	struct TEXTRANGEA
	{
		CHARRANGE chrg;
		LPSTR lpstrText;
	}
	
	
	struct MENUITEMINFOA
	{
		UINT cbSize;
		UINT fMask;
		UINT fType;
		UINT fState;
		UINT wID;
		HMENU hSubMenu;
		HBITMAP hbmpChecked;
		HBITMAP hbmpUnchecked;
		DWORD dwItemData;
		LPSTR dwTypeData;
		UINT cch;
		//HBITMAP hbmpItem;
	}
	alias MENUITEMINFOA* LPMENUITEMINFOA;
	
	
	struct MENUITEMINFOW
	{
		UINT cbSize;
		UINT fMask;
		UINT fType;
		UINT fState;
		UINT wID;
		HMENU hSubMenu;
		HBITMAP hbmpChecked;
		HBITMAP hbmpUnchecked;
		DWORD dwItemData;
		LPWSTR dwTypeData;
		UINT cch;
		//HBITMAP hbmpItem;
	}
	alias MENUITEMINFOW* LPMENUITEMINFOW;
	
	
	struct SCROLLINFO
	{
		UINT cbSize;
		UINT fMask;
		цел nMin;
		цел nMax;
		UINT nPage;
		цел nPos;
		цел nTrackPos;
	}
	alias SCROLLINFO* LPSCROLLINFO;
	
	
	alias UINT function(HWND hdlg, UINT uiMsg, WPARAM wParam, LPARAM lParam) LPCCHOOKPROC;
	
	
	alias UINT function(HWND hdlg, UINT uiMsg, WPARAM wParam, LPARAM lParam) LPCFHOOKPROC;
	
	
	alias BOOL function(HDC hdc, LPARAM lpData, цел cchData) GRAYSTRINGPROC;
	
	
	enum: DWORD
	{
		CC_RGBINIT = 0x00000001,
		CC_FULLOPEN = 0x00000002,
		CC_PREVENTFULLOPEN = 0x00000004,
		CC_SHOWHELP = 0x00000008,
		CC_ENABLEHOOK = 0x00000010,
		CC_ENABLETEMPLATE = 0x00000020,
		CC_ENABLETEMPLATEHANDLE = 0x00000040,
		CC_SOLIDCOLOR = 0x00000080,
		CC_ANYCOLOR = 0x00000100,
	}
	
	
	struct CHOOSECOLORA
	{
		DWORD lStructSize; 
		HWND hwndOwner; 
		HWND hInstance; 
		COLORREF rgbResult; 
		COLORREF* lpCustColors; 
		DWORD Flags; 
		LPARAM lCustData; 
		LPCCHOOKPROC lpfnHook; 
		LPCSTR lpTemplateName; 
	}
	alias CHOOSECOLORA* PCHOOSECOLORA;
	alias CHOOSECOLORA* LPCHOOSECOLORA;
	
	
	struct LOGFONTW
	{
		LONG lfHeight;
		LONG lfWidth;
		LONG lfEscapement;
		LONG lfOrientation;
		LONG lfWeight;
		BYTE lfItalic;
		BYTE lfUnderline;
		BYTE lfStrikeOut;
		BYTE lfCharSet;
		BYTE lfOutPrecision;
		BYTE lfClipPrecision;
		BYTE lfQuality;
		BYTE lfPitchAndFamily;
		WCHAR[32] lfFaceName;
	}
	alias LOGFONTW* PLOGFONTW;
	alias LOGFONTW* LPLOGFONTW;
	
	
	struct NONCLIENTMETRICSA
	{
		UINT cbSize;
		цел iBorderWidth;
		цел iScrollWidth;
		цел iScrollHeight;
		цел iCaptionWidth;
		цел iCaptionHeight;
		LOGFONTA lfCaptionFont;
		цел iSmCaptionWidth;
		цел iSmCaptionHeight;
		LOGFONTA lfSmCaptionFont;
		цел iMenuWidth;
		цел iMenuHeight;
		LOGFONTA lfMenuFont;
		LOGFONTA lfStatusFont;
		LOGFONTA lfMessageFont;
	}
	alias NONCLIENTMETRICSA LPNONCLIENTMETRICSA;
	
	
	struct CHOOSEFONTW
	{
		align(1):
		DWORD lStructSize;
		HWND hwndOwner;
		HDC hDC;
		LPLOGFONTW lpLogFont;
		INT iPointSize;
		DWORD Flags;
		DWORD rgbColors;
		LPARAM lCustData;
		LPCFHOOKPROC lpfnHook;
		LPCWSTR lpTemplateName;
		экз hInstance;
		LPWSTR lpszStyle;
		WORD nFontType;
		WORD ___MISSING_ALIGNMENT__;
		INT nSizeMin;
		INT nSizeMax;
	}
	alias CHOOSEFONTW* PCHOOSEFONTW;
	alias CHOOSEFONTW* LPCHOOSEFONTW;
	
	
	struct CHOOSEFONTA
	{
		align(1):
		DWORD lStructSize;
		HWND hwndOwner;
		HDC hDC;
		LPLOGFONTA lpLogFont;
		INT iPointSize;
		DWORD Flags;
		DWORD rgbColors;
		LPARAM lCustData;
		LPCFHOOKPROC lpfnHook;
		LPCSTR lpTemplateName;
		экз hInstance;
		LPSTR lpszStyle;
		WORD nFontType;
		WORD ___MISSING_ALIGNMENT__;
		INT nSizeMin;
		INT nSizeMax;
	}
	alias CHOOSEFONTA* PCHOOSEFONTA;
	alias CHOOSEFONTA* LPCHOOSEFONTA;
	
	
	struct ICONINFO
	{
		BOOL fIcon;
		DWORD xHotspot;
		DWORD yHotspot;
		HBITMAP hbmMask;
		HBITMAP hbmColor;
	}
	alias ICONINFO* LPICONINFO;
	alias ICONINFO* PICONINFO;
	
	
	struct MINMAXINFO
	{
		POINT ptReserved;
		POINT ptMaxSize;
		POINT ptMaxPosition;
		POINT ptMinTrackSize;
		POINT ptMaxTrackSize;
	}
	alias MINMAXINFO* LPMINMAXINFO;
	alias MINMAXINFO* PMINMAXINFO;
	
	
	struct NCCALCSIZE_PARAMS
	{
		RECT[3] rgrc; 
		PWINDOWPOS lppos; 
	}
	alias NCCALCSIZE_PARAMS* LPNCCALCSIZE_PARAMS;
	
	
	struct CREATESTRUCTA
	{
		LPVOID lpCreateParams;
		экз hInstance;
		HMENU hMenu;
		HWND hwndParent;
		цел cy;
		цел cx;
		цел y;
		цел x;
		LONG стиль;
		LPCSTR lpszName;
		LPCSTR lpszClass;
		DWORD dwExStyle;
	}
	alias CREATESTRUCTA* LPCREATESTRUCTA;
	
	
	struct ACTCTXW
	{
		ULONG cbSize;
		DWORD dwFlags;
		LPCWSTR lpSource;
		USHORT wProcessorArchitecture;
		LANGID wLangId;
		LPCWSTR lpAssemblyDirectory;
		LPCWSTR lpResourceName;
		LPCWSTR lpApplicationName;
		HMODULE hModule;
	}
	alias ACTCTXW* PACTCTXW;
	alias ACTCTXW* LPACTCTXW;
	
	
	struct HELPINFO
	{
		UINT cbSize;
		цел iConтекстType;
		цел iCtrlId;
		HANDLE hItemHandle;
		DWORD dwConтекстId;
		POINT MousePos;
	}
	alias HELPINFO* LPHELPINFO;
	
	
	struct TOOLINFOA
	{
		UINT cbSize;
		UINT uFlags;
		HWND hwnd;
		UINT uId;
		RECT rect;
		экз hinst;
		LPSTR lpszText;
	}
	alias TOOLINFOA* PTOOLINFOA;
	alias TOOLINFOA* LPTOOLINFOA;
	
	
	struct STYLESTRUCT
	{
		DWORD styleOld;
		DWORD styleNew;
	}
	alias STYLESTRUCT* LPSTYLESTRUCT;
	
	
	extern(C) DWORD MAKELONG(WORD wLow, WORD wHigh)
	{
		return wLow | (wHigh << 16);
	}
	
	alias MAKELONG MAKELPARAM;
	alias MAKELONG MAKEWPARAM;
	alias MAKELONG MAKELRESULT;
	
	
	const цел DLGWINDOWEXTRA = 30;
	
	
	extern(C) COLORREF RGB(цел r, цел g , цел b)
	{
		return cast(COLORREF)(cast(BYTE)r |
			cast(WORD)(cast(BYTE)g << 8) |
			cast(DWORD)(cast(BYTE)b << 16));
	}
	
	
	struct DRAWITEMSTRUCT
	{
		UINT CtlType;
		UINT CtlID;
		UINT itemID;
		UINT itemAction;
		UINT itemState;
		HWND hwndItem;
		HDC hDC;
		RECT rcItem;
		DWORD itemData;
	}
	alias DRAWITEMSTRUCT* LPDRAWITEMSTRUCT;
	
	
	struct MEASUREITEMSTRUCT
	{
		UINT CtlType;
		UINT CtlID;
		UINT itemID;
		UINT itemWidth;
		UINT высотаПункта;
		DWORD itemData;
	}
	alias MEASUREITEMSTRUCT* LPMEASUREITEMSTRUCT;
	
	
	struct ANIMATIONINFO
	{
		UINT cbSize;
		цел iMinAnimate;
	}
	
	
	struct APPBARDATA
	{
		DWORD cbSize;
		HWND hWnd;
		UINT uCallbackMessage;
		UINT uEdge;
		RECT rc;
		LPARAM lParam; // message specific
	}
	alias APPBARDATA* PAPPBARDATA;
	
	
	struct CLIENTCREATESTRUCT
	{
		HANDLE hWindowMenu;
		UINT idFirstChild;
	}
	alias CLIENTCREATESTRUCT* LPCLIENTCREATESTRUCT;
	
	
	struct MDICREATESTRUCTA
	{
		LPCSTR szClass;
		LPCSTR szTitle;
		HANDLE hOwner;
		цел x;
		цел y;
		цел cx;
		цел cy;
		DWORD стиль;
		LPARAM lParam;
	}
	alias MDICREATESTRUCTA* LPMDICREATESTRUCTA;
	
	
	struct DROPFILES
	{
		DWORD pFiles;
		POINT pt;
		BOOL fNC;
		BOOL fWide;
	}
	alias DROPFILES* LPDROPFILES;
	
	
	alias HANDLE HHOOK;
	alias HANDLE HTHEME;
	alias HANDLE HTREEITEM;
	alias HANDLE HDROP;
	
	
	HCURSOR CopyCursor(HCURSOR pcur)
	{
		return cast(HCURSOR)CopyIcon(cast(HICON)pcur);
	}
	
	
	BOOL DrawIconEx(HDC hdc, цел xLeft, цел yTop, HICON hIcon, цел cxWidth, цел cyWidth, UINT istepIfAniCur, HBRUSH hbrFlickerFreeDraw, UINT diFlags);
	BOOL DrawIcon(HDC hDC, цел X, цел Y, HICON hIcon);
	BOOL SetWindowPos(HWND hWnd, HWND hWndInsertAfter, цел X, цел Y, цел cx, цел cy, UINT uFlags);
	HWND GetCapture();
	HWND SetCapture(HWND hWnd);
	BOOL ReleaseCapture();
	HMENU GetMenu(HWND hWnd);
	BOOL IsChild(HWND hWndParent, HWND hWnd);
	BOOL IsWindow(HWND hWnd);
	HWND CreateWindowExW(DWORD dwExStyle, LPCWSTR lpClassName, LPCWSTR lpWindowName, DWORD dwStyle, цел x, цел y, цел nWidth, цел nHeight, HWND hWndParent, HMENU hMenu, экз hInstance, LPVOID lpParam);
	LRESULT SendMessageW(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
	DWORD SetClassLongA(HWND hWnd, цел nIndex, LONG dwNewLong);
	DWORD GetClassLongA(HWND hWnd, цел nIndex);
	LONG SetWindowLongA(HWND hWnd, цел nIndex, LONG dwNewLong);
	LONG GetWindowLongA(HWND hWnd, цел nIndex);
	DWORD GetSysColor(цел nIndex);
	BOOL EnableWindow(HWND hWnd, BOOL bEnable);
	BOOL IsWindowEnabled(HWND hWnd);
	COLORREF GetTextColor(HDC hdc);
	//COLORREF SetTextColor(HDC hdc, COLORREF crColor);
	HWND GetWindow(HWND hWnd, UINT uCmd);
	DWORD GetWindowThreadProcessId(HWND hWnd, LPDWORD lpdwProcessId);
	SHORT GetKeyState(цел nVirtKey);
	SHORT GetAsyncKeyState(цел vKey);
	HWND SetParent(HWND hWndChild, HWND hWndNewParent);
	цел CombineRgn(HRGN hrgnDest, HRGN hrgnSrc1, HRGN hrgnSrc2, цел fnCombineMode);
	BOOL EnumWindows(WNDENUMPROC lpEnumFunc, LPARAM lParam);
	BOOL EnumChildWindows(HWND hWndParent, WNDENUMPROC lpEnumFunc, LPARAM lParam);
	BOOL SetWindowTextA(HWND hWnd, LPCSTR lpString);
	BOOL SetWindowTextW(HWND hWnd, LPCWSTR lpString);
	цел GetWindowTextLengthA(HWND hWnd);
	цел GetWindowTextLengthW(HWND hWnd);
	цел GetWindowTextA(HWND hWnd, LPSTR lpString, цел nMaxCount);
	цел GetWindowTextW(HWND hWnd, LPWSTR lpString, цел nMaxCount);
	BOOL IsWindowVisible(HWND hWnd);
	BOOL WaitMessage();
	BOOL BringWindowToTop(HWND hWnd);
	UINT RegisterWindowMessageA(LPCSTR lpString);
	HWND GetParent(HWND hWnd);
	HWND GetDesktopWindow();
	HWND GetNextDlgTabItem(HWND hDlg, HWND hCtl, BOOL bPrevious);
	HBRUSH CreateSolidBrush(COLORREF crColor);
	HBRUSH CreateHatchBrush(цел fnStyle, COLORREF clrref);
	проц InitCommonControls();
	BOOL DestroyWindow(HWND hwnd);
	ATOM RegisterClassExA(WNDCLASSEXA* lpwcx);
	ATOM RegisterClassW(WNDCLASSW* lpWndClass);
	HWND GetActiveWindow();
	LRESULT DefDlgProcA(HWND hDlg, UINT Msg, WPARAM wParam, LPARAM lParam);
	LRESULT DefDlgProcW(HWND hDlg, UINT Msg, WPARAM wParam, LPARAM lParam);
	BOOL IsDialogMessageA(HWND hDlg, LPMSG lpMsg);
	BOOL IsDialogMessageW(HWND hDlg, LPMSG lpMsg);
	HBRUSH GetSysColorBrush(цел nIndex);
	BOOL PostMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
	UINT SetТаймер(HWND hWnd, UINT nIDEvent, UINT uElapse, TIMERPROC lpТаймерFunc);
	BOOL KillТаймер(HWND hWnd, UINT uIDEvent);
	LPSTR GetCommandLineA();
	LPWSTR GetCommandLineW();
	BOOL SetCurrentDirectoryW(LPCWSTR lpPathName);
	DWORD GetCurrentDirectoryW(DWORD nBufferLength, LPWSTR lpBuffer);
	BOOL GetComputerNameA(LPSTR lpBuffer, LPDWORD nSize);
	BOOL GetComputerNameW(LPWSTR lpBuffer, LPDWORD nSize);
	BOOL GetVersionExA(LPOSVERSIONINFOA lpVersionInformation);
	UINT GetSystemDirectoryA(LPSTR lpBuffer, UINT uSize);
	UINT GetSystemDirectoryW(LPWSTR lpBuffer, UINT uSize);
	BOOL GetUserNameA(LPSTR lpBuffer, LPDWORD nSize); // advapi32.lib
	BOOL GetUserNameW(LPWSTR lpBuffer, LPDWORD nSize); // advapi32.lib
	DWORD GetEnvironmentVariableA(LPCSTR lpName, LPSTR lpBuffer, DWORD nSize);
	DWORD GetEnvironmentVariableW(LPCWSTR lpName, LPWSTR lpBuffer, DWORD nSize);
	DWORD ExpandEnvironmentStringsW(LPCWSTR lpSrc, LPWSTR lpDst, DWORD nSize);
	DWORD GetLogicalDrives();
	BOOL SetMenu(HWND hWnd, HMENU hMenu);
	//BOOL win32.winuser.SetLayeredWindowAttributes(HWND hwnd, COLORREF crKey, BYTE bAlpha, DWORD dwFlags);
	BOOL SystemParametersInfoA(UINT uiAction, UINT uiParam, PVOID pvParam, UINT fWinIni);
	BOOL TrackMouseEvent(LPTRACKMOUSEEVENT lpEventTrack);
	BOOL GetClassInfoA(экз hInstance, LPCSTR lpClassName, LPWNDCLASSA lpWndClass);
	BOOL GetClassInfoW(экз hInstance, LPCWSTR lpClassName, LPWNDCLASSW lpWndClass);
	LRESULT CallWindowProcA(WNDPROC lpPrevWndFunc, HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
	LRESULT CallWindowProcW(WNDPROC lpPrevWndFunc, HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
	BOOL OpenClipboard(HWND hWndNewOwner);
	BOOL EmptyClipboard();
	HGLOBAL GlobalAlloc(UINT uFlags, DWORD dwBytes);
	BOOL CloseClipboard();
	HANDLE SetClipboardData(UINT uFormat, HANDLE hMem);
	HANDLE GetClipboardData(UINT uFormat);
	//HGLOBAL GlobalFree(HGLOBAL hMem);
	LPVOID GlobalLock(HGLOBAL hMem);
	//BOOL GlobalUnlock(HGLOBAL hMem);
	BOOL DrawFocusRect(HDC hDC, RECT* lprc);
	LRESULT CallNextHookEx(HHOOK hhk, цел nCode, WPARAM wParam, LPARAM lParam);
	HHOOK SetWindowsHookExA(цел idHook, HOOKPROC lpfn, экз hMod, DWORD dwThreadId);
	BOOL UnhookWindowsHookEx(HHOOK hhk);
	//цел GetSystemMetrics(цел nIndex);
	BOOL DestroyMenu(HMENU hMenu);
	BOOL SetMenuItemInfoA(HMENU hMenu, UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii);
	BOOL SetMenuItemInfoW(HMENU hMenu, UINT uItem, BOOL fByPosition, LPMENUITEMINFOW lpmii);
	BOOL InsertMenuItemA(HMENU hMenu, UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii);
	BOOL InsertMenuItemW(HMENU hMenu, UINT uItem, BOOL fByPosition, LPMENUITEMINFOW lpmii);
	BOOL RemoveMenu(HMENU hMenu, UINT uPosition, UINT uFlags );
	UINT GetMenuItemID(HMENU hMenu, цел nPos);
	BOOL DrawMenuBar(HWND hWnd);
	HMENU CreatePopupMenu();
	HMENU CreateMenu();
	BOOL Shell_NotifyIconA(DWORD dwMessage, NOTIFYICONDATA* pnid);
	LONG RegQueryValueExA(HKEY hKey, LPCSTR lpValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData);
	LONG RegQueryValueExW(HKEY hKey, LPCWSTR lpValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData);
	LONG RegConnectRegistryA(LPCSTR lpMachineName, HKEY hKey, PHKEY phkResult);
	UINT RegisterClipboardFormatA(LPCSTR lpszFormat);
	UINT RegisterClipboardFormatW(LPCWSTR lpszFormat);
	цел GetClipboardFormatNameA(UINT format, LPSTR lpszFormatName, цел cchMaxCount);
	цел GetClipboardFormatNameW(UINT format, LPWSTR lpszFormatName, цел cchMaxCount);
	DWORD GlobalSize(HGLOBAL hMem);
	VOID ExitProcess(UINT uExitCode);
	BOOL DrawAnimatedRects(HWND hwnd, цел idAni, RECT* lprcFrom, RECT* lprcTo);
	HWND FindWindowExA(HWND hwndParent, HWND hwndChildAfter, LPCSTR lpszClass, LPCSTR lpszWindow);
	UINT SHAppBarMessage(DWORD dwMessage, PAPPBARDATA pData);
	BOOL SetPropA(HWND hWnd, LPCSTR lpString, HANDLE hData);
	HANDLE GetPropA(HWND hWnd, LPCSTR lpString);
	HANDLE RemovePropA(HWND hWnd, LPCSTR lpString);
	DWORD CommDlgExtendedError();
	LRESULT DefFrameProcA(HWND hWnd, HWND hWndMDIClient, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT DefFrameProcW(HWND hWnd, HWND hWndMDIClient, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT DefMDIChildProcA(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT DefMDIChildProcW(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	VOID SetLastError(DWORD dwErrCode);
	HWND CreateMDIWindowA(LPSTR lpClassName, LPSTR lpWindowName, DWORD dwStyle, цел X, цел Y, цел nWidth, цел nHeight, HWND hWndParent, экз hInstance, LPARAM lParam);
	цел MulDiv(цел nNumber, цел nNumerator, цел nDenominator);
	BOOL FillRgn(HDC hdc, HRGN hrgn, HBRUSH hbr);
	COLORREF GetNearestColor(HDC hdc,COLORREF crColor);
	цел DrawTextA(HDC hDC, LPCSTR lpString, цел nCount, LPRECT lpRect, UINT uFormat);
	цел DrawTextExA(HDC hdc, LPSTR lpchText, цел cchText, LPRECT lprc, UINT dwDTFormat, LPDRAWTEXTPARAMS lpDTParams);
	цел DrawTextExW(HDC hdc, LPWSTR lpchText, цел cchText, LPRECT lprc, UINT dwDTFormat, LPDRAWTEXTPARAMS lpDTParams);
	HANDLE LoadImageA(экз hinst, LPCSTR lpszName, UINT uType, цел cxDesired, цел cyDesired, UINT fuLoad);
	HANDLE LoadImageW(экз hinst, LPCWSTR lpszName, UINT uType, цел cxDesired, цел cyDesired, UINT fuLoad);
	HANDLE CopyImage(HANDLE hImage, UINT uType, цел cxDesired, цел cyDesired, UINT fuFlags);
	цел WSACancelAsyncRequest(HANDLE hAsyncTaskHandle);
	HANDLE WSAAsyncGetHostByName(HWND hWnd, бцел wMsg, PCSTR имя, char* buf, цел buflen);
	HANDLE WSAAsyncGetHostByAddr(HWND hWnd, бцел wMsg, PCSTR addr, цел len, цел type, char* buf, цел buflen);
	BOOL ExtTextOutA(HDC hdc, цел X, цел Y, UINT fuOptions, RECT* lprc, LPCSTR lpString, UINT cbCount, INT* lpDx);
	BOOL Arc(HDC hdc, цел nLeftRect, цел nTopRect, цел nRightRect, цел nBottomRect, цел nXStartArc, цел nYStartArc, цел nXEndArc, цел nYEndArc);
	BOOL PolyBezier(HDC hdc, POINT* lppt,DWORD cPoints);
	BOOL Ellipse(HDC hdc, цел nLeftRect, цел nTopRect, цел nRightRect, цел nBottomRect);
	BOOL Polygon(HDC hdc, POINT* lpPoints,цел nCount);
	BOOL Rectangle(HDC hdc, цел nLeftRect, цел nTopRect, цел nRightRect, цел nBottomRect);
	BOOL GdiFlush();
	LONG RegSetValueExW(HKEY hKey, LPCWSTR lpValueName, DWORD Reserved, DWORD dwType, BYTE* lpData, DWORD cbData);
	LONG RegCreateKeyExW(HKEY hKey, LPCWSTR lpSubKey, DWORD Reserved, LPWSTR lpClass, DWORD dwOptions, REGSAM samDesired, LPSECURITY_ATTRIBUTES lpSecurityAttributes, PHKEY phkResult, LPDWORD lpdwDisposition);
	LONG RegOpenKeyExW(HKEY hKey, LPCWSTR lpSubKey, DWORD ulOptions, REGSAM samDesired, PHKEY phkResult);
	LONG RegDeleteKeyW(HKEY hKey, LPCWSTR lpSubKey);
	LONG RegEnumKeyExW(HKEY hKey, DWORD dwIndex, LPWSTR lpName, LPDWORD lpcbName, LPDWORD lpReserved, LPWSTR lpClass, LPDWORD lpcbClass, PFILETIME lpftLastWriteTime);
	LONG RegEnumValueW(HKEY hKey, DWORD dwIndex, LPTSTR lpValueName, LPDWORD lpcbValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData);
	BOOL DrawFrameControl(HDC hdc, LPRECT lprc, UINT uType, UINT uState);
	BOOL GetTextExtentPoint32A(HDC hdc, LPCSTR lpString, цел cbString, LPSIZE lpSize);
	BOOL GetTextExtentPoint32W(HDC hdc, LPCWSTR lpString, цел cbString, LPSIZE lpSize);
	экз ShellExecuteA(HWND hwnd, LPCSTR lpOperation, LPCSTR lpFile, LPCSTR lpParameters, LPCSTR lpDirectory, INT nShowCmd);
	HANDLE CreateActCtxW(PACTCTXW pActCtx);
	BOOL ActivateActCtx(HANDLE hActCtx, ULONG** lpCookie);
	UINT GetTempFileNameW(LPCWSTR lpPathName, LPCWSTR lpPrefixString, UINT uUnique, LPWSTR lpTempFileName);
	DWORD GetTempPathW(DWORD nBufferLength, LPWSTR lpBuffer);
	VOID OutputDebugStringA(LPCSTR lpOutputString);
	VOID DebugBreak();
	BOOL BitBlt(HDC hdcDest, цел nXDest,цел nYDest, цел nWidth, цел nHeight, HDC hdcSrc, цел nXSrc, цел nYSrc, DWORD dwRop);
	BOOL GetIconInfo(HICON hIcon, PICONINFO piconinfo);
	BOOL DestroyIcon(HICON hIcon);
	BOOL DestroyCursor(HCURSOR hCursor);
	LPITEMIDLIST SHBrowseForFolderA(LPBROWSEINFOA lpbi);
	LPITEMIDLIST SHBrowseForFolderW(LPBROWSEINFOW lpbi);
	HRESULT SHGetMalloc(LPMALLOC* ppMalloc);
	BOOL SHGetPathFromIDListA(LPCITEMIDLIST pidl, LPSTR pszPath);
	BOOL SHGetPathFromIDListW(LPCITEMIDLIST pidl, LPWSTR pszPath);
	BOOL InitCommonControlsEx(LPINITCOMMONCONTROLSEX lpInitCtrls);
	цел GetDlgCtrlID(HWND hwndCtl);
	HWND GetDlgItem(HWND hDlg, цел nIDDlgItem);
	BOOL ShowOwnedPopups(HWND hWnd, BOOL fShow);
	UINT GetWindowsDirectoryA(LPSTR lpBuffer, UINT uSize);
	UINT GetWindowsDirectoryW(LPWSTR lpBuffer, UINT uSize);
	//HCURSOR CopyCursor(HCURSOR pcur);
	экз LoadLibraryExA(LPCSTR lpLibFileName, HANDLE hFile, DWORD dwFlags);
	экз LoadLibraryExW(LPCWSTR lpLibFileName, HANDLE hFile, DWORD dwFlags);
	HICON CopyIcon(HICON hIcon);
	BOOL ChooseColorA(LPCHOOSECOLORA lpcc);
	UINT DragQueryFileA(HDROP hDrop, UINT iFile, LPSTR lpszFile, UINT cch);
	UINT DragQueryFileW(HDROP hDrop, UINT iFile, LPWSTR lpszFile, UINT cch);
	VOID DragFinish(HDROP hDrop);
	BOOL DragQueryPoint(HDROP hDrop, LPPOINT lppt);
	BOOL GrayStringA(HDC hDC, HBRUSH hBrush, GRAYSTRINGPROC lpOutputFunc, LPARAM lpData, цел nCount, цел X, цел Y, цел nWidth, цел nHeight);
	BOOL IsWindowUnicode(HWND hWnd);
	BOOL ChooseFontA(LPCHOOSEFONTA lpcf);
	BOOL ChooseFontW(LPCHOOSEFONTW lpcf);
	HBITMAP CreateCompatibleBitmap(HDC hdc, цел nWidth, цел nHeight);
	LONG DispatchMessageW(MSG* lpmsg);
	BOOL PeekMessageW(LPMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg);
	LRESULT DefWindowProcW(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
	HWND GetNextDlgGroupItem(HWND hDlg, HWND hCtl, BOOL bPrevious);	
	HANDLE FindFirstChangeNotificationA(LPCSTR lpPathName, BOOL bWatchSubtree, DWORD dwNotifyFilter);
	HANDLE FindFirstChangeNotificationW(LPCWSTR lpPathName, BOOL bWatchSubtree, DWORD dwNotifyFilter);
	BOOL FindCloseChangeNotification(HANDLE hChangeHandle);
	BOOL FindNextChangeNotification(HANDLE hChangeHandle);
	DWORD GetFullPathNameA(LPCSTR lpFileName, DWORD nBufferLength, LPSTR lpBuffer, LPSTR *lpFilePart);
	DWORD GetFullPathNameW(LPCWSTR lpFileName, DWORD nBufferLength, LPWSTR lpBuffer, LPWSTR *lpFilePart);
	SHORT VkKeyScanA(char ch);
	SHORT VkKeyScanW(wchar ch);
	HRSRC FindResourceExA(HMODULE hModule, LPCSTR lpType, LPCSTR lpName, WORD wLanguage);
	HRSRC FindResourceExW(HMODULE hModule, LPCWSTR lpType, LPCWSTR lpName, WORD wLanguage);
	HGLOBAL LoadResource(HMODULE hModule, HRSRC hResInfo);
	DWORD SizeofResource(HMODULE hModule, HRSRC hResInfo);
	BOOL EnableMenuItem(HMENU hMenu, UINT uIDEnableItem, UINT uEnable);
	BOOL IsMenu(HMENU hMenu);
	HMENU GetSystemMenu(HWND hWnd, BOOL bRevert);
	DWORD GetModuleFileNameW(HMODULE hModule, LPWSTR lpFilename, DWORD nSize);
	HBITMAP CreateBitmap(цел nWidth, цел nHeight, UINT cPlanes, UINT cBitsPerPel, VOID *lpvBits);
	BOOL SetBrushOrgEx(HDC hdc, цел nXOrg, цел nYOrg, LPPOINT lppt);
	BOOL PatBlt(HDC hdc, цел nXLeft, цел nYLeft, цел nWidth, цел nHeight, DWORD dwRop);
	HTHEME GetWindowTheme(HWND hWnd);
	THEMEAPI SetWindowTheme(HWND hwnd, LPCWSTR pszSubAppName, LPCWSTR pszSubIdList);
	цел SetScrollInfo(HWND hwnd, цел fnBar, LPSCROLLINFO lpsi, BOOL fRedraw);
	BOOL GetScrollInfo(HWND hwnd, цел fnBar, LPSCROLLINFO lpsi);
	BOOL DragDetect(HWND hwnd, POINT pt);
	HFONT CreateFontIndirectW(LOGFONTW *lplf);
	DWORD GetThemeAppProperties();
	BOOL IsAppThemed();
	HTHEME OpenThemeData(HWND hwnd, LPCWSTR pszClassList);
	HRESULT CloseThemeData(HTHEME hTheme);
	HRESULT GetThemeColor(HTHEME hTheme, цел iPartId, цел iStateId, цел iPropId, COLORREF *pColor);
	HIMAGELIST ImageList_Create(цел cx, цел cy, UINT флаги, цел cInitial, цел cGrow);
	BOOL ImageList_Destroy(HIMAGELIST himl);	
	BOOL ImageList_Draw(HIMAGELIST himl, цел i, HDC hdcDst, цел x, цел y, UINT fStyle);
	BOOL ImageList_DrawEx(HIMAGELIST himl, цел i, HDC hdcDst, цел x, цел y, цел dx, цел dy, COLORREF rgbBk, COLORREF rgbFg, UINT fStyle);
	цел ImageList_Add(HIMAGELIST himl, HBITMAP hbmImage, HBITMAP hbmMask);
	цел ImageList_AddIcon(HIMAGELIST himl, HICON hicon);
	цел ImageList_AddMasked(HIMAGELIST himl, HBITMAP hbmImage, COLORREF crMask);
	BOOL ImageList_Remove(HIMAGELIST himl, цел i);
    HMODULE GetModuleHandleA(LPCSTR lpModuleName);
//////////////////////////////////////////////
/+

extern(C)
{
	extern IID IID_IPicture;
	
	version(REDEFINE_UUIDS)
	{
		// These are needed because uuid.lib is broken in DMC 8.46.
		IID _IID_IUnknown= { 0, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70] };
		IID _IID_IDataObject = { 270, 0, 0, [192, 0, 0, 0, 0, 0, 0, 70 ] };
		IID _IID_IPicture = { 2079852928, 48946, 4122, [139, 187, 0, 170, 0, 48, 12, 171] };
		IID _IID_ISequentialStream = { 208878128, 10780, 4558, [ 173, 229, 0, 170, 0, 68, 119, 61 ] };
		IID _IID_IStream = { 12, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70 ] };
		IID _IID_IDropTarget = { 290, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70 ] };
		IID _IID_IDropSource = { 289, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70 ] };
		IID _IID_IEnumFORMATETC = { 259, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70 ] };
	}
	else
	{
		alias IID_IUnknown _IID_IUnknown;
		alias IID_IDataObject _IID_IDataObject;
		alias IID_IPicture _IID_IPicture;
		
		alias IID_ISequentialStream _IID_ISequentialStream;
		alias IID_IStream _IID_IStream;
		alias IID_IDropTarget _IID_IDropTarget;
		alias IID_IDropSource _IID_IDropSource;
		alias IID_IEnumFORMATETC _IID_IEnumFORMATETC;
	}
}
+/

//alias IID_IUnknown _IID_IUnknown;
//alias IID_IDataObject _IID_IDataObject;
//alias IID_IPicture _IID_IPicture;
		
//alias IID_ISequentialStream _IID_ISequentialStream;
//alias IID_IStream _IID_IStream;
	//alias IID_IDropTarget _IID_IDropTarget;
	//alias IID_IDropSource _IID_IDropSource;
	//alias IID_IEnumFORMATETC _IID_IEnumFORMATETC;

extern(Windows):

interface ISequentialStream: IUnknown
{
	extern(Windows):
	HRESULT Read(ук pv, ULONG cb, ULONG* pcbRead);
	HRESULT Write(ук pv, ULONG cb, ULONG* pcbWritten);
}


/// STREAM_SEEK
enum: DWORD
{
	STREAM_SEEK_SET = 0,
	STREAM_SEEK_CUR = 1,
	STREAM_SEEK_END = 2,
}
alias DWORD STREAM_SEEK;


// TODO: implement the enum`s used here.
struct STATSTG
{
	LPWSTR pwcsName;
	DWORD тип;
	ULARGE_INTEGER cbSize;
	FILETIME mtime;
	FILETIME ctime;
	FILETIME atime;
	DWORD grfMode;
	DWORD grfLocksSupported;
	CLSID clsid;
	DWORD grfStateBits;
	DWORD reserved;
}


interface IStream: ISequentialStream
{
	extern(Windows):
	HRESULT Seek(LARGE_INTEGER dlibMove, DWORD dwOrigin, ULARGE_INTEGER* plibNewPosition);
	HRESULT SetSize(ULARGE_INTEGER libNewSize);
	HRESULT CopyTo(IStream pstm, ULARGE_INTEGER cb, ULARGE_INTEGER* pcbRead, ULARGE_INTEGER* pcbWritten);
	HRESULT Commit(DWORD grfCommitFlags);
	HRESULT Revert();
	HRESULT LockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType);
	HRESULT UnlockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType);
	HRESULT Stat(STATSTG* pstatstg, DWORD grfStatFlag);
	HRESULT Clone(IStream* ppstm);
}
alias IStream* LPSTREAM;


alias UINT OLE_HANDLE;

alias LONG OLE_XPOS_HIMETRIC;

alias LONG OLE_YPOS_HIMETRIC;

alias LONG OLE_XSIZE_HIMETRIC;

alias LONG OLE_YSIZE_HIMETRIC;


interface IPicture: IUnknown
{
	extern(Windows):
	HRESULT get_Handle(OLE_HANDLE* phandle);
	HRESULT get_hPal(OLE_HANDLE* phpal);
	HRESULT get_Type(short* ptype);
	HRESULT get_Width(OLE_XSIZE_HIMETRIC* pwidth);
	HRESULT get_Height(OLE_YSIZE_HIMETRIC* pheight);
	HRESULT Render(HDC hdc, цел x, цел y, цел cx, цел cy, OLE_XPOS_HIMETRIC xSrc, OLE_YPOS_HIMETRIC ySrc, OLE_XSIZE_HIMETRIC cxSrc, OLE_YSIZE_HIMETRIC cySrc, LPCRECT prcWBounds);
	HRESULT set_hPal(OLE_HANDLE hpal);
	HRESULT get_CurDC(HDC* phdcOut);
	HRESULT SelectPicture(HDC hdcIn, HDC* phdcOut, OLE_HANDLE* phbmpOut);
	HRESULT get_KeepOriginalFormat(BOOL* pfkeep);
	HRESULT put_KeepOriginalFormat(BOOL keep);
	HRESULT PictureChanged();
	HRESULT SaveAsFile(IStream pstream, BOOL fSaveMemCopy, LONG* pcbSize);
	HRESULT get_Attributes(DWORD* pdwAttr);
}

struct DVTARGETDEVICE
{
	DWORD tdSize;
	WORD tdDriverNameOffset;
	WORD tdDeviceNameOffset;
	WORD tdPortNameOffset;
	WORD tdExtDevmodeOffset;
	BYTE[1] tdData;
}


struct FORMATETC
{
	CLIPFORMAT cfFormat;
	DVTARGETDEVICE* ptd;
	DWORD dwAspect;
	LONG lindex;
	DWORD tymed;
}
alias FORMATETC* LPFORMATETC;


struct STATDATA 
{
	FORMATETC formatetc;
	DWORD grfAdvf;
	IAdviseSink pAdvSink;
	DWORD dwConnection;
}


struct STGMEDIUM
{
	DWORD tymed;
	union //u
	{
		HBITMAP hBitmap;
		//HMETAFILEPICT hMetaFilePict;
		HENHMETAFILE hEnhMetaFile;
		HGLOBAL hGlobal;
		LPOLESTR lpszFileName;
		IStream pstm;
		//IStorage pstg;
	}
	IUnknown pUnkForRelease;
}
alias STGMEDIUM* LPSTGMEDIUM;


interface IDataObject: IUnknown
{
	extern(Windows):
	HRESULT GetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium);
	HRESULT GetDataHere(FORMATETC* pFormatetc, STGMEDIUM* pmedium);
	HRESULT QueryGetData(FORMATETC* pFormatetc);
	HRESULT GetCanonicalFormatEtc(FORMATETC* pFormatetcIn, FORMATETC* pFormatetcOut);
	HRESULT SetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium, BOOL fRelease);
	HRESULT EnumFormatEtc(DWORD dwDirection, IEnumFORMATETC* ppenumFormatetc);
	HRESULT DAdvise(FORMATETC* pFormatetc, DWORD advf, IAdviseSink pAdvSink, DWORD* pdwConnection);
	HRESULT DUnadvise(DWORD dwConnection);
	HRESULT EnumDAdvise(IEnumSTATDATA* ppenumAdvise);
}


interface IDropSource: IUnknown
{
	extern(Windows):
	HRESULT QueryContinueDrag(BOOL fEscapePressed, DWORD grfKeyState);
	HRESULT GiveFeedback(DWORD dwEffect);
}


interface IDropTarget: IUnknown
{
	extern(Windows):
	HRESULT DragEnter(IDataObject pDataObject, DWORD grfKeyState, POINTL pt, DWORD* pdwEffect);
	HRESULT DragOver(DWORD grfKeyState, POINTL pt, DWORD* pdwEffect);
	HRESULT DragLeave();
	HRESULT Drop(IDataObject pDataObject, DWORD grfKeyState, POINTL pt, DWORD* pdwEffect);
}


interface IEnumFORMATETC: IUnknown
{
	extern(Windows):
	HRESULT Next(ULONG celt, FORMATETC* rgelt, ULONG* pceltFetched);
	HRESULT Skip(ULONG celt);
	HRESULT Reset();
	HRESULT Clone(IEnumFORMATETC* ppenum);
}


interface IEnumSTATDATA: IUnknown
{
	extern(Windows):
	HRESULT Next(ULONG celt, STATDATA* rgelt, ULONG* pceltFetched);
	HRESULT Skip(ULONG celt);
	HRESULT Reset();
	HRESULT Clone(IEnumSTATDATA* ppenum);
}


interface IAdviseSink: IUnknown
{
	// TODO: finish.
}


interface IMalloc: IUnknown
{
	extern(Windows):
	ук Alloc(ULONG cb);
	ук Realloc(ук pv, ULONG cb);
	проц Free(ук pv);
	ULONG GetSize(ук pv);
	цел DidAlloc(ук pv);
	проц HeapMinimize();
}

// Since an interface is а pointer..
alias IMalloc PMALLOC;
alias IMalloc LPMALLOC;


LONG MAP_LOGHIM_TO_PIX(LONG x, LONG logpixels)
{
	return MulDiv(logpixels, x, 2540);
}


enum: DWORD
{
	DVASPECT_CONTENT = 1,
	DVASPECT_THUMBNAIL = 2,
	DVASPECT_ICON = 4,
	DVASPECT_DOCPRINT = 8,
}
alias DWORD DVASPECT;


enum: DWORD
{
	TYMED_HGLOBAL = 1,
	TYMED_FILE = 2,
	TYMED_ISTREAM = 4,
	TYMED_ISTORAGE = 8,
	TYMED_GDI = 16,
	TYMED_MFPICT = 32,
	TYMED_ENHMF = 64,
	TYMED_NULL = 0
}
alias DWORD TYMED;


enum
{
	DATADIR_GET = 1,
}


enum: HRESULT
{
	DRAGDROP_S_DROP = 0x00040100,
	DRAGDROP_S_CANCEL = 0x00040101,
	DRAGDROP_S_USEDEFAULTCURSORS = 0x00040102,
	V_E_LINDEX = cast(HRESULT)0x80040068,
	STG_E_MEDIUMFULL = cast(HRESULT)0x80030070,
	STG_E_INVALIDFUNCTION = cast(HRESULT)0x80030001,
	DV_E_TYMED = cast(HRESULT)0x80040069,
	DV_E_DVASPECT = cast(HRESULT)0x8004006B,
	DV_E_FORMATETC = cast(HRESULT)0x80040064,
	DV_E_LINDEX = cast(HRESULT)0x80040068,
	DRAGDROP_E_ALREADYREGISTERED = cast(HRESULT)0x80040101,
}


alias HRESULT WINOLEAPI;


WINOLEAPI OleInitialize(LPVOID pvReserved);
WINOLEAPI DoDragDrop(IDataObject pDataObject, IDropSource pDropSource, DWORD dwOKEffect, DWORD* pdwEffect);
WINOLEAPI RegisterDragDrop(УОК hwnd, IDropTarget pDropTarget);
WINOLEAPI RevokeDragDrop(УОК hwnd);
WINOLEAPI OleGetClipboard(IDataObject* ppDataObj);
WINOLEAPI OleSetClipboard(IDataObject pDataObj);
WINOLEAPI OleFlushClipboard();
WINOLEAPI CreateStreamOnHGlobal(HGLOBAL hGlobal, BOOL fDeleteOnRelease, LPSTREAM ppstm);
WINOLEAPI OleLoadPicture(IStream pStream, LONG lSize, BOOL fRunmode, IID* riid, проц** ppv);


enum : DWORD 
{
 CP_ACP = (0),
 CP_MACCP = (2),
 CP_OEMCP = (1),
 CP_UTF8 = 65001
 }