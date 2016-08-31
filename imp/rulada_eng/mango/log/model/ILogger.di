/*******************************************************************************

        @file ILogger.d

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

      
        @version        Initial version, May 2004
        @author         Kris


*******************************************************************************/

module mango.log.model.ILogger;

public import mango.log.model.ILevel;

/*******************************************************************************

        This is the primary API to the log package. Use the two static 
        methods to access and/or create Logger instances, and the other
        methods to modify specific Logger attributes.

        See <A HREF="http://logging.apache.org/log4j/docs/documentation.html">this page</A> 
        for the official Log4J documentation. Mango.log closely follows 
        both the API and the behaviour as documented at the official site.

*******************************************************************************/

interface ILogger : ILevel
{
        /***********************************************************************

                Add a trace messages. This is called 'debug' in Log4J but
                that is a  reserved word in the D language. This needs some
                more thought.
                
        ***********************************************************************/

        void trace (char[] msg);

        /***********************************************************************
                
                Add an info message

        ***********************************************************************/

        void info (char[] msg);

        /***********************************************************************

                Add a warning message

        ***********************************************************************/

        void warn (char[] msg);

        /***********************************************************************

                Add an error message

        ***********************************************************************/

        void error (char[] msg);

        /***********************************************************************

                Add a fatal message

        ***********************************************************************/

        void fatal (char[] msg);

        /***********************************************************************
        
                Return the name of this Logger

        ***********************************************************************/

        char[] getName ();

        /***********************************************************************

                Return the current level assigned to this logger

        ***********************************************************************/

        Level getLevel ();

        /***********************************************************************

                Set the activity level of this logger. Levels control how
                much information is emitted during runtime, and relate to
                each other as follows:

                    Trace < Info < Warn < Error < Fatal < None

                That is, if the level is set to Error, only calls to the
                error() and fatal() methods will actually produce output:
                all others will be inhibited.

                Note that Log4J is a hierarchical environment, and each
                logger defaults to inheriting a level from its parent.


        ***********************************************************************/

        void setLevel (Level level);

        /***********************************************************************
        
                same as setLevel (Level), but with additional control over 
                whether the children are forced to accept the changed level
                or not. If 'force' is false, then children adopt the parent
                level only if they have their own level set to Level.None

        ***********************************************************************/

        void setLevel (Level level, bool force);

        /***********************************************************************
        
                Is this logger enabled for the provided level?

        ***********************************************************************/

        bool isEnabled (Level level);

        /***********************************************************************

                Return whether this logger uses additive appenders or not. 
                See setAdditive().

        ***********************************************************************/

        bool isAdditive ();

        /***********************************************************************

                Specify whether or not this logger has additive behaviour.
                This is enabled by default, and causes a logger to invoke
                all appenders within its ancestry (until an ancestor is
                found with an additive attribute of false).

        ***********************************************************************/

        void setAdditive (bool enabled);

        /***********************************************************************
        
                Get number of milliseconds since this application started

        ***********************************************************************/

        ulong getRuntime ();
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
