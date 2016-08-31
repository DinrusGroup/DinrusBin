/*******************************************************************************

        @file FileBucket.d
        
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
           of the source.


        @version        Initial version, April 2004
        @author         Kris


*******************************************************************************/


module mango.io.FileBucket;

public  import  mango.io.FilePath;

private import  mango.io.Exception,
                mango.io.FileConduit;

private import  mango.io.model.IBitBucket;

/******************************************************************************

        FileBucket implements a simple mechanism to store and recover a 
        large quantity of data for the duration of the hosting process.
        It is intended to act as a local-cache for a remote data-source, 
        or as a spillover area for large in-memory cache instances. 
        
        Note that any and all stored data is rendered invalid the moment
        a FileBucket object is garbage-collected.

        The implementation follows a fixed-capacity record scheme, where
        content can be rewritten in-place until said capacity is reached.
        At such time, the altered content is moved to a larger capacity
        record at end-of-file, and a hole remains at the prior location.
        These holes are not collected, since the lifespan of a FileBucket
        is limited to that of the host process.

        All index keys must be unique. Writing to the FileBucket with an
        existing key will overwrite any previous content. What follows
        is a contrived example:
        
        @code
        char[] text = "this is a test";

        FileBucket bucket = new FileBucket (new FilePath("bucket.bin"), FileBucket.HalfK);

        // insert some data, and retrieve it again
        bucket.put ("a key", text);
        char[] b = cast(char[]) bucket.get ("a key");

        assert (b == text);
        bucket.close();
        @endcode

******************************************************************************/

class FileBucket : IBitBucket
{
        /**********************************************************************

                Define the capacity (block-size) of each record

        **********************************************************************/

        struct BlockSize
        {
                int capacity;
        }

        // basic capacity for each record
        private FilePath                path;

        // basic capacity for each record
        private BlockSize               block;

        // where content is stored
        private FileConduit             file;

        // pointers to file records
        private Record[char[]]          map;

        // current file size
        private ulong                   fileSize;

        // current file usage
        private ulong                   waterLine;

        // supported block sizes
        static const BlockSize          EighthK  = {128-1},
                                        HalfK    = {512-1},
                                        OneK     = {1024*1-1},
                                        TwoK     = {1024*2-1},
                                        FourK    = {1024*4-1},
                                        EightK   = {1024*8-1},
                                        SixteenK = {1024*16-1},
                                        ThirtyTwoK = {1024*32-1},
                                        SixtyFourK = {1024*64-1};

        /**********************************************************************

                Construct a FileBucket with the provided path and record-
                size. Selecting a record size that roughly matches the 
                serialized content will limit 'thrashing'.

        **********************************************************************/

        this (FilePath path, BlockSize block)
        {
                this (path, block, 100);
        }

        /**********************************************************************

                Construct a FileBucket with the provided path, record-size,
                and inital record count. The latter causes records to be 
                pre-allocated, saving a certain amount of growth activity.
                Selecting a record size that roughly matches the serialized 
                content will limit 'thrashing'. 

        **********************************************************************/

        this (FilePath path, BlockSize block, uint initialRecords)
        {
                this.path = path;
                this.block = block;

                // open a storage file
                file = new FileConduit (path, FileStyle.ReadWriteCreate);

                // set initial file size (can be zero)
                fileSize = initialRecords * block.capacity;
                file.seek (fileSize);
                file.truncate ();
        }

        /**********************************************************************

                Return the block-size in use for this FileBucket

        **********************************************************************/

        int getBufferSize ()
        {
                return block.capacity+1;
        }

        /**********************************************************************
        
                Return where the FileBucket is located

        **********************************************************************/

        FilePath getFilePath ()
        {
                return path;
        }

        /**********************************************************************

                Return the currently populated size of this FileBucket

        **********************************************************************/

        synchronized ulong length ()
        {
                return waterLine;
        }

        /**********************************************************************

                Return the serialized data for the provided key. Returns
                null if the key was not found.

        **********************************************************************/

        synchronized void[] get (char[] key)
        {
                Record r = null;

                if (key in map)
                   {
                   r = map [key];
                   return r.read (this);
                   }
                return null;
        }

        /**********************************************************************

                Remove the provided key from this FileBucket.

        **********************************************************************/

        synchronized void remove (char[] key)
        {
                map.remove(key);
        }

        /**********************************************************************

                Write a serialized block of data, and associate it with
                the provided key. All keys must be unique, and it is the
                responsibility of the programmer to ensure this. Reusing 
                an existing key will overwrite previous data. 

                Note that data is allowed to grow within the occupied 
                bucket until it becomes larger than the allocated space.
                When this happens, the data is moved to a larger bucket
                at the file tail.

        **********************************************************************/

        synchronized void put (char[] key, void[] data)
        {
                Record* r = key in map;

                if (r is null)
                   {
                   Record rr = new Record ();
                   map [key] =  rr;
                   r = &rr;
                   }
                r.write (this, data, block);
        }

        /**********************************************************************

                Close this FileBucket -- all content is lost.

        **********************************************************************/

        synchronized void close ()
        {
                if (file)
                   {
                   file.close ();
                   file = null;
                   map = null;
                   }
        }

        /**********************************************************************

                Each Record takes up a number of 'pages' within the file. 
                The size of these pages is determined by the BlockSize 
                provided during FileBucket construction. Additional space
                at the end of each block is potentially wasted, but enables 
                content to grow in size without creating a myriad of holes.

        **********************************************************************/

        private class Record
        {
                private ulong           offset;
                private int             length,
                                        capacity = -1;

                /**************************************************************

                **************************************************************/

                private static void eof (FileBucket bucket)
                {
                        throw new IOException ("Unexpected EOF in FileBucket '"~bucket.path.toString()~"'");
                }

                /**************************************************************

                        This should be protected from thread-contention at
                        a higher level.

                **************************************************************/

                void[] read (FileBucket bucket)
                {
                        void[] data = new ubyte [length];

                        bucket.file.seek (offset);
                        if (bucket.file.read (data) != length)
                            eof (bucket);

                        return data;
                }

                /**************************************************************

                        This should be protected from thread-contention at
                        a higher level.

                **************************************************************/

                void write (FileBucket bucket, void[] data, BlockSize block)
                {
                        length = data.length;

                        // create new slot if we exceed capacity
                        if (length > capacity)
                            createBucket (bucket, length, block);

                        // locate to start of content 
                        bucket.file.seek (offset);
        
                        // write content
                        if (bucket.file.write (data) != length)
                            eof (bucket);
                }

                /**************************************************************

                **************************************************************/

                void createBucket (FileBucket bucket, int bytes, BlockSize block)
                {
                        offset = bucket.waterLine;
                        capacity = (bytes + block.capacity) & ~block.capacity;

                        bucket.waterLine += capacity;
                        if (bucket.waterLine > bucket.fileSize)
                           {
                           // grow the filesize 
                           bucket.fileSize = bucket.waterLine * 2;

                           // expand the physical file size
                           bucket.file.seek (bucket.fileSize);
                           bucket.file.truncate ();
                           }
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
