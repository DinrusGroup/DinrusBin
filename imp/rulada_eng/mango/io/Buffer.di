/*******************************************************************************

        @file Buffer.d

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

      
        @version        Initial version; March 2004

        @author         Kris


*******************************************************************************/

module mango.io.Buffer;

private import  mango.io.Exception;

public  import  mango.io.model.IBuffer;

public  import  mango.io.model.IConduit;


/******************************************************************************

******************************************************************************/

extern (C)
{
        void * memcpy (void *dst, void *src, uint);
}       

/*******************************************************************************

        The basic premise behind this IO package is as follows:

        @li The central concept is that of a buffer. The buffer acts
           as a queue (line) where items are removed from the front
           and new items are added to the back. Buffers are modeled 
           by mango.io.model.IBuffer, and a concrete implementation is 
           provided this class.

        @li Buffers can be written to directly, but a Reader and/or
           Writer are typically used to read & write formatted data.
           These readers & writers are bound to a specific buffer;
           often the same buffer. It's also perfectly legitimate to 
           bind multiple writers to the same buffer; they will all
           behave serially as one would expect. The same applies to
           multiple readers on the same buffer. Readers and writers
           support three styles of IO: put/get, the C++ style << &
           >> operators, and the () whisper style. All operations 
           can be chained.

        @li Any class can be made compatable with the reader/writer
           framework by implementing the IReadable and/or IWritable 
           interfaces. Each of these specify just a single method.
           Once compatable, the class can simply be passed to the 
           reader/writer as if it were native data.

        @li Buffers may also be tokenized. This is handy when one is
           dealing with text input, and/or the content suits a more
           fluid format than most typical readers & writers support.
           Tokens are mapped directly onto buffer content, so there
           is only minor overhead in using them. Tokens can be read
           and written by reader/writers also, using a more relaxed
           set of rules than those applied to discrete I/O.

        @li Buffers are sometimes memory-only, in which case there
           is nothing left to do when a reader (or tokenizer) hits
           end of buffer conditions. Other buffers are themselves 
           bound to a Conduit. When this is the case, a reader will 
           eventually cause the buffer to reload via its associated 
           conduit. Previous buffer content will thus be lost. The
           same concept is applied to writers, whereby they flush 
           the content of a full buffer to a bound conduit before 
           continuing. 

        @li Conduits provide virtualized access to external content,
           and represent things like files or Internet connections.
           They are just a different kind of stream. Conduits are
           modelled by mango.io.model.IConduit, and implemented via
           classes FileConduit and SocketConduit. Additional kinds
           of conduit are easy to construct: one either subclasses
           mango.io.Conduit, or implements mango.io.model.IConduit. 
           A conduit reads and writes from/to a buffer in big chunks
           (typically the entire buffer).

        @li Conduits may have one or more filters attached. These 
            will process content as it flows back and forth across
            the conduit. Filter examples include compression, utf
            transcoding, and endian transformation. These filters
            apply to the entire scope of the conduit, rather than
            being specific to one data-type or another.

        @li Readers & writers may have a transcoder attached. The
           role of a transcoder is to aid in converting between each
           representation of text (utf8, utf16, utf32). They're used
           to normalize string I/O according to a standard text-type.
           By default there is no transcoder attached, and the type
           is therefore considered "raw".           


        An example of how to append a buffer follows:

        @code
        char[] foo = "to write some D";

        // create a small buffer
        auto buf = new Buffer (256);

        // append some text directly to it
        buf.append("now is the time for all good men ").append(foo);

        // output the combined string
        Cout (buf.toString);
        @endcode

        Alternatively, one might use a Writer to append the buffer:

        @code
        auto write = new Writer (new Buffer(256));
        write ("now is the time for all good men "c) (foo);
        @endcode

        Or, using printf-like formatting:

        @code
        auto write = new DisplayWriter (new Buffer(256));
        write.print ("now is the time for %d good men %s", 3, foo);
        @endcode

        You might use a GrowBuffer instead where you wish to 
        append beyond a preset limit. One common usage of buffers 
        is in conjunction with a conduit, such as FileConduit. Each 
        conduit exposes a preferred-size for its associated buffers, 
        utilized during Buffer construction:

        @code
        auto file = new FileConduit ("file.name");
        auto buf = new Buffer (file);
        @endcode

        However, this is typically hidden by higher level constructors 
        such as those of Reader and Writer derivitives. For example:

        @code
        auto file = new FileConduit ("file.name");
        auto read = new Reader (file);
        @endcode

        There is indeed a buffer between the Reader and Conduit, but 
        explicit construction is unecessary in most cases.  See both 
        Reader and Writer for examples of formatted IO.

        Stdout is a predefined DisplayWriter, attached to a conduit
        representing the console. Thus, all conduit operations are
        legitimate on Stdout and Stderr:

        @code
        Stdout.conduit.copy (new FileConduit ("readme.txt"));
        @endcode

        In addition to the standard writer facilities, Stdout also has
        support for formatted output:

        @code 
        Stdout.println ("now is the time for %d good men %s", 3, foo);
        @endcode

        Buffers are useful for many purposes within Mango, but there
        are times when it is more straightforward to avoid them. For
        such cases, conduit derivatives (such as FileConduit) support
        direct I/O via a pair of read() and write() methods. These 
        alternate methods will also invoke any attached filters.


*******************************************************************************/

class Buffer : IBuffer
{
        protected void[]        data;
        protected Style         style;
        protected uint          limit;
        protected uint          capacity;
        protected uint          position;
        protected IConduit      conduit;

        protected static char[] overflow  = "output buffer overflow";
        protected static char[] underflow = "input buffer underflow";
        protected static char[] eofRead   = "end-of-file whilst reading";
        protected static char[] eofWrite  = "end-of-file whilst writing";

        /***********************************************************************
        
                Ensure the buffer remains valid between method calls
                 
        ***********************************************************************/

        invariant 
        {
               assert (position <= limit);
               assert (limit <= capacity);
        }

        /***********************************************************************
        
                Construct a Buffer upon the provided conduit

        ***********************************************************************/

        this (IConduit conduit)
        {
                this (conduit.bufferSize);
                setConduit (conduit);
                this.style = conduit.isTextual ? Text : Binary;
        }

        /***********************************************************************
        
                Construct a Buffer with the specified number of bytes.

        ***********************************************************************/

        this (uint capacity=0)
        {
                this (new ubyte[capacity]);              
        }

        /***********************************************************************
        
                Prime buffer with an application-supplied array. There is 
                no readable data present, and writing begins at position 0.

        ***********************************************************************/

        this (void[] data)
        {
                this (data, 0);
        }

        /***********************************************************************
        
                Prime buffer with an application-supplied array, and 
                indicate how much readable data is already there. A
                write operation will begin writing immediately after
                the existing content.

        ***********************************************************************/

        this (void[] data, uint readable)
        {
                setContent (data, readable);
        }

        /***********************************************************************
        
                Throw an exception with the provided message

        ***********************************************************************/

        final void error (char[] msg)
        {
                throw new IOException (msg);
        }

        /***********************************************************************
                
                Return the backing array

        ***********************************************************************/

        protected void[] getContent ()
        {
                return data;
        }

        /***********************************************************************
                
                Return style of buffer

        ***********************************************************************/

        Style getStyle ()
        {
                return style;
        }

        /***********************************************************************
        
                Set the backing array with all content readable. Writing
                to this will either flush it to an associated conduit, or
                raise an Eof condition. Use IBuffer.clear() to reset the
                content (make it all writable).

        ***********************************************************************/

        IBuffer setValidContent (void[] data)
        {
                return setContent (data, data.length);
        }

        /***********************************************************************
        
                Set the backing array with some content readable. Writing
                to this will either flush it to an associated conduit, or
                raise an Eof condition. Use IBuffer.clear() to reset the
                content (make it all writable).

        ***********************************************************************/

        IBuffer setContent (void[] data, uint readable=0)
        {
                this.data = data;
                this.limit = readable;
                this.capacity = data.length;   

                // reset to start of input
                this.position = 0;

                return this;            
        }

        /***********************************************************************
        
                Bulk copy of data from 'src'. Limit is adjusted by 'size'
                bytes.

        ***********************************************************************/

        protected void copy (void *src, uint size)
        {
                data[limit..limit+size] = src[0..size];
                limit += size;
        }

        /***********************************************************************
        
                Read a chunk of data from the buffer, loading from the
                conduit as necessary. The specified number of bytes is
                loaded into the buffer, and marked as having been read 
                when the 'eat' parameter is set true. When 'eat' is set
                false, the read position is not adjusted.

                Returns the corresponding buffer slice when successful, 
                or null if there's not enough data available (Eof; Eob).

        ***********************************************************************/

        void[] get (uint size, bool eat = true)
        {   
                if (size > readable)
                   {
                   if (conduit is null)
                       error (underflow);

                   // make some space? This will try to leave as much content
                   // in the buffer as possible, such that entire records may
                   // be aliased directly from within. 
                   if (size > writable)
                      {
                      if (size > capacity)
                          error (underflow);
                      compress ();
                      }

                   // populate tail of buffer with new content
                   do {
                      if (fill(conduit) == IConduit.Eof)
                          error (eofRead);
                      } while (size > readable);
                   }

                uint i = position;
                if (eat)
                    position += size;
                return data [i .. i + size];               
        }

        /***********************************************************************
        
                Fill the provided array with content. We try to satisfy 
                the request from the buffer content, and read directly
                from the conduit where more is required.

                Returns true if the request was satisfied; false otherwise

        ***********************************************************************/

        bool get (void[] dst)
        {   
                // copy the buffer remains
                int i = readable ();
                if (i > dst.length)
                    i = dst.length;
                dst[0..i] = get(i);

                // and get the rest directly from conduit
                if (i < dst.length)
                    if (conduit)
                        return conduit.fill (dst [i..$]);
                    else
                       return false;
                return true;
        }

        /***********************************************************************
        
                Wait for something to arrive in the buffer. This may stall
                the current thread forever, although usage of SocketConduit 
                will take advantage of the timeout facilities provided there.

        ***********************************************************************/

        void wait ()
        {       
                get (1, false);
        }

        /***********************************************************************
        
                Append an array of data to this buffer, and flush to the
                conduit as necessary. Returns a chaining reference if all 
                data was written; throws an IOException indicating eof or 
                eob if not.

                This is often used in lieu of a Writer.

        ***********************************************************************/

        IBuffer append (void[] src)        
        {               
                uint size = src.length;

                if (size > writable)
                    // can we write externally?
                    if (conduit)
                       {
                       flush ();

                       // check for pathological case
                       if (size > capacity)
                          {
                          conduit.flush (src);
                          return this;
                          }
                       }
                    else
                       error (overflow);

                copy (cast(void*) src, size);
                return this;
        }

        /***********************************************************************
        
                Return a char[] slice of the buffer up to the limit of
                valid content.

        ***********************************************************************/

        override char[] toString ()
        {       
                return cast(char[]) data[position..limit];
        }

        /***********************************************************************
        
                Skip ahead by the specified number of bytes, streaming from 
                the associated conduit as necessary.
        
                Can also reverse the read position by 'size' bytes. This may
                be used to support lookahead-type operations.

                Returns true if successful, false otherwise.

        ***********************************************************************/

        bool skip (int size)
        {
                if (size < 0)
                   {
                   size = -size;
                   if (position >= size)
                      {
                      position -= size;
                      return true;
                      }
                   return false;
                   }
                return cast(bool) (get (size) !is null);
        }

        /***********************************************************************
        
                Support for tokenizing iterators. 
                
                Upon success, the delegate should return the byte-based 
                index of the consumed pattern (tail end of it). Failure
                to match a pattern should be indicated by returning an
                IConduit.Eof

                Each pattern is expected to be stripped of the delimiter.
                An end-of-file condition causes trailing content to be 
                placed into the token. Requests made beyond Eof result
                in empty matches (length == zero).

                Note that additional iterator and/or reader instances
                will stay in lockstep when bound to a common buffer.

                Returns true if a token was isolated, false otherwise.

        ***********************************************************************/

        bool next (uint delegate (void[]) scan)
        {
                while (read(scan) is IConduit.Eof)
                       if (conduit is null)
                          {
                          skip (readable);
                          return false;
                          }
                       else
                          {
                          // did we start at the beginning?
                          if (getPosition)
                              // nope - move partial token to start of buffer
                              compress ();
                          else
                             // no more space in the buffer?
                             if (writable is 0)
                                 error ("Token is too large to fit within buffer");

                          // read another chunk of data
                          if (fill(conduit) is IConduit.Eof)
                             {
                             skip (readable);
                             return false;
                             }
                          }
                return true;
        }

        /***********************************************************************
        
                Return count of readable bytes remaining in buffer. This is 
                calculated simply as limit() - position()

        ***********************************************************************/

        uint readable ()
        {
                return limit - position;
        }               

        /***********************************************************************
        
                Return count of writable bytes available in buffer. This is 
                calculated simply as capacity() - limit()

        ***********************************************************************/

        uint writable ()
        {
                return capacity - limit;
        }               

        /***********************************************************************

                Exposes the raw data buffer at the current write position, 
                The delegate is provided with a void[] representing space
                available within the buffer at the current write position.

                The delegate should return the appropriate number of bytes 
                if it writes valid content, or IConduit.Eof on error.

                Returns whatever the delegate returns.

        ***********************************************************************/

        uint write (uint delegate (void[]) dg)
        {
                int count = dg (data [limit..capacity]);

                if (count != IConduit.Eof) 
                   {
                   limit += count;
                   assert (limit <= capacity);
                   }
                return count;
        }               

        /***********************************************************************

                Exposes the raw data buffer at the current read position. The
                delegate is provided with a void[] representing the available
                data, and should return zero to leave the current read position
                intact. 
                
                If the delegate consumes data, it should return the number of 
                bytes consumed; or IConduit.Eof to indicate an error.

                Returns whatever the delegate returns.

        ***********************************************************************/

        uint read (uint delegate (void[]) dg)
        {
                
                int count = dg (data [position..limit]);
                
                if (count != IConduit.Eof)
                   {
                   position += count;
                   assert (position <= limit);
                   }
                return count;
        }               

        /***********************************************************************

                If we have some data left after an export, move it to 
                front-of-buffer and set position to be just after the 
                remains. This is for supporting certain conduits which 
                choose to write just the initial portion of a request.
                
                Limit is set to the amount of data remaining. Position 
                is always reset to zero.

        ***********************************************************************/

        IBuffer compress ()
        {
                uint r = readable ();

                if (position > 0 && r > 0)
                    // content may overlap ...
                    memcpy (&data[0], &data[position], r);

                position = 0;
                limit = r;
                return this;
        }               

        /***********************************************************************

                Try to fill the available buffer with content from the 
                specified conduit. In particular, we will never ask to 
                read less than 32 bytes. This permits conduit-filters 
                to operate within a known environment.

                Returns the number of bytes read, or Eof if there's no
                more data available. Where no conduit is attached, Eof 
                is always returned.
        
        ***********************************************************************/

        uint fill ()
        {
                if (conduit)
                    return fill (conduit);

                return IConduit.Eof;
        }

        /***********************************************************************

                Try to fill the available buffer with content from the 
                specified conduit. In particular, we will never ask to 
                read less than 32 bytes ~ this permits conduit-filters 
                to operate within a known environment. We also try to
                read as much as possible by clearing the buffer when 
                all current content has been eaten.

                Returns the number of bytes read, or Conduit.Eof
        
        ***********************************************************************/

        uint fill (IConduit conduit)
        {
                if (readable is 0)
                    clear();
                else
                   if (writable < 32)
                       if (compress().writable < 32)
                           error ("input buffer is too small");

                return write (&conduit.read);
        } 

        /***********************************************************************

                make some room in the buffer
                        
        ***********************************************************************/

        void makeRoom (uint space)
        {
                if (conduit)
                    drain ();
                else
                   error (overflow);
        }

        /***********************************************************************

                Write as much of the buffer that the associated conduit
                can consume.

                Returns the number of bytes written, or Conduit.Eof
        
        ***********************************************************************/

        uint drain ()
        {
                uint ret = read (&conduit.write);
                if (ret == conduit.Eof)
                    error (eofWrite);

                compress ();
                return ret;
        }

        /***********************************************************************
        
                flush the contents of this buffer to the related conduit.
                Throws an IOException on premature eof.

        ***********************************************************************/

        void flush ()
        {
                if (conduit)
                    if (conduit.flush (data [position..limit]))
                        clear();
                    else
                       error (eofWrite);
        } 

        /***********************************************************************
        
                Reset 'position' and 'limit' to zero

        ***********************************************************************/

        IBuffer clear ()
        {
                position = limit = 0;
                return this;
        }               

        /***********************************************************************
        
                Truncate the buffer within its extend. Returns true if
                the new 'extent' is valid, false otherwise.

        ***********************************************************************/

        bool truncate (uint extent)
        {
                if (extent <= data.length)
                   {
                   limit = extent;
                   return true;
                   }
                return false;
        }               

        /***********************************************************************
        
                Returns the limit of readable content within this buffer

        ***********************************************************************/

        uint getLimit ()
        {
                return limit;
        }

        /***********************************************************************
        
                Returns the total capacity of this buffer

        ***********************************************************************/

        uint getCapacity ()
        {
                return capacity;
        }

        /***********************************************************************
        
                Returns the current read-position within this buffer

        ***********************************************************************/

        uint getPosition ()
        {
                return position;
        }

        /***********************************************************************
        
                Returns the conduit associated with this buffer. Returns 
                null if the buffer is purely memory based; that is, it's
                not backed by some external medium.

                Buffers do not require an external conduit to operate, but 
                it can be convenient to associate one. For example, methods
                fill() & drain() use it to import/export content as necessary.

        ***********************************************************************/

        IConduit getConduit ()
        {
                return conduit;
        }

        /***********************************************************************
        
                Sets the external conduit associated with this buffer.

                Buffers do not require an external conduit to operate, but 
                it can be convenient to associate one. For example, methods
                fill() & drain() use it to import/export content as necessary.

        ***********************************************************************/

        void setConduit (IConduit conduit)
        {
                this.conduit = conduit;
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
