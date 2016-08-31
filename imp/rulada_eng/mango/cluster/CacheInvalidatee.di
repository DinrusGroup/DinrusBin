/*******************************************************************************

        @file CacheInvalidatee.d
        
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

module mango.cluster.CacheInvalidatee;

private import  mango.log.Logger;

private import  mango.cache.Payload;

private import  mango.cache.model.ICache;

private import  mango.cluster.model.ICluster;

private import  mango.cluster.Client,
                mango.cluster.CacheInvalidator;
                
/*******************************************************************************

        Wrapper around an ICache instance that attaches it to the network, 
        and ensures the former complies with cache invalidation requests. 
        Use this in conjunction with CacheInvalidator or NetworkCombo. The 
        ICache provided should typically be synchronized against thread 
        contention since it will potentially have entries removed from a 
        listener thread (you won't need synchronization if you're using
        the concurrent hash-map ICache implementation).

*******************************************************************************/

class CacheInvalidatee : Client, IEventListener
{
        private IMutableCache   cache;
        private ILogger         logger;
        private IConsumer       consumer;

        /***********************************************************************

                Construct a CacheInvalidatee upon the given cache, using
                the named channel. This channel should be a name that's 
                common to both the receiver and the sender.

        ***********************************************************************/
        
        this (ICluster cluster, char[] channel, IMutableCache cache)
        in {
           assert (cache);
           }
        body
        {
                super (cluster, channel);

                this.cache = cache;
                this.logger = cluster.getLogger;
        
                // make sure we have a logger configured
                if (this.logger is null)
                    throw new ClusterException ("CacheInvalidatee requires the "
                                                "cluster to have a logger configured");
        
                // start listening for invalidation requests
                consumer = getCluster.createConsumer (getChannel(), IEvent.Style.Bulletin, this);
        }

        /***********************************************************************

                Detach from the network. The CacheInvalidatee is disabled
                from this point forward.

        ***********************************************************************/
        
        void cancel ()
        {
                consumer.cancel ();
        }

        /***********************************************************************

                Return the IMutableCache instance provided during construction

        ***********************************************************************/
        
        IMutableCache getCache ()
        {
                return cache;
        }

        /***********************************************************************

                Notification callback from the listener. We remove the
                indicated entry from our cache and destroy the payload
                immediately in case it belongs on a freelist.

        ***********************************************************************/
        
        protected void notify (IEvent event, IPayload payload)
        {
                assert (payload);

                try {
                    InvalidatorPayload p = cast(InvalidatorPayload) payload;

                    // remove entry from our cache
                    if (cache.extract (p.getText, p.getTimeout))
                        if (logger.isEnabled (logger.Level.Trace))
                            logger.trace ("removed cache entry '"~p.getText~
                                          "' on channel '"~event.getChannel.getName~"'");
                    } finally
                            // place payload back on freelist?
                            payload.destroy ();
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
