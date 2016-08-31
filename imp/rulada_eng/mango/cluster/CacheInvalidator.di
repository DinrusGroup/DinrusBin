/*******************************************************************************

        @file CacheInvalidator.d
        
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

module mango.cluster.CacheInvalidator;

private import  mango.cache.Payload;

public  import  mango.cluster.Client;

/*******************************************************************************

        Utility class to invalidate specific cache entries across a 
        network. Any active CacheInvalidatee objects listening upon
        the channel specified for this class will "wake up" whenever
        the invalidate() method is invoked.

*******************************************************************************/

class CacheInvalidator : Client
{
        private InvalidatorPayload filter;

        /***********************************************************************

                Construct an invalidator on the specified channel. Only
                those CacheInvalidatee instances configured for the same
                channel will be listening to this invalidator.

        ***********************************************************************/
        
        this (ICluster cluster, char[] channel)
        in {
           assert (channel.length);
           }
        body
        {
                super (cluster, channel);

                // this is what we'll send as an invalidation notification ...
                this.filter = new InvalidatorPayload;
        }

        /***********************************************************************

                Invalidate all network cache instances on this channel
                using the specified key. When 'timeLimit' is specified, 
                only those cache entries with a time lesser or equal to
                that specified will be removed. This is often useful if 
                you wish to avoid invalidating a cache (local or remote)
                that has just been updated; simply pass the time value
                of the 'old' IPayload as the argument.

                Note that this is asynchronous! An invalidation is just
                a request to remove the item within a short time period.
                If you need the entry removed synchronously, you should
                use the NetworkCache extract() method instead.

        ***********************************************************************/
        
        void invalidate (char[] key, ulong timeLimit = ulong.max)
        in {
           assert (key.length);
           }
        body
        {
                filter.setText (key);
                filter.setTimeout (timeLimit);

                // broadcast a message across the cluster
                getCluster.broadcast (getChannel, filter);
        }
}


/*******************************************************************************

*******************************************************************************/

private class InvalidatorPayload : Payload
{
        private char[]                    text;
        private ulong                     timeout;

        private InvalidatorPayload        next;   
        private static InvalidatorPayload freelist;

        private import mango.io.PickleRegistry;

        /***********************************************************************
        
                Register this class for pickling, so we can resurrect
                instances when they arrive on a network datagram.

        ***********************************************************************/

        static this ()
        {
                PickleRegistry.enroll (new InvalidatorPayload);
        }

        /***********************************************************************

                Allocate a Payload from a list rather than creating a new one

        ***********************************************************************/

        synchronized InvalidatorPayload create ()
        {  
                InvalidatorPayload s;
        
                if (freelist)
                   {
                   s = freelist;
                   freelist = s.next;
                   }
                else
                   s = new InvalidatorPayload;
                return s;
        }

        /***********************************************************************

        ***********************************************************************/

        char[] getText ()
        {
                return text;
        }

        /***********************************************************************

        ***********************************************************************/

        void setText (char[] text)
        in {
           assert (text.length);
           }
        body
        {
                this.text = text;
        }

        /***********************************************************************

                Set the identifier of the cache that should not be touched
                by an invalidation broadcast. This is typically a local
                cache on the machine originating the invalidation; without
                the ability to guard against local invalidation, the cache
                entry that was just added locally would be removed along
                with others across the cluster. The alternative would be
                to invalidate before addding, but that approach can quickly 
                become complicated by timing issues.

        ***********************************************************************/

        void setTimeout (ulong olderThan)
        {
                timeout = olderThan;
        }

        /***********************************************************************

        ***********************************************************************/

        ulong getTimeout ()
        {
                return timeout;
        }

        /***********************************************************************

                Return this Payload to the free-list

        ***********************************************************************/

        synchronized void destroy ()
        {
                next = freelist;
                freelist = this;
        }

        /***********************************************************************

        ***********************************************************************/

        void write (IWriter writer)
        {
                super.write (writer);
                writer.put  (timeout).put(text);
        }

        /***********************************************************************

                Read our attributes, after telling our superclass to do
                likewise. The order of this is important with respect to
                inheritance, such that a subclass and superclass may be 
                populated in isolation where appropriate.

                Note that we slice our text attribute, rather than copying
                it. Since this class is temporal we can forego allocation
                of memory, and just map it directly from the input buffer. 

        ***********************************************************************/

        void read (IReader reader)
        {
                super.read (reader);
                reader.get (timeout).get(text); 
        }

        /***********************************************************************

        ***********************************************************************/

        char[] getGuid ()
        {
                return this.classinfo.name;
        }
}



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
