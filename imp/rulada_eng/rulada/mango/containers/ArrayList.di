/*******************************************************************************

        @file ArrayList.d

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

module mango.containers.ArrayList;

import mango.containers.Container;
import mango.containers.List;
import mango.containers.Iterator;
import mango.containers.Set;
import mango.containers.Util;

import std.array;


/******************************************************************************
	
	Implements a MutableList.  Backed by D's built-in dynamic array.

******************************************************************************/
public class ArrayList(V) : AbstractMutableList!(V) {
  private V[] myArray;

  this() {
  }

  this(Container!(V) items) {
    try {
      foreach(V item; items) {
	myArray ~= item;
      }
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    } 
  }

  this(V[] array) {
    myArray = array.dup;
  }
  
  //Methods from Container
  bit isThreadSafe() {
    return false;
  }

  ArrayList dup() {
    return new ArrayList(myArray);
  }

  int size() {
    return myArray.length;
  }

  //Methods from List
  V get(int i) {
    try {
      return myArray[i];
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    }
  }

  /***********************************************************************
        
	Returns a new List containing the ith element through the
	(j-1)th element.  In ArrayList, D's dynamic arrays are used, so
	an ArrayList implemening COW (copy on write) behavior is returned.

  ***********************************************************************/
  ArrayList subList(int i, int j) {
    try {
      ArrayList ret = new ArrayList;
      ret.myArray = myArray[i..j];
      return ret;
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    }
  }

  V[] toArray() {
    try {
      return myArray.dup;
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    }
  }

  //Methods from MutableList
  ArrayList assign(V item, int i, bit grow = false) {
    try {
      if (grow && i>=myArray.length) {
	myArray.length = i+1;
      }
      myArray[i] = item;
      return this;
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    }
  }

  ArrayList insertAfter(int i, V item) {
   try {
     myArray = myArray[0..i+1] ~ item ~ myArray[i+1..myArray.length];
     return this;
   } catch (ArrayBoundsError e) {
     throw new BoundsException(e.toString);
    }
  }

  ArrayList insertBefore(int i, V item) {
    try {
      myArray = myArray[0..i] ~ item ~ myArray[i..myArray.length];
      return this; 
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    }
  }

  ArrayList append(V item) {
   try {
     myArray ~= item;
     return this;
   } catch (ArrayBoundsError e) {
     throw new BoundsException(e.toString);
   }
  }

  ArrayList prepend(V item) {
   try {
     myArray = item ~ myArray;
     return this;
   } catch (ArrayBoundsError e) {
     throw new BoundsException(e.toString);
   }
  }

  V removeIndex(int i) {
   try {
     V ret = myArray[i];
     myArray = myArray[0..i] ~ myArray[i+1..myArray.length];
     return ret;
   } catch (ArrayBoundsError e) {
     throw new BoundsException(e.toString);
   }
  }

  ArrayList clear() {
   try {
     myArray = myArray[0..0];
     return this;
   } catch (ArrayBoundsError e) {
     throw new BoundsException(e.toString);
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
