/*******************************************************************************

        @file ImmutableList.d

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

module mango.containers.ImmutableList;

import mango.containers.Container;
import mango.containers.Iterator;
import mango.containers.List;
import mango.containers.Util;

import std.array;


/******************************************************************************
	
	An immutable List.  Once constructed, this list <b>cannot</b> be
	modified.  Backed by an array.

******************************************************************************/
public final class ImmutableList(V) : AbstractList!(V) {
  private V[] myArray;

  private this() {
  }

  /***********************************************************************
        
	Makes a copy of the container, and constructs the new list in the
	order that the container's Iterator splits the elements out in.

	There are several ways to populate this list. See the various
	constructors.

  ***********************************************************************/
  public this(Container!(V) items) {
    try {
      foreach(V item; items) {
	myArray ~= item;
      }
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    } 
  }

  /***********************************************************************
        
	Copies the array, and uses that.

  ***********************************************************************/
  public this(V[] array) {
    myArray = array.dup;
  }

  /***********************************************************************
        
	Runs the specified method until false is returned.  In the order
	that the passed delegate assigns items, this List puts them in
	itself.  If the length is known ahead of time, pass it in for
	greater speed.  The length parameter has no effect on the number
	of times the delegate is called, so feel free to estimate.

  ***********************************************************************/
  public this(bit delegate(out V) dg, int length = -1) {
    try {
      if (length > -1)
	myArray.length = length;
      V item;
      while (dg(item)) {
	myArray ~= item;
      }
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    }
  }

  /***********************************************************************
        
	Runs the specified function until false is returned.  In the order
	that the passed fcuntion assigns items, this List puts them in
	itself.  If the length is known ahead of time, pass it in for
	greater speed.  The length parameter has no effect on the number
	of times the function is called, so feel free to estimate.

  ***********************************************************************/
  public this(bit function(out V) fp, int length = -1) {
    try {
      if (length > -1)
	myArray.length = length;
      V item;
      while (fp(item)) {
	myArray ~= item;
      }
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    }
  }  

  //Methods from Container
  bit isThreadSafe() {
    return true;
  }

  ImmutableList dup() {
    return new ImmutableList(myArray);
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
	(j-1)th element.  Does not copy the data.

  ***********************************************************************/
  ImmutableList subList(int i, int j) {
    try {
      ImmutableList ret = new ImmutableList;
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
  
  public ImmutableList concat(V item) {
    try {
      ImmutableList ret = new ImmutableList;
      ret.myArray = myArray ~ item;
      return ret;
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    }
  }
  
  public ImmutableList concat(Container!(V) items) {
    try {
      ImmutableList ret = new ImmutableList(myArray);
      foreach(V item; items) {
	ret.myArray ~= item;
      }
      return ret;
    } catch (ArrayBoundsError e) {
      throw new BoundsException(e.toString);
    }
  }
  
  public ImmutableList intersection(Container!(V) container) {
    Iterator!(V) iter = container.iterator();
    bit add(out V item) {
      while (iter.hasNext) {
	item = iter.next();
	if (this.contains(item))
	  return true;
      } 
      return false;
    }
    return new ImmutableList(&add);
  }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
