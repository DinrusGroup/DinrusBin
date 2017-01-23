module st.tls;

private import stdrus, thread;

/**
 * Исключение НитеЛокИскл генерируется в случае,
 * если во время выполнения (в рантайм) не удается
 * правильно обработать локальное поточное действие.
 */
class НитеЛокИскл : Исключение
{
    this(ткст сооб);
}

version(linux)
    version = TLS_UsePthreads;
version(darwin)
    version = TLS_UsePthreads;
version(Win32)
    version = TLS_UseWinAPI;


version(TLS_UsePthreads)
{
private import gc;

private extern(C)
{
    typedef бцел pthread_key_t;
    
    цел pthread_key_delete(pthread_key_t);
    цел pthread_key_create(pthread_key_t*, проц function(ук));
    цел pthread_setspecific(pthread_key_t, ук);
    укpthread_getspecific(pthread_key_t);
    
    const цел EAGAIN = 11;
    const цел ENOMEM = 12;
    const цел EINVAL = 22;
}

/**
 * Локальное Хранилище Потока - это механизм
 * для ассоциации переменных с определенными потоками.
 * Его использование может гарантировать принцип confinement'а, и
 * быть полезным для алгоритмов многих типов.
 */
public class НитеЛок(T)
{
    /**
     * Размещает нителокальное хранилище.
     *
     * Параметры:
     *  def =Необязательное значение по умолчанию для НЛХ.
     *
     * Выводит исключение:
     *  НитеЛокИскл, если система не может разместить хранилище.
     */
    public this(T def = T.init)
    {
        this.def = def;
        
        switch(pthread_key_create(&ключ_нлх, &clean_up))
        {
            case 0: break; //Успех
            
            case EAGAIN: throw new НитеЛокИскл
                ("Вне диапазона ключей для НЛХ");
            
            case ENOMEM: throw new НитеЛокИскл
                ("Вне диапазона памяти для НЛХ");
            
            default: throw new НитеЛокИскл
                ("Неизвестная ошибка при создании НЛХ");
        }
        
        debug (НитеЛок) скажифнс("НЛХ: Создано %s", вТкст);
    }
    
    /**
     * Вымещает НЛХ.
     */
    public ~this()
    {
        debug (НитеЛок) скажифнс("НЛХ: Удаляется %s", вТкст);
        pthread_key_delete(ключ_нлх);
    }
    
    /**
     * Возвращает: текущ значение НЛХ.
     */
    public T знач()
    {
        debug (НитеЛок) скажифнс("НЛХ: Доступ к %s", вТкст);
        
        TWrapper * w = cast(TWrapper*)pthread_getspecific(ключ_нлх);
        
        if(w is пусто)
        {
            debug(НитеЛок) скажифнс("НЛХ: Не найдено");
            return def;
        }
        
        debug(НитеЛок) скажифнс("НЛХ: Обнаружено %s", w);
        
        return w.знач;
    }
    
    /**
     * Sets the thread local storage.  Can be использован with property syntax.
     *
     * Параметры:
     *  nv = The new value of the thread local storage.
     *
     * Возвращает:
     *  nv upon success
     *
     * Выводит исключение:
     *  НитеЛокИскл if the system could not установи the НитеЛокStorage.
     */
    public T знач(T nv)
    {
        debug (НитеЛок) скажифнс("НЛХ: Устанавливается %s", вТкст);
        
        ук w_old = pthread_getspecific(ключ_нлх);
        
        if(w_old !is пусто)
        {
            (cast(TWrapper*)w_old).знач = nv;
        }
        else
        {
            switch(pthread_setspecific(ключ_нлх, TWrapper(nv)))
            {
                case 0: break;
                    
                case ENOMEM: throw new НитеЛокИскл
                    ("Недостаток памяти для установки нового НЛХ");
                
                case EINVAL: throw new НитеЛокИскл
                    ("Неверное НЛХ");
                
                default: throw new НитеЛокИскл
                    ("Неизвестная ошибка при кстановке НЛХ");
            }
        }
        
        debug(НитеЛок) скажифнс("НЛХ: Установка %s", вТкст);
        return nv;
    }
    
    /**
     * Converts the thread local storage into a stringified representation.
     * Can be useful for debugging.
     * 
     * Возвращает:
     *  A string representing the thread local storage.
     */
    public ткст вТкст()
    {
        return фм("НитеЛок[%8x]", ключ_нлх);
    }

    
    // Clean up thread local resources
    private extern(C) static проц clean_up(ук объ)
    {
        if(объ is пусто)
            return;
        
        смУдалиКорень(объ);
        delete объ;
    }
    
    // The wrapper manages the thread local attributes`
    private struct TWrapper
    {
        T знач;
        
        static ук opCall(T nv)
        {
            TWrapper * res = new TWrapper;
            смДобавьКорень(cast(ук)res);
            res.знач = nv;
            return cast(ук)res;
        }
    }
    
    private pthread_key_t ключ_нлх;
    private T def;
}

}
 else version(TLS_UseWinAPI)
{

private import gc;
    
private extern(Windows)
{
    бцел TlsAlloc();
    бул TlsFree(бцел);
    бул TlsSetValue(бцел, ук);
    ук TlsGetValue(бцел);
}

public class НитеЛок(T)
{
    public this(T def = T.init)
    {
        this.def = def;
        this.ключ_нлх = TlsAlloc();
    }
    
    public ~this()
    {
        TlsFree(ключ_нлх);
    }
    
    public T знач()
    {
        ук v = TlsGetValue(ключ_нлх);
        
        if(v is пусто)
            return def;
        
        return (cast(TWrapper*)v).знач;
    }
    
    public T знач(T nv)
    {
        TWrapper * w_old = cast(TWrapper*)TlsGetValue(ключ_нлх);
        
        if(w_old is пусто)
        {
            TlsSetValue(ключ_нлх, TWrapper(nv));
        }
        else
        {
            w_old.знач = nv;
        }
        
        return nv;
    }
    
    private бцел ключ_нлх;
    private T def;
        
    private struct TWrapper
    {
        T знач;
        
        static ук opCall(T nv)
        {
            TWrapper * res = new TWrapper;
            смДобавьКорень(cast(ук)res);
            res.знач = nv;
            return cast(ук)res;
        }
    }
}

} else {

//Use a terrible hack insteaauxd...
//Performance will be bad, but at least we can fake the result.
public class НитеЛок(T)
{
    public this(T def = T.init)
    {
        this.def = def;
    }
    
    public T знач()
    {
        synchronized(this)
        {
            Нить t = Нить.дайЭту;
            
            if(t in tls_map)
                return tls_map[t];
            return def;
        }
    }
    
    public T знач(T nv)
    {
        synchronized(this)
        {
            return tls_map[Нить.дайЭту] = nv;
        }
    }
    
    private T def;
    private T[Нить] tls_map;
}
    
}
