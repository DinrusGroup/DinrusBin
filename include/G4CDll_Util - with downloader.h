
/*

!!!!!!!!!!!!!!!!!!!!!!!! NOTE
This is an older version of the G4CDll_Util.h file, containing the functions
to download the gui4cli.dll if it is not found. It works fine, but some
antivirus software mark it as a Virus (because of the downloading), so
it has been discontinued. You can use it for yourself though..

*/


// ==========================================================================
//
//	***	This file contains functions for loading Gui4Cli.dll
// ***	and getting the resources from your executable.
// ***	(Tabs are 3 chars long)
//
// ==========================================================================

// Windows includes we use in this file
#include "Shlwapi.h"
#include "WININET.H"

// ==========================================================================
// The functions Gui4Cli.dll exports. 
//   (Note - There are many other functions that can be used but they are 
//    not exported. Instead they are defined in G4C_api.h)
// Listed here are global pointers for the ones the dll exports. Their
// typedefs are in G4C_api.h. These pointers are filled at startup using 
// the loadGui4CliDll() function, below.
// ==========================================================================

GCG4CSTARTUP gcG4CStartup = NULL;
GCG4CSHUTDOWN gcG4CShutDown = NULL;
GCG4CLOOP gcG4CLoop = NULL;
GCGETGCMAIN gcGetGCMain = NULL;
GCSETCALLBACK gcSetCallback = NULL; 

// ==========================================================================
// Function prototypes for functions below that you can use..
// ==========================================================================

// This is the only function you need to call. Call it at startup, to get 
// pointers to the functions that Gui4Cli exports - see above.
HINSTANCE loadGui4CliDll (void);

// This is called by loadGui4CliDll() if Gui4Cli.dll is not found on the 
// user's system, to download the dll from gui4cli.com into windows/system32.
BOOL httpGetFile (char *url, char *destfile);

// =========================================================================
// utility functions
// =========================================================================

// find the file name part of a file path
char *findFileName (char *name, BOOL nullpath) // 1=null the '/'
{	if (!name || !name[0]) return (name);
	char *p = &name[strlen(name)-1]; // end of name
	if (p <= name) return (name); // name is empty..
	while ((*p!='\\')&&(*p!='/')&&(*p!=':')&&(p!=name)) --p;
	if ((*p=='\\')||(*p=='/')||(*p==':')) 
	{	if (nullpath) *p = '\0'; // null end of path part
		return (&p[1]); // return start of filename
	}
	else return (name); // only filename found..
}

// unquote string if quoted
void unquote (char *str)
{	char *a = str, *b = str, g;
	if (*a == '\"' || *a == '\'')
	{	g = *a; ++a;
		while (*a && *a != g) { *b = *a; ++a; ++b; }
		*b = '\0';
}	}

// Small error function to use before we get gui4cli funtions.
void exeSysError (char *message)
{
	void *lpMsgBuf;
	FormatMessage (FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | 
						FORMAT_MESSAGE_IGNORE_INSERTS, NULL,
						GetLastError(),
						MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
						(LPTSTR) &lpMsgBuf,
						0, NULL);

	MessageBox (NULL, (LPCTSTR)lpMsgBuf, message, MB_OK | MB_ICONINFORMATION);
	LocalFree(lpMsgBuf );
}

// =========================================================================
// Internet functions, to download Gui4Cli.dll
// =========================================================================
char ERR_INTERNET [] = "Internet error";
#define BUFFER_SIZE 10000

// Internet connection - ask the user to connect..
BOOL requestConnection (void)
{	DWORD state = 0;
	BOOL iscon = InternetGetConnectedState(&state, 0);
	while (iscon == FALSE)
	{	int ret = MessageBox (NULL, 
			"Please connect to the Internet so that\nGui4Cli.dll can be downloaded.\n\nChoose OK if the connection is made.\n\nChoose CANCEL to cancel.\n", 
			"Internet Connection", MB_OKCANCEL | MB_ICONEXCLAMATION);
		if (ret == IDCANCEL)
			return 0; // aborted..
		Sleep (100); // wait before checking again..
		iscon = InternetGetConnectedState(&state, 0);
	}
	return iscon;
}

BOOL httpGetFile (char *url, char *destfile)
{
	HINTERNET hint = NULL, hurl = NULL;
	HANDLE hfile = NULL;
	BOOL ret = 10;
	BYTE buff[BUFFER_SIZE + 4];
	DWORD actual, actual2, size = BUFFER_SIZE;

//	if (!requestConnection ())
//		return 0;

	// start internet session
	hint = InternetOpen ("Gui4Cli", INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, NULL); 
	if (!hint)
	{	exeSysError ("InternetOpen"); return 0;
	}

	// open the url..
	hurl = InternetOpenUrl (hint, url, NULL, 0, INTERNET_FLAG_DONT_CACHE, 0);
	if (!hurl)
	{	exeSysError ("InternetOpenUrl"); goto getout;
	}

	// open the file..
	hfile = CreateFile (destfile, GENERIC_WRITE, 0, 0, CREATE_ALWAYS,
							  FILE_ATTRIBUTE_NORMAL, 0);
	if (hfile == INVALID_HANDLE_VALUE)
	{	exeSysError ("CreateFile"); goto getout;
	}

	// read data into the file..
	do
	{	if (!InternetReadFile (hurl, buff, size, &actual))
		{	exeSysError ("InternetReadFile"); goto getout;
		}
		if (!WriteFile (hfile, buff, actual, &actual2, NULL))
		{	exeSysError ("WriteFile"); goto getout;
		}
	}	while (actual == size);

	ret = NOERROR; // everything ok..

getout:
	if (hfile)
	{	CloseHandle (hfile);
	}
	if (hurl)
	{	if (!InternetCloseHandle(hurl))
		{	exeSysError ("InternetCloseHandle");
	}	}
	if (hint)
	{	if (!InternetCloseHandle(hint))
		{	exeSysError ("InternetClose");
	}	}

	return ret;
}

// =========================================================================
// Find and load Gui4Cli.dll, get funtion pointers..
// If dll is not found, try to download it from gui4cli.com
// =========================================================================
#define PATH_BUFF_SIZE (MAX_PATH + 16)

HINSTANCE loadGui4CliDll (void)
{
	HINSTANCE lib = 0;
	char *fname, fpath[PATH_BUFF_SIZE+2];

	// look first in the same dir as the executable
	if (GetModuleFileName(NULL, fpath, MAX_PATH))
	{	fname = findFileName(fpath, TRUE);
		strcat_s (fpath, PATH_BUFF_SIZE, "\\Gui4Cli.dll");
		lib = LoadLibrary(fpath);
	}
	// if not there, try the Gui4Cli directory
	if (!lib)
	{	HKEY key; *fpath = '\0';
		if (RegOpenKeyEx (HKEY_LOCAL_MACHINE, "SOFTWARE\\Gui4Cli\\G4C", NULL, 
								KEY_READ, &key) == NOERROR)
		{	DWORD type = 0, size = MAX_PATH;
			if (RegQueryValueEx (key, "Path", 0, &type, (BYTE *)fpath, &size) != ERROR_SUCCESS)
				*fpath = '\0';
			RegCloseKey (key);
		}
		unquote (fpath);
		strcat_s (fpath, PATH_BUFF_SIZE, "\\Gui4Cli.dll");
		lib = LoadLibrary(fpath);
	}
	// if not there either, let windows look for it..
	if (!lib)
	{	UINT oldmode = SetErrorMode(SEM_FAILCRITICALERRORS); // suppress requester..
		lib = LoadLibrary("Gui4Cli.dll");
		SetErrorMode(oldmode);
	}

	// if still not found, try to download it..
	if (!lib)
	{	char tbuff[MAX_PATH], tbuff2[MAX_PATH+16];
		int choice = MessageBox (NULL, 
"This application needs Gui4Cli.dll to function.\n\
Its a small freeware dll that can be automatically\n\
downloaded from www.Gui4Cli.com. This needs to be\n\
done only this first time.\n\n\
Click \"Yes\" to download the dll into your Windows\n\
System32 folder and continue with the application.\n\n\
Click \"No\" to abort.\n",
			"Gui4Cli.dll needed", MB_YESNO | MB_ICONQUESTION);
		if (choice == IDNO)
			return NULL;
		if (GetSystemDirectory(tbuff, MAX_PATH))
		{	PathCombine(tbuff2, tbuff, "Gui4Cli.dll");
			if (httpGetFile ("http://www.Gui4Cli.com/Gui4Cli.dll", tbuff2) == NOERROR)
			{	lib = LoadLibrary("Gui4Cli.dll"); // maybe the site is moved in future..
	}	}	}
	
	if (!lib) // nothing worked..
	{	MessageBox (NULL, "Could not download Gui4Cli.dll :(\nPlease go to http://www.Gui4Cli.com\nand download it yourself.", "Gui4Cli.dll not found", MB_OK | MB_ICONERROR);
		return NULL;
	}
	// get pointers to exported Gui4Cli functions..
	bool ok = 0;
	if (gcG4CStartup = (GCG4CSTARTUP) GetProcAddress(lib, "gcG4CStartup"))
	{	if (gcG4CShutDown = (GCG4CSHUTDOWN) GetProcAddress(lib, "gcG4CShutDown"))
		{	if (gcG4CLoop = (GCG4CLOOP) GetProcAddress(lib, "gcG4CLoop"))
			{	if (gcGetGCMain = (GCGETGCMAIN) GetProcAddress(lib, "gcGetGCMain"))
				{	if (gcSetCallback = (GCSETCALLBACK) GetProcAddress(lib, "gcSetCallback"))
						ok = 1; // got all functions..
	}	}	}	}
	if (!ok)
	{	MessageBox (NULL, "Invalid Gui4Cli.dll - not all functions found.", "Gui4Cli", MB_OK | MB_ICONERROR);
		FreeLibrary (lib);
		return NULL;
	}
	return lib;
}










