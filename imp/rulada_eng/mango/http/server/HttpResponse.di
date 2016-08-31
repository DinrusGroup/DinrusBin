/*******************************************************************************

        @file HttpResponse.d
        
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

        
        @version        Initial version, April 2004      
        @author         Kris


*******************************************************************************/

module mango.http.server.HttpResponse;

private import  mango.io.Buffer,
                mango.io.Writer;

private import  mango.io.model.IWriter;

private import  mango.http.HttpWriter;

private import  mango.http.server.HttpParams,
                mango.http.server.HttpCookies,
                mango.http.server.HttpHeaders,
                mango.http.server.HttpMessage;

private import  mango.http.server.model.IProviderBridge;

//version = ShowHeaders;

/*******************************************************************************

        Some constants for output buffer sizes

*******************************************************************************/

private static const int ParamsBufferSize = 1 * 1024;
private static const int HeaderBufferSize = 4 * 1024;


/*******************************************************************************

        Status is a compound type, with a name and a code.

*******************************************************************************/

struct HttpStatus
{
        int     code; 
        char[]  name;  
}

/*******************************************************************************

        Declare the traditional set of HTTP response codes

*******************************************************************************/

enum HttpResponseCode
{       
        Continue                     = 100,
        SwitchingProtocols           = 101,
        OK                           = 200,
        Created                      = 201,
        Accepted                     = 202,
        NonAuthoritativeInformation  = 203,
        NoContent                    = 204,
        ResetContent                 = 205,
        PartialContent               = 206,
        MultipleChoices              = 300,
        MovedPermanently             = 301,
        MovedTemporarily             = 302,
        SeeOther                     = 303,
        NotModified                  = 304,
        UseProxy                     = 305,
        TemporaryRedirect            = 307,
        BadRequest                   = 400,
        Unauthorized                 = 401,
        PaymentRequired              = 402,
        Forbidden                    = 403,
        NotFound                     = 404,
        MethodNotAllowed             = 405,
        NotAcceptable                = 406,
        ProxyAuthenticationRequired  = 407,
        RequestTimeout               = 408,
        Conflict                     = 409,
        Gone                         = 410,
        LengthRequired               = 411,
        PreconditionFailed           = 412,
        RequestEntityTooLarge        = 413,
        RequestURITooLarge           = 414,
        UnsupportedMediaType         = 415,
        RequestedRangeNotSatisfiable = 416,
        ExpectationFailed            = 417,
        InternalServerError          = 500,
        NotImplemented               = 501,
        BadGateway                   = 502,
        ServiceUnavailable           = 503,
        GatewayTimeout               = 504,
        VersionNotSupported          = 505,
};

/*******************************************************************************

        Declare the traditional set of HTTP responses

*******************************************************************************/

struct HttpResponses
{       
        static /*final*/ HttpStatus Continue                     = {HttpResponseCode.Continue, "Continue"};
        static /*final*/ HttpStatus SwitchingProtocols           = {HttpResponseCode.SwitchingProtocols, "SwitchingProtocols"};
        static /*final*/ HttpStatus OK                           = {HttpResponseCode.OK, "OK"};
        static /*final*/ HttpStatus Created                      = {HttpResponseCode.Created, "Created"};
        static /*final*/ HttpStatus Accepted                     = {HttpResponseCode.Accepted, "Accepted"};
        static /*final*/ HttpStatus NonAuthoritativeInformation  = {HttpResponseCode.NonAuthoritativeInformation, "NonAuthoritativeInformation"};
        static /*final*/ HttpStatus NoContent                    = {HttpResponseCode.NoContent, "NoContent"};
        static /*final*/ HttpStatus ResetContent                 = {HttpResponseCode.ResetContent, "ResetContent"};
        static /*final*/ HttpStatus PartialContent               = {HttpResponseCode.PartialContent, "PartialContent"};
        static /*final*/ HttpStatus MultipleChoices              = {HttpResponseCode.MultipleChoices, "MultipleChoices"};
        static /*final*/ HttpStatus MovedPermanently             = {HttpResponseCode.MovedPermanently, "MovedPermanently"};
        static /*final*/ HttpStatus MovedTemporarily             = {HttpResponseCode.MovedTemporarily, "MovedTemporarily"};
        static /*final*/ HttpStatus SeeOther                     = {HttpResponseCode.SeeOther, "SeeOther"};
        static /*final*/ HttpStatus NotModified                  = {HttpResponseCode.NotModified, "NotModified"};
        static /*final*/ HttpStatus UseProxy                     = {HttpResponseCode.UseProxy, "UseProxy"};
        static /*final*/ HttpStatus BadRequest                   = {HttpResponseCode.BadRequest, "BadRequest"};
        static /*final*/ HttpStatus Unauthorized                 = {HttpResponseCode.Unauthorized, "Unauthorized"};
        static /*final*/ HttpStatus PaymentRequired              = {HttpResponseCode.PaymentRequired, "PaymentRequired"};
        static /*final*/ HttpStatus Forbidden                    = {HttpResponseCode.Forbidden, "Forbidden"};
        static /*final*/ HttpStatus NotFound                     = {HttpResponseCode.NotFound, "NotFound"};
        static /*final*/ HttpStatus MethodNotAllowed             = {HttpResponseCode.MethodNotAllowed, "MethodNotAllowed"};
        static /*final*/ HttpStatus NotAcceptable                = {HttpResponseCode.NotAcceptable, "NotAcceptable"};
        static /*final*/ HttpStatus ProxyAuthenticationRequired  = {HttpResponseCode.ProxyAuthenticationRequired, "ProxyAuthenticationRequired"};
        static /*final*/ HttpStatus RequestTimeout               = {HttpResponseCode.RequestTimeout, "RequestTimeout"};
        static /*final*/ HttpStatus Conflict                     = {HttpResponseCode.Conflict, "Conflict"};
        static /*final*/ HttpStatus Gone                         = {HttpResponseCode.Gone, "Gone"};
        static /*final*/ HttpStatus LengthRequired               = {HttpResponseCode.LengthRequired, "LengthRequired"};
        static /*final*/ HttpStatus PreconditionFailed           = {HttpResponseCode.PreconditionFailed, "PreconditionFailed"};
        static /*final*/ HttpStatus RequestEntityTooLarge        = {HttpResponseCode.RequestEntityTooLarge, "RequestEntityTooLarge"};
        static /*final*/ HttpStatus RequestURITooLarge           = {HttpResponseCode.RequestURITooLarge, "RequestURITooLarge"};
        static /*final*/ HttpStatus UnsupportedMediaType         = {HttpResponseCode.UnsupportedMediaType, "UnsupportedMediaType"};
        static /*final*/ HttpStatus RequestedRangeNotSatisfiable = {HttpResponseCode.RequestedRangeNotSatisfiable, "RequestedRangeNotSatisfiable"};
        static /*final*/ HttpStatus ExpectationFailed            = {HttpResponseCode.ExpectationFailed, "ExpectationFailed"};
        static /*final*/ HttpStatus InternalServerError          = {HttpResponseCode.InternalServerError, "InternalServerError"};
        static /*final*/ HttpStatus NotImplemented               = {HttpResponseCode.NotImplemented, "NotImplemented"};
        static /*final*/ HttpStatus BadGateway                   = {HttpResponseCode.BadGateway, "BadGateway"};
        static /*final*/ HttpStatus ServiceUnavailable           = {HttpResponseCode.ServiceUnavailable, "ServiceUnavailable"};
        static /*final*/ HttpStatus GatewayTimeout               = {HttpResponseCode.GatewayTimeout, "GatewayTimeout"};
        static /*final*/ HttpStatus VersionNotSupported          = {HttpResponseCode.VersionNotSupported, "VersionNotSupported"};
}


/******************************************************************************

        Define an http response to a user-agent (client). Note that all
        data is managed on a thread-by-thread basis.

******************************************************************************/

class HttpResponse : HttpMessage
{
        private HttpMutableParams       params;
        private HttpMutableCookies      cookies;
        private HttpStatus              status;
        private HttpWriter              writer;
        private bool                    commited;

        static private InvalidStateException InvalidState;

        /**********************************************************************

                Construct static instances of exceptions etc. 

        **********************************************************************/

        static this()
        {
                InvalidState = new InvalidStateException("Invalid response state");
        }

        /**********************************************************************

                Create a Response instance. Note that we create a bunch of
                internal support objects on a per-thread basis. This is so
                we don't have to create them on demand; however, we should
                be careful about resetting them all before each new usage.

        **********************************************************************/

        this (IProviderBridge bridge)
        {
                // create a seperate output buffer for headers to reside
                super (bridge, new Buffer(HeaderBufferSize));

                // create a default output writer
                writer = new HttpWriter (super.getBuffer());
        
                // create a cached query-parameter processor. We
                // support a maximum output parameter list of 1K bytes
                params = new HttpMutableParams (new Buffer(ParamsBufferSize));
        
                // create a wrapper for output cookies. This is more akin 
                // to a specialized writer, since it just adds additional
                // content to the output headers.
                cookies = new HttpMutableCookies (super.getHeader());
        }

        /**********************************************************************

                Reset this response, ready for the next connection

        **********************************************************************/

        void reset()
        {
                // response is "OK" by default
                commited = false;
                setStatus (HttpResponses.OK);

                // reset the headers
                super.reset();

                // reset output parameters
                params.reset();
        }

        /**********************************************************************

                Send an error status to the user-agent

        **********************************************************************/

        void sendError (inout HttpStatus status)
        {
                sendError (status, "");
        }

        /**********************************************************************

                Send an error status to the user-agent, along with the
                provided message

        **********************************************************************/

        void sendError (inout HttpStatus status, char[] msg)
        {       
                sendError (status, status.name, msg);
        }

        /**********************************************************************

                Send an error status to the user-agent, along with the
                provided exception text

        **********************************************************************/

        void sendError (inout HttpStatus status, Exception ex)
        {
                sendError (status, status.name, ex.toString());
        }

        /**********************************************************************

                Set the current response status.

        **********************************************************************/

        void setStatus (inout HttpStatus status)
        {
                this.status = status;
        }

        /**********************************************************************

                Return the current response status

        **********************************************************************/

        HttpStatus getStatus ()
        {
                return status;
        }

        /**********************************************************************

                Return the output writer. This set a sentinel indicating
                that we cannot add any more headers (since they have to
                be flushed before any additional output is sent).

        **********************************************************************/

        HttpWriter getWriter()
        {
                // write headers, and cause InvalidState on next call
                // to getOutputHeaders()
                commit (writer);               
                return writer;
        }

        /**********************************************************************

                Return the wrapper for adding output parameters

        **********************************************************************/

        HttpMutableParams getOutputParams()
        {
                return params;
        }

        /**********************************************************************

                Return the wrapper for output cookies

        **********************************************************************/

        HttpMutableCookies getOutputCookies()
        {
                return cookies;
        }

        /**********************************************************************

                Return the wrapper for output headers.

        **********************************************************************/

        HttpMutableHeaders getOutputHeaders()
        {
                // can't access headers after commiting
                if (commited)
                    throw InvalidState;
                return super.getHeader();
        }

        /**********************************************************************

                Return the buffer attached to the output conduit. Note that
                further additions to the output headers is disabled from
                this point forward. 

        **********************************************************************/

        IBuffer getOutputBuffer()
        {
                // write headers, and cause InvalidState on next call
                // to getOutputHeaders()
                commit (writer);
                return super.getBuffer();
        }

        /**********************************************************************

                Send a redirect response to the user-agent

        **********************************************************************/

        void sendRedirect (char[] location)
        {
                setStatus (HttpResponses.MovedTemporarily);
                getHeader().add (HttpHeader.Location, location);
                flush (writer);
        }

        /**********************************************************************

                Write the response and the output headers 

        **********************************************************************/

        void write (IWriter writer)
        {
                commit (writer);
        }

        /**********************************************************************

                Ensure the output is flushed

        **********************************************************************/

        void flush (IWriter writer)
        {
                commit (writer);

                version (ShowHeaders)
                        {
                        Stdout.put ("###############").cr();
                        Stdout.put (super.getBuffer.toString).cr();
                        Stdout.put ("###############").cr();
                        }
                writer.flush();
        }

        /**********************************************************************

                Private method to send the response status, and the
                output headers, back to the user-agent

        **********************************************************************/

        private void commit (IWriter writer)
        {
                if (! commited)
                   {
                   // say we've send headers on this response
                   commited = true;

                   char[]               header;
                   HttpMutableHeaders   headers = getHeader();

                   // write the response header
                   writer.put (HttpHeader.Version.value)
                         .put (' ')
                         .put (status.code)
                         .put (' ')
                         .put (status.name)
                         .cr  ();

                   // tell client we don't support keep-alive
                   if (! headers.get (HttpHeader.Connection))
                         headers.add (HttpHeader.Connection, "close");
                  
                   // write the header tokens, followed by a blank line
                   super.write (writer);
                   writer.cr ();

                   // send it back to the UA (and empty the buffer)
                   writer.flush();
                        
                   version (ShowHeaders)
                           {
                           Stdout.put (">>>> output headers"c).cr();
                           Stdout.put (HttpHeader.Version.value)
                                 .put (' ')
                                 .put (status.code)
                                 .put (' ')
                                 .put (status.name)
                                 .cr  ();
                           super.write (Stdout);
                           }
                   }
        }

        /**********************************************************************

                Send an error back to the user-agent. We have to be careful
                about which errors actually have content returned and those
                that don't.

        **********************************************************************/

        private void sendError (inout HttpStatus status, char[] reason, char[] message)
        {
                setStatus (status);

                if (status.code != HttpResponses.NoContent.code && 
                    status.code != HttpResponses.NotModified.code && 
                    status.code != HttpResponses.PartialContent.code && 
                    status.code >= HttpResponses.OK.code)
                   {
                   // error-page is html
                   setContentType (HttpHeader.TextHtml.value);

                   // output the headers
                   commit (writer);

                   // output an error-page
                   writer.put ("<HTML>\n<HEAD>\n<TITLE>Error "c)
                         .put (status.code)
                         .put (' ')
                         .put (reason)
                         .put ("</TITLE>\n<BODY>\n<H2>HTTP Error: "c)
                         .put (status.code)
                         .put (' ')
                         .put (reason)                       
                         .put ("</H2>\n"c)
                         .put (message ? message : ""c)
                         .put ("\n</BODY>\n</HTML>\n"c);

                   flush (writer);
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
