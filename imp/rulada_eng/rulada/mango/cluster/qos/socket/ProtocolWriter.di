/*******************************************************************************

        @file ProtocolWriter.d
        
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


        @version        Initial version, July 2004      
        @author         Kris


*******************************************************************************/

module mango.cluster.qos.socket.ProtocolWriter;

private import mango.io.model.IPickle;

private import  mango.io.PickleWriter,
                mango.io.EndianWriter;

private import  mango.cluster.model.IChannel;

/*******************************************************************************
        
        Objects passed around a cluster are prefixed with a header, so the 
        receiver can pick them apart correctly. This header consists of:

        - the packet size, including the header (16 bits)
        - a command code (8 bits)
        - the length of the channel name (8 bits)
        - the channel name
        - the payload (an IPickle class)

        Everything is written in Network order (big endian).

*******************************************************************************/

class ProtocolWriter : PickleWriter
{
        const ubyte Version = 0x01;

        enum Command : ubyte {OK, Exception, Full, Locked, 
                              Add, Copy, Remove, Load, AddQueue, RemoveQueue};

        /***********************************************************************
        
                Construct a ProtocolWriter upon the given buffer. As
                Objects are serialized, their content is written to this
                buffer. The buffer content is then typically flushed to 
                some external conduit, such as a file or socket.

                Note that serialized data is always in Network order.

        ***********************************************************************/
        
        this (IBuffer buffer)
        in {
           assert (buffer);
           }
        body
        {
                super (buffer);
        }

        /***********************************************************************
                
                Flush the output
        
        ***********************************************************************/

        override IWriter flush () 
        {
                // remember the current buffer content
                uint content = buffer.readable ();

                // flush pickled object(s) to output
                super.flush ();

                // skip back in case we have to try this again
                buffer.skip (-content);

                return this;
        }

        /***********************************************************************
        
        ***********************************************************************/

        ProtocolWriter put (Command cmd, char[] channel, IPickle object = null, char[] element = null)
        {
                // reset the buffer first!
                buffer.clear ();
                ubyte[] content = cast(ubyte[]) buffer.getContent();

                super.put (cast(ushort) 0)
                     .put (cast(ubyte) cmd)
                     .put (cast(ubyte) Version)
                     .put (channel)
                     .put (element);

                // is there a payload?
                if (object)
                    super.freeze (object);

                // go back and write the total number of bytes
                int size = buffer.getLimit;
                content[0] = cast(ubyte) (size >> 8);
                content[1] = cast(ubyte) (size & 0xff);
                return this;
        }

        /***********************************************************************
        
                Write an exception message

        ***********************************************************************/

        ProtocolWriter exception (char[] message)
        {
                put (ProtocolWriter.Command.Exception, message);
                return this;
        }

        /***********************************************************************
                
                Write an "OK" confirmation

        ***********************************************************************/

        ProtocolWriter success (char[] message = null)
        {
                put (ProtocolWriter.Command.OK, message);
                return this;
        }

        /***********************************************************************
                
                Indicate something has filled up

        ***********************************************************************/

        ProtocolWriter full (char[] message)
        {
                put (ProtocolWriter.Command.Full, message);
                return this;
        }

        /***********************************************************************
        
                Write a serialized payload as constructed by the method
                ProtocolReader.getPacket()

        ***********************************************************************/

        ProtocolWriter reply (ClusterContent content)
        {
                // reset the buffer first
                buffer.clear ();

                // write the length ...
                super.put (cast(ushort) (content.length + ushort.sizeof + ubyte.sizeof + ubyte.sizeof));

                // and the ack ...
                super.put (cast(ubyte) ProtocolWriter.Command.OK);

                // and the version ...
                super.put (cast(ubyte) Version);

                // and the payload (which includes both channel & element)
                if (content.length)
                    buffer.append (content);
                else
                   // or filler for an empty channel & element ...
                   super.put (cast(int) 0).put(cast(int) 0);

                return this;
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
