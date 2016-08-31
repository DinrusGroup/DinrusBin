/*******************************************************************************

        @file ClusterThread.d
        
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

module mango.cluster.qos.socket.ClusterThread;

private import  std.thread;

private import  mango.io.Exception,
                mango.io.GrowBuffer,
                mango.io.ServerSocket,
                mango.io.ArrayAllocator;

private import  mango.io.model.IConduit;

private import  mango.utils.AbstractServer;

private import  mango.cluster.qos.socket.Cluster,
                mango.cluster.qos.socket.ClusterCache,
                mango.cluster.qos.socket.ProtocolReader,
                mango.cluster.qos.socket.ProtocolWriter;

/******************************************************************************

        The socket QOS thread for handling client requests.

******************************************************************************/

class ClusterThread : Thread
{
        private ClusterCache    cache;
        private ClusterQueue    queue;
        private GrowBuffer      buffer;
        private ProtocolReader  reader;
        private ProtocolWriter  writer;
        private ILogger         logger;
        private char[]          client;
        private Cluster         cluster;

        /**********************************************************************

                Note that the conduit stays open until the client kills it.
                Also note that we use a GrowableBuffer here, which expands
                as necessary to contain larger payloads.

        **********************************************************************/

        this (AbstractServer server, IConduit conduit, Cluster cluster, 
              ClusterCache cache, ClusterQueue queue)
        {
                buffer = new GrowBuffer (1024 * 8);
                buffer.setConduit (conduit);

                // get client infomation
                client = server.getRemoteAddress (conduit);

                // setup cluster protocol transcoders
                writer = new ProtocolWriter (buffer);

                // make the reader slice directly from the buffer content
                reader = new ProtocolReader (buffer);
                reader.setAllocator (new BufferAllocator);

                // save state
                logger = server.getLogger;
                this.cluster = cluster;
                this.cache = cache;
                this.queue = queue;
        }

        /**********************************************************************

        **********************************************************************/

        private final char[] msg (char[] action, char[] target)
        {
                return client ~ ": " ~ action ~ target ~ "'"; 
        }

        /**********************************************************************

        **********************************************************************/

        private final char[] msg1 (char[] action, char[] target, char[] channel)
        {
                return msg (action, target) ~ " on channel '" ~ channel ~ "'"; 
        }

        /**********************************************************************

        **********************************************************************/

        version (Ares) 
                 alias void ThreadReturn;
              else
                 alias int ThreadReturn;

        override ThreadReturn run ()
        {
                ProtocolWriter.Command  cmd;
                char[]                  channel;
                char[]                  element;

                logger.info (client ~ ": starting service handler");
                //cache.trace ();
                //queue.trace ();
                
                try {
                    while (true)
                          {
                          // start with a clear buffer
                          buffer.clear ();

                          // wait for a request to arrive
                          ClusterContent content = reader.getPacket (channel, element, cmd);

                          // are we enabled for logging?
                          bool log = logger.isEnabled (logger.Level.Trace);

                          try {
                              switch (cmd)
                                     {
                                     case ProtocolWriter.Command.Add:
                                          if (log)
                                              logger.trace (msg1 ("add cache entry '", element, channel)); 

                                          cache.put (channel, element, content);
                                          writer.success ("success"); 
                                          break;
 
                                     case ProtocolWriter.Command.Copy:
                                          if (log)
                                              logger.trace (msg1 ("copy cache entry '", element, channel)); 

                                          writer.reply (cache.get (channel, element)); 
                                          break;
  
                                     case ProtocolWriter.Command.Remove:
                                          if (log)
                                              logger.trace (msg1 ("remove cache entry '", element, channel)); 

                                          writer.reply (cache.extract (channel, element));
                                          break;

                                     case ProtocolWriter.Command.AddQueue:
                                          if (log)
                                              logger.trace (msg ("add queue entry '", channel)); 

                                          if (queue.put (channel, content))
                                              writer.success ();
                                          else
                                             writer.full ("cluster queue is full");
                                          break;

                                     case ProtocolWriter.Command.RemoveQueue:
                                          if (log)
                                              logger.trace (msg ("remove queue entry '", channel)); 

                                          writer.reply (queue.get (channel));
                                          break;

                                     default:
                                          throw new Exception ("invalid command");
                                     }
                                } catch (Object x)
                                        {
                                        logger.error (msg ("cluster request exception '", x.toString));
                                        writer.exception ("cluster request exception: "~x.toString);
                                        }

                          // send response back to client
                          buffer.flush ();
                          }

                    } catch (IOException x)
                             if (! Socket.isHalting)
                                   logger.trace (msg ("cluster socket exception '", x.toString));

                      catch (Object x)
                             logger.fatal (msg ("cluster runtime exception '", x.toString));

                // log our halt status
                logger.info (client ~ ": halting service handler");

                // make sure we close the conduit
                buffer.getConduit.close ();

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
