/** \file Semaphore.d
 * \brief Counting semaphore
 *
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Ported to D by Ben Hinkle.
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.0
 */

module mango.locks.Semaphore;

private {
  import std.thread;

  import mango.sys.Atomic;

  import mango.locks.Utils;
  import mango.locks.LockImpl;
  import mango.locks.TimeUnit;
  import mango.locks.Exceptions;
}

/** \class Semaphore
 * \brief A counting semaphore. 
 *
 * Conceptually, a semaphore maintains a set of permits.  Each acquire
 * blocks if necessary until a permit is available, and then takes it.
 * Each release adds a permit, potentially releasing a blocking
 * acquirer.  However, no actual permit objects are used; the
 * <tt>Semaphore</tt> just keeps a count of the number available and
 * acts accordingly.
 *
 * <p>Semaphores are often used to restrict the number of threads than
 * can access some (physical or logical) resource. For example, here
 * is a class that uses a semaphore to control access to a pool of
 * items:
 * \code
 * class Pool {
 *   private const MAX_AVAILABLE = 100;
 *   private Semaphore available;
 *
 *   this() {
 *     available = new Semaphore(MAX_AVAILABLE, true);
 *     used = new bool[MAX_AVAILABLE];
 *   }
 *
 *   Object getItem() {
 *     available.acquire();
 *     return getNextAvailableItem();
 *   }
 *
 *   void putItem(Object x) {
 *     if (markAsUnused(x))
 *       available.release();
 *   }
 *
 *   // Not a particularly efficient data structure; just for demo
 *
 *   protected Object[] items; // whatever kinds of items being managed
 *   protected bool[] used;
 *
 *   protected synchronized Object getNextAvailableItem() {
 *     for (int i = 0; i < MAX_AVAILABLE; ++i) {
 *       if (!used[i]) {
 *          used[i] = true;
 *          return items[i];
 *       }
 *     }
 *     return null; // not reached
 *   }
 *
 *   protected synchronized bool markAsUnused(Object item) {
 *     for (int i = 0; i < MAX_AVAILABLE; ++i) {
 *       if (item == items[i]) {
 *          if (used[i]) {
 *            used[i] = false;
 *            return true;
 *          } else
 *            return false;
 *       }
 *     }
 *     return false;
 *   }
 * }
 * \endcode
 *
 * <p>Before obtaining an item each thread must acquire a permit from
 * the semaphore, guaranteeing that an item is available for use. When
 * the thread has finished with the item it is returned back to the
 * pool and a permit is returned to the semaphore, allowing another
 * thread to acquire that item.  Note that no synchronization lock is
 * held when acquire is called as that would prevent an item from
 * being returned to the pool.  The semaphore encapsulates the
 * synchronization needed to restrict access to the pool, separately
 * from any synchronization needed to maintain the consistency of the
 * pool itself.
 *
 * <p>A semaphore initialized to one, and which is used such that it
 * only has at most one permit available, can serve as a mutual
 * exclusion lock.  This is more commonly known as a <em>binary
 * semaphore</em>, because it only has two states: one permit
 * available, or zero permits available.  When used in this way, the
 * binary semaphore has the property (unlike many Lock
 * implementations), that the &quot;lock&quot; can be released by a
 * thread other than the owner (as semaphores have no notion of
 * ownership).  This can be useful in some specialized contexts, such
 * as deadlock recovery.
 *
 * <p> The constructor for this class optionally accepts a
 * <em>fairness</em> parameter. When set false, this class makes no
 * guarantees about the order in which threads acquire permits. In
 * particular, <em>barging</em> is permitted, that is, a thread
 * invoking acquire can be allocated a permit ahead of a thread that
 * has been waiting.  When fairness is set true, the semaphore
 * guarantees that threads invoking any of the acquire() methods are
 * allocated permits in the order in which their invocation of those
 * methods was processed (first-in-first-out; FIFO). Note that FIFO
 * ordering necessarily applies to specific internal points of
 * execution within these methods.  So, it is possible for one thread
 * to invoke <tt>acquire</tt> before another, but reach the ordering
 * point after the other, and similarly upon return from the method.
 *
 * <p>Generally, semaphores used to control resource access should be
 * initialized as fair, to ensure that no thread is starved out from
 * accessing a resource. When using semaphores for other kinds of
 * synchronization control, the throughput advantages of non-fair
 * ordering often outweigh fairness considerations.
 *
 * <p>This class also provides convenience methods to acquire and
 * release multiple permits at a time.  Beware of the increased risk
 * of indefinite postponement when these methods are used without
 * fairness set true.
 */
class Semaphore {
  /** All mechanics via AbstractLock subclass */
  private Sync sync;

  /**
   * Synchronization implementation for semaphore.  Uses AL state
   * to represent permits. Subclassed into fair and nonfair
   * versions.
   */
  abstract class Sync : AbstractLock {
    this(int permits) {
      state = permits;
    }
        
    final int getPermits() {
      return state;
    }

    final int nonfairTryAcquireShared(int acquires) {
      for (;;) {
	int available = state;
	int remaining = available - acquires;
	if (remaining < 0 ||
	    Atomic.compareAndSet32(&state_, available, remaining))
	  return remaining;
      }
    }
        
    protected final bool tryReleaseShared(int releases) {
      for (;;) {
	int p = state;
	if (Atomic.compareAndSet32(&state_, p, p + releases)) 
	  return true;
      }
    }

    final void reducePermits(int reductions) {
      for (;;) {
	int current = state;
	if (Atomic.compareAndSet32(&state_, current, current - reductions))
	  return;
      }
    }

    final int drainPermits() {
      for (;;) {
	int current = state;
	if (current == 0 || Atomic.compareAndSet32(&state_, current, 0))
	  return current;
      }
    }
  }

  /**
   * NonFair version
   */
  final class NonfairSync : Sync {
    this(int permits) {
      super(permits);
    }
       
    protected int tryAcquireShared(int acquires) {
      return nonfairTryAcquireShared(acquires);
    }
  }

  /**
   * Fair version
   */
  final class FairSync : Sync {
    this(int permits) {
      super(permits);
    }
        
    protected int tryAcquireShared(int acquires) {
      Thread current = Thread.getThis();
      for (;;) {
	Thread first = getFirstQueuedThread();
	if (first !is null && first !is current)
	  return -1;
	int available = state;
	int remaining = available - acquires;
	if (remaining < 0 ||
	    Atomic.compareAndSet32(&state_, available, remaining))
	  return remaining;
      }
    }
  }

  /**
   * Creates a <tt>Semaphore</tt> with the given number of permits and
   * the given fairness setting.
   *
   * \param permits the initial number of permits available. This
   * value may be negative, in which case releases must occur before
   * any acquires will be granted.
   *
   * \param fair true if this semaphore will guarantee first-in
   * first-out granting of permits under contention, else false.
   */
  this(int permits, bool fair = false) { 
    if (fair)
      sync = new FairSync(permits);
    else
      sync = new NonfairSync(permits);
  }

  /**
   * Acquires the given number of permits from this semaphore,
   * blocking until all are available.
   *
   * <p>Acquires the given number of permits, if they are available,
   * and returns immediately, reducing the number of available permits
   * by the given amount.
   *
   * <p>If insufficient permits are available then the current thread
   * becomes disabled for thread scheduling purposes and lies dormant
   * until some other thread invokes one of the release methods for
   * this semaphore, the current thread is next to be assigned permits
   * and the number of available permits satisfies this request.
   *
   * \param permits the number of permits to acquire (default 1)
   */
  void acquire(int permits = 1) {
    if (permits < 0)
      throw new IllegalArgumentException();
    sync.acquireShared(permits);
  }

  /**
   * Acquires the given number of permits from this semaphore, only if
   * all are available at the time of invocation.
   *
   * <p>Acquires the given number of permits, if they are available,
   * and returns immediately, with the value <tt>true</tt>, reducing
   * the number of available permits by the given amount.
   *
   * <p>If insufficient permits are available then this method will
   * return immediately with the value <tt>false</tt> and the number
   * of available permits is unchanged.
   *
   * <p>Even when this semaphore has been set to use a fair ordering
   * policy, a call to <tt>tryAcquire</tt> <em>will</em> immediately
   * acquire a permit if one is available, whether or not other
   * threads are currently waiting.  This &quot;barging&quot; behavior
   * can be useful in certain circumstances, even though it breaks
   * fairness. If you want to honor the fairness setting, then use
   * tryAcquire(int, long, TimeUnit) which is almost equivalent.
   *
   * \param permits the number of permits to acquire
   *
   * \return <tt>true</tt> if the permits were acquired and <tt>false</tt>
   * otherwise.
   */
  bool tryAcquire(int permits = 1) {
    if (permits < 0)
      throw new IllegalArgumentException();
    return sync.nonfairTryAcquireShared(permits) >= 0;
  }

  /**
   * Acquires the given number of permits from this semaphore, if all
   * become available within the given waiting time.
   *
   * <p>Acquires the given number of permits, if they are available
   * and returns immediately, with the value <tt>true</tt>, reducing
   * the number of available permits by the given amount.
   *
   * <p>If insufficient permits are available then
   * the current thread becomes disabled for thread scheduling
   * purposes and lies dormant until one of three things happens:
   *  - Some other thread invokes one of the release
   * methods for this semaphore, the current thread is next to be assigned
   * permits and the number of available permits satisfies this request; or
   * <li>The specified waiting time elapses.
   * </ul>
   * <p>If the permits are acquired then the value <tt>true</tt> is returned.
   *
   * <p>If the specified waiting time elapses then the value <tt>false</tt>
   * is returned.
   * If the time is
   * less than or equal to zero, the method will not wait at all.
   * Any permits that were to be assigned to this thread, are instead 
   * assigned to the next waiting thread(s), as if
   * they had been made available by a call to release.
   *
   * \param permits the number of permits to acquire
   * \param timeout the maximum time to wait for the permits
   * \param unit the time unit of the <tt>timeout</tt> argument.
   * \return <tt>true</tt> if all permits were acquired and <tt>false</tt>
   * if the waiting time elapsed before all permits were acquired.
   */
  bool tryAcquire(long timeout, TimeUnit unit, int permits = 1) {
    if (permits < 0)
      throw new IllegalArgumentException();
    return sync.tryAcquireSharedNanos(permits, toNanos(timeout,unit));
  }

  /**
   * Releases the given number of permits, returning them to the semaphore.
   *
   * <p>Releases the given number of permits, increasing the number of
   * available permits by that amount.  If any threads are blocking
   * trying to acquire permits, then the one that has been waiting the
   * longest is selected and given the permits that were just
   * released.  If the number of available permits satisfies that
   * thread's request then that thread is re-enabled for thread
   * scheduling purposes; otherwise the thread continues to wait. If
   * there are still permits available after the first thread's
   * request has been satisfied, then those permits are assigned to
   * the next waiting thread. If it is satisfied then it is re-enabled
   * for thread scheduling purposes. This continues until there are
   * insufficient permits to satisfy the next waiting thread, or there
   * are no more waiting threads.
   *
   * <p>There is no requirement that a thread that releases a permit
   * must have acquired that permit by calling acquire.  Correct usage
   * of a semaphore is established by programming convention in the
   * application.
   *
   * \param permits the number of permits to release
   */
  void release(int permits = 1) {
    if (permits < 0)
      throw new IllegalArgumentException();
    sync.releaseShared(permits);
  }

  /**
   * Returns the current number of permits available in this semaphore.
   * <p>This method is typically used for debugging and testing purposes.
   * \return the number of permits available in this semaphore.
   */
  int availablePermits() {
    return sync.getPermits();
  }

  /**
   * Acquire and return all permits that are immediately available.
   * \return the number of permits 
   */
  int drainPermits() {
    return sync.drainPermits();
  }

  /**
   * Shrinks the number of available permits by the indicated
   * reduction. This method can be useful in subclasses that use
   * semaphores to track resources that become unavailable. This
   * method differs from <tt>acquire</tt> in that it does not block
   * waiting for permits to become available.
   * \param reduction the number of permits to remove
   */
  protected void reducePermits(int reduction) {
    if (reduction < 0)
      throw new IllegalArgumentException();
    sync.reducePermits(reduction);
  }

  /**
   * Returns true if this semaphore has fairness set true.
   * \return true if this semaphore has fairness set true.
   */
  bool isFair() {
    return (cast(FairSync)sync) !is null;
  }

  /**
   * Queries whether any threads are waiting to acquire. Note that
   * because cancellations may occur at any time, a <tt>true</tt>
   * return does not guarantee that any other thread will ever
   * acquire.  This method is designed primarily for use in monitoring
   * of the system state.
   *
   * \return true if there may be other threads waiting to acquire
   * the lock.
   */
  final bool hasQueuedThreads() { 
    return sync.hasQueuedThreads();
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
   * Returns a string identifying this semaphore, as well as its state.
   * The state, in brackets, includes the String 
   * &quot;Permits =&quot; followed by the number of permits.
   * \return a string identifying this semaphore, as well as its
   * state
   */
  char[] toString() {
    char[16] buf;
    return super.toString() ~ "[Permits = " ~ 
      itoa(buf, sync.getPermits()) ~ "]";
  }

  unittest {
    Semaphore sem = new Semaphore(2);
    int done = 0;
    Thread[] t = new Thread[6];

    ThreadReturn f() {
      int n;
      Thread tt = Thread.getThis();
      for (n=0; n < t.length; n++) {
	if (tt is t[n])
	  break;
      }
      sleepNanos(toNanos(10,TimeUnit.MilliSeconds));
      version (LocksVerboseUnittest)
	printf(" thread %d started\n",n);
      sem.acquire();
      sleepNanos(toNanos(10,TimeUnit.MilliSeconds));
      version (LocksVerboseUnittest) {
	printf(" thread %d aquired\n",n);
	printf(" thread %d terminating\n",n);
      }
      return 0;
    }

    ThreadReturn f2() {
      int n;
      Thread tt = Thread.getThis();
      for (n=0; n < t.length; n++) {
	if (tt is t[n])
	  break;
      }
      version (LocksVerboseUnittest)
	printf(" thread %d releasing\n",n);
      sleepNanos(toNanos(10,TimeUnit.MilliSeconds));
      sem.release();
      version (LocksVerboseUnittest)
	printf(" thread %d terminating\n",n);
      sleepNanos(toNanos(10,TimeUnit.MilliSeconds));
      return 0;
    }
    int n;
    for (n=0; n<t.length/2; n++) {
      t[n] = new Thread(&f);
    }
    for (; n<t.length; n++) {
      t[n] = new Thread(&f2);
    }
    version (LocksVerboseUnittest)
      printf("starting locks.semaphore unittest\n");
    for (n=0; n<t.length/2; n++) {
      t[n].start();
    }
    Thread.yield();
    for (; n<t.length; n++) {
      t[n].start();
      Thread.yield();
    }

    foreach(int n, Thread thread; t)
      {
	version (LocksVerboseUnittest)
	  printf(" waiting on %d\n", n);
        version (Ares)
                 thread.join();
              else
                 thread.wait();
      }

    version (LocksVerboseUnittest)
      printf("finished locks.semaphore unittest\n");
    delete sem;
    t[] = null;
  }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
