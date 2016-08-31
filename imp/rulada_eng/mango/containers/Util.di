/*******************************************************************************

        @file Util.d

        Copyright (c) 2005 John Demme
        
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.
        
        Permission is hereby granted to anyone to use this software for any 
        purpose, including commercial applications, and to alter it and/or 
        redistribute it freely, subject to the following restrictions:
        
        1. The origin of this software must not be misrepresented; you must 
           not claim that you wrote the original software. If you use this 
           software in a product, an acknowledgment within documentation of 
           said product would be appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must 
           not be misrepresented as being the original software.

        3. This notice may not be removed or altered from any distribution
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full and credit the original source.


                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      
        @version        Initial version, June 2005
        @author         John Demme (me@teqdruid.com)


*******************************************************************************/


/**
 * jhash() -- hash a variable-length key into a 32-bit value
 *   k     : the key (the unaligned variable-length array of bytes)
 *   len   : the length of the key, counting by bytes
 *   level : can be any 4-byte value
 * Returns a 32-bit value.  Every bit of the key affects every bit of
 * the return value.  Every 1-bit and 2-bit delta achieves avalanche.
 * About 36+6len instructions.
 *
 * The best hash table sizes are powers of 2.  There is no need to do
 * mod a prime (mod is sooo slow!).  If you need less than 32 bits,
 * use a bitmask.  For example, if you need only 10 bits, do
 *   h = (h & hashmask(10));
 * In which case, the hash table should have hashsize(10) elements.
 *
 * If you are hashing n strings (ub1 **)k, do it like this:
 *   for (i=0, h=0; i<n; ++i) h = hash( k[i], len[i], h);
 *
 * By Bob Jenkins, 1996.  bob_jenkins@burtleburtle.net.  You may use this
 * code any way you wish, private, educational, or commercial.  It's free.
 *
 * See http://burlteburtle.net/bob/hash/evahash.html
 * Use for hash table lookup, or anything where one collision in 2^32 is
 * acceptable. Do NOT use for cryptographic purposes.
 */

module mango.containers.Util;

uint jhash (ubyte* k, uint len)
{
  uint    a, b, c;
  
  a = b = 0x9e3779b9; 
  
  // the previous hash value
  c = 0;   
  
  // handle most of the key 
  while (len >= 12) 
    {
      a += *cast(uint *)(k+0);
      b += *cast(uint *)(k+4);
      c += *cast(uint *)(k+8);
      
      a -= b; a -= c; a ^= (c>>13); 
      b -= c; b -= a; b ^= (a<<8); 
      c -= a; c -= b; c ^= (b>>13); 
      a -= b; a -= c; a ^= (c>>12);  
      b -= c; b -= a; b ^= (a<<16); 
      c -= a; c -= b; c ^= (b>>5); 
      a -= b; a -= c; a ^= (c>>3);  
      b -= c; b -= a; b ^= (a<<10); 
      c -= a; c -= b; c ^= (b>>15); 
      k += 12; len -= 12;
    }
  
  // handle the last 11 bytes 
  c += len;
  switch (len)
    {
    case 11: c+=(cast(uint)k[10]<<24);
    case 10: c+=(cast(uint)k[9]<<16);
    case 9 : c+=(cast(uint)k[8]<<8);
    case 8 : b+=(cast(uint)k[7]<<24);
    case 7 : b+=(cast(uint)k[6]<<16);
    case 6 : b+=(cast(uint)k[5]<<8);
    case 5 : b+=k[4];
    case 4 : a+=(cast(uint)k[3]<<24);
    case 3 : a+=(cast(uint)k[2]<<16);
    case 2 : a+=(cast(uint)k[1]<<8);
    case 1 : a+=k[0];
    default:
    }
  
  a -= b; a -= c; a ^= (c>>13); 
  b -= c; b -= a; b ^= (a<<8); 
  c -= a; c -= b; c ^= (b>>13); 
  a -= b; a -= c; a ^= (c>>12);  
  b -= c; b -= a; b ^= (a<<16); 
  c -= a; c -= b; c ^= (b>>5); 
  a -= b; a -= c; a ^= (c>>3);  
  b -= c; b -= a; b ^= (a<<10); 
  c -= a; c -= b; c ^= (b>>15); 
  
  return c;
}

alias jhash byteHash;

template Util(V) {
  public uint hash(V v) {
    static if( is(V == class) || is(V == interface)) { //Classes .toHash
      Object o = cast(Object)v;
      assert(o);
      return o.toHash();
    } else static if(  is( typeof( V.toHash ) == function)) { //Some structs have .toHash as well
      return v.toHash();
    } else static if( is(V U : U[]) && ( is(U == class) || is(U == interface) || is( typeof( U.toHash ) == function)) ) { 
      uint hash = 0;
      foreach(U u; v) {
	hash ^= .Util!(U).hash(u);
      }
      return hash; 
    } else static if ( is(V U : U[]) ) { //If it's not a class, do it en mass
      return byteHash(cast(ubyte*)v.ptr, U.sizeof * v.length);
    } else static if ( is(V U : U*) ) { //For pointers, get the hash of what's at the location,
      return .Util!(U).hash(*v);
    } else static if ( is (V == delegate) ||
		       is (V == struct) ||
		       is (V : bit) ||
		       is (V : byte) ||
		       is (V : ubyte) ||
		       is (V : short) ||
		       is (V : ushort) ||
		       is (V : int) ||
		       is (V : uint) ||
		       is (V : long) ||
		       is (V : ulong) ||
		       //is (V : cent) ||  //These two not supported by DMD yet
		       //is (V : ucent) ||
		       is (V : float) ||
		       is (V : double) ||
		       is (V : real) ||
		       is (V : ifloat) ||
		       is (V : idouble) ||
		       is (V : ireal) ||
		       is (V : cfloat) ||
		       is (V : cdouble) ||
		       is (V : creal) ||
		       is (V : char) ||
		       is (V : wchar) ||
		       is (V : dchar) ) { //Use hash and .sizeof on these

      return byteHash(cast(ubyte*)&v, V.sizeof);
    } else {
      static assert(false); //This type not supported.  Sorry
    }
  }

  public int equals(V a, V b) {
    static if( is(V == class) || is(V == interface) ) {
      if (a is null) {
	return (b is null);
      } else {
	return (a == b);
      }
    } else {
      return (a == b);
    }
  }

  public int cmp(V a, V b) {
    static if( is(V == class) || is(V == interface)) { //Classes .opCmp
      if (a is null) {
	if (b is null) {
	  return 0;
	} else {
	  Object o = cast(Object)b;
	  return o.opCmp(cast(Object)a) * -1; 
	}
      } else {
	Object o = cast(Object)a;
	return o.opCmp(cast(Object)b);
      }
    } else static if(  is( typeof( V.opCmp ) == function)) { //Some structs have .opCmp as well
      return a.opCmp(b);
    } else static if ( is(V U : U*) || //For pointers, subtract
		       is (V : bit) ||
		       is (V : byte) ||
		       is (V : ubyte) ||
		       is (V : short) ||
		       is (V : ushort) ||
		       is (V : int) ||
		       is (V : uint) ||
		       is (V : long) ||
		       is (V : ulong) ) {
      return cast(int)a - cast(int)b;
    } else static if ( //is (V : cent) ||  //These two not supported by DMD yet
		       //is (V : ucent) ||
		       is (V : float) ||
		       is (V : double) ||
		       is (V : real) ||
		       is (V : ifloat) ||
		       is (V : idouble) ||
		       is (V : ireal) ||
		       is (V : cfloat) ||
		       is (V : cdouble) ||
		       is (V : creal) ||
		       is (V : char) ||
		       is (V : wchar) ||
		       is (V : dchar) ) { //Use hash and .sizeof on these

      if ( a == b ) {
	return 0;
      } else if ( a > b ) {
	return 1;
      } else {
	return -1;
      }
    } else {
      return hash(a) - hash(b); //Last ditch effort- compare the hashes
    }
  }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
