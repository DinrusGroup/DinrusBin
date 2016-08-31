/*******************************************************************************

        @file VirtualCache.d
        
        Copyright (c) 2004 Kris Bell
        
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

        
        @version        Initial version, April 2004      
        @author         Kris


*******************************************************************************/

module mango.cache.VirtualCache;

private import  mango.cache.QueuedCache;

private import  mango.io.Buffer,
                mango.io.GrowBuffer,
                mango.io.Exception,
                mango.io.PickleReader,
                mango.io.PickleWriter,
                mango.io.ArrayAllocator;

private import  mango.io.model.IPickle,
                mango.io.model.IBitBucket;

private import  mango.cache.model.IPayload;

/******************************************************************************

        Uses a combination of QueuedCache and IBitBucket to spill LRU
        cache entries from cache memory, and then recover them intact.
        Each cache entry placed into a VirtualCache should have support
        for the IPicked interface, such that its content will be written
        externally, and restored correctly. In practical terms, this means
        the IPayload's placed here should override the read(), write(), 
        create() and getGuid() default implementations.

        Here's a contrived example:

        @code
        // create a FileBucket as a place to spill cache entries
        auto FileBucket bucket = new FileBucket (new FilePath("bucket.bin"), FileBucket.HalfK);

        // note that we specify only two entries, to ensure we'll spill 
        // entries to the FileBucket
        VirtualCache cache = new VirtualCache (bucket, 2);

        // need to tell registry how to resurrect our spilled entries
        PickleRegistry.enroll (new Payload);
        
        // stuff a few entries into the cache. Adding the third entry
        // will cause a spillover to the FileBucket
        cache.put ("a", new Payload);
        cache.put ("b", new Payload);
        cache.put ("c", new Payload);

        // retrieve entries such that we cause one more spillage and
        // two resurrections
        assert (cache.get("a"));
        assert (cache.get("c"));
        assert (cache.get("b"));
        @endcode

******************************************************************************/

class VirtualCache : QueuedCache
{
        private GrowBuffer              buffer;
        private IBitBucket              bucket;
        private PickleReader            reader;
        private PickleWriter            writer;

        /**********************************************************************
        
                Create a VirtualCache with the provided IBitBucket and 
                maximum capacity. Said capacity sets the waterline mark
                whereby further additions to the cache will cause least
                recently used entries to be spilled to the IBitBucket.
                The concurrency level indicates approximately how many 
                threads will content for write access at one time.

        **********************************************************************/

        this (IBitBucket bucket, uint capacity, uint concurrency = 16)
        {
                super (capacity, concurrency);
                
                this.bucket = bucket;

                // create an expanding buffer for writing Objects
                this.buffer = new GrowBuffer (bucket.getBufferSize());

                // hook up a writer for serializing Objects
                writer = new PickleWriter (buffer);

                // hook up a reader for Object reconstruction. Note 
                // that buffer content will be set to data returned
                // by the IBitBucket
                reader = new PickleReader (new Buffer);
                reader.setAllocator (new BufferAllocator);
        }

        /**********************************************************************

                Return the IBitBucket used by this VirtualCache

        **********************************************************************/

        IBitBucket getBucket ()
        {
                return bucket;
        }

        /**********************************************************************

                Return an entry from this cache. If the given key is not
                found, we attempt to resurrect the entry via data from 
                our IBitBucket.

                Returns the IPayload upon success, null if the given
                key was never placed into the cache.

        **********************************************************************/

        override IPayload get (char[] key)
        {
                IPayload        e;
                void[]          obj;

                // see if it's already in the cache ...
                if ((e = super.get (key)) is null)
                   {
                   // else try to get it from the IBitBucket ...
                   obj = bucket.get (key);
                   if (obj.length)
                      {
                      // materialize the object, and stuff it into the cache
                      reader.getBuffer.setValidContent (obj);
                      e = cast(IPayload) reader.thaw ();
                      if (e)
                          super.put (key, e);
                      }
                   }
                return e;
        }

        /**********************************************************************

                Remove an entry from this cache, and from the associated
                IBitBucket too.

        **********************************************************************/

        override IPayload extract (char[] key, ulong timeLimit = ulong.max)
        {
                // remove from cache?
                IPayload p = super.extract (key, timeLimit);

                if (p)
                    // remove it from the bucket
                    bucket.remove (key);
                return p;
        }

        /**********************************************************************

                Place an entry into the cache and associate it with the 
                provided key. Note that there can be only one entry for 
                any particular key. If two keys entries are added with 
                the same key, the second one overwrites the first.

                Copy entry to Bucket immediately, so we avoid writing 
                it each time it gets bumped from the cache. 

        **********************************************************************/

        override IPayload put (char[] key, IPayload entry)
        {
                if (super.put (key, entry))
                   {
                   buffer.clear ();
                   writer.freeze (entry);
                   bucket.put (key, buffer.toString);
                   return entry;
                   }
                throw new IOException ("Failed to add cache entry to queue");
        }       
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
