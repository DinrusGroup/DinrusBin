/*******************************************************************************

        @file List.d

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

module mango.containers.List;

private import mango.containers.Container;
private import mango.containers.Set;
private import mango.containers.Iterator;
private import mango.containers.Util;

/******************************************************************************
	
	The classic list.  Also sometimes known as an array.  What else
	is there to say?

******************************************************************************/
public abstract class List(V) : AbstractContainer!(V) {

       /***********************************************************************
        
                Returns the element stored at the specified location.

		@throws BoundsException if the index is out of range

        ***********************************************************************/
	public abstract V get(int i);
	public alias get opIndex;


       /***********************************************************************
        
                Returns a new List containing the ith element through the
		(j-1)th element.  It is up to the implementation whether or
		not a copy of the data is made.

		@throws BoundsException if either index is out of range

        ***********************************************************************/
	public abstract List subList(int i, int j);
	public alias subList opSlice;


       /***********************************************************************
        
                Returns the location of the first occurrence in the list of the
		specified item.  Returns -1 if the item is not in the list.

        ***********************************************************************/
	public abstract int firstIndexOf(V item);


       /***********************************************************************
        
                Returns the location of the last occurrence in the list of the
		specified item.  Returns -1 if the item is not in the list.

       ************************************************************************/
	public abstract int lastIndexOf(V item);


       /***********************************************************************
        
                Returns a set containing all of the locations at which the
		specified item occurs in the list.  If the item does not occur
		in the list, an empty set is returned.

       ************************************************************************/
	public abstract Set!(int) indexesOf(V item);


       /***********************************************************************
        
                Returns a D array equivalent to the list.

       ************************************************************************/
	public abstract V[] toArray();

	/***********************************************************************
        
                Lists are only comparable to other lists.  Equality of Lists
		is defined to be equal sizes and at each index, the element
		at the location in each list is equal, using the == operator.
		Two null values are considered to be equal.

        ***********************************************************************/
	public abstract override int opEquals(Object o);

	//These next methods override Parents, and specify the return type.
	public abstract List dup();
}

/******************************************************************************

	Since a few of the methods in List are easily implemented using
	some of the other methods, this does it.  These may be overridden.

******************************************************************************/
class AbstractList(V) : List!(V) {

	Iterator!(V) iterator() {
		return new ListIterator!(V)(this);
	}

	int firstIndexOf(V item) {
	  	for(int i=0; i<size; i++) {
			if (get(i) == item)
	      	return i;
		}
		return -1;
	}
	
	int lastIndexOf(V item) {
	  	for(int i=size-1; i>=0; i--) {
		  	if (get(i) == item)
			  return i;
		}
		return -1;
	}
	
	Set!(int) indexesOf(V item) {
		return null;
	}
	
	int opEquals(Object o) {
	  	List!(V) list = cast(List!(V))o;
		assert(list);
		if (list.size != this.size) {
			return false;
		}
		
		Iterator!(V) i = iterator;
		Iterator!(V) j = list.iterator;
		while (i.hasNext() && j.hasNext()) {
			if (!Util!(V).equals(i.next, j.next)) {
			  return false;
			}
		}
		return (i.hasNext() == j.hasNext());
	}
	
	
	uint toHash() {
	  	uint hash;
		foreach(V item; this) {
		 	hash += Util!(V).hash(item);
		}
		return hash;
	}
}

/******************************************************************************

	This abstract class provides mutable methods for lists, permitting
	modification of the list.

	Many of these methods return the list, so that on can string multiple
	method as such:
	@code
	list.assign("foo",1).append("bar");
	@endcode

******************************************************************************/
public abstract class MutableList(V): AbstractList!(V) {

       /***********************************************************************
        
                Sets the ith element in the list to the specified item. Will
		not grow the list unless the optional parameter grow is
		specified to true;

		@throws BoundsException If i is out of range

       ************************************************************************/
	public abstract MutableList assign(V item, int i, bit grow = false);
	public alias assign opIndexAssign;


       /***********************************************************************
        
                Inserts the specified item after index i, shifting everything
		below the ith element down.  Grows the list by one.

		@throws BoundsException if i is out of range

       ************************************************************************/
	public abstract MutableList insertAfter(int i, V item);


       /***********************************************************************
        
                Inserts the specified item before index i, shifting everything
		at and below the ith element down.  Grows the list by one.

		@throws BoundsException if i is out of range

       ************************************************************************/
	public abstract MutableList insertBefore(int i, V item);


       /***********************************************************************
        
                Grows the list by adding the specified element or elements
 		of the specified container to the end of the list.

       ************************************************************************/
	public abstract MutableList append(V item);
	public abstract MutableList append(Container!(V) items);
	public abstract MutableList append(V[] items);
	public alias append opCatAssign;


       /***********************************************************************
        
                Grows the list by adding the specified element or elements
 		of the specified container to the beginning of the list.
		
		Shifts everything down by one.

       ************************************************************************/
	public abstract MutableList prepend(V item);
	public abstract MutableList prepend(Container!(V) items);
	public abstract MutableList prepend(V[] items);


       /***********************************************************************
        
                Shrinks the list by deleting the specified element.  Shifts
		everything below this item up by one.

		@returns The item removed

		@throws BoundsException if i is out of range

       ************************************************************************/
	public abstract V removeIndex(int i);


       /***********************************************************************
        
                Removes everything in the container

       ************************************************************************/
	public abstract MutableList clear();	


       /***********************************************************************
        
                Shrinks the container by deleting the specified element or
		elements of the specifiec container.

       ************************************************************************/
	public abstract MutableList remove(V item);
	public abstract MutableList remove(Container!(V) items);
	public abstract MutableList remove(V[] items);


       /***********************************************************************
        
                Removes all of the items from this container that are not
		in the specified container or array.

       ************************************************************************/
	public abstract MutableList intersect(Container!(V) items);
	public abstract MutableList intersect(V[] items);


       /***********************************************************************
        
                Swaps the two elements in the List.

		@throws BoundsException if i or j is out of range

       ************************************************************************/
	public abstract MutableList swap(int i, int j);


       /***********************************************************************
        
                Runs the specified algorithm.  Allows containers to take care
		of atomicity, or other special features.

       ************************************************************************/
	public template mutate(alias A) {
		void mutate(...) {
			A!(V).go(this, _argptr, _arguments);
		}
	}

	
       	//These next methods override Parents, and specify the return type.
	public abstract MutableList dup();
	public abstract MutableList subList(int i, int j);
	public abstract MutableIterator!(V) iterator();
}

class AbstractMutableList(V): MutableList!(V) {
  	//These methods from Container implemented here for ease of implementation.
  	public MutableList!(V) concat(V item) {
		return this.dup.append(item);
	}

	public MutableList!(V) concat(Container!(V) items) {
		return this.dup.append(items);
	}

	public MutableList!(V) intersection(Container!(V) container) {
	  	return this.dup.intersect(container);
	}


	MutableIterator!(V) iterator() {
		return new MutableListIterator!(V)(this);
	}

	public MutableList!(V) append(Container!(V) items) {
	  	foreach(V item; items) {
			MutableList!(V).append(item);
	  	}
		return this;
  	}

	public MutableList!(V) append(V[] items) {
	  	foreach(V item; items) {
			MutableList!(V).append(item);
	  	}
		return this;
	}

	public MutableList!(V) prepend(Container!(V) items) {
	  	int i=0;
	  	foreach(V item; items) {
	    		insertBefore(i++, item);
	  	}
	  	return this;
	}

	public MutableList!(V) prepend(V[] items) {
	  	for(int i=items.length-1; i>=0; i--) {
	    		MutableList!(V).prepend(items[i]);
	  	}
	  	return this;
	}

	public MutableList!(V) swap(int i, int j) {
		V t = this[i];
		this[i] = this[j];
		this[j] = t;
		return this;
	}

	public MutableList!(V) remove(V item) {
	  MutableIterator!(V) iter = this.iterator();
	  while (iter.hasNext()) {
	    if (iter.next() == item)
	      iter.remove();
	  }
	  return this;
	}

	public MutableList!(V) remove(Container!(V) items) {
	  MutableIterator!(V) iter = this.iterator();
	  while (iter.hasNext()) {
	    if (items.contains(iter.next()))
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

	public MutableList!(V) remove(V[] items) {
	  MutableIterator!(V) iter = this.iterator();
	  while (iter.hasNext()) {
	    if (arrContains(items, iter.next()))
	      iter.remove();
	  }
	  return this;
	}

	public MutableList!(V) intersect(Container!(V) items) {
	  MutableIterator!(V) iter = this.iterator();
	  while (iter.hasNext()) {
	    if (!items.contains(iter.next()))
	      iter.remove();
	  }
	  return this;
	}

	public MutableList!(V) intersect(V[] items) {
	  MutableIterator!(V) iter = this.iterator();
	  while (iter.hasNext()) {
	    if (!arrContains(items, iter.next()))
	      iter.remove();
	  }
	  return this;
	}

	public AbstractMutableList opCall(void delegate(MutableList!(V) list) algorithm) {
	  algorithm(this);
	  return this;
	}

	public AbstractMutableList opCall(void function(MutableList!(V) list) algorithm) {
	  algorithm(this);
	  return this;
	}
}


/******************************************************************************

	Provides a generic iterator that should work with all lists.  This
	way, each list doesn't have to provide it's own Iterator implementation.

	This implementation has no regard for concurrent modification.  It
	simply counts and returns the values until it reaches the end of
	the list.  If the list grows, this iterator will keep going.  If the
	list shrinks, it is possible that this Iterator will throw an
	BoundsException.

******************************************************************************/
class ListIterator(V): Iterator!(V) {
  private List!(V) myList;
  protected int pos;

  this(List!(V) list) {
    myList = list;
    pos = 0;
  }

  bit hasNext() {
    return cast(bit)(pos < myList.size());
  }

  V next() {
    return myList.get(pos++);
  }
}

class MutableListIterator(V) : ListIterator!(V), MutableIterator!(V) {
  private MutableList!(V) mutList;

  this(MutableList!(V) list) {
    super(list);
    mutList = list;
  }

  void remove() {;
    if (pos <= 0) 
      throw new BoundsException("You must call .next before you can call .remove on an iterator");
    mutList.removeIndex(--pos);
  }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
