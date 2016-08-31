/*******************************************************************************

        @file Message.d
        
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

module mango.cluster.Message;

private import  mango.cache.Payload;

private import  mango.io.Exception,    
                mango.io.PickleRegistry;        

public  import  mango.cluster.model.ICluster;        

/*******************************************************************************

        A cluster-based messaging class. You should implement the various
        abstract methods, and optionally override the read() and write() 
        methods to transport any non-transient content along with the task.
        Note that when using read() and write(), you should invoke the 
        superclass first. That is, read() and write() should look something
        like this:

        @code
        void read (IReader reader)
        {       
                super.read (reader);
                reader.get (myAttribute1);
                reader.get (myAttribute2);
                reader.get (myAttribute3);
        }

        void write (IWriter writer)
        {
                super.write (writer);
                writer.put  (myAttribute1);
                writer.put  (myAttribute2);
                writer.put  (myAttribute3);
        }
        @endcode

        You should do it this way so that your Message can be deserialized
        as a superclass instance (if ever necessary).

*******************************************************************************/

class Message : Payload, IMessage
{
        private char[] reply;

        /**********************************************************************

                Overridable create method that simply instantiates a 
                new instance. May be used to allocate subclassses from 
                a freelist

        **********************************************************************/

        abstract Object create ();

        /**********************************************************************

                Return the guid for this payload. This should be unique
                per payload class, if said class is used in conjunction
                with the clustering facilities. Inspected by the Pickle
                utilitiy classes.
                
        **********************************************************************/

        abstract char[] getGuid ();

        /***********************************************************************

        ***********************************************************************/
        
        void setReply (char[] channel)
        {
                reply = channel;
        }

        /***********************************************************************

        ***********************************************************************/
        
        char[] getReply ()
        {
                return reply;
        }

        /***********************************************************************

        ***********************************************************************/
        
        bool isReplyExpected ()
        {
                return cast(bool) (reply.length > 0);
        }

        /**********************************************************************
        
                Recover the reply-channel from the provided reader

        **********************************************************************/

        override void read (IReader reader)
        {       
                super.read (reader);
                reader.get (reply);
        }

        /**********************************************************************

                Emit our reply-channel to the provided writer

        **********************************************************************/

        override void write (IWriter writer)
        {
                super.write (writer);
                writer.put  (reply);
        }

        /***********************************************************************

                Create a new instance of a payload, and populate it via
                read() using the specified reader

        ***********************************************************************/

        override Object create (IReader reader)
        {
                return super.create (reader);
        }
}


/*******************************************************************************

        An empty Message that can be used for network signaling, or simply 
        as an example.

*******************************************************************************/

class NullMessage : Message
{
        /**********************************************************************
        
                Register ourselves with the pickle factory

        **********************************************************************/

        static this ()
        {
                PickleRegistry.enroll (new NullMessage);
        }

        /**********************************************************************

                Overridable create method that simply instantiates a 
                new instance. May be used to allocate subclassses from 
                a freelist

        **********************************************************************/

        override Object create ()
        {
                return new NullMessage;
        }

        /**********************************************************************

                Return the guid for this payload. This should be unique
                per payload class, if said class is used in conjunction
                with the clustering facilities. Inspected by the Pickle
                utility classes.
                
        **********************************************************************/

        override char[] getGuid ()
        {
                return this.classinfo.name;
        }
}


/*******************************************************************************

        A cluster-based executable class. You should implement the various
        abstract methods, and optionally override the read() and write() 
        methods to transport any non-transient content along with the task.
        Note that when using read() and write(), you should invoke the 
        superclass first. That is, read() and write() should look something
        like this:

        @code
        void read (IReader reader)
        {       
                super.read (reader);
                reader.get (myAttribute1);
                reader.get (myAttribute2);
                reader.get (myAttribute3);
        }

        void write (IWriter writer)
        {
                super.write (writer);
                writer.put  (myAttribute1);
                writer.put  (myAttribute2);
                writer.put  (myAttribute3);
        }
        @endcode

        You should do it this way so that your Task can be deserialized as
        a superclass instance (if ever necessary).

*******************************************************************************/

class Task : Message, ITask
{
        /***********************************************************************

        ***********************************************************************/
        
        abstract void execute ();

        /**********************************************************************

                Overridable create method that simply instantiates a 
                new instance. May be used to allocate subclassses from 
                a freelist

        **********************************************************************/

        abstract Object create ();

        /**********************************************************************

                Return the guid for this payload. This should be unique
                per payload class, if said class is used in conjunction
                with the clustering facilities. Inspected by the Pickle
                utilitiy classes.
                
        **********************************************************************/

        abstract char[] getGuid ();

        /**********************************************************************
        
                Recover attributes from the provided reader

        **********************************************************************/

        override void read (IReader reader)
        {
                super.read (reader);
        }

        /**********************************************************************

                Emit attributes to the provided writer

        **********************************************************************/

        override void write (IWriter writer)
        {
                super.write (writer);
        }

        /***********************************************************************

                Create a new instance of a payload, and populate it via
                read() using the specified reader

        ***********************************************************************/

        override Object create (IReader reader)
        {
                return super.create (reader);
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
