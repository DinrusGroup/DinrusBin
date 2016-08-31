//This file changed for Rulada by Vitaly Kulich
//Phobos

// Implementation is in internal\object.d

module object;


//public import rt.core.stdc.stdio: ФАЙЛ, стдвхо, стдвых, стдош, стддоп, стдпрн;


alias bool бул;

enum : бул
{
нет = false,
да = true

}

const ук пусто = null;

alias char[] string;
alias wchar[] wstring;
alias dchar[] dstring;
alias int equals_t;
//alias bit bool;


alias бул *убул;
alias int цел;
alias цел *уцел;
alias uint бцел;
alias бцел *убцел;
alias long дол;
alias дол *удол;
alias ulong бдол;
alias бдол *убдол;
alias real реал;
alias реал *уреал;
alias double дво;
alias дво *удво;
alias char сим;
alias сим *усим;
alias усим ткст0;
alias wchar шим;
alias шим *ушим;
alias dchar дим;
alias дим *удим;
alias byte байт;
alias байт *убайт;
alias ubyte ббайт;
alias ббайт *уббайт;
alias short крат;
alias крат *украт;
alias ushort бкрат;
alias бкрат *убкрат;
alias float плав;
alias плав *уплав;

alias void проц;
alias проц *ук;

alias ireal вреал;
alias вреал *увреал;
alias idouble вдво;
alias вдво *увдво;
alias ifloat вплав;
alias вплав *увплав;

alias creal креал;
alias креал *укреал;
alias cdouble кдво;
alias кдво *укдво;
alias cfloat кплав;
alias кплав *укплав;

alias size_t т_мера;
alias ptrdiff_t т_дельтаук;
alias hash_t т_хэш;
alias int т_рав;

alias string симма; 
alias симма *усимма;
alias симма ткст;
alias ткст *уткст;
alias wstring шимма;
alias шимма *ушимма;
alias шимма ткстш;
alias ткстш *уткстш;
alias dstring димма;
alias димма *удимма;
alias димма ткстд;
alias ткстд *уткстд;

alias bit бит;
alias ук спис_ва;

alias bool bit;

alias extern(C) extern int сиэкспцел; 
alias extern(C) extern uint сиэкспбцел; 
alias extern(C) extern double сиэкспдво; 
alias extern(C) extern float сиэкспплав; 
alias extern(C) extern void сиэксппроц; 
alias extern(C) extern void * сиэкспук; 
alias extern(C) extern byte сиэкспбайт; 
alias extern(C) extern ubyte сиэкспббайт; 
alias extern(C) extern char сиэкспсим; 
alias extern(C) extern char *сиэксптктс0;
alias extern(C) extern wchar сиэкспшим;
alias extern(C) extern wchar *сиэксткстш0;

//alias typeof(int.sizeof) size_t;
//alias typeof(cast(void*)0 - cast(void*)0) ptrdiff_t;

version( X86_64 )
{
    alias ulong size_t;
    alias long  ptrdiff_t;
}
else
{
    alias uint  size_t;
    alias int   ptrdiff_t;
}

alias size_t hash_t;



alias Exception.TraceInfo function( void* ptr = null ) TraceHandler;
alias Object.Monitor        IMonitor;
alias void delegate(Object) DEvent;

enum
{   MIctorstart = 1,	// we've started constructing it
    MIctordone = 2,	// finished construction
    MIstandalone = 4,	// module ctor does not depend on other module
			// ctors being done first
    MIhasictor = 8,	// has ictor member
}

extern (C)
{   
   int printf(char *, ...);
   alias printf выводф;
   // int printf(char[], ...);
    void trace_term();
	alias trace_term трасс_терм;
	//int memcmp(void *, void *, size_t);
    //void* memcpy(void *, void *, size_t);
	//void* memmove(void* s1, in void* s2, size_t n);
	//void* memset(void* s, int c, size_t n);
	//void*   malloc(size_t size);
    //void* calloc(size_t, size_t);
    //void* realloc(void*, size_t);
   // void free(void*);	
}

class Object
{
    void dispose();
	проц вымести();
	
    void print();
	проц выведи();
	
    char[] toString();
	ткст вТкст();
	
    hash_t toHash();
	т_хэш вХэш();
	
    int opCmp(Object o);
    int opEquals(Object o);
		
	alias Monitor Монитор;
		interface Monitor
    {
        void lock();
		alias lock блокируй;
		
        void unlock();
		alias unlock разблокируй;
    }
	
    final void notifyRegister(void delegate(Object) dg);
	final проц уведомиРег(проц delegate(Объект) dg);
	
    final void notifyUnRegister(void delegate(Object) dg);
	final проц уведомиОтрег(проц delegate(Объект) dg);

    static Object factory(char[] classname);
	static Объект фабрика(ткст имякласса);
}
alias Object Объект;
	
struct Interface
{
    ClassInfo classinfo;
	alias classinfo классинфо;
	
    void *[] vtbl;
	alias vtbl вирттаб;
	
    int offset;			// offset to Interface 'this' from Object 'this'
	alias offset смещение;
}
alias Interface Интерфейс;

class ClassInfo ///*: Object*/
{
    byte[] init;		// class static initializer
	alias init иниц;
	
    char[] name;		// class name
	alias name имя;
	
    void *[] vtbl;		// virtual function pointer table
	alias vtbl вирттаб;
	
    Interface[] interfaces;
	alias interfaces интерфейсы;
	
    ClassInfo base;
	alias base основа;
	
    void *destructor;
	alias destructor деструктор;
	
    void (*classInvariant)(Object);
	
    uint flags;
	alias flags флаги;
	
    //	1:			// IUnknown
    //	2:			// has no possible pointers into GC memory
    //	4:			// has offTi[] member
    //	8:			// has constructors
    //	32:			// has typeinfo
    void *deallocator;
	alias deallocator выместитель;
	
    OffsetTypeInfo[] offTi;
	alias offTi смТи;
	
    void* defaultConstructor;	// default Constructor
    TypeInfo typeinfo;
    alias typeinfo инфотипе;
	
    static ClassInfo find(char[] classname);
	alias find найди;
	
    Object create();
	alias create создаЙ;
}
alias ClassInfo ИнфОКлассе;

struct OffsetTypeInfo
{
    size_t offset;
	alias offset смещение;
	
    TypeInfo ti;
	alias ti иот;
}
alias OffsetTypeInfo ИнфОТипеИСмещ;

class TypeInfo
{
    hash_t getHash(void *p);
	alias getHash полХэш;
	
    int equals(void *p1, void *p2);
	alias equals равны_ли;
	
    int compare(void *p1, void *p2);
	alias compare сравни;
	
    size_t tsize();
    void swap(void *p1, void *p2);
    TypeInfo next();
    void[] init();
    uint flags();
    // 1:			// has possible pointers into GC memory
    OffsetTypeInfo[] offTi();

alias next следщ;
alias init иниц;
alias flags флаги;
}
alias TypeInfo ИнфОТипе;

class TypeInfo_Typedef : TypeInfo
{
alias base основа;
alias name имя;

    TypeInfo base;
    char[] name;
    void[] m_init;
}
alias TypeInfo_Typedef ИнфОТипе_Типдеф;

class TypeInfo_Enum : TypeInfo_Typedef
{
}
alias TypeInfo_Enum  ИнфОТипе_Перечень;

class TypeInfo_Pointer : TypeInfo
{
    TypeInfo m_next;
}
alias TypeInfo_Pointer ИнфОТипе_Указатель;

class TypeInfo_Array : TypeInfo
{
alias value значение;

    TypeInfo value;
}
alias TypeInfo_Array ИнфОТипе_Массив;

class TypeInfo_StaticArray : TypeInfo
{
alias value значение;
alias len длин;

    TypeInfo value;
    size_t len;
}
alias TypeInfo_StaticArray ИнфОТипе_СтатичМассив;

class TypeInfo_AssociativeArray : TypeInfo
{
alias value значение;
alias key ключ;

    TypeInfo value;
    TypeInfo key;
}
alias TypeInfo_AssociativeArray  ИнфОТипе_АссоцМассив;

class TypeInfo_Function : TypeInfo
{
alias next следщ;

    TypeInfo next;
}
alias TypeInfo_Function ИнфОТипе_Функция;

class TypeInfo_Delegate : TypeInfo
{
alias next следщ;

    TypeInfo next;
}
alias TypeInfo_Delegate ИнфОТипе_Делегат;

class TypeInfo_Class : TypeInfo
{
alias info инфо;

    ClassInfo info;
}
alias TypeInfo_Class ИнфОТипе_Класс;

class TypeInfo_Interface : TypeInfo
{
alias info инфо;

    ClassInfo info;
}
alias TypeInfo_Interface ИнфОТипе_Интерфейс;

class TypeInfo_Struct : TypeInfo
{
    char[] name;
    void[] m_init;

    uint function(void*) xtoHash;
    int function(void*,void*) xopEquals;
    int function(void*,void*) xopCmp;
    char[] function(void*) xtoString;

    uint m_flags;
}
alias TypeInfo_Struct ИнфОТипе_Структ;

class TypeInfo_Tuple : TypeInfo
{
    TypeInfo[] elements;
}
alias TypeInfo_Tuple ИнфОТипе_Кортеж;
///////////////////////////////////////////////////////////
class TypeInfo_Const : TypeInfo
{
    TypeInfo next;
}
alias TypeInfo_Const ИнфОТипе_Конст;
///////////////////////////////////////////////////////////////
class TypeInfo_Invariant : TypeInfo_Const
{
}
alias TypeInfo_Invariant ИнфОТипе_Инвариант;
/////////////////////////////////////////////////////////////////
/// information about a module (can be used for example to get its unittests)
class ModuleInfo
{
    /// name of the module
    char[]          name;
    ///
    ModuleInfo[]    importedModules;
    ///
    ClassInfo[]     localClasses;
    uint            flags;

    void function() ctor;
    void function() dtor;
    /// unit tests of the module
    void function() unitTest;

    version(GNU){}
    else{
        void* xgetMembers;
        void function() ictor;
    }
    
    /// loops on all the modules loaded
    static int opApply( int delegate( inout ModuleInfo ) );
	static ModuleInfo[] modules();
}

// Recoverable errors
class Exception : Object
{
/// Information about a frame in the stack
    struct FrameInfo{
        /// line number in the source of the most likely start adress (0 if not available)
        long line;
        /// number of the stack frame (starting at 0 for the top frame)
        ptrdiff_t iframe;
        /// offset from baseSymb: within the function, or from the closest symbol
        ptrdiff_t offsetSymb;
        /// adress of the symbol in this execution
        size_t baseSymb;
        /// offset within the image (from this you can use better methods to get line number
        /// a posteriory)
        ptrdiff_t offsetImg;
        /// base adress of the image (will be dependent on randomization schemes)
        size_t baseImg;
        /// adress of the function, or at which the ipc will return
        /// (which most likely is the one after the adress where it started)
        /// this is the raw adress returned by the backtracing function
        size_t address;
        /// file (image) of the current adress
        char[] file;
        /// name of the function, if possible demangled
        char[] func;
        /// extra information (for example calling arguments)
        char[] extra;
        /// if the адрess is exact or it is the return адрess
        bool exactAddress;
        /// if this function is an internal functions (for example the backtracing function itself)
        /// if true by default the frame is not printed
        bool internalFunction;
        alias void function(FrameInfo*,void delegate(char[])) FramePrintHandler;
        /// the default printing function
        static FramePrintHandler defaultFramePrintingFunction;
        /// writes out the current frame info
        void writeOut(void delegate(char[])sink);
        /// clears the frame information stored
        void clear();		
		
	alias clear сотри;
	alias line строка;
	alias file файл;
	alias func функ;
	alias address адрес;
	alias writeOut выпиши;
	alias func функц;
    alias extra экстра;
    alias exactAddress точныйАдрес;
    alias internalFunction внутрФункция;	
    }
    /// trace information has the following interface
    interface TraceInfo
    {
        int opApply( int delegate( inout FrameInfo fInfo) );
        void writeOut(void delegate(char[])sink);
		alias writeOut выпиши;
    }
    /// message of the exception
    char[]      msg;
    /// file name
    char[]      file;
    /// line number
    size_t      line;  // long would be better to be consistent
    /// trace of where the exception was raised
    TraceInfo   info;
    /// next exception (if an exception made an other exception raise)
    Exception   next;

    this( char[] msg, char[] file, long line, Exception next, TraceInfo info )
    {
        // main constructor, breakpoint this if you want...
        this.msg = msg;
        this.next = next;
        this.file = file;
        this.line = cast(size_t)line;
        this.info = info;
    }

    this( char[] msg, Exception next=null )    {
		      
        this(msg,"",0,next,rt_createTraceContext(null));
    }

    this( char[] msg, char[] file, long line, Exception next=null )
    {
		this(msg,file,line,next,rt_createTraceContext(null));
    }  
    void writeOut(void delegate(char[]) sink);
	
alias FrameInfo ИнфОКадре;
alias TraceInfo ИнфОСледе; 
alias writeOut выпиши;	
}
extern (C) Exception.TraceInfo rt_createTraceContext( void* ptr );
/**
 * All recoverable exceptions should be derived from class Exception.
 */

alias Exception Исключение;
////////////////////////////////////////////////////////////////
/**
 * All irrecoverable exceptions should be derived from class Error.
 */
class Error : Exception
{
    Error next;

    /**
     * Constructor; msg is a descriptive message for the exception.
     */
    this(char[] msg)
    {
	super(msg, null);
    }

    this(char[] msg, Error next)
    {
	super(msg, next);
	this.next = next;
    }
}
alias Error Ошибка;



class ModuleCtorError : Exception
{
    this(ModuleInfo m)
    {
	super(cast(string) ("circular initialization dependency with module "
                            ~ m.name));
    }
}

////////////////////////////////////////////////
struct Monitor
{
    void delegate(Object)[] delegates;

    /* More stuff goes here defined by internal/monitor.c */
	IMonitor impl;
    /* internal */
    DEvent[] devt;
    /* stuff */
}
alias Monitor Монитор;

