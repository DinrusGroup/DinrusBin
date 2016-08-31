/*******************************************************************************

        @file Tokenizer.d     

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


        @version        Initial version, March 2004
        @author         Kris


*******************************************************************************/

module mango.io.Tokenizer;

version (Ares)
         private import  std.c.ctype;
      else
         private import  std.ctype;

private import  mango.io.Token,
                mango.io.Exception;

private import  mango.io.model.IReader,
                mango.io.model.IBuffer,
                mango.io.model.IConduit;

/*******************************************************************************

        Extract tokens from an IBuffer. This is the base-class for all
        Tokenizers, but can also be used outside of the ITokenizer model.

*******************************************************************************/

class Scanner
{ 
        /***********************************************************************
        
                Scan the given IBuffer for another token, and place the
                results in the provided token. Note that this should be
                completely thread-safe so one can instantiate singleton
                tokenizers without issue.

                Each Token is expected to be stripped of the delimiter.
                An end-of-file condition causes trailing content to be 
                placed into the token. Requests made beyond Eof result
                in empty tokens (length == zero).

                Returns true if a token was isolated, false otherwise.

        ***********************************************************************/

        bool next (IBuffer buffer, uint delegate (char[]) scan)
        {
                while (buffer.read (cast(uint delegate(void[])) scan) == IConduit.Eof)
                      {
                      IConduit conduit = buffer.getConduit();
                      if (conduit is null)
                         {
                         buffer.skip (buffer.readable());
                         return false;
                         }
                      else
                         {
                         // no more space in the buffer?
                         if (! buffer.writable())
                            {
                            // did we start at the beginning?
                            if (buffer.getPosition ())
                                // nope - move partial token to start of buffer
                                buffer.compress ();
                            else
                               throw new TokenException ("Token is too large to fit within buffer");
                            }

                         // read another chunk of data
                         if (buffer.fill (conduit) == IConduit.Eof)
                            {
                            buffer.skip (buffer.readable());
                            return false;
                            }
                         }
                      }
                return true;
        }

        /***********************************************************************
        
                Clean up after we fail to find a token. Trailing content
                is placed into the token, and the scanner is told to try
                and load some more content (where available).
                
        ***********************************************************************/

        uint notFound (Token token, char[] content)
        {
                token.set (content);
                return IConduit.Eof;
        }
}


/*******************************************************************************

        Interface to define how Tokenizers should expose their functionality.

*******************************************************************************/

interface ITokenizer
{ 
        /***********************************************************************
        
        ***********************************************************************/

        bool next (IBuffer buffer, Token token);
}


/*******************************************************************************

        A simple delimiting tokenizer. Use this to tokenize simple streams
        such as comma-seperated text.

*******************************************************************************/

class SimpleTokenizer : Scanner, ITokenizer
{
        private char delimiter;

        /***********************************************************************
        
                Construct a SimpleTokenizer with the given delimiter char.
                More sophisticated delimiters can be constructed by using
                a RegexTokenizer instead. 

        ***********************************************************************/

        this (char delimiter)
        {
                this.delimiter = delimiter;
        }
     

        /***********************************************************************
        
                Locate the next token from the provided buffer, and map a
                buffer reference into token. Returns true if a token was 
                located, false otherwise. 

                Note that the buffer content is not duplicated. Instead, a
                slice of the buffer is referenced by the token. You can use
                Token.clone() or Token.toString().dup() to copy content per
                your application needs.

                Note also that there may still be one token left in a buffer 
                that was not terminated correctly (as in eof conditions). In 
                such cases, tokens are mapped onto remaining content and the 
                buffer will have no more readable content.

        ***********************************************************************/

        bool next (IBuffer buffer, Token token)
        {
                uint scan (char[] content)
                {
                        foreach (int i, char c; content)
                                 if (c == delimiter)
                                    {
                                    token.set (content[0..i]);
                                    return i+1;
                                    }

                        return notFound (token, content);
                }

                return super.next (buffer, &scan);
        }
}


/*******************************************************************************

        A tokenizer that isolates content enclosed by whitespace.

*******************************************************************************/

class SpaceTokenizer : Scanner, ITokenizer
{
        /***********************************************************************
        
                Locate the next token from the provided buffer, and map a
                buffer reference into token. Returns true if a token was 
                located, false otherwise. 

                Note that the buffer content is not duplicated. Instead, a
                slice of the buffer is referenced by the token. You can use
                Token.clone() or Token.toString().dup() to copy content per
                your application needs.

                Note also that there may still be one token left in a buffer 
                that was not terminated correctly (as in eof conditions). In 
                such cases, tokens are mapped onto remaining content and the 
                buffer will have no more readable content.

        ***********************************************************************/

        bool next (IBuffer buffer, Token token)
        {
                uint scan (char[] content)
                {
                        foreach (int i, char c; content)
                                 if (isspace (c))
                                    {
                                    token.set (content[0..i]);
                                    return i+1;
                                    }

                        return notFound (token, content);
                }

                return super.next (buffer, &scan);
        }
}


/*******************************************************************************

        A tokenizer for handling both whitespace and punctuation delimiters.

*******************************************************************************/

class PunctTokenizer : Scanner, ITokenizer
{
        /***********************************************************************
        
                Locate the next token from the provided buffer, and map a
                buffer reference into token. Returns true if a token was 
                located, false otherwise. 

                Note that the buffer content is not duplicated. Instead, a
                slice of the buffer is referenced by the token. You can use
                Token.clone() or Token.toString().dup() to copy content per
                your application needs.

                Note also that there may still be one token left in a buffer 
                that was not terminated correctly (as in eof conditions). In 
                such cases, tokens are mapped onto remaining content and the 
                buffer will have no more readable content.

        ***********************************************************************/

        bool next (IBuffer buffer, Token token)
        {
                uint scan (char[] content)
                {
                        foreach (int i, char c; content)
                                 if (isspace(c) || ispunct(c))
                                    {
                                    token.set (content[0..i]);
                                    return i+1;
                                    }

                        return notFound (token, content);
                }

                return super.next (buffer, &scan);
        }
}


/*******************************************************************************

        Tokenize an entire line delimited by a single '\\n' character, or
        by a "\r\n" pair.

*******************************************************************************/

class LineTokenizer : Scanner, ITokenizer
{
        /***********************************************************************
        
                Locate the next token from the provided buffer, and map a
                buffer reference into token. Returns true if a token was 
                located, false otherwise. 

                Note that the buffer content is not duplicated. Instead, a
                slice of the buffer is referenced by the token. You can use
                Token.clone() or Token.toString().dup() to copy content per
                your application needs.

                Note also that there may still be one token left in a buffer 
                that was not terminated correctly (as in eof conditions). In 
                such cases, tokens are mapped onto remaining content and the 
                buffer will have no more readable content.

        ***********************************************************************/

        bool next (IBuffer buffer, Token token)
        {
                uint scan (char[] content)
                {      
                        foreach (int i, char c; content)
                                 if (c == '\n')
                                    {
                                    int slice = i;
                                    if (i && content[i-1] == '\r')
                                        --slice;
                                    token.set (content[0..slice]);
                                    return i+1;
                                    }

                        return notFound (token, content);
                }

                return super.next (buffer, &scan);
        }
}
   
     
/*******************************************************************************

        Eat everything until we reach a newline. Use this with a Reader, 
        where you wish to discard everything else in the current line. 

*******************************************************************************/

class LineScanner : Scanner, IReadable
{       
        /***********************************************************************
        
                IReadable interface to support Reader.get()

        ***********************************************************************/

        void read (IReader r)
        {
                next (r.getBuffer());
        }
                
        /***********************************************************************
        
                Eat all content until we see a '\n' character. The content
                is simply discarded.

        ***********************************************************************/

        bool next (IBuffer buffer)
        {
                uint scan (char[] content)
                {      
                        foreach (int i, char c; content)
                                 if (c == '\n')
                                     return i+1;
                        return IConduit.Eof;
                }

                return super.next (buffer, &scan);
        }
}

version (Ares) {}
else
{
/*******************************************************************************

        Wrap a tokenizer around the std.RegExp class. This is useful for
        situations where you can't load the entire source into memory at
        one time. In other words, this adapts RegExp into an incremental
        scanner.

        Note that the associated buffer must be large enough to contain
        an entire RegExp match. For example, if you have a regex pattern
        that matches an entire file then the buffer must be at least the
        size of the file. In such cases, one might be advised to find an 
        more effective solution.

*******************************************************************************/

class RegexTokenizer : Scanner, ITokenizer
{
        import std.regexp;
    
        private RegExp exp;

        /***********************************************************************
        
                Construct a RegexTokenizer with the provided RegExp.

        ***********************************************************************/

        this (RegExp exp)
        {
                this.exp = exp;
        }

        /***********************************************************************
        
                Locate the next token from the provided buffer, and map a
                buffer reference into token. Returns true if a token was 
                located, false otherwise. 

                Note that the buffer content is not duplicated. Instead, a
                slice of the buffer is referenced by the token. You can use
                Token.clone() or Token.toString().dup() to copy content per
                your application needs.

                Note also that there may still be one token left in a buffer 
                that was not terminated correctly (as in eof conditions). In 
                such cases, tokens are mapped onto remaining content and the 
                buffer will have no more readable content.

        ***********************************************************************/

        bool next (IBuffer buffer, Token token)
        {
                uint scan (char[] content)
                {      
                        //printf ("'%.*s' : %d\n", content, content.length);

                        // did we find a match?
                        if (exp.test (content))
                           {
                           int start = exp.pmatch[0].rm_so;
                           int end   = exp.pmatch[0].rm_eo;

                           // yep: stuff it into the token and go home
                           token.set (content[start..end]);
                           return end;
                           }
                        
                        // this is a bit tricky since RegExp doesn't tell
                        // us when it has a partial match. To compensate,
                        // we force the buffer to load as much as it can
                        // after a failure within a *partial* buffer.
                        if (buffer.getPosition())
                            buffer.compress();
                        else
                           // skip past everything that didn't match. The
                           // entire buffer may still be a partial match,
                           // but then it should be made bigger to begin
                           // with.
                           buffer.skip (content.length);

                        // say we found nothing
                        return notFound (token, content);
                }

                // return the next token using this tokenizer
                return super.next (buffer, &scan);
        }
}
}   
     
/*******************************************************************************

        It's convenient to have some simple tokenizers available without 
        constructing them, so we provide a few to get going with.

        Note that these Tokenizers do not maintain any state of their own. 
        Thus they are all thread-safe.

*******************************************************************************/

struct Tokenizers
{       
        static LineScanner      eol;
        static LineTokenizer    line;
        static SpaceTokenizer   space;
        static PunctTokenizer   punct;
        static SimpleTokenizer  comma;
         
        /***********************************************************************

                Make a few common tokenizers available as singletons      

        ***********************************************************************/

        static this ()
        {
                eol = new LineScanner();
                line = new LineTokenizer();           
                space = new SpaceTokenizer();
                punct = new PunctTokenizer();
                comma = new SimpleTokenizer(',');
        }
}
 



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
