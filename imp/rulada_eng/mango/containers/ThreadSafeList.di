/*******************************************************************************

        @file ThreadSafeList.d

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

module mango.containers.ThreadSafeList;

private import mango.containers.Container, 
	       mango.containers.List,
	       mango.containers.Iterator;

private import mango.locks.ReadWriteLock;

/******************************************************************************
	
	Creates a thread safe MutableList by wrapping an existing MutableList
	instance and making calls to it within lock and unlock calls to a
	ReentrantReadWriteLock.

******************************************************************************/
public class ThreadSafeList(V): AbstractMutableList!(V) {
  private MutableList!(V) myList;
  protected ReentrantReadWriteLock myRwl;

  /***********************************************************************
        
	Will make thread-safe calls to the passed "wrappedList".  Takes
	ownership of the list- does NOT copy.  You must abandon all
	references to this List after passing it here.

  ***********************************************************************/
  this(MutableList!(V) wrappedList) {
    myList = wrappedList;
    myRwl = new ReentrantReadWriteLock();
  }

  //Methods from Container
  bit isThreadSafe() {
    return true;
  }

  MutableList!(V) dup() {
    try {
      myRwl.readLock().lock();
      return myList.dup();
    } finally {
      myRwl.readLock().unlock();
    }
  }

  int size() {
    try {
      myRwl.readLock().lock();
      return myList.size();
    } finally {
      myRwl.readLock().unlock();
    }
  }

  //Methods from List
  V get(int i) {
    try {
      myRwl.readLock().lock();
      return myList.get(i);
    } finally {
      myRwl.readLock().unlock();
    }
  }

  /***********************************************************************
        
	Returns a new List containing the ith element through the
	(j-1)th element.  Copies the data.

  ***********************************************************************/
  ThreadSafeList subList(int i, int j) {
    try {
      myRwl.readLock().lock();
      MutableList!(V) ml = myList.subList(i,j);
      return new ThreadSafeList(ml);
    } finally {
      myRwl.readLock().unlock();
    }
  }
  
  V[] toArray() {
    try {
      myRwl.readLock().lock();
      return myList.toArray();
    } finally {
      myRwl.readLock().unlock();
    }
  }

  //Methods from MutableList
  ThreadSafeList assign(V item, int i, bit grow = false) {
    try {
      myRwl.writeLock().lock();
      myList.assign(item,i,grow);
      return this;
    } finally {
      myRwl.writeLock().unlock();
    }
  }

  ThreadSafeList insertAfter(int i, V item) {
    try {
      myRwl.writeLock().lock();
      myList.insertAfter(i,item);
      return this;
    } finally {
      myRwl.writeLock().unlock();
    }
  }

  ThreadSafeList insertBefore(int i, V item) {
    try {
      myRwl.writeLock().lock();
      myList.insertBefore(i,item);
      return this;
    } finally {
      myRwl.writeLock().unlock();
    }
  }

  ThreadSafeList append(V item) {
    try {
      myRwl.writeLock().lock();
      myList.append(item);
      return this;
    } finally {
      myRwl.writeLock().unlock();
    }
  }

  ThreadSafeList prepend(V item) {
    try {
      myRwl.writeLock().lock();
      myList.prepend(item);
      return this;
    } finally {
      myRwl.writeLock().unlock();
    }
  }  

  V removeIndex(int i) {
   try {
     myRwl.writeLock().lock();
     return myList.removeIndex(i);
   } finally {
     myRwl.writeLock().unlock();
   }
  }

  ThreadSafeList clear() {
    try {
      myRwl.writeLock().lock();
      myList.clear();
      return this;
    } finally {
      myRwl.writeLock().unlock();
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
