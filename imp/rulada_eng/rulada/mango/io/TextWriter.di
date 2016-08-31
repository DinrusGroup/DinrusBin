/*******************************************************************************

        @file TextWriter.d
        
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

module mango.io.TextWriter;

private import mango.convert.Type;

public  import mango.io.FlushWriter;

/*******************************************************************************

        Print readable output to an IWriter seperated by delimiters. Note
        that the delimiter should be chosen such that it doesn't conflict
        with any other characters being written. For example, by choosing 
        a comma-delimiter, you should ensure a comma is not output within
        a text string (so the output can be easily tokenized when read).

*******************************************************************************/

class TextWriter : FlushWriter
{
        alias FlushWriter.put put;

        private byte    ignore;
        private char[]  delimiter;

        /***********************************************************************
        
                Construct a TextWriter using the provided buffer. Output 
                is seperated with the given delimiter string.

        ***********************************************************************/

        this (IBuffer buffer, char[] delimiter)
        {
                super (buffer);
                this.delimiter = delimiter;
        }
     
        /***********************************************************************
        
                Reset this writer, so it won't emit the specified series 
                of subsequent delimeters

        ***********************************************************************/

        void suppress (byte count)
        {    
                ignore += count;
        }
     
        /***********************************************************************
        
                Intercept the IWritable method to catch newlines

        ***********************************************************************/

        override IWriter put (IWritable x)
        {      
                // don't delimit writable if it's to be ignored
                if (cast(IPhantomWriter) x)
                    suppress (1);

                // have superclass print the IWritable
                return super.put (x);
        }

        /***********************************************************************
        
                Intercept string output so we can append a delimiter

        ***********************************************************************/

        protected override IWriter encode (void* x, uint bytes, int type)
        {    
                super.encode (x, bytes, type);
                return delimit ();
        }

        /***********************************************************************
        
                write a delimiter after each token

        ***********************************************************************/

        private final IWriter delimit ()
        {    
                // output the delimiter?
                if (ignore)
                    --ignore;
                else
                   super.encode (cast(void*) delimiter, delimiter.length, cast(int) Type.Utf8);
                return this;
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
