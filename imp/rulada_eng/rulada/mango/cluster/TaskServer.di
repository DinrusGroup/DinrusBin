/*******************************************************************************

        @file TaskServer.d
        
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

module mango.cluster.TaskServer;

private import  mango.log.Admin,
                mango.log.Logger;

public  import  mango.log.model.ILogger;

private import  mango.io.Socket,
                mango.io.PickleRegistry;

private import  mango.io.model.IConduit;

private import  mango.servlet.Servlet,
                mango.servlet.ServletContext,
                mango.servlet.ServletProvider;

private import  mango.http.server.HttpServer;

private import  mango.cluster.qos.socket.Cluster;

                
/******************************************************************************
        
        @code
        import  MyTask1,
                MyTask2,
                MyTask3;


        class MyTaskServer : TaskServer
        {
                this (char[] filename)
                {
                        auto FileConduit config = new FileConduit (filename);
                        ILogger logger = Logger.getLogger ("my.task.server");

                        super (new Cluster (logger, config));
                }


                void enroll (ILogger logger)
                {
                        addConsumer (new MyTask1);
                        addConsumer (new MyTask2);
                        addConsumer (new MyTask3);
                }
        }


        main ()
        {
                MyTaskServer mts = new MyTaskServer ("cluster.properties");

                mts.start ();
        }
        @endcode

******************************************************************************/

class TaskServer
{
        private ILogger         logger;
        private ICluster        cluster;
        private HttpServer      adminServer;

        /**********************************************************************

        **********************************************************************/

        abstract void enroll (ILogger logger);

        /**********************************************************************

        **********************************************************************/

        this (ICluster cluster, ushort adminPort = 0)
        {
                this.cluster = cluster;
                this.logger = cluster.getLogger;

                if (adminPort)
                   {
                   // construct a servlet-provider
                   ServletProvider sp = new ServletProvider;

                   // create a context for admin servlets
                   ServletContext admin = sp.addContext (new AdminContext (sp, "/admin"));

                   // create a (1 thread) server using the IProvider to service requests
                   // and start listening for requests (but this thread does not listen)
                   adminServer = new HttpServer (sp, new InternetAddress (adminPort), 1, logger);
                   }

        }

        /**********************************************************************

        **********************************************************************/

        ICluster getCluster ()
        {
                return cluster;
        }

        /**********************************************************************

        **********************************************************************/

        void start ()
        {
                enroll (logger);

                if (adminServer)
                    adminServer.start ();
        }

        /**********************************************************************

        **********************************************************************/

        IConsumer addConsumer (IPickleFactory task, bool enroll = false)
        {
                char[] name = task.getGuid;

                cluster.getLogger.info ("adding consumer '" ~ name ~ "'");
        
                if (enroll)
                    PickleRegistry.enroll (task);
                return new TaskConsumer (cluster, name);
        }

        /**********************************************************************


        **********************************************************************/

        class TaskConsumer : IEventListener, IConsumer
        {
                private char[]          channel;
                private ILogger         logger;
                private IConsumer       consumer;

                /**************************************************************

                **************************************************************/

                this (ICluster cluster, char[] channel)
                {
                        this.channel = channel;
                        this.logger = cluster.getLogger ();

                        IChannel ch = cluster.createChannel (channel);
                        consumer = cluster.createConsumer (ch, IEvent.Style.Message, this);
                }

                /**************************************************************

                **************************************************************/

                void cancel ()
                {
                        consumer.cancel ();     
                }

                /**************************************************************

                        Declares the contract for listeners within the 
                        cluster package. When creating a listener, you 
                        provide a class that implements this interface. 
                        The notify() method is invoked (on a seperate
                        thread) whenever a relevant event occurs.

                **************************************************************/

                void notify (IEvent event, IPayload payload)
                {
                        if (logger.isEnabled (logger.Level.Info))
                            logger.info ("executing task from channel '" ~ channel ~ "'");
        
                        // instantiate the task
                        ITask task = cast(ITask) payload;
                        
                        // fire it up!
                        if (task)
                           {
                           task.execute ();                        

                           if (logger.isEnabled (logger.Level.Trace))
                               logger.trace ("completed task from channel '" ~ channel ~ "'");
                           }
                        else
                           logger.error ("received an invalid task on channel '" ~ channel ~ "'");
                }
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
