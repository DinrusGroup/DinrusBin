/******************************************************************************* 

	A simple freelist implementation

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 
	
	Description:    
	A mixin to allow classes and structs to use fast allocations / 
	de-allocations, using a free list.
		
	This can be on the order of 40-80x faster than new / delete. 

	Examples:
	--------------------
		class Vector
		{ mixin FreeListAllocator; }
		
		auto vec = Vector.allocate(); // use instead of new
		
		// use vec, but note that vec isn't a freshly initialized instance and
		// can (and probably will!) contain old data
		
		Vector.free(vec); // use instead of delete
	--------------------

*******************************************************************************/

module arc.memory.freelist; 

/**
	Provides allocate/free methods to allocate and deallocate to and from a pool.
	
	Note that a call to allocate does not neccessarily call the constructor or
	initialize the object in any way. Basically you get an old instance that was
	previously discarded with a call to free.
**/
template FreeListAllocator()
{
	private alias typeof(this) T;
	
	// start of the memory pool of currently unused instances
	private static T freelist;
	// next instance
	private T next;

	/*** Used to quickly allocate a type T. (only fast if there's one waiting in the free list).
	   Just remember to call free() on it when finished (not delete!).
	   Also keep in mind that the new type T will contain memory garbage and needs to be set.
	*/
	static T allocate()
	{
		T instance;
		
		if (freelist)
		{
			instance = freelist;
			freelist = instance.next;
		}
		else 
			instance = new T();
		
		return instance;
	}

	/// Place this type T back on a free list for the next allocate.
	static void free(T goodbye)
	{
		goodbye.next = freelist;
		freelist = goodbye;
	}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
