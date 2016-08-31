/*******************************************************************************

        @file LinkedList.d

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

module mango.containers.LinkedList;

import mango.containers.Container;
import mango.containers.List;
import mango.containers.Iterator;


/******************************************************************************
	
	Implements a MutableList.  Implemented using a doubly linked list

******************************************************************************/
public class LinkedList(V) : AbstractMutableList!(V) {
  static private struct Node {
    Node* next;
    Node* prev;
    V value;
  }

  private Node* root;
  private Node* end;
  private int length;

  class LinkedListIterator: MutableIterator!(V) {
    Node* curr;
    Node* last;
        
    this () {
      curr = root;
    }
    
    public bit hasNext() {
      return (curr != null);
    }
    
    public V next() {
      if (curr == null) {
	throw new BoundsException();
      }
      
      last = curr;
      curr = curr.next;
      return last.value;
    }
    
    public void remove() {
      removeNode(last);
    }
  }

  protected Node* getNode(int i) {
    if (i>=length) {
      throw new BoundsException();
    }

    Node* curr;
    if (i<=length/2) { //Go from front
      curr = root;
      while (i-- > 0) {
	curr = curr.next;
      }
    } else { //Go from back
      curr = end;
      i = length-i;
      while (--i > 0) {
	curr = curr.prev;
      }
    }

    return curr;
  }

  this() {
    root = null;
    end = null;
    length = 0;
  }

  this(Container!(V) items) {
    this();
    foreach(V item; items) {
      this ~= item;
    }
  }

  this(V[] array) {
    this();
    foreach(V item; array) {
      this ~= item;
    }
  }
  
  //Methods from Container
  bit isThreadSafe() {
    return false;
  }

  //LinkedListIterator iterator() {
  //  return new LinkedListIterator();
  //}

  LinkedList dup() {
    return new LinkedList(this);
  }

  int size() {
    return length;
  }

  //Methods from List
  V get(int i) {
    return getNode(i).value;
  }

  /***********************************************************************
        
	Returns a new List containing the ith element through the
	(j-1)th element.  Copies the data.

  ***********************************************************************/
  LinkedList subList(int i, int j) {
    if (i < 0 || i >= length || j < 0 || j >= length || j < i) {
      throw new BoundsException();
    }

    LinkedList ret = new LinkedList;
    Node* curr = getNode(i);
    while (i++<j) {
      ret ~= curr.value;
      curr = curr.next;
    }

    return ret;
  }

  V[] toArray() {
    V[] ret;
    foreach(V item; this) {
      ret ~= item;
    }
    return ret;
  }

  //Methods from MutableList
  LinkedList assign(V item, int i, bit grow = false) {
    if (grow && i>=length) {
      int add = i - length + 1;
      while (add-- > 0) {
	end.next = new Node;
	end.next.prev = end;
	end = end.next;
	length++;
      }
      end.value = item;
    } else {
      getNode(i).value = item;
    }
    return this;
  }

  LinkedList insertAfter(int i, V item) {
    Node* iNode = getNode(i);
    Node* nNode = new Node;
    nNode.value = item;
    if (iNode == null) {
      root = nNode;
      end = nNode;
    } else {
      if (iNode.next != null) {
	iNode.next.prev = nNode;
      } else {
	assert(end is iNode);
	end = nNode;
      }
      nNode.prev = iNode;
      nNode.next = iNode.next;
      iNode.next = nNode;
    }

    length++;
    return this;
  }

  LinkedList insertBefore(int i, V item) {
    Node* iNode = getNode(i);
    Node* nNode = new Node;
    nNode.value = item;
    if (iNode == null) {
      root = nNode;
      end = nNode;
    } else {
      if (iNode.prev != null) {
	iNode.prev.next = nNode;
      } else {
	assert(root is iNode);
	root = nNode;
      }
      nNode.next = iNode;
      nNode.prev = iNode.prev;
      iNode.prev = nNode;
    }

    length++;
    return this;
  }

  LinkedList append(V item) {
    Node* nNode = new Node;
    nNode.value = item;
    if (root == null) {
      root = nNode;
    } else {
      nNode.prev = end;
      end.next = nNode;
    }
    end = nNode;
    length++;
    return this;
  }

  LinkedList prepend(V item) {
    Node* nNode = new Node;
    nNode.value = item;
    if (end == null) {
      end = nNode;
    } else {
      nNode.next = root;
      root.prev = nNode;
    }
    root = nNode;
    length++;
    return this;
  }

  protected V removeNode(Node* node) {
    if (node.prev != null) {
      node.prev.next = node.next;
    } else {
      root = node.next;
    }

    if (node.next != null) {
      node.next.prev = node.prev;
    } else {
      end = node.prev;
    }

    length--;
    return node.value;
  }

  V removeIndex(int i) {
    return removeNode(getNode(i));
  }

  LinkedList clear() {
    length = 0;
    root = null;
    end = null;
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
