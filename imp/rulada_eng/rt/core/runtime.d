﻿/**
 * The runtime module exposes information specific to the D runtime code.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   <a href="http://www.boost.org/LICENSE_1_0.txt>Boost License 1.0</a>.
 * Authors:   Sean Kelly
 *
 *          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module rt.core.runtime;


private
{
    extern (C) bool rt_isHalting();

    alias bool function() ModuleUnitTester;
    alias bool function(Object) CollectHandler;
    alias Exception.TraceInfo function( void* ptr = null ) TraceHandler;

    extern (C) void rt_setCollectHandler( CollectHandler h );
    extern (C) void rt_setTraceHandler( TraceHandler h );

    alias void delegate( Exception ) ExceptionHandler;
    extern (C) bool rt_init( ExceptionHandler dg = null );
    extern (C) bool rt_term( ExceptionHandler dg = null );

    extern (C) void* rt_loadLibrary( in char[] name );
    extern (C) bool  rt_unloadLibrary( void* ptr );
	
	extern(C) void consoleInteger (ulong i);
    extern(C) void consoleString  (char[] str);
	
	extern(C) void gc_init();
	extern(C) void gc_term();
	extern(C) void _minit();
	extern(C) void _moduleCtor();
	extern(C) void _moduleUnitTests();
	
	}


///////////////////////////////////////////////////////////////////////////////
// Runtime
///////////////////////////////////////////////////////////////////////////////


/**
 * This struct encapsulates all functionality related to the underlying runtime
 * module for the calling context.
 */
struct Runtime
{

 struct Console
    {
	alias stderr стдош;
	alias console консоль;
	
        alias stderr opCall;

        Console stderr (char[] s)
        {
            consoleString (s);
            return *this;
        }

        Console stderr (ulong i)
        {
            consoleInteger (i);
            return *this;
        }
    }
        

    static Console console()
    {
        Console c;
        return c;
    }
	
    /**
     * Initializes the runtime.  This call is to be used in instances where the
     * standard program initialization process is not executed.  This is most
     * often in shared libraries or in libraries linked to a C program.
     *
     * Params:
     *  dg = A delegate which will receive any exception thrown during the
     *       initialization process or null if such exceptions should be
     *       discarded.
     *
     * Returns:
     *  true if initialization succeeds and false if initialization fails.
     */
    static bool initialize( ExceptionHandler dg = null )
    {
	version(DLL_BUILD)
	{
	gc_init();			// инициализует СМ
	    _minit();			// инициализует список модулей
	    _moduleCtor();		// запускает конструкторы модулей
	    _moduleUnitTests();		// запускает тесты модулей
	}
	else
		{
			return rt_init(dg);
		}
    }


    /**
     * Terminates the runtime.  This call is to be used in instances where the
     * standard program termination process will not be not executed.  This is
     * most often in shared libraries or in libraries linked to a C program.
     *
     * Params:
     *  dg = A delegate which will receive any exception thrown during the
     *       termination process or null if such exceptions should be
     *       discarded.
     *
     * Returns:
     *  true if termination succeeds and false if termination fails.
     */
    static bool terminate( ExceptionHandler dg = null )
    {
        return rt_term( dg );
    }


    /**
     * Returns true if the runtime is halting.  Under normal circumstances,
     * this will be set between the time that normal application code has
     * exited and before module dtors are called.
     *
     * Returns:
     *  true if the runtime is halting.
     */
    static bool isHalting()
    {
        return rt_isHalting();
    }


    /**
     * Locates a dynamic library with the supplied library name and dynamically
     * loads it into the caller's address space.  If the library contains a D
     * runtime it will be integrated with the current runtime.
     *
     * Params:
     *  name = The name of the dynamic library to load.
     *
     * Returns:
     *  A reference to the library or null on error.
     */
    static void* loadLibrary( in char[] name )
    {
        return rt_loadLibrary( name );
    }


    /**
     * Unloads the dynamic library referenced by p.  If this library contains a
     * D runtime then any necessary finalization or cleanup of that runtime
     * will be performed.
     *
     * Params:
     *  p = A reference to the library to unload.
     */
    static bool unloadLibrary( void* p )
    {
        return rt_unloadLibrary( p );
    }


    /**
     * Overrides the default trace mechanism with s user-supplied version.  A
     * trace represents the context from which an exception was thrown, and the
     * trace handler will be called when this occurs.  The pointer supplied to
     * this routine indicates the base address from which tracing should occur.
     * If the supplied pointer is null then the trace routine should determine
     * an appropriate calling context from which to begin the trace.
     *
     * Params:
     *  h = The new trace handler.  Set to null to use the default handler.
     */
    static void traceHandler( TraceHandler h )
    {
        rt_setTraceHandler( h );
    }


    /**
     * Overrides the default collect hander with a user-supplied version.  This
     * routine will be called for each resource object that is finalized in a
     * non-deterministic manner--typically during a garbage collection cycle.
     * If the supplied routine returns true then the object's dtor will called
     * as normal, but if the routine returns false than the dtor will not be
     * called.  The default behavior is for all object dtors to be called.
     *
     * Params:
     *  h = The new collect handler.  Set to null to use the default handler.
     */
    static void collectHandler( CollectHandler h )
    {
        rt_setCollectHandler( h );
    }


    /**
     * Overrides the default module unit tester with a user-supplied version.
     * This routine will be called once on program initialization.  The return
     * value of this routine indicates to the runtime whether the body of the
     * program will be executed.
     *
     * Params:
     *  h = The new unit tester.  Set to null to use the default unit tester.
     */
    static void moduleUnitTester( ModuleUnitTester h )
    {
        sm_moduleUnitTester = h;
    }


private:
    // NOTE: This field will only ever be set in a static ctor and should
    //       never occur within any but the main thread, so it is safe to
    //       make it __gshared.
    static ModuleUnitTester sm_moduleUnitTester = null;
}


///////////////////////////////////////////////////////////////////////////////
// Overridable Callbacks
///////////////////////////////////////////////////////////////////////////////


/**
 * This routine is called by the runtime to run module unit tests on startup.
 * The user-supplied unit tester will be called if one has been supplied,
 * otherwise all unit tests will be run in sequence.
 *
 * Returns:
 *  true if execution should continue after testing is complete and false if
 *  not.  Default behavior is to return true.
 */
extern (C) bool runModuleUnitTests()
{
    if( Runtime.sm_moduleUnitTester is null )
    {
        foreach( m; ModuleInfo )
        {
            if( m.unitTest )
                m.unitTest();
        }
        return true;
    }
    return Runtime.sm_moduleUnitTester();
}
