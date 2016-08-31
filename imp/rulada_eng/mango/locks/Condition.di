/** \file Condition.d
 * \brief <tt>Condition</tt> implements a condition variable for
 * a lock.
 *
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Ported to D by Ben Hinkle.
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.0
 */

module mango.locks.Condition;

private import mango.locks.TimeUnit;

/** \class Condition
 * \brief Conditions (also known as <em>condition queues</em> or
 * <em>condition variables</em>) provide a means for one thread to
 * suspend execution (to &quot;wait&quot;) until notified by another
 * thread that some state condition may now be true.  
 *
 * Because access to this shared state information occurs in different
 * threads, it must be protected, so a lock of some form is associated
 * with the condition. The key property that waiting for a condition
 * provides is that it <em>atomically</em> releases the associated
 * lock and suspends the current thread.
 *
 * <p>A <tt>Condition</tt> instance is intrinsically bound to a lock.
 * To obtain a <tt>Condition</tt> instance for a particular Lock 
 * instance use its newCondition() method.
 *
 * <p>A <tt>Condition</tt> implementation can provide customized
 * behavior and semantics such as guaranteed ordering for
 * notifications, or not requiring a lock to be held when performing
 * notifications.  If an implementation provides such specialized
 * semantics then the implementation must document those semantics.
 *
 * <p>Note that <tt>Condition</tt> instances are just normal objects
 * and can themselves be used as the target in a <tt>synchronized</tt>
 * statement.  Acquiring the monitor lock of a <tt>Condition</tt>
 * instance has no specified relationship with acquiring the Lock
 * associated with that <tt>Condition</tt>.  It is recommended that to
 * avoid confusion you never use <tt>Condition</tt> instances in this
 * way, except perhaps within their own implementation.
 *
 * <h3>Implementation Considerations</h3>
 *
 * <p>When waiting upon a <tt>Condition</tt>, a &quot;<em>spurious
 * wakeup</em>&quot; is permitted to occur, in general, as a
 * concession to the underlying platform semantics.  This has little
 * practical impact on most application programs as a
 * <tt>Condition</tt> should always be waited upon in a loop, testing
 * the state predicate that is being waited for.  An implementation is
 * free to remove the possibility of spurious wakeups but it is
 * recommended that applications programmers always assume that they
 * can occur and so always wait in a loop.
 */
interface Condition {

  /**
   * Causes the current thread to wait until it is notified.
   *
   * <p>The lock associated with this <tt>Condition</tt> is atomically 
   * released and the current thread becomes disabled for thread scheduling 
   * purposes and lies dormant until <em>one</em> of three things happens:
   * <ul>
   * <li>Some other thread invokes the notify method for this 
   * <tt>Condition</tt> and the current thread happens to be chosen as the 
   * thread to be awakened; or
   * <li>Some other thread invokes the notifyAll method for this 
   * <tt>Condition</tt>; or
   * <li>A &quot;<em>spurious wakeup</em>&quot; occurs
   * </ul>
   *
   * <p>In all cases, before this method can return the current thread must
   * re-acquire the lock associated with this condition. When the
   * thread returns it is <em>guaranteed</em> to hold this lock.
   *
   * <p><b>Implementation Considerations</b>
   * <p>The current thread is assumed to hold the lock associated
   * with this <tt>Condition</tt> when this method is called.  It is
   * up to the implementation to determine if this is the case and
   * if not, how to respond.
   */
  void wait();

  /**
   * Causes the current thread to wait until it is notified
   * or the specified waiting time elapses.
   *
   * <p>The lock associated with this condition is atomically 
   * released and the current thread becomes disabled for thread scheduling 
   * purposes and lies dormant until <em>one</em> of four things happens:
   * <ul>
   * <li>Some other thread invokes the notify method for this 
   * <tt>Condition</tt> and the current thread happens to be chosen as the 
   * thread to be awakened; or 
   * <li>Some other thread invokes the notifyAll method for this 
   * <tt>Condition</tt>; or
   * <li>The specified waiting time elapses; or
   * <li>A &quot;<em>spurious wakeup</em>&quot; occurs.
   * </ul>
   *
   * <p>In all cases, before this method can return the current
   * thread must re-acquire the lock associated with this
   * condition. When the thread returns it is <em>guaranteed</em> to
   * hold this lock.
   *
   * <p>The method returns an estimate of the number of nanoseconds
   * remaining to wait given the supplied <tt>nanosTimeout</tt>
   * value upon return, or a value less than or equal to zero if it
   * timed out. This value can be used to determine whether and how
   * long to re-wait in cases where the wait returns but an waited
   * condition still does not hold. Typical uses of this method take
   * the following form:
   *
   * \code
   * synchronized bool aMethod(long timeout, TimeUnit unit) {
   *   long nanosTimeout = unit.toNanos(timeout);
   *   while (!conditionBeingWaitedFor) {
   *     if (nanosTimeout &gt; 0)
   *         nanosTimeout = theCondition.waitNanos(nanosTimeout);
   *      else
   *        return false;
   *   }
   *   // ... 
   * }
   * \endcode
   *
   * <p> Design note: This method requires a nanosecond argument so
   * as to avoid truncation errors in reporting remaining times.
   * Such precision loss would make it difficult for programmers to
   * ensure that total waiting times are not systematically shorter
   * than specified when re-waits occur.
   *
   * <p><b>Implementation Considerations</b>
   * <p>The current thread is assumed to hold the lock associated
   * with this <tt>Condition</tt> when this method is called.  It is
   * up to the implementation to determine if this is the case and
   * if not, how to respond.
   *
   * \param nanosTimeout the maximum time to wait, in nanoseconds
   * \return A value less than or equal to zero if the wait has
   * timed out; otherwise an estimate, that
   * is strictly less than the <tt>nanosTimeout</tt> argument,
   * of the time still remaining when this method returned.
   */
  long waitNanos(long nanosTimeout);

  /**
   * Causes the current thread to wait until it is notified
   * or the specified waiting time elapses. This method is behaviorally
   * equivalent to:
   * \code
   *   waitNanos(unit.toNanos(time)) > 0
   * \endcode
   * \param time the maximum time to wait
   * \param unit the time unit of the <tt>time</tt> argument.
   * \return <tt>false</tt> if the waiting time detectably elapsed
   * before return from the method, else <tt>true</tt>.
   */
  bool wait(long time, TimeUnit unit);

  /**
   * Wakes up one waiting thread.
   *
   * <p>If any threads are waiting on this condition then one
   * is selected for waking up. That thread must then re-acquire the
   * lock before returning from <tt>wait</tt>.
   **/
  void notify();

  /**
   * Wake up all waiting threads.
   *
   * <p>If any threads are waiting on this condition then they are
   * all woken up. Each thread must re-acquire the lock before it can
   * return from <tt>wait</tt>.
   **/
  void notifyAll();
}








version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
