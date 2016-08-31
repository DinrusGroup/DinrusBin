/*******************************************************************************

        @file HttpParams.d
        
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

module mango.http.server.HttpParams;

private import  mango.io.model.IBuffer;

private import  mango.text.SimpleIterator;

private import  mango.http.server.HttpTokens;

/******************************************************************************

        Maintains a set of query parameters, parsed from an HTTP request.
        Use HttpMutableParams instead for output parameters.

        Note that these input params may have been encoded by the user-
        agent. Unfortunately there has been little consensus on what that
        encoding should be (especially regarding GET query-params). With
        luck, that will change to a consistent usage of UTF-8 within the 
        near future.

******************************************************************************/

class HttpParams : HttpTokens
{
        // tell compiler to used super.parse() also
        alias HttpTokens.parse parse;

        private SimpleIterator amp;

        /**********************************************************************
                
                Construct parameters by telling the TokenStack that
                name/value pairs are seperated by a '=' character.

        **********************************************************************/

        this ()
        {
                super ('=');

                // construct a line tokenizer for later usage
                amp = new SimpleIterator ("&");
        }

        /**********************************************************************
                
                Clone a source set of HttpParams

        **********************************************************************/

        this (HttpParams source)
        {
                super (source);
        }

        /**********************************************************************
                
                Clone this set of HttpParams

        **********************************************************************/

        HttpParams clone ()
        {
                return new HttpParams (this);
        }

        /**********************************************************************
                
                Read all query parameters. Everything is mapped rather 
                than being allocated & copied

        **********************************************************************/

        void parse (IBuffer input)
        {
                setParsed (true);
                amp.set (input);

                while (amp.next || amp.get.length)
                       stack.push (amp.get);
        }
}


/******************************************************************************

        HttpMutableParams are used for output purposes. This can be used
        to add a set of queries and then combine then into a text string
        using method write().

******************************************************************************/

class HttpMutableParams : HttpParams
{      
        /**********************************************************************
                
                Construct output params upon the provided IBuffer

        **********************************************************************/

        this (IBuffer output)
        {
                super();
                super.setOutputBuffer (output);
        }
        
        /**********************************************************************
                
                Clone a source set of HttpMutableParams

        **********************************************************************/

        this (HttpMutableParams source)
        {
                super (source);
        }

        /**********************************************************************
                
                Clone this set of HttpMutableParams

        **********************************************************************/

        HttpMutableParams clone ()
        {
                return new HttpMutableParams (this);
        }

        /**********************************************************************
                
                Add a name/value pair to the query list

        **********************************************************************/

        void add (char[] name, char[] value)
        {
                super.add (name, value);
        }

        /**********************************************************************
                
                Add a name/integer pair to the query list 

        **********************************************************************/

        void addInt (char[] name, int value)
        {
                super.addInt (name, value);
        }


        /**********************************************************************
                
                Add a name/date(long) pair to the query list

        **********************************************************************/

        void addDate (char[] name, ulong value)
        {
                super.addDate (name, value);
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
