//
//	Gui4Cli API - D. Keletsekis - 1/4/2004
//
// Includes for writting DLLs for Gui4Cli - (to be extended)..	
//
//	Contents:										
// - Structure declarations for Gui4Cli
// - Gui4Cli API function definitions
//
// NOTE: To view this file correctly, TABs should be 3 spaces long.

// =============================================================================
//	Note: ARGUMENT TEMPLATES
// =============================================================================
/*
	Commands, Events and their arguments are declared by giving a simple string, 
	containing "Name Template Name Template".. etc. The template is series of 
	letters, defining the argunents the command expects. Example:

	char DLL_COMMANDS[] = "DOUBLE NS LIST 0";

	Rules:
	- Everything must be in capitals.
	- For now, you can have a maximum of 8 arguments
	- Event names must start with X, all othes must not
	- The strings must be global, valid throughout the life of the DLL
	
	The template is a series of letters defining the arguments, as follows:

	S - A string is expected

	N - A number. This is stored as a long integer. There are no floats or
	    other types. If needed, they can be passed as strings.

	K - A Keyword. This is also stored as a long integer. A "Keyword" is a
	    numeric representation on the first 4 letters of a string. It makes 
	    it easy to declare flags, switches etc..

	U - An Optional string argunent. This is the same as "S", but there is 
	    no error if it is not given. Of course, they must be the last letter
		 in the template.

	0 - (zero) - This can only be given alone, and it means that the command
	    does not take any arguments.

   T - This can only be given alone, or as the last argument. It will cause
	    the parser to consider the remainder of the line (or all of the line)
		 as one argument - ie no quotes are needed.
*/
// =============================================================================

// include is needed for IPicture interface
#ifndef __ocidl_h__
#include <ocidl.h>
#endif

// =============================================================================

// This define is used for making numeric ID's (Keywords) from the first 4
// letters of a word (which should be in capitals).
#define MakeID(a,b,c,d)	((LONG)(d)<<24L | (LONG)(c)<<16L | (b)<<8 | (a))
#define kWRITE	 MakeID('W','R','I','T')	// example... 

// various defines
#define MYMAX_NAME	35		// maximum string length for gui names, image names, etc

// All commands must return the $$RETCODE internal variable, which
// is 0 for OK and a value from 1 - 20 indicating the severety of
// the error. 5 is a warning, 10 serious, 20 is fatal.
typedef int RETCODE;
#define NOERROR 0				// success..
#define SAME 0					// strcmp()
#define REPORT TRUE			// for functions that want to know if a debug report
#define NOREPORT FALSE		// should be printed on failure.

// This is the structure arguments are passed in. An argument can be
// be a string or a long, according to what you gave in the template.
// "N" and "K" are numbers, the others are strings. All functions that Gui4Cli
// calls are given a pointer to an array of gcArguments structures, containing the 
// translated arguments. Note that the *str argument is always valid, even if the 
// argunment is a number, and points to a buffer GCM->buffsize long (default 1024 bytes).
// You can use this buffer too, if you want, but its temporary..
struct gcArguments
{
	char *str;	// This always points to a valid buffer..
	long num;
};

// This is the structure used to store a variable. Lists of these
// are attached to guis, events, treeviews etc..
struct var
{
	char *name;				// malloc() - the variable's name
	char *str;				// malloc() - the variable's contents
	struct var *next;		// pointer to next variable in list
	// to be extended..
};

// =============================================================================
//	EVENTS & COMMANDS
// =============================================================================

// The maximum number of arguments.
#define OPT_COUNT		 12

// Union to hold each of the OPT_COUNT possible number of arguments..
union commandunion
{	LONG  num;		// number
	char  *str;		// string
	void *dummy;	// forget it..
};

// EVENT COMMAND
// This structure holds an event command. A list of these is attached
// to every event structure, to be executed when the event is trigerred.
struct line
{
	SHORT	type;				// type of command (internal definition..)
	int progline;			// 0-based line No of the command in the file
	struct line *next;	// pointer to next command or NULL
	void *xt;				// general purpose attach

	// More private fields - use gcGetLineArg() to get arguments..
};

// This structure is allocated only if its a visual event, and
// contains stuff that non-visual events don't need..
struct VisDat
{
	BYTE	Resz[4];			// Left/Top/Wd/Ht 0=Normal, 1=None, 2=Max

	// these are the items you should initialize..
	DWORD exStyle;			// ExStyle (frame etc) given to CreateWindowEx()
	DWORD Style;			// Style given to CreateWindowEx()
	char *Wnclass;			// pointer to class string CL_BUTTON.. (Command.h)
	char *Title;			// gadget title or null (points to an arg[])
	char *Varname;			// variable name, if any (points to an arg[])

	// these are set by ATTR 
	char *fontname;		// malloc() - name of events's font (if any is set)
	char *iconname;		// malloc() - name of icon (if any)
	char *help;				// malloc() - tooltip text, if any..
	char *pageid;			// malloc() - name of page this event belongs to (if any)

	// more private fields..
};

// The actual Event structure. A list of these is attached to each gui file
struct Event
{
	BYTE magic;					// == 131 - for sanity checks..
	char *UID;					// ID, if defined..
	WORD type;					// type of event (see defines)
	WORD tclass;				// my class type - ie does it have LTWH etc

	struct guifile *gf;		// pointer to the guifile of this event
	struct line *topx;		// first of a linked list of event commands
	struct var *topvar;		// first of list of this event's variables (if any)
	struct Event *next;		// next event in the list (or null)..

	int progline;				// 0-based Line in the file where event is declared
	int lastline;				// 0-based Line No of last of this events commands (in file)

	HWND  wn;					// event's window handle, if any..
	int  val;					// current value of event (varies - use it for your own events)	

	struct VisDat *qq;		// extra structure, allocated only for visual gadgets
	void *xt;		 			// void pointer, to attach special structures according to event type

	void *user;					// Free pointer to attach user data - USE THIS!

	// More private fields - use gcGetEventArg() to get arguments..
};

// =============================================================================
// GUIs
// =============================================================================

struct guifile						// the main gui structure - every gui has one.
{ 
	BYTE magic;						// == 132 - for sanity checks
	char name[MYMAX_NAME+1];	// gui name (fixed buffer)

	struct Event *topbt;			// first of list of EVENTs
	struct var *topvar;			// first of list of this gui's variables
	struct guifile *next;		// next gui file (or null)

	int  wbline;					// line number of Window command (for gui saving)
	int  progstart;				// line in file where the gui starts
	int  progfinish;				// line where it ends

	HWND	wn;						// pointer to this gui's window (if declared and open)

	char *parentName;				// malloc() - name of gui to be a child of
	char *pageid;					// malloc() - the current pageid
	char *iconName;				// malloc() - name of window's icon (if any)

	char *wintitle;				// read-only - window title

	struct guifile *parentgf;	// the pointer to the parent window (if any)..

	// More private fields..
};

// =============================================================================
// EVENT SPECIFIC STRUCTURES
// =============================================================================

// image structure - every image has one
struct imginfo	
{
	struct imginfo *next;		// next image in list
	BYTE  magic;					// == 134 - for sanity checks..
	char *name;						// malloc() - the name of this image
	HBITMAP hbm;					// HBITMAP from loadimage() 
	IPicture *pic;					// picture object
	BITMAP bm;						// Start of DIBSECTION...
	BITMAPINFOHEADER dsBmih;
	DWORD dsBitfields[3]; 		// These fields are a copy of the DIBSECTION
	HANDLE dshSection; 
	DWORD dsOffset;				// End of DIBSECTION.
	WORD	user;						// internal use count (pointers/bgds..)
	// More private fields..
};

// xBUFFER event structure
struct myBuffer	
{
	struct myBuffer *next;		// linked list of buffers..
	char *name;						// the name itself.. malloc() - must free.
	char *buff;						// the actual buffer
	long len;						// its length
	// More private fields..
};


// =============================================================================
// Holder structure for packed resource
// =============================================================================

struct resHolder
{
	ULONG size;					// resource data payload size (or 0)
	HGLOBAL hglob;				// locked resource
	HRSRC hrsrc;				// resource handle
	BYTE *buff;					// the full memory buffer containing the file
	// private fields below this..............
};

// =============================================================================
// COMMANDS
// =============================================================================
typedef int (WINAPI *DLLCOMMAND)(struct gcArguments *args);

// The structure that commands are held in
struct Commands	
{
	struct Commands *next;	// next command in list..
	char *com;					// the command name - "XBUTTON"
	char *tem;					// the template - "NNNNS"
	WORD type;					// command type - #define'd number

	// More private fields.. - get function pointer with gcGetComFunc()
};

// =============================================================================
// DLL specific
// =============================================================================

struct dllHolder	// this holds information for each loaded dll
{
	struct dllHolder *next;		// next DLL in list, or NULL
	HMODULE hdll;					// the dll module handle
	struct Commands *topcom;
	char *dllName;					// the name of the dll (ie Test.dll -> "TEST")
	char *dllPath;					// the full path..
	int totCommands;				// total number of commands
	int totEvents;					// total number of events
	int userCount;					// how many commands using it are loaded - purge on 0
	// more private fields..
};

// =============================================================================
// GCMAIN
// =============================================================================

// This is the main Gui4Cli structure, the base for all pointers.
struct GCMain
{	
	long magic;							// sanity check (MM_G4C = 4848484)
	HINSTANCE hInstance;				// Gui4Cli hInstance
	DWORD threadID;					// Main thread ID (PostThreadMessage() etc)
	DWORD procID;						// Process ID
	WORD osversion[2];				// Windows version ([Major][minor])
	char osplatform[3];				// 31, 95, 98 or NT

	HWND outwn;							// output window handle
	HWND outlv;							// output window listview handle
	struct Event *outputBT;			// event to output to (if output is diverted)

	HKEY rgLocal, rgUser;			// open registry keys - User keys 
	HKEY rgGLocal, rgGUser;			// open registry keys - Gui4Cli keys

	WORD lastMouseX, lastMouseY;	// latest mouse position (may not always be right)..
	short lastWheelDelta;			// how many clicks wheel travelled last time..

	// This is a void pointer array (function table) containing pointers to all 
	// functions that Gui4Cli exports. DLLs can use them to save on code..
	// See definitions below...
	void **vtbl;						

	// these are the buffers used by Gui4Cli for handling data. They will be free when
	// your DLL function is called so you can use them, but if you call other Gui4Cli
	// functions, they may be overwritten by them, so always check for this..
	char *membuff[5];					// 5 main memory buffers of buffsize length
	int buffsize;						// size of buffers (1024 bytes by default - changed with SET)

	char buff[MAX_PATH];				// Spare buffer..

	struct var *gtopvar;				// top of the Global variables list (null if no globals)
	struct guifile *topguifile;	// first of a linked list of all gui files

	// These pointers are the gui and event that started the last round of command
	// execution. They can be changed by the Use command.
	struct guifile *curgf;			// Current GUI - the one last activated or set by Use
	struct Event *curbt;				// Current EVENT - the one last trigerred or set by Use
	struct line *curx;				// Current COMMAND - set by Use only

	// These pointers are the currently executing gui, event and command, which may
	// or may not be the same as the above. They change, for example, if you GOSUB..
	struct guifile *execgf;			// GUI in which the currently executing command is
	struct Event *execbt;			// EVENT in which the currently executing command is
	struct line *execx;				// COMMAND - the currently executing command

	struct imginfo *topimage;		// top of linked list of images
	struct imginfo *curimg;			// current image



	// More private fields..
};

// ================================================================================

// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

// ================================================================================

// Function Definitions

// ================================================================================
// Gui4Cli.DLL
// These are the templates of the functions exported by the Gui4Cli.dll
// See the Gui4Cli manual for explanations..

typedef int (WINAPI *GCG4CSTARTUP)(HINSTANCE hInstance, LPSTR lpCmdLine, int nCmdShow, BOOL haveRes); // the haveRes was mistakenly left out until G4C - v19.37, causing a ESP runtime error... -1 means I don't know..
// GCG4CSTARTUP gcG4CStartup = NULL;
typedef void (WINAPI *GCG4CSHUTDOWN)(void);
// GCG4CSHUTDOWN gcG4CShutDown = NULL;
typedef void (WINAPI *GCG4CLOOP)(void);
// GCG4CLOOP gcG4CLoop = NULL;
typedef struct GCMain * (WINAPI *GCGETGCMAIN)(void);
// GCGETGCMAIN gcGetGCMain = NULL;
// typedef RETCODE (WINAPI *GCZUILOAD)(BYTE *datastart, ULONG datasize); - OBSOLETE!
// GCZUILOAD gcZuiLoad = NULL;
typedef BOOL (WINAPI *GCSETCALLBACK)(long type, void *funcPointer);
// GCSETCALLBACK gcSetCallback = NULL; 

// These are the defines for function types you can pass to gcSetCallback(), 
// together with the template of the function that Gui4Cli.dll expects.
#define CB_MAIN			0	// main loop
// typedef BOOL (WINAPI *G4C_CALLBACK)(MSG *msg);
#define CB_WINDOW			1	// window proc
// typedef BOOL (WINAPI *G4C_WINPROC)(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam, LRESULT *result);
#define CB_GETFUNCTION	2	// get pointer to function to call to get function pointers..
// typedef void * (WINAPI *G4C_GETFUNCTION)(char *FunctionName, int dummy_parameter);


// ================================================================================
// Gui4Cli.EXE and DLL
// Below we define various functions included in Gui4Cli which you can call, 
// if you want. Using them will save you a lot of code and reduce your DLL size..
// Read the help manual for funtion descriptions. We get all function pointers from
// the function table in GCMain via a global pointer called "GCM", which must have 
// been initialized by the DLL before calling any of these functions..

typedef BOOL (WINAPI *GCADDCOMMANDS)(char *dllTemplate);
#define gcAddCommands ((GCADDCOMMANDS)(GCM->vtbl[1]))

typedef void (WINAPI *GCSYSERROR)(BOOL requester, long errno, LPCTSTR str,...);
#define gcSysError ((GCSYSERROR)(GCM->vtbl[2]))

typedef void (WINAPI *GCPRINT)(LPCTSTR str,...);
#define gcPrintf ((GCPRINT)(GCM->vtbl[3]))

typedef void (WINAPI *GCSPRINT)(char *buffer, int bufferSize, LPCTSTR str,...);
#define gcSNPrintf ((GCSPRINT)(GCM->vtbl[4]))

typedef void (WINAPI *GCSETVAR)(char *name, char *value);
#define gcSetVar ((GCSETVAR)(GCM->vtbl[5]))

typedef char * (WINAPI *GCGETVAR)(char *name, char *storebuff, LONG buffsize, int translate);
#define gcGetVar ((GCGETVAR)(GCM->vtbl[6]))

typedef BOOL (WINAPI *SETSIMPLEVAR)(struct var **vartop, char *name, char *str);
#define gcSetVarEx ((SETSIMPLEVAR)(GCM->vtbl[7]))

typedef union commandunion (WINAPI *GCGETLINEARG)(struct line *x, int argnum);
#define gcGetLineArg ((GCGETLINEARG)(GCM->vtbl[8]))

typedef union commandunion (WINAPI *GCGETEVENTARG)(struct Event *bt, int argnum);
#define gcGetEventArg ((GCGETEVENTARG)(GCM->vtbl[9]))

typedef int (WINAPI *GCREADNUM)(char *str, LONG *result, BOOL report);
#define gcReadNum ((GCREADNUM)(GCM->vtbl[10]))

typedef BOOL (WINAPI *MATCHPATTERN)(char *string, char *pattern, BOOL insensitive);
#define gcMatchPattern ((MATCHPATTERN)(GCM->vtbl[11]))

typedef struct Commands * (WINAPI *GCFINDEVENTDEF)(struct Event *bt, BOOL report);
#define gcFindEventDef ((GCFINDEVENTDEF)(GCM->vtbl[12]))

typedef struct Commands * (WINAPI *GCFINDCOMMANDDEF)(struct line *x, BOOL report);
#define gcFindCommandDef ((GCFINDCOMMANDDEF)(GCM->vtbl[13]))

typedef BOOL (WINAPI *TRANSLATE)(char *buffer, int buffsize);
#define gcTranslate ((TRANSLATE)(GCM->vtbl[14]))

typedef char * (WINAPI *MYSTRCPY)(char *to, char *from, int size);
#define gcStrNCpy ((MYSTRCPY)(GCM->vtbl[15]))

typedef int (WINAPI *MYSTRCMP)(char *str1, char *str2);
#define gcStrCmp ((MYSTRCMP)(GCM->vtbl[16]))

typedef BOOL (WINAPI *MYSTRICMP)(char *str1, char *str2);
#define gcStrICmp ((MYSTRICMP)(GCM->vtbl[17]))

typedef BOOL (WINAPI *REPSTRING)(char *str, char **pointer);
#define gcRepString ((REPSTRING)(GCM->vtbl[18]))

typedef BOOL (WINAPI *JOINFILEEX)(char *dir, char *file, LONG bfsize, BOOL quote);
#define gcJoinFile ((JOINFILEEX)(GCM->vtbl[19]))

typedef void (WINAPI *MYERROR)(char *title, char *str,...);
#define gcError ((MYERROR)(GCM->vtbl[20]))

typedef BOOL (WINAPI *CHECKSECURITY)(void);
#define gcSecurity ((CHECKSECURITY)(GCM->vtbl[21]))

typedef BOOL (WINAPI *GCGETVISUALDATA)(struct Event *bt);
#define gcGetVisualData ((GCGETVISUALDATA)(GCM->vtbl[22]))

typedef BOOL (WINAPI *GETGFFROMWIN)(HWND win, struct guifile **cgf, struct Event **cbt);
#define gcGetWindowPointers ((GETGFFROMWIN)(GCM->vtbl[23]))

typedef BOOL (WINAPI *GCADDEVENTS)(char *dtLTWH, char *dtVISUAL, char *dtEVENT);
#define gcAddEvents ((GCADDEVENTS)(GCM->vtbl[24]))

typedef void (WINAPI *DOCOMMANDMESSAGE)(struct Event *bt);
#define gcTriggerEvent ((DOCOMMANDMESSAGE)(GCM->vtbl[25]))

typedef struct Commands * (WINAPI *GCFINDEVENTTYPE)(struct Event *bt, BOOL report);
#define gcFindEventType ((GCFINDEVENTTYPE)(GCM->vtbl[26]))

typedef LONG (WINAPI *GETKEYWORD)(char *str);
#define gcGetKeywordID ((GETKEYWORD)(GCM->vtbl[27]))

typedef long (WINAPI *GETNUM)(char *str, BOOL report);
#define gcGetNum ((GETNUM)(GCM->vtbl[28]))

typedef void (WINAPI *EXTRACT)(char *var, LONG mode, char *dest);
#define gcExtract ((EXTRACT)(GCM->vtbl[29]))

typedef char * (WINAPI *MAKEUPPER)(char *str);
#define gcToUpper ((MAKEUPPER)(GCM->vtbl[30]))

typedef char ** (WINAPI *GETSTRINGARRAY)(char *names, int *totStrings, BYTE slashchar);
#define gcGetStrings ((GETSTRINGARRAY)(GCM->vtbl[31]))

typedef void (WINAPI *FREESTRINGARRAY)(char **namar, int num);
#define gcFreeStrings ((FREESTRINGARRAY)(GCM->vtbl[32]))

typedef void (WINAPI *USEIMAGE)(struct imginfo *img);
#define gcImgRef ((USEIMAGE)(GCM->vtbl[33]))

typedef void (WINAPI *UNUSEIMAGE)(struct imginfo *img);
#define gcImgUnref ((UNUSEIMAGE)(GCM->vtbl[34]))

typedef struct imginfo * (WINAPI *FINDIMAGE)(char *name, BOOL report);
#define gcImgFind ((FINDIMAGE)(GCM->vtbl[35]))

typedef void (WINAPI *GCBGDPAINT)(struct Event *bt);
#define gcBgdPaint ((GCBGDPAINT)(GCM->vtbl[36]))

typedef HBITMAP (WINAPI *GCIMGGETBITMAP)(int w, int h, int depth, void **pbitbuff);
#define gcImgGetBitmap ((GCIMGGETBITMAP)(GCM->vtbl[37]))

typedef struct imginfo * (WINAPI *GCIMGFROMBITMAP)(HBITMAP hbm, char *alias);
#define gcImgFromBitmap ((GCIMGFROMBITMAP)(GCM->vtbl[38]))

typedef struct imginfo * (WINAPI *GCIMGLOAD)(char *picpath, char *alias);
#define gcImgLoad ((GCIMGLOAD)(GCM->vtbl[39]))

typedef int (WINAPI *GCIMGCOMMAND)(int com, char *arg1, char *arg2, char *arg3, char *arg4, char *arg5);
#define gcImgCommand ((GCIMGCOMMAND)(GCM->vtbl[40]))

typedef void (WINAPI *GCFREE)(void *ptr);
#define gcFree ((GCFREE)(GCM->vtbl[41]))

typedef void * (WINAPI *GCMALLOC)(int size, BOOL clear, BOOL report);
#define gcMalloc ((GCMALLOC)(GCM->vtbl[42]))

typedef int (WINAPI *GCPOPMENU)(char *choices);
#define gcPopMenu ((GCPOPMENU)(GCM->vtbl[43]))

typedef struct Event * (WINAPI *GCFINDEVENT)(char *gfname, char *btid, BOOL report);
#define gcFindEvent ((GCFINDEVENT)(GCM->vtbl[44]))

typedef BOOL (WINAPI *GCDLLLOAD)(char *name);
#define gcDllLoad ((GCDLLLOAD)(GCM->vtbl[45]))

typedef void (WINAPI *GCDLLFREE)(char *name);
#define gcDllFree ((GCDLLFREE)(GCM->vtbl[46]))

typedef struct gcArguments * (WINAPI *GCPARSEARGS)(char *tem, ...);
#define gcParseArgs ((GCPARSEARGS)(GCM->vtbl[47]))

typedef char * (WINAPI *GCPARSEFILENAME)(struct guifile *gf, char *name);
#define gcParseFilename ((GCPARSEFILENAME)(GCM->vtbl[48]))

typedef char * (WINAPI *GCREADFILE)(char *name, char *header, long *pfilesize);
#define gcReadFile ((GCREADFILE)(GCM->vtbl[49]))

typedef struct guifile * (WINAPI *GCPARSEBUFFER)(struct guifile *gf, char *buffer, BOOL doxonload);
#define gcParseBuffer ((GCPARSEBUFFER)(GCM->vtbl[50]))

typedef int (WINAPI *GCTRIGGEREVENTWAIT)(struct Event *bt);
#define gcTriggerEventWait ((GCTRIGGEREVENTWAIT)(GCM->vtbl[51]))

typedef void * (WINAPI *GCHOLDERCREATE)(void **top, int size, char *name);
#define gcHolderCreate ((GCHOLDERCREATE)(GCM->vtbl[52]))

typedef void (WINAPI *GCHOLDERFREE)(void **top, void *freethis);
#define gcHolderFree ((GCHOLDERFREE)(GCM->vtbl[53]))

typedef void * (WINAPI *GCHOLDERFIND)(void *top, char *name, BOOL report);
#define gcHolderFind ((GCHOLDERFIND)(GCM->vtbl[54]))

typedef void (WINAPI *GCHOLDERFREEALL)(void **top);
#define gcHolderFreeAll ((GCHOLDERFREEALL)(GCM->vtbl[55]))

typedef void * (WINAPI *GCHOLDERGOTO)(void *top, void *current, char *name);
#define gcHolderGoto ((GCHOLDERGOTO)(GCM->vtbl[56]))

typedef BOOL (WINAPI *GCAPPEND)(char *file, char *str, char *flag);
#define gcAppend ((GCAPPEND)(GCM->vtbl[57]))

typedef char * (WINAPI *GCFILEPART)(char *name, BOOL nullpath);
#define gcFilePart ((GCFILEPART)(GCM->vtbl[58]))

typedef int (WINAPI *GCRENAME)(char *oldName, char *newName, char *flags);
#define gcRename ((GCRENAME)(GCM->vtbl[59]))

typedef int (WINAPI *GCMOVE)(char *sourceName, char *destination, char *flags);
#define gcMove ((GCMOVE)(GCM->vtbl[60]))

typedef int (WINAPI *GCCOPY)(char *sourceName, char *destination, char *flags);
#define gcCopy ((GCCOPY)(GCM->vtbl[61]))

typedef int (WINAPI *GCDELETE)(char *Name, char *flags);
#define gcDelete ((GCDELETE)(GCM->vtbl[62]))

typedef struct imginfo * (WINAPI *GCIMGLOADMEM)(char *buffer, char *alias, DWORD buffsize);
#define gcImgLoadMem ((GCIMGLOADMEM)(GCM->vtbl[63]))

typedef BOOL (WINAPI *GCLVLOADBUFFER)(struct Event *bt, char *buffer, int buffersize);
#define gcLVLoadBuffer ((GCLVLOADBUFFER)(GCM->vtbl[64]))

typedef BOOL (WINAPI *GCTVLOADBUFFER)(struct Event *bt, char *buff, int buffsize);
#define gcTVLoadBuffer ((GCTVLOADBUFFER)(GCM->vtbl[65]))

typedef void (WINAPI *GCMESSAGEBOX)(LPCTSTR str,...);
#define gcMessageBox ((GCMESSAGEBOX)(GCM->vtbl[66]))

#define GCCOM_COMMAND	0
#define GCCOM_EVENT		1
#define GCCOM_VISUAL		2
#define GCCOM_LTWH		3
typedef BOOL (WINAPI *GCADDSYNTAX)(char *dllName, int comType, char *comTemplate);
#define gcAddSyntax ((GCADDSYNTAX)(GCM->vtbl[67]))

typedef void (WINAPI *GCENCRYPTBUFFER)(BYTE *buff, DWORD len);
#define gcEncryptBuffer ((GCENCRYPTBUFFER)(GCM->vtbl[68]))

// used by exes using g4c.dll
typedef struct resHolder * (WINAPI *GCGETRESOURCE)(void);
#define gcGetResource ((GCGETRESOURCE)(GCM->vtbl[69]))

// used by exes using g4c.dll
typedef BOOL (WINAPI *GCRUNFIRSTGUI)(struct resHolder *myres);
#define gcRunFirstGui ((GCRUNFIRSTGUI)(GCM->vtbl[70]))

typedef struct myBuffer * (WINAPI *GCBUFFERFIND)(char *buffname, BOOL report);
#define gcBufferFind ((GCBUFFERFIND)(GCM->vtbl[71]))

typedef struct myBuffer * (WINAPI *GCBUFFERCREATE)(char *buffname, BYTE *data, int bytes, BOOL overwrite);
#define gcBufferCreate ((GCBUFFERCREATE)(GCM->vtbl[72]))

typedef int (WINAPI *GCBUFFERCOMMAND)(long com, char *arg1, char *arg2, char *arg3);
#define gcBufferCommand ((GCBUFFERCOMMAND)(GCM->vtbl[73]))

#define color_BACKGROUND 3 
#define color_FOREGROUND 0
typedef DWORD (WINAPI *GCGETEVENTCOLOR)(struct Event *bt, int whichColor);
#define gcGetEventColor ((GCGETEVENTCOLOR)(GCM->vtbl[74]))

typedef COLORREF (WINAPI *GCREADCOLORSTRING)(char *spec); // 30/256/200 or #12
#define gcReadColorString ((GCREADCOLORSTRING)(GCM->vtbl[75]))

typedef LONG (WINAPI *GCSETBOUNDS)(LONG is, LONG min, LONG max);
#define gcSetBounds ((GCSETBOUNDS)(GCM->vtbl[76]))

typedef struct guifile * (WINAPI *GCFINDGUI)(BOOL report, char *name);
#define gcFindGui ((GCFINDGUI)(GCM->vtbl[77]))

#define kPROGRESS		MakeID('P','R','O','G')	// ktype
#define kCOMBO			MakeID('C','O','M','B')	// 
#define kBUTTON		MakeID('B','U','T','T')	// 
#define kRADIO			MakeID('R','A','D','I')	// 
#define kCHECK			MakeID('C','H','E','C')	// 
#define kSPIN			MakeID('S','P','I','N')	// 
#define kNORMAL		MakeID('N','O','R','M')	// kstate
#define kPUSHED		MakeID('P','U','S','H')	// 
typedef void (WINAPI *GCTHEMEDRAW)(HWND hWnd, HDC hdc, RECT *rc, int ktype, int kstate, DWORD val);
#define gcThemeDraw ((GCTHEMEDRAW)(GCM->vtbl[78]))

#define kCENTER		MakeID('C','E','N','T')	// justify
#define kMIDDLE		MakeID('M','I','D','D')	// 
#define kRIGHT			MakeID('R','I','G','H')	// 
#define kLEFT			MakeID('L','E','F','T')	// 
typedef int (WINAPI *GCDRAWFANCYTEXT)(HDC hdc, char *text, char *icon, char *font, char *color, RECT *rc, long justify);
#define gcDrawFancyText ((GCDRAWFANCYTEXT)(GCM->vtbl[79]))





