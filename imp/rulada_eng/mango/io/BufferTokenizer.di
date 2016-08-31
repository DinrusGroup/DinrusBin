/*******************************************************************************

        @file BufferTokenizer.d
        
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

module mango.io.BufferTokenizer;

private import  mango.text.Token;

private import  mango.io.Buffer;
/+
private import  mango.io.model.IBuffer,
                mango.io.model.IConduit;
+/
/*******************************************************************************

        Tokenize input from a buffer or conduit
        
        All input is tokenized from the associated buffer, and exposed as a 
        freachable property via method opApply(). Empty token are passed to
        the caller ~ this may happen if, for example, an empty line is seen
        by a line-tokenizer.

*******************************************************************************/

class BufferTokenizerTemplate(T)
{
        private TokenTemplate!(T)       token;
        private IBuffer                 buffer;

        /***********************************************************************
        
                Construct a BufferTokenizer on the provided buffer, using 
                the specified Tokenizer instead of the default one.

        ***********************************************************************/

        this (IBuffer buffer, TokenTemplate!(T) token)
        {
                this.token = token;
                this.buffer = buffer;
                token.setRefill (&refill);
        }
        
        /***********************************************************************
                
                Construct a BufferTokenizer upon the buffer associated with 
                the given conduit.

        ***********************************************************************/

        this (IConduit conduit, TokenTemplate!(T) token)
        {
                this (new Buffer(conduit), token);
        }

        /**********************************************************************

                Iterate over the set of tokens

        **********************************************************************/

        int opApply (int delegate(inout T[]) dg)
        {
                return token.opApply (dg);
        }

        /***********************************************************************
 
                Refill the token content from our buffer. Returns false 
                upon reaching EOF

        ***********************************************************************/

        private bool refill (TokenTemplate!(T) token)
        {
                bool more;

                buffer.skip (token.eaten - buffer.getPosition);
                if (buffer.getConduit)
                    more = cast(bool) (buffer.fill() != IConduit.Eof);
                else
                   more = cast(bool) (buffer.readable > 0);
                token.prime (buffer.toString);
                return  more;
        }
}


// convenience alias
alias BufferTokenizerTemplate!(char) BufferTokenizer;
version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
