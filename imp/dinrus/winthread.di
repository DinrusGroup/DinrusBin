module winthread;
import dinrus, time.Time;

alias HANDLE Handle;
extern(Windows)
{

struct SECURITY_ATTRIBUTES {
  uint nLength;
  void* lpSecurityDescriptor;
  int bInheritHandle;
}

const uint INFINITE = 0xFFFFFFFF;

enum : uint {
  WAIT_OBJECT_0 = 0,
  WAIT_ABANDONED = 0x80,
  WAIT_ABANDONED_0 = 0x80,
  WAIT_TIMEOUT = 258,
  SYNCHRONIZE                     = 0x00100000,
  ERROR_ACCESS_DENIED           = 5,
}

uint GetLastError();

uint WaitForSingleObject(Handle hHandle, uint dwMilliseconds);

uint WaitForSingleObjectEx(Handle hHandle, uint dwMilliseconds, BOOL bAlertable);

uint WaitForMultipleObjects(uint nCount, in Handle* lpHandles, BOOL bWaitAll, uint dwMilliseconds);

uint WaitForMultipleObjectsEx(uint nCount, in Handle* lpHandles, BOOL bWaitAll, uint dwMilliseconds, BOOL bAlertable);

uint SignalObjectAndWait(Handle hObjectToSignal, Handle hObjectToWaitOn, uint dwMilliseconds, BOOL bAlertable);

void Sleep(uint dwMilliseconds);

uint SleepEx(uint dwMilliseconds, int bAlertable);

uint TlsAlloc();

int TlsFree(uint dwTlsIndex);

void* TlsGetValue(uint dwTlsIndex);

int TlsSetValue(uint dwTlsIndex, void* lpTlsValue);

Handle CreateEventW(SECURITY_ATTRIBUTES* lpEventAttributes, int bManualReset, int bInitialState, in wchar* lpName);
alias CreateEventW CreateEvent;

int SetEvent(Handle hEvent);

int ResetEvent(Handle hEvent);

Handle CreateMutexW(SECURITY_ATTRIBUTES* lpMutexAttributes, int bInitialOwner, in wchar* lpName);
alias CreateMutexW CreateMutex;

enum : uint {
  MUTEX_MODIFY_STATE = 0x0001
}
Handle OpenMutexW(uint dwDesiredAccess, int bInheritHandle, in wchar* lpName);
alias OpenMutexW OpenMutex;

int ReleaseMutex(Handle hMutex);

Handle CreateSemaphoreW(SECURITY_ATTRIBUTES* lpSemaphoreAttributes, int lInitialCount, int lMaximumCount, in wchar* lpName);
alias CreateSemaphoreW CreateSemaphore;

int ReleaseSemaphore(Handle hSemaphore, int lReleaseCount, out int lpPreviousCount);

int CloseHandle(Handle hObject);
}

class ВинНитьЛок(Т) {


  private struct ДанныеНлх {
    Т значение;
  }

  private бцел слот_;
  private Т дефЗначение_;

  /**
   * Initializes a new instance.
   */
  this(lazy Т дефЗначение = Т.init) {
    дефЗначение_ = cast(Т)дефЗначение();
    слот_ = TlsAlloc();
  }

  ~this() {
    if (auto данныеНлх = cast(ДанныеНлх*)TlsGetValue(слот_))
      удалиКорень(данныеНлх);

    TlsFree(слот_);
    слот_ = cast(бцел)-1;
  }

  /**
   * Gets the значение in the current thread's copy of this instance.
   * Возвращает: The current thread's copy of this instance.
   */
  final Т дай() {
    if (auto данныеНлх = cast(ДанныеНлх*)TlsGetValue(слот_))
      return данныеНлх.значение;
    return дефЗначение_;
  }

  /**
   * Sets the current thread's copy of this instance to the specified _value.
   * Параметры: значение = The _value to be stored in the current thread's copy of this instance.
   */
  final проц установи(Т значение) {
    auto данныеНлх = cast(ДанныеНлх*)TlsGetValue(слот_);
    if (данныеНлх is null) {
      данныеНлх = new ДанныеНлх;
      добавьКорень(данныеНлх);

      TlsSetValue(слот_, данныеНлх);
    }
    данныеНлх.значение = значение;
  }

}


/**
 * Suspends the current thread for a specified time.
 * Параметры: миллисек = The number of _milliseconds for which the thread is blocked. Specify -1 to block the thread indefinitely.
 */
проц спи(бцел миллисек);

/**
 * Suspends the current thread for a specified time.
 * Параметры: таймаут = The amount of time for which the thread is blocked. Specify -1 to block the thread indefinitely.
 */
проц спи(ИнтервалВремени таймаут);

enum ПРежимСбросаСобытия {
  Авто,
  Ручной
}

abstract class УкОжидание {

  private Дескр дескр_ = cast(Дескр)НЕВЕРНХЭНДЛ;

  проц закрой() ;

  бул ждиОдин(бцел таймаутВМиллисек = INFINITE);

  бул ждиОдин(ИнтервалВремени таймаут) ;

  static бул ждиВсе(УкОжидание[] ждиуки, бцел таймаутВМиллисек = INFINITE);

  static бцел ждиЛюбой(УкОжидание[] ждиуки, бцел таймаутВМиллисек = INFINITE);

  static бул сигнализируйИЖди(УкОжидание toSignal, УкОжидание toWaitOn, бцел таймаутВМиллисек = INFINITE) ;

  static бул сигнализируйИЖди(УкОжидание toSignal, УкОжидание toWaitOn, ИнтервалВремени таймаут);

  проц дескр(Дескр значение) ;
  
  Дескр дескр() ;

}

class ДескрОжиданияСобытия : УкОжидание {

  this(бул начСостояние, ПРежимСбросаСобытия режим) ;

  final бул установи();

  final бул сбрось() ;

}

final class СобытиеАвтоСброса : ДескрОжиданияСобытия {

  this(бул начСостояние) ;

}

final class СобытиеРучногоСброса : ДескрОжиданияСобытия {

  this(бул начСостояние);

}

final class ВинМютекс : УкОжидание {

  this(бул initiallyOwned = false, ткст имя = null);

  проц отпусти() ;

}

final class ВинСемафор : УкОжидание {

  this(цел начСчёт, цел максСчёт, ткст имя = пусто) ;

  цел отпусти(цел релизСчёт = 1);

}

