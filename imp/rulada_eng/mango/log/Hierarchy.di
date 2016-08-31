/*******************************************************************************

        @file Hierarchy.d

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

      
        @version        Initial version, October 2004
        @author         Kris


*******************************************************************************/

module mango.log.Hierarchy;

private import mango.log.Appender;

// GDC: this should not be required: it is public imported via log.Appender ...
private import mango.log.Logger;

/*******************************************************************************

        Pull in additional functions from the C library

*******************************************************************************/

extern (C)
{
        int memcmp (void *, void *, int);
}

/*******************************************************************************

        This is the real Logger implementation, hidden behind the public
        abstract frontage. 

*******************************************************************************/

private class LoggerInstance : Logger
{
        private LoggerInstance  next,
                                parent;

        private char[]          name;
        private Level           level;
        private Appender        appender;
        private Hierarchy       hierarchy;
        private bool            additive,
                                breakpoint;

        /***********************************************************************
        
                Construct a LoggerInstance with the specified name for the 
                given hierarchy. By default, logger instances are additive
                and are prohibited from emitting events.

        ***********************************************************************/

        protected this (Hierarchy hierarchy, char[] name)
        {
                this.hierarchy = hierarchy;
                this.level = Level.None;
                this.additive = true;
                this.name = name;
        }

        /***********************************************************************
        
                Is this logger enabed for the specified Level?

        ***********************************************************************/

        final bool isEnabled (Level level)
        {
                return cast(bool) (level >= this.level);
        }

        /***********************************************************************
        
                Is this a breakpoint Logger?
                
        ***********************************************************************/

        final bool isBreakpoint ()
        {
                return breakpoint;
        }

        /***********************************************************************
        
                Is this logger additive? That is, should we walk ancestors
                looking for more appenders?

        ***********************************************************************/

        final bool isAdditive ()
        {
                return additive;
        }

        /***********************************************************************

                Append a trace message

        ***********************************************************************/

        final void trace (char[] msg)
        {
                append (Level.Trace, msg);
        }

        /***********************************************************************

                Append an info message

        ***********************************************************************/

        final void info (char[] msg)
        {
                append (Level.Info, msg);
        }

        /***********************************************************************

                Append a warning message

        ***********************************************************************/

        final void warn (char[] msg)
        {
                append (Level.Warn, msg);
        }

        /***********************************************************************

                Append an error message

        ***********************************************************************/

        final void error (char[] msg)
        {
                append (Level.Error, msg);
        }

        /***********************************************************************

                Append a fatal message

        ***********************************************************************/

        final void fatal (char[] msg)
        {
                append (Level.Fatal, msg);
        }

        /***********************************************************************

                Return the name of this Logger (sans the appended dot).
       
        ***********************************************************************/

        final char[] getName ()
        {
                int i = name.length;
                if (i > 0)
                    --i;
                return name[0 .. i];     
        }

        /***********************************************************************
        
                Return the Level this logger is set to

        ***********************************************************************/

        final Level getLevel ()
        {
                return level;     
        }

        /***********************************************************************
        
                Set the current level for this logger (and only this logger).

        ***********************************************************************/

        final void setLevel (Level level)
        {
                setLevel (level, false);
        }

        /***********************************************************************
        
                Set the current level for this logger, and (optionally) all
                of its descendents.

        ***********************************************************************/

        final void setLevel (Level level, bool force)
        {
                this.level = level;     
                hierarchy.updateLoggers (this, force);
        }

        /***********************************************************************
        
                Set the breakpoint status of this logger.

        ***********************************************************************/

        final void setBreakpoint (bool enabled)
        {
                breakpoint = enabled;     
                hierarchy.updateLoggers (this, false);
        }

        /***********************************************************************
        
                Set the additive status of this logger. See isAdditive().

        ***********************************************************************/

        final void setAdditive (bool enabled)
        {
                additive = enabled;     
        }

        /***********************************************************************
        
                Add (another) appender to this logger. Appenders are each
                invoked for log events as they are produced. At most, one
                instance of each appender will be invoked.

        ***********************************************************************/

        final void addAppender (Appender next)
        {
                if (appender)
                    next.setNext (appender);
                appender = next;
        }

        /***********************************************************************
        
                Remove all appenders from this Logger

        ***********************************************************************/

        final void clearAppenders ()
        {
                appender = null;     
        }


        /***********************************************************************
        
                Get number of milliseconds since this application started

        ***********************************************************************/

        final ulong getRuntime ()
        {
                return Event.getRuntime();
        }

        /***********************************************************************
        
                Append a message to this logger via its appender list.

        ***********************************************************************/

        private final void append (Level level, char[] s)
        {
                if (isEnabled (level))
                   {
                   uint            masks;
                   LoggerInstance  l = this;
                   Event           event = Event.allocate ();

                   try {
                       // set the event attributes
                       event.set (hierarchy, level, s, name[0..name.length-1]);

                       // combine appenders from all ancestors
                       do {
                          Appender appender = l.appender;

                          // this level have an appender?
                          while (appender)
                                { 
                                uint mask = appender.getMask();

                                // have we used this appender already?
                                if ((masks & mask) == 0)
                                   {
                                   // no - append message and update mask
                                   event.scratch.length = 0;
                                   appender.append (event);
                                   masks |= mask;
                                   }
                                // process all appenders for this node
                                appender = appender.getNext ();
                                }
                            // process all ancestors
                          } while (l.additive && ((l = l.parent) !is null));
                        
                       // make sure we release the event ...
                       } finally
                               Event.deallocate (event);
                   }
        }

        /***********************************************************************
        
                See if the provided Logger is a good match as a parent of
                this one. Note that each Logger name has a '.' appended to
                the end, such that name segments will not partially match.

        ***********************************************************************/

        private final bool isCloserAncestor (LoggerInstance other)
        {
                int length = other.name.length;

                // possible parent if length is shorter
                if (length < name.length)
                    // does the prefix match? Note we append a "." to each 
                    if (length == 0 || 
                        memcmp (&other.name[0], &name[0], length) == 0)
                        // is this a better (longer) match than prior parent?
                        if ((parent is null) || (length >= parent.name.length))
                             return true;
                return false;
        }
}


/*******************************************************************************
 
        The Logger hierarchy implementation. We keep a reference to each
        logger in a hash-table for convenient lookup purposes, plus keep
        each logger linked to the others in an ordered chain. Ordering
        places shortest names at the head and longest ones at the tail, 
        making the job of identifying ancestors easier in an orderly
        fashion. For example, when propogating levels across descendents
        it would be a mistake to propogate to a child before all of its
        ancestors were taken care of.

*******************************************************************************/

class Hierarchy 
{
        private char[]                  name,
                                        address;      

        private LoggerInstance          root;
        private LoggerInstance[char[]]  loggers;

        /***********************************************************************
        
                Construct a hierarchy with the given name.

        ***********************************************************************/

        this (char[] name)
        {
                this.name = name;
                this.address = "network";

                // insert a root node; the root has an empty name
                root = new LoggerInstance (this, "");
        }

        /**********************************************************************

                Return the name of this Hierarchy

        **********************************************************************/

        char[] getName ()
        {
                return name;
        }

        /**********************************************************************

                Return the address of this Hierarchy. This is typically
                attached when sending events to remote monitors.

        **********************************************************************/

        char[] getAddress ()
        {
                return address;
        }

        /**********************************************************************

                Set the name of this Hierarchy

        **********************************************************************/

        void setName (char[] name)
        {
                this.name = name;
        }

        /**********************************************************************

                Set the address of this Hierarchy. The address is attached
                used when sending events to remote monitors.

        **********************************************************************/

        void setAddress (char[] address)
        {
                this.address = address;
        }

        /***********************************************************************
        
                Return the root node.

        ***********************************************************************/

        LoggerInstance getRootLogger ()
        {
                return root;
        }

        /***********************************************************************
        
                Return the instance of a Logger with the provided name. If
                the instance does not exist, it is created at this time.

        ***********************************************************************/

        synchronized LoggerInstance getLogger (char[] name)
        {
                name ~= ".";

                LoggerInstance *l = name in loggers;

                if (l is null)
                   {
                   // create a new logger
                   LoggerInstance li = new LoggerInstance (this, name);
                   l = &li;

                   // insert into linked list
                   insertLogger (li);

                   // look for and adjust children
                   updateLoggers (li, true);

                   // insert into map
                   loggers [name] = li;
                   }
               
                return *l;
        }

        /**********************************************************************

                Iterate over all Loggers in list

        **********************************************************************/

        int opApply (int delegate(inout Logger) dg)
        {
                int result = 0;
                LoggerInstance curr = root;

                while (curr)
                      {
                      // BUG: this uncovers a cast() issue in the 'inout' delegation
                      Logger l = curr;
                      if ((result = dg (l)) != 0)
                           break;
                      curr = curr.next;
                      }
                return result;
        }

        /***********************************************************************
        
                Loggers are maintained in a sorted linked-list. The order 
                is maintained such that the shortest name is at the root, 
                and the longest at the tail.

                This is done so that updateLoggers() will always have a
                known environment to manipulate, making it much faster.

        ***********************************************************************/

        private void insertLogger (LoggerInstance l)
        {
                LoggerInstance prev,
                               curr = root;

                while (curr)
                      {
                      // insert here if the new name is shorter
                      if (l.name.length < curr.name.length)
                          if (prev is null)
                              throw new Exception ("invalid hierarchy");
                          else                                 
                             {
                             l.next = prev.next;
                             prev.next = l;
                             return;
                             }
                      else
                         // find best match for parent of new entry
                         propogate (l, curr, true);

                      // remember where insertion point should be
                      prev = curr;  
                      curr = curr.next;  
                      }

                // add to tail
                prev.next = l;
        }

        /***********************************************************************
        
                Propogate hierarchical changes across known loggers. 
                This includes changes in the hierarchy itself, and to
                the various settings of child loggers with respect to 
                their parent(s).              

        ***********************************************************************/

        private void updateLoggers (LoggerInstance changed, bool force)
        {
                LoggerInstance logger = root;

                // scan all loggers 
                while (logger)
                      {
                      propogate (logger, changed, force);

                      // try next entry
                      logger = logger.next;
                      }                
        }

        /***********************************************************************
        
                Propogate changes in the hierarchy downward to child Loggers.
                Note that while 'parent' and 'breakpoint' are always forced
                to update, the update of 'level' is selectable.

        ***********************************************************************/

        private void propogate (LoggerInstance logger, LoggerInstance changed, bool force)
        {
                // is the changed instance a better match for our parent?
                if (logger.isCloserAncestor (changed))
                   {
                   // update parent (might actually be current parent)
                   logger.parent = changed;

                   // if we don't have an explicit level set, inherit it
                   if (logger.level == Logger.Level.None || force)
                       logger.level = changed.level;

                   // always force breakpoints to follow parent settings
                   logger.breakpoint = changed.breakpoint;
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
