/*******************************************************************************

        @file Cluster.d
        
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

module mango.cluster.qos.socket.Cluster;

private import  mango.cache.HashMap;

private import  mango.utils.Random;

private import  mango.convert.Integer;

private import  mango.sys.System;

private import  mango.io.Buffer,
                mango.io.Socket,
                mango.io.Exception,
                mango.io.Properties,
                mango.io.GrowBuffer,
                mango.io.ArrayAllocator,
                mango.io.SocketConduit,
                mango.io.SocketListener,
                mango.io.MulticastSocket;

private import  mango.io.model.IConduit;

private import  mango.log.model.ILogger;

private import  mango.cluster.Client;

public  import  mango.cluster.model.ICluster;

private import  mango.cluster.qos.socket.RollCall,
                mango.cluster.qos.socket.ClusterEvent,
                mango.cluster.qos.socket.ProtocolReader,
                mango.cluster.qos.socket.ProtocolWriter;


/*******************************************************************************
        
        QOS implementation for sockets. All cluster-client activity is 
        gated through here by the higher level classes; NetworkQueue &
        NetworkCache for example. You gain access to the cluster by 
        creating an instance of the QOS (quality of service) you desire
        and mapping client classes onto it. For example:

        @code
        import mango.cluster.NetworkCache;
        import mango.cluster.qos.socket.Cluster;

        ICluster cluster = new Cluster (...);
        NetworkCache cache = new NetworkCache (cluster, ...);

        cache.put (...);
        cache.get (...);
        cache.invalidate (...);
        @endcode

        Please see the cluster clients for additional details. Currently
        these include CacheInvalidator, CacheInvalidatee, NetworkMessage, 
        NetworkTask, NetworkQueue, NetworkCache, NetworkCombo, plus the 
        Client base-class.

*******************************************************************************/

class Cluster : ICluster, IEventListener
{  
        private static HashMap                  groups;
        private ILogger                         logger;
        private NodeSet                         nodeSet;
        private Buffer                          mBuffer;
        private ProtocolWriter                  mWriter;
        private MulticastSocket                 mSocket;

        private int                             groupTTL = 1;
        private int                             groupPort = 3333;
        private int                             groupPrefix = 225;
     
        /***********************************************************************

                Setup a hashmap for multicast group addresses

        ***********************************************************************/
        
        static this ()
        {
                groups = new HashMap (128, 0.75, 2);
        }

        /***********************************************************************

                Setup a Cluster instance. Currently the buffer & writer
                are shared for all bulletin serialization; this should
                probably change at some point such that we can support 
                multiple threads broadcasting concurrently to different 
                output ports.

        ***********************************************************************/
        
        this (ILogger logger = null)
        {
                this.logger = logger;
                nodeSet = new NodeSet (logger);
                mBuffer = new Buffer (1024 * 4);
                mSocket = new MulticastSocket;
                mWriter = new ProtocolWriter (mBuffer);
        }

        /***********************************************************************

                Setup a Cluster instance. Currently the buffer & writer
                are shared for all bulletin serialization; this should
                probably change at some point such that we can support 
                multiple threads broadcasting concurrently to different 
                output ports.

        ***********************************************************************/
        
        this (ILogger logger, IConduit conduit)
        in {
           assert (logger);
           assert (conduit);
           }
        body
        {
                this (logger);

                // callback for loading cluster configuration 
                void loader (char[] name, char[] value)
                {
                        logger.info ("cluster config: "~name~" = "~value);
                        if (name == "node")
                            nodeSet.addNode (new Node (logger, value));
                        else
                        if (name == "multicast_port")
                            groupPort = cast(int) Integer.parse (value);
                        else
                           if (name == "multicast_prefix")
                               groupPrefix = cast(int) Integer.parse (value);
                        else
                           if (name == "multicast_ttl")
                               groupTTL = cast(int) Integer.parse (value);
                        else
                           throw new ClusterException ("Unrecognized attribute '"~name~"' in socket.Cluster configuration");
                }


                // load up the cluster configuration
                Properties.load (conduit, &loader);

                // finalize nodeSet 
                nodeSet.optimize ();

                // listen for cluster servers
                IChannel channel = createChannel ("cluster.server.advertise");
                createConsumer (channel, IEvent.Style.Bulletin, this);

                // ask who's currently running
                logger.trace ("discovering active cluster servers ...");
                broadcast (channel, new RollCall (Socket.hostName(), 0, 0, true));

                // wait for enabled servers to respond ...
                System.sleep (System.Interval.Millisec * 250);
        }

        /***********************************************************************

                Setup a Cluster instance. Currently the buffer & writer
                are shared for all bulletin serialization; this should
                probably change at some point such that we can support 
                multiple threads broadcasting concurrently to different 
                output ports.

        ***********************************************************************/
        
        this (ILogger logger, uint serverPort)
        in {
           assert (logger);
           assert (serverPort > 1024);
           }
        body
        {
                this (logger);

                Node node = new Node (logger, "local");
                node.setCache (new InternetAddress ("localhost", serverPort));
                node.setTasks (new InternetAddress ("localhost", serverPort+1));
                node.setEnabled (true);
                nodeSet.addNode (node);
                nodeSet.optimize ();
        }

        /***********************************************************************

                IEventListener interface method for listening to RollCall
                responses. These are sent out by cluster servers both when 
                they get a RollCall request, and when they begin execution.

        ***********************************************************************/

        void notify (IEvent event, IPayload payload)
        {
                RollCall rollcall = cast(RollCall) payload;

                // ignore requests from clients (we're on a common channel)
                if (! rollcall.request)
                      nodeSet.enable (rollcall.name, 
                                      cast(ushort) rollcall.port1, 
                                      cast(ushort) rollcall.port2);
        }

        /***********************************************************************

                Create a channel instance. Our channel implementation 
                includes a number of cached IO helpers (ProtolcolWriter
                and so on) which simplifies and speeds up execution.

        ***********************************************************************/
        
        IChannel createChannel (char[] channel)
        {
                return new Channel (channel);
        }

        /***********************************************************************

                Return the logger instance provided during construction.
                
        ***********************************************************************/
        
        ILogger getLogger ()
        {
                return logger;
        }

        /***********************************************************************

                Broadcast a payload on the specified channel. This uses
                IP/Multicast to scatter the payload to all registered
                listeners (on the same multicast group). Note that the
                maximum payload size is limited to that of an Ethernet 
                data frame, minus the IP/UDP header size (1472 bytes).

        ***********************************************************************/
        
        synchronized void broadcast (IChannel channel, IPayload payload = null)
        {
                // serialize content
                mBuffer.clear ();
                mWriter.put (ProtocolWriter.Command.OK, channel.getName, payload);

                // Ethernet data-frame size minus the 28 byte UDP/IP header:
                if (mBuffer.getPosition > 1472)
                    throw new ClusterException ("payload is too large to broadcast");

                // send it to the appropriate multicast group
                mSocket.write (mBuffer, getGroup (channel.getName));
        }

        /***********************************************************************

                Create a listener of the specified type. Listeners are 
                run within their own thread, since they spend the vast 
                majority of their time blocked on a Socket read. Would
                be good to support multiplexed reading instead, such 
                that a thread pool could be applied instead.
                 
        ***********************************************************************/
        
        IConsumer createConsumer (IChannel channel, IEvent.Style style, 
                                  IEventListener notify)
        {
                IEvent event = new ClusterEvent (this, channel, style, notify);
                
                if (logger)
                    logger.info ("creating " ~ event.getStyleName ~ 
                                 " consumer for channel '" ~ channel.getName ~ "'");

                switch (style)
                       {
                       case IEvent.Style.Message:
                            return new MessageConsumer (this, event);

                       case IEvent.Style.Bulletin:
                            return new BulletinConsumer (this, event);

                       default:
                            throw new ClusterException ("Invalid consumer style");
                       }  
               return null; 
        }

        /***********************************************************************

                Return a entry from the network cache, and optionally
                remove it. This is a synchronous operation as opposed
                to the asynchronous nature of an invalidate broadcast.

        ***********************************************************************/
        
        IPayload getCache (IChannel channel, char[] key, bool remove)
        {
                Channel c = cast(Channel) channel;
                
                c.writer.put (remove ? ProtocolWriter.Command.Remove : 
                              ProtocolWriter.Command.Copy, c.getName, null, key);
                return nodeSet.request (c.writer, c.reader, key);
        }

        /***********************************************************************

                Place an entry into the network cache, replacing the
                entry with the identical key. Note that this may cause
                the oldest entry in the cache to be displaced if the
                cache is already full.

        ***********************************************************************/
        
        IPayload putCache (IChannel channel, char[] key, IPayload payload)
        {
                Channel c = cast(Channel) channel;

                c.writer.put (ProtocolWriter.Command.Add, c.getName, payload, key);
                return nodeSet.request (c.writer, c.reader, key);
        }

        /***********************************************************************

                Add an entry to the specified network queue. May throw a
                QueueFullException if there's no room available.

        ***********************************************************************/
        
        IPayload putQueue (IChannel channel, IPayload payload)
        {
                Channel c = cast(Channel) channel;
                
                c.writer.put (ProtocolWriter.Command.AddQueue, c.getName, payload);
                nodeSet.request (c.writer, c.reader);
                return payload;
        }


        /***********************************************************************
                
                Query the cluster for queued entries on the corresponding 
                channel. Returns, and removes, the first matching entry 
                from the cluster. Note that this sweeps the cluster for
                matching entries, and is synchronous in nature. The more
                common approach is to setup a queue listener, which will
                grab and dispatch queue entries asynchronously.

        ***********************************************************************/
        
        IPayload getQueue (IChannel channel)
        {
                IPayload payload;

                Channel c = cast(Channel) channel;

                // callback for NodeSet.scan()
                bool scan (Node node)
                {
                        // ask this node ...
                        c.writer.put (ProtocolWriter.Command.RemoveQueue, c.getName);
                        node.request (node.cache, c.writer, c.reader, payload);
                        return cast(bool) (payload !is null);
                }

                // make a pass over each Node, looking for channel entries
                nodeSet.scan (&scan);
                return payload;
        }

        /***********************************************************************
                
                Load a network cache entry remotely. This sends the given
                Payload over the network to the cache host, where it will
                be executed locally. The benefit of doing so it that the
                host may deny access to the cache entry for the duration
                of the load operation. This, in turn, provides an elegant 
                mechanism for gating/synchronizing multiple network clients  
                over a given cache entry; handy for those entries that are 
                relatively expensive to construct or access. 

        ***********************************************************************/
        
        void loadCache (IChannel channel, char[] key, IPayload payload)
        {               
                Channel c = cast(Channel) channel;

                c.writer.put (ProtocolWriter.Command.OK, c.getName, payload, key);
                Node node = nodeSet.selectNode (key);
                node.request (node.tasks, c.writer, c.reader, payload);
        }

        /***********************************************************************

                Return an internet address representing the multicast
                group for the specified channel. We use three of the
                four address segments to represent the channel itself
                (via a hash on the channel name), and set the primary
                segment to be that of the broadcast prefix (above).

        ***********************************************************************/
        
        synchronized InternetAddress getGroup (char[] channel)
        {
                InternetAddress group = cast(InternetAddress) groups.get (channel);

                if (group is null)
                   {
                   // construct a group address from the prefix & channel-hash,
                   // where the hash is folded down to 24 bits
                   uint hash = groups.jhash (channel);
                   hash = (hash >> 24) ^ (hash & 0x00ffffff);
                  
                   char[] address = Integer.format (new char[5], groupPrefix) ~ "." ~
                                    Integer.format (new char[5], (hash >> 16) & 0xff) ~ "." ~
                                    Integer.format (new char[5], (hash >> 8) & 0xff) ~ "." ~
                                    Integer.format (new char[5], hash & 0xff);

                   //printf ("channel '%.*s' == '%.*s'\n", channel, address);
        
                   // insert InternetAddress into hashmap
                   group = new InternetAddress (address, groupPort);
                   groups.put (channel, group);
                   }
                return group;              
        }
}


/*******************************************************************************         

        A listener for multicast channel traffic. These are currently used 
        for cache coherency, queue publishing, and node discovery activity; 
        though could be used for direct messaging also.

*******************************************************************************/

private class BulletinConsumer : SocketListener, IConsumer
{
        private IEvent                  event;
        private Buffer                  buffer;
        private ProtocolReader          reader;
        private Cluster                 cluster;
        private MulticastSocket         consumer;

        /***********************************************************************

                Construct a multicast consumer for the specified event. The
                event handler will be invoked whenever a message arrives for
                the associated channel.

        ***********************************************************************/
        
        this (Cluster cluster, IEvent event)
        {
                this.event = event;
                this.cluster = cluster;

                // buffer doesn't need to be larger than Ethernet data-frame
                buffer = new Buffer (1500);

                // make the reader slice directly from the buffer content
                reader = new ProtocolReader (buffer);
                reader.setAllocator (new BufferAllocator);

                // configure a listener socket
                consumer = new MulticastSocket;
                consumer.join (cluster.getGroup (event.getChannel.getName));
                
                super (consumer, buffer);

                // fire up this listener
                start ();
        }

        /***********************************************************************

                Notification callback invoked when we receive a multicast
                packet. Note that we check the packet channel-name against
                the one we're consuming, to check for cases where the group
                address had a hash collision.

        ***********************************************************************/
        
        override void notify (IBuffer buffer)
        {
                ProtocolWriter.Command  cmd;
                char[]                  channel;
                char[]                  element;
                
                IPayload payload = reader.getPayload (channel, element, cmd);
                // printf ("notify '%.*s::%.*s' #'%.*s'\n", channel, element, event.getChannel.getName);

                // check it's really for us first (might be a hash collision)
                if (channel == event.getChannel.getName)
                    invoke (event, payload);
        }

        /***********************************************************************

                Handle error conditions from the listener thread.

        ***********************************************************************/

        override void exception (char [] msg)
        {
                cluster.getLogger.error ("BulletinConsumer: "~msg);
        }

        /***********************************************************************

                Overridable mean of notifying the client code.
                 
        ***********************************************************************/
        
        protected void invoke (IEvent event, IPayload payload)
        {
                event.invoke (payload);
        }

        /***********************************************************************

                Return the cluster instance we're associated with.

        ***********************************************************************/
        
        Cluster getCluster ()
        {
                return cluster;
        }

        /***********************************************************************

                Temporarily halt listening. This can be used to ignore
                multicast messages while, for example, the consumer is
                busy doing other things.

        ***********************************************************************/

        void pauseGroup ()
        {
                consumer.pauseGroup ();
        }

        /***********************************************************************

                Resume listening, post-pause.

        ***********************************************************************/

        void resumeGroup ()
        {
                consumer.resumeGroup ();
        }

        /***********************************************************************

                Cancel this consumer. The listener is effectively disabled
                from this point forward. The listener thread does not halt
                at this point, but waits until the socket-read returns. 
                Note that the D Interface implementation requires us to 
                "reimplement and dispatch" trivial things like this ~ it's
                a pain in the neck to maintain.

        ***********************************************************************/
        
        void cancel ()
        {
                super.cancel ();
        }
}


/*******************************************************************************
        
        A listener for queue events. These events are produced by the 
        queue host on a periodic bases when it has available entries.
        We listen for them (rather than constantly scanning) and then
        begin a sweep to process as many as we can. Note that we will
        be in competition with other nodes to process these entries.

*******************************************************************************/

private class MessageConsumer : BulletinConsumer
{
        /***********************************************************************

                Construct a multicast consumer for the specified event

        ***********************************************************************/
        
        this (Cluster cluster, IEvent event)
        {
                super (cluster, event);
        }

        /***********************************************************************

                Handle error conditions from the listener thread.

        ***********************************************************************/

        override void exception (char [] msg)
        {
                cluster.getLogger.error ("MessageConsumer: "~msg);
        }

        /***********************************************************************

                override the default processing to sweep the cluster for 
                queued entries. Each server node is queried until one is
                found that contains a payload. Note that it is possible 
                to set things up where we are told exactly which node to
                go to; howerver given that we won't be listening whilst
                scanning, and that there's likely to be a group of new
                entries in the cluster, it's just as effective to scan.
                This will be far from ideal for all environments, so we 
                should make the strategy plugable instead.                 

        ***********************************************************************/
        
        override protected void invoke (IEvent event, IPayload payload)
        {
                //temporarilty pause listening
                pauseGroup ();

                try {
                    while ((payload = getCluster.getQueue (event.getChannel)) !is null)
                            event.invoke (payload);
                    } finally 
                            // resume listening
                            resumeGroup ();
        }
}


/*******************************************************************************
        
        A channel represents something akin to a publish/subscribe topic, 
        or a radio station. These are used to segregate cluster operations
        into a set of groups, where each group is represented by a channel.
        Channel names are whatever you want then to be: use of dot notation 
        has proved useful in the past. See Client.createChannel

*******************************************************************************/

private class Channel : IChannel
{
        char[]                  name;
        GrowBuffer              buffer;
        ProtocolReader          reader;
        ProtocolWriter          writer;

        /***********************************************************************
        
                Construct a channel with the specified name. We cache
                a number of session-related constructs here also, in
                order to eliminate runtime overhead

        ***********************************************************************/

        this (char[] name)
        in {
           assert (name.length);
           }
        body
        {       
                this.name = name;

                // this buffer will grow as required to house larger payloads
                buffer = new GrowBuffer (1024 * 2);
                writer = new ProtocolWriter (buffer);

                // make the reader slice directly from the buffer content
                reader = new ProtocolReader (buffer);
                reader.setAllocator (new BufferAllocator);
        }

        /***********************************************************************
        
                Return the name of this channel. This is the name provided
                when the channel was constructed.

        ***********************************************************************/

        char[] getName ()
        {
                return name;
        }

        /***********************************************************************
        
                Output this channel via the provided IWriter

        ***********************************************************************/

        void write (IWriter writer)
        {
                writer.put (name);
        }

        /***********************************************************************
        
                Input this channel via the provided IReader

        ***********************************************************************/

        void read (IReader reader)
        {
                reader.get (name);
        }
}


/*******************************************************************************
        
        An abstraction of a socket connection. Used internally by the 
        socket-based Cluster. 

*******************************************************************************/

private class Connection
{
        abstract bool reset();

        abstract void done (ulong time);

        abstract SocketConduit getConduit ();
}


/*******************************************************************************
        
        A pool of socket connections for accessing cluster nodes. Note 
        that the entries will timeout after a period of inactivity, and
        will subsequently cause a connected host to drop the supporting
        session.

*******************************************************************************/

private class ConnectionPool
{ 
        private int             count;
        private InternetAddress address;
        private PoolConnection  freelist;
        private const ulong     timeout = 60_000;

        /***********************************************************************
        
                Utility class to provide the basic connection facilities
                provided by the connection pool.

        ***********************************************************************/

        class PoolConnection : Connection
        {
                ulong           time;
                PoolConnection  next;   
                ConnectionPool  parent;   
                SocketConduit   conduit;

                /***************************************************************
                
                        Construct a new connection and set its parent

                ***************************************************************/
        
                this (ConnectionPool pool)
                {
                        parent = pool;
                        reset ();
                }
                  
                /***************************************************************

                        Return the socket belonging to this connection

                ***************************************************************/
        
                SocketConduit getConduit ()
                {
                        return conduit;
                }
                  
                /***************************************************************

                        Create a new socket and connect it to the specified 
                        server. This will cause a dedicated thread to start 
                        on the server. Said thread will quit when an error
                        occurs.

                ***************************************************************/
        
                bool reset ()
                {
                        try {
                            conduit = new SocketConduit ();
                            conduit.connect (parent.address);

                            // set a 500ms timeout for read operations
                            conduit.setTimeout (System.Interval.Millisec * 500);
                            return true;

                            } catch (Object)
                                    {
                                    return false;
                                    }
                }
                  
                /***************************************************************

                        Close the socket. This will cause any host session
                        to be terminated.

                ***************************************************************/
        
                void close ()
                {
                        conduit.close ();
                }

                /***************************************************************

                        Return this connection to the free-list. Note that
                        we have to synchronize on the parent-pool itself.

                ***************************************************************/

                void done (ulong time)
                {
                        synchronized (parent)
                                     {
                                     next = parent.freelist;
                                     parent.freelist = this;
                                     this.time = time;
                                     }
                }
        }


        /***********************************************************************

                Create a connection-pool for the specified address.

        ***********************************************************************/

        this (InternetAddress address)
        {      
                this.address = address;
        }

        /***********************************************************************

                Allocate a Connection from a list rather than creating a 
                new one. Reap old entries as we go.

        ***********************************************************************/

        synchronized Connection borrow (ulong time)
        {  
                if (freelist)
                    do {
                       PoolConnection c = freelist;

                       freelist = c.next;
                       if (freelist && (time - c.time > timeout))
                           c.close ();
                       else
                          return c;
                       } while (true);

                return new PoolConnection (this);
        }

        /***********************************************************************

                Close this pool and drop all existing connections.

        ***********************************************************************/

        synchronized void close ()
        {       
                PoolConnection c = freelist;
                freelist = null;
                while (c)
                      {
                      c.close ();
                      c = c.next;
                      }
        }
}


/*******************************************************************************
        
        Class to represent a cluster node. Each node supports both cache
        and queue functionality. Note that the set of available nodes is
        configured at startup, simplifying the discovery process in some
        significant ways, and causing less thrashing of cache-keys.

*******************************************************************************/

private class Node
{ 
        private char[]                  name,
                                        port;
        private ILogger                 logger;
        private bool                    enabled;

        private ConnectionPool          tasks,
                                        cache;

        /***********************************************************************

                Construct a node with the provided name. This name should
                be the network name of the hosting device.

        ***********************************************************************/
        
        this (ILogger logger, char[] name)
        {
                this.logger = logger;
                this.name = name;
        }

        /***********************************************************************

                Add a cache/queue reference for the remote node
                 
        ***********************************************************************/

        void setCache (InternetAddress address)
        {      
                this.cache = new ConnectionPool (address);
                port = Integer.format (new char[5], address.port);
        }

        /***********************************************************************

                Add a cache-loader reference for the remote node

        ***********************************************************************/

        void setTasks (InternetAddress address)
        {      
                this.tasks = new ConnectionPool (address);
        }

        /***********************************************************************

                Return the name of this node (the network name of the device)

        ***********************************************************************/
        
        override char[] toString ()
        {
                return name;
        }

        /***********************************************************************

                Remove this Node from the cluster. The node is disabled
                until it is seen to recover.

        ***********************************************************************/

        void fail ()
        {       
                setEnabled (false);
                cache.close ();    
                tasks.close ();    
        }

        /***********************************************************************

                Get the current state of this node

        ***********************************************************************/

        bool isEnabled ()
        {      
                volatile  
                       return enabled;    
        }

        /***********************************************************************

                Set the enabled state of this node

        ***********************************************************************/

        void setEnabled (bool enabled)
        {      
                if (logger && logger.isEnabled (logger.Level.Trace))
                   {
                   if (enabled)
                       logger.trace ("enabling node '"~name~"' on port "~port);
                   else
                      logger.trace ("disabling node '"~name~"'");
                   }
                volatile  
                       this.enabled = enabled;    
        }

        /***********************************************************************

                request data; fail this Node if we can't connect. Note
                that we make several attempts to connect before writing
                the node off as a failure.
                
        ***********************************************************************/
        
        bool request (ConnectionPool pool, ProtocolWriter writer, ProtocolReader reader, out IPayload payload)
        {       
                ProtocolWriter.Command  cmd;
                ulong                   time;
                char[]                  channel;
                char[]                  element;
                Connection              connect;

                // it's possible that the pool may have failed between 
                // the point of selecting it, and the invocation itself
                if (pool is null)
                    return false;

                // get a connection to the server
                connect = pool.borrow (time = System.getMillisecs);

                // talk to the server (try a few times if necessary)
                for (int attempts=3; attempts--;)
                     try {
                         // attach connection to reader and writer 
                         writer.getBuffer.setConduit (connect.getConduit);
                         reader.getBuffer.setConduit (connect.getConduit);
        
                         // send request
                         writer.flush ();

                         // load the returned object (don't retry!)
                         attempts = 0;
                         payload = reader.getPayload (channel, element, cmd);

                         // return borrowed connection
                         connect.done (time);

                         } catch (PickleException x)
                                 {
                                 connect.done (time);
                                 throw x;
                                 }
                           catch (IOException x)
                                  // attempt to reconnect?
                                  if (attempts == 0 || !connect.reset)
                                     {
                                     // that server is offline
                                     fail ();
  
                                     // state that we failed
                                     return false;
                                     }
                    
                // is payload an exception?
                if (cmd != ProtocolWriter.Command.OK)                       
                   {
                   // is node full?
                   if (cmd == ProtocolWriter.Command.Full)                       
                       throw new ClusterFullException (channel);

                   // did node barf?
                   if (cmd == ProtocolWriter.Command.Exception)                       
                       throw new ClusterException (channel);
                        
                   // bogus response
                   throw new ClusterException ("invalid response from cluster server");
                   }

                return true;
        }
}


/*******************************************************************************
        
        Models a set of remote cluster nodes.

*******************************************************************************/

private class NodeSet
{ 
        private HashMap         map;
        private Node[]          nodes;
        private Node[]          random;
        private ILogger         logger;

        /***********************************************************************

        ***********************************************************************/
        
        this (ILogger logger)
        {
                this.logger = logger;
                map = new HashMap (128, 0.75, 4);
        }

        /***********************************************************************

        ***********************************************************************/
        
        ILogger getLogger ()
        {
                return logger;
        }

        /***********************************************************************

                Add a node to the list of servers, and sort them such that
                all clients will have the same ordered set

        ***********************************************************************/
        
        synchronized void addNode (Node node)
        {
                char[]  name = node.toString;

                if (map.get (name))
                    throw new ClusterException ("Attempt to add cluster node '"~name~"' more than once");

                map.put (name, node);
                nodes ~= node;
                //nodes.sort;
        }

        /***********************************************************************

        ***********************************************************************/
        
        void optimize ()
        {
                // nodes are already in the same order across the cluster
                // since the configuration file should be identical ...

                // nodes.sort;
                
                // copy the node list
                random = nodes.dup;

                // muddle up the duplicate list. This randomized list
                // is used when scanning the cluster for queued entries
                foreach (int i, Node n; random)
                        {
                        int j = Random.get (random.length);
                        Node tmp = random[i];
                        random[i] = random[j];
                        random[j] = tmp;
                        }
        }

        /***********************************************************************

        ***********************************************************************/
        
        synchronized void enable (char[] name, ushort port1, ushort port2)
        {
                Node node = cast(Node) map.get (name);
                if (node is null)
                    throw new ClusterException ("Attempt to enable unknown cluster node '"~name~"'");
                else
                   if (! node.isEnabled)
                      {
                      node.setCache (new InternetAddress (name, port1));
                      node.setTasks (new InternetAddress (name, port2));
                      node.setEnabled (true);
                      }
        }

        /***********************************************************************

        ***********************************************************************/
        
        IPayload request (ProtocolWriter writer, ProtocolReader reader, char[] key = null)
        {
                Node     node;
                IPayload payload;

                do {
                   node = selectNode (key);
                   } while (! node.request (node.cache, writer, reader, payload));
                return payload;
        }

        /***********************************************************************

                Select a cluster server based on a starting index. If the
                selected server is not currently enabled, we just try the
                next one. This behaviour should be consistent across each
                cluster client.

        ***********************************************************************/
        
        private final Node selectNode (uint index)
        {
                uint i = nodes.length;

                if (i)
                   {
                   index %= i;

                   while (i--)
                         {
                         Node node = nodes[index];
                         if (node.isEnabled)
                             return node;
        
                         if (++index >= nodes.length)
                             index = 0;
                         }
                   }
                throw new ClusterEmptyException ("No cluster servers are available"); 
        }

        /***********************************************************************

                Select a cluster server based on the specified key. If the
                selected server is not currently enabled, we just try the
                next one. This behaviour should be consistent across each
                cluster client.

        ***********************************************************************/
        
        final Node selectNode (char[] key = null)
        {
                static uint index;
              
                if (key.length)
                    return selectNode (HashMap.jhash (key));

                // no key provided, so just roll the counter
                return selectNode (++index);
        }

        /***********************************************************************

                Sweep the cluster servers. Returns true if the delegate
                returns true, false otherwise. The sweep is aborted when
                the delegate returns true. Note that this scans nodes in
                a randomized pattern, which should tend to avoid 'bursty'
                activity by a set of clients upon any one cluster server.

        ***********************************************************************/
        
        bool scan (bool delegate (Node) dg)
        {
                Node    node;
                int     index = nodes.length;

                while (index--)
                      {
                      // lookup the randomized set of server nodes
                      node = random [index];

                      // callback on each enabled node
                      if (node.isEnabled)
                          if (dg (node))
                              return true;
                      }
                return false;
        }
}

 


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
