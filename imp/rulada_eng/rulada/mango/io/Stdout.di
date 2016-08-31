/*******************************************************************************

        @file Stdout.d
        
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

       
        @version        Initial version, Feb 2005      
        @author         Kris


*******************************************************************************/

module mango.io.Stdout;

// for CR
public import   mango.io.Writer;        

private import  mango.io.Console,
                mango.io.BufferCodec,
                mango.io.FlushWriter;

/*******************************************************************************

        The ubiquitous console IO support. These are standard Conduit 
        instances, with Reader/Writer wrappers applied appropriately. Note 
        that the outputs use FlushBuffer to automatically flush data as it 
        is added to the buffer. The basic usage of this module is illustrated 
        below:

        @code
        char[] msg = "on the console";

        Stdout ("print ") (1) (' ') ("message ") (msg) (CR);
        @endcode

        An alternative is to use put() notation like so:

        @code
        char[] msg = "on the console";

        Stdout.put ("print ")
              .put (1)
              .put (' ')
              .put ("message ")
              .put (msg)
              .put (CR);
        @endcode

        Another alternative is to use the C++ iostream operators like so:

        @code
        char[] msg = "on the console";

        Stdout << "print "
               << 1
               << ' '
               << "message "
               << msg
               << CR;
        @endcode

        Since console idioms are based upon Conduit, you can use them 
        as direct targets for stream-oriented operations. For example, 
        the code:

        @code
          FileConduit from = new FileConduit ("myfile.txt");
          Stdout.conduit.copy (from);
        @endcode

        copies a text file directly to the console. Likewise, you can 
        copy console input directly to a FileConduit or a SocketConduit.
        Input via Stdin is similar in nature, but uses the Token classes
        to isolate and parse each token on an input line:

        @code
        Stdout ("please input a number: ") ();
        int x;
        Stdin (x);          
        @endcode

        @code
        Stdout ("please enter your name: ") ();
        char[] you;
        Stdin (you);           
        Stdout ("Hello ") (you) (CR);
        @endcode

        Stdout automatically flushes the output when it sees a CR, so you 
        may need to flush the output manually where a CR is not desired.
        This is the case in the above example, so we use the empty () to
        request a flush (which is actually an alias for the flush method).

        Note that Stdin awaits a carriage-return before parsing the input
        into the targets. Note also that the Stdout and Stderr are not written 
        to be thread-safe. As such you may find that output from two threads 
        intersect across each other. If this is a problem you should wrap a 
        synchronized block around the offending entity, like so:

        @code
        synchronized (Stdout)
                      Stdout ("this is ") ("'atomic' ") (" output") (CR);
        @endcode
        
        Alternatively, please consider using the mango.log (Logger) package 
        to provide detailed runtime diagnostics from your application. The 
        functionality exposed there is likely sufficient for most application 
        needs.

        Redirecting the standard IO handles (via a shell) operates as one 
        would expect.

*******************************************************************************/

static FlushWriter Stdout,
                   Stderr;

static this ()
{
        Stdout = new FlushWriter (Cout);
        Stderr = new FlushWriter (Cerr);

        Stdout.setEncoder (new UnicodeImporter!(char)(Cout));
        Stderr.setEncoder (new UnicodeImporter!(char)(Cerr));
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
