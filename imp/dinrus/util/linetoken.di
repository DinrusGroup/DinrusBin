
module util.linetoken;

ткст[] разбериСтроку(ткст pSource,
                      ткст pDelim = ",",
                      ткст pComment = "//",
                      ткст pEscape = "\\");
					  
					  
юткст[] разбериСтроку(юткст pSource,
                       юткст pDelim = ",",
                       юткст pComment = "//",
                       юткст pEscape = "\\");
/* How To Use ===============================
Insert this into your code ...

  private import linetoken;

Then to call it use ...

   ткст Toks;
   ткст InputLine;
   ткст DelimChar;
   ткст CommentString;

   Toks = разбериСтроку(InputLine, DelimChar, CommentString);
** Note that it accepts all 'char[]' or all 'дим[]' arguments.

The routine scans the input string and returns a set of strings, one
per token found in the input string.

The tokens are delimited by the single character in DelimChar. However,
if DelimChar is an empty string, then tokens are delimited by any group
of one or more white-space characters. By default, DelimChar is ",".

If CommentString is not empty, then all parts of the input string from
the begining of the comment to the end are ignored. By default
CommentString is "//".

If a token начинается_с with a quote (single, double or back), then you will
get back two tokens. The first is the quote as a single character string,
and the second is all the characters up to, but not including the next
quote of the same тип. The ending quote is discarded.

If a token начинается_с with a bracket (parenthesis, square, or brace), then you
will get back two tokens. The first is the opening bracket as a single
character string, and the second is all the characters up to, but not
including, the matching end bracket, taking nested brackets (of the same
тип) into consideration.

All whitespace in between tokens is ignored, and not returned.

If the tokenizer finds a back-slash character (\), then next character
is always considered as a part of a token. You can use this to force
the delimiter character or spaces to be inserted into a token.

Examples:
   разбериСтроку(" abc, def , ghi, ")
 --> {"abc", "def", "ghi", ""}

   разбериСтроку("character    or spaces to be \t inserted", "")
 --> {"character", "or", "spaces", "to", "be", "inserted"}

   разбериСтроку(" abc; def , ghi; ", ";")
 --> {"abc", "def , ghi", "" }

   разбериСтроку(" abc, [def , ghi]           ")
 --> {"abc", "[", "def , ghi"}

   разбериСтроку(" abc, [def , ghi] // comment")
 --> {"abc", "[", "def , ghi"}

   разбериСтроку(" abc, [def , [ghi, jkl] ]  ")
 --> {"abc", "[", "def , [ghi, jkl] "}

   разбериСтроку(" abc, def , ghi ; comment", ",", ";")
 --> {"abc", "def", "ghi"}

   разбериСтроку(` abc, "def , ghi" , jkl `)
 --> {"abc", `"`, "def , ghi", "jkl"}
*/
