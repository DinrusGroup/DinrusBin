/**
 */
module meta.generatetable;
 
private import meta.hack.hackgenerate;

/**  T [] generateArray!( T function!(int) generator, int n)
 * Generate a lookup table
 * 
 * Returns the constant array [ generator!(0), generator!(1),.. generator!(n)]
 * Params:
 *  generator   The name of a metafunction template which takes a single integer parameter,
 *              and returns a constant value of arbitrary type. generator!(0) 
 *              must be valid.
 *              It must be a template name, not a template instance. 
 *  n           The highest entry to generate. It must be between 0 and 127, inclusive.
 * 
 * Example:
 *    Here, the computationally expensive factorial function is completely moved to compile
 *    time.
 ----
 // Returns correct value for n=0 (factorial(0)=1).
template factorial(uint n)
{
  static if (n<2) const ulong factorial = 1;
  else const ulong factorial = n * factorial!(n-1);
} 

// Make an array of all the factorials from 0 to 20.
const ulong [] smallfactorials  = generateLookupTable!(factorial, 20);

ulong factorial(uint n)
{
  assert(n<=20);
  return smallfactorials[n];
}
-----
 */
template generateArray(alias generator, int n)
{
     const typeof(generator!(0)) [] generateArray = hackgenerate!(n, generator);
}
