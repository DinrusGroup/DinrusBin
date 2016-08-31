/*  Metafunctions mimicing those in std.math
 *
 * Compile with -version=testmeta to run unit tests.
 */
module meta.math;

/* *******************************************
 * bool isnan!(real x)
 *
 *  Return true if and only if x is an IEEE not-a-number
 */
template isnan(real x)
{
  const bool isnan = (x!<>=0);
}

template isPositiveZero(real x)
{
    static if (x==0 && 1.0L/x > 0) 
        const bool isPositiveZero = true;
    else 
        const bool isPositiveZero = false;
}

template isNegativeZero(real x)
{
    static if (x==0 && 1.0L/x < 0) 
        const bool isNegativeZero = true;
    else 
        const bool isNegativeZero = false;
}

version(testmeta) {

static assert( isPositiveZero!(0.0L));
static assert( !isPositiveZero!(-0.0L));
static assert( !isPositiveZero!(real.nan));
static assert( isNegativeZero!(-0.0L));
static assert( !isNegativeZero!(0.0L));
}

/*   real abs!(real x) */
template abs(real x)
{
  static if (x<0) const real abs = -x;
  else const real abs = x;
}

/* long abs(long x) */
template abs(long x)
{
  static if (x<0) const long abs = -x;
  else const long abs = x;
}

/* ******************************************* 
 * int binaryExponent!(real x)
 * Returns the binary exponent of a real number x.
 *
 * x must not be infinity or nan.
 */
template binaryExponent(real x)
{
  static if (x<0)  const int binaryExponent = .binaryExponent!(-x);
  else static if (x>0x1p128) const int binaryExponent = .binaryExponent!(x/0x1p128)+ 128;
  else static if (x<0x1p-128)const int binaryExponent = .binaryExponent!(x*0x1p128)- 128;
  else static if (x>0x1p32)  const int binaryExponent = .binaryExponent!(x/0x1p32)+ 32;
  else static if (x<0x1p-32) const int binaryExponent = .binaryExponent!(x*0x1p32)- 32;
  else static if (x>=2.0)    const int binaryExponent = .binaryExponent!(x/2) + 1;
  else static if (x<1.0)     const int binaryExponent = .binaryExponent!(x*2) - 1;
  else                        const int binaryExponent = 0;
}

/* *******************************************
 *  int decimalExponent!(real x)
 * Returns the decimal exponent of a real number x.
 *
 * x must not be infinity or nan.
 */
template decimalExponent(real x)
{
  static if (x<0) const int decimalExponent = .decimalExponent!(-x);
  else static if (x<1) 
    const int decimalExponent = -1 - .decimalExponent!(1/x);
  else static if (x>1e10000L)
    const int decimalExponent= .decimalExponent!(x/1e10000L) + 10000;
  else static if (x>1e1000L) 
    const int decimalExponent= .decimalExponent!(x/1e1000L) + 1000;
  else static if (x>1e100L) 
    const int decimalExponent = .decimalExponent!(x/1e100L) + 100;
  else static if (x>1e10)
    const int decimalExponent = .decimalExponent!(x/1e10) + 10;
  else static if (x>10)
    const int decimalExponent = .decimalExponent!(x/10) + 1;
  else const int decimalExponent = 0;
}

/* real binaryMantissa!(real x) */
template binaryMantissa(real x)
{
  const real binaryMantissa = x * pow!(2, -.binaryExponent!(x));
}

/* *******************************************
 * real pow!(real a, int b) 
 * Fast integer powers
 */
template pow(real a, int b)
{
  static if (b==0) const real pow=1.0L;
  else static if (b<0) const real pow = 1.0L/.pow!(a, -b);
  else static if (b==1) const real pow = a;
  else static if (b & 1) const real pow = a * .pow!(a*a, b>>1);
  else const real pow = .pow!(a*a, b>>1);
}


/* *******************************************
 * creal powz!(creal a, int b) 
 * Fast integer powers of a complex number
 */
template cpow(creal a, int b)
{
  static if (b==0) const creal cpow=1.0L;
  else static if (b<0) const creal cpow = 1.0L/.cpow!(a, -b);
  else static if (b==1) const creal cpow = a;
  else static if (b & 1) const creal cpow = a * .cpow!(a*a, b>>1);
  else const creal cpow = .cpow!(a*a, b>>1);
}

version(testmeta) {

 static assert( pow!(22, 13) == 282810057883082752L);
 static assert( isnan!(real.nan));
 static assert(!isnan!(real.infinity));
 static assert(binaryExponent!(0x1.54437p+149)==149);
 static assert(binaryExponent!(0x1.54437p-12)==-12);
 static assert(binaryExponent!(0x1.54437p0)==0);
 static assert(decimalExponent!(7e38)==38);
 static assert(decimalExponent!(7e-38)==-38);
 static assert(decimalExponent!(1)==0);
 static assert(decimalExponent!(-300)==2);
}

