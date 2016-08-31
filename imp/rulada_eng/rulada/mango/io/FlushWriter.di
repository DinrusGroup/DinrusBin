/*******************************************************************************

        @file FlushWriter.d
        
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


        @version        Initial version; March 2004      

        @author         Kris
                        

*******************************************************************************/

module mango.io.FlushWriter;

public import  mango.io.DisplayWriter;

/*******************************************************************************

        Subclass to support automatic flushing. This can be used for 
        Stdout, Stderr, and other related conduits.

*******************************************************************************/

class FlushWriter : DisplayWriter
{
        alias DisplayWriter.put put;

        /***********************************************************************
        
                Construct a FlushWriter upon the specified IBuffer

        ***********************************************************************/

        this (IBuffer buffer)
        {
                super (buffer);
        }

        /***********************************************************************
        
                Construct a FlushWriter upon the specified IConduit

        ***********************************************************************/

        this (IConduit conduit)
        {
                this (new Buffer(conduit));
        }

        /**********************************************************************
        
                Intercept the IWritable method to catch newlines, and 
                flush the buffer whenever one is emitted

        ***********************************************************************/

        override IWriter put (IWritable x)
        {      
               // have superclass handle the IWritable
                super.put (x);

                // flush output when we see a newline
                if (cast(INewlineWriter) x)
                    flush ();

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
