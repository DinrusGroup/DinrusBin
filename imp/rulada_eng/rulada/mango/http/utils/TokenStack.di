/*******************************************************************************

        @file TokenStack.d
        
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
        @author         Kris, John Reimer


*******************************************************************************/

module mango.http.utils.TokenStack;

private import  mango.io.Exception;

/******************************************************************************

        Unix doesn't appear to have a memicmp() ... JJR notes that the
        strncasecmp() is available instead.

******************************************************************************/

version (Win32)
        {
        extern (C) int memicmp (char *, char *, uint);
        }

version (Posix) 
        {
        extern (C) int strncasecmp (char *, char*, uint);
        }

extern (C) void* memmove (void* dst, void* src, int n);


/******************************************************************************

        Internal representation of a token

******************************************************************************/

class Token
{
        private char[] value;

        Token set (char[] value)
        {
                this.value = value;
                return this;
        }

        char[] toString ()
        {
                return value;
        }
}

/******************************************************************************

        A stack of Tokens, used for capturing http headers. The tokens
        themselves are typically mapped onto the content of a Buffer, 
        or some other external content, so there's minimal allocation 
        involved (typically zero).

******************************************************************************/

class TokenStack
{
        private int     depth;
        private Token[] tokens;

        private static const int MaxTokenStackSize = 256;

        /**********************************************************************

                Construct a TokenStack with the specified initial size. 
                The stack will later be resized as necessary.

        **********************************************************************/

        this (int size = 10)
        {
                tokens = new Token[0];
                resize (tokens, size);
        }

        /**********************************************************************

                Clone this stack of tokens

        **********************************************************************/

        TokenStack clone ()
        {
                // setup a new tokenstack of the same depth
                TokenStack clone = new TokenStack(depth);
                
                clone.depth = depth;

                // duplicate the content of each original token
                for (int i=0; i < depth; ++i)
                     clone.tokens[i].set (tokens[i].toString().dup);

                return clone;
        }

        /**********************************************************************

                Iterate over all tokens in stack

        **********************************************************************/

        int opApply (int delegate(inout Token) dg)
        {
                int result = 0;

                for (int i=0; i < depth; ++i)
                     if ((result = dg (tokens[i])) != 0)
                          break;
                return result;
        }

        /**********************************************************************

                Pop the stack all the way back to zero

        **********************************************************************/

        final void reset ()
        {
                depth = 0;
        }

        /**********************************************************************

                Scan the tokens looking for the first one with a matching
                name. Returns the matching Token, or null if there is no
                such match.

        **********************************************************************/

        final Token findToken (char[] match)
        {
                Token tok;

                for (int i=0; i < depth; ++i)
                    {
                    tok = tokens[i];
                    if (isMatch (tok, match))
                        return tok;
                    }
                return null;
        }

        /**********************************************************************

                Scan the tokens looking for the first one with a matching
                name, and remove it. Returns true if a match was found, or
                false if not.

        **********************************************************************/

        final bool removeToken (char[] match)
        {
                for (int i=0; i < depth; ++i)
                     if (isMatch (tokens[i], match))
                        {
                        tokens[i].value = null;
                        return true;
                        }
                return false;
        }

        /**********************************************************************

                Return the current stack depth

        **********************************************************************/

        final int size ()
        {       
                return depth;
        }

        /**********************************************************************

                Push a new token onto the stack, and set it content to 
                that provided. Returns the new Token.

        **********************************************************************/

        final Token push (char[] content)
        {
                return push().set (content);  
        }

        /**********************************************************************

                Push a new token onto the stack, and set it content to 
                be that of the specified token. Returns the new Token.

        **********************************************************************/

        final Token push (inout Token token)
        {
                return push (token.toString());  
        }

        /**********************************************************************

                Push a new token onto the stack, and return it.

        **********************************************************************/

        final Token push ()
        {
                if (depth == tokens.length)
                    resize (tokens, depth * 2);
                return tokens[depth++];
        }

        /**********************************************************************

                Pop the stack by one.

        **********************************************************************/

        final void pop ()
        {
                if (depth)
                    --depth;
                else
                   throw new IOException ("illegal attempt to pop Token stack");
        }

        /**********************************************************************

                See if the given token matches the specified text. The 
                two must match the minimal extent exactly.

        **********************************************************************/

        final static bool isMatch (inout Token token, char[] match)
        {
                char[] target = token.toString();

                int length = target.length;
                if (length > match.length)
                    length = match.length;

                if (length is 0)
                    return false;

                version (Win32)
                         return cast(bool) (memicmp (cast(char*) target,cast(char*) match, length) == 0);
                version (Posix)
                         return cast(bool) (strncasecmp (cast(char *)target, cast(char *)match, length) == 0);
        }
        
        /**********************************************************************

                Resize this stack by extending the array.

        **********************************************************************/

        final static void resize (inout Token[] tokens, int size)
        {
                int i = tokens.length;

                // this should *never* realistically happen 
                if (size > MaxTokenStackSize)
                    throw new IOException ("Token stack exceeds maximum depth");

                for (tokens.length=size; i < tokens.length; ++i)
                     tokens[i] = new Token();
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
