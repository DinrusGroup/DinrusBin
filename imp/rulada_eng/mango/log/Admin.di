/******************************************************************************

        @file Admin.d

        Classes for administration of logging from a Servlet Engine.

        AdminServlet can be used to modify logging details.
      
        AdminContext is a pre-built ServletContext that includes AdminServlet

        AdminServer is a pre-built server that allows logging administration.
        Simply instantiate it with an InternetAddress to bind to.
        
        Scott Sanders, June 3, 2004

*******************************************************************************/

module mango.log.Admin;

private import  mango.io.Uri;

private import  mango.io.model.IWriter;

private import  mango.log.Logger,
                mango.log.Event,
                mango.log.Manager;

private import  mango.servlet.Servlet,
                mango.servlet.ServletContext,
                mango.servlet.ServletProvider;

/*******************************************************************************

        Servlet to allow modification of Logger details

*******************************************************************************/

class AdminServlet : Servlet
{
        // our logging instance
        private Logger log;

        /***********************************************************************

                Set up the logger for this servlet
        
        ***********************************************************************/

        this()
        {
                log = Logger.getLogger ("mango.admin.AdminServlet");
        }

        /***********************************************************************

                Instantiate a new logger, if one does not already exist.
        
        ***********************************************************************/
  
        void addLogger(IServletRequest request, IServletResponse response)
        {
                char[] loggerName = request.getParameters.get("logger");
                Logger.Level level = cast(Logger.Level) request.getParameters.getInt("level");
                
                Logger loggerToChange = Manager.getLogger(loggerName);
                loggerToChange.setLevel(level);
        }

   
        /***********************************************************************

                Set the level of a given logger, where logger name is in the 
                request parameter 'logger'.
        
        ***********************************************************************/
  
        void setLoggerLevel(IServletRequest request, IServletResponse response, Logger.Level level)
        {
                //set the given logger's level
                char[] loggerName = request.getParameters.get("logger");
                
                // get the logger
                Logger loggerToChange;
                if (loggerName.length)
                    loggerToChange = Manager.getLogger(loggerName);
                else
                   loggerToChange = Manager.getRootLogger();

                //set the level on the logger
                log.info("Setting logger " ~ loggerName ~ 
                         " to level " ~ Event.LevelNames[level]);
                loggerToChange.setLevel(level);
        }


        /***********************************************************************

                Handle all the different request methods ...
        
        ***********************************************************************/
  
        void service (IServletRequest request, IServletResponse response)
        {   
                // determine the action to take   
                char[] action = request.getParameters().get("action");
                
                // if the action is null, then we are doing the default - list
                if (action is null)
                    action = "L";
                
                switch (action[0])
                       {
                       // Add a logger
                       case 'A':
                            addLogger (request, response);
                            break;

                       // Set the logger level to TRACE
                       case 'T':
                            setLoggerLevel (request, response, Logger.Level.Trace);
                            break;

                       // Set the logger level to INFO
                       case 'I':
                            setLoggerLevel (request, response, Logger.Level.Info);
                            break;

                       // Set the logger level to WARN
                       case 'W':
                            setLoggerLevel (request, response, Logger.Level.Warn);
                            break;

                       // Set the logger level to ERROR
                       case 'E':
                            setLoggerLevel (request, response, Logger.Level.Error);
                            break;

                       // Set the logger level to FATAL
                       case 'F':
                            setLoggerLevel (request, response, Logger.Level.Fatal);
                            break;

                       // Set the logger level to NONE
                       case 'N':
                            setLoggerLevel (request, response, Logger.Level.None);
                            break;
                       
                       default:
                            break;
                       }
                
                Uri uri = request.getUri();

                if (action != "L")
                    response.sendRedirect("/admin/logger");
                else
                   // now list the loggers for the next go round
                   log.trace ("request to logadmin with uri: " ~ uri.toString());

                // say we're writing html
                response.setContentType ("text/html");

                IWriter write = response.getWriter();

                // write HTML preamble ...
                write ("<html><head><title>LogAdmin</title></head><body>"c);

                //List out the currently defined Loggers
                write("<h1>Mango Server Console - Logger Administrator</h1>"c 
                       "<h2>Existing Loggers</h2><table border='1' cellpadding='3'>")
                      .cr()
                      ("<tr><td>Logger Name</td>"c 
                       "<td>Logger Level</td>"  
                       "<td colspan=\"6\">Change Level to:</td></tr>")
                      .cr();

                //print a table row for each logger
                foreach (Logger l; Manager.getHierarchy())
                {
                        char[] name = l.getName();
                        char[] label = name;
                        if (label.length == 0)
                           label = "ROOT";

                        int level = l.getLevel();
                        write("<tr><td><b>" ~ label ~ "</b>&nbsp;</td><td>" ~ 
                               Event.LevelNames[level] ~ "</td>");

                        for (int i = Logger.Level.min; i < Logger.Level.max + 1; i++)
                        {
                            write("<td>"c);
                            if (i == level)
                                write("<b>" ~ Event.LevelNames[i] ~ "</b>");
                            else
                              write("<a href=\"logger?action=" ~ Event.LevelNames[i] ~ 
                                    "&logger=" ~ name ~ 
                                    "\">" ~ Event.LevelNames[i] ~ "</a>");
                            write("</td>"c);
                        }
                                   
                        write("</tr>"c)
                              .cr();
                }

                write("</table>"c)
                      .cr()
                      ("<h2>Add a new logger</h2>"c)
                      .cr()
                      ("<form method=\"get\" action=\"logger\">"c)
                      .cr()
                      ("<input type=\"hidden\" name=\"action\" value=\"ADD\" />"c)
                      .cr()
                      ("<table><tr><td>Logger Name:</td>" ~ 
                       "<td>Level</td></tr><tr>" ~ 
                       "<td><input type=\"text\" name=\"logger\" />"c)
                      .cr()
                      ("</td><td><select name=\"level\">"c)
                      .cr();

                for (int i = Logger.Level.min; i < Logger.Level.max + 1; i++)
                {
                     char[] levelStr = Event.LevelNames[i];
                     write("<option value=\""c);
                     write(i);
                     write("\">" ~ levelStr ~ "</option>").cr();
                }       
   
                write("</select></td></tr></table>"c 
                      "<input type=\"submit\" name=\"submit\" value=\"Add Level\" />")
                      .cr()
                      ("</form>"c)
                      .cr();

                // write HTML closure
                write ("</body></html>"c);
        }
}



/*******************************************************************************

        ServletContext prebuilt to include the AdminServlet.  Convenience class
        allowing a developer to drop this prebuilt context into an existing
        servlet engine.  Create a context with a name ("/admin', for example),
        and AdminContext will provide a "/logger" handler for modifying
        logging details.

*******************************************************************************/

class AdminContext : ServletContext
{

        this (ServletProvider provider, char[] name)
        {
                super (name);
                provider.addContext (this);
                IRegisteredServlet logger = provider.addServlet (new AdminServlet(), "logger", this);
                provider.addMapping ("/logger", logger);
        }

}



/*******************************************************************************

        Given an InternetAddress to bind to, a full admin server is built and
        deployed. Logging can then be configured at http://address/admin/logger

*******************************************************************************/

class AdminServer
{

}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
