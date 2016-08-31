/** \file Lock.d
 * \brief <tt>Lock</tt> implementations provide more extensive locking
 * operations than can be obtained using <tt>synchronized</tt> methods
 * and statements.  They allow more flexible structuring, may have
 * quite different properties, and may support multiple associated
 * Condition objects.
 *
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Ported to D by Ben Hinkle.
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.0 - ScopedLock suggested by Sean Kelly
 */

module mango.locks.Lock;

import mango.locks.Condition;
import mango.locks.TimeUnit;

/** \class Lock
 * \brief <tt>Lock</tt> implementations provide more extensive locking
 * operations than can be obtained using <tt>synchronized</tt> methods
 * and statements.  They allow more flexible structuring, may have
 * quite different properties, and may support multiple associated
 * Condition objects.
 *
 * <p>A lock is a tool for controlling access to a shared resource by
 * multiple threads. Commonly, a lock provides exclusive access to a
 * shared resource: only one thread at a time can acquire the lock and
 * all access to the shared resource requires that the lock be
 * acquired first. However, some locks may allow concurrent access to
 * a shared resource, such as the read lock of a ReadWriteLock.
 *
 * <p>The use of <tt>synchronized</tt> methods or statements provides 
 * access to the implicit monitor lock associated with every object, but
 * forces all lock acquisition and release to occur in a block-structured way:
 * when multiple locks are acquired they must be released in the opposite
 * order, and all locks must be released in the same lexical scope in which
 * they were acquired.
 *
 * <p>While the scoping mechanism for <tt>synchronized</tt> methods
 * and statements makes it much easier to program with monitor locks,
 * and helps avoid many common programming errors involving locks,
 * there are occasions where you need to work with locks in a more
 * flexible way. For example, some algorithms for traversing
 * concurrently accessed data structures require the use of
 * &quot;hand-over-hand&quot; or &quot;chain locking&quot;: you
 * acquire the lock of node A, then node B, then release A and acquire
 * C, then release B and acquire D and so on.  Implementations of the
 * <tt>Lock</tt> interface enable the use of such techniques by
 * allowing a lock to be acquired and released in different scopes,
 * and allowing multiple locks to be acquired and released in any
 * order.
 *
 * <p>With this increased flexibility comes additional
 * responsibility. The absence of block-structured locking removes the
 * automatic release of locks that occurs with <tt>synchronized</tt>
 * methods and statements. In most cases, the following idiom
 * should be used:
 * \code
 *     Lock l = ...; 
 *     l.lock();
 *     try {
 *         // access the resource protected by this lock
 *     } finally {
 *         l.unlock();
 *     }
 * \endcode
 * 
 * A ScopedLock can be used to simplify the above to
 * \code
 *     Lock l = ...; 
 *     auto ScopedLock sl = new ScopedLock(l);
 *     // access the resource protected by this lock
 *     // the lock will be release at the end of the block
 * \endcode
 *
 * When locking and unlocking occur in different scopes, care must be
 * taken to ensure that all code that is executed while the lock is
 * held is protected by try-finally or try-catch to ensure that the
 * lock is released when necessary.
 *
 * <p><tt>Lock</tt> implementations provide additional functionality
 * over the use of <tt>synchronized</tt> methods and statements by
 * providing a non-blocking attempt to acquire a lock using tryLock(), 
 * and an attempt to acquire
 * the lock that can timeout tryLock(long, TimeUnit).
 *
 * <p>A <tt>Lock</tt> class can also provide behavior and semantics
 * that is quite different from that of the implicit monitor lock,
 * such as guaranteed ordering, non-reentrant usage, or deadlock
 * detection. If an implementation provides such specialized semantics
 * then the implementation must document those semantics.
 *
 * <p>Note that <tt>Lock</tt> instances are just normal objects and can 
 * themselves be used as the target in a <tt>synchronized</tt> statement.
 * Acquiring the
 * monitor lock of a <tt>Lock</tt> instance has no specified relationship
 * with invoking any of the lock methods of that instance. 
 * It is recommended that to avoid confusion you never use <tt>Lock</tt>
 * instances in this way, except within their own implementation.
 *
 * \see ReentrantLock
 * \see Condition
 * \see ReadWriteLock
 */
interface Lock {

  /**
   * Acquires the lock.
   * <p>If the lock is not available then
   * the current thread becomes disabled for thread scheduling
   * purposes and lies dormant until the lock has been acquired.
   */
  void lock();

  /**
   * Acquires the lock only if it is free at the time of invocation.
   * <p>Acquires the lock if it is available and returns immediately
   * with the value <tt>true</tt>.
   * If the lock is not available then this method will return 
   * immediately with the value <tt>false</tt>.
   * <p>A typical usage idiom for this method would be:
   * \code
   *      Lock lock = ...;
   *      if (lock.tryLock()) {
   *          try {
   *              // manipulate protected state
   *          } finally {
   *              lock.unlock();
   *          }
   *      } else {
   *          // perform alternative actions
   *      }
   * \endcode
   * This usage ensures that the lock is unlocked if it was acquired, and
   * doesn't try to unlock if the lock was not acquired.
   *
   * \return <tt>true</tt> if the lock was acquired and <tt>false</tt>
   * otherwise.
   **/
  bool tryLock();

  /**
   * Acquires the lock if it is free within the given waiting time.
   *
   * <p>If the lock is available this method returns immediately
   * with the value <tt>true</tt>.
   * If the lock is not available then
   * the current thread becomes disabled for thread scheduling 
   * purposes and lies dormant until one of three things happens:
   * <ul>
   * <li>The lock is acquired by the current thread; or
   * <li>The specified waiting time elapses
   * </ul>
   * <p>If the lock is acquired then the value <tt>true</tt> is returned.
   * <p>If the specified waiting time elapses then the value <tt>false</tt>
   * is returned.
   * If the time is 
   * less than or equal to zero, the method will not wait at all.
   *
   * \param time the maximum time to wait for the lock
   * \param unit the time unit of the <tt>time</tt> argument.
   * \return <tt>true</tt> if the lock was acquired and <tt>false</tt>
   * if the waiting time elapsed before the lock was acquired.
   */
  bool tryLock(long time, TimeUnit unit);

  /**
   * Releases the lock.
   **/
  void unlock();

  /**
   * Returns a new Condition instance that is bound to this 
   * <tt>Lock</tt> instance.
   * <p>Before waiting on the condition the lock must be held by the 
   * current thread. 
   * A call to Condition.wait() will atomically release the lock 
   * before waiting and re-acquire the lock before the wait returns.
   * 
   * \return A new Condition instance for this <tt>Lock</tt> 
   * instance.
   */
  Condition newCondition();
}

/** \class ScopedLock
 *
 * A wrapper around a lock which acquires the lock during construction
 * and guarantees the lock is released at the end of the current
 * scope. Use a ScopedLock when you need the Lock equivalent of
 * synchronized statements. For example
 *
 * \code 
 * void example(Lock lock) {
 *   auto ScopedLock slock = new ScopedLock(lock); // acquires lock 
 *   // the lock will be released at function exit 
 * } 
 * \endcode
 */
scope final class ScopedLock {
  this(Lock lock) { this.lock = lock; lock.lock(); }
  ~this() {lock.unlock();}
  private Lock lock;
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
