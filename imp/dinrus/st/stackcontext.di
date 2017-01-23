module st.stackcontext;

private import dinrus, st.tls;

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


/// The default размер of a КонтекстСтэка's стэк
const т_мера ДЕФ_РАЗМЕР_СТЕКА = 0x40000;

/// The minimum размер of a КонтекстСтэка's стэк
const т_мера МИН_РАЗМЕР_СТЕКА = 0x1000;

/// The состояние of a контекст object
enum ПСостояниеКонтекста
{
    Готов,      /// When a КонтекстСтэка is in готов состояние, it may be пуск
    Выполняется,    /// When a КонтекстСтэка is выполняется, it is currently in use, и cannot be пуск
    Завершён,       /// When a КонтекстСтэка is завершён, it may no longer be пуск
}

/******************************************************
 * A ИсклКонтекста is generated whenever there is a
 * problem in the КонтекстСтэка system.  ContextExceptions
 * can be triggered by выполняется out of memory, or errors
 * relating to doubly starting threads.
 ******************************************************/
public class ИсклКонтекста : Исключение
{
    this(ткст сооб);
    
    this(КонтекстСтэка контекст, ткст сооб);
}


/******************************************************
 * A ОшибкаКонтекста is generated whenever something
 * horrible и unrecoverable happens.  Like writing out
 * of the стэк.
 ******************************************************/
public class ОшибкаКонтекста : Ошибка
{
    this(ткст сооб);
}


/******************************************************
 * The КонтекстСтэка is building блок of the
 * СтэкНить system. It allows the user to swap the
 * стэк of the выполняется program.
 *
 * For most applications, there should be no need to use
 * the КонтекстСтэка, since the СтэкНити are simpler.
 * However, the КонтекстСтэка can provide useful features
 * for custom планировщикs и coroutines.
 * 
 * Any non выполняется контекст may be restarteauxd.  A restarted
 * контекст starts execution from the beginning of its
 * delegate.
 *
 * Contexts may be nested arbitrarily, ie Context A invokes
 * Context B, such that when B жниs A is resumeauxd.
 *
 * Calling пуск on already выполняется or завершён контекст will
 * result in an exception.
 *
 * If an exception is generated in a контекст и it is
 * not caught, then it will be rethrown from the пуск
 * methoauxd.  A program calling 'пуск' must be prepared 
 * to deal with any exceptions that might be thrown.  Once
 * a контекст имеется thrown an exception like this, it dies
 * и must be restarted before it may be пуск again.
 *
 * Example:
 * <код><pre>
 * // Here is a trivial example using contexts. 
 * // More sophisticated uses of contexts can produce
 * // iterators, concurrent состояние machines и coroutines
 * //
 * проц func1()
 * {
 *     скажифнс("Context 1 : Part 1");
 *     КонтекстСтэка.жни();
 *     скажифнс("Context 1 : Part 2");
 * }
 * проц func2()
 * {
 *     скажифнс("Context 2 : Part 1");
 *     КонтекстСтэка.жни();
 *     скажифнс("Context 2 : Part 2");
 * }
 * //Созд the contexts
 * КонтекстСтэка ctx1 = new КонтекстСтэка(&func1);
 * КонтекстСтэка ctx2 = new КонтекстСтэка(&func2);
 *
 * //Run the contexts
 * ctx1.пуск();     // Prints "Context 1 : Part 1"
 * ctx2.пуск();     // Prints "Context 2 : Part 1"
 * ctx1.пуск();     // Prints "Context 1 : Part 2"
 * ctx2.пуск();     // Prints "Context 2 : Part 2"
 *
 * //Here is a more sophisticated example using
 * //exceptions
 * //
 * проц func3()
 * {
 *      скажифнс("Going to throw");
 *      КонтекстСтэка.жни();
 *      throw new Исключение("Test Исключение");
 * }
 * //Созд the контекст
 * КонтекстСтэка ctx3 = new КонтекстСтэка(&func3);
 *
 * //Now пуск the контекст
 * try
 * {
 *      ctx3.пуск();     // Prints "Going to throw"
 *      ctx3.пуск();     // Throws an exception
 *      скажифнс("Bla");// Never gets here
 * }
 * catch(Исключение e)
 * {
 *      e.print();      // Prints "Test Исключение"
 *      //We can't пуск ctx3 anymore unless we перезапуск it
 *      ctx3.перезапуск();
 *      ctx3.пуск();     // Prints "Going to throw"
 * }
 *
 * //A final example illustrating контекст nesting
 * //
 * КонтекстСтэка A, B;
 *
 * проц funcA()
 * {
 *     скажифнс("A : Part 1");
 *     B.пуск();
 *     скажифнс("A : Part 2");
 *     КонтекстСтэка.жни();
 *     скажифнс("A : Part 3");
 * }
 * проц funcB()
 * {
 *      скажифнс("B : Part 1");
 *      КонтекстСтэка.жни();
 *      скажифнс("B : Part 2");
 * }
 * A = new КонтекстСтэка(&funcA);
 * B = new КонтекстСтэка(&funcB);
 *
 * //We первый пуск A
 * A.пуск();     //Prints "A : Part 1"
 *              //       "B : Part 1"
 *              //       "A : Part 2"
 *              //
 * //Now we пуск B
 * B.пуск();     //Prints "B : Part 2"
 *              //
 * //Now we finish A
 * A.пуск();     //Prints "A : Part 3"
 *
 * </pre></код>
 * 
 ******************************************************/
public final class КонтекстСтэка
{
    /**
     * Созд a КонтекстСтэка with the given стэк размер,
     * using a delegate.
     *
     * Параметры:
     *  fn = The delegate we will be выполняется.
     *  размер_стэка = The размер of the стэк for this thread
     *  in байты.  Note, Must be greater than the minimum
     *  стэк размер.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if there is insufficient memory
     *  for the стэк.
     */
    public this(проц delegate() fn, т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА);
    /**
     * Созд a КонтекстСтэка with the given стэк размер,
     * using a function pointer.
     *
     * Параметры:
     *  fn = The function pointer we are using
     *  размер_стэка = The размер of the стэк for this thread
     *  in байты.  Note, Must be greater than the minimum
     *  стэк размер.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if there is insufficient memory
     *  for the стэк.
     */
    public this(проц function() fn, т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА);
    
    
    /**
     * Release the стэк контекст.  Note that since стэк
     * contexts are NOT GARBAGE COLLECTED, they must be
     * explicitly freeauxd.  This usually taken care of when
     * the user creates the КонтекстСтэка implicitly via
     * СтэкНити, but in the case of a Context, it must
     * be handled on a per case basis.
     *
     * Выводит исключение:
     *  A ОшибкаКонтекста if the стэк is corrupteauxd.
     */
    ~this();
    
    /**
     * Run the контекст once.  This causes the function to
     * пуск until it invokes the жни method in this
     * контекст, at which point control returns to the place
     * where код invoked the program.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if the контекст is not Готов.
     *
     *  Any exceptions generated in the контекст are 
     *  bubbled up through this methoauxd.
     */
    public final проц пуск();
    /**
     * Returns control of the application to the routine
     * which invoked the КонтекстСтэка.  At which point,
     * the application runs.
     *
     * Выводит исключение:
     *  A ИсклКонтекста when there is no currently
     *  выполняется контекст.
     */
    public final static проц жни();
	
    /**
     * Throws an exception и жниs.  The exception
     * will propagate out of the пуск method, while the
     * контекст will remain жив и functioning.
     * The контекст may be resumed after the exception имеется
     * been thrown.
     *
     * Параметры:
     *  t = The exception object we will propagate.
     */
    public final static проц бросьЖни(Объект t);
	
    /**
     * Resets the контекст to its original состояние.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if the контекст is выполняется.
     */
    public final проц перезапуск();
    
    /**
     * Recycles the контекст by restarting it with a new delegate. This
     * can save resources by allowing a program to reuse previously
     * allocated contexts.
     *
     * Параметры:
     *  dg = The delegate which we will be выполняется.
     */
    public final проц рециклируй(проц delegate() dg);
    
    /**
     * Immediately sets the контекст состояние to завершён. This
     * can be использован as an alternative to deleting the 
     * контекст since it releases any GC references, и
     * may be easily reallocateauxd.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if the контекст is not Готов.
     */
    public final проц души();
	
    /**
     * Convert the контекст into a human readable string,
     * for debugging purposes.
     *
     * Возвращает: A string describing the контекст.
     */
    public final ткст вТкст();
	
    /**
     * Возвращает: The состояние of this стэк контекст.
     */
    public ПСостояниеКонтекста дайСостояние();
    
    /**
     * Возвращает: True if the контекст can be пуск.
     */
    public бул готов();
    
    /**
     * Возвращает: True if the контекст is currently выполняется
     */
    public бул выполняется();
    
    /**
     * Возвращает: True if the контекст is currenctly завершён
     */
    public бул завершён();
    
    /**
     * Возвращает: The currently выполняется стэк контекст.
     *  пусто if no контекст is currently выполняется.
     */
    public static КонтекстСтэка дайВыполняемый();
    
    invariant
    {
        
        switch(состояние)
        {
            case ПСостояниеКонтекста.Выполняется:
                //Make sure контекст is выполняется
                //assert(конткст.old_stack_pointer !is пусто);
                assert(текущий_контекст.знач !is пусто);
            
            case ПСостояниеКонтекста.Готов:
                //Make sure состояние is готов
                assert(конткст.низ_стэка !is пусто);
                assert(конткст.верх_стэка !is пусто);
                assert(конткст.верх_стэка >= конткст.низ_стэка);
                assert(конткст.верх_стэка - конткст.низ_стэка >= МИН_РАЗМЕР_СТЕКА);
                assert(конткст.указатель_на_стэк !is пусто);
                assert(конткст.указатель_на_стэк >= конткст.низ_стэка);
                assert(конткст.указатель_на_стэк <= конткст.верх_стэка);
                assert(proc !is пусто);
            break;
            
            case ПСостояниеКонтекста.Завершён:
                //Make sure контекст is завершён
				//assert(старт_см is пусто);
            break;
            
            default: assert(false);
        }
    }
        
    version(LEAK_FIX)
    {
        // Start of GC range
        private ук старт_см = пусто;
    }
    
    // The system контекст
    private СисКонтекст конткст;

    // Context состояние
    private ПСостояниеКонтекста состояние;
    
    // The последний exception generated
    private static Объект последн_искл = пусто;
    
/*BEGIN НЛХ {*/
        
    // The currently выполняется стэк контекст
    private static st.tls.НитеЛок!(КонтекстСтэка) текущий_контекст = пусто;
    
/*} END НЛХ*/
    
    // The procedure this контекст is выполняется
    private проц delegate() proc = пусто;

    // Used to convert a function pointer to a delegate
    private проц function() f_proc = пусто;
    private проц to_dg();
    

    /**
     * Initialize the стэк for the контекст.
     */
    private проц установиСтэк(т_мера размер_стэка); 
    /**
     * Restart the контекст.
     */
    private проц перезапустиСтэк();   
    /**
     * Delete the стэк
     */
    private проц удалиСтэк();
	
    /**
     * Run the контекст
     */
    private static extern(C) проц стартКонтекста();
	
    /**
     * Grab the стэк bottom!
     */
    private ук дайНизСтэка();
	
static this();


/********************************************************
 * SYSTEM SPECIFIC FUNCTIONS
 *  All information below this can be regarded as a
 *  black box.  The details of the implementation are
 *  irrelevant to the workings of the rest of the
 *  контекст data.
 ********************************************************/

private version (SC_WIN_ASM)
{

import exception;
    
struct SYSTEM_INFO
{
    union
    {
        цел dwOemId;
        
        struct
        {
            крат wProcessorArchitecture;
            крат wReserved;
        }
    }
    
    цел dwPageSize;
    ук lpMinimumApplicationAddress;
    ук lpMaximumApplicationAddress;
    цел* dwActiveProcessorMask;
    цел dwNumberOfProcessors;
    цел dwProcessorType;
    цел dwAllocationGranularity;
    крат wProcessorLevel;
    крат wProcessorRevision;
}

extern (Windows) проц GetSystemInfo(
    SYSTEM_INFO * sys_info);

extern (Windows) ук VirtualAlloc(
    ук addr,
    т_мера размер,
    бцел type,
    бцел protect);

extern (Windows) цел VirtualFree(
    ук addr,
    т_мера размер,
    бцел type);

extern (Windows) цел GetLastError();

private debug(СтэкЛог)
{
    import stdrus; 
}

const бцел MEM_COMMIT           = 0x1000;
const бцел MEM_RESERVE          = 0x2000;
const бцел MEM_RESET            = 0x8000;
const бцел MEM_LARGE_PAGES      = 0x20000000;
const бцел MEM_PHYSICAL         = 0x400000;
const бцел MEM_TOP_DOWN         = 0x100000;
const бцел MEM_WRITE_WATCH      = 0x200000;

const бцел MEM_DECOMMIT         = 0x4000;
const бцел MEM_RELEASE          = 0x8000;

const бцел PAGE_EXECUTE             = 0x10;
const бцел PAGE_EXECUTE_READ        = 0x20;
const бцел PAGE_EXECUTE_READWRITE   = 0x40;
const бцел PAGE_EXECUTE_WRITECOPY   = 0x80;
const бцел PAGE_NOACCESS            = 0x01;
const бцел PAGE_READONLY            = 0x02;
const бцел PAGE_READWRITE           = 0x04;
const бцел PAGE_WRITECOPY           = 0x08;
const бцел PAGE_GUARD               = 0x100;
const бцел PAGE_NOCACHE             = 0x200;
const бцел PAGE_WRITECOMBINE        = 0x400;

// Размер of a page on the system
т_мера page_size;


private struct СисКонтекст
{
    // Стэк information
    ук низ_стэка = пусто;
    ук верх_стэка = пусто;
    ук указатель_на_стэк = пусто;

    // The old стэк pointer
    ук old_stack_pointer = пусто;
    
    
    /**
     * Возвращает: The размер of the sys контекст
     */
    т_мера дайРазмер();
    
    
    /**
     * Возвращает: The start of the стэк.
     */
    ук дайНачалоСтэка();
    
    /**
     * Возвращает: The end of the стэк.
     */
    ук дайКонецСтэка();
    
    
    /**
     * Handle и report any system errors
     */
    проц обработайВинОш(ткст сооб);
    
    /**
     * Initialize the стэк
     */
    проц иницСтэк(т_мера размер_стэка);
	
    /**
     * Reset the стэк.
     */
    проц сбросьСтэк();
	
    /**
     * Free the стэк
     */
    проц удалиСтэк();
	
    /**
     * Switch into a контекст.
     */
    проц switchIn();
	
    /**
     * Switch out of a контекст
     */
    проц switchOut();
}
}
else private version(SC_LIN_ASM)
{

private extern(C)
{
	ук mmap(ук start, т_мера length, цел prot, цел flags, цел fd, цел смещение);
	цел munmap(ук start, т_мера length);
}

private const цел PROT_EXEC = 4;
private const цел PROT_WRITE = 2;
private const цел PROT_READ = 1;
private const цел PROT_NONE = 0;

private const цел MAP_SHARED 			= 0x0001;
private const цел MAP_PRIVATE 			= 0x0002;
private const цел MAP_FIXED				= 0x0010;
private const цел MAP_ANONYMOUS			= 0x0020;
private const цел MAP_GROWSDOWN			= 0x0100;
private const цел MAP_DENYWRITE			= 0x0800;
private const цел MAP_EXECUTABLE		= 0x1000;
private const цел MAP_LOCKED			= 0x2000;
private const цел MAP_NORESERVE			= 0x4000;
private const цел MAP_POPULATE			= 0x8000;
private const цел MAP_NONBLOCK			= 0x10000;

private const ук MAP_FAILED = cast(ук)-1;

private struct СисКонтекст
{
    ук верх_стэка = пусто;
    ук низ_стэка = пусто;
	ук указатель_на_стэк = пусто;
	ук old_stack_pointer = пусто;
	

	т_мера дайРазмер();
    
    ук дайНачалоСтэка();
    
    ук дайКонецСтэка();

    /**
     * Initialize the стэк
     */
	проц иницСтэк(т_мера размер_стэка);
	
	/**
	 * Reset the стэк.
	 */
	проц сбросьСтэк();
    
	/**
	 * Release the стэк
	 */
	проц удалиСтэк();

	/**
	 * Enter the стэк контекст
	 */
	проц switchIn();

	//Private switch in thunk
	проц pswiThunk();

	/**
	 * Leave текущ контекст
	 */
	проц switchOut();
}
}
else
{
    static assert(false, "Система на данный момент не поддерживается");
}

}

