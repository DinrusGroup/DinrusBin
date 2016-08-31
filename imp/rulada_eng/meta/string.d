
module meta.string;

// Returns str[] sans trailing delimiter[], if any.
// Unlike std.string.chomp, it removes all instances of the delimiter.
template chomp(char [] str, char delimiter)
{
  static if (str.length==0) const char[] chomp=str;
  else static if (str[str.length - 1]==delimiter) 
     const char [] chomp = chomp!( str[0..$-1], delimiter);
  else const char [] chomp = str;
}

// int find!(char [] str, char c);
// Find first occurrence of c in string str.
//
// Returns:
//  Index in s where c is found, -1 if not found. 
template find(char[] str, char c, int n=0)
{
  static if (str.length==n) const int find = -1;
  else static if( c==str[n]) const int find = n;
  else const int find = find!(str, c, n + 1);
}

// int rfind!(char [] str, char c);
// Find last occurrence of c in string str.
//
// Returns:
//   Index in s where c is found, -1 if not found. 
template rfind(char[] str, char c, int n = 0)
{
  static if (str.length==n) const int rfind = -1;
  else static if( c==str[str.length - n - 1]) const int rfind = str.length - n - 1;
  else const int rfind = rfind!(str, c, n + 1);
}

//  char [] repeat!(char [] str, uint n)
//
// Return a string that consists of s[] repeated n times.
template repeat(char [] str, uint n)
{
   static if (n==0) const char [] repeat="";
   else static if (n==1) const char [] repeat = str;
   else const char [] repeat = str ~ repeat!(str, n-1);
}


version(testmeta) {
 static assert( 11 == find!("it's in there somewhere!", 'r'));
 static assert( -1 == find!("but it's not in this one", 'q'));
 static assert( -1 == rfind!("not in here either", 'z'));
 static assert( 4 == rfind!("but this is ok", 't'));
 static assert(repeat!("abc", 4) == "abcabcabcabc");
}