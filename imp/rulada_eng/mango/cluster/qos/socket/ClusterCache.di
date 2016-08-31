/*******************************************************************************

        @file ClusterCache.d
        
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

        
        @version        Initial version, April 2004      
        @author         Kris


*******************************************************************************/

module mango.cluster.qos.socket.ClusterCache;

private import  std.thread;

private import  mango.sys.System;

private import  mango.utils.Random;

private import  mango.cache.HashMap,
                mango.cache.Payload,
                mango.cache.QueuedCache;

private import  mango.cache.model.IPayload;

private import  mango.cluster.CacheInvalidatee;

private import  mango.cluster.qos.socket.Cluster;


/******************************************************************************
       
        The socket QOS cache containers. These are created by ClusterServer
        and maintained via ClusterThread.
         
******************************************************************************/

class ClusterCache
{
        private Cluster         cluster;
        private HashMap         cacheSet;
        private uint            defaultSize;
        
        /**********************************************************************

        **********************************************************************/

        this (Cluster cluster, uint defaultSize)
        {
                this.cacheSet = new HashMap (256);
                this.defaultSize = defaultSize;
                this.cluster = cluster;
        }

        /**********************************************************************

        **********************************************************************/

        private final ChannelCache lookup (char[] channel)
        {       
                return cast(ChannelCache) cacheSet.get (channel);
        }       

        /**********************************************************************

        **********************************************************************/

        ChannelCache addCache (char[] channel, uint size)
        {       
                // create new cache instance
                ChannelCache cache = new ChannelCache (cluster, channel, size);

                // add to current list
                cacheSet.put (channel, cache); 

                return cache;
        }       

        /**********************************************************************

        **********************************************************************/

        void put (char[] channel, char[] element, ClusterContent content)
        {       
                ChannelCache cache = lookup (channel);

                if (cache is null)
                    cache = addCache (channel.dup, defaultSize);

                cache.put (element, content);
        }       

        /**********************************************************************

        **********************************************************************/

        ClusterContent extract (char[] channel, char[] element)
        {
                ChannelCache cache = lookup (channel);

                if (cache)
                    return cache.extract (element);

                return null;
        }

        /**********************************************************************

        **********************************************************************/

        ClusterContent get (char[] channel, char[] element)
        {
                ChannelCache cache = lookup (channel);

                if (cache)
                    return cache.get (element);

                return null;
        }

        /**********************************************************************

                Add a cache lock where the entry is invalid or unlocked.
                Returns true if locked by this call, false otherwise. Note
                that this will return false if the entry is already locked.

        **********************************************************************/

        bool lockWhereInvalid (char[] channel, char[] element, ulong time)
        {
                ChannelCache cache = lookup (channel);

                // create new cache if necessary (we're about to load an entry)
                if (cache is null)
                    cache = addCache (channel.dup, defaultSize);

                return cache.lockWhereInvalid (element, time);
        }

        /**********************************************************************

        **********************************************************************/

        void unlock (char[] channel, char[] element)
        {
                ChannelCache cache = lookup (channel);

                if (cache)
                    cache.unlock (element);
        }
}


/******************************************************************************
        
******************************************************************************/

class ClusterQueue : Thread
{
        private uint            size,
                                used,
                                sleep;
        private ILogger         logger;
        private Cluster         cluster;
        private HashMap         queueSet;

        /**********************************************************************

        **********************************************************************/

        this (Cluster cluster, uint size, uint sleep)
        {
                queueSet = new HashMap (256);
                logger = cluster.getLogger ();
                this.cluster = cluster;
                this.sleep = sleep;
                this.size = size;

                start ();
        }

        /**********************************************************************

        **********************************************************************/

        private final ChannelQueue lookup (char[] channel)
        {
                return cast(ChannelQueue) queueSet.get (channel);
        }

        /**********************************************************************

        **********************************************************************/

        bool put (char[] name, ClusterContent content)
        {       
                if ((used + content.length) < size)
                   {
                   // select the appropriate queue
                   ChannelQueue queue = lookup (name);
                   if (queue is null)
                      {
                      // name is currently a reference only; copy it
                      name = name.dup;

                      logger.trace ("creating new queue for channel '" ~ name ~ "'");

                      // place new ChannelQueue into the list
                      queueSet.put (name, queue = new ChannelQueue (cluster.createChannel (name)));
                      }

                   queue.put (content);
                   used += content.length;
                   return true;
                   }
                return false;
        }       

        /**********************************************************************

        **********************************************************************/

        synchronized ClusterContent get (char[] name)
        {
                ClusterContent ret = null;
                ChannelQueue   queue = lookup (name);

                if (queue)
                   {
                   // printf ("get from queue '%.*s' (%d)\n", name, queue.count);

                   ret = queue.get ();
                   used -= ret.length;
                   }
                return ret;
        }   
        
        /**********************************************************************

        **********************************************************************/

        version (Ares) 
                 alias void ThreadReturn;
              else
                 alias int ThreadReturn;

        override ThreadReturn run ()
        {       
                while (true)
                      {
                      System.sleep (Random.get (sleep));

                      try {
                          foreach (char[] k, Object o; queueSet)
                                  {
                                  ChannelQueue q = cast(ChannelQueue) o;
                                  if (q.count)
                                     {
                                     IChannel c = q.channel;

                                     if (logger.isEnabled (logger.Level.Trace))
                                         logger.trace ("publishing queue channel '" ~ 
                                                        c.getName ~ "'");
                                     cluster.broadcast (c);
                                     }
                                  }
                          } catch (Object x)
                                   logger.error ("queue-publisher: "~x.toString);
                      }
                return 0;
        }           
}


/******************************************************************************
       
******************************************************************************/

private class ChannelCache 
{
        private HashMap         locks;
        private QueuedCache     cache;

        /**********************************************************************

        **********************************************************************/

        this (Cluster cluster, char[] channel, int cacheSize)
        {
                cluster.getLogger.trace ("creating new cache for channel '" ~ channel ~ "'");

                // disallow concurrent updates to the lock map, since the
                // whole point of these locks is to allow just one thread 
                // to update the cache
                locks = new HashMap (256, 0.75, 1);

                cache = new QueuedCache (cacheSize);

                // construct an invalidation listener for this cache
                new CacheInvalidatee (cluster, channel, cache);
        }

        /**********************************************************************

        **********************************************************************/

        void put (char[] key, ClusterContent content)
        in {
           assert (content);
           }
        body
        {
                ClusterEntry entry = ClusterEntry.create ();

                entry.setData (content);
                cache.put (key, entry);
        }

        /**********************************************************************

        **********************************************************************/

        ClusterContent extract (char[] key)
        {
                IPayload p = cache.extract (key);

                if (p)
                   {
                   ClusterEntry entry = cast(ClusterEntry) cast(void*) p;
                   return entry.getData;
                   }
                return null;
        }

        /**********************************************************************

        **********************************************************************/

        ClusterContent get (char[] key)
        {
                IPayload p = cache.get (key);

                if (p)
                   {
                   ClusterEntry entry = cast(ClusterEntry) cast(void*) p;
                   return entry.getData;
                   }
                return null;
        }

        /**********************************************************************

                Add a cache lock where the entry is invalid or unlocked.
                Returns true if locked by this call, false otherwise. Note
                that this will return false if the entry is already locked.

        **********************************************************************/

        bool lockWhereInvalid (char[] key, ulong time)
        {
                IPayload p = cache.get (key);
                if (p)
                   {
                   ClusterEntry entry = cast(ClusterEntry) cast(void*) p;
                   if (entry.getTime () > time)
                       return false;
                   }

                if (locks.get (key))
                    return false;

                // place any old object in the lock list
                locks.put (key, this);
                return true;
        }

        /**********************************************************************

        **********************************************************************/

        void unlock (char[] key)
        {
                locks.remove (key);
        }
}


/*******************************************************************************

*******************************************************************************/

private class ClusterEntry : Payload
{
        private ClusterContent          data;
        private ClusterEntry            next;   
        private static ClusterEntry     freelist;

        /***********************************************************************

        ***********************************************************************/

        void setData (ClusterContent data)
        {
                this.data = data;
        }

        /***********************************************************************

        ***********************************************************************/

        ClusterContent getData ()
        {
                return data;
        }

        /***********************************************************************

                Allocate an entry from a list rather than creating a new one

        ***********************************************************************/

        static ClusterEntry create ()
        {  
                ClusterEntry s;
        
                if (freelist)
                   {
                   s = freelist;
                   freelist = s.next;
                   }
                else
                   s = new ClusterEntry;
                return s;
        }

        /***********************************************************************

                Return this Payload to the free-list

        ***********************************************************************/

        void destroy ()
        {
                data = null;
                next = freelist;
                freelist = this;
        }
}


/******************************************************************************
        
******************************************************************************/

private class ChannelQueue
{
        private Link            head,
                                tail;
        private int             count;
        IChannel                channel;

        /**********************************************************************

        **********************************************************************/

        private static class Link
        {
                Link            prev,
                                next;
                ClusterContent  data;

                static Link     freeList;

                /**************************************************************

                **************************************************************/

                Link append (Link after)
                {
                        if (after)
                           {
                           next = after.next;

                           // patch 'next' to point at me
                           if (next)
                               next.prev = this;

                           //patch 'after' to point at me
                           prev = after;
                           after.next = this;
                           }
                        return this;
                }

                /**************************************************************

                **************************************************************/

                Link unlink ()
                {
                        // make 'prev' and 'next' entries see each other
                        if (prev)
                            prev.next = next;

                        if (next)
                            next.prev = prev;

                        // Murphy's law 
                        next = prev = null;
                        return this;
                }

                /**************************************************************

                **************************************************************/

                Link create ()
                {
                        Link l;

                        if (freeList)
                           {
                           l = freeList;
                           freeList = l.next;
                           }
                        else
                           l = new Link;
                        return l;                       
                }

                /**************************************************************

                **************************************************************/

                void destroy ()
                {
                        next = freeList;
                        freeList = this;
                        this.data = null;
                }
        }


        /**********************************************************************

        **********************************************************************/

        this (IChannel channel)
        {
                head = tail = new Link;
                this.channel = channel;
        }

        /**********************************************************************

                Add the specified content to the queue at the current
                tail position, and bump tail to the next Link

        **********************************************************************/

        void put (ClusterContent content)
        {
                tail.data = content;
                tail = tail.create.append (tail);
                ++count;
        }       

        /**********************************************************************

                Extract from the head, which is the oldest item in the 
                queue. The removed Link is then appended to the tail, 
                ready for another put. Head is adjusted to point at the
                next valid queue entry.

        **********************************************************************/

        ClusterContent get ()
        {
                if (head !is tail)
                   {
                   // printf ("removing link\n");
                   Link l = head;
                   head = head.next;
                   ClusterContent ret = l.data;
                   l.unlink ();
                   l.destroy ();
                   --count;
                   return ret;
                   }
                return null;                   
        }       
}



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
