/** \file CyclicBarrier.d
 * \brief A cyclic barrier is a reasonable choice for a barrier in
 * contexts involving a fixed sized group of threads that must
 * occasionally wait for each other.
 *
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Ported to D by Ben Hinkle.
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.0
 */

module mango.locks.CyclicBarrier;

import mango.locks.Condition;

class Error : Object
{
        private char[] msg;

        this (char[] msg)
        {
                this.msg = msg;
        }

        char[] toString()
        {
                return msg;
        }
}

private {
  import std.thread;
  import mango.locks.Utils;
  import mango.locks.Exceptions;
  import mango.locks.ReentrantLock;
  import mango.locks.TimeUnit;
}

/** \class CyclicBarrier
 * \brief A synchronization aid that allows a set of threads to all wait for
 * each other to reach a common barrier point.  
 *
 * CyclicBarriers are useful in programs involving a fixed sized party
 * of threads that must occasionally wait for each other. The barrier
 * is called <em>cyclic</em> because it can be re-used after the
 * waiting threads are released.
 *
 * <p>A <tt>CyclicBarrier</tt> supports an optional delegate that is
 * run once per barrier point, after the last thread in the party
 * arrives, but before any threads are released.  This <em>barrier
 * action</em> is useful for updating shared-state before any of the
 * parties continue.
 * 
 * <p><b>Sample usage:</b> Here is an example of
 *  using a barrier in a parallel decomposition design:
 * \code
 * class Solver {
 *   final int N;
 *   final float[][] data;
 *   final CyclicBarrier barrier;
 *   
 *   class Worker {
 *     int myRow;
 *     Worker(int row) { myRow = row; }
 *     int run() {
 *       while (!done()) {
 *         processRow(myRow);
 *         try {
 *           barrier.wait(); 
 *         } catch (BrokenBarrierException ex) { 
 *           return 1; 
 *         }
 *       }
 *       return 0;
 *     }
 *   }
 *
 *   this(float[][] matrix) {
 *     data = matrix;
 *     N = matrix.length;
 *     barrier = new CyclicBarrier(N, 
 *         delegate int() { mergeRows(...); });
 *     for (int i = 0; i < N; ++i) 
 *       (new Thread(new Worker(i))).start();
 *     waitUntilDone();
 *   }
 * }
 * \endcode
 *
 * Here, each worker thread processes a row of the matrix then waits
 * at the barrier until all rows have been processed. When all rows
 * are processed the supplied barrier action is executed and merges
 * the rows. If the merger determines that a solution has been found
 * then <tt>done()</tt> will return <tt>true</tt> and each worker will
 * terminate.
 *
 * <p>If the barrier action does not rely on the parties being
 * suspended when it is executed, then any of the threads in the party
 * could execute that action when it is released. To facilitate this,
 * each invocation of wait returns the arrival index of that thread at
 * the barrier.  You can then choose which thread should execute the
 * barrier action.
 *
 * <p>The <tt>CyclicBarrier</tt> uses a fast-fail all-or-none breakage
 * model for failed synchronization attempts: If a thread leaves a
 * barrier point prematurely because of failure, or timeout, all other
 * threads, even those that have not yet resumed from a previous
 * wait. will also leave abnormally via BrokenBarrierException.
 */
class CyclicBarrier {

  /** The lock for guarding barrier entry */
  private ReentrantLock lock;
  /** Condition to wait on until tripped */
  private Condition trip;
  /** The number of parties */
  private int parties_;
  /* The command to run when tripped */
  private int delegate() barrierCommand;

  /**
   * The generation number. Incremented upon barrier trip.
   * Retracted upon reset.
   */
  private long generation; 

  /** 
   * Breakage indicator.
   */
  private bool broken; 

  /**
   * Number of parties still waiting. Counts down from parties to 0
   * on each cycle.
   */
  private int count; 

  /**
   * Updates state on barrier trip and wake up everyone.
   */  
  private void nextGeneration() {
    count = parties_;
    ++generation;
    trip.notifyAll();
  }

  /**
   * Sets barrier as broken and wake up everyone
   */
  private void breakBarrier() {
    broken = true;
    trip.notifyAll();
  }

  /**
   * Main barrier code, covering the various policies.
   */
  private int dowait(bool timed, long nanos) {
    ReentrantLock lock = this.lock;
    lock.lock();
    try {
      int index = --count;
      long g = generation;

      if (broken) 
	throw new BrokenBarrierException();

      //            if (Thread.interrupted()) {
      //                breakBarrier();
      //                throw new InterruptedException();
      //            }

      if (index == 0) {  // tripped
	nextGeneration();
	bool ranAction = false;
	try {
	  int delegate() command = barrierCommand;
	  if (command !is null) 
	    command();
	  ranAction = true;
	  return 0;
	} finally {
	  if (!ranAction)
	    breakBarrier();
	}
      }

      for (;;) {
	try {
	  if (!timed) 
	    trip.wait();
	  //                    else if (nanos > 0L)
	  //                        nanos = trip.waitNanos(nanos);
	} catch (WaitException ie) {
	  breakBarrier();
	  throw ie;
	}
                
	if (broken || 
	    g > generation) // true if a reset occurred while waiting
	  throw new BrokenBarrierException();

	if (g < generation)
	  return index;

	if (timed && nanos <= 0L) {
	  breakBarrier();
	  throw new TimeoutException();
	}
      }

    } finally {
      lock.unlock();
    }
  }


  /**
   * Creates a new <tt>CyclicBarrier</tt> that will trip when the
   * given number of parties (threads) are waiting upon it, and which
   * will execute the given barrier action when the barrier is
   * tripped, performed by the last thread entering the barrier.
   *
   * \param parties the number of threads that must invoke wait
   * before the barrier is tripped.
   * \param barrierAction the command to execute when the barrier is
   * tripped, or <tt>null</tt> if there is no action.
   */
  this(int parties, int delegate() barrierAction = null) {
    if (parties <= 0)
      throw new IllegalArgumentException();
    this.lock = new ReentrantLock();
    this.trip = lock.newCondition();
    this.parties_ = parties; 
    this.count = parties;
    this.barrierCommand = barrierAction;
  }

  /**
   * Returns the number of parties required to trip this barrier.
   * \return the number of parties required to trip this barrier.
   **/
  int parties() {
    return parties_;
  }

  /**
   * Waits until all parties have invoked <tt>wait</tt> on this
   * barrier.
   *
   * <p>If the current thread is not the last to arrive then it is
   * disabled for thread scheduling purposes and lies dormant until
   * one of following things happens:
   * <ul>
   * <li>The last thread arrives; or
   * <li>Some other thread times out while waiting for barrier; or
   * <li>Some other thread invokes reset on this barrier.
   * </ul>
   *
   * <p>If the barrier is reset while any thread is waiting, or if the
   * barrier is broken when <tt>wait</tt> is invoked, or while any
   * thread is waiting, then BrokenBarrierException is thrown.
   *
   * <p>If the current thread is the last thread to arrive, and a
   * non-null barrier action was supplied in the constructor, then the
   * current thread runs the action before allowing the other threads
   * to continue.  If an exception occurs during the barrier action
   * then that exception will be propagated in the current thread and
   * the barrier is placed in the broken state.
   *
   * \return the arrival index of the current thread, where index
   *  <tt>parties - 1</tt> indicates the first to arrive and 
   * zero indicates the last to arrive.
   */
  int wait() {
    try {
      return dowait(false, 0L);
    } catch (TimeoutException toe) {
      throw new Error("Timeout"); // cannot happen;
    }
  }

  /**
   * Waits until all parties have invoked <tt>wait</tt>
   * on this barrier.
   *
   * <p>If the current thread is not the last to arrive then it is
   * disabled for thread scheduling purposes and lies dormant until
   * one of the following things happens:
   * <ul>
   * <li>The last thread arrives; or
   * <li>The specified timeout elapses; or
   * <li>Some other thread times out while waiting for barrier; or
   * <li>Some other thread invokes reset on this barrier.
   * </ul>
   *
   * <p>If the barrier is reset while any thread is waiting, or if the
   * barrier is broken when <tt>wait</tt> is invoked, or while any
   * thread is waiting, then BrokenBarrierException is thrown.
   *
   * <p>If the current thread is the last thread to arrive, and a
   * non-null barrier action was supplied in the constructor, then the
   * current thread runs the action before allowing the other threads
   * to continue.  If an exception occurs during the barrier action
   * then that exception will be propagated in the current thread and
   * the barrier is placed in the broken state.
   *
   * \param timeout the time to wait for the barrier
   * \param unit the time unit of the timeout parameter
   * \return the arrival index of the current thread, where index
   *  <tt>parties - 1</tt> indicates the first to arrive and 
   * zero indicates the last to arrive.
   */
  int wait(long timeout, TimeUnit unit) {
    return dowait(true, toNanos(timeout,unit));
  }

  /**
   * Queries if this barrier is in a broken state.
   * \return <tt>true</tt> if one or more parties broke out of this
   * barrier due to timeout since construction or the last reset, or a
   * barrier action failed due to an exception; and <tt>false</tt>
   * otherwise.
   */
  bool isBroken() {
    ReentrantLock lock = this.lock;
    lock.lock();
    try {
      return broken;
    } finally {
      lock.unlock();
    }
  }

  /**
   * Resets the barrier to its initial state.  If any parties are
   * currently waiting at the barrier, they will return with a
   * BrokenBarrierException. Note that resets <em>after</em>
   * a breakage has occurred for other reasons can be complicated to
   * carry out; threads need to re-synchronize in some other way,
   * and choose one to perform the reset.  It may be preferable to
   * instead create a new barrier for subsequent use.
   */
  void reset() {
    ReentrantLock lock = this.lock;
    lock.lock();
    try {
      /*
       * Retract generation number enough to cover threads
       * currently waiting on current and still resuming from
       * previous generation, plus similarly accommodating spans
       * after the reset.
       */
      generation -= 4;
      broken = false;
      trip.notifyAll();
    } finally {
      lock.unlock();
    }
  }

  /**
   * Returns the number of parties currently waiting at the barrier.
   * This method is primarily useful for debugging and assertions.
   *
   * \return the number of parties currently blocked in <tt>wait</tt>
   **/
  int getNumberWaiting() {
    ReentrantLock lock = this.lock;
    lock.lock();
    try {
      return parties_ - count;
    } finally {
      lock.unlock();
    }
  }

  unittest {
    double Solver(float[][] matrix) {
      int N = matrix.length;
      float[] totals;
      totals.length = N;
      float grand_total = 0;
      bool done = false;
      // nested function to run after barrier is triggered
      int mergeRows() {
	for (int k=0;k<N;k++)
	  grand_total += totals[k];
	done = true;
	return 0;
      }
      CyclicBarrier barrier = new CyclicBarrier(N,&mergeRows);
      bool gotRow = false;
      int i;
      // nested function to run in each thread
      ThreadReturn workerFcn() {
	int myRow;
	myRow = i;
	gotRow = true;
	for (int k=0;k<N;k++) {
	  totals[myRow] += matrix[myRow][k];
	}

	try {
	  barrier.wait(); 
	}
	catch (WaitException ex) { return 0; }
	catch (BrokenBarrierException ex) { return 0; }
	return 0;
      }
      for (i = 0; i < N; ++i) {
	//    for (int k=1;k<1000;k++) Thread.yield();
	gotRow = false;
	(new Thread(&workerFcn)).start();
	while (!gotRow) Thread.yield();
	//    for (int k=1;k<1000;k++) Thread.yield();
      }
      while (!done) Thread.yield();
      return grand_total;
    }

    version (LocksVerboseUnittest)
      printf("started locks.cyclicbarrier unittest\n");
    float[][] mat;
    mat.length = 3;
    for (int k=0;k<3;k++)
      mat[k].length = 3;
    for (int j=0;j<3;j++) {
      for (int k=0;k<3;k++)
	mat[j][k] = j+k;
    }
    assert(18 == Solver(mat));
    version (LocksVerboseUnittest)
      printf("finished locks.cyclicbarrier unittest\n");
  }
}



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
