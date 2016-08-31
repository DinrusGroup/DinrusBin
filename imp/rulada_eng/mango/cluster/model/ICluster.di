/*******************************************************************************

        @file ICluster.d
        
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

module mango.cluster.model.ICluster;

private import  mango.io.model.IPickle;

public  import  mango.log.model.ILogger;

public  import  mango.cache.model.IPayload;

public  import  mango.cluster.model.IEvent,
                mango.cluster.model.IChannel,
                mango.cluster.model.IMessage,
                mango.cluster.model.IConsumer;

/*******************************************************************************

        The contract exposed by each QOS implementation. This is the heart
        of the cluster package, designed with multiple implementations in 
        mind. It should be reasonably straightforward to construct specific
        implementations upon a database, pub/sub system, or other substrates.

*******************************************************************************/

interface ICluster
{
        /***********************************************************************
                
                Create a channel instance. Every cluster operation has
                a channel provided as an argument

        ***********************************************************************/
        
        IChannel createChannel (char[] channel);

        /***********************************************************************

                Scatter a payload to all registered listeners. This is
                akin to multicast.

        ***********************************************************************/
        
        void broadcast (IChannel channel, IPayload payload = null);

        /***********************************************************************

                Create a listener of the specified style on the given
                channel. The IEventListener should be called whenever
                a corresponding cluster event happens. Note that the
                notification is expected to be on a seperate thread.

        ***********************************************************************/
        
        IConsumer createConsumer (IChannel channel, IEvent.Style style, 
                                  IEventListener notify);

        /***********************************************************************

                Return a cluster cache entry, and optionally remove it
                from the cluster.

        ***********************************************************************/
        
        IPayload getCache (IChannel channel, char[] key, bool remove);

        /***********************************************************************

                Place a cache entry into the cluster. If there is already
                a matching entry, it is replaced.

        ***********************************************************************/
        
        IPayload putCache (IChannel channel, char[] key, IPayload payload);

        /***********************************************************************

                Place a new entry into the cluster queue. This may throw
                a ClusterFullException when there is no space left within
                the cluster queues.

        ***********************************************************************/
        
        IPayload putQueue (IChannel channel, IPayload payload);

        /***********************************************************************
                
                Query the cluster for queued entries on our corresponding 
                channel. Returns, and removes, the first matching entry 
                from the cluster.

        ***********************************************************************/
        
        IPayload getQueue (IChannel channel);

        /***********************************************************************
                
        ***********************************************************************/
        
        void loadCache (IChannel channel, char[] key, IPayload payload);

        /***********************************************************************

                Return the Logger associated with this cluster

        ***********************************************************************/
        
        ILogger getLogger ();
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
