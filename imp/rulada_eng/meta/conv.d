/*  Compile-time conversions between strings and numeric values.
  *
  * In most cases, it's not possible to overload template value parameters,
  * so most of these functions have unique names.
  * Compile with -version=testmeta to run unit tests.
  * Author: Don Clugston. License: Public domain.
  */
/*
Normally, a function which processes the first part of a string
would return the part which was not consumed (the 'tail').
This doesn't work very well for D templates, so for such functions,
we supply a seperate metafunction with the suffix 'Consumed' which returns
the  number of characters consumed. (This is the same as the index of the first
character in the string which was not consumed).
This results in some code duplication, but seems to results in a much cleaner design.
*/
  
module meta.conv;
private import meta.math;
private import meta.string;
private import meta.ctype;

template decimaldigit(int n) { const char [] decimaldigit = "0123456789"[n..n+1]; }
template hexdigit(int n) { const char [] hexdigit = "0123456789ABCDEF"[n..n+1]; }

/* *****************************************************
 *  char [] itoa!(long n);
 */
template itoa(long n)
{
	static if (n<0)
		const char [] itoa = "-" ~ itoa!(-n); 
	else static if (n<10L)
		const char [] itoa = decimaldigit!(n);
	else
		const char [] itoa = itoa!(n/10L) ~ decimaldigit!(n%10L);
}

template toHexString(ulong n)
{
	static if (n<16L)
		const char [] toHexString = hexdigit!(n);
	else
		const char [] toHexString = toHexString!(n >> 4) ~ hexdigit!(n&0xF);
}

/* *****************************************************
 *  long atoi!(char [] s);
 */
template atoi(char [] s, long result=0, int indx=0)
{
    static if (s.length==indx)
        const long atoi = result;
    else static if (indx==0 && s[indx]=='-')
        const long atoi = - atoi!(s, 0, 1);
    else static if (!isdigit!( (s[indx]) ) )
        const long atoi = result;
    else 
        const long atoi = atoi!(s, result * 10 + s[indx]-'0', indx+1);
}

/* *****************************************************
 *  the number of characters in s[] which would be 'consumed' by atoi!().
 */
template atoiConsumed(char [] s, int indx=0)
{
    static if(s.length==indx)
        const int atoiConsumed = indx;
    else static if ((indx==0 && s[indx]=='-') || isdigit!( (s[indx]) ) )
        const int atoiConsumed = atoiConsumed!(s,indx + 1);
    else    // invalid character
        const int atoiConsumed = indx;
}

private enum  EFloatParseState { START=0, GOTSIGN, WAITDOT, WAITEXP=3, GOTEXPCHAR, GOTEXPSIGN, EXPDIG };


// Like atoi!(), except that internal underscores are allowable
template parseInt(char [] s, long result=0, EFloatParseState state =0 /* start*/)
{
    static if (s.length==0) 
        const long parseInt = result;
    else static if (state == EFloatParseState.START && s[0]=='-')
        const long parseInt = - parseInt!(s[1..$], 0, GOTSIGN);
    else static if (state == EFloatParseState.WAITDOT && s[0]=='_')
        const long parseInt = parseInt!(s[1..$], result, state);
    else static if (isdigit!( (s[0]) ) ) 
        const long parseInt = parseInt!(s[1..$], result*10 + s[0]-'0', WAITDOT);
}

// Returns the value of the exponent.
// must be of the form "" or  "e-543" or "E+2_453" etc 
template parseExponent(char [] s, int result = 0, EFloatParseState state = EFloatParseState.WAITEXP)
{
    static if (s.length == 0) {
        // an empty string is acceptable
        static if (state == EFloatParseState.WAITEXP || state == EFloatParseState.EXPDIG)
            const int parseExponent = result;
        else {
            pragma(msg, "Error: No exponent found in floating-point literal.");
            static assert(0);
        }
    } else static if (state == EFloatParseState.WAITEXP && (s[0]=='e' || s[0]=='E') )
        const int parseExponent = parseExponent!(s[1..$], 0, EFloatParseState.GOTEXPCHAR);
    else static if (state == EFloatParseState.GOTEXPCHAR && s[0]=='-')
        const int parseExponent = -parseExponent!(s[1..$], 0, EFloatParseState.GOTEXPSIGN);
    else static if (state == EFloatParseState.GOTEXPCHAR && s[0]=='+')
        const int parseExponent = parseExponent!(s[1..$], 0, EFloatParseState.GOTEXPSIGN);
    else static if (state == EFloatParseState.EXPDIG && s[0]=='_')
        // embedded underscores are allowed after the first digit
        const int parseExponent = parseExponent!(s[1..$], result, state);
    else static if (isdigit!( (s[0]) ) )
       const int parseExponent = parseExponent!(s[1..$], result*10 + (s[0]-'0'), EFloatParseState.EXPDIG);    
    else {
        pragma(msg, "Error: Invalid characters found in floating-point literal.");
        static assert(0);
    }
}

// parse a %f-style floating-point number, returning the result as a real.
// A minus sign is allowed as the first character.
// Embedded underscores are allowed any time after the first digit.
template parseMantissa(char [] s, EFloatParseState state = EFloatParseState.START, real result=0.0L)
{
    static if (s.length==0) 
        const real parseMantissa = result;
    else static if (state==EFloatParseState.START && s[0]=='-')
        const real parseMantissa = - parseMantissa!(s[1..$], EFloatParseState.GOTSIGN, 0.0L);
    else static if (state==EFloatParseState.WAITDOT && s[0]=='.')
        const real parseMantissa = result + parseMantissa!(s[1..$], EFloatParseState.WAITEXP, 0.0L);
    else static if (state!=EFloatParseState.START  && state!=EFloatParseState.GOTSIGN && s[0]=='_')
        // allow embedded underscores, but not before the first digit
        const real parseMantissa = parseMantissa!(s[1..$], state, result);
    else static if (isdigit!( (s[0]) )) {
        static if (state == EFloatParseState.WAITEXP)
            // fractional part
            const real parseMantissa = result + (s[0]-'0')/10.0L + parseMantissa!(s[1..$], state, 0.0L) /10.0L;
        else
            const real parseMantissa = parseMantissa!(s[1..$], EFloatParseState.WAITDOT, result*10.0L + (s[0]-'0') );
    } else static if (state == EFloatParseState.WAITDOT || state == EFloatParseState.WAITEXP)
            const real parseMantissa = result;
    else {
        pragma(msg, "Error: No digits found in floating-point literal.");
        static assert(0);
    }
}

template parseMantissaConsumed(char [] s, EFloatParseState state = EFloatParseState.START)
{
    static if (s.length == 0)
        const int parseMantissaConsumed = 0;
    else static if (state==EFloatParseState.START && s[0]=='-')
        const int parseMantissaConsumed = 1 + parseMantissaConsumed!(s[1..$], EFloatParseState.GOTSIGN);
    else static if (state==EFloatParseState.WAITDOT && s[0]=='.')
        const int parseMantissaConsumed = 1 + parseMantissaConsumed!(s[1..$], EFloatParseState.WAITEXP);
    else static if (state!=EFloatParseState.START  && state!=EFloatParseState.GOTSIGN && s[0]=='_')
        // allow embedded underscores, but not before the first digit
        const int parseMantissaConsumed = 1 + parseMantissaConsumed!(s[1..$], state);
    else static if (isdigit!( (s[0]) ))
        const int parseMantissaConsumed = 1 + parseMantissaConsumed!(s[1..$],
            (state == EFloatParseState.WAITEXP) ? state : EFloatParseState.WAITDOT );
    else // found first offending character. 
        //static assert(state != EFloatParseState.START && state!= EFloatParseState.GOTSIGN);
        const int parseMantissaConsumed = 0;
}


// accepts %f or %e format.
template atof(char [] s)
{
    const real atof = parseMantissa!(s) * meta.math.pow!(10.0L, 
            parseExponent!(s[parseMantissaConsumed!(s)..$]));
}

// returns number of decimal places in s.
// s must be a valid floating-point literal
template decimalplaces(char [] s, bool gotDot = false)
{
    static if (s.length==0)
        const int decimalplaces = 0;
    else static if ( !gotDot && s[0]=='.')
        const int decimalplaces = decimalplaces!(s[1..$], true);
    else static if (s[0]=='_' || !gotDot) {
        const int decimalplaces = decimalplaces!(s[1..$], gotDot);
    } else {
        static if (isdigit!( (s[0]) ) )
            const int decimalplaces = 1 + decimalplaces!(s[1..$], true);
        else // we've finished
            const int decimalplaces = 0;
    }
}


//------------------------------------------------
// Given a number x, where 0<= x <1,
// returns the first 'maxdigs' digits after the decimal point.
template afterdec(real x, int maxdigs=real.dig)
{
    static if (maxdigs==0 || x==0) const char [] afterdec = "";
  else const char [] afterdec = decimaldigit!(cast(int)(x*10)) ~ afterdec!(x*10-cast(int)(x*10), maxdigs-1);
}

/* *****************************************************
 *  char [] fcvt!(real x)
 *  Convert a real number x to %f format
 */
template fcvt(real x)
{
	static if (x<0) {
		const real fcvt = "-" ~ .fcvt!(-x);
	} else static if (x==cast(long)x) {
		const char [] fcvt = itoa!(cast(long)x);
	} else {
		const char [] fcvt = itoa!(cast(long)x) ~ "." ~ chomp!(afterdec!(x - cast(long)x), '0');
	}
}

template itoaWithSign(long x)
{
  static if (x>=0) const char [] itoaWithSign = "+" ~ itoa!(x);
  else const char [] itoaWithSign = itoa!(x);
}

/* *****************************************************
 * char [] pcvt!(real x)
 * Convert a real number x to %a format, eg 0x1.ABCDp+30
 */
template pcvt(real x)
{
  static if (isnan!(x)) const char [] pcvt = "nan";
  else static if (x<0) const char [] pcvt =  "-" ~ .pcvt!(-x);
  else static if (x==real.infinity) const char [] pcvt = "inf";
  else const char [] pcvt = "0x1." ~ toHexString!(cast(ulong)(0x1000000 *(binaryMantissa!(x)-1.0)) ) ~ "p" ~ itoaWithSign!(binaryExponent!(x));
}

version(testmeta) {


    static assert(parseMantissa!("3.34") == 3.34);
    static assert(parseMantissa!("-548_29.317_1abc") == -548_29.317_1);
    static assert( isPositiveZero!(parseMantissa!("0.0")));
    static assert( isNegativeZero!(parseMantissa!("-0.0")));
    static assert(parseMantissaConsumed!("-31_4.3252e34") == 10);
    static assert(parseMantissaConsumed!("_23e112") == 0);

 static assert( pcvt!(0x1.12345p954L) == "0x1.123450p+954" );
 static assert( fcvt!(12.345) == "12.345" );

 static assert( atoi!("3580abc")==3580);
 static assert( atoi!("-0326")==-326);
 static assert( atoiConsumed!("325827wip")==6);
 static assert( atoiConsumed!("abc")==0);
}