/*******************************************************************************

        @file IConduit.d
        
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

module mango.io.model.IConduit;

/*******************************************************************************

        Conduits provide virtualized access to external content, and 
        represent things like files or Internet connections. Conduits 
        are modelled by mango.io.model.IConduit, and implemented via 
        classes FileConduit and SocketConduit. 
        
        Additional kinds of conduit are easy to construct: one either 
        subclasses mango.io.Conduit, or implements mango.io.model.IConduit. 
        A conduit typically reads and writes from/to an IBuffer in large 
        chunks, typically the entire buffer. Alternatively, one can invoke 
        read(dst[]) and/or write(src[]) directly.

*******************************************************************************/

interface IConduit
{
        // abstract OS file-handle from getHandle()
        typedef int Handle = -1;

        /***********************************************************************
        
                Declare the End Of File identifer

        ***********************************************************************/

        enum {Eof = uint.max};

        /***********************************************************************
                
                read from conduit into a target array

        ***********************************************************************/

        abstract uint read (void[] dst);               

        /***********************************************************************
        
                write to conduit from a source array

        ***********************************************************************/

        abstract uint write (void[] src);               

        /***********************************************************************
        
                flush provided content to the conduit

        ***********************************************************************/

        abstract bool flush (void[] src);

        /***********************************************************************
        
                Transfer the content of this conduit to another one. 
                Returns true if all content was successfully copied.
        
        ***********************************************************************/

        abstract IConduit copy (IConduit source);

        /**********************************************************************
        
                Fill the provided buffer. Returns true if the request 
                can be satisfied; false otherwise

        **********************************************************************/
	
        abstract bool fill (void[] dst);

        /***********************************************************************
        
                Attach a filter to this conduit: see IConduitFilter

        ***********************************************************************/

        abstract void attach (IConduitFilter filter);

        /***********************************************************************
        
                Return a preferred size for buffering conduit I/O

        ***********************************************************************/

        abstract uint bufferSize (); 
                     
        /***********************************************************************
        
                Returns true is this conduit can be read from

        ***********************************************************************/

        abstract bool isReadable ();

        /***********************************************************************
        
                Returns true if this conduit can be written to

        ***********************************************************************/

        abstract bool isWritable ();

        /***********************************************************************
        
                Returns true if this conduit is seekable (whether it 
                implements ISeekable)

        ***********************************************************************/

        abstract bool isSeekable ();

        /***********************************************************************
        
                Returns true if this conduit is text-based

        ***********************************************************************/

        abstract bool isTextual ();

        /***********************************************************************
        
                Return the underlying OS handle of this Conduit

        ***********************************************************************/

        abstract Handle getHandle (); 

        /***********************************************************************
                
                Release external resources

        ***********************************************************************/

        abstract void close ();
}


/*******************************************************************************
        
        Define a conduit filter base-class. The filter is invoked
        via its reader() method whenever a block of content is 
        being read, and by its writer() method whenever content is
        being written. 

        The filter should return the number of bytes it has actually
        produced: less than or equal to the length of the provided 
        array. 

        Filters are chained together such that the last filter added
        is the first one invoked. It is the responsibility of each
        filter to invoke the next link in the chain; for example:

        @code
        class MungingFilter : ConduitFilter
        {
                int reader (void[] dst)
                {
                        // read the next X bytes
                        int count = next.reader (dst);

                        // set everything to '*' !
                        dst[0..count] = '*';

                        // say how many we read
                        return count;
                }

                int writer (void[] src)
                {
                        byte[] tmp = new byte[src.length];

                        // set everything to '*'
                        tmp = '*';

                        // write the munged output
                        return next.writer (tmp);
                }
        }
        @endcode

        Notice how this filter invokes the 'next' instance before 
        munging the content ... the far end of the chain is where
        the original IConduit reader is attached, so it will get
        invoked eventually assuming each filter invokes 'next'. 
        If the next reader fails it will return IConduit.Eof, as
        should your filter (or throw an IOException). From a client 
        perspective, filters are attached like this:

        @code
        FileConduit fc = new FileConduit (...);

        fc.attach (new ZipFilter);
        fc.attach (new MungingFilter);
        @endcode

        Again, the last filter attached is the first one invoked 
        when a block of content is actually read. Each filter has
        two additional methods that it may use to control behavior:

        @code
        class ConduitFilter : IConduitFilter
        {
                protected IConduitFilter next;

                void bind (IConduit conduit, IConduitFilter next)
                {
                        this.next = next;
                }

                void unbind ()
                {
                }
        }
        @endcode

        The first method is invoked when the filter is attached to a 
        conduit, while the second is invoked just before the conduit 
        is closed. Both of these may be overridden by the filter for
        whatever purpose desired.

        Note that a conduit filter can choose to sidestep reading from 
        the conduit (per the usual case), and produce its input from 
        somewhere else entirely. This mechanism supports the notion
        of 'piping' between multiple conduits, or between a conduit 
        and something else entirely; it's a bridging mechanism.

*******************************************************************************/

interface IConduitFilter
{
        /***********************************************************************
        
                filter-specific reader

        ***********************************************************************/

        abstract uint reader (void[] dst);               
                             
        /***********************************************************************
        
                filter-specific writer

        ***********************************************************************/

        abstract uint writer (void[] dst);               
                             
        /***********************************************************************
        
        ***********************************************************************/

        abstract void bind (IConduit conduit, IConduitFilter next);                       
                              
        /***********************************************************************
        
        ***********************************************************************/

        abstract void unbind ();
}


/*******************************************************************************

        Models the ability to seek within a conduit. 

*******************************************************************************/

interface ISeekable
{
        /***********************************************************************
        
                The anchor positions supported by ISeekable

        ***********************************************************************/

        enum SeekAnchor {
                        Begin   = 0,
                        Current = 1,
                        End     = 2,
                        };

        /***********************************************************************
                        
                Return the current conduit position (such as file position)
                
        ***********************************************************************/

        abstract ulong getPosition ();

        /***********************************************************************
        
                Move the file position to the given offset from the provided 
                anchor point, and return the adjusted position.

        ***********************************************************************/

        abstract ulong seek (ulong offset, SeekAnchor anchor=SeekAnchor.Begin);
}


/*******************************************************************************

        Defines how a Conduit should be opened. This is typically subsumed
        by another structure     

*******************************************************************************/

struct ConduitStyle
{
        align(1):

        

        /***********************************************************************
        
        ***********************************************************************/

        enum Access : ubyte     {
                                Read      = 0x01,       // is readable
                                Write     = 0x02,       // is writable 
                                ReadWrite = 0x03,       // both 
                                };
								
								
		struct Bits
        {
                Access access;                          // access rights
        }

        /***********************************************************************
        
                Setup common instances of conduit styles

        ***********************************************************************/

        const Bits Read = {Access.Read};
        const Bits Write = {Access.Write};
        const Bits ReadWrite = {Access.ReadWrite}; 
}



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
