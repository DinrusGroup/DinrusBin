/*******************************************************************************

        @file Stack.d

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

      
        @version        Initial version, December 2005
        @author         John Demme (me@teqdruid.com)


*******************************************************************************/

module mango.containers.Stack;

private import mango.containers.LinkedList;

/******************************************************************************
	
	Implements a stack by extending a linked list.

******************************************************************************/
public class Stack(V) : LinkedList!(V) {
	public this() {
	}

	public this(Container!(V) items) {
	  super(items);
	}

	public this(V[] array) {
	  super(array);
	}

	/***********************************************************************
        
		"Pushes" a new item on to the top of the stack.

	***********************************************************************/
	public Stack push(V item) {
	  prepend(item);
	  return this;
	}

	/***********************************************************************
        
		Removes the top item from the stack and returns it.

	***********************************************************************/
	public V pop() {
	  return removeIndex(0);
	}

	/***********************************************************************
        
		Returns the top item on the stack without removing it.

	***********************************************************************/
	public V peek() {
	  return get(0);
	}
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
