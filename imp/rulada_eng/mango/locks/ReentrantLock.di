/** \file ReentrantLock.d
 * \brief A reentrant mutual exclusion Lock with the same basic
 * behavior and semantics as the implicit monitor lock accessed using
 * <tt>synchronized</tt> methods and statements, but with extended
 * capabilities.
 *
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Ported to D by Ben Hinkle.
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.0
 */

module mango.locks.ReentrantLock;

import mango.locks.Lock;
import mango.locks.TimeUnit;
import mango.locks.Condition;

private {
  import std.thread;

  import mango.sys.Atomic;

  import mango.locks.Utils;
  import mango.locks.LockImpl;
  import mango.locks.Exceptions;
}

/** \class ReentrantLock
 * \brief A reentrant mutual exclusion Lock with the same basic
 * behavior and semantics as the implicit monitor lock accessed using
 * <tt>synchronized</tt> methods and statements, but with extended
 * capabilities.
 *
 * <p> A <tt>ReentrantLock</tt> is <em>owned</em> by the thread last
 * successfully locking, but not yet unlocking it. A thread invoking
 * <tt>lock</tt> will return, successfully acquiring the lock, when
 * the lock is not owned by another thread. The method will return
 * immediately if the current thread already owns the lock. This can
 * be checked using methods isHeldByCurrentThread, and
 * getHoldCount.  
 *
 * <p> The constructor for this class accepts an optional
 * <em>fairness</em> parameter.  When set <tt>true</tt>, under
 * contention, locks favor granting access to the longest-waiting
 * thread.  Otherwise this lock does not guarantee any particular
 * access order.  Programs using fair locks accessed by many threads
 * may display lower overall throughput (i.e., are slower; often much
 * slower) than those using the default setting, but have smaller
 * variances in times to obtain locks and guarantee lack of
 * starvation. Note however, that fairness of locks does not guarantee
 * fairness of thread scheduling. Thus, one of many threads using a
 * fair lock may obtain it multiple times in succession while other
 * active threads are not progressing and not currently holding the
 * lock.
 *
 * <p> It is recommended practice to <em>always</em> immediately
 * follow a call to <tt>lock</tt> with a <tt>try</tt> block, most
 * typically in a before/after construction such as:
 *
 * \code
 * class X {
 *   private ReentrantLock lock;
 *   // ...
 *   this() { 
 *     lock = new ReentrantLock; 
 *   }
 *   void m() { 
 *     lock.lock();  // block until condition holds
 *     try {
 *       // ... method body
 *     } finally {
 *       lock.unlock()
 *     }
 *   }
 * }
 * \endcode
 *
 * <p>In addition to implementing the Lock interface, this
 * class defines methods <tt>isLocked</tt> and
 * <tt>getLockQueueLength</tt>, as well as some associated
 * <tt>protected</tt> access methods that may be useful for
 * instrumentation and monitoring.
 *
 * <p> This lock supports a maximum of 2147483648 recursive locks by
 * the same thread. 
 */
class ReentrantLock : Lock {

  /** Synchronizer providing all implementation mechanics */
  private final Sync sync;

  /*
   * Base of synchronization control for this lock. Subclassed
   * into fair and nonfair versions below. Uses AbstractLock state to
   * represent the number of holds on the lock.
   */
  abstract class Sync : AbstractLock {
    /* Current owner thread */
    Thread owner;

    /*
     * Perform Lock.lock. The main reason for subclassing
     * is to allow fast path for nonfair version.
     */
    abstract void lock();

    /* 
     * Perform non-fair tryLock.  tryAcquire is
     * implemented in subclasses, but both need nonfair
     * try for trylock method
     */
    final bool nonfairTryAcquire(int acquires) { 
      Thread current = Thread.getThis();
      int c = state;
      if (c == 0) {
	if (Atomic.compareAndSet32(&state_, c, acquires)) {
	  owner = current;
	  return true;
	}
      }
      else if (current is owner) {
	state = c+acquires;
	return true;
      }
      return false;
    }

    final bool tryRelease(int releases) {
      if (Thread.getThis() !is owner)
	throw new IllegalArgumentException();
      int c = state - releases;
      bool free = false;
      if (c == 0) {
	free = true;
	owner = null;
      }
      state = c;
      return free;
    }

    final bool isHeldExclusively() {
      return state != 0 && owner is Thread.getThis();
    }

    final ConditionObject newCondition() {
      return new ConditionObject(this);
    }

    // Methods relayed from outer class

    final Thread getOwner() {
      int c = state;
      Thread o = owner;
      return (c == 0)? null : o;
    }
        
    final int getHoldCount() {
      int c = state;
      Thread o = owner;
      return (o is Thread.getThis())? c : 0;
    }
        
    final bool isLocked() {
      return state != 0;
    }
  }

  /*
   * Sync object for non-fair locks
   */
  final class NonfairSync : Sync {
    /*
     * Perform lock.  Try immediate barge, backing up to normal
     * acquire on failure.
     */
    final void lock() {
      if (Atomic.compareAndSet32(&state_, 0, 1))
	owner = Thread.getThis();
      else {
	acquire(1);
      }
    }

    protected final bool tryAcquire(int acquires) { 
      return nonfairTryAcquire(acquires);
    }
  }

  /*
   * Sync object for fair locks
   */
  final class FairSync : Sync {
    final void lock() { 
      acquire(1); 
    }

    /*
     * Fair version of tryAcquire.  Don't grant access unless
     * recursive call or no waiters or is first.
     */
    protected final bool tryAcquire(int acquires) { 
      Thread current = Thread.getThis();
      int c = state;
      if (c == 0) {
	Thread first = getFirstQueuedThread();
	if ((first is null || first is current) && 
	    Atomic.compareAndSet32(&state_, c, acquires)) {
	  owner = current;
	  return true;
	}
      }
      else if (current is owner) {
	state = c+acquires;
	return true;
      }
      return false;
    }
  }

  /**
   * Creates an instance of <tt>ReentrantLock</tt> with the
   * given fairness policy.
   * \param fair true if this lock will be fair; else false
   */
  this(bool fair = false) { 
    if (fair)
      sync = new FairSync();
    else
      sync = new NonfairSync();
  }

  /**
   * Acquires the lock. 
   *
   * <p>Acquires the lock if it is not held by another thread and
   * returns immediately, setting the lock hold count to one.
   *
   * If the current thread already holds the lock then the hold count
   * is incremented by one and the method returns immediately.
   *
   * <p>If the lock is held by another thread then the current thread
   * becomes disabled for thread scheduling purposes and lies dormant
   * until the lock has been acquired, at which time the lock hold
   * count is set to one.
   */
  void lock() {
    sync.lock();
  }

  /**
   * Acquires the lock only if it is not held by another thread at the time
   * of invocation.
   *
   * <p>Acquires the lock if it is not held by another thread and
   * returns immediately with the value <tt>true</tt>, setting the
   * lock hold count to one. Even when this lock has been set to use a
   * fair ordering policy, a call to <tt>tryLock()</tt> <em>will</em>
   * immediately acquire the lock if it is available, whether or not
   * other threads are currently waiting for the lock.  This
   * &quot;barging&quot; behavior can be useful in certain
   * circumstances, even though it breaks fairness.
   *
   * <p> If the current thread already holds this lock then the hold
   * count is incremented by one and the method returns <tt>true</tt>.
   *
   * <p>If the lock is held by another thread then this method will return 
   * immediately with the value <tt>false</tt>.  
   *
   * \return <tt>true</tt> if the lock was free and was acquired by the
   * current thread, or the lock was already held by the current thread; and
   * <tt>false</tt> otherwise.
   */
  bool tryLock() {
    return sync.nonfairTryAcquire(1);
  }

  /**
   * Acquires the lock if it is not held by another thread within the given 
   * waiting time.
   *
   * <p>Acquires the lock if it is not held by another thread and returns 
   * immediately with the value <tt>true</tt>, setting the lock hold count 
   * to one. If this lock has been set to use a fair ordering policy then
   * an available lock <em>will not</em> be acquired if any other threads
   * are waiting for the lock. This is in contrast to the tryLock()
   * method. If you want a timed <tt>tryLock</tt> that does permit barging on
   * a fair lock then combine the timed and un-timed forms together:
   *
   * <pre>
   *  if (lock.tryLock() || lock.tryLock(timeout, unit) ) { ... }
   * </pre>
   *
   * <p>If the current thread already holds this lock then the hold
   * count is incremented by one and the method returns <tt>true</tt>.
   *
   * <p>If the lock is held by another thread then the current thread
   * becomes disabled for thread scheduling purposes and lies dormant
   * until one of two things happens:
   * <ul>
   * <li>The lock is acquired by the current thread; or
   * <li>The specified waiting time elapses
   * </ul>
   *
   * <p>If the lock is acquired then the value <tt>true</tt> is returned and
   * the lock hold count is set to one.
   *
   * <p>If the specified waiting time elapses then the value
   * <tt>false</tt> is returned.  If the time is less than or equal to
   * zero, the method will not wait at all.
   *
   * \param time the maximum time to wait for the lock
   * \param unit the time unit of the <tt>time</tt> argument.
   *
   * \return <tt>true</tt> if the lock was free and was acquired by the
   * current thread, or the lock was already held by the current thread; and
   * <tt>false</tt> if the waiting time elapsed before the lock could be 
   * acquired.
   */
  bool tryLock(long timeout, TimeUnit unit) {
    return sync.tryAcquireNanos(1, toNanos(timeout,unit));
  }

  /**
   * Attempts to release this lock.  
   *
   * <p>If the current thread is the holder of this lock then the hold
   * count is decremented. If the hold count is now zero then the lock
   * is released.
   */
  void unlock() {
    sync.release(1);
  }

  /**
   * Returns a Condition instance for use with this Lock instance.
   *
   * <ul> <li>When the condition Condition.wait() methods are called
   * the lock is released and, before they return, the lock is
   * reacquired and the lock hold count restored to what it was when
   * the method was called.
   *
   * <li> Waiting threads are signalled in FIFO order
   *
   * <li>The ordering of lock reacquisition for threads returning
   * from waiting methods is the same as for threads initially
   * acquiring the lock, which is in the default case not specified,
   * but for <em>fair</em> locks favors those threads that have been
   * waiting the longest.
   * 
   * </ul>
   *
   * \return the Condition object
   */
  Condition newCondition() {
    return sync.newCondition();
  }

  /**
   * Queries the number of holds on this lock by the current thread.
   *
   * <p>A thread has a hold on a lock for each lock action that is not 
   * matched by an unlock action.
   *
   * <p>The hold count information is typically only used for testing and
   * debugging purposes. For example, if a certain section of code should
   * not be entered with the lock already held then we can assert that
   * fact:
   *
   * \code
   * class X {
   *   ReentrantLock lock;
   *   // ...     
   *   this() { 
   *     lock = new ReentrantLock; 
   *   }
   *   void m() { 
   *     assert( lock.getHoldCount() == 0 );
   *     lock.lock();
   *     try {
   *       // ... method body
   *     } finally {
   *       lock.unlock();
   *     }
   *   }
   * }
   * \endcode
   *
   * \return the number of holds on this lock by the current thread,
   * or zero if this lock is not held by the current thread.
   */
  int getHoldCount() {
    return sync.getHoldCount();
  }

  /**
   * Queries if this lock is held by the current thread.
   * <p>This method is typically used for debugging and
   * testing.
   * \return <tt>true</tt> if current thread holds this lock and 
   * <tt>false</tt> otherwise.
   */
  bool isHeldByCurrentThread() {
    return sync.isHeldExclusively();
  }

  /**
   * Queries if this lock is held by any thread. This method is
   * designed for use in monitoring of the system state, 
   * not for synchronization control.
   * \return <tt>true</tt> if any thread holds this lock and 
   * <tt>false</tt> otherwise.
   */
  bool isLocked() {
    return sync.isLocked();
  }

  /**
   * Returns true if this lock has fairness set true.
   * @return true if this lock has fairness set true.
   */
  final bool isFair() {
    return cast(FairSync)sync !is null;
  }

  /**
   * Returns the thread that currently owns the exclusive lock, or
   * <tt>null</tt> if not owned. Note that the owner may be
   * momentarily <tt>null</tt> even if there are threads trying to
   * acquire the lock but have not yet done so.  This method is
   * designed to facilitate construction of subclasses that provide
   * more extensive lock monitoring facilities.
   * 'return the owner, or <tt>null</tt> if not owned.
   */
  protected Thread getOwner() {
    return sync.getOwner();
  }

  /**
   * Queries whether any threads are waiting to acquire. Note that
   * because cancellations may occur at any time, a <tt>true</tt>
   * return does not guarantee that any other thread will ever
   * acquire.  This method is designed primarily for use in
   * monitoring of the system state.
   *
   * 'return true if there may be other threads waiting to acquire
   * the lock.
   */
  final bool hasQueuedThreads() { 
    return sync.hasQueuedThreads();
  }


  /**
   * Queries whether the given thread is waiting to acquire this
   * lock. Note that because cancellations may occur at any time, a
   * <tt>true</tt> return does not guarantee that this thread
   * will ever acquire.  This method is designed primarily for use
   * in monitoring of the system state.
   *
   * \param thread the thread
   * \return true if the given thread is queued waiting for this lock.
   */
  final bool hasQueuedThread(Thread thread) { 
    return sync.isQueued(thread);
  }


  /**
   * Returns an estimate of the number of threads waiting to
   * acquire.  The value is only an estimate because the number of
   * threads may change dynamically while this method traverses
   * internal data structures.  This method is designed for use in
   * monitoring of the system state, not for synchronization
   * control.
   * \return the estimated number of threads waiting for this lock
   */
  final int getQueueLength() {
    return sync.getQueueLength();
  }

  /**
   * Returns a collection containing threads that may be waiting to
   * acquire.  Because the actual set of threads may change
   * dynamically while constructing this result, the returned
   * collection is only a best-effort estimate.  The elements of the
   * returned collection are in no particular order.  This method is
   * designed to facilitate construction of subclasses that provide
   * more extensive monitoring facilities.
   * \return the collection of threads
   */
  protected Thread[] getQueuedThreads() {
    return sync.getQueuedThreads();
  }

  /**
   * Queries whether any threads are waiting on the given condition
   * associated with this lock. Note that because timeouts and
   * interrupts may occur at any time, a <tt>true</tt> return does
   * not guarantee that a future <tt>signal</tt> will awaken any
   * threads.  This method is designed primarily for use in
   * monitoring of the system state.
   * \param condition the condition
   * \return <tt>true</tt> if there are any waiting threads.
   */ 
  bool hasWaiters(Condition condition) {
    if ((condition is null) || 
	(cast(AbstractLock.ConditionObject)condition is null))
      throw new IllegalArgumentException();
    return sync.hasWaiters(cast(AbstractLock.ConditionObject)condition);
  }

  /**
   * Returns an estimate of the number of threads waiting on the
   * given condition associated with this lock. Note that because
   * timeouts and interrupts may occur at any time, the estimate
   * serves only as an upper bound on the actual number of waiters.
   * This method is designed for use in monitoring of the system
   * state, not for synchronization control.
   * \param condition the condition
   * \return the estimated number of waiting threads.
   */ 
  int getWaitQueueLength(Condition condition) {
    if ((condition is null) || 
	(cast(AbstractLock.ConditionObject)condition is null))
      throw new IllegalArgumentException();
    return sync.getWaitQueueLength(cast(AbstractLock.ConditionObject)condition);
  }

  /**
   * Returns a collection containing those threads that may be
   * waiting on the given condition associated with this lock.
   * Because the actual set of threads may change dynamically while
   * constructing this result, the returned collection is only a
   * best-effort estimate. The elements of the returned collection
   * are in no particular order.  This method is designed to
   * facilitate construction of subclasses that provide more
   * extensive condition monitoring facilities.
   * \param condition the condition
   * \return the collection of threads
   */
  protected Thread[] getWaitingThreads(Condition condition) {
    if ((condition is null) || 
	(cast(AbstractLock.ConditionObject)condition is null))
      throw new IllegalArgumentException();
    return sync.getWaitingThreads(cast(AbstractLock.ConditionObject)condition);
  }

  /**
   * Returns a string identifying this lock, as well as its lock
   * state.  The state, in brackets, includes either the String
   * &quot;Unlocked&quot; or the String &quot;Locked by&quot;
   * followed by the Thread.toString of the owning thread.
   * \return a string identifying this lock, as well as its lock state.
   */
  char[] toString() {
    Thread owner = sync.getOwner();
    return super.toString() ~ ((owner is null) ?
			       "[Unlocked]" :
			       ("[Locked by thread" ~ owner.toString() ~ "]"));
  }

  unittest {
    ReentrantLock lock;
    int acquired;
    Thread[] t;
    
    ThreadReturn f() {
      int n;
      Thread tt = Thread.getThis();
      for (n=0; n < t.length; n++) {
	if (tt is t[n])
	  break;
      }
      version (LocksVerboseUnittest)
	printf(" thread %d started\n",n);
      lock.lock();
      version (LocksVerboseUnittest)
	printf(" thread %d aquired\n",n);
      for (int k=0;k<1000;k++)
	Thread.yield();
      lock.unlock();
      acquired++;
      version (LocksVerboseUnittest)
	printf(" thread %d released\n",n);
      return 0;
    }

    lock = new ReentrantLock;
    acquired = 0;
    t = new Thread[3];
    int n;
    for (n=0; n<t.length; n++) {
      t[n] = new Thread(&f);
    }
    version (LocksVerboseUnittest)
      printf("starting locks.reentrantlock unittest\n");
    for (n=0; n<t.length; n++) {
      t[n].start();
    }
    while (acquired != n)
      Thread.yield();

    
    // test ScopedLock
    {
      auto ScopedLock sl = new ScopedLock(lock);
      assert( lock.isHeldByCurrentThread );
      
    }
    assert( ~lock.isHeldByCurrentThread );

    version (LocksVerboseUnittest)
      printf("finished locks.reentrantlock unittest\n");
  }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
