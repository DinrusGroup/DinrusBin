/** \file Countdown.d
 * \brief A latch that fires after a specified count.
 *
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Ported to D by Ben Hinkle.
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.0
 */

module mango.locks.Countdown;

private {
  import std.thread;

  import mango.sys.Atomic;

  import mango.locks.Utils;
  import mango.locks.LockImpl;
  import mango.locks.TimeUnit;
  import mango.locks.Exceptions;
}

/** \class CountDownLatch
 * \brief A synchronization aid that allows one or more threads to
 * wait until a set of operations being performed in other threads
 * completes.
 *
 * <p>A <tt>CountDownLatch</tt> is initialized with a given
 * <em>count</em>.  The wait methods block until the current count
 * reaches zero due to invocations of the countDown method, after
 * which all waiting threads are released and any subsequent
 * invocations of wait return immediately. This is a one-shot
 * phenomenon -- the count cannot be reset.  If you need a version
 * that resets the count, consider using a CyclicBarrier.
 *
 * <p>A <tt>CountDownLatch</tt> is a versatile synchronization tool
 * and can be used for a number of purposes.  A
 * <tt>CountDownLatch</tt> initialized with a count of one serves as a
 * simple on/off latch, or gate: all threads invoking wait wait at the
 * gate until it is opened by a thread invoking countDown.  A
 * <tt>CountDownLatch</tt> initialized to <em>N</em> can be used to
 * make one thread wait until <em>N</em> threads have completed some
 * action, or some action has been completed N times.  <p>A useful
 * property of a <tt>CountDownLatch</tt> is that it doesn't require
 * that threads calling <tt>countDown</tt> wait for the count to reach
 * zero before proceeding, it simply prevents any thread from
 * proceeding past an wait until all threads could pass.
 *
 * <p><b>Sample usage:</b> Here is a pair of classes in which a group
 * of worker threads use two countdown latches:
 * 
 *  - The first is a start signal that prevents any worker from proceeding
 *    until the driver is ready for them to proceed;
 *  - The second is a completion signal that allows the driver to wait
 *    until all workers have completed.
 *
 * \code
 * class Driver {
 *   void main() {
 *     CountDownLatch startSignal;
 *     CountDownLatch doneSignal;
 *
 *     this() {
 *       startSignal = new CountDownLatch(1);
 *       doneSignal = new CountDownLatch(N);
 *     }
 *     for (int i = 0; i < N; ++i) { // create and start threads
 *       Worker work = new Worker(startSignal, doneSignal);
 *       new Thread(&work.run).start();
 *
 *     doSomethingElse();            // don't let run yet
 *     startSignal.countDown();      // let all threads proceed
 *     doSomethingElse();
 *     doneSignal.wait();            // wait for all to finish
 *   }
 * }
 *
 * class Worker {
 *   private CountDownLatch startSignal;
 *   private CountDownLatch doneSignal;
 *   this(CountDownLatch startSignal, CountDownLatch doneSignal) {
 *      this.startSignal = startSignal;
 *      this.doneSignal = doneSignal;
 *   }
 *   int run() {
 *      startSignal.wait();
 *      doWork();
 *      doneSignal.countDown();
 *      return 0;
 *   }
 *
 *   void doWork() { ... }
 * }
 *\endcode
 */
class CountDownLatch {

  /*
   * Synchronization control For CountDownLatch.
   * Uses AbstractLock state to represent count.
   */
  private final class Sync : AbstractLock {
    this(int count) {
      state = count; 
    }
        
    int getCount() {
      return state;
    }

    int tryAcquireShared(int acquires) {
      return state == 0? 1 : -1;
    }
        
    bool tryReleaseShared(int releases) {
      // Decrement count; signal when transition to zero
      for (;;) {
	int c = state;
	if (c == 0)
	  return false;
	int nextc = c-1;
	if (Atomic.compareAndSet32(&state_, c, nextc)) 
	  return nextc == 0;
      }
    }
  }

  private Sync sync;

  /**
   * Constructs a <tt>CountDownLatch</tt> initialized with the given
   * count.
   * 
   * \param count the number of times countDown must be invoked before
   * threads can pass through wait
   */
  this(int count) {
    if (count < 0)
      throw new IllegalArgumentException();
    this.sync = new Sync(count);
  }

  /**
   * Causes the current thread to wait until the latch has counted
   * down to zero.
   *
   * <p>If the current count is zero then this method returns
   * immediately. If the current count is greater than zero then
   * the current thread becomes disabled for thread scheduling
   * purposes and lies dormant until the count reaches zero due to
   * invocations of the countDown method.
   */
  void wait() {
    sync.acquireShared(1);
  }

  /**
   * Causes the current thread to wait until the latch has counted
   * down to zero.
   *
   * <p>If the current count is zero then this method returns
   * immediately with the value <tt>true</tt>.
   *
   * <p>If the current count is greater than zero then the current
   * thread becomes disabled for thread scheduling purposes and lies
   * dormant until one of three things happen:
   *  - The count reaches zero due to invocations of the
   *    countDown method; or
   *  - The specified waiting time elapses.
   *
   * <p>If the count reaches zero then the method returns with the
   * value <tt>true</tt>.
   *
   * <p>If the specified waiting time elapses then the value
   * <tt>false</tt> is returned. If the time is less than or equal to
   * zero, the method will not wait at all.
   *
   * \param timeout the maximum time to wait
   * \param unit the time unit of the <tt>timeout</tt> argument.
   * \return <tt>true</tt> if the count reached zero  and <tt>false</tt>
   *   if the waiting time elapsed before the count reached zero.
   */
  bool wait(long timeout, TimeUnit unit) {
    return sync.tryAcquireSharedNanos(1, toNanos(timeout,unit));
  }

  /**
   * Decrements the count of the latch, releasing all waiting threads
   * if the count reaches zero.
   *
   * <p>If the current count is greater than zero then it is
   * decremented. If the new count is zero then all waiting threads
   * are re-enabled for thread scheduling purposes.
   *
   * <p>If the current count equals zero then nothing happens.
   */
  void countDown() {
    sync.releaseShared(1);
  }

  /**
   * Returns the current count. This method is typically used for
   * debugging and testing purposes.
   * \return the current count.
   */
  long count() {
    return sync.getCount();
  }

  /**
   * Returns a string identifying this latch, as well as its state.
   * The state, in brackets, includes the String &quot;Count =&quot;
   * followed by the current count.
   * \return a string identifying this latch, as well as its state
   */
  char[] toString() {
    char[16] buf;

    return super.toString() ~ "[Count = " ~ 
      itoa(buf, sync.getCount()) ~ "]";
  }

  unittest {
    class Worker { 
      private final CountDownLatch done;
      this(CountDownLatch d) { done = d; }

      ThreadReturn run() {
	version (LocksVerboseUnittest)
	  printf("counting down...\n");
	for (int k=0;k<10000; k++){}
	done.countDown();
	return 0;
      }
    }
    int N = 5;
    version (LocksVerboseUnittest)
      printf("starting locks.countdown unittest\n");
    CountDownLatch done = new CountDownLatch(N);
    for (int i = 0; i < N; ++i) {
      Worker w = new Worker(done);
      Thread t = new Thread(&w.run);
      t.start();
    }
    for (int k=0;k<10000; k++){}
    done.wait(); // wait for all to finish
    version (LocksVerboseUnittest)
      printf("finished locks.countdown unittest\n");
  }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
