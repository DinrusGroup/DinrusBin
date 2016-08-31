/*******************************************************************************

        @file HttpTokens.d
        
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

       
        @version        Initial version, April 2004      
        @author         Kris


*******************************************************************************/

module mango.http.server.HttpTokens;

private import  mango.text.Text;

private import  mango.io.Buffer;

private import  mango.convert.Integer,
                mango.convert.Rfc1123;

private import  mango.io.model.IBuffer,
                mango.io.model.IWriter;

private import  mango.http.utils.TokenStack;

/******************************************************************************

        Struct used to expose freachable HttpToken instances.

******************************************************************************/

struct HttpToken
{
        char[]          name,
                        value;
}

/******************************************************************************

        Maintains a set of HTTP tokens. These tokens include headers, query-
        parameters, and anything else vaguely similar. Both input and output
        are supported, though a subclass may choose to expose as read-only.

        All tokens are mapped directly onto a buffer, so there is no memory
        allocation or copying involved. 

        Note that this class does not support deleting tokens. Supporting
        such operations require a different approach, such as mapping the
        tokens into a temporary buffer, and then setting token content in
        the stack to be null when it is deleted. This could be implemented
        as a wrapper upon the subclasses of HttpToken.

******************************************************************************/

class HttpTokens : IWritable
{
        protected TokenStack    stack;

        private IBuffer         input,
                                output;
        private bool            parsed;
        private bool            inclusive;
        private char            separator;
        private char[1]         sepString;
        static private char[]   emptyString;

        /**********************************************************************
                
                Setup an empty character array for later assignment.

        **********************************************************************/

        static this ()
        {
                emptyString = new char[0];
        }

        /**********************************************************************
                
                Construct a set of tokens based upon the given delimeter, 
                and an indication of whether said delimeter should be
                considered part of the left side (effectively the name).
        
                The latter is useful with headers, since the seperating
                ':' character should really be considered part of the 
                name for purposes of subsequent token matching.

        **********************************************************************/

        this (char separator, bool inclusive = false)
        {
                stack = new TokenStack();

                this.inclusive = inclusive;
                this.separator = separator;
                
                // convert separator into a string, for later use
                sepString[0] = separator;

                // pre-construct an empty buffer for wrapping char[] parsing
                input = new Buffer;
        }

        /**********************************************************************
                
                Clone a source set of HttpTokens

        **********************************************************************/

        this (HttpTokens source)
        {
                stack = source.stack.clone();
                input = null;
                output = source.output;
                parsed = true;
                inclusive = source.inclusive;
                separator = source.separator;
                sepString[0] = source.sepString[0];
        }

        /**********************************************************************
                
                Read all tokens. Everything is mapped rather than being 
                allocated & copied

        **********************************************************************/

        abstract void parse (IBuffer input);

        /**********************************************************************
                
                Parse an input string.

        **********************************************************************/

        void parse (char[] content)
        {
                input.setValidContent (content);
                parse (input);       
        }

        /**********************************************************************
                
                Reset this set of tokens.

        **********************************************************************/

        void reset ()
        {
                stack.reset();
                parsed = false;

                // reset output buffer, if it was configured
                if (output)
                    output.clear();
        }

        /**********************************************************************
                
                Have tokens been parsed yet?

        **********************************************************************/

        bool isParsed ()
        {
                return parsed;
        }

        /**********************************************************************
                
                Indicate whether tokens have been parsed or not.

        **********************************************************************/

        void setParsed (bool parsed)
        {
                this.parsed = parsed;
        }

        /**********************************************************************
                
                Return the value of the provided header, or null if the
                header does not exist

        **********************************************************************/

        char[] get (char[] name, char[] ret = null)
        {
                Token token = stack.findToken (name);
                if (token)
                   {
                   HttpToken element;

                   if (split (token, element))
                       ret = trim (element.value);
                   }
                return ret;
        }

        /**********************************************************************
                
                Return the integer value of the provided header, or the 
                provided default-vaule if the header does not exist

        **********************************************************************/

        int getInt (char[] name, int ret = -1)
        {       
                char[] value = get (name);

                if (value.length)
                    ret = cast(int) Integer.parse (value);

                return ret;
        }

        /**********************************************************************
                
                Return the date value of the provided header, or the 
                provided default-value if the header does not exist

        **********************************************************************/

        ulong getDate (char[] name, ulong date = Rfc1123.InvalidEpoch)
        {
                char[] value = get (name);

                if (value.length)
                    date = Rfc1123.parse (value);

                return date;
        }

        /**********************************************************************

                Iterate over the set of tokens

        **********************************************************************/

        int opApply (int delegate(inout HttpToken) dg)
        {
                HttpToken element;
                int       result = 0;

                foreach (Token t; stack)
                         if (split (t, element))
                            {
                            result = dg (element);
                            if (result)
                                break;
                            }
                return result;
        }

        /**********************************************************************

                Output the token list to the provided writer

        **********************************************************************/

        void write (IWriter writer)
        {
                foreach (Token token; stack)
                        {
                        char[] content = token.toString;
                        if (content.length)
                            writer.put(content).cr();
                        }                           
        }

        /**********************************************************************

                overridable method to handle the case where a token does
                not have a separator. Apparently, this can happen in HTTP 
                usage

        **********************************************************************/

        protected bool handleMissingSeparator (char[] s, inout HttpToken element)
        {
                return false;
        }

        /**********************************************************************

                split basic token into an HttpToken

        **********************************************************************/

        final private bool split (Token t, inout HttpToken element)
        {
                char[] s = t.toString();

                if (s.length)
                   {
                   int i = Text.indexOf (s, separator);

                   // we should always find the separator
                   if (i > 0)
                      {
                      int j = (inclusive) ? i+1 : i;
                      element.name = s[0..j];
                      element.value = (i < s.length) ? s[i+1..s.length] : emptyString;
                      return true;
                      }
                   else
                      // allow override to specialize this case
                      return handleMissingSeparator (s, element);
                   }
                return false;                           
        }

        /**********************************************************************

                Create a filter for iterating over the tokens matching
                a particular name. 
        
        **********************************************************************/

        FilteredTokens createFilter (char[] match)
        {
                return new FilteredTokens (this, match);
        }

        /**********************************************************************

                Implements a filter for iterating over tokens matching
                a particular name. We do it like this because there's no 
                means of passing additional information to an opApply() 
                method.
        
        **********************************************************************/

        private static class FilteredTokens 
        {       
                private char[]          match;
                private HttpTokens      tokens;

                /**************************************************************

                        Construct this filter upon the given tokens, and
                        set the pattern to match against.

                **************************************************************/

                this (HttpTokens tokens, char[] match)
                {
                        this.match = match;
                        this.tokens = tokens;
                }

                /**************************************************************

                        Iterate over all tokens matching the given name

                **************************************************************/

                int opApply (int delegate(inout HttpToken) dg)
                {
                        HttpToken       element;
                        int             result = 0;
                        
                        foreach (Token token; tokens.stack)
                                 if (tokens.stack.isMatch (token, match))
                                     if (tokens.split (token, element))
                                        {
                                        result = dg (element);
                                        if (result)
                                            break;
                                        }
                        return result;
                }

        }

        /**********************************************************************

                Is the argument a whitespace character?

        **********************************************************************/

        private bool isSpace (char c)
        {
                return cast(bool) (c is ' ' || c is '\t' || c is '\r' || c is '\n');
        }

        /**********************************************************************

                Trim the provided string by stripping whitespace from 
                both ends. Returns a slice of the original content.

        **********************************************************************/

        private char[] trim (char[] source)
        {
                int  front,
                     back = source.length;

                if (back)
                   {
                   while (front < back && isSpace(source[front]))
                          ++front;

                   while (back > front && isSpace(source[back-1]))
                          --back;
                   } 
                return source [front .. back];
        }


        /**********************************************************************
        ****************** these should be exposed carefully ******************
        **********************************************************************/


        /**********************************************************************
                
                Set the output buffer for adding tokens to. This is used
                by the various MutableXXXX classes.

        **********************************************************************/

        protected void setOutputBuffer (IBuffer output)
        {
                this.output = output;
        }

        /**********************************************************************
                
                Return the buffer used for output.

        **********************************************************************/

        protected IBuffer getOutputBuffer ()
        {
                return output;
        }

        /**********************************************************************
                
                Return a char[] representing the output. An empty array
                is returned if output was not configured. This perhaps
                could just return out 'output' buffer content, but that
                would not reflect deletes, or seperators. Better to do 
                it like this instead, for a small cost.

        **********************************************************************/

        char[] formatTokens (IBuffer dst, char[] delim)
        {
                int adjust = 0;

                foreach (Token token; stack)
                        {
                        char[] content = token.toString;
                        if (content.length)
                           {
                           dst.append(content).append(delim);
                           adjust = delim.length;
                           }
                        }    

                dst.truncate (dst.getLimit - adjust);
                return dst.toString;
        }

        /**********************************************************************
                
                Add a token with the given name. The content is provided
                via the specified delegate. We stuff this name & content
                into the output buffer, and map a new Token onto the
                appropriate buffer slice.

        **********************************************************************/

        protected void add (char[] name, void delegate (IBuffer) dg)
        {
                // save the buffer write-position
                int prior = output.getLimit;

                // add the name
                output.append (name);

                // don't append separator if it's already part of the name
                if (! inclusive)
                      output.append (sepString);
                
                // add the value
                dg (output);

                // map new token onto buffer slice
                int limit = output.getLimit;
                stack.push (output.toString[prior..limit]);
        }

        /**********************************************************************
                
                Add a simple name/value pair to the output

        **********************************************************************/

        protected void add (char[] name, char[] value)
        {
                void addValue (IBuffer buffer)
                {
                        buffer.append (value);
                }

                add (name, &addValue);
        }

        /**********************************************************************
                
                Add a name/integer pair to the output

        **********************************************************************/

        protected void addInt (char[] name, int value)
        {
                char[16] tmp;

                add (name, Integer.format (tmp, value));
        }

        /**********************************************************************
               
               Add a name/date(long) pair to the output
                
        **********************************************************************/

        protected void addDate (char[] name, ulong value)
        {
                char[40] tmp;

                add (name, Rfc1123.format (tmp, value));
        }

        /**********************************************************************
               
               remove a token from our list. Returns false if the named
               token is not found.
                
        **********************************************************************/

        protected bool remove (char[] name)
        {
                return stack.removeToken (name);
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
