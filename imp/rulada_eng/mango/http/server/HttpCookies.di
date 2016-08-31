/*******************************************************************************

        @file HttpCookies.d
        
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

module mango.http.server.HttpCookies;

private import  mango.io.Buffer;

private import  mango.text.Text,
                mango.text.Iterator;

private import  mango.io.model.IWriter,
                mango.io.model.IBuffer,
                mango.io.model.IConduit;

private import  mango.convert.Integer;

private import  mango.http.HttpWriter;

private import  mango.http.server.HttpHeaders;


version (Ares)
         private import  std.c.ctype;
      else
         private import  std.ctype;


/*******************************************************************************

        Defines the Cookie class, and the means for reading & writing them.
        Cookie implementation conforms with RFC 2109, but supports parsing 
        of server-side cookies only. Client-side cookies are supported in
        terms of output, but response parsing is not yet implemented ...

        See over <A HREF="http://www.faqs.org/rfcs/rfc2109.html">here</A>
        for the RFC document.        

*******************************************************************************/

class Cookie : IWritable
{
        private char[]  name,
                        path,
                        value,
                        domain,
                        comment;
        private uint    vrsn=1;              // 'version' is a reserved word
        private long    maxAge;
        private bool    secure;

        /***********************************************************************
                
                Construct an empty client-side cookie. You add these
                to an output request using HttpClient.addCookie(), or
                the equivalent.

        ***********************************************************************/

        this ()
        {
        }

        /***********************************************************************
        
                Construct a cookie with the provided attributes. You add 
                these to an output request using HttpClient.addCookie(), 
                or the equivalent.

        ***********************************************************************/

        this (char[] name, char[] value)
        {
                setName (name);
                setValue (value);
        }

        /***********************************************************************
        
                Set the name of this cookie

        ***********************************************************************/

        void setName (char[] name)
        {
                this.name = name;
        }

        /***********************************************************************
        
                Set the value of this cookie

        ***********************************************************************/

        void setValue (char[] value)
        {
                this.value = value;
        }

        /***********************************************************************
                
                Set the version of this cookie

        ***********************************************************************/

        void setVersion (uint vrsn)
        {
                this.vrsn = vrsn;
        }

        /***********************************************************************
        
                Set the path of this cookie

        ***********************************************************************/

        void setPath (char[] path)
        {
                this.path = path;
        }

        /***********************************************************************
        
                Set the domain of this cookie

        ***********************************************************************/

        void setDomain (char[] domain)
        {
                this.domain = domain;
        }

        /***********************************************************************
        
                Set the comment associated with this cookie

        ***********************************************************************/

        void setComment (char[] comment)
        {
                this.comment = comment;
        }

        /***********************************************************************
        
                Set the maximum duration of this cookie

        ***********************************************************************/

        void setMaxAge (long maxAge)
        {
                this.maxAge = maxAge;
        }

        /***********************************************************************
        
                Indicate wether this cookie should be considered secure or not

        ***********************************************************************/

        void setSecure (bool secure)
        {
                this.secure = secure;
        }

        /***********************************************************************
        
                Output the cookie as a text stream, via the provided IWriter.

        ***********************************************************************/

        void write (IWriter writer)
        {
                writer.put (name);

                if (value.length)
                    writer.put ('=').put(value);

                if (path.length)
                    writer.put (";Path="c).put(path);

                if (domain.length)
                    writer.put (";Domain="c).put(domain);

                if (vrsn)
                   {
                   char[32] tmp;

                   writer.put (";Version="c).put(Integer.format(tmp, vrsn));

                   if (comment.length)
                       writer.put (";Comment=\""c).put(comment).put('"');

                   if (secure)
                       writer.put (";Secure"c);

                   if (maxAge >= 0)
                       writer.put (";Max-Age="c).put(Integer.format(tmp, maxAge));
                   }
        }

        /***********************************************************************
        
                Reset this cookie

        ***********************************************************************/

        void clear ()
        {
                maxAge = 0;
                vrsn = 1;
                secure = false;
                name = path = domain = comment = null;
        }
}



/*******************************************************************************

        Implements a stack of cookies. Each cookie is pushed onto the
        stack by a parser, which takes its input from HttpHeaders. The
        stack can be populated for both client and server side cookies.

*******************************************************************************/

class CookieStack
{
        private int             depth;
        private Cookie[]        cookies;

        /**********************************************************************

                Construct a cookie stack with the specified initial extent.
                The stack will grow as necessary over time.

        **********************************************************************/

        this (int size)
        {
                cookies = new Cookie[0];
                resize (cookies, size);
        }

        /**********************************************************************

                Pop the stack all the way to zero

        **********************************************************************/

        final void reset ()
        {
                depth = 0;
        }

        /**********************************************************************

                Return a fresh cookie from the stack

        **********************************************************************/

        final Cookie push ()
        {
                if (depth == cookies.length)
                    resize (cookies, depth * 2);
                return cookies [depth++];
        }
        
        /**********************************************************************

                Resize the stack such that is has more room.

        **********************************************************************/

        private final static void resize (inout Cookie[] cookies, int size)
        {
                int i = cookies.length;
                
                for (cookies.length=size; i < cookies.length; ++i)
                     cookies[i] = new Cookie();
        }

        /**********************************************************************

                Iterate over all cookies in stack

        **********************************************************************/

        int opApply (int delegate(inout Cookie) dg)
        {
                int result = 0;

                for (int i=0; i < depth; ++i)
                     if ((result = dg (cookies[i])) != 0)
                          break;
                return result;
        }
}



/*******************************************************************************

        This is the support point for server-side cookies. It wraps a
        CookieStack together with a set of HttpHeaders, along with the
        appropriate cookie parser. One would do something very similar
        for client side cookie parsing also.

*******************************************************************************/

class HttpCookies : IWritable
{
        private bool                    parsed;
        private CookieStack             stack;
        private CookieParser            parser;
        private HttpHeaders             headers;

        /**********************************************************************

                Construct cookie wrapper with the provided headers.

        **********************************************************************/

        this (HttpHeaders headers)
        {
                this.headers = headers;

                // create a stack for parsed cookies
                stack = new CookieStack (10);

                // create a parser
                parser = new CookieParser (stack);
        }

        /**********************************************************************

                Output each of the cookies parsed to the provided IWriter.

        **********************************************************************/

        void write (IWriter writer)
        {
                foreach (Cookie cookie; parse)
                         writer.put (cookie).cr();
        }

        /**********************************************************************

                Reset these cookies for another parse

        **********************************************************************/

        void reset ()
        {
                stack.reset();
                parsed = false;
        }

        /**********************************************************************

                Parse all cookies from our HttpHeaders, pushing each onto
                the CookieStack as we go.

        **********************************************************************/

        CookieStack parse ()
        {
                if (! parsed)
                   {
                   parsed = true;

                   foreach (HeaderElement header; headers)
                            if (header.name.value == HttpHeader.Cookie.value)
                                parser.parse (header.value);
                   }
                return stack;
        }
}



/*******************************************************************************

        Handles a set of output cookies by writing them into the list of
        output headers.

*******************************************************************************/

class HttpMutableCookies
{
        private HttpWriter              writer;
        private HttpMutableHeaders      headers;

        /**********************************************************************

                Construct an output cookie wrapper upon the provided 
                output headers. Each cookie added is converted to an
                addition to those headers.

        **********************************************************************/

        this (HttpMutableHeaders headers)
        {
                this.headers = headers;
                writer = new HttpWriter (headers.getOutputBuffer);
        }

        /**********************************************************************

                Add a cookie to our output headers.

        **********************************************************************/

        void add (Cookie cookie)
        {
                // nested function to actually perform the output
                void writeCookie (IBuffer buf)
                {
                        cookie.write (writer);
                }

                // add the cookie header via our callback
                headers.add (HttpHeader.SetCookie, &writeCookie);        
        }
}



/*******************************************************************************

        Server-side cookie parser. See RFC 2109 for details.

*******************************************************************************/

class CookieParser : IteratorT!(char)
{
        private enum State {Begin, LValue, Equals, RValue, Token, SQuote, DQuote};

        private CookieStack stack;

        /***********************************************************************

        ***********************************************************************/

        this (CookieStack stack)
        {
                super ();
                this.stack = stack;
        }

        /***********************************************************************

                Callback for iterator.next(). We scan for name-value
                pairs, populating Cookie instances along the way.

        ***********************************************************************/

        protected uint scan (void[] data)
        {      
                char    c;
                int     mark,
                        vrsn;
                char[]  name,
                        token;
                Cookie  cookie;

                State   state = State.Begin;
                char[]  content = cast(char[]) data;

                /***************************************************************

                        Found a value; set that also

                ***************************************************************/

                void setValue (int i)
                {   
                        token = content [mark..i];
                        //Print ("::name '%.*s'\n", name);
                        //Print ("::value '%.*s'\n", token);

                        if (name[0] != '$')
                           {
                           cookie = stack.push();
                           cookie.setName (name);
                           cookie.setValue (token);
                           cookie.setVersion (vrsn);
                           }
                        else
                           switch (toLower (name))
                                  {
                                  case "$path":
                                        if (cookie)
                                            cookie.setPath (token); 
                                        break;

                                  case "$domain":
                                        if (cookie)
                                            cookie.setDomain (token); 
                                        break;

                                  case "$version":
                                        vrsn = cast(int) Integer.parse (token); 
                                        break;

                                  default:
                                       break;
                                  }
                        state = State.Begin;
                }

                /***************************************************************

                        Scan content looking for cookie fields

                ***************************************************************/

                for (int i; i < content.length; ++i)
                    {
                    c = content [i];
                    switch (state)
                           {
                           // look for an lValue
                           case State.Begin:
                                mark = i;
                                if (isalpha (c) || c is '$')
                                    state = State.LValue;
                                continue;

                           // scan until we have all lValue chars
                           case State.LValue:
                                if (! isalnum (c))
                                   {
                                   state = State.Equals;
                                   name = content [mark..i];
                                   --i;
                                   }
                                continue;

                           // should now have either a '=', ';', or ','
                           case State.Equals:
                                if (c is '=')
                                    state = State.RValue;
                                else
                                   if (c is ',' || c is ';')
                                       // get next NVPair
                                       state = State.Begin;
                                continue;

                           // look for a quoted token, or a plain one
                           case State.RValue:
                                mark = i;
                                if (c is '\'')
                                    state = State.SQuote;
                                else
                                   if (c is '"')
                                       state = State.DQuote;
                                   else
                                      if (isalpha (c))
                                          state = State.Token;
                                continue;

                           // scan for all plain token chars
                           case State.Token:
                                if (! isalnum (c))
                                   {
                                   setValue (i);
                                   --i;
                                   }
                                continue;

                           // scan until the next '
                           case State.SQuote:
                                if (c is '\'')
                                    ++mark, setValue (i);
                                continue;

                           // scan until the next "
                           case State.DQuote:
                                if (c is '"')
                                    ++mark, setValue (i);
                                continue;

                           default:
                                continue;
                           }
                    }

                // we ran out of content; patch partial cookie values 
                if (state is State.Token)
                    setValue (content.length);

                // go home
                return IConduit.Eof;
        }
                                
        /***********************************************************************
        
                Locate the next token from the provided buffer, and map a
                buffer reference into token. Returns true if a token was 
                located, false otherwise. 

                Note that the buffer content is not duplicated. Instead, a
                slice of the buffer is referenced by the token. You can use
                Token.clone() or Token.toString().dup() to copy content per
                your application needs.

                Note also that there may still be one token left in a buffer 
                that was not terminated correctly (as in eof conditions). In 
                such cases, tokens are mapped onto remaining content and the 
                buffer will have no more readable content.

        ***********************************************************************/

        bool parse (char[] header)
        {
                super.set (header);
                return next ();
        }

        /**********************************************************************

                in-place conversion to lowercase 

        **********************************************************************/

        final static char[] toLower (inout char[] src)
        {
                foreach (int i, char c; src)
                         if (c >= 'A' && c <= 'Z')
                             src[i] = c + ('a' - 'A');
                return src;
        }
}
   
     

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
