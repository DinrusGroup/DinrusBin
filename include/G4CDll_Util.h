// ==========================================================================
//
//	***	This file contains functions for loading Gui4Cli.dll
// ***	and getting the resources from your executable.
// ***	(Tabs are 3 chars long)
//
// ==========================================================================

// Windows includes we use in this file
#include "Shlwapi.h"
#include "shellapi.h"

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
	{	int choice = MessageBox (NULL, 
"This application needs Gui4Cli.dll to function.\n\
Its a free, safe, open-source dll that can be \n\
downloaded from www.Gui4Cli.com.\n\n\
Click \"Yes\" to quit and go to the Downloads page \n\
Click \"No\" to quit.\n\n",
			"Gui4Cli.dll needed", MB_YESNO | MB_ICONQUESTION);
		
		if (choice == IDYES)
		{	char tbuff[50];
			strcpy_s (tbuff, 40, "http:"); strcat_s (tbuff, 49, "//www.gui4cli.com/html/Downloads.htm");
			ShellExecute (NULL, "explore", tbuff, 0, 0, SW_SHOW);
			// system("explorer http://www.gui4cli.com/html/Downloads.htm");
		}
		return NULL; // we'll quit anyway.. let the users restart us after download..
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










