module std.gc;


version= Static;//Dynamic;

version(Dynamic)
{
import std.memory;
version=GCCLASS; 

	struct GCStats
	{
		size_t poolsize;        // total size of pool
		size_t usedsize;        // bytes allocated
		size_t freeblocks;      // number of blocks marked FREE
		size_t freelistsize;    // total of memory on free lists
		size_t pageblocks; 
	}
	struct BlkInfo
	{
		void*  base;
		size_t size;
		uint   attr;
	}

	struct Array
	{
		size_t length;
		byte *data;
	};

	struct Array2
	{
		size_t length;
		void* ptr;
	}

	version (GCCLASS)
		alias GC gc_t;
	else
		alias GC* gc_t;

	gc_t _gc;

	alias extern(D) void delegate() ddel;
	alias extern(D) void delegate(int, int) dint;

	alias void (*GC_FINALIZER)(void *p, bool dummy);

	private int _termCleanupLevel=1;

	///////////////////////////////////////////////////////////////////
	 extern (C) void _d_callinterfacefinalizer(void *p);
	 extern (C)  byte[] _d_arraysetlengthT(TypeInfo ti, size_t newlength, Array *p);
	 extern (C) byte[] _d_arraysetlengthiT(TypeInfo ti, size_t newlength, Array *p);
	 extern (C) long _d_arrayappendT(TypeInfo ti, Array *px, byte[] y);
	 extern (C) byte[] _d_arrayappendcT(TypeInfo ti, inout byte[] x, ...);
	 extern (C)  char[] _d_arrayappendcd(inout char[] x, dchar c);
	 extern (C)  wchar[] _d_arrayappendwd(inout wchar[] x, dchar c);
	 extern (C) byte[] _d_arraycatT(TypeInfo ti, byte[] x, byte[] y);
	 extern (C) byte[] _d_arraycatnT(TypeInfo ti, uint n, ...);
	 extern (C) void* _d_arrayliteralT(TypeInfo ti, size_t length, ...);
	extern (C)
	{
	void setTypeInfo(TypeInfo ti, void* p);
	void* getGCHandle();
	void setGCHandle(void* p);
	void endGCHandle();
	}
	 extern (C) void gc_init();
	 extern (C) void gc_term();
	 extern (C) size_t gc_capacity(void* p);
	 extern (C) void gc_minimize();
	 extern (C) void gc_addRoot( void* p );
	 extern (C) void gc_addRange( void* p, size_t sz );
	 extern (C) void gc_removeRoot( void* p );
	 extern (C) void gc_removeRange( void* p );	
	 extern (C) void gc_monitor(ddel begin, dint end );
	 extern (C)  gc_t newGC();
	 extern (C) void deleteGC(gc_t gc);
	 extern (C) void gc_printStats(gc_t gc);
	 extern (C)  GCStats gc_stats();
	 extern (C)  void _d_gc_addrange(void *pbot, void *ptop);
	 extern (C)  void _d_gc_removerange(void *pbot);
	 extern (C) long _adDupT(TypeInfo ti, Array2 a);
	 extern (C) uint gc_getAttr( void* p );
	 extern (C) uint gc_setAttr( void* p, uint a );
	 extern (C) uint gc_clrAttr( void* p, uint a );
	 extern (C) void* gc_malloc( size_t sz, uint ba = 0 );
	 extern (C) void* gc_calloc( size_t sz, uint ba = 0 );
	 extern (C) void* gc_realloc( void* p, size_t sz, uint ba = 0 );
	 extern (C) size_t gc_extend( void* p, size_t mx, size_t sz );
	 extern (C) size_t gc_reserve( size_t sz );
	 extern (C) void gc_free( void* p );
	 extern (C) void* gc_addrOf( void* p );
	 extern (C) size_t gc_sizeOf( void* p );
	 extern (C) void* gc_weakpointerCreate( Object r );
	 extern (C) void gc_weakpointerDestroy( void* wp );
	 extern (C) Object gc_weakpointerGet( void* wp );
	 extern (C) BlkInfo gc_query( void* p );
	 extern (C) void gc_enable();
	 extern (C) void gc_disable();
	 extern (C) void gc_collect();
	 extern (C) void gc_check(void *p);
	 
	 extern (D){
	 void setFinalizer(void *p, GC_FINALIZER pFn);
	 void addRoot(void *p);
	 void removeRoot(void *p);
	 void addRange(void *pbot, void *ptop);
	 void removeRange(void *pbot);
	 void fullCollect();
	 void fullCollectNoStack();
	 void genCollect();
	 void minimize();
	 void disable();
	 void enable();
	 void getStats(out GCStats stats);
	 void hasPointers(void* p);
	 void hasNoPointers(void* p);
	 void setV1_0();
	 }
	 
//class GC{}


extern (D):
	void printStats(gc_t gc);
	//void[] malloc(size_t sz, uint ba = 0);
		//void[] realloc(void* p, size_t sz, uint ba = 0);		
	size_t capacity(void* p);		
	size_t capacity(void[] p);
	void[] malloc(size_t nbytes);
	void[] realloc(void* p, size_t nbytes);
	size_t extend(void* p, size_t minbytes, size_t maxbytes);
	//size_t capacity(void* p);
	void new_finalizer(void *p, bool dummy);
}
version(Static)
{

	public import std.c;
	public import rt.gc.gcx;
	public import std.exception;
	public import gcstats;
	public import std.thread;

private{
/*
		struct GCStats
	{
		т_мера poolsize;        // total size of pool
		т_мера usedsize;        // bytes allocated
		т_мера freeblocks;      // number of blocks marked FREE
		т_мера freelistsize;    // total of memory on free lists
		т_мера pageblocks; 
	}*/
	
	version=GCCLASS;

	version (GCCLASS)
		alias GC gc_t;
	else
		alias GC* gc_t;

	gc_t _gc;


	struct Proxy
    {
        extern (C) void function() gc_enable;
        extern (C) void function() gc_disable;
        extern (C) void function() gc_collect;
        extern (C) void function() gc_minimize;

        extern (C) uint function(void*) gc_getAttr;
        extern (C) uint function(void*, uint) gc_setAttr;
        extern (C) uint function(void*, uint) gc_clrAttr;

        extern (C) void*  function(size_t, uint) gc_malloc;
        extern (C) void*  function(size_t, uint) gc_calloc;
        extern (C) void*  function(void*, size_t, uint ba) gc_realloc;
        extern (C) size_t function(void*, size_t, size_t) gc_extend;
        extern (C) size_t function(size_t) gc_reserve;
        extern (C) void   function(void*) gc_free;

        extern (C) void*   function(void*) gc_addrOf;
        extern (C) size_t  function(void*) gc_sizeOf;

        extern (C) BlkInfo function(void*) gc_query;

        extern (C) void function(void*) gc_addRoot;
        extern (C) void function(void*, size_t) gc_addRange;
		extern (C) void function( void* p, void *sz ) gc_addRangeOld;

        extern (C) void function(void*) gc_removeRoot;
        extern (C) void function(void*) gc_removeRange;
		
		extern (C) void* function( Object r ) gc_weakpointerCreate;
		extern (C) void function( void* wp ) gc_weakpointerDestroy;
		extern (C) Object function( void* wp )gc_weakpointerGet;
		
		extern (C) void function(void *p)gc_check;
		extern (C) size_t function(void* p) gc_capacity;
		extern (C) void function(ddel begin, dint end ) gc_monitor;
    }
	
	Proxy  pthis;
    Proxy* proxy;
	
	 void initProxy()
    {
        pthis.gc_enable = &gc_enable;
        pthis.gc_disable = &gc_disable;
        pthis.gc_collect = &gc_collect;
        pthis.gc_minimize = &gc_minimize;

        pthis.gc_getAttr = &gc_getAttr;
        pthis.gc_setAttr = &gc_setAttr;
        pthis.gc_clrAttr = &gc_clrAttr;

        pthis.gc_malloc = &gc_malloc;
        pthis.gc_calloc = &gc_calloc;
        pthis.gc_realloc = &gc_realloc;
        pthis.gc_extend = &gc_extend;
        pthis.gc_reserve = &gc_reserve;
        pthis.gc_free = &gc_free;

        pthis.gc_addrOf = &gc_addrOf;
        pthis.gc_sizeOf = &gc_sizeOf;

        pthis.gc_query = &gc_query;

        pthis.gc_addRoot = &gc_addRoot;
        pthis.gc_addRange = &gc_addRange;
		pthis.gc_addRangeOld = &gc_addRangeOld;

        pthis.gc_removeRoot = &gc_removeRoot;
        pthis.gc_removeRange = &gc_removeRange;
		
		pthis.gc_weakpointerCreate = &gc_weakpointerCreate;
		pthis.gc_weakpointerDestroy =&gc_weakpointerDestroy;
		pthis.gc_weakpointerGet = &gc_weakpointerGet;
		
		pthis.gc_check = &gc_check;
		pthis.gc_capacity = &gc_capacity;
		pthis.gc_monitor = &gc_monitor;
    }
	
}


	private int _termCleanupLevel=1;

export{
	 void addRoot(void *p)		;
	 void removeRoot(void *p)	    ;
	 void addRange(void *pbot, void *ptop) ;
	 void removeRange(void *pbot)	   ;
	 void fullCollect()		    ;
	 void fullCollectNoStack()	     ;
	 void genCollect()		    ;
	 void minimize()			   ;
	 void disable()			   ;
	 void enable()			  ;
	 void getStats(out GCStats stats)    ;
	 void hasPointers(void* p)	    ;
	 void hasNoPointers(void* p)	  ;
	 void setV1_0()		;
	 }
	///////////////////////////////////////////////////////////////////
	 extern (C) void gc_check(void *p);
	extern (C) void gc_minimize() ;
	extern (C) void gc_addRoot( void* p );
	extern (C) void gc_addRange( void* p, size_t sz );
	extern (C) void gc_addRangeOld(void *pbot, void *ptop) ;
	extern (C) void gc_removeRoot( void* p );
	extern (C) void gc_removeRange( void* p );
	 extern (C) size_t gc_capacity(void* p);
	alias extern(D) void delegate() ddel;
	alias extern(D) void delegate(int, int) dint;
		
	extern (C) void gc_monitor(ddel begin, dint end );
	/////////////////////////////////////////////////////////////////////////
	 extern (C)  gc_t newGC();
	 extern (C) void gc_clrProxy();
	 extern (C) void gc_setProxy( Proxy* p );
	 extern (C) Proxy* gc_getProxy();
	 extern (C) void deleteGC(gc_t gc);
	 extern (C) void gc_printStats(gc_t gc);
	 extern (C)  GCStats gc_stats();
	 extern (C)  void _d_gc_addrange(void *pbot, void *ptop);
	 extern (C)  void _d_gc_removerange(void *pbot);
	export void[] malloc(size_t nbytes);

	export void[] realloc(void* p, size_t nbytes);
	export size_t extend(void* p, size_t minbytes, size_t maxbytes);
	export size_t capacity(void* p);
	extern (C) void setTypeInfo(TypeInfo ti, void* p);

	 extern (C) void* getGCHandle();
	 extern (C) void setGCHandle(void* p);

	 extern (C) void endGCHandle();


	 extern (C) 	void _d_monitorrelease(Object h);

		version(OSX)
		{
		 extern (C) 	void _d_osx_image_init();
		}

	 extern (C) void thread_init();

	 extern (C) void gc_init();
	 extern (C) void gc_term();
	 extern (C)   Object _d_newclass(ClassInfo ci);

	 extern (C)	void _d_delinterface(void** p);

	 extern (C)  void _d_delclass(Object *p);

	/******************************************
	 * Allocate a new array of length elements.
	 * ti is the type of the resulting array, or pointer to element.
	 */

	 extern (C) ulong _d_newarrayT(TypeInfo ti, size_t length);

	 extern (C) ulong _d_newarrayiT(TypeInfo ti, size_t length);

	 extern (C) ulong _d_newarraymT(TypeInfo ti, int ndims, ...);

	 extern (C) ulong _d_newarraymiT(TypeInfo ti, int ndims, ...);


	struct Array
	{
		size_t length;
		byte *data;
	};

	// Perhaps we should get a a size argument like _d_new(), so we
	// can zero out the array?

	 extern (C) void _d_delarray(Array *p);


	 extern (C) void _d_delmemory(void* *p);


	export void new_finalizer(void *p, bool dummy);

	 extern (C) void _d_callinterfacefinalizer(void *p);
	 extern (C) void _d_callfinalizer(void *p);


	/+ ------------------------------------------------ +/


	/******************************
	 * Resize dynamic arrays with 0 initializers.
	 */

	 extern (C)  byte[] _d_arraysetlengthT(TypeInfo ti, size_t newlength, Array *p);

	/**
	 * Resize arrays for non-zero initializers.
	 *	p		pointer to array lvalue to be updated
	 *	newlength	new .length property of array
	 *	sizeelem	size of each element of array
	 *	initsize	size of initializer
	 *	...		initializer
	 */
	 extern (C) byte[] _d_arraysetlengthiT(TypeInfo ti, size_t newlength, Array *p);

	/****************************************
	 * Append y[] to array x[].
	 * size is size of each array element.
	 */

	 extern (C) long _d_arrayappendT(TypeInfo ti, Array *px, byte[] y);


	 extern (C)  size_t gc_newCapacity(size_t newlength, size_t size);
	 extern (C) byte[] _d_arrayappendcT(TypeInfo ti, inout byte[] x, ...);

	/**
	 * Append dchar to char[]
	 */
	 extern (C)  char[] _d_arrayappendcd(inout char[] x, dchar c);

	/**
	 * Append dchar to wchar[]
	 */
	 extern (C)  wchar[] _d_arrayappendwd(inout wchar[] x, dchar c);


	 extern (C) byte[] _d_arraycatT(TypeInfo ti, byte[] x, byte[] y);


	 extern (C) byte[] _d_arraycatnT(TypeInfo ti, uint n, ...);


	 extern (C) void* _d_arrayliteralT(TypeInfo ti, size_t length, ...);


	/**********************************
	 * Support for array.dup property.
	 */

	struct Array2
	{
		size_t length;
		void* ptr;
	}

	 extern (C) long _adDupT(TypeInfo ti, Array2 a);


	 extern (C) uint gc_getAttr( void* p );
	 extern (C) uint gc_setAttr( void* p, uint a );
	 extern (C) uint gc_clrAttr( void* p, uint a );
	 extern (C) void* gc_malloc( size_t sz, uint ba = 0 );
	 extern (C) void* gc_calloc( size_t sz, uint ba = 0 );
	 extern (C) void* gc_realloc( void* p, size_t sz, uint ba = 0 );
	 extern (C) size_t gc_extend( void* p, size_t mx, size_t sz );
	 extern (C) size_t gc_reserve( size_t sz );
	 extern (C) void gc_free( void* p );
	 extern (C) void* gc_addrOf( void* p );
	 extern (C) size_t gc_sizeOf( void* p );
	 extern (C) void* gc_weakpointerCreate( Object r );
	 extern (C) void gc_weakpointerDestroy( void* wp );
	 extern (C) Object gc_weakpointerGet( void* wp );
	 extern (C) BlkInfo gc_query( void* p );
	 extern (C) void rt_finalize(void* p, bool det = true);

	 extern (C) void gc_enable();
	 extern (C) void gc_disable();
	 extern (C) void gc_collect();
	 extern (C) void setFinalizer(void *p, GC_FINALIZER pFn);


	class GCAlone
	{
		
		this();		
		void collect();
		void disable();
		void enable();
	    void getStats(out GCStats stats);
	    void hasPointers(void* p);
	    void hasNoPointers(void* p);
	    void check(void *p);
		void minimize();
		void addRoot( void* p );
		void ddRange( void* p, size_t sz );
		void removeRoot( void* p );
		void removeRange( void* p );
		size_t capacity(void* p);
		~this();
	 
	}
	
}