/*******************************************************************************

        @file NetworkQueue.d
        
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

module mango.cluster.NetworkQueue;

private import  mango.cluster.Client;

/*******************************************************************************

        Exposes a gateway to the cluster queues, which collect IPayload
        objects until they are removed. Because there is a finite limit
        to the quantity of entries stored, the put() method may throw a
        ClusterFullException if it cannot add a new entry.

*******************************************************************************/

class NetworkQueue : Client
{
        /***********************************************************************

                Construct a NetworkQueue gateway on the provided QOS cluster
                for the specified channel. Each subsequent queue operation
                will take place over the given channel.

        ***********************************************************************/
        
        this (ICluster cluster, char[] channel)
        {
                super (cluster, channel);
        }

        /***********************************************************************

                Create a listener for this channel. Listeners are invoked
                when new content is placed into a corresponding queue.

        ***********************************************************************/
        
        IConsumer createConsumer (IEventListener listener)
        {
                return getCluster.createConsumer (getChannel, IEvent.Style.Message, listener);
        }

        /***********************************************************************
        
                Add an IPayload entry to the corresponding queue. This
                will throw a ClusterFullException if there is no space
                left in the clustered queue.

        ***********************************************************************/
        
        void put (IPayload payload)
        {
                getCluster.putQueue (getChannel, payload);
        }

        /***********************************************************************
                
                Query the cluster for queued entries on our corresponding 
                channel. Returns, and removes, a matching entry from the 
                cluster. This is the synchronous (polling) approach; you
                should use createConsumer() instead for asynchronous style
                notification instead.

        ***********************************************************************/
        
        IPayload get ()
        {
                return getCluster.getQueue (getChannel);
        }
}


/*******************************************************************************

*******************************************************************************/

class NetworkMessage : NetworkQueue, IConsumer
{
        private IChannel        reply;
        private IConsumer       consumer;

        /***********************************************************************

                Construct a NetworkMessage gateway on the provided QOS cluster
                for the specified channel. Each subsequent queue operation
                will take place over the given channel.

                You can listen for cluster replies by providing an optional 
                IEventListener. Outgoing messages will be tagged appropriately
                such that a consumer can respond using IEvent.reply().

        ***********************************************************************/
        
        this (ICluster cluster, char[] channel, IEventListener listener = null)
        {
                super (cluster, channel);

                if (listener)
                   {
                   reply = cluster.createChannel (channel ~ ".reply");
                   consumer = cluster.createConsumer (reply, IEvent.Style.Message, listener);
                   }
        }

        /***********************************************************************

                Cancel the listener. No more events will be dispatched to
                the reply IEventListener.

        ***********************************************************************/
        
        void cancel()
        {
                if (consumer)
                    consumer.cancel ();
        }

        /***********************************************************************
        
                Add an IMessage entry to the corresponding queue. This
                will throw a ClusterFullException if there is no space
                left in the clustered queue.

        ***********************************************************************/
        
        void put (IMessage message)
        {
                if (reply)
                    message.setReply (reply.getName);

                super.put (message);
        }
}


/*******************************************************************************

*******************************************************************************/

class NetworkTask : NetworkMessage
{
        /***********************************************************************

                Construct a NetworkTask gateway on the provided QOS cluster
                for the specified channel. Each subsequent queue operation
                will take place over the given channel.

                You can listen for cluster replies by providing an optional 
                IEventListener. Outgoing tasks will be tagged appropriately
                such that a consumer can respond using IEvent.reply().

        ***********************************************************************/
        
        this (ICluster cluster, char[] channel, IEventListener listener = null)
        {
                super (cluster, channel, listener);
        }

        /***********************************************************************
        
                Add an ITask entry to the corresponding queue. This
                will throw a ClusterFullException if there is no space
                left in the clustered queue.

        ***********************************************************************/
        
        void put (ITask task)
        {
                super.put (task);
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
