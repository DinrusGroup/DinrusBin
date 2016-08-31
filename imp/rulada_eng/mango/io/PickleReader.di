/*******************************************************************************

        @file PickleReader.d
        
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

module mango.io.PickleReader;

private import  mango.io.EndianReader,
                mango.io.PickleRegistry;


/*******************************************************************************
        
        Reads serialized content from the bound Buffer, and reconstructs
        the 'original' object from the data therein. 

        All content must be in Network byte-order, so as to span machine
        boundaries. Here's an example of how this class is expected to be 
        used in conjunction with PickleWriter & PickleRegistry: 

        @code
        // define a pickle class (via interfaces)
        class Bar : IPickled
        {
                private int x = 11;
                private int y = 112;

                void write (IWriter output)
                {
                        output (x) (y);
                }

                void read (IReader input)
                {
                        input (x) (y);
                }

                Object create (IReader reader)
                {
                        Bar bar = new Bar;
                        bar.read (reader);
                        assert (bar.x == 11 && bar.y == 112);
                        return bar;
                }

                char[] getGuid ()
                {
                        return "a network guid";
                }
        }

        // setup for serialization
        Buffer buf = new Buffer (256);
        PickleWriter w = new PickleWriter (buf);
        PickleReader r = new PickleReader (buf);

        // construct a Bar
        Bar bar = new Bar;

        // tell registry about this object
        PickleRegistry.enroll (bar);

        // serialize it
        w.freeze (bar);
        
        // create a new instance and populate. This just shows the basic
        // concept, not a fully operational implementation
        Object o = r.thaw ();
        @endcode


        An alternative approach uses a proxy function instead of a class:

        @code
        // define a pickle class (via interface)
        class Bar : IPickle
        {
                private int x = 11;
                private int y = 112;
                
                void write (IWriter output)
                {
                        output (x) (y);
                }

                void read (IReader input)
                {
                        input (x) (y);
                        assert (x == 11 && y == 112);
                }

                char[] getGuid ()
                {
                        return "a network guid";
                }

                // note that this is a static method, as opposed to
                // the IPickleFactory method of the same name
                static Object create (IReader reader)
                {
                        Bar bar = new Bar;
                        bar.read (reader);
                        return bar;
                }
        }
      
        // setup for serialization
        Buffer buf = new Buffer (256);
        PickleWriter w = new PickleWriter (buf);
        PickleReader r = new PickleReader (buf);

        // tell registry about this object
        PickleRegistry.enroll (&Bar.create, "a network guid");

        // serialize it
        w.freeze (new Bar);
        
        // create a new (populated) instance via the proxy function
        Object o = r.thaw ();
        @endcode

        Note that in the latter case you must ensure that the enroll() method
        is passed a guid identical to the one exposed by the IPickle instance.

*******************************************************************************/

version (BigEndian)
         alias Reader SuperClass;
      else
         alias EndianReader SuperClass;

class PickleReader : SuperClass
{       
        /***********************************************************************
        
                Construct a PickleReader with the given buffer, and
                an appropriate EndianReader.

                Note that serialized data is always in Network order.

        ***********************************************************************/

        this (IBuffer buffer)
        {
                super (buffer);
        }

        /***********************************************************************
        
                Reconstruct an Object from the current buffer content. It
                is considered optimal to configure the underlying IReader
                with an allocator that slices array-references, rather than 
                copying them into the heap (the default configuration). 

        ***********************************************************************/

        Object thaw ()
        {
                char[] name;

                get (name);
                return PickleRegistry.create (this, name);                                 
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
