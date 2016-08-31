/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module dcollections.DefaultAllocator;

version(Tango)
{
    version(DDoc)
    {
    }
    else
    {
        private import tango.stdc.string;
        private import tango.core.Memory;
    }
}
else
{
    version(DDoc)
    {
    }
    else
    {
        private import std.c;
    }
}

version(Tango)
{
    /**
     * Allocate a chunk of elements at once, then use the chunk to return
     * elements.  This makes allocating individual elements more efficient
     * because the GC isn't used for allocating every element, only every
     * chunk of elements.
     *
     * The only requirement is that the size of V is >= size of a pointer.
     * This is because the data V contains is used as a pointer when freeing
     * the element.
     *
     * If an entire chunk of elements is freed, that chunk is then returned to
     * the GC.
     */
    struct ChunkAllocator(V, uint elemsPerChunk)
    {
        /**
         * Free is needed to recycle nodes for another allocation.
         */
        const bool freeNeeded = true;
        static if(V.sizeof < (void*).sizeof)
        {
            static assert(false, "Error, allocator for " ~ V.stringof ~ " failed to instantiate");
        }

        /**
         * This is the form used to link recyclable elements together.
         */
        struct element
        {
            element *next;
        }

        /**
         * A chunk of elements
         */
        struct chunk
        {
            /**
             * The next chunk in the chain
             */
            chunk *next;

            /**
             * The previous chunk in the chain.  Required for O(1) removal
             * from the chain.
             */
            chunk *prev;

            /**
             * The linked list of free elements in the chunk.  This list is
             * amended each time an element in this chunk is freed.
             */
            element *freeList;

            /**
             * The number of free elements in the freeList.  Used to determine
             * whether this chunk can be given back to the GC
             */
            uint numFree;

            /**
             * The elements in the chunk.
             */
            V[elemsPerChunk] elems;

            /**
             * Allocate a V* from the free list.
             */
            V *allocateFromFree()
            {
                element *x = freeList;
                freeList = x.next;
                //
                // clear the pointer, this clears the element as if it was
                // newly allocated
                //
                x.next = null;
                numFree--;
                return cast(V*)x;
            }

            /**
             * deallocate a V*, send it to the free list
             *
             * returns true if this chunk no longer has any used elements.
             */
            bool deallocate(V *v)
            {
                //
                // clear the element so the GC does not interpret the element
                // as pointing to anything else.
                //
                memset(v, 0, (V).sizeof);
                element *x = cast(element *)v;
                x.next = freeList;
                freeList = x;
                return (++numFree == elemsPerChunk);
            }
        }

        /**
         * The chain of used chunks.  Used chunks have had all their elements
         * allocated at least once.
         */
        chunk *used;

        /**
         * The fresh chunk.  This is only used if no elements are available in
         * the used chain.
         */
        chunk *fresh;

        /**
         * The next element in the fresh chunk.  Because we don't worry about
         * the free list in the fresh chunk, we need to keep track of the next
         * fresh element to use.
         */
        uint nextFresh;

        /**
         * Allocate a V*
         */
        V* allocate()
        {
            if(used !is null && used.numFree > 0)
            {
                //
                // allocate one element of the used list
                //
                V* result = used.allocateFromFree();
                if(used.numFree == 0)
                    //
                    // move used to the end of the list
                    //
                    used = used.next;
                return result;
            }

            //
            // no used elements are available, allocate out of the fresh
            // elements
            //
            if(fresh is null)
            {
                fresh = new chunk;
                nextFresh = 0;
            }

            V* result = &fresh.elems[nextFresh];
            if(++nextFresh == elemsPerChunk)
            {
                if(used is null)
                {
                    used = fresh;
                    fresh.next = fresh;
                    fresh.prev = fresh;
                }
                else
                {
                    //
                    // insert fresh into the used chain
                    //
                    fresh.prev = used.prev;
                    fresh.next = used;
                    fresh.prev.next = fresh;
                    fresh.next.prev = fresh;
                    if(fresh.numFree != 0)
                    {
                        //
                        // can recycle elements from fresh
                        //
                        used = fresh;
                    }
                }
                fresh = null;
            }
            return result;
        }

        /**
         * free a V*
         */
        void free(V* v)
        {
            //
            // need to figure out which chunk v is in
            //
            chunk *cur = cast(chunk *)GC.addrOf(v);

            if(cur !is fresh && cur.numFree == 0)
            {
                //
                // move cur to the front of the used list, it has free nodes
                // to be used.
                //
                if(cur !is used)
                {
                    if(used.numFree != 0)
                    {
                        //
                        // first, unlink cur from its current location
                        //
                        cur.prev.next = cur.next;
                        cur.next.prev = cur.prev;

                        //
                        // now, insert cur before used.
                        //
                        cur.prev = used.prev;
                        cur.next = used;
                        used.prev = cur;
                        cur.prev.next = cur;
                    }
                    used = cur;
                }
            }

            if(cur.deallocate(v))
            {
                //
                // cur no longer has any elements in use, it can be deleted.
                //
                if(cur.next is cur)
                {
                    //
                    // only one element, don't free it.
                    //
                }
                else
                {
                    //
                    // remove cur from list
                    //
                    if(used is cur)
                    {
                        //
                        // update used pointer
                        //
                        used = used.next;
                    }
                    cur.next.prev = cur.prev;
                    cur.prev.next = cur.next;
                    delete cur;
                }
            }
        }

        /**
         * Deallocate all chunks used by this allocator.
         */
        void freeAll()
        {
            used = null;

            //
            // keep fresh around
            //
            if(fresh !is null)
            {
                nextFresh = 0;
                fresh.freeList = null;
            }
        }
    }
}

/**
 * Simple allocator uses new to allocate each element
 */
struct SimpleAllocator(V)
{
    /**
     * new doesn't require free
     */
    const bool freeNeeded = false;

    /**
     * equivalent to new V;
     */
    V* allocate()
    {
        return new V;
    }
}

/**
 * Default allocator selects the correct allocator depending on the size of V.
 */
template DefaultAllocator(V)
{
    //
    // if there will be more than one V per page, use the chunk allocator,
    // otherwise, use the simple allocator.  Note we can only support
    // ChunkAllocator on Tango.
    //
    version(Tango)
    {
        static if((V).sizeof + ((void*).sizeof * 3) + uint.sizeof >= 4095 / 2)
        {
            alias SimpleAllocator!(V) DefaultAllocator;
        }
        else
        {
            alias ChunkAllocator!(V, (4095 - ((void *).sizeof * 3) - uint.sizeof) / (V).sizeof) DefaultAllocator;
        }
    }
    else
    {
        alias SimpleAllocator!(V) DefaultAllocator;
    }
}
