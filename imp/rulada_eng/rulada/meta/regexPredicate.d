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
module meta.regexPredicate;

import meta.conv;
import meta.math;
//import meta.strhacks;
import meta.string;

/* TODO: support all of these
exec

	A regular expression method that executes a search for a match in a string. It returns an array of information.

test

	A regular expression method that tests for a match in a string. It returns true or false.

match

	A String method that executes a search for a match in a string. It returns an array of information or null on a mismatch.

search

	A String method that tests for a match in a string. It returns the index of the match, or -1 if the search fails.

replace

	A String method that executes a search for a match in a string, and replaces the matched substring with a replacement substring.

split

	A String method that uses a regular expression or a fixed string to break a string into an array of substrings.
*/

//match routines
alias char[][] function(char[] str) MatchPredicate;
alias const noMatch = (char[][]).init ;

// unions the results of two matches together
template matchUnion(alias firstMatch,alias secondMatch,char[] key){
	char[][] matchUnion(char[] str){
		char[][] results = firstMatch(str);
		results ~= secondMatch(str);
		return results;
	}
}

// attempts a single basic match from the start of the string only
template matchTest(alias testPredicate,char[] key){
	char[][] matchTest(char[] str){
		char[][] results;
		int result = testPredicate(str);
		if(result != testFail && result > 0){
			results ~= str[0..result];
		}
		return results;
	}
}

/*
// aggressive test- tests every possible substring for matches
//NOTE: you probably should never use this
template matchAggressive(alias testPredicate,char[] key){
	char[][] matchAggressive(char[] str){
		char[][] results;
		for(uint start=0; start<str.length; start++){
			for(uint end=str.length; end>start; end--){
				int result = testPredicate(str[start..end]);
				if(result != testFail && result == end-start){
					results ~= str[start..result];
				}
			}
		}
		return results;
	}
}*/

// tests all substrings that start at the start of string
template matchTestFromStart(alias testPredicate,char[] key,bit aggressive=false){
	char[][] matchTestFromStart(char[] str){
		for(uint end=str.length; end>0; end--){
			char[][] results;
			int result = testPredicate(str[0..end]);
			if(result != testFail && result > 0){
				results ~= str[0..result];
				return results;	
			}
		}
		return results;		
	}
}

// tests all substrings that terminate at the string's end
//TODO: refactor by reversing the string (should make for a faster match)
template matchTestFromEnd(alias testPredicate,char[] key,bit aggressive=false){
	char[][] matchTestFromEnd(char[] str){
		char[][] results;
		for(uint start=0; start<str.length; start++){
			int result = testPredicate(str[start..$]);
			if(result != testFail && result == str.length-start){
				results ~= str[start..$];
				static if(!aggressive) return results;	
			}
		}
		return results;	
	}	
}

// test must completely cover the entire string
template matchTestPerfect(alias testPredicate,char[] key){
	char[][] matchTestFromStart(char[] str){
		char[][] results;
		int result = testPredicate(str);
		if(result != testFail && result == str.length){
			results ~= str[0..result];
		}
		return results;
	}
}

//test routines
alias int function(char[] str) TestPredicate;
const int testFail = -1;

/// empty terminal
template testEmpty(){
	int testEmpty(char[] str){
		return 0;
	}
}

/// two consecutive tests
template testUnion(alias testFirst,alias testSecond,char[] key){
	int testUnion(char[] str){
		int result = testFirst(str);
		if(result != testFail){
			int nextResult = testSecond(str[result..$]);
			if(result != testFail){
				return result + nextResult;
			}
		}
		return testFail;
	}
}

// two consecutive tests, either one will pass
template testOr(alias testFirst,alias testSecond,char[] key){
	int testOr(char[] str){
		int result = testFirst(str);
		if(result != testFail) return result;
		result = testSecond(str);
		return result;
	}
}


template testText(char[] text){
	int testText(char[] str){
		if(str.length == 0 || text.length > str.length) return testFail;
		if(str[0..text.length] == text){
			return text.length;
		}
		return testFail;
	}
}

template testOneOrMore(alias testPredicate,char[] key){
	int testOneOrMore(char[] str){
		if(str.length == 0) return testFail;
		int result = testPredicate(str);
		if(result != testFail){
			int nextResult = .testOneOrMore!(testPredicate,key)(str[result..$]);
			if(nextResult != testFail){
				return result + nextResult;
			}
			return result;
		}
		return testFail;
	}
}


template testZeroOrMore(alias testPredicate,char[] key){
	int testZeroOrMore(char[] str){
		if(str.length == 0) return 0;
		int result = testPredicate(str);
		if(result != testFail){
			int nextResult = .testZeroOrMore!(testPredicate,key)(str[result..$]);
			if(nextResult != testFail){
				return result + nextResult;
			}
			return result;
		}
		return 0;
	}
}


template testZeroOrOne(alias testPredicate,char[] key){
	int testZeroOrOne(char[] str){
		if(str.length == 0) return testFail;
		int result = testPredicate(str);
		if(result == testFail) return 0;
		return result;
	}
}

template testRange(char[] term1,char[] term2){
	int testRange(char[] str){
		if(str.length == 0) return testFail;
		if(str[0] >= term1[0] && str[0] <= term2[0]){
			return 1;
		}
		return testFail;
	}
}

template testTimes(uint min,uint max,alias testPredicate,char[] key){
	int testTimes(char[] str){
		if(str.length == 0) return testFail;
		int result = 0;
		uint i;
		for(i=0; i<max; i++){
			int nextResult = testPredicate(str[result..$]);
			if(nextResult == testFail){
				if(i < min)	return testFail;
				break;
			}
			result += nextResult;
		}
		return result;
	}
}

template testAny(){
	int testAny(char[] str){
		if(str.length == 0) return testFail;
		//TODO: check for newline (some regexps dont' test this)
		return 1;
	}
}

template testChar(char[] ch){
	int testChar(char[] str){
		if(str.length == 0) return testFail;
		if(str[0] == ch[0]){
			return 1;
		}
		return testFail;
	}
}

template testWordChar(){
	int testWordChar(char[] str){
		if(str.length == 0) return testFail;
		if(	
			(str[0] >= 'a' && str[0] <= 'z') ||
			(str[0] >= 'A' && str[0] <= 'Z') ||
			(str[0] >= '0' && str[0] <= '9') ||
			str[0] == '_'
		){
			return 1;
		}
		return testFail;
	}
}

template testCharInverse(alias testPredicate,char[] key){
	int testCharInverse(char[] str){
		if(testPredicate(str) == testFail) return 1;
		return testFail;
	}
}