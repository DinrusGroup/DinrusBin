/*******************************************************************************

        @file Properties.d
        
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


        @version        Initial version, May 2004      
        @author         Kris


*******************************************************************************/

module mango.io.Properties;

private import  mango.text.Text,
                mango.text.LineIterator;

private import  mango.io.FileConduit;

private import  mango.io.model.IConduit;

/*******************************************************************************
        
        Provides load facilities for a properties file. That is, a file
        or other medium containing lines of text with a name=value layout.

*******************************************************************************/

class Properties
{
        /***********************************************************************
        
                Load properties from the named file, and pass each of them
                to the provided delegate.

        ***********************************************************************/

        static void load (char[] filepath, void delegate (char[]name, char[] value) dg)
        {
                FileConduit fc = new FileConduit (filepath, FileStyle.ReadExisting);

                try {
                    load (fc, dg);
                    } finally 
                            fc.close();
        }

        /***********************************************************************
        
                Load properties from the provided conduit, and pass them to
                the provided delegate.

        ***********************************************************************/

        static void load (IConduit conduit, void delegate (char[]name, char[] value) dg)
        {
                // bind the input to a line tokenizer
                auto line = new LineIterator (conduit);

                // scan all lines
                while (line.next)
                      {
                      char[] text = line.trim.get;
                        
                      // comments require '#' as the first non-whitespace char 
                      if (text.length && (text[0] != '#'))
                         {
                         // find the '=' char
                         int i = Text.indexOf (text, '=');

                         // ignore if not found ...
                         if (i > 0)
                             dg (Text.trim (text[0..i]), Text.trim (text[i+1..text.length]));
                         }
                      }
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
