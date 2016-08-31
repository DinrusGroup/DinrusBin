/*******************************************************************************

        @file Token.d
        
        Copyright (c) 2004 Kris Bell
        
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.
        
        Permission is hereby granted to anyone to use this software for any 
        purpose, including commercial applications, and to alter it and/or 
        redistribute it freely, subject to the following restrictions:
        
        1. The origin of this software must not be misrepresented; you must 
           not claim that you wrote the original software. If you use this 
           software in a product, an acknowledgment within documentation of 
           said product would be appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must 
           not be misrepresented as being the original software.

        3. This notice may not be removed or altered from any distribution
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full and credit the original source.


                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        @version        Initial version, December 2005      

        @author         Kris


*******************************************************************************/

module mango.text.Token;

private import mango.text.Text;

/*******************************************************************************

        The base class for a set of tokenizers. 

        There are two types of tokenizers supported ~ exclusive and 
        inclusive. The former are the more common kind, where a token
        is delimited by elements that are considered foreign. Examples
        include space, comma, and end-of-line delineation. Inclusive
        tokens are just the opposite: they look for patterns in the
        text that should be part of the token itself ~ everything else
        is considered foreign. Currently the only inclusive token type
        is exposed by RegexToken; everything else is of the exclusive
        variety.

        The content provided to Tokenizers is supposed to be entirely
        read-only. All current tokenizers abide by this rule, but it's
        possible a user could mutate the content through a token slice.
        To enforce the desired read-only aspect, the code would have to 
        introduce redundant copying or the compiler would have to support 
        read-only arrays.

        See LineToken, CharToken, RegexToken, QuotedToken, and SetToken.

*******************************************************************************/

class TokenTemplate(T)
{
        static if (!is (T == char) && !is (T == wchar) && !is (T == dchar)) 
                    pragma (msg, "Template type must be char, wchar, or dchar");


        alias TokenTemplate Token;

        alias bool delegate(Token token) Refill;

        protected T*            peek,           // current position
                                last,           // prior position
                                end;            // end of content
        package   T[]           slice,          // current token slice
                                content;        // the content to tokenize
        package   bool          hasTail,        // sentinel for last call
                                autoTrim;       // trim tokens by default?
        package   Refill        refill;         // where to get new content

        /***********************************************************************
 
                Locate the next token. If this Token is configured for
                "refills", more content will be requested as needed.
                        
                Returns true if a token is found; false otherwise.
        
        ***********************************************************************/

        abstract bool next();

        /***********************************************************************
 
                Construct a token upon the given content. Automatic
                refills are disabled

        ***********************************************************************/

        this (T[] string)
        {
                prime (string);
                refill = &this.noRefill;
        }

        /**********************************************************************

                Iterate over the set of tokens. This provides read-only
                access to the tokens

        **********************************************************************/

        int opApply (int delegate(inout T[]) dg)
        {
                int result = 0;

                while (next)
                      {
                      T[] t = get ();
                      result = dg (t);
                      if (result)
                          break;
                      }
                return result;
        }

        /***********************************************************************
        
                Enable automatic trimming of tokens?
      
        ***********************************************************************/

        void setAutoTrim (bool enabled)
        {
                autoTrim = enabled;
        }

        /***********************************************************************
 
                A Refill delegate should use this method to push the tail
                of the current text. Doing so will cause the tail to be
                prepended to the next 'found' token, after the content is
                primed to reference fresh incoming data. Thus, a Refill
                should do this:

                // copy token.tail() into buffer

                // append fresh content into buffer
                // ...
                
                token.prime (buffer);
                return true;
       
        ***********************************************************************/

        void setRefill (Refill refill)
        {
                this.refill = refill;
        }

        /***********************************************************************
 
                Set the content, ready for next() to start

        ***********************************************************************/

        T[] prime (T[] content)
        {
                this.content = content;
                peek = (last = content.ptr) - 1;
                end = last + content.length;
                return content;
        }

        /***********************************************************************
 
                Return the current token as a slice of the content
        
        ***********************************************************************/

        T[] get()
        {
                return slice;
        }

        /***********************************************************************
 
                Return the current content-tail. This is typically used
                by "refill" handlers, when they stream more content in.
                
        ***********************************************************************/

        T[] tail()
        {
                return last [0 .. end-last];
        }

        /***********************************************************************
 
                Return how much content has been consumed

        ***********************************************************************/

        uint eaten()
        {
                return last - content.ptr;
        }

        /***********************************************************************

                Return the index of the current token. This is different 
                from eaten() in that the current token may not yet have 
                been consumed. Thus index() will always be less than or 
                equal to eaten()

        ***********************************************************************/

        uint index()
        {
                return slice.ptr - content.ptr;
        }

        /***********************************************************************
 
                Trim spaces from the left and right of the current token.
                Note that this is done in-place on the current slice. The
                content itself is not affected.
        
        ***********************************************************************/

        Token trim ()
        {
                slice = TextT!(T).trim (slice);
                return this;
        }

        /***********************************************************************
 
                Internal method for subclasses to call when they locate a 
                token

        ***********************************************************************/

        protected bool found (int offset = 0)
        {
                slice = last [0 .. (peek - offset) - last];
                last = peek + 1;
                if (autoTrim)
                    trim ();
                return true;
        }

        /***********************************************************************
 
                Internal method for subclasses to call when they run out
                of content to scan. This invokes the "refill" facilities
                to provide additional content.

        ***********************************************************************/

        protected bool getMore ()
        {
                hasTail = false;
                if (last < end || content.ptr is null)
                   {
                   // more content available?
                   if (refill (this))
                       return true;

                   // set the last slice for this content
                   hasTail = true;
                   slice = tail;
                   if (autoTrim)
                       trim();
                   last = end;
                   }
                return false;
        }

        /***********************************************************************
        
                Default "refill" handler, which indicates there's no more 
                content to be had
        
        ***********************************************************************/

        private bool noRefill (Token token)
        {
                return false;
        }
}

//alias TokenTemplate!(char) Token;
version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
