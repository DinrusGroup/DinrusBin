/*******************************************************************************

        @file Layout.d

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

module mango.log.Layout;

private import mango.log.Event;

/*******************************************************************************

        Base class for all Layout instances

*******************************************************************************/

public class Layout
{
        private import mango.log.Logger;

        /***********************************************************************
                
                Subclasses should implement this method to perform the
                formatting of each message header

        ***********************************************************************/

        abstract char[]  header (Event event);

        /***********************************************************************
                
                Subclasses should implement this method to perform the
                formatting of each message footer

        ***********************************************************************/

        char[] footer (Event event)
        {
                return "";
        }

        /***********************************************************************
                
                Subclasses should implement this method to perform the
                formatting of the actual message content.

        ***********************************************************************/

        char[] content (Event event)
        {
                return event.toString;
        }

        /***********************************************************************
                
                Convert a time value (in milliseconds) to ascii

        ***********************************************************************/

        final char[] ultoa (char[] s, ulong l)
        in {
           assert (s.length > 0);
           }
        body 
        {
                int len = s.length;
                do {
                   s[--len] = l % 10 + '0';
                   l /= 10;
                   } while (l && len);
                return s[len..s.length];                
        }
}


/*******************************************************************************

        A simple layout comprised only of level, name, and message

*******************************************************************************/

public class SimpleLayout : Layout
{
        /***********************************************************************
                
                Format outgoing message

        ***********************************************************************/

        char[] header (Event event)
        {
                event.append (event.getLevelName)
                     .append(event.getName)
                     .append(" - ");
                return event.getContent;
        }
}

/*******************************************************************************

        A simple layout comprised only of time(ms), level, name, and message

*******************************************************************************/

public class SimpleTimerLayout : Layout
{
        /***********************************************************************
                
                Format outgoing message

        ***********************************************************************/

        char[] header (Event event)
        {
                char[20] tmp;

                event.append (ultoa (tmp, event.getTime))
                     .append (" ")
                     .append (event.getLevelName)
                     .append (event.getName)
                     .append (" - ");
                return event.getContent;
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
