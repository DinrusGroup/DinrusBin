/*******************************************************************************

        @file ServerSocket.d
        
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

module mango.io.ServerSocket;

public  import  mango.io.Socket;

private import  mango.io.Exception,
                mango.io.SocketConduit;

private import  mango.io.model.IBuffer,
                mango.io.model.IConduit;

/*******************************************************************************

        ServerSocket is a wrapper upon the basic socket functionality to
        simplify the API somewhat. You use a ServerSocket to listen for 
        inbound connection requests, and get back a SocketConduit when a
        connection is made.

*******************************************************************************/

class ServerSocket : Socket
{
        private int linger = -1;

        /***********************************************************************
        
                Construct a ServerSocket on the given address, with the
                specified number of backlog connections supported. The
                socket is bound to the given address, and set to listen
                for incoming connections. Note that the socket address 
                can be setup for reuse, so that a halted server may be 
                restarted immediately.

        ***********************************************************************/

        this (InternetAddress addr, int backlog, bool socketReuse = false)
        {
                super (AddressFamily.INET, Type.STREAM, Protocol.IP);
                setAddressReuse (socketReuse);
                bind (addr);
                listen (backlog);
        }

        /***********************************************************************
        
                Set the period in which dead sockets are left lying around
                by the O/S

        ***********************************************************************/

        override void setLingerPeriod (int period)
        {
                linger = period;
        }

        /***********************************************************************
        
                Wait for a client to connect to us, and return a connected
                SocketConduit.

        ***********************************************************************/

        override SocketConduit accept ()
        {
                return cast(SocketConduit) super.accept ();
        }

        /***********************************************************************
        
                Overrides the default socket behaviour to create a socket
                for an incoming connection. Here we provide a SocketConduit
                instead.

        ***********************************************************************/

        protected override Socket createSocket (socket_t handle)
        {
                Socket socket = SocketConduit.create (handle);

                // force abortive closure to avoid prolonged OS scavenging?
                if (linger >= 0)
                    socket.setLingerPeriod (linger);

                return socket;
        }
}



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
