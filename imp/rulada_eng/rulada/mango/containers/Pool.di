/*******************************************************************************

        @file Pool.d

        Copyright (c) 2006 John Demme
        
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

      
        @version        Initial version, January 2006
        @author         John Demme (me@teqdruid.com)


*******************************************************************************/

module mango.containers.Pool;

private import	mango.containers.LinkedList,
		mango.containers.ThreadSafeList;

/**
	Provides a pool of something (T).  Backed by a linked list.  Doesn't keep
	track of borrowed items.  Thread safe.  Resizable.
*/
public class Pool(T): ThreadSafeList!(T)
{
	public alias T delegate() Ctor;
	public alias size spare;
	protected Ctor ctor;

	/**
		Give it a delegate to a method that will return a new item.
		This method will be called each time a new item is put into the pool.
	*/
	public this(Ctor ctor)
	{
		super(new LinkedList!(T)());
		this.ctor = ctor;
	}

	/**
		Borrow an item from the pool.  Like a forgetful friend, the pool doesn't
		know if you never return it.
	*/
	public T getItem()
	{    
		try
		{
			myRwl.writeLock().lock();
			if (size() == 0)
				return ctor();
			else
				return removeIndex(0);
		}
		finally
		{
			myRwl.writeLock().unlock();
		}
	}

	/**
		Ensure that there are at least a given number of spare items in the pool.
	*/
	public void populateSpareTo(uint items)
	{
		while (this.size < items)
			append(ctor());
	}

	/**
		Ensure that there are no more than a given number of items in the pool.
	*/
	public void shrinkSpareTo(uint items)
	{
		while (this.size > items) {
			T item = removeIndex(0);
			delete item;
		}
	}

	/**
		Puts an item back in the pool.
	*/
	public void returnItem(T item)
	{
		append(item);
	}
}
version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
