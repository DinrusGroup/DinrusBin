/*******************************************************************************

        @file RollCall.d
        
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

module mango.cluster.qos.socket.RollCall;

private import mango.cache.Payload;

/******************************************************************************

        An IPayload used by the cluster client and server during discovery 
        lookup and liveness broadcasts. The client broadcasts one of these
        at startup to see which servers are alive. The server responds with
        a reply RollCall stating its name and port. The server will also
        broadcast one of these when it first starts, such that any running
        clients can tell the server has 'recovered'.
         
******************************************************************************/

class RollCall : Payload
{
        char[]  name;
        int     port1,
                port2;
        bool    request;

        private import mango.io.PickleRegistry;

        /***********************************************************************
        
                Register this class for pickling, so we can resurrect
                instances when they arrive on a network datagram.

        ***********************************************************************/

        static this ()
        {
                PickleRegistry.enroll (new RollCall);
        }

        /**********************************************************************

        **********************************************************************/

        this ()
        {
        }

        /**********************************************************************

        **********************************************************************/

        this (char[] name, ushort port1, ushort port2, bool request = false)
        {
                this.name    = name;
                this.port1   = port1;
                this.port2   = port2;
                this.request = request;
        }

        /**********************************************************************

        **********************************************************************/

        void read (IReader reader)
        {
                super.read (reader);
                reader.get (name)
                      .get (port1)
                      .get (port2)
                      .get (request);
        }

        /**********************************************************************

        **********************************************************************/

        void write (IWriter writer)
        {
                super.write (writer);
                writer.put  (name)
                      .put  (port1)
                      .put  (port2)
                      .put  (request);
        }

        /**********************************************************************

        **********************************************************************/

        override Payload create ()
        {
                return new RollCall;
        }

        /**********************************************************************

        **********************************************************************/

        override char[] getGuid ()
        {
                return this.classinfo.name;
        }
}



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
