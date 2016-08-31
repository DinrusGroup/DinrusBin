/**
* Главный рантаймный модуль языка программирования Динрус,
* поддерживающий совместимость с английской версией.
* Разработчик Виталий Кулич
*/
module object;
public import base;


extern (D) class Object

{
   проц dispose();
   проц вымести();
    
    проц print();
    проц выведи();	

    ткст toString();	
	ткст вТкст();

   hash_t toHash();
	т_хэш вХэш();

	 int opCmp(Object o);
	 int opEquals(Object o) ;
	
	interface Monitor
    {
        проц lock();		alias lock блокируй;
        проц unlock();		alias unlock разблокируй;
    }
	alias Monitor Монитор;

	final проц notifyRegister(проц delegate(Object) дг);
	final проц уведомиРег(проц delegate(Объект) дг);

	final проц notifyUnRegister(проц delegate(Object) дг);
	final проц уведомиОтрег(проц delegate(Объект) дг);

    static Object factory(ткст classname);	
	static Объект фабрика(ткст имякласса);
	
}
alias Object Объект;
alias Object.Monitor        IMonitor, ИМонитор;

ИнфОКлассе дайИоК(Объект о){return о.classinfo ;}


//ИнфОКлассе дайИоК(Объект о){return о.classinfo;}

//////////////////////////////////////////////////////////////////////
/**
 * Все невосстановимые исключения должны проиходить от класса Ошибка.
 */
 
extern (D) class Exception : Object
{


	ткст      msg; alias msg сооб;
    ткст      file; alias file файл;
    size_t  line;  	alias line строка;
    TraceInfo   info;	alias info инфо;
    Exception   next;	alias next следщ;	
	
    struct FrameInfo
	{	
	
        long  line;		alias line строка;		
        size_t iframe;		alias iframe икадр;		
        ptrdiff_t offsetSymb;		alias offsetSymb симвСмещ;		
        size_t baseSymb;		alias baseSymb симвОвы;		
        ptrdiff_t offsetImg;		alias offsetImg обрСмещ;		
        size_t baseImg;		alias baseImg обрОвы;		
        size_t address;		alias address адрес;		
        ткст file;		alias file файл;		
        ткст func;		alias func функц;		
        ткст extra;		alias extra экстра;		
        bool exactAddress;		 alias exactAddress точныйАдрес;		
        bool internalFunction;		 alias internalFunction внутрФункция;		 
        alias проц function(FrameInfo*,проц delegate(char[])) FramePrintHandler, ОбработчикПечатиКадра;
		
        static FramePrintHandler defaultFramePrintingFunction;
		alias defaultFramePrintingFunction дефФцияПечатиКадра;
		
        проц writeOut(проц delegate(char[])sink);
		проц выпиши(проц delegate(ткст) синк);
        
        проц clear();
		проц сотри();
		
    }
	alias FrameInfo ИнфОКадре;//
	
    interface TraceInfo
    {	
        int opApply( int delegate( ref FrameInfo fInfo ) );
        проц writeOut(проц delegate(char[])sink);
		
	alias writeOut выпиши;
    }
	alias TraceInfo ИнфОСледе;//
	
    this( ткст сооб, ткст file, long  line, Exception next, TraceInfo info );
    this( ткст сооб, Exception next=null );
    this( ткст сооб, ткст file, long  line, Exception next=null );
	override проц print();
	override проц выведи();	
	
    override ткст toString();
	override ткст вТкст();	
	/+
    проц writeOutMsg(проц delegate(char[])sink);
	проц выпишиСооб(проц delegate(ткст) синк);	
	
    проц writeOut(проц delegate(char[])sink);
	проц выпиши(проц delegate(ткст) синк);
	+/
	проц сбрось();
}
alias Exception Исключение, Искл, Ошибка, Ош;
////////////////////////////////////////////////////

alias Исключение.ИнфОСледе function( ук укз = пусто ) TraceHandler, Следопыт;

private Следопыт следопыт = пусто;
////////////////////////////////////////////////////////
/+
extern (D) class Error : Exception
{
    Error next; alias next следщ;
	ткст msg; alias msg сооб;
	
	override проц print();
	override проц выведи();
	
	override ткст toString();
	override ткст вТкст();
    /**
     * Конструктор; сооб - сообщение, описывающее исключение.
     */
	this(ткст сооб);
    this(ткст сооб, Error next);
}

alias Error Ошибка, Ош;
///////////////////////////////////////////////////////////////////////
+/
alias проц delegate(Object) DEvent, ДСобыт;

extern (D) struct Monitor
{
    проц delegate(Object)[] delegates;
  	extern(C) extern IMonitor impl;
    extern(C) extern ДСобыт[] devt;
  }
alias Monitor Монитор;	

/***********************
 * Информация о каждом модуле.
 */
 
 alias ModuleInfo ИнфОМодуле;
 
extern(D) class ModuleInfo
{
    extern(C) extern char name[];
    extern(C) extern ИнфОМодуле importedModules[];
    extern(C) extern ИнфОКлассе localClasses[];

    extern(C) extern бцел flags;		// initialization state

    проц function() ctor;       // module static constructor (order dependent)
    проц function() dtor;       // module static destructor
    проц function() unitTest;
	/*проц (*ctor)();	// module static constructor (order dependent)
	  проц (*dtor)();	// module static destructor
        проц (*unitTest)();	// module unit tests*/

    extern(C) extern ук xgetMembers;	// module getMembers() function

    проц function() ictor;//проц (*ictor)();	// module static constructor (order independent)

	static int opApply( int delegate( ref  ModuleInfo ) дг );
    /******************
     * Возвращает коллекцию всех модулей в программе.
     */
    static ИнфОМодуле[] модули();
}

extern(D) class ОшКтораМодуля : Исключение
{
    this(ИнфОМодуле m);
}

///////////////////

extern (C) struct Interface
{
   extern(C) extern  ИнфОКлассе classinfo; 	alias classinfo классинфо;
   extern(C) extern  ук [] vtbl;	alias vtbl вирттаб;
   extern(C) extern  цел offset;	alias offset смещение;

}
alias Interface Интерфейс;
//////////////////////////////////////////////////////////////////////

alias ClassInfo ИнфОКлассе;
extern (D) class ClassInfo 
{

    extern(C) extern byte[] init;	alias init иниц;
	
	byte[] getSetInit(byte[] init = null);
	байт[] дайУстИниц(байт[] иниц = пусто);
	
    extern(C) extern ткст name;	alias name имя;
	
	ткст getSetName(ткст name = null);
	ткст дайУстИмя(ткст имя = пусто);

    extern(C) extern ук [] vtbl;	alias vtbl вирттаб;
	
	ук[] getSetVtbl(ук[] vtbl = null);
	ук[] дайУстВирттаб(ук[] вирттаб = пусто);
	

    extern(C) extern Interface[] interfaces;	alias interfaces интерфейсы;
	
	Interface[] getSetInterfaces(Interface[] interfaces = null);
	Интерфейс[] дайУстИнтерфейсы(Интерфейс[] интерфейсы = пусто);

    extern(C) extern ClassInfo base;	alias base основа;	
	
	ИнфОКлассе getSetBase(ИнфОКлассе base = null);
	ИнфОКлассе дайУстОву(ИнфОКлассе основа = пусто);

   extern(C) extern ук destructor;	alias destructor деструктор;
   
	ук getSetDestructor(ук destructor = null);
	ук дайУстДестр(ук деструктор = пусто);

    проц (*classInvariant)(Object);

    extern(C) extern бцел flags;	alias flags флаги;
	//	1:			// ИИнкогнито (IUnknown)
    //	2:			// нет возможных указателей на память СМ
    //	4:			// есть члены offTi[]
    //	8:			// есть конструкторы
    //	32:			// есть инфотипе
	бцел getSetFlags(бцел flags = бцел.init);  

    extern(C) extern ук deallocator;	alias deallocator выместитель;
	
	ук getSetDeallocator(ук deallocator = null);
	ук дайУстДеаллок(ук выместитель = пусто);

    extern(C) extern OffsetTypeInfo[] offTi;	alias offTi смТи;
	
	OffsetTypeInfo[] getSetOffTi(OffsetTypeInfo[] offTi = null);
	OffsetTypeInfo[] дайУстСмТи(ИнфОТипеИСмещ[] смТи = пусто);

    проц function(Object) defaultConstructor;

   extern(C) extern TypeInfo typeinfo;    alias typeinfo инфотипе;
   
	ИнфОТипе getSetTypeinfo(ИнфОТипе typeinfo = null);
	ИнфОТипе дайУстИнфОТипе(ИнфОТипе инфотипе = пусто);

    static ClassInfo find(ткст classname);
	static ИнфОКлассе найди (ткст имякласса);

  	Object create();
	Объект создай();
}

///////////////////////////////////////////////////////////////////////////////////
extern (C) struct OffsetTypeInfo
{
   extern(C) extern size_t offset;	alias offset смещение;	
   extern(C) extern TypeInfo ti;	alias ti иот;
}
alias OffsetTypeInfo ИнфОТипеИСмещ;

/////////////////////////////////////////////////////////////////////////////

alias TypeInfo ИнфОТипе; 
extern (D) class TypeInfo
{
    hash_t toHash();
	т_хэш вХэш();	

    override int opCmp(Object o);	
    override int opEquals(Object o);

    hash_t getHash(in ук p);
	т_хэш дайХэш(in ук п);
	
    int equals(in ук p1, in ук p2) ;
	цел равны(in ук п1, in ук п2);	

    int compare(in ук p1, in ук p2) ;
	цел сравни(in ук п1, in ук п2);
	
    size_t tsize();
	т_мера тразм();
	
    проц swap(ук p1, ук p2);
	проц поменяй(ук п1, ук п2);	

    TypeInfo next();
	ИнфОТипе следщ();
	
     проц[] init();
	проц[] иниц();
    
    бцел flags();
	бцел флаги();
  
    OffsetTypeInfo[] offTi();
	ИнфОТипеИСмещ[] смТи();
		
}
//////////////////////////////////////////////////////////////
extern (D) class TypeInfo_Typedef : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();	

    override int opEquals(Object o);

    override hash_t getHash(in ук p) ;
	override т_хэш дайХэш(in  ук п);
	
    override int equals(in ук p1, in ук p2) ;
	override цел равны(in ук п1, in ук п2);
	
    override int compare(in ук p1, in ук p2) ;
	override цел сравни(in ук п1, in ук п2);
	
    override size_t tsize();
	override т_мера тразм();
	
    override проц swap(ук p1, ук p2) ;
	override проц поменяй( ук п1, ук п2);
	
    override ИнфОТипе next() ;
	override ИнфОТипе следщ();
	
   override  бцел flags() ;
   override бцел флаги();
   
    override проц[] init() ;
	override проц[] иниц();

    extern(C) extern ИнфОТипе base;	alias base основа;
	
	ИнфОТипе getSetBase(ИнфОТипе base = null);
	ИнфОТипе дайУстОву(ИнфОТипе основа = пусто);
	
    extern(C) extern ткст name;	alias name имя;
	
	ткст getSetName(ткст name = null);
	ткст дайУстИмя(ткст имя = пусто);
	
    extern(C) extern проц[] m_init;
}
alias TypeInfo_Typedef ТипТипдеф;
///////////////////////////////////////////

extern (D) class TypeInfo_Enum : TypeInfo_Typedef
{


}
alias TypeInfo_Enum  ТипПеречень;
//////////////////////////////////////////

extern (D) class TypeInfo_Pointer : ИнфОТипе
{
    override ткст toString() ;
	override ткст вТкст();
	
    override int opEquals(Object o);	

    hash_t getHash(ук p);
	т_хэш дайХэш(ук п);	

    int equals(ук p1, ук p2);
	цел равны(ук п1, ук п2);	
	
    int compare(ук p1, ук p2);
	цел сравни(ук п1, ук п2);	

    override size_t tsize();
	override т_мера тразм();	

    override проц swap(ук p1, ук p2);
	override проц поменяй( ук п1, ук п2);	

    override ИнфОТипе next();
	override ИнфОТипе следщ();	
	
    override бцел flags();
	override бцел флаги();
	

   extern(C) extern ИнфОТипе m_next;
}
alias TypeInfo_Pointer ТипУказатель;
///////////////////////////////////////////

extern (D) class TypeInfo_Array : ИнфОТипе
{
    override ткст toString() ;
	override ткст вТкст();

    override int opEquals(Object o);

    hash_t getHash(ук p);
	override т_хэш дайХэш(ук п);	

    int equals(ук p1, ук p2);
	цел равны(ук п1, ук п2);	

    int compare(ук p1, ук p2);
	цел сравни(ук п1, ук п2);	
	
    override size_t tsize();
	override т_мера тразм();	

    override проц swap(ук p1, ук p2);
	override проц поменяй( ук п1, ук п2);	

    extern(C) extern ИнфОТипе value;

    override ИнфОТипе next();
	override ИнфОТипе следщ();	

    override бцел flags();
	override бцел флаги();
}
alias TypeInfo_Array ТипМассив;

/////////////////////////////////////////////////////////////////////////

extern (D) class TypeInfo_StaticArray : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();	

    override int opEquals(Object o);

	override hash_t getHash(in ук p);
	override т_хэш дайХэш(in ук п);	
	
    override int equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);

    override int compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);	

    override size_t tsize();
	override т_мера тразм();	

    override проц swap(ук p1, ук p2);
	override проц поменяй( ук п1, ук п2);

    override проц[] init() ;
	override проц[] иниц();
	
    override ИнфОТипе next() ;
	override ИнфОТипе следщ();
	
    override бцел flags();
	override бцел флаги();

    extern(C) extern ИнфОТипе value;	alias value значение;
	
	ИнфОТипе getSetValue(ИнфОТипе value = null);
	ИнфОТипе дайУстЗначение(ИнфОТипе значение = пусто);
	
    extern(C) extern size_t len;	alias len длин;
	
	т_мера getSetLength(т_мера len = т_мера.init);
	т_мера дайУстДлину(т_мера длин = т_мера.init);
}
alias TypeInfo_StaticArray ТипСтатМас;

////////////////////////////////////////////////////////////////////////////////////////////
extern (D) class TypeInfo_AssociativeArray : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();	

    override /*int*/ int opEquals(Object o);

    override hash_t getHash(in ук p);
	override т_хэш дайХэш(in ук п);	

    override size_t tsize();
	override т_мера тразм();	
	
    override int equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);	

    override int compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);	

   override ИнфОТипе next() ;
   override ИнфОТипе следщ();
   
    override бцел flags() ;
	override бцел флаги();

   extern(C) extern ИнфОТипе value;	alias value значение;
   
	ИнфОТипе getSetValue(ИнфОТипе value = null);
	ИнфОТипе дайУстЗначение(ИнфОТипе значение = пусто);
	
    extern(C) extern ИнфОТипе key;	alias key ключ;
	
	ИнфОТипе getSetKey(ИнфОТипе key = null);
	ИнфОТипе дайУстКлюч(ИнфОТипе ключ = пусто);
}
alias TypeInfo_AssociativeArray  ТипАссоцМас;
////////////////////////////////////////////////////////////////////////////////////////////

extern (D) class TypeInfo_Function : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();	

    override int opEquals(Object o);
  
    override size_t tsize();
	override т_мера тразм();

    extern(C) extern ИнфОТипе next;	alias next следщ;
	
	ИнфОТипе getSetNext(ИнфОТипе next = null);
	ИнфОТипе дайУстСледщ(ИнфОТипе следщ = null);
	
}
alias TypeInfo_Function ТипФункция;
/////////////////////////////////////////////////////////////////////////////////////

extern (D) class TypeInfo_Delegate : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();

    override int opEquals(Object o);

    override size_t tsize();
	override т_мера тразм();

    override бцел flags();
	 override бцел флаги();

   extern(C) extern ИнфОТипе next;	alias next следщ;
   
	ИнфОТипе getSetNext(ИнфОТипе next = null);
	ИнфОТипе дайУстСледщ(ИнфОТипе следщ = null);
}
alias TypeInfo_Delegate ТипДелегат;
//////////////////////////////////////////////////////////////////////////////////////

extern (D) class TypeInfo_Class : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();

    override int opEquals(Object o);

    hash_t getHash(ук p);
	override т_хэш дайХэш(ук п);	

    int equals(ук p1, ук p2);
	цел равны(ук п1, ук п2);	

    int compare(ук p1, ук p2);
	цел сравни(ук п1, ук п2);	

    override size_t tsize();
	override т_мера тразм();	

    override бцел flags();
	 override бцел флаги();

    override OffsetTypeInfo[] offTi();
	override ИнфОТипеИСмещ[] смТи();	

    extern(C) extern ClassInfo info;	alias info инфо;
	
	ИнфОКлассе getSetInfo(ИнфОКлассе info = null);
	ИнфОКлассе дайУстИнфо(ИнфОКлассе инфо = пусто);
}
alias TypeInfo_Class ТипКласс;
///////////////////////////////////////////////////////////////////////////////////////////
extern (D) class TypeInfo_Interface : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();

    override int opEquals(Object o);

    hash_t getHash(ук p);
	т_хэш дайХэш(ук п);	

    int equals(ук p1, ук p2);
	цел равны(ук п1, ук п2);	

    int compare(ук p1, ук p2);
	цел сравни(ук п1, ук п2);

    override size_t tsize();
	override т_мера тразм();	

    override бцел flags();
	 override бцел флаги();

    extern(C) extern ClassInfo info;	alias info инфо;
	
	ИнфОКлассе getSetInfo(ИнфОКлассе info = null);
	ИнфОКлассе дайУстИнфо(ИнфОКлассе инфо = пусто);
}
alias TypeInfo_Interface ТипИнтерфейс;
///////////////////////////////////////////////////////////////////////////////////

extern (D) class TypeInfo_Struct : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();

    override int opEquals(Object o);	

    hash_t getHash(ук p);
	т_хэш дайХэш(ук п);	

    int equals(ук p1, ук p2);
	цел равны(ук п1, ук п2);

    int compare(ук p1, ук p2);
	цел сравни(ук п1, ук п2);

    override size_t tsize();
	override т_мера тразм();	

    override проц[] init();
	override проц[] иниц();

    override бцел flags();
	override бцел флаги();	

   extern(C) extern ткст name;	alias name имя;
   
	ткст getSetName(ткст name = null);
	ткст дайУстИмя(ткст имя = пусто);
	
   extern(C) extern проц[] m_init;
	
    hash_t function(проц*) xtoHash;
    int function(проц*,проц*) xopEquals;
    int function(проц*,проц*) xopCmp;
    ткст function(проц*) xtoString;

   extern(C) extern бцел m_flags;
}
alias TypeInfo_Struct ТипСтрукт;
/////////////////////////////////////////////////////////////////////////////

extern (D) class TypeInfo_Tuple : ИнфОТипе
{
    extern(C) extern ИнфОТипе[] elements;	alias elements элементы;
	
	ИнфОТипе[] getSetElements(ИнфОТипе[] elements = null);	
	ИнфОТипе[] дайУстЭлементы(ИнфОТипе[] элементы = пусто);

    override ткст toString();
	override ткст вТкст();	

    override int opEquals(Object o);

    hash_t getHash(ук p);
	т_хэш дайХэш(ук п);	

    int equals(ук p1, ук p2);
	цел равны(ук п1, ук п2);	

    int compare(ук p1, ук p2);
	цел сравни(ук п1, ук п2);	

    override size_t tsize();
	override т_мера тразм();	

    override проц swap(ук p1, ук p2);
	override проц поменяй( ук п1, ук п2);
}
alias TypeInfo_Tuple ТипКортеж;
//////////////////////////////////////////////////////////////////////////////

extern (D) class TypeInfo_Const : ИнфОТипе
{
    override ткст toString() ;
	override ткст вТкст();

    override int opEquals(Object o);
    hash_t getHash(ук p);
	т_хэш дайХэш(ук п);
	
    int equals(ук p1, ук p2) ;
	цел равны(ук п1, ук п2);
	
    int compare(ук p1, ук p2) ;
	цел сравни(ук п1, ук п2);
	
    override size_t tsize() ;
	override т_мера тразм();
	
    override проц swap(ук p1, ук p2) ;
	override проц поменяй( ук п1, ук п2);

    override ИнфОТипе next() ;
	override ИнфОТипе следщ();
	
    override бцел flags() ;
	 override бцел флаги();
	 
    override проц[] init();
	override проц[] иниц();

   extern(C) extern ИнфОТипе base;	alias base основа;	
   
	ИнфОТипе getSetBase(ИнфОТипе base = null);
	ИнфОТипе дайУстОву(ИнфОТипе основа = пусто);
}
alias TypeInfo_Const ТипКонстанта;
///////////////////////////////////////////////////////////////////

extern (D) class TypeInfo_Invariant : TypeInfo_Const
{

    override ткст toString();
	override ткст вТкст();
}
alias TypeInfo_Invariant ТипИнвариант;
/////////////////////////////////////////////////////////////////////////////

// Object[]
extern (D) class TypeInfo_AC : TypeInfo_Array
{
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);	
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_AC ТипОбъмас;
//////////////////////////////////
// кдво[]
extern (D) class TypeInfo_Ar : TypeInfo_Array
{
    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ar ТипКдвомас;
//////////////////////////////////

// кплав[]
extern (D) class TypeInfo_Aq : TypeInfo_Array
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p) ;
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Aq ТипКплавмас;
/////////////////////////////////////

// креал[]
extern (D) class TypeInfo_Ac : TypeInfo_Array
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p) ;
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ac ТипКреалмас;
/////////////////////////////////////////////

// дво[]
extern (D) class TypeInfo_Ad : TypeInfo_Array
{

   override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p) ;
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ad ТипДвомас;
///////////////////////////

// вдво[]
extern (D) class TypeInfo_Ap : TypeInfo_Ad
{

    ткст toString();
	override ткст вТкст();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ap ТипВдвомас;
//////////////////////////////////////

// плав[]
extern (D) class TypeInfo_Af : TypeInfo_Array
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Af ТипПлавмас;
///////////////////////////////////

// вплав[]
extern (D) class TypeInfo_Ao : TypeInfo_Af
{
    override ткст toString();
	override ткст вТкст();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ao ТипВплавмас;
///////////////////////////////////

// байт[]
extern (D) class TypeInfo_Ag : TypeInfo_Array
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p) ;
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ag ТипБайтмас;
////////////////////////////////

// ббайт[]
extern (D) class TypeInfo_Ah : TypeInfo_Ag
{
    override ткст toString(); 
	override ткст вТкст();
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ah ТипБбайтмас;
////////////////////////////////

// проц[]
extern (D) class TypeInfo_Av : TypeInfo_Ah
{
    override ткст toString();
	override ткст вТкст();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Av ТипПроцмас;
//////////////////////////////////

// bool[]
extern (D) class TypeInfo_Ab : TypeInfo_Ah
{
    override ткст toString();
	override ткст вТкст();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ab ТипБулмас;
//////////////////////////////////

// ткст
extern (D) class TypeInfo_Aa : TypeInfo_Ag
{
    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Aa ТипТкст;
////////////////////////////////////

// цел[]
extern (D) class TypeInfo_Ai : TypeInfo_Array
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ai ТипЦелмас;
/////////////////////////////

// бцел[]
extern (D) class TypeInfo_Ak : TypeInfo_Ai
{
    override ткст toString();
	override ткст вТкст();
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ak ТипБцелмас;
//////////////////////////////
// юткст, дим[]
extern (D) class TypeInfo_Aw : TypeInfo_Ak
{
    override ткст toString() ;
	override ткст вТкст();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Aw ТипЮткст;
///////////////////////////////////

// дол[]
extern (D) class TypeInfo_Al : TypeInfo_Array
{
    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Al ТипДолмас;
/////////////////////////////////////////////

// бдол[]
extern (D) class TypeInfo_Am : TypeInfo_Al
{
    override ткст toString();
	override ткст вТкст();
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Am ТипБдолмас;
//////////////////////////////////////////////

// реал[]
extern (D) class TypeInfo_Ae : TypeInfo_Array
{
    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Ae ТипРеалмас;
///////////////////////////////////

// вреал[]
extern (D) class TypeInfo_Aj : TypeInfo_Ae
{
    override ткст toString();
	override ткст вТкст();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Aj ТипВреалмас;
////////////////////////////////////////

// крат[]
extern (D) class TypeInfo_As : TypeInfo_Array
{
    override ткст toString() ;
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_As ТипКратмас;
//////////////////////////////

// бкрат[]
extern (D) class TypeInfo_At : TypeInfo_As
{
    override ткст toString();
	override ткст вТкст();
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_At ТипБкратмас;
///////////////////////////////

// шткст, шим[]
extern (D) class TypeInfo_Au : TypeInfo_At
{
    override ткст toString();
	override ткст вТкст();
    override ИнфОТипе next();
	override ИнфОТипе следщ();
}
alias TypeInfo_Au ТипШткст;
///////////////////////////////

// байт
extern (D) class TypeInfo_g : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
}
alias TypeInfo_g ТипБайт;
//////////////////////////////////////

// Объект
extern (D) class TypeInfo_C : ИнфОТипе
{
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override бцел flags();
	 override бцел флаги();
}
alias TypeInfo_C ТипОбъ;
////////////////////////////////////
// кдво
extern (D) class TypeInfo_r : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override проц[] init();
	override   проц[] иниц();
}
alias TypeInfo_r ТипКдво;
////////////////////////////////////////
// кплав
extern (D) class TypeInfo_q : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override проц[] init();
	override   проц[] иниц();
}
alias TypeInfo_q ТипКплав;
////////////////////////////////////////

//сим
extern (D) class TypeInfo_a : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override проц[] init();
	override   проц[] иниц();
}
alias TypeInfo_a ТипСим;
///////////////////////////////////

// креал
extern (D) class TypeInfo_c : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);	
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override проц[] init();
	override   проц[] иниц();
}
alias TypeInfo_c ТипКреал;
///////////////////////////////////////

// дим
extern (D) class TypeInfo_w : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override проц[] init();
	override   проц[] иниц();
}
alias TypeInfo_w ТипДим;
//////////////////////////////////////

// delegate
alias проц delegate(цел) дг;

extern (D) class TypeInfo_D : ИнфОТипе
{

    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override бцел flags();
	 override бцел флаги();
}
alias TypeInfo_D ТипДг;
////////////////////////////

// дво
extern (D) class TypeInfo_d : ИнфОТипе
{
    override ткст toString() ;
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override проц[] init();
	override   проц[] иниц();
}
alias TypeInfo_d ТипДво;
///////////////////////////////

// плав
extern (D) class TypeInfo_f : ИнфОТипе
{

    override ткст toString() ;
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);	
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override проц[] init();
	override   проц[] иниц();
}
alias TypeInfo_f ТипПлав;
/////////////////////////////

// вдво
extern (D) class TypeInfo_p : TypeInfo_d
{

    override ткст toString();
	override ткст вТкст();
}
alias TypeInfo_p ТипВдво;
/////////////////////////////
// вплав
extern (D) class TypeInfo_o : TypeInfo_f
{

    override ткст toString();
	override ткст вТкст();
}
alias TypeInfo_o ТипВплав;
/////////////////////////
// цел
extern (D) class TypeInfo_i : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
}
alias TypeInfo_i ТипЦел;
///////////////////////////
// вреал
extern (D) class TypeInfo_j : TypeInfo_e
{

    override ткст toString();
	override ткст вТкст();
}
alias TypeInfo_j ТипВреал;
//////////////////////////////
// дол
extern (D) class TypeInfo_l : ИнфОТипе
{

    override ткст toString() ;
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
}
alias TypeInfo_l ТипДол;
/////////////////////////////////

// указатель
extern (D) class TypeInfo_P : ИнфОТипе
{

    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override бцел flags();
	 override бцел флаги();
}
alias TypeInfo_P ТипУк;
///////////////////////////

// реал
extern (D) class TypeInfo_e : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
        override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override проц[] init();
	override   проц[] иниц();
}
alias TypeInfo_e ТипРеал;
////////////////////////////////////

// крат
extern (D) class TypeInfo_s : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
}
alias TypeInfo_s ТипКрат;
//////////////////////////////

// ббайт
extern (D) class TypeInfo_h : ИнфОТипе
{

    override ткст toString() ;
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
}
alias TypeInfo_h ТипБбайт;
///////////////////////////////////////

extern (D) class TypeInfo_b : TypeInfo_h
{

    override ткст toString() ;
	override ткст вТкст();
}
alias TypeInfo_b ТипБул;
//////////////////////////////////

// бцел
extern (D) class TypeInfo_k : ИнфОТипе
{

    override ткст toString() ;
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
}
alias TypeInfo_k ТипБцел;
///////////////////////////////////

// бдол
extern (D) class TypeInfo_m : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
}
alias TypeInfo_m ТипБдол;
//////////////////////////////

//бкрат
extern (D) class TypeInfo_t : ИнфОТипе
{
    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
}
alias TypeInfo_t ТипБкрат;
//////////////////////////////////////

// проц
extern (D) class TypeInfo_v : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override бцел flags();
	 override бцел флаги();
}
alias TypeInfo_v ТипПроц;
///////////////////////////////

//шим
extern (D) class TypeInfo_u : ИнфОТипе
{

    override ткст toString();
	override ткст вТкст();
    override т_хэш getHash(in ук p);
	override т_хэш дайХэш(in  ук п);
    override цел equals(in ук p1, in ук p2);
	override цел равны(in ук п1, in ук п2);
    override цел compare(in ук p1, in ук p2);
	override цел сравни(in ук п1, in ук п2);
    override т_мера tsize();
	override т_мера тразм();
    override проц swap(ук p1, ук p2);
	override  проц поменяй( ук п1, ук п2);
    override проц[] init();
	override   проц[] иниц();
}
alias TypeInfo_u ТипШим;
///////////////////////////////////////////////////////