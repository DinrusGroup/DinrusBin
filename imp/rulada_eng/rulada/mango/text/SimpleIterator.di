/*******************************************************************************

        @file SimpleIterator.d
        
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


        @version        Initial version, January 2006      

        @author         Kris


*******************************************************************************/

module mango.text.SimpleIterator;

private import  mango.text.Iterator;

/*******************************************************************************

        Iterate across a set of text patterns.

        These iterators are based upon the IBuffer construct, and can
        thus be used in conjunction with other Iterators and/or Reader
        instances upon a common buffer ~ each will stay in lockstep via
        state maintained within the IBuffer.

        The content exposed via an iterator is supposed to be entirely
        read-only. All current iterators abide by this rule, but it is
        possible a user could mutate the content through a get() slice.
        To enforce the desired read-only aspect, the code would have to 
        introduce redundant copying or the compiler would have to support 
        read-only arrays.

        See LineIterator, SimpleIterator, RegexIterator, QuotedIterator.


*******************************************************************************/

class SimpleIteratorT(T) : IteratorT!(T)
{
        private T[] delim;

        /***********************************************************************
        
                Construct an uninitialized iterator. Use as follows:

                auto line = new LineIterator;

                void somefunc (IBuffer buffer)
                {
                        // there are several set() methods
                        line.set (buffer);
                        
                        while (line.next)
                               Println (line.get);
                }
        
        ***********************************************************************/

        this (T[] delim) 
        {
                this.delim = delim;
        }

        /***********************************************************************

                Construct a streaming iterator upon the provided buffer. 
                Use as follows:

                void somefunc (IBuffer buffer)
                {
                        auto line = new LineIterator (buffer);
                        
                        while (line.next)
                               Println (line.get);
                }
        
        ***********************************************************************/

        this (IBuffer buffer, T[] delim)
        {
                super (buffer);
                this.delim = delim;
        }

        /***********************************************************************
        
                Construct a streaming iterator upon the provided conduit. 
                Use as follows:

                auto line = new LineIterator (new FileConduit ("myfile"));

                while (line.next)
                       Println (line.get);

        ***********************************************************************/

        this (IConduit conduit, T[] delim)
        {
                super (conduit);
                this.delim = delim;
        }

        /***********************************************************************
        
                Construct an iterator upon the provided string. Use as follows:

                void somefunc (char[] string)
                {
                        auto line = new LineIterator (string);
                        
                        while (line.next)
                               Println (line.get);
                }
        
        ***********************************************************************/

        this (T[] string, T[] delim)
        {
                super (string);
                this.delim = delim;
        }

        /***********************************************************************
                      
        ***********************************************************************/

        protected uint scan (void[] data)
        {
                T[] content = convert (data);

                if (delim.length is 1)
                   {
                   foreach (int i, T c; content)
                            if (c is delim[0])
                                return found (set (cast(char*) content, 0, i));
                   }
                else
                   foreach (int i, T c; content)
                            if (has (delim, c))
                                return found (set (cast(char*) content, 0, i));

                return notFound (content);
        }
}


// convenience alias
alias SimpleIteratorT!(char) SimpleIterator;


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
