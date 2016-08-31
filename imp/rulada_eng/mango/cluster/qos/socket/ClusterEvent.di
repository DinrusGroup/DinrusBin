/*******************************************************************************

        @file ClusterEvent.d
        
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

module mango.cluster.qos.socket.ClusterEvent;

private import  mango.io.Buffer;

private import  mango.cluster.model.ICluster;

/*******************************************************************************
        
        The socket QOS implementation of IEvent

*******************************************************************************/

class ClusterEvent : IEvent
{       
        private IEvent.Style    style;
        private ICluster        cluster;
        private IChannel        channel;
        private IEventListener  listener;

        private static char[][] styleNames = ["bulletin", "message"];

        /***********************************************************************

        ***********************************************************************/
        
        this (ICluster cluster, IChannel channel, IEvent.Style style, IEventListener listener)
        {
                this.style = style;
                this.cluster = cluster;
                this.channel = channel;
                this.listener = listener;
        }

        /***********************************************************************

        ***********************************************************************/
        
        IChannel getChannel ()
        {
                return channel;
        }

        /***********************************************************************

        ***********************************************************************/
        
        IEvent.Style getStyle ()
        {
                return style;
        }

        /***********************************************************************

        ***********************************************************************/
        
        char[] getStyleName ()
        {
                return styleNames [style];
        }

        /***********************************************************************

        ***********************************************************************/
        
        void invoke (IPayload payload) 
        {
                // dispatch notification
                listener.notify (this, payload);
        }

        /***********************************************************************

                Send a payload back to the producer. This should support all
                the various event styles.                 

        ***********************************************************************/
        
        void reply (char[] channel, IPayload payload)
        in {
           assert (channel.length);
           }
        body
        {
                IChannel ch = cluster.createChannel (channel);

                if (style == IEvent.Style.Message)
                    cluster.putQueue (ch, payload);
                else
                   cluster.broadcast (ch, payload);
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
