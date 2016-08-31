
module std.thread;

/* ================================ Win32 ================================= */
private import os.windows: HANDLE;

version=Static;//Dynamic;

version (Dynamic)
{

extern (Windows) alias uint (*stdfp)(void *);

extern (C)    thread_hdl _beginthreadex(void* security, uint stack_size,
	stdfp start_addr, void* arglist, uint initflag,
	thread_id* thrdaddr);

private const uint  WAIT_TIMEOUT = 258;
alias HANDLE thread_hdl;
alias uint thread_id;

extern (D) class ThreadError : Error
{
    this(string s);
}

alias Thread DThread;

extern (D) class Thread
{

    this(size_t stacksize = 0);
  
    this(int (*fp)(void *), void *arg, size_t stacksize = 0);
    this(int delegate() dg, size_t stacksize = 0);
    ~this();
    thread_hdl hdl;
	uint nthreads = 1;

    void* stackBottom;

   void start();		
    int run();
    void wait();
    void wait(uint milliseconds);
	uint getNThreads();
	
    enum TS
    {
	INITIAL,	/// The thread hasn't been started yet.
	RUNNING,	/// The thread is running or paused.
	TERMINATED,	/// The thread has ended.
        FINISHED        /// The thread has been cleaned up
    }

    TS getState();

    enum PRIORITY
    {
	INCREASE,	/// Increase thread priority
	DECREASE,	/// Decrease thread priority
	IDLE,		/// Assign thread low priority
	CRITICAL,	/// Assign thread high priority
	NORMAL,
    }

    void setPriority(PRIORITY p);
    bool isSelf();
    static DThread getThis();
    static DThread[] getAll();
    void pause();
    void resume();
    static void pauseAll();
    static void resumeAll();
    static void yield();
		
	extern (Windows) static uint threadstart(void *p);

		public static void thread_init();
		
		static ~this();
		
		static thread_hdl getCurrentThreadHandle();

}


 extern (D) void *os_query_stackBottom();

}


version (Static)
{

private import os.windows, std.c;

extern (Windows) alias uint (*stdfp)(void *);

extern (C)
    thread_hdl _beginthreadex(void* security, uint stack_size,
	stdfp start_addr, void* arglist, uint initflag,
	thread_id* thrdaddr);

private const uint  WAIT_TIMEOUT = 258;

/**
 * The type of the thread handle used by the operating system.
 * For Windows, it is equivalent to a HANDLE from windows.d.
 */
alias HANDLE thread_hdl;

alias uint thread_id;

/**
 * Thrown for errors.
 */
 

class ThreadError : Error
{

    this(string s)
    {
	super("DThread error: " ~ s);
    }
}

/**
 * One of these is created for each thread. 
 */
alias  Thread DThread;

 class Thread
{

    this(size_t stacksize = 0)
    {
	this.stacksize = stacksize;	
    }

    this(int (*fp)(void *), void *arg, size_t stacksize = 0)
    {
	this.fp = fp;
	this.arg = arg;
	this.stacksize = stacksize;
	}

    this(int delegate() dg, size_t stacksize = 0)
    {
	this.dg = dg;
	this.stacksize = stacksize;	
    }

     ~this()
    {
        if (state != TS.FINISHED)
            CloseHandle(hdl);
    }

    thread_hdl hdl;

    ук stackBottom;

     void start()
    {
	synchronized (DThread.classinfo)
	{
	    if (state != TS.INITIAL)
		error("already started");

	    for (int i = 0; 1; i++)
	    {
		if (i == allThreads.length)
		    error("too many threads");
		if (!allThreads[i])
		{   allThreads[i] = this;
		    idx = i;
		    if (i >= allThreadsDim)
			allThreadsDim = i + 1;
		    break;
		}
	    }
	    nthreads++;

	    state = TS.RUNNING;
	    hdl = _beginthreadex(null, cast(uint)stacksize, &threadstart, cast(void*)this, 0, &id);
	    if (hdl == cast(thread_hdl)0)
	    {
		allThreads[idx] = null;
		nthreads--;
		state = TS.FINISHED;
		idx = -1;
		error("failed to start");
	    }
	}
    }
		
    int run()
    {
	if (fp)
	    return fp(arg);
	else if (dg)
	    return dg();
	assert(0);
    }
	
	uint getNThreads()
	{
	return nthreads;
	}

     void wait()
    {
	if (isSelf)
	    error("wait on self");
	if (state != TS.FINISHED)
	{   DWORD dw;

	    dw = WaitForSingleObject(hdl, 0xFFFFFFFF);
            state = TS.FINISHED;
            CloseHandle(hdl);
            hdl = null;
	}
    }

    /******************************
     * Wait for this thread to terminate or until milliseconds time has
     * elapsed, whichever occurs first.
     * Simply returns if thread has already terminated.
     * Выводит исключение: $(B ThreadError) if the thread hasn't begun yet or
     * is called on itself.
     */
    void wait(uint milliseconds)
    {
	if (isSelf)
	    error("wait on self");
	if (state != TS.FINISHED)
	{   DWORD dw;

	    dw = WaitForSingleObject(hdl, milliseconds);
	    if (dw != WAIT_TIMEOUT)
	    {
		state = TS.FINISHED;
		CloseHandle(hdl);
		hdl = null;
	    }
	}
    }

    /**
     * The state of a thread.
     */
    enum TS
    {
	INITIAL,	/// The thread hasn't been started yet.
	RUNNING,	/// The thread is running or paused.
	TERMINATED,	/// The thread has ended.
        FINISHED        /// The thread has been cleaned up
    }

    /**
     * Returns the state of a thread.
     */
    TS getState()
    {
	return state;
    }

    /**
     * The priority of a thread.
     */
    enum PRIORITY
    {
	INCREASE,	/// Increase thread priority
	DECREASE,	/// Decrease thread priority
	IDLE,		/// Assign thread low priority
	CRITICAL,	/// Assign thread high priority
	NORMAL,
    }

    /**
     * Adjust the priority of this thread.
     * Выводит исключение: ThreadError if cannot set priority
     */
    void setPriority(PRIORITY p)
    {
	int nPriority;

	switch (p)
	{
	    case PRIORITY.INCREASE:
		nPriority = THREAD_PRIORITY_ABOVE_NORMAL;
		break;
	    case PRIORITY.DECREASE:
		nPriority = THREAD_PRIORITY_BELOW_NORMAL;
		break;
	    case PRIORITY.IDLE:
		nPriority = THREAD_PRIORITY_IDLE;
		break;
	    case PRIORITY.CRITICAL:
		nPriority = THREAD_PRIORITY_TIME_CRITICAL;
		break;
	    case PRIORITY.NORMAL:
		nPriority = THREAD_PRIORITY_NORMAL;
		break;
	    default:
		assert(0);
	}

	if (SetThreadPriority(hdl, nPriority) == THREAD_PRIORITY_ERROR_RETURN)
	    error("set priority");
    }

    /**
     * Returns true if this thread is the current thread.
     */
    bool isSelf()
    {
	//printf("id = %d, self = %d\n", id, pthread_self());
	return (id == GetCurrentThreadId());
    }

    /**
     * Returns a reference to the DThread for the thread that called the
     * function.
     */
    static DThread getThis()
    {
	//printf("getThis(), allThreadsDim = %d\n", allThreadsDim);
        thread_id id = GetCurrentThreadId();
        for (int i = 0; i < allThreadsDim; i++)
        {
            DThread t = allThreads[i];
            if (t && id == t.id)
            {
                return t;
            }
        }
	printf("didn't find it\n");
	assert(0);
    }

    /**
     * Returns an array of all the threads currently running.
     */
    static DThread[] getAll()
    {
	synchronized (DThread.classinfo) return allThreads[0 .. allThreadsDim];
    }

    /**
     * Suspend execution of this thread.
     */
    void pause()
    {
	if (state != TS.RUNNING || SuspendThread(hdl) == 0xFFFFFFFF)
	    error("cannot pause");
    }

    /**
     * Resume execution of this thread.
     */
    void resume()
    {
	if (state != TS.RUNNING || ResumeThread(hdl) == 0xFFFFFFFF)
	    error("cannot resume");
    }

    /**
     * Suspend execution of all threads but this thread.
     */
    static void pauseAll()
    {
        synchronized (DThread.classinfo)
        {
            if (nthreads > 1)
            {
		thread_id thisid = GetCurrentThreadId();

		for (int i = 0; i < allThreadsDim; i++)
		{
		    DThread t = allThreads[i];
		    if (t && t.id != thisid && t.state == TS.RUNNING)
			t.pause();
		}
            }
        }
    }

    /**
     * Resume execution of all paused threads.
     */
    static void resumeAll()
    {
        synchronized (DThread.classinfo)
        {
            if (nthreads > 1)
            {
                thread_id thisid = GetCurrentThreadId();

                for (int i = 0; i < allThreadsDim; i++)
                {
                    DThread t = allThreads[i];
                    if (t && t.id != thisid && t.state == TS.RUNNING)
                        t.resume();
                }
            }
        }
    }

    /**
     * Give up the remainder of this thread's time slice.
     */
    static void yield()
    {
	Sleep(0);
    }

    /**
     *
     */
    static uint nthreads = 1;

private
{

    static uint allThreadsDim;
    static DThread[0x400] allThreads;	// length matches value in C runtime

    TS state;
    int idx = -1;			// index into allThreads[]
    thread_id id;
    size_t stacksize = 0;

    int (*fp)(void *);
    void *arg;

    int delegate() dg;

    void error(string msg)
    {
	throw new ThreadError(msg);
    }


}   
 /* ***********************************************
     * This is just a wrapper to interface between C rtl and DThread.run().
     */

    extern (Windows) static uint threadstart(void *p)
    {
	DThread t = cast(DThread)p;
	int result;

	debug (thread) printf("Starting thread %d\n", t.idx);
	t.stackBottom = os_query_stackBottom();
	try
	{
	    result = t.run();
	}
	catch (Object o)
	{
	    fprintf(stderr, "Error: %.*s\n", o.toString());
	    result = 1;
	}

	debug (thread) printf("Ending thread %d\n", t.idx);
        synchronized (DThread.classinfo)
        {
            allThreads[t.idx] = null;
            nthreads--;
	    t.state = TS.TERMINATED;
            t.idx = -1;
        }
	return result;
    }


    /**************************************
     * Create a DThread for global main().
     */

    public static void thread_init()
    {
	DThread t = new DThread();

	t.state = TS.RUNNING;
	t.id = GetCurrentThreadId();
	t.hdl = DThread.getCurrentThreadHandle();
	t.stackBottom = os_query_stackBottom();

	assert(!allThreads[0]);
	allThreads[0] = t;
	allThreadsDim = 1;
	t.idx = 0;
    }

    static ~this()
    {
	if (allThreadsDim)
	{
	    CloseHandle(allThreads[0].hdl);
	    allThreads[0].hdl = GetCurrentThread();
	}
    }
          
    /********************************************
     * Returns the handle of the current thread.
     * This is needed because GetCurrentThread() always returns -2 which
     * is a pseudo-handle representing the current thread.
     * The returned thread handle is a windows resource and must be explicitly
     * closed.
     * Many thanks to Justin (jhenzie@mastd.c.com) for figuring this out
     * and providing the fix.
     */
    static thread_hdl getCurrentThreadHandle()
    {
	thread_hdl currentThread = GetCurrentThread();
	thread_hdl actualThreadHandle;

	//thread_hdl currentProcess = cast(thread_hdl)-1;
	thread_hdl currentProcess = GetCurrentProcess(); // http://www.digitalmars.com/drn-bin/wwwnews?D/21217


	uint access = cast(uint)0x00000002;

	DuplicateHandle(currentProcess, currentThread, currentProcess,
			 &actualThreadHandle, cast(uint)0, TRUE, access);

	return actualThreadHandle;
     }
}


/**********************************************
 * Determine "bottom" of stack (actually the top on Win32 systems).
 */

 void *os_query_stackBottom()
{
    asm
    {
	naked			;
	mov	EAX,FS:4	;
	ret			;
    }
}

}
