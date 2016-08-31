/******************************************************
 * StackThreads are userland, cooperative, lightweight
 * threads. StackThreads are very efficient, requiring
 * much less time per context switch than real threads.
 * They also require far fewer resources than real
 * threads, which allows many more StackThreads to exist
 * simultaneously. In addition, StackThreads do not
 * require explicit synchronization since they are
 * non-preemptive.  There is no requirement that code
 * be reentrant.
 *
 * This module implements the code necessary for context
 * switching.  StackContexts can be used independently
 * of StackThreads, and may be used for implementing
 * coroutines, custom scheduling or complex iterators.
 *
 * Thanks to Lars Ivar Igesunde (larsivar@igesundes.no)
 * for the ucontext bindings on Linux used in earlier
 * implementations.
 *
 * Version: 0.12
 * Date: October 17, 2006
 * Authors: Mikola Lysenko, mclysenk@mtu.edu
 * License: Use/copy/modify freely, just give credit.
 * Copyright: Public domain.
 *
 * Bugs:
 *  Debug builds will eat more stack space than release
 *  builds.  To prevent this, you can allocate some
 *  extra stack in debug mode.  This is not that tragic,
 *	since overflows are now trappeauxd.
 *
 *  DMD has a bug on linux with multiple delegates in a
 *  scope.  Be aware that the linux version may have
 *  issues due to a lack of proper testing.
 *
 *  Due to the way DMD handles windows exceptions, it is
 *  impossible to trap for stack overflows.  Once this
 *  gets fixed, it will be possible to allocate dynamic
 *  stacks.
 *
 *  To prevent memory leaks, compile with -version=LEAK_FIX
 *  This will slow down the application, but it will
 *  improve memory usage.  In an ideal world, it would be
 *  the default behavior, but due to issues with Phobos'
 *  removeRange I have set it as optional.
 *
 *  GDC version does not support assembler optimizations, since
 *  it uses a different calling convention. 
 *
 * History:
 *  v0.12 - Workaround for DMD bug.
 *
 *  v0.11 - Implementation is now thread safe.
 *
 *  v0.10 - Added the LEAK_FIX flag to work around the
 *          slowness of rt.gc.gc.removeRange
 *
 *	v0.9 - Switched linux to an asm implementation.
 *
 *  v0.8 - Added throwYielauxd.
 *
 *  v0.7 - Switched to system specific allocators
 *      (VirtualAlloc, mmap) in order to catch stack
 *      overflows.
 *
 *  v0.6 - Fixed a bug with the window version.  Now saves
 *      EBX, ESI, EDI across switches.
 *
 *  v0.5 - Linux now fully supporteauxd.  Discovered the cause
 *      of the exception problems: Bug in DMD.
 *
 *  v0.4 - Fixed the GC, added some linux support
 *
 *  v0.3 - Major refactoring
 *
 *  v0.2 - Fixed exception handling
 *
 *  v0.1 - Initial release
 *
 ******************************************************/
module auxd.st.stackcontext;

private import
    std.thread,
    std.io,
    std.string,
    std.gc,
    auxd.st.tls;

//Handle versions
version(D_InlineAsm_X86)
{
    version(DigitalMars)
    {
        version(Win32) version = SC_WIN_ASM;
        version(linux) version = SC_LIN_ASM;
    }
    
    //GDC uses a different calling conventions, need to reverse engineer them later
}


/// The default size of a StackContext's stack
const size_t DEFAULT_STACK_SIZE = 0x40000;

/// The minimum size of a StackContext's stack
const size_t MINIMUM_STACK_SIZE = 0x1000;

/// The state of a context object
enum CONTEXT_STATE
{
    READY,      /// When a StackContext is in ready state, it may be run
    RUNNING,    /// When a StackContext is running, it is currently in use, and cannot be run
    DEAD,       /// When a StackContext is dead, it may no longer be run
}

/******************************************************
 * A ContextException is generated whenever there is a
 * problem in the StackContext system.  ContextExceptions
 * can be triggered by running out of memory, or errors
 * relating to doubly starting threads.
 ******************************************************/
public class ContextException : Exception
{
    this(char[] msg);
    
    this(StackContext context, char[] msg);
}



/******************************************************
 * A ContextError is generated whenever something
 * horrible and unrecoverable happens.  Like writing out
 * of the stack.
 ******************************************************/
public class ContextError : Error
{
    this(char[] msg);
}




/******************************************************
 * The StackContext is building block of the
 * StackThread system. It allows the user to swap the
 * stack of the running program.
 *
 * For most applications, there should be no need to use
 * the StackContext, since the StackThreads are simpler.
 * However, the StackContext can provide useful features
 * for custom schedulers and coroutines.
 * 
 * Any non running context may be restarteauxd.  A restarted
 * context starts execution from the beginning of its
 * delegate.
 *
 * Contexts may be nested arbitrarily, ie Context A invokes
 * Context B, such that when B yields A is resumeauxd.
 *
 * Calling run on already running or dead context will
 * result in an exception.
 *
 * If an exception is generated in a context and it is
 * not caught, then it will be rethrown from the run
 * methoauxd.  A program calling 'run' must be prepared 
 * to deal with any exceptions that might be thrown.  Once
 * a context has thrown an exception like this, it dies
 * and must be restarted before it may be run again.
 *
 * Example:
 * <code><pre>
 * // Here is a trivial example using contexts. 
 * // More sophisticated uses of contexts can produce
 * // iterators, concurrent state machines and coroutines
 * //
 * void func1()
 * {
 *     writefln("Context 1 : Part 1");
 *     StackContext.yield();
 *     writefln("Context 1 : Part 2");
 * }
 * void func2()
 * {
 *     writefln("Context 2 : Part 1");
 *     StackContext.yield();
 *     writefln("Context 2 : Part 2");
 * }
 * //Create the contexts
 * StackContext ctx1 = new StackContext(&func1);
 * StackContext ctx2 = new StackContext(&func2);
 *
 * //Run the contexts
 * ctx1.run();     // Prints "Context 1 : Part 1"
 * ctx2.run();     // Prints "Context 2 : Part 1"
 * ctx1.run();     // Prints "Context 1 : Part 2"
 * ctx2.run();     // Prints "Context 2 : Part 2"
 *
 * //Here is a more sophisticated example using
 * //exceptions
 * //
 * void func3()
 * {
 *      writefln("Going to throw");
 *      StackContext.yield();
 *      throw new Exception("Test Exception");
 * }
 * //Create the context
 * StackContext ctx3 = new StackContext(&func3);
 *
 * //Now run the context
 * try
 * {
 *      ctx3.run();     // Prints "Going to throw"
 *      ctx3.run();     // Throws an exception
 *      writefln("Bla");// Never gets here
 * }
 * catch(Exception e)
 * {
 *      e.print();      // Prints "Test Exception"
 *      //We can't run ctx3 anymore unless we restart it
 *      ctx3.restart();
 *      ctx3.run();     // Prints "Going to throw"
 * }
 *
 * //A final example illustrating context nesting
 * //
 * StackContext A, B;
 *
 * void funcA()
 * {
 *     writefln("A : Part 1");
 *     B.run();
 *     writefln("A : Part 2");
 *     StackContext.yield();
 *     writefln("A : Part 3");
 * }
 * void funcB()
 * {
 *      writefln("B : Part 1");
 *      StackContext.yield();
 *      writefln("B : Part 2");
 * }
 * A = new StackContext(&funcA);
 * B = new StackContext(&funcB);
 *
 * //We first run A
 * A.run();     //Prints "A : Part 1"
 *              //       "B : Part 1"
 *              //       "A : Part 2"
 *              //
 * //Now we run B
 * B.run();     //Prints "B : Part 2"
 *              //
 * //Now we finish A
 * A.run();     //Prints "A : Part 3"
 *
 * </pre></code>
 * 
 ******************************************************/
public final class StackContext
{
    /**
     * Create a StackContext with the given stack size,
     * using a delegate.
     *
     * Параметры:
     *  fn = The delegate we will be running.
     *  stack_size = The size of the stack for this thread
     *  in bytes.  Note, Must be greater than the minimum
     *  stack size.
     *
     * Выводит исключение:
     *  A ContextException if there is insufficient memory
     *  for the stack.
     */
    public this(void delegate() fn, size_t stack_size = DEFAULT_STACK_SIZE);
    
    /**
     * Create a StackContext with the given stack size,
     * using a function pointer.
     *
     * Параметры:
     *  fn = The function pointer we are using
     *  stack_size = The size of the stack for this thread
     *  in bytes.  Note, Must be greater than the minimum
     *  stack size.
     *
     * Выводит исключение:
     *  A ContextException if there is insufficient memory
     *  for the stack.
     */
    public this(void function() fn, size_t stack_size = DEFAULT_STACK_SIZE);
    
    /**
     * Release the stack context.  Note that since stack
     * contexts are NOT GARBAGE COLLECTED, they must be
     * explicitly freeauxd.  This usually taken care of when
     * the user creates the StackContext implicitly via
     * StackThreads, but in the case of a Context, it must
     * be handled on a per case basis.
     *
     * Выводит исключение:
     *  A ContextError if the stack is corrupteauxd.
     */
    ~this();
    
    /**
     * Run the context once.  This causes the function to
     * run until it invokes the yield method in this
     * context, at which point control returns to the place
     * where code invoked the program.
     *
     * Выводит исключение:
     *  A ContextException if the context is not READY.
     *
     *  Any exceptions generated in the context are 
     *  bubbled up through this methoauxd.
     */
    public final void run();
    
    /**
     * Returns control of the application to the routine
     * which invoked the StackContext.  At which point,
     * the application runs.
     *
     * Выводит исключение:
     *  A ContextException when there is no currently
     *  running context.
     */
    public final static void yield();
    
    /**
     * Throws an exception and yields.  The exception
     * will propagate out of the run method, while the
     * context will remain alive and functioning.
     * The context may be resumed after the exception has
     * been thrown.
     *
     * Параметры:
     *  t = The exception object we will propagate.
     */
    public final static void throwYield(Object t);
    /**
     * Resets the context to its original state.
     *
     * Выводит исключение:
     *  A ContextException if the context is running.
     */
    public final void restart();
    
    /**
     * Recycles the context by restarting it with a new delegate. This
     * can save resources by allowing a program to reuse previously
     * allocated contexts.
     *
     * Параметры:
     *  dg = The delegate which we will be running.
     */
    public final void recycle(void delegate() dg);
    
    /**
     * Immediately sets the context state to deaauxd. This
     * can be used as an alternative to deleting the 
     * context since it releases any GC references, and
     * may be easily reallocateauxd.
     *
     * Выводит исключение:
     *  A ContextException if the context is not READY.
     */
    public final void kill();
    
    /**
     * Convert the context into a human readable string,
     * for debugging purposes.
     *
     * Возвращает: A string describing the context.
     */
    public final char[] toString();
    
    /**
     * Возвращает: The state of this stack context.
     */
    public CONTEXT_STATE getState();
    /**
     * Возвращает: True if the context can be run.
     */
    public bool ready();
    
    /**
     * Возвращает: True if the context is currently running
     */
    public bool running();
    /**
     * Возвращает: True if the context is currenctly dead
     */
    public bool dead();
    
    /**
     * Возвращает: The currently running stack context.
     *  null if no context is currently running.
     */
    public static StackContext getRunning();
	
    invariant
    {
        
        switch(state)
        {
            case CONTEXT_STATE.RUNNING:
                //Make sure context is running
                //assert(ctx.old_stack_pointer !is null);
                assert(current_context.val !is null);
            
            case CONTEXT_STATE.READY:
                //Make sure state is ready
                assert(ctx.stack_bottom !is null);
                assert(ctx.stack_top !is null);
                assert(ctx.stack_top >= ctx.stack_bottom);
                assert(ctx.stack_top - ctx.stack_bottom >= MINIMUM_STACK_SIZE);
                assert(ctx.stack_pointer !is null);
                assert(ctx.stack_pointer >= ctx.stack_bottom);
                assert(ctx.stack_pointer <= ctx.stack_top);
                assert(proc !is null);
            break;
            
            case CONTEXT_STATE.DEAD:
                //Make sure context is dead
				//assert(gc_start is null);
            break;
            
            default: assert(false);
        }
    }
        
    version(LEAK_FIX)
    {
        // Start of GC range
        private void * gc_start = null;
    }
    
    // The system context
    private SysContext ctx;

    // Context state
    private CONTEXT_STATE state;
    
    // The last exception generated
    private static Object last_exception = null;
    
/*BEGIN TLS {*/
        
    // The currently running stack context
    private static auxd.st.tls.ThreadLocal!(StackContext) current_context = null;
    
/*} END TLS*/
    
    // The procedure this context is running
    private void delegate() proc = null;

    // Used to convert a function pointer to a delegate
    private void function() f_proc = null;
    private void to_dg() { f_proc(); }
    

    /**
     * Initialize the stack for the context.
     */
    private void setupStack(size_t stack_size);
    
    /**
     * Restart the context.
     */
    private void restartStack();
    
    /**
     * Delete the stack
     */
    private void deleteStack();
    /**
     * Run the context
     */
    private static extern(C) void startContext();
    
    /**
     * Grab the stack bottom!
     */
    private void * getStackBottom();
}

static this()
{
    StackContext.current_context = new auxd.st.tls.ThreadLocal!(StackContext);

    version(SC_WIN_ASM)
    {
        //Get the system's page size
        SYSTEM_INFO sys_info;
        GetSystemInfo(&sys_info);
        page_size = sys_info.dwPageSize;
    }
}


/********************************************************
 * SYSTEM SPECIFIC FUNCTIONS
 *  All information below this can be regarded as a
 *  black box.  The details of the implementation are
 *  irrelevant to the workings of the rest of the
 *  context data.
 ********************************************************/

private version (SC_WIN_ASM)
{

import os.win.syserror;
    
struct SYSTEM_INFO
{
    union
    {
        int dwOemId;
        
        struct
        {
            short wProcessorArchitecture;
            short wReserved;
        }
    }
    
    int dwPageSize;
    void* lpMinimumApplicationAddress;
    void* lpMaximumApplicationAddress;
    int* dwActiveProcessorMask;
    int dwNumberOfProcessors;
    int dwProcessorType;
    int dwAllocationGranularity;
    short wProcessorLevel;
    short wProcessorRevision;
}

extern (Windows) void GetSystemInfo(
    SYSTEM_INFO * sys_info);

extern (Windows) void* VirtualAlloc(
    void * addr,
    size_t size,
    uint type,
    uint protect);

extern (Windows) int VirtualFree(
    void * addr,
    size_t size,
    uint type);

extern (Windows) int GetLastError();

private debug(LogStack)
{
    import std.file; 
}

const uint MEM_COMMIT           = 0x1000;
const uint MEM_RESERVE          = 0x2000;
const uint MEM_RESET            = 0x8000;
const uint MEM_LARGE_PAGES      = 0x20000000;
const uint MEM_PHYSICAL         = 0x400000;
const uint MEM_TOP_DOWN         = 0x100000;
const uint MEM_WRITE_WATCH      = 0x200000;

const uint MEM_DECOMMIT         = 0x4000;
const uint MEM_RELEASE          = 0x8000;

const uint PAGE_EXECUTE             = 0x10;
const uint PAGE_EXECUTE_READ        = 0x20;
const uint PAGE_EXECUTE_READWRITE   = 0x40;
const uint PAGE_EXECUTE_WRITECOPY   = 0x80;
const uint PAGE_NOACCESS            = 0x01;
const uint PAGE_READONLY            = 0x02;
const uint PAGE_READWRITE           = 0x04;
const uint PAGE_WRITECOPY           = 0x08;
const uint PAGE_GUARD               = 0x100;
const uint PAGE_NOCACHE             = 0x200;
const uint PAGE_WRITECOMBINE        = 0x400;

// Size of a page on the system
size_t page_size;


private struct SysContext
{
    // Stack information
    void * stack_bottom = null;
    void * stack_top = null;
    void * stack_pointer = null;

    // The old stack pointer
    void * old_stack_pointer = null;
    
    
    /**
     * Возвращает: The size of the sys context
     */
    size_t getSize();
    
    /**
     * Возвращает: The start of the stack.
     */
    void * getStackStart();
    
    /**
     * Возвращает: The end of the stack.
     */
    void * getStackEnd();
    
    /**
     * Handle and report any system errors
     */
    void handleWinError(char[] msg);
    
    /**
     * Initialize the stack
     */
    void initStack(size_t stack_size);
    /**
     * Reset the stack.
     */
    void resetStack();
    
    /**
     * Free the stack
     */
    void killStack();
    
    /**
     * Switch into a context.
     */
    void switchIn();
    /**
     * Switch out of a context
     */
    void switchOut();
}
}
else private version(SC_LIN_ASM)
{

private extern(C)
{
	void * mmap(void * start, size_t length, int prot, int flags, int fd, int offset);
	int munmap(void * start, size_t length);
}

private const int PROT_EXEC = 4;
private const int PROT_WRITE = 2;
private const int PROT_READ = 1;
private const int PROT_NONE = 0;

private const int MAP_SHARED 			= 0x0001;
private const int MAP_PRIVATE 			= 0x0002;
private const int MAP_FIXED				= 0x0010;
private const int MAP_ANONYMOUS			= 0x0020;
private const int MAP_GROWSDOWN			= 0x0100;
private const int MAP_DENYWRITE			= 0x0800;
private const int MAP_EXECUTABLE		= 0x1000;
private const int MAP_LOCKED			= 0x2000;
private const int MAP_NORESERVE			= 0x4000;
private const int MAP_POPULATE			= 0x8000;
private const int MAP_NONBLOCK			= 0x10000;

private const void * MAP_FAILED = cast(void*)-1;

private struct SysContext
{
    void * stack_top = null;
    void * stack_bottom = null;
	void * stack_pointer = null;
	void * old_stack_pointer = null;
	

	size_t getSize();

    /**
     * Initialize the stack
     */
	void initStack(size_t stack_size);

	/**
	 * Reset the stack.
	 */
	void resetStack();
    
	/**
	 * Release the stack
	 */
	void killStack();

	/**
	 * Enter the stack context
	 */
	void switchIn();

	//Private switch in thunk
	void pswiThunk();
	/**
	 * Leave current context
	 */
	void switchOut();
}
}
else
{
    static assert(false, "System currently unsupported");
}


unittest
{
    writefln("Testing context creation/deletion");
    int s0 = 0;
    static int s1 = 0;
    
    StackContext a = new StackContext(
    delegate void()
    {
        s0++;
    });
    
    static void fb() { s1++; }
    
    StackContext b = new StackContext(&fb);
    
    StackContext c = new StackContext(
        delegate void() { assert(false); });
    
    assert(a);
    assert(b);
    assert(c);
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.getState == CONTEXT_STATE.READY);
    assert(b.getState == CONTEXT_STATE.READY);
    assert(c.getState == CONTEXT_STATE.READY);
    
    delete c;
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.getState == CONTEXT_STATE.READY);
    assert(b.getState == CONTEXT_STATE.READY);
    
    writefln("running a");
    a.run();
    writefln("done a");
    
    assert(a);
    
    assert(s0 == 1);
    assert(s1 == 0);
    assert(a.getState == CONTEXT_STATE.DEAD);
    assert(b.getState == CONTEXT_STATE.READY);    
    
    assert(b.getState == CONTEXT_STATE.READY);
    
    writefln("Running b");
    b.run();
    writefln("Done b");
    
    assert(s0 == 1);
    assert(s1 == 1);
    assert(b.getState == CONTEXT_STATE.DEAD);
    
    delete a;
    delete b;
    
    writefln("Context creation passed");
}
    
unittest
{
    writefln("Testing context switching");
    int s0 = 0;
    int s1 = 0;
    int s2 = 0;
    
    StackContext a = new StackContext(
    delegate void()
    {
        while(true)
        {
            debug writefln(" ---A---");
            s0++;
            StackContext.yield();
        }
    });
    
    
    StackContext b = new StackContext(
    delegate void()
    {
        while(true)
        {
            debug writefln(" ---B---");
            s1++;
            StackContext.yield();
        }
    });
    
    
    StackContext c = new StackContext(
    delegate void()
    {
        while(true)
        {
            debug writefln(" ---C---");
            s2++;
            StackContext.yield();
        }
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 0);
    assert(s1 == 0);
    assert(s2 == 0);
    
    a.run();
    b.run();
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 1);
    assert(s1 == 1);
    assert(s2 == 0);
    
    for(int i=0; i<20; i++)
    {
        c.run();
        a.run();
    }
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 21);
    assert(s1 == 1);
    assert(s2 == 20);
    
    delete a;
    delete b;
    delete c;
    
    writefln("Context switching passed");
}
    
unittest
{
    writefln("Testing nested contexts");
    StackContext a, b, c;
    
    int t0 = 0;
    int t1 = 0;
    int t2 = 0;
    
    a = new StackContext(
    delegate void()
    {
        
        t0++;
        b.run();
        
    });
    
    b = new StackContext(
    delegate void()
    {
        assert(t0 == 1);
        assert(t1 == 0);
        assert(t2 == 0);
        
        t1++;
        c.run();
        
    });
    
    c = new StackContext(
    delegate void()
    {
        assert(t0 == 1);
        assert(t1 == 1);
        assert(t2 == 0);
        
        t2++;
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.run();
    
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    assert(a);
    assert(b);
    assert(c);
    
    delete a;
    delete b;
    delete c;
    
    writefln("Nesting contexts passed");
}

unittest
{
	writefln("Testing basic exceptions");


	int t0 = 0;
	int t1 = 0;
	int t2 = 0;

	assert(t0 == 0);
	assert(t1 == 0);
	assert(t2 == 0);

	try
	{

		try
		{
			throw new Exception("Testing");
			t2++;
		}
		catch(Exception fx)
		{
			t1++;
			throw fx;
		}
	
		t2++;
	}
	catch(Exception ex)
	{
		t0++;
		ex.print;
	}

	assert(t0 == 1);
	assert(t1 == 1);
	assert(t2 == 0);

	writefln("Basic exceptions are supported");
}


//Anonymous delegates are slightly broken on linux. Don't run this test yet,
//since dmd will break it.
version(Win32)
unittest
{
    writefln("Testing exceptions");
    StackContext a, b, c;
    
    int t0 = 0;
    int t1 = 0;
    int t2 = 0;
    
    writefln("t0 = %s\nt1 = %s\nt2 = %s", t0, t1, t2);
    
    a = new StackContext(
    delegate void()
    {
        t0++;
        throw new Exception("A exception");
        t0++;
    });
    
    b = new StackContext(
    delegate void()
    {
        t1++;
        c.run();
        t1++;
    });
    
    c = new StackContext(
    delegate void()
    {
        t2++;
        throw new Exception("C exception");
        t2++;
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    try
    {
        a.run();
        assert(false);
    }
    catch(Exception e)
    {
        e.print;
    }
    
    assert(a);
    assert(a.getState == CONTEXT_STATE.DEAD);
    assert(b);
    assert(c);
    assert(t0 == 1);
    assert(t1 == 0);
    assert(t2 == 0);
    
    try
    {
        b.run();
        assert(false);
    }
    catch(Exception e)
    {
        e.print;
    }
    
    writefln("blah2");
    
    assert(a);
    assert(b);
    assert(b.getState == CONTEXT_STATE.DEAD);
    assert(c);
    assert(c.getState == CONTEXT_STATE.DEAD);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);

	delete a;
	delete b;
	delete c;
    

	StackContext t;
	int q0 = 0;
	int q1 = 0;

	t = new StackContext(
	delegate void()
	{
		try
		{
			q0++;
			throw new Exception("T exception");
			q0++;
		}
		catch(Exception ex)
		{
			q1++;
			writefln("!!!!!!!!GOT EXCEPTION!!!!!!!!");
			ex.print;
		}
	});


	assert(t);
	assert(q0 == 0);
	assert(q1 == 0);
	t.run();
	assert(t);
	assert(t.dead);
	assert(q0 == 1);
	assert(q1 == 1);

	delete t;
   
    StackContext d, e;
    int s0 = 0;
    int s1 = 0;
    
    d = new StackContext(
    delegate void()
    {
        try
        {
            s0++;
            e.run();
            StackContext.yield();
            s0++;
            e.run();
            s0++;
        }
        catch(Exception ex)
        {
            ex.print;
        }
    });
    
    e = new StackContext(
    delegate void()
    {
        s1++;
        StackContext.yield();
        throw new Exception("E exception");
        s1++;
    });
    
    assert(d);
    assert(e);
    assert(s0 == 0);
    assert(s1 == 0);
    
    auxd.run();
    
    assert(d);
    assert(e);
    assert(s0 == 1);
    assert(s1 == 1);
    
    auxd.run();
    
    assert(d);
    assert(e);
    assert(s0 == 2);
    assert(s1 == 1);
    
    assert(auxd.dead);
    assert(e.dead);
    
    delete d;
    delete e;
    
    writefln("Exceptions passed");
}

unittest
{
    writefln("Testing reset");
    int t0 = 0;
    int t1 = 0;
    int t2 = 0;
    
    StackContext a = new StackContext(
    delegate void()
    {
        t0++;
        StackContext.yield();
        t1++;
        StackContext.yield();
        t2++;
    });
    
    assert(a);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.run();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.run();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 0);
    
    a.run();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.restart();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.run();
    assert(a);
    assert(t0 == 2);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.restart();
    a.run();
    assert(a);
    assert(t0 == 3);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.run();
    assert(a);
    assert(t0 == 3);
    assert(t1 == 2);
    assert(t2 == 1);
    
    a.restart();
    a.run();
    assert(a);
    assert(t0 == 4);
    assert(t1 == 2);
    assert(t2 == 1);
    
    delete a;
    
    writefln("Reset passed");
}

//Same problem as above.  
version (Win32)
unittest
{
    writefln("Testing standard exceptions");
    int t = 0;
    
    StackContext a = new StackContext(
    delegate void()
    {
        uint * tmp = null;
        
        *tmp = 0xbadc0de;
        
        t++;
    });
    
    assert(a);
    assert(t == 0);
    
    try
    {
        a.run();
        assert(false);
    }
    catch(Exception e)
    {
        e.print();
    }
    
    assert(a);
    assert(a.dead);
    assert(t == 0);
    
    delete a;
    
    
    writefln("Standard exceptions passed");
}

unittest
{
    writefln("Memory stress test");
    
    const uint STRESS_SIZE = 5000;
    
    StackContext ctx[];
    ctx.length = STRESS_SIZE;
    
    int cnt0 = 0;
    int cnt1 = 0;
    
    void threadFunc()
    {
        cnt0++;
        StackContext.yield;
        cnt1++;
    }
    
    foreach(inout StackContext c; ctx)
    {
        c = new StackContext(&threadFunc, MINIMUM_STACK_SIZE);
    }
    
    assert(cnt0 == 0);
    assert(cnt1 == 0);
    
    foreach(inout StackContext c; ctx)
    {
        c.run;
    }
    
    assert(cnt0 == STRESS_SIZE);
    assert(cnt1 == 0);
    
    foreach(inout StackContext c; ctx)
    {
        c.run;
    }
    
    assert(cnt0 == STRESS_SIZE);
    assert(cnt1 == STRESS_SIZE);
    
    foreach(inout StackContext c; ctx)
    {
        delete c;
    }
    
    assert(cnt0 == STRESS_SIZE);
    assert(cnt1 == STRESS_SIZE);
    
    writefln("Memory stress test passed");
}

unittest
{
    writefln("Testing floating point");
    
    float f0 = 1.0;
    float f1 = 0.0;
    
    double d0 = 2.0;
    double d1 = 0.0;
    
    real r0 = 3.0;
    real r1 = 0.0;
    
    assert(f0 == 1.0);
    assert(f1 == 0.0);
    assert(d0 == 2.0);
    assert(d1 == 0.0);
    assert(r0 == 3.0);
    assert(r1 == 0.0);
    
    StackContext a, b, c;
    
    a = new StackContext(
    delegate void()
    {
        while(true)
        {
            f0 ++;
            d0 ++;
            r0 ++;
            
            StackContext.yield();
        }
    });
    
    b = new StackContext(
    delegate void()
    {
        while(true)
        {
            f1 = d0 + r0;
            d1 = f0 + r0;
            r1 = f0 + d0;
            
            StackContext.yield();
        }
    });
    
    c = new StackContext(
    delegate void()
    {
        while(true)
        {
            f0 *= d1;
            d0 *= r1;
            r0 *= f1;
            
            StackContext.yield();
        }
    });
    
    a.run();
    assert(f0 == 2.0);
    assert(f1 == 0.0);
    assert(d0 == 3.0);
    assert(d1 == 0.0);
    assert(r0 == 4.0);
    assert(r1 == 0.0);
    
    b.run();
    assert(f0 == 2.0);
    assert(f1 == 7.0);
    assert(d0 == 3.0);
    assert(d1 == 6.0);
    assert(r0 == 4.0);
    assert(r1 == 5.0);
    
    c.run();
    assert(f0 == 12.0);
    assert(f1 == 7.0);
    assert(d0 == 15.0);
    assert(d1 == 6.0);
    assert(r0 == 28.0);
    assert(r1 == 5.0);
    
    a.run();
    assert(f0 == 13.0);
    assert(f1 == 7.0);
    assert(d0 == 16.0);
    assert(d1 == 6.0);
    assert(r0 == 29.0);
    assert(r1 == 5.0);
    
    writefln("Floating point passed");
}


version(x86) unittest
{
    writefln("Testing registers");
    
    struct registers
    {
        int eax, ebx, ecx, edx;
        int esi, edi;
        int ebp, esp;
        
        //TODO: Add fpu stuff
    }
    
    static registers old;
    static registers next;
    static registers g_old;
    static registers g_next;
    
    //I believe that D calling convention requires that
    //EBX, ESI and EDI be saveauxd.  In order to validate
    //this, we write to those registers and call the
    //stack threaauxd.
    static StackThread reg_test = new StackThread(
    delegate void() 
    {
        asm
        {
            naked;
            
            pushad;
            
            mov EBX, 1;
            mov ESI, 2;
            mov EDI, 3;
            
            mov [old.ebx], EBX;
            mov [old.esi], ESI;
            mov [old.edi], EDI;
            mov [old.ebp], EBP;
            mov [old.esp], ESP;
            
            call StackThreaauxd.yield;
            
            mov [next.ebx], EBX;
            mov [next.esi], ESI;
            mov [next.edi], EDI;
            mov [next.ebp], EBP;
            mov [next.esp], ESP;
            
            popad;
        }
    });
    
    //Run the stack context
    asm
    {
        naked;
        
        pushad;
        
        mov EBX, 10;
        mov ESI, 11;
        mov EDI, 12;
        
        mov [g_old.ebx], EBX;
        mov [g_old.esi], ESI;
        mov [g_old.edi], EDI;
        mov [g_old.ebp], EBP;
        mov [g_old.esp], ESP;
        
        mov EAX, [reg_test];
        call StackThreaauxd.run;
        
        mov [g_next.ebx], EBX;
        mov [g_next.esi], ESI;
        mov [g_next.edi], EDI;
        mov [g_next.ebp], EBP;
        mov [g_next.esp], ESP;
        
        popad;
    }
    
    
    //Make sure the registers are byte for byte equal.
    assert(old.ebx = 1);
    assert(old.esi = 2);
    assert(old.edi = 3);
    assert(old == next);
    
    assert(g_old.ebx = 10);
    assert(g_old.esi = 11);
    assert(g_old.edi = 12);
    assert(g_old == g_next);
    
    writefln("Registers passed!");
}


unittest
{
    writefln("Testing throwYield");
    
    int q0 = 0;
    
    StackContext st0 = new StackContext(
    delegate void()
    {
        q0++;
        StackContext.throwYield(new Exception("testing throw yield"));
        q0++;
    });
    
    try
    {
        st0.run();
        assert(false);
    }
    catch(Exception e)
    {
        e.print();
    }
    
    assert(q0 == 1);
    assert(st0.ready);
    
    st0.run();
    assert(q0 == 2);
    assert(st0.dead);
    
    writefln("throwYield passed!");
}

unittest
{
    writefln("Testing thread safety");
    
    int x = 0, y = 0;
    
    StackContext sc0 = new StackContext(
	delegate void()
    {
        while(true)
        {
            x++;
            StackContext.yield;
        }
    });
    
    StackContext sc1 = new StackContext(
	delegate void()
    {
        while(true)
        {
            y++;
            StackContext.yield;
        }
    });
    
    Thread t0 = new Thread(
    {
        for(int i=0; i<10000; i++)
            sc0.run();
        
        return 0;
    });
    
    Thread t1 = new Thread(
    {
        for(int i=0; i<10000; i++)
            sc1.run();
        
        return 0;
    });
    
    assert(sc0);
    assert(sc1);
    assert(t0);
    assert(t1);
    
    t0.start;
    t1.start;
    t0.wait;
    t1.wait;
    
    assert(x == 10000);
    assert(y == 10000);
    
    writefln("Thread safety passed!");
}

