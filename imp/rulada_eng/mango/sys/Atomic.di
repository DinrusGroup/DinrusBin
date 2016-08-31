/** \file Atomic.d
 * \brief Declarations for atomic compare-and-set operations and 
 * platform-specific utility functions.
 *
 * Written by Ben Hinkle and released to the public domain, as
 * explained at http://creativecommons.org/licenses/publicdomain
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.02
 *
 * Modified for purposes of Mango; May 28th 2005
 * Note that the non-asm version does not support multiple CPUs
 * or multi-core CPUs. Note also that pointers passed to these
 * routines should be correctly aligned for the bus size, which
 * which is typically 32 bits.
 *
 */

module mango.sys.Atomic;

// comment this out to get generic non-asm implementations
version = ASM;

struct Atomic
{

/** Compare expect to *ptr and if equal copy update to *ptr and return true;
 * Otherwise return false.
 * \param ptr the memory location to update
 * \param expect the expected value at *ptr
 * \param update the new value for *ptr
 * \return true if successful
 */
static bool compareAndSet32(void* vptr, void* expect, void* update) {
  return compareAndSet32(vptr,cast(int)expect,cast(int)update);
}

version (ASM) {
  // alternative declaration for data instead of pointers
  static bool compareAndSet32(void* vptr, int expect, int update) {
    asm {
      mov	EBX,update;
      mov	EAX,expect;
      mov	ECX,vptr;
      lock;
      cmpxchg	[ECX],EBX;
      setz	AL;
    }
  }
}
else 
{
  static bool compareAndSet32(void* vptr, int expect, int update) {
    int* vi = cast(int*)vptr;
    bool res = false;
    synchronized {
      res = expect == *vi;
      if (res) {
	*vi = update;
      }
    }
    return res;
  }
}
} // end of Atomic

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
