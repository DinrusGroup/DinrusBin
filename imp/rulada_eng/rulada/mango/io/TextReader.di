/*******************************************************************************

        @file TextReader.d
        
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

module mango.io.TextReader;

private import  mango.io.Reader,
                mango.io.BufferCodec;

private import  mango.convert.Type;

private import  mango.text.Iterator,
                mango.text.NumericParser;


/*******************************************************************************

        Convert readable input from a stream. All input is tokenized from the
        associated buffer, and converted as necessary into the destination. 

*******************************************************************************/

class TextReaderT(T) : Reader
{
        private NumericParserT!(T)  parser;

        /***********************************************************************
        
                Construct a TextReader on the provided buffer, using the
                specified Tokenizer instead of the default one.

        ***********************************************************************/

        this (NumericParserT!(T) parser, AbstractDecoder decoder)
        {
                super (parser.getIterator.getBuffer);
                this.parser = parser;
                setDecoder (decoder);
        }
        
        /***********************************************************************
        
                Is this Reader text oriented?

        ***********************************************************************/

        bool isTextBased ()
        {
                return true;
        }

        /***********************************************************************
        
                Extract a char value from the next token
                
        ***********************************************************************/

        IReader get (inout char x)
        {
                char[] tmp;

                get (tmp);
                if (tmp.length)
                    x = tmp[0];
                return this;
        }

        /***********************************************************************
        
                Extract a wide char value from the next token
                
        ***********************************************************************/

        IReader get (inout wchar x)
        {
                wchar[] tmp;

                get (tmp);
                if (tmp.length)
                    x = tmp[0];
                return this;
        }

        /***********************************************************************
        
                Extract a double char value from the next token
                
        ***********************************************************************/

        IReader get (inout dchar x)
        {
                dchar[] tmp;

                get (tmp);
                if (tmp.length)
                    x = tmp[0];
                return this;
        }

        /***********************************************************************
        
        ***********************************************************************/

        IReader get (inout char[] x, uint elements = uint.max)
        {       
                x = cast(char[]) decoder.decoder (parser.next(), Type.Utf8);
                return this;
        }

        /***********************************************************************
        
        ***********************************************************************/

        IReader get (inout wchar[] x, uint elements = uint.max)
        {
                x = cast(wchar[]) decoder.decoder (parser.next(), Type.Utf16);
                return this;
        }

        /***********************************************************************
        
        ***********************************************************************/

        IReader get (inout dchar[] x, uint elements = uint.max)
        {
                x = cast(dchar[]) decoder.decoder (parser.next(), Type.Utf32);
                return this;
        }

        /***********************************************************************
        
        ***********************************************************************/

        protected override uint read (void* src, uint bytes, uint type)
        {
                return parser.read (src, bytes, type);
        }
}


// convenience alias
alias TextReaderT!(char) TextReader;





version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
