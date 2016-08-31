/+
	Copyright (c) 2005 Eric Anderton
        
	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or
	sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
+/
/**
	Compile-Time regular expression engine.
	
	To use, simply call regexMatch!() and use the function pointer to perform matches 
	for that expression.  The match routine returns a set of strings for all matches;
	char[][].
	
	--------------------
	auto exp = &regexMatch!("[a-z]*\s*\w*");
	writefln("matches: %s",exp("hello    world");
	--------------------
	
	The compile-time regex parser generates a series of functions that match specific 
	portions of your expression, which make up the runtime expression engine.  The
	resulting generated code set and call tree are absolutely minimalistic and match
	the original expression's logic with as few productions as possible.
		
	Currently Supported
	- character classes (including inverse char classes via [^...])
	- match one or more (+)
	- match zero or more (*)
	- match zero or one (?)
	- escape sequences
	- whitespace matching (ws chars are treated literally right now)
	- {n} and {n,m} predicates
	- ^ at the start of an expression
	- $ at the end of an expression
	- grouping via ()
	- most standard escape sequences
	- union operator (outside of parens)

	Planned
	- {,m} and {n,} predicates
	- different match operations other than first match
	- move pipe to low parsing precedence rather than highest (support inside parens)
	
	Possible?!
	- \d (decimal)
	- \o (octal)
	- multi-line matching semantics (like ^ and $ matching \n and such)
	- \b word boundary
	- \B non word boundary
	- lazy matching (current implementation is greedy)
	- replacement expressions
	- named groups
*/
module meta.regex;

import meta.conv;
//import meta.strhacks;
import meta.string;

import meta.regexPredicate;

template getAt(char[] str,uint index){
	const char getAt = str[index];
}

template first(char[] str){
	const char first = str[0];
}

template last(char[] str){
	const char last = getAt!(str,strlen!(str)-1);
}

template isSpecial(char[] pattern){
	static if(
		pattern[0] == '*' ||
		pattern[0] == '+' ||
		pattern[0] == '?' ||
		pattern[0] == '.' ||
		pattern[0] == '[' ||
		pattern[0] == '{' ||
		pattern[0] == '(' ||
		//pattern[0] == ')' ||
		//pattern[0] == '}' ||
		//pattern[0] == ']' ||
		pattern[0] == '$' ||
		pattern[0] == '^' ||
		pattern[0] == '\\' 	
	){
		const bit isSpecial = true;
	}
	else{
		const bit isSpecial = false;
	}
}

template parseTextToken(char[] pattern){
	static if(strlen!(pattern) > 0){
		static if(isSpecial!(pattern)){
			const char[] parseTextToken="";
		}
		else{
			const char[] parseTextToken = slice!(pattern,0,1) ~ .parseTextToken!(slice!(pattern,1,strlen!(pattern)));
		}
	}	
	else{
		const char[] parseTextToken="";
	}			
}

/// parses up to and including terminator.  Returns everything up to terminator.
template parseUntil(char[] pattern,char terminator,bit fuzzy=false){
	static if(strlen!(pattern) > 0){
		static if(pattern[0] == '\\'){
			static if(strlen!(pattern) > 1){
				const char[] nextSlice = sliceheadoff!(pattern,2);
				alias .parseUntil!(nextSlice,terminator,fuzzy) next;
				const char[] token = slice!(pattern,0,2) ~ next.token;	
				const uint consumed = next.consumed+2;
			}
			else{
				pragma(msg,"Error: exptected character to follow \\");
				static assert(false);
			}
		}
		else static if(pattern[0] == terminator){
			const char[] token="";
			const uint consumed = 1;
		}
		else{
			const char[] nextSlice = sliceheadoff!(pattern,1);
			alias .parseUntil!(nextSlice,terminator,fuzzy) next;
			const char[] token = slice!(pattern,0,1) ~ next.token;
			const uint consumed = next.consumed+1;
		}
	}
	else static if(fuzzy){
		const char[] token = "";
		const uint consumed = 0;
	}
	else{
		pragma(msg,"Error: exptected " ~ makechar!(terminator) ~ " to terminate group expression");
		static assert(false);
	}			
}

// shim for parseUint
template charToUint(char[] value){
	const uint charToUint = value[0];
}

template parseUint(char[] pattern,uint prev=0){
	static if(strlen!(pattern) > 0){
		static if(pattern[0] >= '0' && pattern[0] <= '9'){
			const uint thisValue = (charToUint!(pattern)-'0') + prev*10;
			alias .parseUint!(sliceheadoff!(pattern,1),thisValue) next;
			const uint consumed = next.consumed+1;
			const uint value = next.value;
		}
		else{
			const uint consumed = 0;
			const uint value = prev;
		}
	}
	else{
		const uint consumed = 0;
		const uint value = prev;
	}			
}

template regexCompileCharClassRecurse(alias termFn,char[] pattern){
	static if(strlen!(pattern) > 0){
		static if(pattern[0] != ']'){
			debug pragma(msg,"REMAINING: " ~ pattern);
			
			alias regexCompileCharClass2!(pattern) next;
			alias testOr!(termFn,next.fn,pattern) fn;
			const uint consumed = next.consumed;
		}
		else{
			alias termFn fn;
			const uint consumed = 0;
		}
	}
	else{
		alias termFn fn;
		const uint consumed = 0;
	}
	debug pragma(msg,"regexCompileCharClassRecurse consumed:" ~ itoa!(consumed));
}

template regexCompileCharClass2(char[] pattern){
	static if(strlen!(pattern) > 0){
		static if(pattern[0] == '\\'){
			static if(strlen!(pattern) == 1){
				pragma(msg,"Error: expected character following \\ in character class");
				static assert(false);
			}
			else static if(pattern[1] == ']'){
				alias testChar!("]") fn;
				const uint thisConsumed = 2;
			}
			else static if(pattern[1] == '^'){
				alias testChar!("^") fn;
				const uint thisConsumed = 2;
			}
			else static if(pattern[1] == '-'){
				alias testChar!("-") fn;
				const uint thisConsumed = 2;
			}
			else{
				alias regexCompileEscape!(sliceheadoff!(pattern,1)) term;
				alias term.fn termFn;
				const uint thisConsumed = term.consumed+1;
			}
			
			const char[] remaining = slice!(pattern,thisConsumed,strlen!(pattern));
		}
		else{
			//NOTE: read ahead up to two chars for a range expression.
			//NOTE: should probably be refactored off to something else
			static if(strlen!(pattern) > 1){
				static if(pattern[1] == '-'){
					static if(strlen!(pattern) > 2){
						alias testRange!(slice!(pattern,0,1),slice!(pattern,2,3)) termFn;
						const uint thisConsumed = 3;
						const char[] remaining = slice!(pattern,3,strlen!(pattern));
					}
					else{ // length is 2
						pragma(msg,"Error: expected character following '-' in character class");
						static assert(false);	
					}
				}
				else{ // not '-'
					alias testChar!(slice!(pattern,0,1)) termFn;
					const uint thisConsumed = 1;
					const char[] remaining = slice!(pattern,1,strlen!(pattern));						
				}
			}
			else{
				alias testChar!(slice!(pattern,0,1)) termFn;
				const uint thisConsumed = 1;
				const char[] remaining = slice!(pattern,1,strlen!(pattern));
			}
		}
		alias regexCompileCharClassRecurse!(termFn,remaining) recurse;
		alias recurse.fn fn;
		const uint consumed = recurse.consumed + thisConsumed;
	}
	else{
		//TODO: trigger error
		alias testEmpty!() fn;
		const uint consumed = 0;
	}
	debug pragma(msg,"regexCompileCharClass2 consumed:" ~ itoa!(consumed));
}

template regexCompileCharClass(char[] pattern){	
	static if(strlen!(pattern) > 0){
		static if(pattern[0] == ']'){
			alias testEmpty!() fn;
			const uint consumed = 0;
		}
		else static if(pattern[0] == '^'){
			pragma(msg,"foobar");
			alias regexCompileCharClass2!(sliceheadoff!(pattern,1)) charClass;
			alias testCharInverse!(charClass.fn,pattern) inverseCharClass;
			alias inverseCharClass fn;
			const uint consumed = charClass.consumed + 1;
		}
		else{
			alias regexCompileCharClass2!(pattern) charClass;
			alias charClass.fn fn;
			const uint consumed = charClass.consumed;
		}
	}
	else{
		pragma(msg,"Error: expected closing ']' for character class");
		static assert(false);	
	}
}

// shim to assist with {n,m} notation
template validateMaxToken(uint tokenLength,uint consumed,uint value){
	static if(consumed == 0 || consumed < tokenLength){
		pragma(msg,"Error: expected expression in the format of {n,m}");
		static assert(false);
	}
	const uint max = value;
}

// shim to assist with {n,m} notation
template parseMaxPredicate(uint min,char[] token){
	static if(strlen!(token) > 0){
		static if(getAt!(token,0) == ',' && strlen!(token) > 1){
			alias parseUint!(sliceheadoff!(token,1)) maxToken;
			const uint max = validateMaxToken!(strlen!(token),maxToken.consumed+1,maxToken.value).max;
		}
		else{
			pragma(msg,"Error: expected expression in the format of {n,m}");
			static assert(false);
		}
	}
	else{
		const uint max = min;
	}
}

template regexCompilePredicate(alias test,char[] token,char[] pattern){
	static if(strlen!(pattern) > 0){
		static if(pattern[0] == '*'){
			alias testZeroOrMore!(test,token) fn;
			const uint consumed = 1;
		}
		else static if(pattern[0] == '+'){
			alias testOneOrMore!(test,token) fn;
			const uint consumed = 1;
		}
		else static if(pattern[0] == '?'){
			alias testZeroOrMore!(test,token) fn;
			const uint consumed = 1;
		}
		else static if(pattern[0] == '{'){
			const char[] token = parseUntil!(sliceheadoff!(pattern,1),'}').token;
			static if(strlen!(token) == 0){
				pragma(msg,"Error: expected number inside {n} expression");
				static assert(false);
			}
			
			alias parseUint!(token) minToken;
			const uint min = minToken.value;	
			uint max = parseMaxPredicate!(min,sliceheadoff!(token,minToken.consumed)).max;			

			alias testTimes!(min,max,test,token) fn;
			const uint consumed = strlen!(token)+2;
			debug pragma(msg,"consumed: " ~ itoa!(consumed));
		}
		else{
			alias test fn;
			const uint consumed = 0;			
		}
	}
	else{
		alias test fn;
		const uint consumed = 0;
	}	
}

template regexCompileEscape(char[] pattern){
	static if(strlen!(pattern) > 0){
		static if(pattern[0] == '\\'){
			alias testChar!("\\") fn;
		}		
		//TODO: word boundary (/b) and non-word boundary (/B)
		//TODO: /d (decimal) and /o (octal)?
		else static if(pattern[0] == 'd'){
			// numeric chars
			alias testRange!("0","9") fn;
		}
		else static if(pattern[0] == 'D'){
			// non numeric chars
			alias testCharInverse!(testRange!("0","9"),pattern) fn;
		}
		else static if(pattern[0] == 'f'){
			// form feed
			alias testChar!("\f") fn;
		}		
		else static if(pattern[0] == 'n'){
			// newline
			alias testChar!("\n") fn;
		}
		else static if(pattern[0] == 'r'){
			// carriage return
			alias testChar!("\r") fn;
		}
		else static if(pattern[0] == 's'){
			// whitespace char
			alias testRange!("\x00","\x20") fn;
		}
		else static if(pattern[0] == 'S'){
			//non-whitespace char
			alias testCharInverse!(testRange!("\x00","\x20"),pattern) fn;
		}
		else static if(pattern[0] == 't'){
			//tab	
			alias testChar!("\t") fn;
		}
		else static if(pattern[0] == 'v'){
			//vertical tab
			alias testChar!("\v") fn;
		}
		else static if(pattern[0] == 'w'){
			//word char
			alias testWordChar!() fn;
		}
		else static if(pattern[0] == 'W'){
			alias testCharInverse!(testWordChar!()) fn;
		}
		else{
			alias testChar!(slice!(pattern,0,1)) fn;
		}
		const uint consumed = 1;
	}
	else{
		pragma(msg,"Error: expected char following '\\'");
		static assert(false);
	}
}

/// recursive portion of regexCompile - shim to work around alias scope issue
template regexCompileRecurse(alias term,char[] pattern){
	static if(strlen!(pattern) > 0){
		debug pragma(msg,"REMAINING: " ~ pattern);
		
		alias regexCompile!(pattern) next;
		alias testUnion!(term.fn,next.fn,pattern) fn;
	}
	else{
		alias term.fn fn;
	}
}

/// recursive descent parser for regex strings
//TODO: install pipe operator here and give regexCompile the 'consumed' protocol to make
// partial passes of the pattern possible
template regexCompile(char[] pattern){
	debug pragma(msg,"PATTERN: " ~ pattern);
	static if(strlen!(pattern) > 0){
		static if(pattern[0] == '['){
			const char[] charClassToken = parseUntil!(slice!(pattern,1,strlen!(pattern)),']').token;			
			alias regexCompileCharClass!(charClassToken) charClass;
			const char[] token = slice!(pattern,0,charClass.consumed+2);
			const char[] next = slice!(pattern,charClass.consumed+2,strlen!(pattern));
			alias charClass.fn test;
		}
		else static if(pattern[0] == '('){
			const char[] groupToken = parseUntil!(slice!(pattern,1,strlen!(pattern)),')').token;
			alias regexCompile!(groupToken) groupExpression;
			const char[] token = slice!(pattern,0,strlen!(groupToken)+2);
			const char[] next = slice!(pattern,strlen!(groupToken)+2,strlen!(pattern)); 
			alias groupExpression.fn test;
		}
		else static if(pattern[0] == '.'){
			const char[] token = ".";
			const char[] next = sliceheadoff!(pattern,1);
			alias testAny!() test;
		}
		else static if(pattern[0] == '\\'){
			alias regexCompileEscape!(sliceheadoff!(pattern,1)) escapeSequence;
			const char[] token = slice!(pattern,0,escapeSequence.consumed+1);
			const char[] next = sliceheadoff!(pattern,escapeSequence.consumed+1);
			alias escapeSequence.fn test;
		}
		else static if(pattern[0] == '$'){
			pragma(msg,"Error: $ not allowed inside an expression (use \\$ instead)");
			static assert(false);
		}
		else static if(pattern[0] == '^'){
			pragma(msg,"Error: ^ not allowed inside an expression (use \\^ instead)");
			static assert(false);
		}		
		else{
			const char[] token = parseTextToken!(pattern);
			static assert(strlen!(token) > 0);
			const char[] next = slice!(pattern,strlen!(token),strlen!(pattern));
			alias testText!(token) test;
		}
		
		debug pragma(msg,"TOKEN: " ~ token);
		debug pragma(msg,"NEXT: " ~ next);
		
		alias regexCompilePredicate!(test,token,next) term;
		const char[] remaining = slice!(next,term.consumed,strlen!(next));
		
		alias regexCompileRecurse!(term,remaining).fn fn;
	}
	else{
		alias testEmpty!() fn;
	}	
}


//TODO: at this level, check each tokenized sub expression for starting with '^' or ending with '$', and
// apply the appropriate matching algorithm.

/// recursive portion of regexCompile - shim to work around alias scope issue
template compileMatchRecurse(alias termFn,char[] pattern){
	static if(strlen!(pattern) > 0){
		debug pragma(msg,"REMAINING: " ~ pattern);
		
		alias compileMatch!(pattern) next;
		alias matchUnion!(termFn,next.fn,pattern) fn;
	}
	else{
		alias termFn fn;
	}
}

// shim
template compileMatch2(char[] token,char[] remaining){
	static if(last!(token) == '$'){
		static if(first!(token) == '^'){
			alias matchTestPerfect!(regexCompile!(slicetailoff!(token,1)).fn,remaining) termFn;
		}
		else{
			//TODO: refactor by reversing the string (should make for a faster match)
			alias matchTestFromEnd!(regexCompile!(slicetailoff!(token,1)).fn,remaining) termFn;
		}
	}
	else static if(first!(token) == '^'){
		alias matchTestFromStart!(regexCompile!(sliceheadoff!(token,1)).fn,remaining) termFn;
	}
	else{
		alias matchTest!(regexCompile!(token).fn,remaining) termFn;
	}			
	alias compileMatchRecurse!(termFn,remaining).fn fn;
}

template compileMatch(char[] pattern){
	static if(strlen!(pattern) > 0){
		alias parseUntil!(pattern,'|',true) unionToken;
		
		const char[] token = unionToken.token;
		const char[] remaining = sliceheadoff!(pattern,unionToken.consumed);
		
		debug pragma(msg,"TOKEN: " ~ token);
		debug pragma(msg,"REMAINING: " ~ remaining);	
		
		alias compileMatch2!(token,remaining).fn fn;
	}
	else{
		alias matchTest!(testEmpty!(),pattern) fn;
	}
	//TODO: parse support for unions (another parser layer most likely)
}

template regexMatch(char[] pattern){	
	//alias matchTest!(regexCompile!(pattern).fn,pattern) regexMatch;
	alias compileMatch!(pattern).fn regexMatch;
}
