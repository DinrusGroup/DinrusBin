/*******************************************************************************

        @file Set.d

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

module mango.containers.Set;

private import mango.containers.Container;
private import mango.containers.Iterator;

public abstract class Set(V) : AbstractContainer!(V) {
	//These are here to further specify the return type.
  	public abstract Set dup();
  	public abstract Set concat(V item);
	public abstract Set concat(Container!(V) items);
	public abstract Set intersection(Container!(V) container);
}

class AbstractSet(V): Set!(V) {
}

abstract class MutableSet(V): AbstractSet!(V) {

       /***********************************************************************
        
                Removes everything in the container

       ************************************************************************/
	public abstract MutableSet clear();	


       /***********************************************************************
        
                Adds an item or items to the set.

       ************************************************************************/
	public abstract MutableSet add(V item);
	public abstract MutableSet add(Container!(V) items);
	public abstract MutableSet add(V[] items);


       /***********************************************************************
        
                Shrinks the container by deleting the specified element or
		elements of the specifiec container.

       ************************************************************************/
	public abstract MutableSet remove(V item);
	public abstract MutableSet remove(Container!(V) items);
	public abstract MutableSet remove(V[] items);


       /***********************************************************************
        
                Removes all of the items from this container that are not
		in the specified container or array.

       ************************************************************************/
	public abstract MutableSet intersect(Container!(V) items);
	public abstract MutableSet intersect(V[] items);


	//These are here to further specify the return type.
  	public abstract MutableSet dup();
	public abstract MutableIterator!(V) iterator();
  	public abstract MutableSet concat(V item);
	public abstract MutableSet concat(Container!(V) items);
	public abstract MutableSet intersection(Container!(V) container);	
}

class AbstractMutableSet(V): MutableSet!(V) {
  	//These methods from Container implemented here for ease of implementation.
  	public MutableSet!(V) concat(V item) {
		return this.dup.add(item);
	}

	public MutableSet!(V) concat(Container!(V) items) {
		return this.dup.add(items);
	}

	public MutableSet!(V) intersection(Container!(V) container) {
		return this.dup.intersect(container);
	}
	//End Container methods

	public AbstractMutableSet add(Container!(V) items) {
	  	foreach(V item; items) {
		  //add(item);
		}
		return this;
	}

	public AbstractMutableSet add(V[] items) {
	  	foreach(V item; items) {
		  //add(item);
		}
		return this;
	}

	public AbstractMutableSet remove(Container!(V) items) {
	  	foreach(V item; items) {
		  //remove(item);
		}
		return this;
	}

	public AbstractMutableSet remove(V[] items) {
	  	foreach(V item; items) {
		  //remove(item);
		}
		return this;
	}

	public AbstractMutableSet intersect(Container!(V) items) {
	  MutableIterator!(V) iter = this.iterator();
	  while (iter.hasNext()) {
	    if (!items.contains(iter.next()))
	      iter.remove();
	  }
	  return this;
	}

	//Helper method
	private static bit arrContains(V[] items, V item) {
	  for (int i=0; i<items.length; i++) {
	    if (items[i] == item)
	      return true;
	  }
	  return false;
	}

	public AbstractMutableSet intersect(V[] items) {
	  MutableIterator!(V) iter = this.iterator();
	  while (iter.hasNext()) {
	    if (!arrContains(items, iter.next()))
	      iter.remove();
	  }
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
