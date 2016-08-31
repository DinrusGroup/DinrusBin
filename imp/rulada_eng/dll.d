﻿// Public Domain
module dll;


import os.windows;
HINSTANCE g_hInst;


extern (C)

{ 
	void gc_init();
	void gc_term();
	void _minit();
	void _moduleCtor();
	void _moduleUnitTests();
}

extern (Windows)
BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)
{
    switch (ulReason)
    {
	case DLL_PROCESS_ATTACH:
	    gc_init();			// initialize GC
	    _minit();			// initialize module list
	    _moduleCtor();		// run module constructors
	    _moduleUnitTests();		// run module unit tests
	    break;

	case DLL_PROCESS_DETACH:
	    gc_term();			// shut down GC
	    break;

	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	    // Multiple threads not supported yet
	    return false;
		
	default: ;
    }
    g_hInst=hInstance;
    return true;
}

