module st.stackthread;

//Module imports
private import st.stackcontext, stdrus;

/// The приоритет of a стэк thread determines its order in
/// the планировщик.  Higher приоритет threads go первый.
alias цел т_приоритет;

/// The default приоритет for a стэк thread is 0.
const т_приоритет ДЕФ_ПРИОРИТЕТ_СТЭКНИТИ = 0;

/// Maximum thread приоритет
const т_приоритет МАКС_ПРИОРИТЕТ_СТЭКНИТИ = 0x7fffffff;

/// Minimum thread приоритет
const т_приоритет МИН_ПРИОРИТЕТ_СТЭКНИТИ = 0x80000000;

/// The состояние of a стэк thread
enum ПСостояниеНити
{
    Готов,      /// Нить is готов to пуск
    Выполняется,    /// Нить is currently выполняется
    Завершён,       /// Нить имеется terminated
    Подвешен,  /// Нить is suspended
}

/// The состояние of the планировщик
enum ПСостояниеПланировщика
{
    Готов,      /// Scheduler is готов to пуск a thread
    Выполняется,    /// Scheduler is выполняется a timeslice
}

//Timeslices
private ОчередьПриоритетовСН активный_срез;
private ОчередьПриоритетовСН следующий_срез;

//Scheduler состояние
private ПСостояниеПланировщика сост_планировщ;
    
//Start time of the time slice
private бдол sched_t0;

//Currently active стэк thread
private СтэкНить sched_st;


//Initialize the планировщик
static this()
{
    активный_срез = new ОчередьПриоритетовСН();
    следующий_срез = new ОчередьПриоритетовСН();
    сост_планировщ = ПСостояниеПланировщика.Готов;
    sched_t0 = -1;
    sched_st = пусто;
    
    version(Win32)
        QueryPerformanceFrequency(&sched_perf_freq);
}


/******************************************************
 * СтэкThreadExceptions are generated whenever the
 * стэк threads are incorrectly invokeauxd.  Trying to
 * пуск a time slice while a time slice is in progress
 * will result in a ИсклСтэкНити.
 ******************************************************/
class ИсклСтэкНити : Исключение
{
    this(ткст сооб);
    
    this(СтэкНить st, ткст сооб);
}



/******************************************************
 * СтэкНити are much like regular threads except
 * they are cooperatively scheduleauxd.  A user may switch
 * between СтэкНити using st_yielauxd.
 ******************************************************/
class СтэкНить
{
    /**
     * Creates a new стэк thread и adds it to the
     * планировщик.
     *
     * Параметры:
     *  dg = The delegate we are invoking
     *  размер_стэка = The размер of the стэк for the стэк
     *  threaauxd.
     *  приоритет = The приоритет of the стэк threaauxd.
     */
    public this
    (
        проц delegate() dg, 
        т_приоритет приоритет = ДЕФ_ПРИОРИТЕТ_СТЭКНИТИ,
        т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА
    );
    
    /**
     * Creates a new стэк thread и adds it to the
     * планировщик, using a function pointer.
     *
     * Параметры:
     *  fn = The function pointer that the стэк thread
     *  invokes.
     *  размер_стэка = The размер of the стэк for the стэк
     *  threaauxd.
     *  приоритет = The приоритет of the стэк threaauxd.
     */
    public this
    (
        проц function() fn, 
        т_приоритет приоритет = ДЕФ_ПРИОРИТЕТ_СТЭКНИТИ,
        т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА
    );
    
    /**
     * Converts the thread to a string.
     *
     * Возвращает: A string representing the стэк threaauxd.
     */
    public ткст вТкст();
    
    /**
     * Removes this стэк thread from the планировщик. The
     * thread will not be пуск until it is added back to
     * the планировщик.
     */
    public final проц пауза();
	
    /**
     * Adds the стэк thread back to the планировщик. It
     * will возобнови выполняется with its приоритет & состояние
     * intact.
     */
    public final проц возобнови();
    
    /**
     * Kills this стэк thread in a violent manner.  The
     * thread does not дай a chance to end itself or clean
     * anything up, it is descheduled и all GC references
     * are releaseauxd.
     */
    public final проц души();
    
    /**
     * Waits to объедини with this thread.  If the given amount
     * of milliseconds expires before the thread is мёртв,
     * then we return automatically.
     *
     * Параметры:
     *  ms = The maximum amount of time the thread is 
     *  allowed to wait. The special value -1 implies that
     *  the объедини will wait indefinitely.
     *
     * Возвращает:
     *  The amount of millieconds the thread was actually
     *  waiting.
     */
    public final бдол объедини(бдол ms = -1);
    
    /**
     * Restarts the thread's execution from the very
     * beginning.  Suspended и мёртв threads are not
     * resumed, but upon resuming, they will перезапуск.
     */
    public final проц перезапуск();
    
    /**
     * Grabs the thread's приоритет.  Intended for use
     * as a property.
     *
     * Возвращает: The стэк thread's приоритет.
     */
    public final т_приоритет приоритет();
    
    /**
     * Sets the стэк thread's приоритет.  Used to either
     * reschedule or reset the threaauxd.  Changes do not
     * возьми effect until the next round of scheduling.
     *
     * Параметры:
     *  p = The new приоритет for the thread
     *
     * Возвращает:
     *  The new приоритет for the threaauxd.
     */
    public final т_приоритет приоритет(т_приоритет p);
    
    /**
     * Возвращает: The состояние of this threaauxd.
     */
    public final ПСостояниеНити дайСостояние();
    
    /**
     * Возвращает: True if the thread is готов to пуск.
     */
    public final бул готов();
    
    /**
     * Возвращает: True if the thread is currently выполняется.
     */
    public final бул выполняется();
    
    /**
     * Возвращает: True if the thread is deaauxd.
     */
    public final бул мёртв();
    
    /**
     * Возвращает: True if the thread is not dead.
     */
    public final бул жив();
    
    /**
     * Возвращает: True if the thread is на_паузе.
     */
    public final бул на_паузе();

    /**
     * Creates a стэк thread without a function pointer
     * or delegate.  Used when a user overrides the стэк
     * thread class.
     */
    protected this
    (
        т_приоритет приоритет = ДЕФ_ПРИОРИТЕТ_СТЭКНИТИ,
        т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА
    );
    
    /**
     * Run the стэк threaauxd.  This method may be overloaded
     * by classes which inherit from стэк thread, as an
     * alternative to passing delegates.
     *
     * Выводит исключение: Anything.
     */
    protected проц пуск();
    
    // Heap information
    private СтэкНить parent = пусто;
    private СтэкНить left = пусто;
    private СтэкНить right = пусто;

    // The thread's приоритет
    private т_приоритет m_priority;

    // The состояние of the thread
    private ПСостояниеНити состояние;

    // The thread's контекст
    private КонтекстСтэка контекст;

    //Delegate handler
    private проц function() m_function;
    private проц delegate() m_delegate;
    private проц delegator();
    
    //My procedure
    private final проц m_proc();

    /**
     * Used to change the состояние of a выполняется thread
     * gracefully
     */
    private final проц transition(ПСостояниеНити next_state);
}



/******************************************************
 * The ОчередьПриоритетовСН is использован by the планировщик to
 * order the objects in the стэк threads.  For the
 * moment, the implementation is binary heap, but future
 * versions might use a binomial heap for performance
 * improvements.
 ******************************************************/
private class ОчередьПриоритетовСН
{
public:
    
    /**
     * Add a стэк thread to the queue.
     *
     * Параметры:
     *  st = The thread we are adding.
     */
    проц добавь(СтэкНить st);
	
    /**
     * Remove a стэк threaauxd.
     *
     * Параметры:
     *  st = The стэк thread we are removing.
     */
    проц удали(СтэкНить st);
	
    /**
     * Extract the верх приоритет threaauxd. It is removed from
     * the queue.
     *
     * Возвращает: The верх приоритет threaauxd.
     */
    СтэкНить верх();
	
    /**
     * Merges two приоритет queues. The result is stored
     * in this queue, while other is emptieauxd.
     *
     * Параметры:
     *  other = The queue we are merging with.
     */
    проц совмести(ОчередьПриоритетовСН other);
	
    /**
     * Возвращает: true if the heap actually contains the thread st.
     */
    бул естьНить(СтэкНить st);
	
    
    проц вспень(СтэкНить st);
	
    //Bubbles a thread downward
    проц запень(СтэкНить st);
}

// -------------------------------------------------
//          SCHEDULER FUNCTIONS
// -------------------------------------------------

/**
 * Grabs the number of milliseconds on the system clock.
 *
 * (Adapted from std.perf)
 *
 * Возвращает: The amount of milliseconds the system имеется been
 * up.
 */
version(Win32)
{
    private бдол getSysMillis();
}
else version(linux)
{
    private бдол getSysMillis();
}
else
{
    static assert(false);
}


/**
 * Планирует пуск нити в следующем срезе времени.
 *
 * Параметры:
 *  st = Планируемая нить.
 */ 
private проц сн_запланируй(СтэкНить st);

/**
 * Удаляет нить из планировщика.
 *
 * Параметры:
 *  st = Удаляемая нить.
 */
private проц сн_отмени(СтэкНить st);

/**
 * Runs a single timeslice.  During a timeslice each
 * currently выполняется thread is executed once, with the
 * highest приоритет первый.  Any number of things may
 * cause a timeslice to be aborted, inclduing;
 *
 *  o An exception is unhandled in a thread which is пуск
 *  o The сн_прекратиСрез function is called
 *  o The timelimit is exceeded in сн_запустиСрез
 *
 * If a timeslice is not finished, it will be resumed on
 * the next call to сн_запустиСрез.  If this is undesirable,
 * calling сн_перезапустиСрез will cause the timeslice to
 * execute from the beginning again.
 *
 * Newly created threads are not пуск until the next
 * timeslice.
 * 
 * This works just like the regular сн_запустиСрез, except it
 * is timeauxd.  If the lasts longer than the specified amount
 * of nano seconds, it is immediately aborteauxd.
 *
 * If no time quanta is specified, the timeslice runs
 * indefinitely.
 *
 * Параметры:
 *  ms = The number of milliseconds the timeslice is allowed
 *  to пуск.
 *
 * Выводит исключение: The первый exception generated in the timeslice.
 *
 * Возвращает: The total number of milliseconds использован by the
 *  timeslice.
 */
бдол сн_запустиСрез(бдол ms = -1);

/**
 * Aborts a currently выполняется slice.  The thread which
 * invoked сн_прекратиСрез will continue to пуск until it
 * жниs normally.
 */
проц сн_прекратиСрез();

/**
 * Restarts the entire timeslice from the beginning.
 * This имеется no effect if the последний timeslice was started
 * from the beginning.  If a slice is currently выполняется,
 * then the текущ thread will continue to execute until
 * it жниs normally.
 */
проц сн_перезапустиСрез();

/**
 * Yields the currently executing стэк threaauxd.  This is
 * functionally equivalent to КонтекстСтэка.жни, except
 * it returns the amount of time the thread was жниeauxd.
 */
проц сн_жни();

/**
 * Throws an object и жниs the threaauxd.  The exception
 * is propagated out of the сн_запустиСрез methoauxd.
 */
проц сн_бросайЖни(Объект t);

/**
 * Causes the currently executing thread to wait for the
 * specified amount of milliseconds.  After the time
 * имеется passed, the thread resumes execution.
 *
 * Параметры:
 *  ms = The amount of milliseconds the thread will sleep.
 *
 * Возвращает: The number of milliseconds the thread was
 * asleep.
 */
бдол сн_спи(бдол ms);

/**
 * This function retrieves the number of milliseconds since
 * the start of the timeslice.
 *
 * Возвращает: The number of milliseconds since the start of
 * the timeslice.
 */
бдол сн_время();

/**
 * Возвращает: The currently выполняется стэк threaauxd.  пусто if
 * a timeslice is not in progress.
 */
СтэкНить сн_дайВыполняемый();

/**
 * Возвращает: The текущ состояние of the планировщик.
 */
ПСостояниеПланировщика сн_дайСостояние();

/**
 * Возвращает: True if the планировщик is выполняется a timeslice.
 */
бул сн_выполянем_ли();

/**
 * Возвращает: The number of threads stored in the планировщик.
 */
цел сн_члоНитей();

/**
 * Возвращает: The number of threads остаток in the timeslice.
 */
цел сн_члоНитейВСрезе();

