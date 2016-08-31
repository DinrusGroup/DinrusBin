/*******************************************************************************

        @file QuotedToken.d
        
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

module mango.text.QuotedToken;

private import  mango.text.Text,
                mango.text.Token;


/*******************************************************************************


*******************************************************************************/

class QuotedTokenTemplate(T) : TokenTemplate!(T)
{
        private T[] set;

        /***********************************************************************
 
        
        ***********************************************************************/

        this (T[] set, T[] string = null)
        {
                this.set = set;
                super (string);
        }

        /***********************************************************************
 
        
        ***********************************************************************/

        override Token trim ()
        {
                super.trim ();

                if (slice.length > 1)
                   {        
                   int start, end;
                   T* p = slice.ptr;
                      
                   if (*p == '"' || *p == '\'')
                       ++start;
                
                   p += (end = slice.length) - 1;
                   if (*p == '"' || *p == '\'')
                       --end;

                   slice = slice [start..end];
                   }
                return this;
        }

        /***********************************************************************
 
        
        ***********************************************************************/

        override bool next()
        {
                void pair (T quote)
                {
                        while (++peek < end)
                               if (*peek == quote)
                                   return;
                        --peek;
                }

                do {
                   while (++peek < end)
                          if (TextT!(T).locate (set.ptr, *peek, set.length))
                              return found;
                          else
                             if (*peek == '"' || *peek == '\'')
                                 pair (*peek);
                   } while (getMore);

                return hasTail;
        }
}

// convenience alias
alias QuotedTokenTemplate!(char) QuotedToken;

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
