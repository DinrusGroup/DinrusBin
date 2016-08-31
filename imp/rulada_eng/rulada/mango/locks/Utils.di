/** \file Utils.d
 * \brief Declarations for atomic compare-and-set operations and 
 * platform-specific utility functions.
 *
 * Written by Ben Hinkle and released to the public domain, as
 * explained at http://creativecommons.org/licenses/publicdomain
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * Modified for Mango; may28th 2005
 * Much of the original has been placed into mango.sys.Atomic
 *
 *
 * revision 2.02
 */

module mango.locks.Utils;

version (Ares)
         version (LocksVerboseUnittest)
                  extern (C) int printf (char*, ...);

version (Ares)
         alias void ThreadReturn;
      else
         alias int ThreadReturn;


char[] itoa (char[] buf, uint i)
{
        char*p = buf.ptr + buf.length;

        while (p > buf.ptr)
              {
              *--p = i % 10 + '0';
              if (i /= 10 == 0)
                  break;
              } 

        return buf [p-buf.ptr .. buf.length];
}

package import mango.sys.Epoch;

alias  Epoch.utcNano  currentTimeNanos;
alias  Epoch.utcMilli currentTimeMillis;


package import mango.sys.System;

void sleepNanos (long nanos) {
  System.sleep (nanos / 1000);
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
