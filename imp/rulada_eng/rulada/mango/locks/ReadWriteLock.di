/** \file ReadWriteLock.d
 * \brief A <tt>ReadWriteLock</tt> maintains a pair of associated
 * locks, one for read-only operations and one for writing.  The read
 * lock may be held simultaneously by multiple reader threads, so long
 * as there are no writers.  The write lock is exclusive.
 *
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Ported to D by Ben Hinkle.
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.01
 */

module mango.locks.ReadWriteLock;

import mango.locks.Lock;
import mango.locks.Condition;

/** \class ReadWriteLock
 * \brief A <tt>ReadWriteLock</tt> maintains a pair of associated
 * locks, one for read-only operations and one for writing.  The read
 * lock may be held simultaneously by multiple reader threads, so long
 * as there are no writers.  The write lock is exclusive.
 * 
 * <p>A read-write lock allows for a greater level of concurrency in
 * accessing shared data, than that permitted by a mutual exclusion
 * lock.  It exploits the fact that while only a single thread at a
 * time (a <em>writer</em> thread) can modify the shared data, in many
 * cases any number of threads can concurrently read the data (hence
 * <em>reader</em> threads).  In theory, the increase in concurrency
 * permitted by the use of a read-write lock will lead to performance
 * improvements over the use of a mutual exclusion lock. In practice
 * this increase in concurrency will only be fully realized on a
 * multi-processor, and then only if the access patterns for the
 * shared data are suitable.
 *
 * <p>Whether or not a read-write lock will improve performance over the use
 * of a mutual exclusion lock depends on the frequency that the data is
 * read compared to being modified, the duration of the read and write 
 * operations, and the contention for the data - that is, the number of
 * threads that will try to read or write the data at the same time.
 * For example, a collection that is initially populated with data and
 * thereafter infrequently modified, while being frequently searched
 * (such as a directory of some kind) is an ideal candidate for the use of
 * a read-write lock. However, if updates become frequent then the data
 * spends most of its time being exclusively locked and there is little, if any
 * increase in concurrency. Further, if the read operations are too short
 * the overhead of the read-write lock implementation (which is inherently
 * more complex than a mutual exclusion lock) can dominate the execution
 * cost, particularly as many read-write lock implementations still serialize
 * all threads through a small section of code. Ultimately, only profiling
 * and measurement will establish whether the use of a read-write lock is
 * suitable for your application.
 *
 * @see ReentrantReadWriteLock
 * @see Lock
 * @see ReentrantLock
 */
interface ReadWriteLock {
    /**
     * Returns the lock used for reading.
     *
     * \return the lock used for reading.
     */
    Lock readLock();

    /**
     * Returns the lock used for writing.
     *
     * \return the lock used for writing.
     */
    Lock writeLock();
}

private {
  import std.thread;

  import mango.sys.Atomic;

  import mango.locks.Utils;
  import mango.locks.LockImpl;
  import mango.locks.TimeUnit;
  import mango.locks.Exceptions;
}

/** \class ReentrantReadWriteLock
 * \brief An implementation of ReadWriteLock supporting similar
 * semantics to ReentrantLock.
 *
 * <p>This class has the following properties:
 *
 * <ul>
 * <li><b>Acquisition order</b>
 *
 * <p> This class does not impose a reader or writer preference
 * ordering for lock access.  However, it does support an optional
 * <em>fairness</em> policy.  When constructed as fair, threads
 * contend for entry using an approximately arrival-order policy. When
 * the write lock is released either the longest-waiting single writer
 * will be assigned the write lock, or if there is a reader waiting
 * longer than any writer, the set of readers will be assigned the
 * read lock.  When constructed as non-fair, the order of entry to the
 * lock need not be in arrival order.  In either case, if readers are
 * active and a writer enters the lock then no subsequent readers will
 * be granted the read lock until after that writer has acquired and
 * released the write lock.
 * 
 * <li><b>Reentrancy</b>
 * <p>This lock allows both readers and writers to reacquire read or
 * write locks in the style of a ReentrantLock. Readers are not
 * allowed until all write locks held by the writing thread have been
 * released.  
 * <p>Additionally, a writer can acquire the read lock - but not vice-versa.
 * Among other applications, reentrancy can be useful when
 * write locks are held during calls or callbacks to methods that
 * perform reads under read locks. 
 * If a reader tries to acquire the write lock it will never succeed.
 * 
 * <li><b>Lock downgrading</b>
 * <p>Reentrancy also allows downgrading from the write lock to a read lock,
 * by acquiring the write lock, then the read lock and then releasing the
 * write lock. However, upgrading from a read lock to the write lock, is
 * <b>not</b> possible.
 *
 * <li><b>Condition support</b>
 * <p>The write lock provides a Condition implementation that behaves
 * in the same way, with respect to the write lock, as the Condition
 * implementation provided by ReentrantLock.newCondition does for
 * ReentrantLock.  This Condition can, of course, only be used with
 * the write lock.
 *
 * <p>The read lock does not support a Condition and
 * <tt>readLock().newCondition()</tt> throws
 * <tt>UnsupportedOperationException</tt>.
 *
 * <li><b>Instrumentation</b>
 * <P> This class supports methods to determine whether locks
 * are held or contended. These methods are designed for monitoring
 * system state, not for synchronization control.
 * </ul>
 *
 * <p><b>Sample usages</b>. Here is a code sketch showing how to exploit
 * reentrancy to perform lock downgrading after updating a cache (exception
 * handling is elided for simplicity):
 * \code
 * class CachedData {
 *   Object data;
 *   bool cacheValid;
 *   ReentrantReadWriteLock rwl;
 *   this() { 
 *     rwl = new ReentrantReadWriteLock(); 
 *   }
 *   void processCachedData() {
 *     rwl.readLock().lock();
 *     if (!cacheValid) {
 *        // upgrade lock manually
 *        rwl.readLock().unlock();   // must unlock first to obtain writelock
 *        rwl.writeLock().lock();
 *        if (!cacheValid) { // recheck
 *          data = ...
 *          cacheValid = true;
 *        }
 *        // downgrade lock
 *        rwl.readLock().lock();  // reacquire read without giving up write lock
 *        rwl.writeLock().unlock(); // unlock write, still hold read
 *     }
 *
 *     use(data);
 *     rwl.readLock().unlock();
 *   }
 * }
 * \endcode
 *
 * ReentrantReadWriteLocks can be used to improve concurrency in some
 * uses of some kinds of collections. This is typically worthwhile
 * only when the collections are expected to be large, accessed by
 * more reader threads than writer threads, and entail operations with
 * overhead that outweighs synchronization overhead.
 *
 * <h3>Implementation Notes</h3>
 *
 * <p>A reentrant write lock intrinsically defines an owner and can
 * only be released by the thread that acquired it.  In contrast, in
 * this implementation, the read lock has no concept of ownership, and
 * there is no requirement that the thread releasing a read lock is
 * the same as the one that acquired it.  However, this property is
 * not guaranteed to hold in future implementations of this class.
 *
 * <p> This lock supports a maximum of 65536 recursive write locks
 * and 65536 read locks. Attempts to exceed these limits result in
 * Error throws from locking methods.
 */
class ReentrantReadWriteLock : ReadWriteLock {
  /* Inner class providing readlock */
  private final ReentrantReadWriteLock.ReadLock readerLock;
  /* Inner class providing writelock */
  private final ReentrantReadWriteLock.WriteLock writerLock;
  /* Performs all synchronization mechanics */
  private final Sync sync;

  /**
   * Creates a new <tt>ReentrantReadWriteLock</tt> with
   * the given fairness policy.
   *
   * \param fair true if this lock should use a fair ordering policy
   */
  this(bool fair = false) {
    if (fair)
      sync = new FairSync();
    else
      sync = new NonfairSync();
    readerLock = new ReadLock(this);
    writerLock = new WriteLock(this);
  }

  Lock writeLock() { return writerLock; }
  Lock  readLock()  { return readerLock; }

  /* 
   * Read vs write count extraction constants and functions.
   * Lock state is logically divided into two shorts: The lower
   * one representing the exclusive (writer) lock hold count,
   * and the upper the shared (reader) hold count.
   */
    
  const int SHARED_SHIFT   = 16;
  const int SHARED_UNIT    = (1 << SHARED_SHIFT);
  const int EXCLUSIVE_MASK = (1 << SHARED_SHIFT) - 1;
    
  /** Returns the number of shared holds represented in count  */
  static int sharedCount(int c)    { return c >>> SHARED_SHIFT; }
  /** Returns the number of exclusive holds represented in count  */
  static int exclusiveCount(int c) { return c & EXCLUSIVE_MASK; }

  /*
   * Synchronization implementation for ReentrantReadWriteLock.
   * Subclassed into fair and nonfair versions.
   */
  abstract static class Sync : AbstractLock {
    /* Current (exclusive) owner thread */
    Thread owner;

    /*
     * Perform write lock. Allows fast path in non-fair version.
     */
    abstract void wlock();

    /*
     * Perform non-fair tryLock for write.  tryAcquire is
     * implemented in subclasses, but both versions need nonfair
     * try for trylock method
     */
    final bool nonfairTryAcquire(int acquires) {
      // mask out readlocks if called from condition methods
      acquires = exclusiveCount(acquires);
      Thread current = Thread.getThis();
      int c = state;
      int w = exclusiveCount(c);
      if (w + acquires >= SHARED_UNIT)
	throw new Exception("Maximum lock count exceeded");
      if (c != 0 && (w == 0 || current !is owner))
	return false;
      if (!Atomic.compareAndSet32(&state_, c, c+acquires))
	return false;
      owner = current;
      return true;
    }

    /*
     * Perform nonfair tryLock for read. 
     */
    final int nonfairTryAcquireShared(int acquires) {
      for (;;) {
	int c = state;
	int nextc = c + (acquires << SHARED_SHIFT);
	if (nextc < c)
	  throw new Exception("Maximum lock count exceeded");
	if (exclusiveCount(c) != 0 && 
	    owner !is Thread.getThis())
	  return -1;
	if (Atomic.compareAndSet32(&state_, c, nextc)) 
	  return 1;
	// Recheck count if lost CAS
      }
    }

    protected final bool tryRelease(int releases) {
      Thread current = Thread.getThis();
      int c = state;
      if (owner !is current)
	throw new Exception("Illegal monitor state");
      int nextc = c - releases;
      bool free = false;
      if (exclusiveCount(c) == releases) {
	free = true;
	owner = null;
      }
      state = nextc;
      return free;
    }

    protected final bool tryReleaseShared(int releases) {
      for (;;) {
	int c = state;
	int nextc = c - (releases << SHARED_SHIFT);
	if (nextc < 0)
	  throw new Exception("Illegal monitor state");
	if (Atomic.compareAndSet32(&state_, c, nextc)) 
	  return nextc == 0;
      }
    }
    
    final bool isHeldExclusively() {
      return exclusiveCount(state) != 0 && 
	owner is Thread.getThis();
    }

    // Methods relayed to outer class
        
    final ConditionObject newCondition() { 
      return new ConditionObject(this); 
    }

    final Thread getOwner() {
      int c = exclusiveCount(state);
      Thread o = owner;
      return (c == 0)? null : o;
    }
        
    final int getReadLockCount() {
      return sharedCount(state);
    }
        
    final bool isWriteLocked() {
      return exclusiveCount(state) != 0;
    }

    final int getWriteHoldCount() {
      int c = exclusiveCount(state);
      Thread o = owner;
      return (o is Thread.getThis())? c : 0;
    }

    final int getCount() { return state; }
  }

  /* 
   * Nonfair version of Sync
   */
  final static class NonfairSync : Sync {
    protected final bool tryAcquire(int acquires) { 
      return nonfairTryAcquire(acquires);
    }

    protected final int tryAcquireShared(int acquires) {
      return nonfairTryAcquireShared(acquires);
    }

    // Use fastpath for main write lock method
    final void wlock() {
      if (Atomic.compareAndSet32(&state_, 0, 1))
	owner = Thread.getThis();
      else
	acquire(1);
    }
  }

  /*
   * Fair version of Sync
   */
  final static class FairSync : Sync {
    protected final bool tryAcquire(int acquires) { 
      // mask out readlocks if called from condition methods
      acquires = exclusiveCount(acquires);
      Thread current = Thread.getThis();
      Thread first;
      int c = state;
      int w = exclusiveCount(c);
      if (w + acquires >= SHARED_UNIT)
	throw new Exception("Maximum lock count exceeded");
      if ((w == 0 || current !is owner) &&
	  (c != 0 || 
	   ((first = getFirstQueuedThread()) !is null && 
	    first !is current)))
	return false;
      if (!Atomic.compareAndSet32(&state_, c, c + acquires))
	return false;
      owner = current;
      return true;
    }

    protected final int tryAcquireShared(int acquires) {
      Thread current = Thread.getThis();
      for (;;) {
	Thread first = getFirstQueuedThread();
	if (first !is null && first !is current)
	  return -1;
	int c = state;
	int nextc = c + (acquires << SHARED_SHIFT);
	if (nextc < c)
	  throw new Exception("Maximum lock count exceeded");
	if (exclusiveCount(c) != 0 && 
	    owner !is Thread.getThis())
	  return -1;
	if (Atomic.compareAndSet32(&state_, c, nextc)) 
	  return 1;
	// Recheck count if lost CAS
      }
    }

    final void wlock() { // no fast path
      acquire(1);
    }
  }

  /**
   * The lock returned by method ReentrantReadWriteLock.readLock.
   */
  static class ReadLock : Lock {
    private Sync sync;
        
    /** 
     * Constructor for use by subclasses 
     * \param lock the outer lock object
     */
    this(ReentrantReadWriteLock lock) {
      sync = lock.sync;
    }

    /**
     * Acquires the shared lock. 
     *
     * <p>Acquires the lock if it is not held exclusively by
     * another thread and returns immediately.
     *
     * <p>If the lock is held exclusively by another thread then
     * the current thread becomes disabled for thread scheduling
     * purposes and lies dormant until the lock has been acquired.
     */
    void lock() { 
      sync.acquireShared(1);
    }

    /**
     * Acquires the shared lock only if it is not held exclusively by
     * another thread at the time of invocation.
     *
     * <p>Acquires the lock if it is not held exclusively by another
     * thread and returns immediately with the value
     * <tt>true</tt>. Even when this lock has been set to use a fair
     * ordering policy, a call to <tt>tryLock()</tt> <em>will</em>
     * immediately acquire the lock if it is available, whether or not
     * other threads are currently waiting for the lock.  This
     * &quot;barging&quot; behavior can be useful in certain
     * circumstances, even though it breaks fairness. If you want to
     * honor the fairness setting for this lock, then use tryLock(0,
     * TimeUnit.SECONDS) which is almost equivalent (it also detects
     * interruption).
     *
     * <p>If the lock is held exclusively by another thread then
     * this method will return immediately with the value
     * <tt>false</tt>.
     *
     * 'return <tt>true</tt> if the lock was acquired.
     */
    bool tryLock() {
      return sync.nonfairTryAcquireShared(1) >= 0;
    }

    /**
     * Acquires the shared lock if it is not held exclusively by
     * another thread within the given waiting time.
     *
     * <p>Acquires the lock if it is not held exclusively by
     * another thread and returns immediately with the value
     * <tt>true</tt>. If this lock has been set to use a fair
     * ordering policy then an available lock <em>will not</em> be
     * acquired if any other threads are waiting for the
     * lock. This is in contrast to the tryLock()
     * method. If you want a timed <tt>tryLock</tt> that does
     * permit barging on a fair lock then combine the timed and
     * un-timed forms together:
     *
     * <pre>if (lock.tryLock() || lock.tryLock(timeout, unit) ) { ... }
     * </pre>
     *
     * <p>If the lock is held exclusively by another thread then the
     * current thread becomes disabled for thread scheduling 
     * purposes and lies dormant until one of three things happens:
     *
     * <ul>
     * <li>The lock is acquired by the current thread; or
     * <li>The specified waiting time elapses
     * </ul>
     *
     * <p>If the lock is acquired then the value <tt>true</tt> is
     * returned.
     *
     * <p>If the specified waiting time elapses then the value
     * <tt>false</tt> is returned.  If the time is less than or
     * equal to zero, the method will not wait at all.
     *
     * \param timeout the time to wait for the lock
     * \@param unit the time unit of the timeout argument
     *
     * \return <tt>true</tt> if the lock was acquired.
     *
     */
    bool tryLock(long timeout, TimeUnit unit) {
      return sync.tryAcquireSharedNanos(1, toNanos(timeout,unit));
    }

    /**
     * Attempts to release this lock.  
     *
     * <p> If the number of readers is now zero then the lock
     * is made available for other lock attempts.
     */
    void unlock() {
      sync.releaseShared(1);
    }

    /**
     * Throws UnsupportedOperationException because ReadLocks
     * do not support conditions.
     * \throws UnsupportedOperationException always
     */
    Condition newCondition() {
      throw new UnsupportedOperationException();
      return null;
    }

    /**
     * Returns a string identifying this lock, as well as its lock state.
     * The state, in brackets, includes the String 
     * &quot;Read locks =&quot; followed by the number of held
     * read locks.
     * \return a string identifying this lock, as well as its lock state.
     */
    char[] toString() {
      char[16] buf;

      int r = sync.getReadLockCount();
      return super.toString() ~ 
	"[Read locks = " ~ itoa(buf, r) ~ "]";
    }

  }

  /**
   * The lock returned by method ReentrantReadWriteLock.writeLock
   */
  static class WriteLock : Lock {
    private final Sync sync;
        
    /** 
     * Constructor for use by subclasses 
     * \param lock the outer lock object
     */
    this(ReentrantReadWriteLock lock) {
      sync = lock.sync;
    }

    /**
     * Acquire the lock. 
     *
     * <p>Acquires the lock if it is not held by another thread
     * and returns immediately, setting the lock hold count to
     * one.
     *
     * <p>If the current thread already holds the lock then the
     * hold count is incremented by one and the method returns
     * immediately.
     *
     * <p>If the lock is held by another thread then the current
     * thread becomes disabled for thread scheduling purposes and
     * lies dormant until the lock has been acquired, at which
     * time the lock hold count is set to one.
     */
    void lock() {
      sync.wlock();
    }

    /**
     * Acquires the lock only if it is not held by another thread
     * at the time of invocation.
     *
     * <p>Acquires the lock if it is not held by another thread and
     * returns immediately with the value <tt>true</tt>, setting the
     * lock hold count to one. Even when this lock has been set to use
     * a fair ordering policy, a call to <tt>tryLock()</tt>
     * <em>will</em> immediately acquire the lock if it is available,
     * whether or not other threads are currently waiting for the
     * lock.  This &quot;barging&quot; behavior can be useful in
     * certain circumstances, even though it breaks fairness. If you
     * want to honor the fairness setting for this lock, then use
     * .tryLock(0, TimeUnit.SECONDS) which is almost equivalent (it
     * also detects interruption).
     *
     * <p> If the current thread already holds this lock then the
     * hold count is incremented by one and the method returns
     * <tt>true</tt>.
     *
     * <p>If the lock is held by another thread then this method
     * will return immediately with the value <tt>false</tt>.
     *
     * \return <tt>true</tt> if the lock was free and was acquired by the
     * current thread, or the lock was already held by the current thread; and
     * <tt>false</tt> otherwise.
     */
    bool tryLock( ) {
      return sync.nonfairTryAcquire(1);
    }

    /**
     * Acquires the lock if it is not held by another thread
     * within the given waiting time.
     *
     * <p>Acquires the lock if it is not held by another thread
     * and returns immediately with the value <tt>true</tt>,
     * setting the lock hold count to one. If this lock has been
     * set to use a fair ordering policy then an available lock
     * <em>will not</em> be acquired if any other threads are
     * waiting for the lock. This is in contrast to the
     * tryLock() method. If you want a timed <tt>tryLock</tt>
     * that does permit barging on a fair lock then combine the
     * timed and un-timed forms together:
     *
     * <pre>if (lock.tryLock() || lock.tryLock(timeout, unit) ) { ... }
     * </pre>
     *
     * <p>If the current thread already holds this lock then the
     * hold count is incremented by one and the method returns
     * <tt>true</tt>.
     *
     * <p>If the lock is held by another thread then the current
     * thread becomes disabled for thread scheduling purposes and
     * lies dormant until one of three things happens:
     *
     * <ul>
     * <li>The lock is acquired by the current thread; or
     * <li>The specified waiting time elapses
     * </ul>
     *
     * <p>If the lock is acquired then the value <tt>true</tt> is
     * returned and the lock hold count is set to one.
     *
     * <p>If the specified waiting time elapses then the value
     * <tt>false</tt> is returned.  If the time is less than or
     * equal to zero, the method will not wait at all.
     *
     * \param timeout the time to wait for the lock
     * \param unit the time unit of the timeout argument
     *
     * \return <tt>true</tt> if the lock was free and was acquired
     * by the current thread, or the lock was already held by the
     * current thread; and <tt>false</tt> if the waiting time
     * elapsed before the lock could be acquired.
     */
    bool tryLock(long timeout, TimeUnit unit) {
      return sync.tryAcquireNanos(1, toNanos(timeout,unit));
    }

    /**
     * Attempts to release this lock.  
     *
     * <p>If the current thread is the holder of this lock then
     * the hold count is decremented. If the hold count is now
     * zero then the lock is released.
     */
    void unlock() {
      sync.release(1);
    }

    /**
     * Returns a Condition instance for use with this Lock
     * instance. The semantics are like the semantics of the Condition
     * for a ReentrantLock.
     * \return the Condition object
     */
    Condition newCondition() { 
      return sync.newCondition();
    }

    /**
     * Returns a string identifying this lock, as well as its lock
     * state.  The state, in brackets includes either the String
     * &quot;Unlocked&quot; or the String &quot;Locked by&quot;
     * followed by the  Thread.toString of the owning thread.
     * \return a string identifying this lock, as well as its lock state.
     */
    char[] toString() {
      Thread owner = sync.getOwner();
      return super.toString() ~ ((owner is null) ?
				 "[Unlocked]" :
				 ("[Locked by thread" ~ owner.toString() ~ "]"));
    }

  }


  // Instrumentation and status

  /**
   * Returns true if this lock has fairness set true.
   * @return true if this lock has fairness set true.
   */
  final bool isFair() {
    return (cast(FairSync)sync) !is null;
  }

  /**
   * Returns the thread that currently owns the exclusive lock, or
   * <tt>null</tt> if not owned. Note that the owner may be
   * momentarily <tt>null</tt> even if there are threads trying to
   * acquire the lock but have not yet done so.  This method is
   * designed to facilitate construction of subclasses that provide
   * more extensive lock monitoring facilities.
   * @return the owner, or <tt>null</tt> if not owned.
   */
  protected Thread getOwner() {
    return sync.getOwner();
  }
    
  /**
   * Queries the number of read locks held for this lock. This
   * method is designed for use in monitoring system state, not for
   * synchronization control.
   * @return the number of read locks held.
   */
  int getReadLockCount() {
    return sync.getReadLockCount();
  }

  /**
   * Queries if the write lock is held by any thread. This method is
   * designed for use in monitoring system state, not for
   * synchronization control.
   * @return <tt>true</tt> if any thread holds write lock and 
   * <tt>false</tt> otherwise.
   */
  bool isWriteLocked() {
    return sync.isWriteLocked();
  }

  /**
   * Queries if the write lock is held by the current thread. 
   * @return <tt>true</tt> if current thread holds this lock and 
   * <tt>false</tt> otherwise.
   */
  bool isWriteLockedByCurrentThread() {
    return sync.isHeldExclusively();
  }

  /**
   * Queries the number of reentrant write holds on this lock by the
   * current thread.  A writer thread has a hold on a lock for
   * each lock action that is not matched by an unlock action.
   *
   * @return the number of holds on this lock by the current thread,
   * or zero if this lock is not held by the current thread.
   */
  int getWriteHoldCount() {
    return sync.getWriteHoldCount();
  }

  /**
   * Returns a collection containing threads that may be waiting to
   * acquire the write lock.  Because the actual set of threads may
   * change dynamically while constructing this result, the returned
   * collection is only a best-effort estimate.  The elements of the
   * returned collection are in no particular order.  This method is
   * designed to facilitate construction of subclasses that provide
   * more extensive lock monitoring facilities.
   * @return the collection of threads
   */
  protected Thread[] getQueuedWriterThreads() {
    return sync.getExclusiveQueuedThreads();
  }

  /**
   * Returns a collection containing threads that may be waiting to
   * acquire the read lock.  Because the actual set of threads may
   * change dynamically while constructing this result, the returned
   * collection is only a best-effort estimate.  The elements of the
   * returned collection are in no particular order.  This method is
   * designed to facilitate construction of subclasses that provide
   * more extensive lock monitoring facilities.
   * @return the collection of threads
   */
  protected Thread[] getQueuedReaderThreads() {
    return sync.getSharedQueuedThreads();
  }

  /**
   * Queries whether any threads are waiting to acquire. Note that
   * because cancellations may occur at any time, a <tt>true</tt>
   * return does not guarantee that any other thread will ever
   * acquire.  This method is designed primarily for use in
   * monitoring of the system state.
   *
   * @return true if there may be other threads waiting to acquire
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
   * @param thread the thread
   * @return true if the given thread is queued waiting for this lock.
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
   * @return the estimated number of threads waiting for this lock
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
   * @return the collection of threads
   */
  protected Thread[] getQueuedThreads() {
    return sync.getQueuedThreads();
  }

  /**
   * Queries whether any threads are waiting on the given condition
   * associated with the write lock. Note that because timeouts and
   * interrupts may occur at any time, a <tt>true</tt> return does
   * not guarantee that a future <tt>signal</tt> will awaken any
   * threads.  This method is designed primarily for use in
   * monitoring of the system state.
   * @param condition the condition
   * @return <tt>true</tt> if there are any waiting threads.
   */ 
  bool hasWaiters(Condition condition) {
    if ((condition is null) || 
	(cast(AbstractLock.ConditionObject)condition is null))
      throw new IllegalArgumentException();
    return sync.hasWaiters(cast(AbstractLock.ConditionObject)condition);
  }

  /**
   * Returns an estimate of the number of threads waiting on the
   * given condition associated with the write lock. Note that because
   * timeouts and interrupts may occur at any time, the estimate
   * serves only as an upper bound on the actual number of waiters.
   * This method is designed for use in monitoring of the system
   * state, not for synchronization control.
   * @param condition the condition
   * @return the estimated number of waiting threads.
   */ 
  int getWaitQueueLength(Condition condition) {
    if ((condition is null) || 
	(cast(AbstractLock.ConditionObject)condition is null))
      throw new IllegalArgumentException();
    return sync.getWaitQueueLength(cast(AbstractLock.ConditionObject)condition);
  }

  /**
   * Returns a collection containing those threads that may be
   * waiting on the given condition associated with the write lock.
   * Because the actual set of threads may change dynamically while
   * constructing this result, the returned collection is only a
   * best-effort estimate. The elements of the returned collection
   * are in no particular order.  This method is designed to
   * facilitate construction of subclasses that provide more
   * extensive condition monitoring facilities.
   * @param condition the condition
   * @return the collection of threads
   */
  protected Thread[] getWaitingThreads(Condition condition) {
    if ((condition is null) || 
	(cast(AbstractLock.ConditionObject)condition is null))
      throw new IllegalArgumentException();
    return sync.getWaitingThreads(cast(AbstractLock.ConditionObject)condition);
  }

  /**
   * Returns a string identifying this lock, as well as its lock state.
   * The state, in brackets, includes the String &quot;Write locks =&quot;
   * follwed by the number of reentrantly held write locks, and the
   * String &quot;Read locks =&quot; followed by the number of held
   * read locks.
   * @return a string identifying this lock, as well as its lock state.
   */
  char[] toString() {
    char[16] buf1;
    char[16] buf2;
    int c = sync.getCount();
    int w = exclusiveCount(c);
    int r = sharedCount(c);
        
    return super.toString() ~ 
      "[Write locks = " ~ itoa(buf1, w) ~ ", Read locks = " 
      ~ itoa(buf2, r) ~ "]";
  }

}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
