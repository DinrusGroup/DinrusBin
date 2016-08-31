/** \file Exceptions.d
 *  \brief Common lock exceptions.
 *
 * This file is in the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.0
 */

module mango.locks.Exceptions;

/** \class WaitException
 *
 *  Exception class thrown when a wait() method call fails.
 */
class WaitException : Exception {
  public this(char[] str) { super(str); }
}


/** \class BrokenBarrierException
 *
 *  Exception class thrown when a cyclic barrier is broken.
 */
class BrokenBarrierException : Exception {
  public this() { super("Broken Barrier"); }
  public this(char[] str) { super(str); }
}

/** \class TimeoutException
 *
 *  Exception class thrown when a timeout occurs.
 */
class TimeoutException : Exception {
  public this() { super("Timeout"); }
  public this(char[] str) { super(str); }
}

/** \class IllegalArgumentException
 *
 *  Exception class thrown when a function input argument is invalid
 */
class IllegalArgumentException : Exception {
  public this() { super("Illegal argument"); }
  public this(char[] str) { super(str); }
}

/** \class UnsupportedOperationException
 *
 *  Exception class thrown when a class doesn't implement an operation
 */
class UnsupportedOperationException : Exception {
  this(){super("Unsupported operation");}
  this(char[] msg) { super(msg); }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
