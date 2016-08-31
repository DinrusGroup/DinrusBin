/*******************************************************************************

        @file ProtocolReader.d
        
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

module mango.cluster.qos.socket.ProtocolReader;

private import  mango.io.Exception,
                mango.io.PickleReader,
                mango.io.EndianReader;

private import  mango.cluster.model.ICluster;

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

class ProtocolReader : PickleReader
{
        /***********************************************************************
        
                Construct a ProtocolReader upon the given buffer. As
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
        
                Return the payload if there was one, null otherwise.

        ***********************************************************************/

        IPayload getPayload (inout char[] channel, inout char[] element, inout ubyte cmd)
        {
                int position = buffer.getPosition;

                ushort size;
                ubyte  versn;

                get (size);
                get (cmd);
                get (versn);

                // avoid allocation for these two strings
                get (channel);
                get (element);

                // is there a payload attached?
                if (size > (buffer.getPosition - position))
                    return cast(IPayload) thaw ();

                return null;
        }

        /***********************************************************************
        
                Return a duplicated slice of the buffer representing the 
                recieved payload. This is a bit of a hack, but eliminates
                a reasonable amount of overhead. Note that the channel/key
                text is retained right at the start of the buffer, allowing
                the writer to toss the whole thing back without any further
                munging. 

        ***********************************************************************/

        ClusterContent getPacket (inout char[] channel, inout char[] element, inout ubyte cmd)
        {
                ushort  size;
                ubyte   versn;

                // load up the length first.
                get (size);
                //printf ("size: %d\n", cast(int) size);

                // read the header 
                get (cmd);

                // read the version stamp
                get (versn);

                // subtract header size
                size -= buffer.getPosition;
                
                // may throw an exception if the payload is too large to fit
                // completely inside the buffer!
                buffer.get (size, false);

                // duplicate the remaining packet (with channel/key text)
                ClusterContent content = cast(ClusterContent) buffer.toString().dup;

                // get a slice upon the channel name. Note this is 
                // dup'd as part of the payload
                get (channel);

                // get a slice upon the element name. Note this is 
                // dup'd as part of the payload
                get (element);

                // return the dup'd payload (including channel/key text)
                return content;
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
