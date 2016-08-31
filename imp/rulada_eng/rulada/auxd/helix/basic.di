// D import file generated from 'basic.d'
module auxd.helix.basic;
import std.math;
import auxd.helix.config;
bool equal(real x, real y, int relprec = defrelprec, int absprec = defabsprec);
template EqualityByNorm(T)
{
bool equal(T a, T b, int relprec = defrelprec, int absprec = defabsprec)
{
return .equal((b - a).normSquare,0L,relprec,absprec);
}
}
bool less(real a, real b, int relprec = defrelprec, int absprec = defabsprec)
{
return a < b && !equal(a,b,relprec,absprec);
}
bool greater(real a, real b, int relprec = defrelprec, int absprec = defabsprec)
{
return a > b && !equal(a,b,relprec,absprec);
}
real lerp(real a, real b, real t)
{
return a * (1 - t) + b * t;
}
template Lerp(T)
{
T lerp(T a, T b, real t)
{
return a * (1 - t) + b * t;
}
}
template MinMax(T)
{
T max(T a, T b)
{
return a > b ? a : b;
}
T min(T a, T b)
{
return a < b ? a : b;
}
}
alias MinMax!(bool).min min;
alias MinMax!(bool).max max;
alias MinMax!(byte).min min;
alias MinMax!(byte).max max;
alias MinMax!(ubyte).min min;
alias MinMax!(ubyte).max max;
alias MinMax!(short).min min;
alias MinMax!(short).max max;
alias MinMax!(ushort).min min;
alias MinMax!(ushort).max max;
alias MinMax!(int).min min;
alias MinMax!(int).max max;
alias MinMax!(uint).min min;
alias MinMax!(uint).max max;
alias MinMax!(long).min min;
alias MinMax!(long).max max;
alias MinMax!(ulong).min min;
alias MinMax!(ulong).max max;
alias MinMax!(float).min min;
alias MinMax!(float).max max;
alias MinMax!(double).min min;
alias MinMax!(double).max max;
alias MinMax!(real).min min;
alias MinMax!(real).max max;
template Clamp(T)
{
T clampBelow(ref T x, T inf)
{
return x = max(x,inf);
}
T clampAbove(ref T x, T sup)
{
return x = min(x,sup);
}
T clamp(ref T x, T inf, T sup)
{
clampBelow(x,inf);
return clampAbove(x,sup);
}
}
alias Clamp!(bool).clampBelow clampBelow;
alias Clamp!(bool).clampAbove clampAbove;
alias Clamp!(bool).clamp clamp;
alias Clamp!(byte).clampBelow clampBelow;
alias Clamp!(byte).clampAbove clampAbove;
alias Clamp!(byte).clamp clamp;
alias Clamp!(ubyte).clampBelow clampBelow;
alias Clamp!(ubyte).clampAbove clampAbove;
alias Clamp!(ubyte).clamp clamp;
alias Clamp!(short).clampBelow clampBelow;
alias Clamp!(short).clampAbove clampAbove;
alias Clamp!(short).clamp clamp;
alias Clamp!(ushort).clampBelow clampBelow;
alias Clamp!(ushort).clampAbove clampAbove;
alias Clamp!(ushort).clamp clamp;
alias Clamp!(int).clampBelow clampBelow;
alias Clamp!(int).clampAbove clampAbove;
alias Clamp!(int).clamp clamp;
alias Clamp!(uint).clampBelow clampBelow;
alias Clamp!(uint).clampAbove clampAbove;
alias Clamp!(uint).clamp clamp;
alias Clamp!(long).clampBelow clampBelow;
alias Clamp!(long).clampAbove clampAbove;
alias Clamp!(long).clamp clamp;
alias Clamp!(ulong).clampBelow clampBelow;
alias Clamp!(ulong).clampAbove clampAbove;
alias Clamp!(ulong).clamp clamp;
alias Clamp!(float).clampBelow clampBelow;
alias Clamp!(float).clampAbove clampAbove;
alias Clamp!(float).clamp clamp;
alias Clamp!(double).clampBelow clampBelow;
alias Clamp!(double).clampAbove clampAbove;
alias Clamp!(double).clamp clamp;
alias Clamp!(real).clampBelow clampBelow;
alias Clamp!(real).clampAbove clampAbove;
alias Clamp!(real).clamp clamp;
template SimpleSwap(T)
{
void swap(ref T a, ref T b)
{
T temp = a;
a = b;
b = temp;
}
}
alias SimpleSwap!(bool).swap swap;
alias SimpleSwap!(byte).swap swap;
alias SimpleSwap!(ubyte).swap swap;
alias SimpleSwap!(short).swap swap;
alias SimpleSwap!(ushort).swap swap;
alias SimpleSwap!(int).swap swap;
alias SimpleSwap!(uint).swap swap;
alias SimpleSwap!(long).swap swap;
alias SimpleSwap!(ulong).swap swap;
alias SimpleSwap!(float).swap swap;
alias SimpleSwap!(double).swap swap;
alias SimpleSwap!(real).swap swap;
