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


        @version        Initial version, March 2004      
                        Circular dependency split; Oct 2004  
                        2nd circular dependency split; March 2005 (dmd v0.115)

        @author         Kris, Chris Sauls


*******************************************************************************/

module mango.io.Token;

private import  mango.io.Buffer,
                mango.io.Tokenizer;

private import  mango.convert.Atoi,
                mango.convert.Double;

private import  mango.io.model.IWriter,
                mango.io.model.IReader,
                mango.io.model.IConduit;

/*******************************************************************************

        Tokens used by Tokenizer class. Tokens do not copy their content
        so they are quite useful for parsing quantites of data quickly. 
        Conversely since each token is mapped into an external buffer, 
        you should be aware that changes to said buffer will impact any
        tokens based upon it. You may sidestep this by using the clone()
        method, or toString().dup

        Tokens can convert from a variety of numeric format to ascii text.
        Formats currently include int, uint, long, ulong, and real. Each
        number may be preceded by whitespace, and an optional '+' or '-'
        specifier. Note that real-number format is simplistic in that it 
        does not support exponential declarations.  Note the conversion 
        methods should probably be moved elsewhere.

        Here's a brief example of how to apply Token with Tokenizers:

        @code
        // open a file for reading
        FileConduit fc = new FileConduit ("test.txt");

        // create a buffer for reading the file
        IBuffer buffer = new Buffer (fc);

        // create a token for receiving the line
        Token token = new Token;

        // read file a line at a time. Method next() returns false when no more 
        // delimiters are found. Note there may be an unterminated line at eof
        while (Tokenizers.line.next(buffer, token) || token.getLength)
               Stdout (token) (CR);
        @endcode

        See also BoundToken, ReaderToken, CompositeToken and HybridToken.

*******************************************************************************/

class Token : IWritable
{ 
        private int     type;
        private char[]  content;

        /***********************************************************************
        
                Set the content of this token.

        ***********************************************************************/

        Token set (char[] content)
        {
                this.content = content;
                return this;
        }

        /***********************************************************************
                
                Return the length of this token.

        ***********************************************************************/

        int getLength ()
        {
                return content.length;
        }

        /***********************************************************************
        
                Set the type of this token. Token types can be useful when
                one wishes to categorize input patterns.

        ***********************************************************************/

        Token setType (int type)
        {
                this.type = type;
                return this;
        }

        /***********************************************************************
        
                Return the type associated with this token. See setType().

        ***********************************************************************/

        int getType ()
        {
                return type;
        }

        /***********************************************************************
        
                Convert this token to an integer.

        ***********************************************************************/

        int toInt ()
        {
                return cast(int) Atoi.parse (content);
        }

        /***********************************************************************
        
                Convert this token to a long integer.

        ***********************************************************************/

        long toLong ()
        {
                return Atoi.parse (content);
        }

        /***********************************************************************

                Convert this token to a real.

        ***********************************************************************/

        real toReal ()
        {
                return Double.parse (content);
        }

        /***********************************************************************
        
                Clone this token, making a copy of the content also.

        ***********************************************************************/

        Token clone ()
        {
                Token clone = new Token;

                clone.set (toString (false));
                clone.type = type;
                return clone;
        }

        /***********************************************************************
        
                Return a reference to this tokens content. Duplicate it
                only if 'slice' is explicitly set to false (defaults to 
                a slice instead).

        ***********************************************************************/

        char[] toString (bool slice = true)
        {
                if (slice)
                    return content;
                return content.dup;
        }

        /***********************************************************************
        
                Is this token equal to another?

        ***********************************************************************/

        override int opEquals (Object o)
        {
                Token other = cast(Token) o;

                if (other is null)
                    return super.opEquals (o);
                return typeid(char[]).equals (&content, &other.content);
        }

        /***********************************************************************
        
                Compare this token to another.

        ***********************************************************************/

        override int opCmp (Object o)
        {
                Token other = cast(Token) o;

                if (other is null)
                    return super.opCmp (o);

                return typeid(char[]).compare (&content, &other.content);
        }

        /***********************************************************************
        
                Hash this token

        ***********************************************************************/

        override uint toHash ()
        {
                return typeid(char[]).getHash (&content);
        }

        /***********************************************************************
        
                Make the Token class compatible with IWriter instances.

        ***********************************************************************/

        void write (IWriter w)
        {
                w.put (content);
        }
}


/*******************************************************************************

        A style of Token that's bound to a Tokenizer. This can be a handy 
        means of cleaning up client code, and limiting the scope of how
        a token is used by recieving methods.

        Contrast this example with that shown in the Token class:

        @code
        // open a file for reading
        FileConduit fc = new FileConduit ("test.txt");

        // create a buffer for reading the file
        IBuffer buffer = new Buffer(fc);

        // bind a line-tokenizer to our input token
        BoundToken line = new BoundToken (Tokenizers.line);

        // read file a line at a time. Method next() returns false when no more 
        // delimiters are found. Note there may be an unterminated line at eof
        while (line.next(buffer) || line.getLength)
               Stdout (line) (CR);
        @endcode

        One might also consider a CompositeToken or HybridToken.

*******************************************************************************/

class BoundToken : Token
{ 
        private ITokenizer tk;

        /***********************************************************************
        
        ***********************************************************************/

        this (ITokenizer tk)
        {
                this.tk = tk;
        }

        /***********************************************************************
        
                Return the associated tokenizer

        ***********************************************************************/

        ITokenizer getTokenizer ()
        {     
                return tk;
        }

        /***********************************************************************
        
                Extract the next token from the provided buffer.

                Returns true if a token was isolated, false if no more 
                tokens were found. Note that one last token may still
                be present when this return false; this may happen if
                (for example) the last delimiter is missing before an
                EOF condition is seen. Check token.getLength() when
                this method returns false.
                
                For example:

                @code
                        while (token.next() || token.getLength())
                               // do something

                @endcode               

        ***********************************************************************/

        bool next (IBuffer buf)
        {
                return tk.next (buf, this);
        }
}


/*******************************************************************************

        ReaderToken adapts a BoundToken such that it can be used directly
        with any IReader implementation. We just add the IReadable methods
        to the basic BoundToken.

        Here's a contrived example of how to use ReaderToken:

        @code
        // create a small buffer on the heap
        Buffer buf = new Buffer (256);

        // write items with a comma between each
        TextWriter write = new TextWriter (buf, ",");

        // write some stuff to the buffer
        write ("now is the time for all good men") (3.14159);

        // bind a couple of tokens to a comma tokenizer
        ReaderToken text = new ReaderToken (Tokenizers.comma);
        ReaderToken number = new ReaderToken (Tokenizers.comma);
        
        // create any old reader since we only use it for handling tokens
        Reader read = new Reader (buf);

        // populate both tokens via reader 
        read (text) (number);

        // print them to the console
        Stdout (text) (':') (number) (CR);
        @endcode

*******************************************************************************/

class ReaderToken : BoundToken, IReadable
{ 
        /***********************************************************************
        
                Construct a ReaderToken using the provided Tokenizer.

        ***********************************************************************/

        this (ITokenizer tk)
        {
                super (tk);
        }

        /***********************************************************************
        
                Read the next delimited element into this token.

        ***********************************************************************/

        void read (IReader r)
        {
                tk.next (r.getBuffer, this);
        }
}


/*******************************************************************************

        Another subclass of BoundToken that combines both a Tokenizer and
        an input buffer. This is simply a convenience wrapper than takes
        care of details that would otherwise clutter the client code.

        Compare this to usage of a basic Token:

        @code
        // open a file for reading
        FileConduit fc = new FileConduit ("test.txt");

        // create a Token and bind it to both the file and a line-tokenizer
        CompositeToken line = new CompositeToken (Tokenizers.line, fc);

        // read file a line at a time. Method get() returns false when no more 
        // tokens are found. 
        while (line.get)
               Stdout (line) (CR);
        @endcode

        You might also consider a HybridToken for further processing of
        token content.

*******************************************************************************/

class CompositeToken : BoundToken
{       
        private IBuffer buffer;

        /***********************************************************************
        
                Set this token to use the provided Tokenizer, and bind it 
                to the given buffer.

        ***********************************************************************/

        this (ITokenizer tk, IBuffer buffer)
        {
                super (tk);
                this.buffer = buffer;
        }

        /***********************************************************************
        
                Set this token to use the provided Tokenizer, and bind it 
                to the buffer associated with the given conduit.

        ***********************************************************************/

        this (ITokenizer tk, IConduit conduit)
        {
                this (tk, new Buffer(conduit));
        }

        /***********************************************************************
        
                Return the associated buffer

        ***********************************************************************/

        IBuffer getBuffer ()
        {     
                return buffer;
        }

        /***********************************************************************

                Extract the next token. 

                Returns true if a token was isolated, false if no more 
                tokens were found. Note that one last token may still
                be present when this return false; this may happen if
                (for example) the last delimiter is missing before an
                Eof condition is seen. Check token.getLength() when
                this method returns false.
                
                For example:

                @code
                        while (token.next || token.getLength)
                               // do something

                @endcode               

        ***********************************************************************/

        bool next ()
        {
                return tk.next (buffer, this);
        }

        /***********************************************************************

                Extract the next token, taking Eof into consideration.
                If next() returns false, then this function will still
                return true as long as there's some content available.

                For example:

                @code
                        while (token.get)
                               // do something

                @endcode               

        ***********************************************************************/

        bool get ()
        {
                return cast(bool) (next || getLength);
        }
}


/*******************************************************************************

        A subclass of CompositeToken that combines a Tokenizer, an input buffer,
        and the means to bind its content to a subordinate Reader or Token. 
        This is another convenience wrapper than takes care of details that
        would otherwise complicate client code.

        Compare this to usage of a CompositeToken:

        @code
        // open a file for reading
        FileConduit fc = new FileConduit ("test.txt");

        // create a Token and bind it to both the file and a line-tokenizer
        HybridToken line = new HybridToken (Tokenizers.line, fc);

        // now create a reader upon the token
        Reader input = new Reader (line.getHost);

        // read file a line at a time. Method get() returns false when no more 
        // tokens are found. 
        while (line.get)
              {
              int x, y;
                
              // reader is now bound to the content of the current line
              input (x) (y);

              Stdout (x) (y) (CR);
              }
        @endcode

        You can use the same mechanism to bind subordinate Tokens:

        @code
        // open a file for reading
        FileConduit fc = new FileConduit ("test.txt");

        // create a Token and bind it to both the file and a line-tokenizer
        HybridToken line = new HybridToken (Tokenizers.line, fc);

        // now create a subordinate Token that splits on whitespace
        CompositeToken word = new CompositeToken (Tokenizers.space, line.getHost);

        // read file a line at a time. Method get() returns false when no more 
        // tokens are found. 
        while (line.get)
               // extract space delimited tokens from each line
               while (word.get)
                      Stdout (word) (CR);
        @endcode


*******************************************************************************/

class HybridToken : CompositeToken
{       
        private IBuffer host;

        /***********************************************************************
        
                Set this token to use the provided Tokenizer, and bind it 
                to the given buffer.

        ***********************************************************************/

        this (ITokenizer tk, IBuffer buffer)
        {
                super (tk, buffer);

                // create the hosting IBuffer
                host = new Buffer();
        }

        /***********************************************************************
        
                Set this token to use the provided Tokenizer, and bind it 
                to the buffer associated with the given conduit.

        ***********************************************************************/

        this (ITokenizer tk, IConduit conduit)
        {
                this (tk, new Buffer(conduit));
        }

        /***********************************************************************
        
                Return the associated host buffer. The host should be used
                for purposes of binding a subordinate Token or Reader onto
                the content of this token. Each call to next() will update
                this content appropriately, which is also reflected within 
                said host buffer.

                That is, token.toString == token.getHost.toString.

        ***********************************************************************/

        IBuffer getHost ()
        {     
                return host;
        }

        /***********************************************************************

                Extract the next token. 

                Returns true if a token was isolated, false if no more 
                tokens were found. Note that one last token may still
                be present when this return false; this may happen if
                (for example) the last delimiter is missing before an
                Eof condition is seen. Check token.getLength() when
                this method returns false.
                
                For example:

                @code
                        while (token.next || token.getLength)
                               // do something

                @endcode               

        ***********************************************************************/

        bool next ()
        {
                // get the next token
                bool ret = super.next;

                // set host content
                host.setValidContent (toString);

                return ret;
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
