/*******************************************************************************

        @file IEvent.d
        
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

module mango.cluster.model.IEvent;

private import mango.cache.model.IPayload;

private import mango.cluster.model.IChannel;

/*******************************************************************************

        An IEvent is passed to each listener as an argument to the
        IEventListener callback interface.

*******************************************************************************/

interface IEvent
{
        /***********************************************************************

                The supported styles of event/listener

        ***********************************************************************/
        
        enum Style {Bulletin, Message};

        /***********************************************************************

                Return the channel used to initiate the listener

        ***********************************************************************/
        
        IChannel getChannel();

        /***********************************************************************

                Return the style of the listener.

        ***********************************************************************/
        
        Style getStyle();

        /***********************************************************************

                Return the style name of the listener.

        ***********************************************************************/
        
        char[] getStyleName();

        /***********************************************************************

                Invoke the listener with the specified payload

        ***********************************************************************/
        
        void invoke (IPayload payload);

        /***********************************************************************

                Send a payload back to the producer. This should support all
                the various event styles.                 

        ***********************************************************************/
        
        void reply (char[] channel, IPayload payload);
}


/*******************************************************************************

        Declares the contract for listeners within the cluster package.
        When creating a listener, you provide a class that implements
        this interface. The notify() method is invoked (on a seperate
        thread) whenever a relevant event occurs.

*******************************************************************************/

interface IEventListener
{
        void notify (IEvent event, IPayload payload);
}



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
