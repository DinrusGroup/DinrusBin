private import mango.http.client.HttpClient;

private import  mango.sys.System;

private import  mango.convert.Atoi;

private import  mango.io.Uri,
				mango.io.Stdout,
                mango.io.Buffer,
                mango.io.Exception,
                mango.io.SocketConduit,
                mango.io.Writer;

private import  mango.text.LineIterator;

private import  mango.http.utils.TokenTriplet;

private import  mango.http.server.HttpParams,  
                mango.http.server.HttpHeaders,
                mango.http.server.HttpCookies,
                mango.http.server.HttpResponse;

private import  mango.http.HttpWriter;


 // callback for client reader
        void sink (char[] content)
        {
                Stdout.put (content);
        }

void main(){
        // create client for a GET request
        auto client = new HttpClient (HttpClient.Get, "http://www.yahoo.com");

        // make request
        client.open ();

        // check return status for validity
        if (client.isResponseOK)
           {
           // extract content length
           int length = client.getResponseHeaders.getInt (HttpHeader.ContentLength, int.max);
        
           // display all returned headers
           Stdout.put (client.getResponseHeaders);
        
           // display remaining content
           client.read (&sink, length);
           }
        else
           Stderr.put (client.getResponse);

        client.close ();
	}