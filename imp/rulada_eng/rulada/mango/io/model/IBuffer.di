/*******************************************************************************

        @file IBuffer.d
        
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


        @version        Initial version, March 2004      
        @author         Kris


*******************************************************************************/

module mango.io.model.IBuffer;

private import mango.io.model.IConduit;

/*******************************************************************************

        The basic premise behind this IO package is as follows:

        1) the central concept is that of a buffer. The buffer acts
           as a queue (line) where items are removed from the front
           and new items are added to the back. Buffers are modeled 
           by this interface, and mango.io.Buffer exposes a concrete 
           implementation.

        2) buffers can be written to directly, but a Reader and/or
           Writer are typically used to read & write formatted data.
           These readers & writers are bound to a specific buffer;
           often the same buffer. It's also perfectly legitimate to 
           bind multiple writers to the same buffer; they will all
           behave serially as one would expect. The same applies to
           multiple readers on the same buffer. Readers and writers
           support two styles of IO: put/get, and the C++ style << 
           and >> operators. All such operations can be chained.

        3) Any class can be made compatable with the reader/writer
           framework by implementing the IReadable and/or IWritable 
           interfaces. Each of these specify just a single method.

        4) Buffers may also be tokenized. This is handy when one is
           dealing with text input, and/or the content suits a more
           fluid format than most typical readers & writers support.
           Tokens are mapped directly onto buffer content, so there
           is only minor overhead in using them. Tokens can be read
           and written by reader/writers also, using a more relaxed
           set of rules than those applied to integral IO.

        5) buffers are sometimes memory-only, in which case there
           is nothing left to do when a reader (or tokenizer) hits
           end of buffer conditions. Other buffers are themselves 
           bound to a Conduit. When this is the case, a reader will 
           eventually cause the buffer to reload via its associated 
           conduit. Previous buffer content will thus be lost. The
           same concept is applied to writers, whereby they flush 
           the content of a full buffer to a bound conduit before 
           continuing. 

        6) conduits provide virtualized access to external content,
           and represent things like files or Internet connections.
           They are just a different kind of stream. Conduits are
           modelled by mango.io.model.IConduit, and implemented via
           classes FileConduit and SocketConduit. Additional kinds
           of conduit are easy to construct: one either subclasses
           mango.io.Conduit, or implements mango.io.model.IConduit. A
           conduit reads and writes from/to a buffer in big chunks
           (typically the entire buffer).

*******************************************************************************/

abstract class IBuffer // could be an interface, but that causes poor codegen
{
        typedef uint delegate (void* dst, uint count, uint type) Converter;

        private typedef byte Style;

        const Style     Mixed  = 0, 
                        Binary = 1,
                        Text   = 2;

        /***********************************************************************
                
                Return the backing array

        ***********************************************************************/

        abstract void[] getContent ();

        /***********************************************************************
        
                Return a char[] slice of the buffer up to the limit of
                valid content.

        ***********************************************************************/

        abstract char[] toString ();

        /***********************************************************************
        
                Set the backing array with all content readable. Writing
                to this will either flush it to an associated conduit, or
                raise an Eof condition. Use IBuffer.clear() to reset the
                content (make it all writable).

        ***********************************************************************/

        abstract IBuffer setValidContent (void[] data);

        /***********************************************************************
        
                Set the backing array with some content readable. Writing
                to this will either flush it to an associated conduit, or
                raise an Eof condition. Use IBuffer.clear() to reset the
                content (make it all writable).

        ***********************************************************************/

        abstract IBuffer setContent (void[] data, uint readable);

        /***********************************************************************

                Write an array of data into this buffer, and flush to the
                conduit as necessary. Returns a chaining reference if all 
                data was written; throws an IOException indicating eof or 
                eob if not.

                This is often used in lieu of a Writer.

        ***********************************************************************/

        abstract IBuffer append (void[] content);

        /***********************************************************************

                Read a chunk of data from the buffer, loading from the
                conduit as necessary. The requested number of bytes are
                loaded into the buffer, and marked as having been read 
                when the 'eat' parameter is set true. When 'eat' is set
                false, the read position is not adjusted.

                Returns the corresponding buffer slice when successful, 
                or null if there's not enough data available (Eof; Eob).

        ***********************************************************************/

        abstract void[] get (uint size, bool eat = true);

        /***********************************************************************

                Exposes the raw data buffer at the current write position, 
                The delegate is provided with a void[] representing space
                available within the buffer at the current write position.

                The delegate should return the approriate number of bytes 
                if it writes valid content, or IConduit.Eof on error.

                Returns whatever the delegate returns.

        ***********************************************************************/

        abstract uint write (uint delegate (void[]) writer);

        /***********************************************************************

                Exposes the raw data buffer at the current read position. The
                delegate is provided with a void[] representing the available
                data, and should return zero to leave the current read position
                intact. 
                
                If the delegate consumes data, it should return the number of 
                bytes consumed; or IConduit.Eof to indicate an error.

                Returns whatever the delegate returns.

        ***********************************************************************/

        abstract uint read (uint delegate (void[]) reader);

        /***********************************************************************

                If we have some data left after an export, move it to 
                front-of-buffer and set position to be just after the 
                remains. This is for supporting certain conduits which 
                choose to write just the initial portion of a request.
                            
                Limit is set to the amount of data remaining. Position 
                is always reset to zero.

        ***********************************************************************/

        abstract IBuffer compress ();

        /***********************************************************************
        
                Skip ahead by the specified number of bytes, streaming from 
                the associated conduit as necessary.
        
                Can also reverse the read position by 'size' bytes. This may
                be used to support lookahead-type operations.

                Returns true if successful, false otherwise.

        ***********************************************************************/

        abstract bool skip (int size);

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

        bool next (uint delegate (void[]));

        /***********************************************************************

                Try to fill the available buffer with content from the 
                specified conduit. In particular, we will never ask to 
                read less than 32 bytes. This permits conduit-filters 
                to operate within a known environment.

                Returns the number of bytes read, or throws an underflow
                error if there nowhere to read from
        
        ***********************************************************************/

        abstract uint fill ();

        /***********************************************************************

                Try to fill the available buffer with content from the 
                specified conduit. In particular, we will never ask to 
                read less than 32 bytes. This permits conduit-filters 
                to operate within a known environment.

                Returns the number of bytes read, or Conduit.Eof
        
        ***********************************************************************/

        abstract uint fill (IConduit conduit);

        /***********************************************************************

                Write as much of the buffer that the associated conduit
                can consume.

                Returns the number of bytes written, or Conduit.Eof
        
        ***********************************************************************/

        abstract uint drain ();

        /***********************************************************************
        
                flush the contents of this buffer to the related conduit.
                Throws an IOException on premature eof.

        ***********************************************************************/

        abstract void flush ();

        /***********************************************************************
        
                Reset position and limit to zero.

        ***********************************************************************/

        abstract IBuffer clear ();               

        /***********************************************************************
        
                Truncate the buffer within its extend. Returns true if
                the new 'extent' is valid, false otherwise.

        ***********************************************************************/

        bool truncate (uint extent);

        /***********************************************************************
        
                return count of readable bytes remaining in buffer. This is 
                calculated simply as limit() - position()

        ***********************************************************************/

        abstract uint readable ();               

        /***********************************************************************
        
                Return count of writable bytes available in buffer. This is 
                calculated simply as capacity() - limit()

        ***********************************************************************/

        abstract uint writable ();

        /***********************************************************************
        
                returns the limit of readable content within this buffer

        ***********************************************************************/

        abstract uint getLimit ();               

        /***********************************************************************
        
                returns the total capacity of this buffer

        ***********************************************************************/

        abstract uint getCapacity ();               

        /***********************************************************************
        
                returns the current position within this buffer

        ***********************************************************************/

        abstract uint getPosition ();               

        /***********************************************************************

                make some room in the buffer
                        
        ***********************************************************************/

        abstract void makeRoom (uint space);

        /***********************************************************************
        
                Returns the conduit associated with this buffer. Returns 
                null if the buffer is purely memory based; that is, it's
                not backed by some external conduit.

                Buffers do not require a conduit to operate, but it can
                be convenient to associate one. For example, the IReader
                and IWriter classes use this to import/export content as
                necessary.

        ***********************************************************************/

        abstract IConduit getConduit ();               

        /***********************************************************************
        
                Sets the external conduit associated with this buffer.

                Buffers do not require an external conduit to operate, but 
                it can be convenient to associate one. For example, methods
                read and write use it to import/export content as necessary.

        ***********************************************************************/

        abstract void setConduit (IConduit conduit);

        /***********************************************************************
                
                Return style of buffer

        ***********************************************************************/

        abstract Style getStyle ();

        /***********************************************************************
        
                Throw an exception with the provided message

        ***********************************************************************/

        abstract void error (char[] msg);
}


/*******************************************************************************

        Any class implementing IDecoder can be bound to a reader using
        the setDecoder() method.
        
*******************************************************************************/

abstract class AbstractDecoder
{       
        alias decoder opCall;

        abstract uint type ();

        abstract void bind (IBuffer buffer);

        abstract void[] decoder (void[] src, uint type);

        abstract uint decoder (void* dst, uint bytes, uint type);
}


/*******************************************************************************

        Any class implementing IEncoder can be bound to a writer using
        the bind() method.
        
*******************************************************************************/

abstract class AbstractEncoder
{
        alias encoder opCall;

        abstract uint type ();

        abstract void bind (IBuffer buffer);

        abstract uint encoder (void* src, uint bytes, uint type);
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
