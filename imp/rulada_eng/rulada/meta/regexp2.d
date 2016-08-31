// Compile-time regular expression parser, version 2.0
// Author: Don Clugston, borrowing heavily from the 1.0 parser written by Eric Anderton.
// This version uses mixins for simplicity, flexibility, and high performance.

// Terminology:
// a regex "sequence" is a set of consecutive "term"s, 
// each of which consists of a "naked term", optionally followed by
// a "quantifier" (*,+,?, {m}, {m,} or {m,n}).
// A "naked term" is either a "sequence" or an "atom".

/*
Features currently supported:
   * match previous expression 0 or more times
   + match previous expression 1 or more times
   ? match previous expression 0 or 1 times
   {m,n}  match previous expression between m and n times
   {m,} match previous expression m or more times
   {,n} match previous expression between 0 and m times
   {n} match previous expression exactly n times.
   . match any character
   other characters match themselves
   a|b   match regular expression a or b
   uncaptured grouping via ( )
   ^   start of line
   [abc]  match any character in character class abc
   [^abc] match any character not in character class abc
   @n  match string variables passed into the functions as extra parameters. (this is a non-standard extension).
   
   All matches are lazy, rather than greedy.
   
Planned, but not yet supported:
   $   end of line
   captured grouping
   escape characters
   word matching
   greedy matching
   full diagnostic error messages
  
Possible:
  an optimisation pass, including features such as searching the pattern in reverse order.
  \1..\9 to match previously captured subsequences
  Perl 6 syntax
   
*/

// Points of interest:
// * The parser is able to treat all 'quantifier's in a single mixin function, while still applying
//   optimisations (eg, there's absolutely no difference between {1,} and "+").
// * There is absolutely no parameter passing inside the regexp engine. Even functions which
//   can't be inlined will have very low calling cost.
// * Consequently, the speed is excellent. The main unnecessary operations are the checks to see whether we
//   are at the end of the string.
//   This could be greatly improved by precalculating the minimum length required for a match,
//   at least for subsequences of fixed length.
// * Since each mixin can be given access to any desired runtime or compile-time parameters,
//   the scheme is extremely flexible.

module meta.regexp2;

//---------------------------------------------------------------------
// Part 0 : Functions from the meta library
//---------------------------------------------------------------------

/******************************************************
 *  ulong atoui!(char [] s);
 *
 *  Converts an ASCII string to an uint.
 */
template atoui(char [] s, uint result=0, int indx=0)
{
    static if (s.length==indx)
        const uint atoui = result;
    else static if (s[indx]<'0' || s[indx]>'9')
        const uint atoui = result;
    else 
        const uint atoui = atoui!(s, result * 10 + s[indx]-'0', indx+1);
}

//---------------------------------------------------------------------
// Part I : Functions for parsing a regular expression string literal.
//---------------------------------------------------------------------
// None of these generate any code.

// retuns index of first char in regstr which equals ch, or -1 if not found
// escaped chars are ignored
template unescapedFindFirst(char [] regstr, char ch, int indx=0)
{
    static if (regstr.length<=indx)
        const int unescapedFindFirst = -1; // not found
    else static if (regstr[indx]==ch) const int unescapedFindFirst=indx;
    else static if (regstr[indx]=='\\')
        // if it's escaped, prevent it from matching.
        const int unescapedunescapedFindFirst = unescapedFindFirst!(regstr, ch, indx+2);
    else const int unescapedFindFirst = unescapedFindFirst!(regstr, ch, indx+1);
}

// Returns the number of chars at the start of regstr which are made up by
// a repetition expression (+, *, ?, {,} )
template quantifierConsumed(char [] regstr)
{
    static if (regstr.length==0) const int quantifierConsumed = 0;
    else static if (regstr[0]=='+' || regstr[0]=='*' || regstr[0]=='?') const int quantifierConsumed = 1;
    else static if (regstr[0]=='{') {
        static if (unescapedFindFirst!(regstr, '}')==-1) {
            pragma(msg, "Error: unmatched { in regular expression");
            static assert(0);
        } else const int quantifierConsumed = 1 + unescapedFindFirst!(regstr, '}');
    } else const int quantifierConsumed = 0;
}

// The minimum allowable number of repetitions for this quantifier
template quantifierMin(char [] regstr)
{
    static if (regstr[0]=='*' || regstr[0]=='?') const uint quantifierMin = 0;
    else static if (regstr[0]=='+') const uint quantifierMin = 1;
    else { 
        static assert (regstr[0]=='{') ;
        const uint quantifierMin = atoui!(regstr[1..$]);
     }
}

// The maximum allowable number of repetitions for this quantifier
template quantifierMax(char [] regstr)
{
    static if (regstr[0]=='*' || regstr[0]=='+') const uint quantifierMax = uint.max;
    else static if (regstr[0]=='?') const uint quantifierMax = 1;
    else static if (regstr[0]=='{') {
        static if (unescapedFindFirst!(regstr, ',')==-1) // "{n}"
            const uint quantifierMax = quantifierMin!(regstr);
        else static if (regstr[$-2]==',') // "{n,}"
            const uint quantifierMax = uint.max;
        else // "{n,m}" 
            const uint quantifierMax = atoui!(regstr[ 1+unescapedFindFirst!(regstr, ',') .. $]);
    } else {
        pragma(msg, "Error: unsupported quantifier " ~ regstr);
        static assert(0);
    }
}

// find the index of the first |, or -1 if not found.
// ignores escaped items, and anything in parentheses.
template findUnion(char [] regstr, int indx=0, int numopenparens=0)
{
    static if (indx>=regstr.length)
        const int findUnion = -1;
    else static if (numopenparens==0 && regstr[indx]=='|')
        const int findUnion = indx;
    else static if (regstr[indx]==')')
        const int findUnion = findUnion!(regstr, indx+1, numopenparens-1);
    else static if (regstr[indx]=='(')
        const int findUnion = findUnion!(regstr, indx+1, numopenparens+1);
    else static if (regstr[indx]=='\\') // skip the escaped character
        const int findUnion = findUnion!(regstr, indx+2, numopenparens);
    else 
        const int findUnion = findUnion!(regstr, indx+1, numopenparens);
}

// keeps going until the number of ) parens equals the number of ( parens.
// All escaped characters are ignored.
// BUG: what about inside [-] ?
template parenConsumed(char [] regstr, int numopenparens=0)
{
    static if (regstr.length==0) {
        pragma(msg, "Unmatched parenthesis");
        static assert(0);
    } else static if (regstr[0]==')') {
        static if (numopenparens==1) const int parenConsumed=1; // finished!
        else const int parenConsumed = 1 + parenConsumed!(regstr[1..$], numopenparens-1);
    } else static if (regstr[0]=='(') {
        const int parenConsumed = 1 + parenConsumed!(regstr[1..$], numopenparens+1);
    } else static if (regstr[0]=='\\' && regstr.length>1)
        // ignore \(, \).
        const int parenConsumed = 2 + parenConsumed!(regstr[2..$], numopenparens);
    else 
        const int parenConsumed = 1 + parenConsumed!(regstr[1..$], numopenparens);    
}

// the naked term, with no quantifier. Either an atom, or a subsequence.
template atomConsumed(char [] regstr)
{
    static if (regstr[0]=='(') const int atomConsumed = parenConsumed!(regstr);
    else static if (regstr[0]=='[') const int atomConsumed = 1 + unescapedFindFirst!(regstr, ']');
    else static if (regstr[0]=='\\') { // escape character
        static if (regstr.length>0) {
            const int atomConsumed=2;
        } else  {
            pragma(msg, "Error: Regexp must not end with \\");
            static assert(0);
        }
    } else static if (regstr[0]=='@')  { // NONSTANDARD: referenced parameter
        const int atomConsumed=2;
    } else const int atomConsumed=1; // match single char
}

// parses a term from the front of regstr (which must not be empty).
// consisting of an atom, optionally followed by a quantifier.
template termConsumed(char [] regstr)
{
    const int termConsumed = atomConsumed!(regstr) + quantifierConsumed!(regstr[atomConsumed!(regstr)..$]);
}

//---------------------------------------------------------------------
// Part II: mixins which generate the final code
//---------------------------------------------------------------------
// Unlike most regexp engines, which turn the pattern string into a table-based state machine,
// this one generates a binary tree of nested functions. Each node in the tree corresponds to
// a D template, and is generated as a mixin.

// At compile time, each mixin is passed a subset of a regexp string.
// It generates a member function bool fn(), which updates a pointer p,
// and returns true if a match was found.

// Each mixin has access to the following values:
// At compile time: 
//     fullpattern -- the complete, unparsed regular expression string
// At run time:
//     searchstr (read only) -- the string being searched
//     p --- the first character in searchstr which is not yet matched.
//     param[0..8] -- the quasi-static parameter strings @1..@9 to match.

// Additional variables or constants can be added as desired.

// Most of the complexity in the regexp engine comes from the optional quantifiers.
// In general, they can only determine how far to match by testing if the entire remainder
// of the pattern can be matched.
//
// Each mixin also recieves a template alias 'next'. This has a member bool fn() which
// returns true if the remainder of the regexp match is successful.
// All regexps must ensure that next.fn is called.

// Note that unless p is reset to 0, it will automatically behave as a global search,
// continuing from the last place it left off.

template parseRegexp(char [] pattern)
{
    mixin alwaysTrue!() endSequence;
    mixin regSequence!(pattern, endSequence) allseq;
    alias allseq.fn fn;
}

template alwaysTrue() // used to mark the end of a sequence
{
   bool fn () { return true; }
}

// regstr is a sequence of productions, possibly containing a union
template regSequence(char [] regstr, alias next)
{
    static if (findUnion!(regstr)==-1) {
        // No unions to worry about
        mixin regNoUnions!(regstr, next);
    } else {
        bool fn() {
            // Both halves of the union have the same next, inherited from the parent
            mixin regSequence!(regstr[0..findUnion!(regstr)], next) a;
            mixin regSequence!(regstr[findUnion!(regstr)+1..$], next) b;
            int oldp = p;
            if (a.fn()) return true;
            p = oldp;
            return b.fn();
        }
    }
}

// regstr is a sequence of terms, all of which must be matched
// Does not contain any unions
template regNoUnions(char [] regstr, alias next)
{
    static if (regstr.length == termConsumed!(regstr)) {
        // there's only a single item (possibly including a quantifier)
        mixin regTerm!(regstr, next);
    } else {
        bool fn() {            
            mixin regSequence!(regstr[termConsumed!(regstr)..$], next) second;
            mixin regTerm!(regstr[0..termConsumed!(regstr)], second) first;
            return first.fn();
        }
    }
}

// the term without a quantifier. Here we deal with embedded subsequences.
template regSingleTerm(char [] regstr, alias next)
{
        static if (regstr[0]=='(') {
            // A sequence always calls next.
            mixin regSequence!(regstr[1..$-1], next);
        } else  {
            // A simple atom doesn't call next, so we need to do it here.
            bool fn() {
                mixin regAtom!(regstr) a;
                return a.fn() && next.fn();
            }
        }
}

// Evaluate one term (without quantifier).
// This helper class has two purposes:
// (1) to restore the 'p' pointer when we return.
// (2) ensure that at least one character was consumed
template regSequenceDontUpdateP(char [] regstr)
{
    bool fn() {
        mixin regSequence!(regstr, endSequence) x;
        // It's only a successful match if _something_ was consumed
        if (p==theinitialp) return false;        
        int oldp = p;
        if (!x.fn()) return false;
        p = oldp;
        return true;
    }
}

//  Calls the naked term twice, but only updates 'p' after the first one.
// Evaluate the term, knowing that what comes after will be the same as this.
template regTermTwice(char [] regstr)
{
    static if (regstr[0]=='(') {
        bool fn()
        {
            // While evaluating this first sequence, if this is a sequence
            // that potentially has zero length (ie, everything is a *, ? or {m,} term),
            // each term should attempt to consume at least one character if possible.
            int theinitialp = p;
            mixin regSequenceDontUpdateP!(regstr[1..t-1]) suddendeath;
            mixin regSequence!(regstr[1..t-1], suddendeath) a;
            return a.fn();
       }
    } else {
            bool fn() {
                // It's easy with atoms, because we know they always eat something.
                // BUG: Maybe this will fail when null @n strings are passed in?                
                mixin regAtom!(regstr) a;
                return a.fn();
            }    
    }
}

// the atom, optionally followed by a quantifier.
// Here we deal with all kinds of repitition,
// but we make different optimisations depending on the allowable repeats.
template regTerm(char [] regstr, alias next)
{
    static if (atomConsumed!(regstr)==regstr.length) {
            // there is no quantifier, just use the naked term
       mixin regSingleTerm!(regstr, next);
    } else {
        bool fn() {
            const int t = atomConsumed!(regstr);
            const uint repmin = quantifierMin!(regstr[t..$]);
            const uint repmax = quantifierMax!(regstr[t..$]);
            
            // HORRENDOUSLY inefficient! In some cases, we generate the quantified term THREE TIMES!
            // The first one contains the rest of the search tree.
            // This is used when we think we can do (atom).(next) for an early exit
            mixin regTerm!(regstr[0..t], next) atomAndNext;

            debug writefln(fullpattern, " Quantifier ",regstr ,  " starting at ", searchstr[p..$]);
            
            static if (repmin == 0 && repmax == 1) { 
                // "?", or "{0,1}". Worth optimising seperately
                int oldp = p;
                if (next.fn()) { return true; }
                p = oldp;
                return atomAndNext.fn();
            } else {
                // Here's where we generate the redundant term.
                // If we can't do (atom).(next), we must be able to do
                // (atom).(atom) to stay in the game.                       
                  mixin regTermTwice!(regstr[0..t]) atomonly;

                static if (repmin==0 && repmax == uint.max) {
                    // optimise for "*", "{0,}"
                    int oldp=p;
                    if (next.fn()) return true; // We can finish right now.
                    p=oldp;
                    do {
                      // Can we do (atom).(next) ?
                      oldp = p;
                      if (atomAndNext.fn()) { return true; }
                      p = oldp;
                      // We need to do (atom).(atom) to have any chance of continuing.                  
                      // also, it must have consumed at least one character, or there is no hope.                 
                    } while (atomonly.fn() && p != oldp);
                    return false;
                } else { // "+", or "{m,n}"
                    int numreps=0; // how many repeats have we found?
                    int oldp;
                    do {
                        oldp = p;
                        numreps++;
                        if (numreps>=repmin && atomAndNext.fn()) return true;
                        p = oldp;
                        static if (repmax<uint.max) {
                            // optimise for "+", "{n,}"
                            if (numreps == repmax) return false;
                        }
                     } while (atomonly.fn() && p!=oldp);
                    return false;
               }
            }
        }
    }
}

// generate a parser for an atom
// IN: regstr is a valid atom, without a repeat
// OUT: if atom is matched, return true, and update p.
//      if atom is not matched, return false, and leave p unchanged.
template regAtom(char [] regstr)
{
    static if (regstr[0]=='[') {
        static if (regstr[1]=='^')
        {
            bool fn() { // inverse character class            
                return (p<searchstr.length && !charMatches!(regstr[2..$-1])(searchstr[p++]));
            }
        } else {
            bool fn() { // character class
                return (p<searchstr.length && charMatches!(regstr[1..$-1])(searchstr[p++]));
            }
        }            
    } else static if (regstr[0]=='.') { // match any
        bool fn() {
            if (p==searchstr.length) return false;
            p++;
            return true;
        }
    } else static if (regstr[0]=='@')  { // NONSTANDARD: referenced parameter
        mixin regParameter!(atoui!(regstr[1..$])-1);
    } else static if (regstr[0]=='^') { // start of line
        bool fn() {
            return (p==0 || searchstr[p-1]=='\n');
        }    
    } else {
        // match single character
        bool fn() {
            if (p==searchstr.length || searchstr[p]!=regstr[0]) return false;
            p++;
            return true;
        }
    }
}

// match a variable string, which will be passed as a parameter.
template regParameter(int parmnum)
{
    bool fn() {
        if (p + param[parmnum].length > searchstr.length) return false;
        if (searchstr[p..p+param[parmnum].length] != param[parmnum]) return false;
        p+=param[parmnum].length;
        return true;
    }
}

//"a-zA-Z0-9_"

// return true if char ch is matched by the character class regstr.
template charMatches(char [] regstr)
{
    bool charMatches(char ch) {
        static if (regstr.length==0) return false;
        else static if (regstr.length>=3 && regstr[1]=='-') {
            return (ch>=regstr[0] && ch<=regstr[2]) || charMatches!(regstr[3..$])(ch);
        } else return (ch==regstr[0]) || charMatches!(regstr[1..$])(ch);
    }
}

//---------------------------------------------------------------------
// Part III: the public interface of the regexp engine
//---------------------------------------------------------------------

// Does the regexp match the pattern?
template test(char [] fullpattern)
{
    bool test(char [] searchstr, char [][] param...) {
        int p = 0; // start at the beginning of the string
        mixin parseRegexp!(fullpattern) engine;
        return engine.fn();
    }
}

/// Return first substring which matches the pattern.
/// Note that some patterns will return an empty string as a valid result.
template search(char [] fullpattern)
{
    char [] search(char [] searchstr, char [][] param...) {
        int p; // next index to test
        mixin parseRegexp!(fullpattern) engine;
        for (int x=0; x<searchstr.length; ++x) {
            p=x;
            if (engine.fn()) return searchstr[x..p];
        }
        return "<No match>"; // no match
    }
}

//---------------------------------------------------------------------
//                         EXAMPLE
//---------------------------------------------------------------------

import std.stdio;

void main()
{
writefln("BEGINNING UNIT TESTS\n");
assert(search!("ab")("aaab")=="ab"); 
assert(search!("a*b")("aaab")=="aaab"); 
assert(search!("a*(b)")("aaab")=="aaab"); 
assert(search!("((a*b))")("aaab")=="aaab"); 
assert(search!("(a*)b")("aaab")=="aaab"); 
assert(search!("(b*a*)*b")("aaab")=="aaab"); 
assert(search!("b+cd")("acdbbcabbcdaaab")=="bbcd");
assert(search!("b?cd")("abcacbacdb")=="cd");
assert(search!("(ab)?abc")("aababcab")=="ababc");
assert(search!("(ab)*abc")("aababcab")=="ababc");
assert(search!("((a)*|xyz)b")("aaab")=="aaab"); 
assert(search!("(ab)*(abb)")("bababb")=="ababb"); 
assert(search!("e?(ab)*b+")("eaaababbbbaac")=="ababb");
assert(search!("(ab*)*c")("bbbababbaaabaaaabbbbc") == "ababbaaabaaaabbbbc");
char [] quasistatic="m";
assert(search!("(@1.*@1)")("they said D can't do metaprogramming?", quasistatic)=="metaprogram");
assert(search!("[h-za]*g")("metaprogramming")=="taprog");
assert(search!("(a*)*b")("cacaaab")=="aaab");
assert(search!("(a*b*)*c")("dababdaabababbaaabbbcab")=="aabababbaaabbbc");
assert(search!("((a*b*)|da)*b")("fasdaaab")=="daaab");

char [] qq;
writefln("=========");

qq = search!("((a*b*)|da)*b")("fasdaaab");
writefln("Result: ----",qq, "---");
writefln("=========");

}

//-------------------------------------------------------------------------------
/+

// NOT CURRENTLY USED

// Finds the number of instances of 'ch' in str which aren't preceded by a backslash
// ch must not be a backslash.
template unescapedCount(char [] str, char ch)
{
    static if (str.length==0) const int unescapedCount = 0;
    else static if (str[0]=='\\' && str.length>1) const int unescapedCount = unescapedCount!(str[2..$], ch);
    else static if (str[0]==ch) const int unescapedCount = 1 + unescapedCount!(str[1..$], ch);
    else const int unescapedCount = unescapedCount!(str[1..$], ch);
}

+/

//-------------
// unit tests
//-------------
version (testmeta) {
    static assert(quantifierConsumed!("{456}345")==5);
    static assert(parenConsumed!("(45(6)4)5")==8);
    static assert(parenConsumed!(`(45\(6)45`)==7);
}
