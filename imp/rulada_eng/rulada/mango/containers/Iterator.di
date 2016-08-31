/*******************************************************************************

        @file Iterator.d

        Copyright (c) 2005 John Demme
        
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

      
        @version        Initial version, June 2005
        @author         John Demme (me@teqdruid.com)


*******************************************************************************/

module mango.containers.Iterator;


/******************************************************************************

	Provides a very simple, generic way to iterate through the elements
	of any container.  This interface doesn't provide any manner to modify
	the container.

******************************************************************************/
interface Iterator(V) {
       /***********************************************************************
        
                Returns true if there are any more items in the container to
		be returned by next().

       ************************************************************************/
	bit hasNext();

       /***********************************************************************
        
                Returns the next item in the container.

		@throws ArrayBoundsError If you overstep your bounds

       ************************************************************************/
	V next();
}


/******************************************************************************

	Adds on to the Iterator interface, and adds a method of modifying
	a container.

******************************************************************************/
interface MutableIterator(V) : Iterator!(V) {
       /***********************************************************************
        
                Removes the last element that was returned by next().

		@throws ArrayBoundsError If next() hasn't yet been called, or
			if the item no longer exists in the container.

       ************************************************************************/  
	void remove();
}

interface MapIterator(K,V) {
       /***********************************************************************
        
                Returns true if there are any more items in the container to
		be returned by next().

       ************************************************************************/
	bit hasNext();

       /***********************************************************************
        
                Returns the next item in the container.

		@throws ArrayBoundsError If you overstep your bounds

       ************************************************************************/
	void next(out K key, out V value);
}

interface MutableMapIterator(K,V): MapIterator!(K,V) {
       /***********************************************************************
        
                Returns true if there are any more items in the container to
		be returned by next().

       ************************************************************************/
	bit hasNext();

       /***********************************************************************
        
                Returns the next item in the container.

		@throws ArrayBoundsError If you overstep your bounds

       ************************************************************************/
	void next(out K key, out V value);


       /***********************************************************************
        
                Removes the last value returned from next from the map

		@throws ArrayBoundsError If next hasn't been called yet;

       ************************************************************************/
	void remove();
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
