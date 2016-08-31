/*******************************************************************************

        @file NetworkCache.d
        
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

module mango.cluster.NetworkCache;

private import  mango.sys.System;

private import  mango.cache.model.ICache;

private import  mango.cluster.CacheInvalidator,
                mango.cluster.CacheInvalidatee;

/*******************************************************************************

        A gateway to the network cache. From here you can easily place
        IPayload objects into the network cluster, copy them and remove 
        them. A cluster cache is spread out across many servers within 
        the network. Each cache entry is associated with a 'channel', 
        which is effectively the name of a cache instance within the
        cluster. See ComboCache also. The basic procedure is so:

        @code
        import mango.cluster.NetworkCache;
        import mango.cluster.qos.socket.Cluster;

        ICluster cluster = new Cluster (...);
        NetworkCache cache = new NetworkCache (cluster, ...);

        cache.put (...);
        cache.get (...);
        cache.invalidate (...);
        @endcode

        Note that any content placed into the cache must implement the
        IPayload interface, and must be enrolled with PickleRegistry, as
        it will be frozen and thawed as it travels around the network.

*******************************************************************************/

class NetworkCache : CacheInvalidator
{
        /***********************************************************************

                Construct a NetworkCache using the QOS (cluster) provided, 
                and hook it onto the specified channel. Each subsequent 
                operation is tied to this channel.

        ***********************************************************************/
        
        this (ICluster cluster, char[] channel)
        {
                super (cluster, channel);
        }

        /***********************************************************************

                Returns a copy of the cluster cache entry corresponding to 
                the provided key. Returns null if there is no such entry.

        ***********************************************************************/
        
        IPayload get (char[] key)
        in {
           assert (key.length);
           }
        body
        {
                return getCluster.getCache (getChannel, key, false);
        }

        /***********************************************************************

                Remove and return the cache entry corresponding to the 
                provided key.

        ***********************************************************************/
        
        IPayload extract (char[] key)
        in {
           assert (key.length);
           }
        body
        {
                return getCluster.getCache (getChannel, key, true);
        }

        /***********************************************************************

                Add a cluster cache entry. The entry will be placed in
                one or more of the cluster servers (depending upon QOS).

        ***********************************************************************/
        
        IPayload put (char[] key, IPayload payload)
        in {
           assert (key.length);
           assert (payload);
           }
        body
        {
                return getCluster.putCache (getChannel, key, payload);
        }


        /**********************************************************************

                Bind a local loader to this network cache. The loader 
                will check that a cache entry is valid, and load up a 
                fresh instance where a stale one is found. Each stale 
                entry with the equivalent timestamp is removed across 
                the entire network, 
                
        **********************************************************************/

        ICache bind (ICacheLoader loader)
        {
                return new LocalLoader (this, loader);
        }

        /**********************************************************************

                Bind a remote cache loader. Remote loaders are great for 
                gating/synchronizing access to a particular resource over
                the entire cluster. When a cache entry fails its validity 
                test, the loader is executed remotely by the cache host;
                the cache entry itself is 'locked' for the duration, such
                that requests from any cluster node will stall until the 
                new entry is loaded. This is a convenient way to restrict
                load on an expensive resource (such as a slow or very busy 
                back-end server).

        **********************************************************************/

        ICache bind (IRemoteCacheLoader loader)
        {
                return bind (new RemoteLoader (this, loader));
        }

        /**********************************************************************

                
        **********************************************************************/

        private class LocalLoader : ICache
        {
                NetworkCache    cache;
                ICacheLoader    loader;

                /**************************************************************

                **************************************************************/

                this (NetworkCache cache, ICacheLoader loader)
                {
                        this.cache = cache;
                        this.loader = loader;
                }

                /**************************************************************

                **************************************************************/

                IPayload get (char[] key)
                {
                        long     time = long.min;
                        IPayload p = cache.get (key);

                        if (p)
                           {
                           if (loader.test (p))
                               return p;
                        
                           // set the "newer than" time to the old entry
                           time = p.getTime ();

                           // invalidate the entire network. This is done
                           // so that subsequent lookups on a local cache
                           // will check the cluster first, before trying
                           // to load yet another new instance.
                           cache.invalidate (key, time);
                           }

                        p = loader.load (key, time);
                        if (p)
                            cache.put (key, p);
                        return p;
                }
        }

        /**********************************************************************

        **********************************************************************/

        private class RemoteLoader : ICacheLoader
        {
                NetworkCache            cache;
                IRemoteCacheLoader      loader;                 

                /**************************************************************

                **************************************************************/

                this (NetworkCache cache, IRemoteCacheLoader loader)
                {
                        this.cache = cache;
                        this.loader = loader;
                }

                /**************************************************************

                **************************************************************/

                bool test (IPayload p)
                {
                        return loader.test (p);
                }

                /**************************************************************

                **************************************************************/

                IPayload load (char[] key, ulong newerThan)
                {
                        uint    wait,
                                pause;

                        // set the loader time to be that of the old cache
                        // entry (zero if there was none).
                        loader.setTime (newerThan);

                        // tell cache to load this entry remotely & atomically.
                        // This may be ignored if someone else is loading the
                        // entry already, or the current entry is new enough.
                        cache.getCluster.loadCache (cache.getChannel(), key, loader);   
                         
                        // wait for it to appear ...            
                        do {
                           // get current entry
                           IPayload r = cache.get (key);

                           // ready to go home? We might pick up an older version 
                           if (r && loader.test (r))
                               return r;
                        
                           pause = loader.pause (wait);
                           System.sleep (pause);
                           wait += pause;
                           } while (pause);

                        return null;
                }
        }
}


/*******************************************************************************

        A combination of a local cache, cluster cache, and CacheInvalidatee.
        The two cache instances are combined such that they represent a
        classic level1/level2 cache. The CacheInvalidatee ensures that the
        level1 cache maintains coherency with the cluster. 

*******************************************************************************/

class NetworkCombo : NetworkCache
{
        private IMutableCache           cache;
        private CacheInvalidatee        invalidatee;

        /***********************************************************************
        
                Construct a ComboCache for the specified local cache, and
                on the given cluster channel.

        ***********************************************************************/
        
        this (ICluster cluster, char[] channel, IMutableCache cache)
        in {
           assert (cache);
           }
        body
        {
                super (cluster, channel);

                this.cache = cache;
                invalidatee = new CacheInvalidatee (cluster, channel, cache);
        }

        /***********************************************************************

                Return the IMutableCache instance provided during construction

        ***********************************************************************/
        
        IMutableCache getCache ()
        {
                return cache;
        }

        /***********************************************************************

                Get an IPayload from the local cache, and revert to the
                cluster cache if it's not found. Cluster lookups will 
                place new content into the local cache.

        ***********************************************************************/
        
        IPayload get (char[] key)
        {
                IPayload payload;

                if ((payload = cache.get (key)) is null)
                   {
                   payload = super.get (key);
                   if (payload)
                       cache.put (key, payload);
                   }
                return payload;
        }

        /***********************************************************************

                Place a new entry into the cache. This will also place
                the entry into the cluster, and optionally invalidate 
                all other local cache instances across the network. If
                a cache entry exists with the same key, it is replaced.
                Note that when using the coherency option you should 
                ensure your IPayload has a valid time stamp, since that
                is used to set the cluster-wide "invalidation level".
                You can use the getTime() method to retrieve the current 
                millisecond count.

        ***********************************************************************/
        
        void put (char[] key, IPayload payload, bool coherent = false)
        {
                // this will throw an exception if there's a problem
                super.put (key, payload);

                // place into local cache also
                cache.put (key, payload);

                // invalidate all other cache instances except this new one,
                // such that no other listening cache has the same key 
                if (coherent)
                    invalidate (key, payload.getTime);
        }

        /***********************************************************************

                Remove and return the cache entry corresponding to the 
                provided key.

        ***********************************************************************/
        
        IPayload extract (char[] key)
        {
                cache.extract (key);
                return super.extract (key);
        }
}




version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
