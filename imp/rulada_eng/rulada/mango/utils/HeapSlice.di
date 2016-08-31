/*******************************************************************************

        @file HeapSlice.d
        
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


        @version        Initial version, October 2004      
        @author         Kris


*******************************************************************************/

module mango.utils.HeapSlice;

/*******************************************************************************
        
*******************************************************************************/

class HeapSlice
{
        private uint    used;
        private void[]  buffer;

        /***********************************************************************
        
                Create with the specified starting size

        ***********************************************************************/

        this (uint size)
        {
                buffer = new void[size];
        }

        /***********************************************************************
        
                Reset content length to zero

        ***********************************************************************/

        void reset ()
        {
                used = 0;
        }

        /***********************************************************************
        
                Potentially expand the content space, and return a pointer
                to the start of the empty section.

        ***********************************************************************/

        void* expand (uint size)
        {
                if ((used + size) > buffer.length)
                     buffer.length = (used + size) * 2;
                return &buffer [used];
        }

        /***********************************************************************
        
                Return a slice of the content from the current position 
                with the specified size. Adjusts the current position to 
                point at an empty zone.

        ***********************************************************************/

        void[] slice (int size)
        {
                uint i = used;
                used += size;
                return buffer [i..used];
        }
}



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
