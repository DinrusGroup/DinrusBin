/**
	DLL Loader for Windows support of OMF Implibs
	
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2006 Eric Anderton
*/
module ddl.omf.DLLProvider;

version(Windows){
	extern (Windows)
	{
		alias uint HANDLE;
		alias HANDLE HMODULE;
		alias int BOOL;
		alias int (*FARPROC)();
		alias void* LPCSTR;
		FARPROC GetProcAddress(HMODULE hModule, LPCSTR lpProcName);
		HMODULE LoadLibraryA(LPCSTR lpLibFileName);
		BOOL FreeLibrary(HMODULE hLibModule);
	}
	
	class DLLProvider{
		static HANDLE[char[]] dllHandles;
		static DLLProvider instance;
		
		public static this();
		//TODO: is this valid? (is it guaranteed to be last?)
		public static ~this();
		
		public static HANDLE loadLibrary(char[] moduleName);
		
		public static void* loadModuleSymbol(char[] moduleName,char[] entryName);
		
		public static void* loadModuleSymbol(char[] moduleName,uint entryOrdinal);	
	}
}

