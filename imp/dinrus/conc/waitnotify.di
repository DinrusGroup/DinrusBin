module conc.waitnotify;

import conc.sync;
private import thread;


version (Windows) 
{
  private import winapi;

  version = ATOMIC; 

  private проц ждиВин32Реализ(HANDLE событие, Объект объ, бцел таймаут);
  
  private struct ЖдиСообщиРеализ 
  {
    private HANDLE событие;

    проц иниц() ;
    проц разрушь() ;
    проц жди(Объект объ);
    проц жди(Объект объ, бцел таймаут);
    проц уведоми() ;
  }

  private struct ЖдиСообщиВсемРеализ
  {
    private HANDLE событие;

    проц иниц();
    проц разрушь() ;
    проц жди(Объект объ) ;
    проц жди(Объект объ, бцел таймаут);
    проц уведомиВсех() ;
  }

  private {
    extern (Windows) {
      HANDLE CreateEventA(LPSECURITY_ATTRIBUTES, BOOL, BOOL, LPCSTR);
      DWORD WaitForSingleObject(HANDLE, DWORD);
      DWORD SignalObjectAndWait(HANDLE,HANDLE, DWORD,BOOL);
      DWORD SetEvent(HANDLE);
      DWORD PulseEvent(HANDLE);
      DWORD ResetEvent(HANDLE);
      DWORD WaitForMultipleObjects(DWORD, HANDLE*, BOOL, DWORD);
    }
    const DWORD INFINITE = -1;
    const DWORD WAIT_FAILED = -1;
    struct RTL_CRITICAL_SECTION {
      проц* DebugInfo;
      LONG LockCount;
      LONG RecursionCount;
      HANDLE OwningThread;
      HANDLE LockSemaphore;
      // ignore the rest
    }
    /* D Объект layout puts monitor after vtbl */
    struct InternalObjectRep
	{
      проц* vtbl;
      RTL_CRITICAL_SECTION* monitor;
    }
  }

}
 else version (linux) 
{

  private цел ZeroRecursionCount;
  static this() 
  {
    Объект объ = new Объект;
    synchronized (объ) {
      InternalObjectRep* iobj = cast(InternalObjectRep*)объ;
      ZeroRecursionCount = iobj.monitor.__m_count;
    }
    объ = пусто;
  }

 struct ЖдиСообщиРеализ 
  {
    private ubyte[48] cond;    // _pthread_cond_t has sizeof 48

    проц иниц() ;
    проц разрушь();
    проц жди(Объект объ) ;
    проц жди(Объект объ, бцел таймаут) ;
    проц уведоми();

  }

  struct ЖдиСообщиВсемРеализ {
    ЖдиСообщиРеализ wnlock;
    проц иниц() {
      wnlock.иниц();
    }
    проц разрушь() {
      wnlock.разрушь();
    }
    проц жди(Объект объ) {
      wnlock.жди(объ);
    }
    проц жди(Объект объ, бцел таймаут) {
      wnlock.жди(объ,таймаут);
    }
    проц уведомиВсех() {
      pthread_cond_broadcast(wnlock.cond);
    }
  }

  private {
    struct timespec {
      time_t tv_sec;		/* Seconds.  */
      цел tv_nsec;		/* Nanoseconds.  */
    }
    /* from bits/pthreadtypes.h */
    struct pthread_mutex_t {
      цел __m_reserved;       
      цел __m_count;          
      // ignore the rest
    };

    /* D Объект layout puts monitor after vtbl */
    struct InternalObjectRep {
      проц* vtbl;
      pthread_mutex_t* monitor;
    }
    const цел ETIMEDOUT = 110; // from errno.h
    extern (C) {
      цел pthread_cond_init(проц* cond, проц* attr);
      цел pthread_cond_destroy(проц* cond);
      цел pthread_cond_wait(проц* cond, проц* мютекс);
      цел pthread_cond_timedwait(проц* cond, проц* мютекс, timespec* abstime);
      цел pthread_cond_signal(проц* cond);
      цел pthread_cond_broadcast(проц* cond);
    }
  }
}

/* Internal D functions to aquire/отпусти object monitor */
private {
  extern (C) проц _d_monitorexit(проц* h);
  extern (C) проц _d_monitorenter(проц* h);
}


template ЖдиУведоми()
 {

  ЖдиСообщиРеализ waitNotifyImpl;

  проц иницЖдиУведоми() 
  {
    waitNotifyImpl.иниц();
  }

  проц удалиЖдиУведоми()
  {
    waitNotifyImpl.разрушь();
  }

  проц жди() {
    waitNotifyImpl.жди(this);
  }

  проц жди(бцел таймаут)
  {
    waitNotifyImpl.жди(this,таймаут);
  }

  проц уведоми() 
  {
    waitNotifyImpl.уведоми();
  }

}


class ОбъектЖдиУведоми
 {
  mixin ЖдиУведоми;
  this();
  ~this();
}


template ЖдиУведомиВсех()
 {
  ЖдиСообщиВсемРеализ waitNotifyAllImpl;

  проц иницЖдиУведомиВсех()
  { 
    waitNotifyAllImpl.иниц(); 
  }

  проц удалиЖдиУведомиВсех() 
  { 
    waitNotifyAllImpl.разрушь(); 
  }

  проц жди() 
  {
    waitNotifyAllImpl.жди(this);
  }

  проц жди(бцел таймаут)
  {
    waitNotifyAllImpl.жди(this,таймаут);
  }

  проц уведомиВсех() 
  {
    waitNotifyAllImpl.уведомиВсех();
  }
}

class ОбъектЖдиУведомиВсех
 {
  mixin ЖдиУведомиВсех;
  this() ;
  ~this();
}
