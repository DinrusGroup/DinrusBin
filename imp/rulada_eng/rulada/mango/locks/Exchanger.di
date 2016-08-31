/** \file Exchanger.d
 * \brief A synchronization point at which two threads can exchange
 * objects.
 *
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Ported to D by Ben Hinkle.
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.0
 */

module mango.locks.Exchanger;
private {
  import mango.locks.Utils;
  import mango.locks.TimeUnit;
  import mango.locks.Exceptions;
  import mango.locks.ReentrantLock;

  // for unittest
  import std.thread;
  import mango.locks.Countdown;
}

/** \class Exchanger
 * \brief A synchronization point at which two threads can exchange
 * objects.  Each thread presents some object on entry to the exchange
 * method, and receives the object presented by the other thread on
 * return.
 *
 * <p><b>Sample Usage:</b>
 * Here are the highlights of a class that uses an <tt>Exchanger</tt>
 * to swap buffers between threads so that the thread filling the
 * buffer gets a freshly emptied one when it needs it, handing off the
 * filled one to the thread emptying the buffer.
 * <pre>
 *   Exchanger!(DataBuffer) exchanger = new Exchanger!(DataBuffer);
 *   DataBuffer initialEmptyBuffer = ... a made-up type
 *   DataBuffer initialFullBuffer = ...
 *   Thread t1 = new Thread(
 *     delegate int() {
 *       DataBuffer currentBuffer = initialEmptyBuffer;
 *       while (currentBuffer != null) {
 *         addToBuffer(currentBuffer);
 *         if (currentBuffer.full())
 *           currentBuffer = exchanger.exchange(currentBuffer);
 *       }
 *       return 0;
 *     });
 *   Thread t2 = new Thread(
 *     delegate int() {
 *       DataBuffer currentBuffer = initialFullBuffer;
 *       while (currentBuffer != null) {
 *         takeFromBuffer(currentBuffer);
 *         if (currentBuffer.empty())
 *           currentBuffer = exchanger.exchange(currentBuffer);
 *       }
 *       return 0;
 *     });
 *   t1.start();
 *   t2.start();
 * }
 * </pre>
 */
class Exchanger(Value) {
  private ReentrantLock lock;
  private Condition taken;

  /** Holder for the item being exchanged */
  private Value item;
    
  /**
   * Arrival count transitions from 0 to 1 to 2 then back to 0
   * during an exchange.
   */
  private int arrivalCount;

  /**
   * Main exchange function, handling the different policy variants.
   */
  private Value doExchange(Value x, bool timed, long nanos) {
    lock.lock();
    try {
      Value other;

      // If arrival count already at two, we must wait for
      // a previous pair to finish and reset the count;
      while (arrivalCount == 2) {
	if (!timed)
	  taken.wait();
	else if (nanos > 0) 
	  nanos = taken.waitNanos(nanos);
	else 
	  throw new TimeoutException();
      }

      int count = ++arrivalCount;

      // If item is already waiting, replace it and signal other thread
      if (count == 2) { 
	other = item;
	item = x;
	taken.notify();
	return other;
      }

      // Otherwise, set item and wait for another thread to
      // replace it and signal us.

      item = x;
      while (arrivalCount != 2) {
	if (!timed)
	  taken.wait();
	else if (nanos > 0) 
	  nanos = taken.waitNanos(nanos);
	else 
	  break; // timed out
      }

      // Get and reset item and count after the wait.
      // (We need to do this even if wait was aborted.)
      other = item;
      item = Value.init;
      count = arrivalCount;
      arrivalCount = 0; 
      taken.notify();
            
      // If the other thread replaced item, then we must
      // continue even if cancelled.
      if (count == 2) {
	return other;
      }

      // If no one is waiting for us, we can back out
      throw new TimeoutException();
    } finally {
      lock.unlock();
    }
  }

  /**
   * Create a new Exchanger.
   */
  this() {
    lock = new ReentrantLock();
    taken = lock.newCondition();
  }

  /**
   * Waits for another thread to arrive at this exchange point and
   * then transfers the given object to it, receiving its object in
   * return.
   *
   * <p>If another thread is already waiting at the exchange point then
   * it is resumed for thread scheduling purposes and receives the object
   * passed in by the current thread. The current thread returns immediately,
   * receiving the object passed to the exchange by that other thread.
   * <p>If no other thread is already waiting at the exchange then the 
   * current thread is disabled for thread scheduling purposes and lies
   * dormant until some other thread enters the exchange.
   *
   * \param x the object to exchange
   * \return the object provided by the other thread.
   */
  Value exchange(Value x) {
    return doExchange(x, false, 0);
  }

  /**
   * Waits for another thread to arrive at this exchange point (unless
   * the specified waiting time elapses), and then transfers the given
   * object to it, receiving its object in return.
   *
   * <p>If another thread is already waiting at the exchange point then
   * it is resumed for thread scheduling purposes and receives the object
   * passed in by the current thread. The current thread returns immediately,
   * receiving the object passed to the exchange by that other thread.
   *
   * <p>If no other thread is already waiting at the exchange then the 
   * current thread is disabled for thread scheduling purposes and lies
   * dormant until one of three things happens:
   * <ul>
   * <li>Some other thread enters the exchange; or
   * <li>The specified waiting time elapses.
   * </ul>
   *
   * <p>If the specified waiting time elapses then TimeoutException is
   * thrown.  If the time is less than or equal to zero, the method
   * will not wait at all.
   *
   * \param x the object to exchange
   * \param timeout the maximum time to wait
   * \param unit the time unit of the <tt>timeout</tt> argument.
   * \return the object provided by the other thread.
   */
  Value exchange(Value x, long timeout, TimeUnit unit) {
    return doExchange(x, true, toNanos(timeout,unit));
  }

}

unittest {
  version (LocksVerboseUnittest)
    printf("starting locks.exchanger unittest\n");
  Exchanger!(int) ex = new Exchanger!(int);
  CountDownLatch done = new CountDownLatch(2);

  Thread t1 = new Thread( delegate ThreadReturn() {
    int my_val = 10;
    my_val = ex.exchange(my_val);
    assert( my_val == 20 );
    done.countDown();
    return 0;
  });
  Thread t2 = new Thread( delegate ThreadReturn() {
    int my_val = 20;
    my_val = ex.exchange(my_val);
    assert( my_val == 10 );
    done.countDown();
    return 0;
  });
  t1.start();
  t2.start();
  done.wait();
  version (LocksVerboseUnittest)
    printf("finished locks.exchanger unittest\n");
}



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
