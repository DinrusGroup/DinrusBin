/*******************************************************************************

        @file Client.d
        
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

module mango.cluster.Client;

private import  mango.sys.System;  

private import  mango.io.Exception;        

public  import  mango.cluster.Message;        

public  import  mango.cluster.model.ICluster;        

/*******************************************************************************

        The base class for all cluster clients (such as CacheInvalidator)
        which acts simply as a container for the operating IChannel and
        the configured ICluster. The former specifies something akin to
        a 'topic' in the pub/sub world, while the latter provides access
        to the underlying functional substrate (the QOS implementation).

*******************************************************************************/

class Client
{
        private IChannel channel;
        private ICluster cluster;

        public static NullMessage EmptyMessage;

        static this ()
        {
                EmptyMessage = new NullMessage;
        }

        /***********************************************************************

                Construct this client with the specified channel and cluster. 
                The former specifies something akin to a 'topic', whilst the 
                latter provides access to the underlying functional substrate 
                (the QOS implementation). A good way to think about channels
                is to map them directly to a class name. That is, since you
                send and recieve classes on a channel, you might utilize the 
                class name as the channel name (this.classinfo.name).
 
        ***********************************************************************/
        
        this (ICluster cluster, char[] channel)
        in {
           assert (cluster);
           assert (channel.length);
           }
        body
        {
                this.cluster = cluster;
                this.channel = cluster.createChannel (channel);
        }

        /***********************************************************************

                Return the channel we're tuned to

        ***********************************************************************/
        
        IChannel getChannel ()
        {
                return channel;
        }

        /***********************************************************************

                Return the cluster specified during construction

        ***********************************************************************/
        
        ICluster getCluster ()
        {
                return cluster;
        }

        /***********************************************************************

                Return the number of milliseconds since Jan 1st 1970

        ***********************************************************************/
        
        ulong getTime ()
        {
                return System.getMillisecs;
        }

        /***********************************************************************
        
                Create a channel with the specified name. A channel 
                represents something akin to a publush/subscribe topic, 
                or a radio station. These are used to segregate cluster 
                operations into a set of groups, where each group is 
                represented by a channel. Channel names are whatever you 
                want then to be; use of dot notation has proved useful 
                in the past. In fact, a good way to think about channels
                is to map them directly to a class name. That is, since you
                typically send and recieve classes on a channel, you might 
                utilize the class name as the channel (this.classinfo.name).

        ***********************************************************************/
        
        IChannel createChannel (char[] name)
        {
                return cluster.createChannel (name);
        }
}

/*******************************************************************************

        This exception is thrown by the cluster subsystem when it runs
        into something unexpected.

*******************************************************************************/

class ClusterException : IOException
{
        /***********************************************************************
        
                Construct exception with the provided text string

        ***********************************************************************/

        this (char[] msg)
        {
                super (msg);
        }
}

/*******************************************************************************

        This exception is thrown by the cluster subsystem when an attempt
        is made to place additional content into a full queue

*******************************************************************************/

class ClusterFullException : ClusterException
{
        /***********************************************************************
        
                Construct exception with the provided text string

        ***********************************************************************/

        this (char[] msg)
        {
                super (msg);
        }
}

/*******************************************************************************

        This exception is thrown by the cluster subsystem when an attempt
        is made to converse with a non-existant cluster, or one where all
        cluster-servers have died.

*******************************************************************************/

class ClusterEmptyException : ClusterException
{
        /***********************************************************************
        
                Construct exception with the provided text string

        ***********************************************************************/

        this (char[] msg)
        {
                super (msg);
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
