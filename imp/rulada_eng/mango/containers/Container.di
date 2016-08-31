/*******************************************************************************

        @file Container.d

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

module mango.containers.Container;

private import mango.containers.Iterator;
private import mango.containers.Util;

/******************************************************************************

	Container is the root class for most of Mango's containers.  It
	provides only the most basic of methods which can be applied to all
	single-valued containers.

******************************************************************************/
abstract class Container(V) {

       /***********************************************************************
        
                Returns true if the container is thread-safe.  A thread safe
		container is defined here as a container which can be accessed
		by multiple threads at the same time with corrupting the
		container or data, and without invalidating any of the
		container's invariants.

        ***********************************************************************/
  	public abstract bit isThreadSafe();


       /***********************************************************************
        
                Creates and returns an Iterator which will recite all of the
		elements in a container.  The behaviour of said Iterator should
		the contents of the container be modified concurrently is not
		generically defined, and it implementation specific.

        ***********************************************************************/
  	public abstract Iterator!(V) iterator();


       /***********************************************************************
        
                Allows iteration through a container using foreach.  The
		behaviour of said iteration is implementation specific should
		the container be modified concurrently.

        ***********************************************************************/
  	public abstract int opApply(int delegate(inout V) dg);


	/***********************************************************************
        
                Returns a copy of the container.  Copies the values of each
		element.  In the case of pointers or references, only the value
       		of the pointer or reference is copied.  No attempt is made to
       		copy the data stored at the location of the pointer or reference.

        ***********************************************************************/
	public abstract Container dup();


	/***********************************************************************
        
                Returns true if the container contains the element specified.

		Unless otherwise specified by the implementation, equality is
		checked using ==, so (in the case of classes and structs)
		opEquals should be overridden.

        ***********************************************************************/
	public abstract bit contains(V item);


	/***********************************************************************
        
                Returns true if the container contains all of the elements in
		the specified container.

		Unless otherwise specified by the implementation, equality is
		checked using ==, so (in the case of classes and structs)
		opEquals should be overridden.

        ***********************************************************************/
	public abstract bit contains(Container c);


	/***********************************************************************
        
                Returns the number of elements in the container.

		An alias to length is provided for conversion from D's
		built-in arrays.

        ***********************************************************************/
	public abstract int size();
	public alias size length;


	/***********************************************************************
        
                The concat method (and aliased ~ operator) don't modify the
		container, they instead return a copy with the specified
		item(s) added to it.

        ***********************************************************************/
	public abstract Container concat(V item);
	public abstract Container concat(Container items);
	public alias concat opCat;


	/***********************************************************************
        
                Returns a Container that contains all the items that the two
		containers have in common.  The type of this container is
		the type of this container (versus the type of the container
		specified).

        ***********************************************************************/	
	public abstract Container intersection(Container container);


	/***********************************************************************
        
                Container-type specific.

        ***********************************************************************/
	public abstract override int opEquals(Object o);


	/***********************************************************************
        
               Provides a hash for the container. 

        ***********************************************************************/
	public abstract override uint toHash();


	/**********************************************************************
	  Comparison operators for the elements
	***********************************************************************/
	public abstract int equals(V a, V b);
	public abstract int cmp(V a, V b);
	public abstract uint hash(V v);
}


/******************************************************************************

	Since a few of the methods in Container are easily implemented using
	some of the other methods, this does it.  These may be overridden.

******************************************************************************/
class AbstractContainer(V) : Container!(V) {
  bit contains(V item) {
    Iterator!(V) iter = iterator();
    while (iter.hasNext)
      if (iter.next == item) return true;
    return false;
  }

  bit contains(Container!(V) c) { //TODO this could be more efficient, using sets
    Iterator!(V) iter = c.iterator();
    while(iter.hasNext) {
      if (!contains(iter.next)) {
	return false;
      }
    }
    return true;
  }

  int opApply(int delegate(inout V) dg) {
    Iterator!(V) iter = iterator();
    while (iter.hasNext()) {
      V v = iter.next;
      if (dg(v) != 0)
	return -1;
    }
    return 0;
  }

  public int equals(V a, V b) {
    return Util!(V).equals(a,b);
  }
  
  public int cmp(V a, V b) {
    return Util!(V).cmp(a,b);
  }
  
  public uint hash(V v) {
    return Util!(V).hash(v);
  }
}


public abstract class ContainerException: Exception {
  this(char[] message) {
    super(message);
  }
}

public class BoundsException: ContainerException {
  this(char[] message) {
    super(message);
  }
  
  this() {
    super("Program went out of bounds on a container");
  }
}


/*
  These are the methods that should be in a MutableContainer.  This interface
  will be created if D gets decent interface support in the future.
 */
/+
interface MutableContainer(V) : Container!(V) {
       /***********************************************************************
        
                Removes everything in the container

       ************************************************************************/
	public abstract MutableContainer clear();	


       /***********************************************************************
        
                Shrinks the container by deleting the specified element or
		elements of the specifiec container.

       ************************************************************************/
	public abstract MutableContainer remove(V item);
	public abstract MutableContainer remove(Container!(V) items);
	public abstract MutableContainer remove(V[] items);


       /***********************************************************************
        
                Removes all of the items from this container that are not
		in the specified container or array.

       ************************************************************************/
	public abstract MutableContainer intersect(Container!(V) items);
	public abstract MutableContainer intersect(V[] items);
}
+/

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
