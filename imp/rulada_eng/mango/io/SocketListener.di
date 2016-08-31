/*******************************************************************************

        @file SocketListener.d
        
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


        @version        Initial version, June 2004      
        @author         Kris


*******************************************************************************/

module mango.io.SocketListener;

private import  std.thread;

private import  mango.io.Socket;

private import  mango.io.model.IBuffer,
                mango.io.model.IWriter;

/******************************************************************************

        Abstract class to asynchronously listen for incoming data on a 
        socket. This can be used with DatagramSocket & MulticastSocket, 
        and might possibly be useful with a basic SocketConduit also.
        Note that DatagramSocket must first be bound to a local network
        address via bind(), and MulticastSocket should first be made a 
        member of a multicast group via its join() method. Note also
        that the underlying thread is not started by the constructor;
        you should do that manually via the start() method.

******************************************************************************/

//version = AltListener;

version (AltListener)
         alias Object FOO;
        else
         alias Thread FOO;

class SocketListener : FOO, IListener
{
        private bool                    quit;
        private IBuffer                 buffer;
        private ISocketReader           reader;
        private int                     limit = 3;

        /**********************************************************************
               
                Construct a listener with the requisite arguments. The
                specified buffer is populated via the provided instance
                of ISocketReader before being passed to the notify()
                method. All arguments are required.

        **********************************************************************/

        this (ISocketReader reader, IBuffer buffer)
        in {
           assert (reader);
           assert (buffer);
           }
        body
        {
                this.buffer = buffer;
                this.reader = reader;
                version (AltListener)
                        {
                        Thread t = new Thread (&run);
                        t.start();
                        }
        }

        version (AltListener)
                 void start(){}

        /***********************************************************************
                
                Notification callback invoked whenever the listener has
                anything to report. The buffer will have whatever content
                was available from the read() operation

        ***********************************************************************/

        abstract void notify (IBuffer buffer);

        /***********************************************************************

                Handle error conditions from the listener thread.

        ***********************************************************************/

        abstract void exception (char[] msg);

        /**********************************************************************
             
                Cancel this listener. The thread will quit only after the 
                current read() request responds, or is interrrupted.

        **********************************************************************/

        void cancel ()
        {
                quit = true;
        }

        /**********************************************************************
             
                Set the maximum contiguous number of exceptions this 
                listener will survive. Setting a limit of zero will 
                not survive any errors at all, whereas a limit of two
                will survive as long as two consecutive errors don't 
                arrive back to back.

        **********************************************************************/

        void setErrorLimit (ushort limit)
        {
                this.limit = limit + 1;
        }

        /**********************************************************************

                Execution of this thread is typically stalled on the
                read() method belonging to the ISocketReader specified
                during construction. You can invoke cancel() to indicate
                execution should not proceed further, but that will not
                actually interrupt a blocked read() operation.

                Note that exceptions are all directed towards the handler
                implemented by the class instance. 

        **********************************************************************/

        version (Ares) 
                 alias void ThreadReturn;
              else
                 alias int ThreadReturn;

        ThreadReturn run ()
        {
                int lives = limit;

                while (lives > 0)
                       try {
                           // start with a clean slate
                           buffer.clear ();

                           // wait for incoming content
                           reader.read (buffer);

                           // time to quit? Note that a v0.95 compiler bug 
                           // prohibits 'break' from exiting the try{} block
                           if (quit || Socket.isHalting ())
                               lives = 0;
                           else
                              {
                              // invoke callback                        
                              notify (buffer);
                              lives = limit;
                              }
                           } catch (Object x)
                                    // time to quit?
                                    if (quit || Socket.isHalting ())
                                        break;
                                    else
                                       {
                                       exception (x.toString);
                                       if (--lives == 0)
                                           exception ("listener thread aborting");
                                       }
                version (TraceLinux)
                        {
                        printf ("SocketListener exiting\n");
                        }
                return 0;
        }
}




version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
