module amigos.dk.utils;

import std.c;
import std.string;
import std.conv;

string join_with(T)(T[] xs, string sep = " ")
{
  if(xs.length == 0) return "";
  string s;
  foreach(x; xs)
    static if(is(T==string))
      {
	s ~=  x ~ sep;
      }
    else
      s ~= .toString(x) ~ sep;
  return s[0..$-sep.length];
}

int safeToInt(char* pc)
{
  string s;
  int[] a;
  foreach(i; a[0..strlen(pc)])
    s~=[pc[i]];
  try
    {
      return toInt(s);
    }
  catch(Exception e)
    {
      return -1;
    }
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
