/*******************************************************************************

        @file ClusterServer.d
        
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

module mango.cluster.qos.socket.ClusterServer;

version = NO_DEBUG;

private import  mango.io.Buffer,
                mango.io.Exception,
                mango.io.ServerSocket,
                mango.io.SocketConduit,
                mango.io.PickleRegistry,
                mango.io.ArrayAllocator;

private import  mango.io.model.IConduit;

private import  mango.cache.model.ICache;

private import  mango.utils.ServerThread,
                mango.utils.AbstractServer;

private import  mango.cluster.qos.socket.Cluster,
                mango.cluster.qos.socket.RollCall,
                mango.cluster.qos.socket.ClusterCache,
                mango.cluster.qos.socket.ClusterThread,
                mango.cluster.qos.socket.ProtocolReader,
                mango.cluster.qos.socket.ProtocolWriter;
                
/******************************************************************************
        
        Extends the AbstractServer to glue cluster-server support together.
        Note that there may only be one server running for any given host
        name. This is to make it easier to manage the server(s) via one or
        more http clients. If you require more than one server per machine,
        virtual hosting will need to be provided.

******************************************************************************/

class ClusterServer : AbstractServer, IEventListener
{
        private ClusterCache    cache;
        private ClusterQueue    queue;
        private Cluster         cluster;
        private IChannel        channel;
        private RollCall        rollcall;
        private CacheServer     taskServer;

        /**********************************************************************

                Construct this server with the requisite attributes. The 
                'bind' address is the local address we'll be listening on, 
                'threads' represents the number of socket-accept threads, 
                and backlog is the number of "simultaneous" connection 
                requests that a socket layer will buffer on our behalf.

                We also set up a listener for client discovery-requests, 
                and lastly, we tell active clients that we're available 
                for work. Clients should be listening on the appropriate 
                channel for an instance of the RollCall payload.

        **********************************************************************/

        this (InternetAddress bind, int threads, ILogger logger = null)
        {
                super (bind, threads, 10, logger);
                logger = getLogger();

                // hook into the cluster
                cluster = new Cluster (logger);

                // create an identity for ourselves
                rollcall = new RollCall (Socket.hostName(), bind.port(), 0);

                // clients are listening on this channel ...
                channel = cluster.createChannel ("cluster.server.advertise");

                version (NO_DEBUG)
                {
                // ... and listen for subsequent server.advertise requests
                cluster.createConsumer (channel, IEvent.Style.Bulletin, this);

                // construct a server for cache tasks
                InternetAddress addr = new InternetAddress (bind.toAddrString(), bind.port+1);
                taskServer = new CacheServer (this, addr, 20, logger);
                
                // enroll cache tasks
                enroll (logger);
                }
        }

        /**********************************************************************

        **********************************************************************/

        void enroll (ILogger logger)
        {
        }

        /**********************************************************************

        **********************************************************************/

        void addCacheLoader (IPayload loader, bool enroll = false)
        {
                char[] name = loader.getGuid;

                cluster.getLogger.info ("adding cache loader '" ~ name ~ "'");
        
                if (enroll)
                    PickleRegistry.enroll (loader);
        }

        /**********************************************************************

                Start this server

        **********************************************************************/

        void start ()
        {
                // cache with 101 entries
                if (cache is null)
                    cache = new ClusterCache (cluster, 101);

                // queue with 64MB ceiling & maximum of 1 second dispatch
                if (queue is null)
                    queue = new ClusterQueue (cluster, 64 * 1024 * 1024, 1_000_000);
                
                super.start();

                version (NO_DEBUG)
                {
                taskServer.start();
                }

                // tell everyone about ourselves ...
                cluster.broadcast (channel, rollcall);
        }

        /**********************************************************************

                Use this before starting the server

        **********************************************************************/

        void setCache (ClusterCache cache)
        {
                this.cache = cache;
        }

        /**********************************************************************

        **********************************************************************/

        ClusterCache getCache ()
        {
                return cache;
        }

        /**********************************************************************

                Use this before starting the server

        **********************************************************************/

        void setQueue (ClusterQueue queue)
        {
                this.queue = queue;
        }

        /**********************************************************************

                Return the protocol in use.

        **********************************************************************/

        char[] getProtocol()
        {
                return "cluster";
        }

        /**********************************************************************

                Interface method that's invoked when a client is making
                discovery requests. We just send back our identity in a
                reply.

        **********************************************************************/

        void notify (IEvent event, IPayload payload)
        {
                RollCall input = cast(RollCall) payload;

                // if this is a request, reply with our identity
                if (input.request)
                    cluster.broadcast (channel, rollcall);
        }

        /**********************************************************************

                Return a text string identifying this server

        **********************************************************************/

        override char[] toString()
        {
                return getProtocol() ~ "::Host";
        }

        /**********************************************************************

                Create a ServerSocket instance. 

        **********************************************************************/

        override ServerSocket createSocket (InternetAddress bind, int backlog)
        {
                return new ServerSocket (bind, backlog);
        }

        /**********************************************************************

                Create a ServerThread instance. This can be overridden to 
                create other thread-types, perhaps with additional thread-
                level data attached.

        **********************************************************************/

        override ServerThread createThread (ServerSocket socket)
        {
                return new ServerThread (this, socket);
        }

        /**********************************************************************

                Factory method for servicing a request. We just create
                a new ClusterThread to handle requests from the client.
                The thread does not exit until the socket connection is
                broken by the client, or some other exception occurs. 

        **********************************************************************/

        override void service (ServerThread st, IConduit conduit)
        {
                ClusterThread thread = new ClusterThread (this, conduit, 
                                                          cluster, cache, queue);
                thread.start();
        }
}



/******************************************************************************
        
******************************************************************************/

private class CacheServer : AbstractServer
{
        private ClusterServer cs;

        /**********************************************************************

        **********************************************************************/

        this (ClusterServer cs, InternetAddress bind, int threads, ILogger logger = null)
        {
                super (bind, threads, 10, logger);
                this.cs = cs;
        }

        /**********************************************************************

                Return the protocol in use.

        **********************************************************************/

        char[] getProtocol()
        {
                return "cluster";
        }

        /**********************************************************************

                Return a text string identifying this server

        **********************************************************************/

        override char[] toString()
        {
                return getProtocol() ~ "::Tasks";
        }

        /**********************************************************************

                Create a ServerSocket instance. 

        **********************************************************************/

        override ServerSocket createSocket (InternetAddress bind, int backlog)
        {
                return new ServerSocket (bind, backlog);
        }

        /**********************************************************************

                Create a ServerThread instance. This can be overridden to 
                create other thread-types, perhaps with additional thread-
                level data attached.

        **********************************************************************/

        override ServerThread createThread (ServerSocket socket)
        {
                return new LoaderThread (this, socket, cs);
        }

        /**********************************************************************

                Factory method for servicing a request.  

        **********************************************************************/

        override void service (ServerThread st, IConduit conduit)
        {
                // we know what this is cos' we created it (above)
                LoaderThread tt = cast(LoaderThread) st;
        
                // unpickle task and execute it
                tt.load (conduit);
        }

        /**********************************************************************


        **********************************************************************/

        class LoaderThread : ServerThread
        {
                private ClusterCache    cache;
                private IBuffer         buffer;
                private ProtocolReader  reader;
                private ProtocolWriter  writer;
                private ILogger         logger;

                /**************************************************************


                **************************************************************/

                this (AbstractServer server, ServerSocket socket, ClusterServer cs)
                {
                        super (server, socket);

                        // maximum of 8K for ITask instance 
                        // perhaps make this a GrowableBuffer?
                        buffer = new Buffer (1024 * 8);

                        // hook protocol IO to the buffer
                        writer = new ProtocolWriter (buffer);

                        // make the reader slice directly from the buffer content
                        reader = new ProtocolReader (buffer);
                        reader.setAllocator (new BufferAllocator);
                        
                        // extract the ILogger instance
                        logger = server.getLogger;

                        // extract the ClusterCache
                        cache = cs.getCache ();
                }

                /**************************************************************


                **************************************************************/

                void load (IConduit conduit)
                {
                        ubyte           cmd;
                        IPayload        entry;
                        char[]          element,
                                        channel;

                        // start afresh
                        buffer.clear ();

                        // bind the buffer (and hence reader) to the conduit
                        buffer.setConduit (conduit);

                        //printf ("remote loader\n");
                        // instantiate the loader
                        IPayload p = reader.getPayload (channel, element, cmd);
                        ulong time = p.getTime ();

                        // check to see if it has already been updated or is
                        // currently locked; go home if so, otherwise lock it
                        if (! cache.lockWhereInvalid (channel, element, time))
                              writer.success().flush();
                        else
                           try {                                                
                               // say what's going on
                               if (logger.isEnabled (logger.Level.Trace))
                                   logger.trace ("loading cache for channel '" ~ channel ~
                                                 "' via key '" ~ element ~ "'");

                               // ensure this is the right object
                               IRemoteCacheLoader loader = cast(IRemoteCacheLoader) p;
                               if (loader)
                                  {
                                  // acknowledge the request. Do NOT wait for completion!
                                  writer.success ().flush();

                                  // get the new cache entry
                                  p = loader.load (element, time);

                                  if (p)
                                     {
                                     // serialize new entry and stuff it into cache
                                     writer.put (writer.Command.OK, channel, p, element);
                                     cache.put  (channel, element, reader.getPacket (channel, element, cmd));
                                     }
                                  }
                               else
                                  writer.exception ("invalid remote cache-loader").flush();

                               } catch (Object o)
                                        writer.exception (o.toString).flush();
                                 finally 
                                       // ensure we unlock this one!
                                       cache.unlock (channel, element);
                }
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
