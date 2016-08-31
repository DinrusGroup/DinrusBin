/*******************************************************************************

        @file UMango.d
        
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

module mango.icu.UMango;

public  import mango.icu.UConverter;

private import mango.convert.Type;

/*******************************************************************************

        Include these classes when compiled with the Mango.io package.
        They represent the 'glue' to bind said package to the unicode 
        converters provided by ICU.

*******************************************************************************/

version (Isolated){}
else
{
        private import mango.io.model.IReader;
        private import mango.io.model.IWriter;

        /***********************************************************************

                Abstract base class for String decoders. These decoders
                bind the ICU functionality to the Mango.io package, and
                provide some utility functions such as input streaming.

                These decoder classes will always attempt to fill their
                destination (provided) output array, but may terminate
                early if (a) a defined read 'limit' on the input stream 
                has been reached or (b) a partial surrogate-pair would
                be left at the output tail. Each decoder returns a count
                of how many output elements were actually converted.

        ***********************************************************************/

        class StringDecoder : AbstractDecoder, IReadable
        {
                private UConverter      cvt;
                private bool            done;
                private IBuffer         bound;
                private uint            limit = uint.max;

                /***************************************************************

                        Decoders can be used to convert directly into a 
                        provided destination. The converter will try to 
                        fill the destination, up to the configured input 
                        'limit', and returns the number of elements thus
                        converted. This returned value will be less than
                        the destination capacity when either the 'limit'
                        was reached, or when a partial surrogate would  
                        be placed at the tail.

                ***************************************************************/

                abstract uint read (IBuffer b, wchar[] dst);

                /***************************************************************

                        Signature for BufferDecoder handlers. These 
                        decoders are intended to be usable as the 
                        default handlers within the reader constructs. 
                        Use IReader.setDecoder() to set a decoder as 
                        the default handler.

                ***************************************************************/

                abstract uint decoder (void* p, uint capacity, uint type);

                /***************************************************************

                        Return the type of this decoder

                ***************************************************************/

                abstract uint type ();

                /***************************************************************

                        Set the limit for this decoder. This will cause
                        the decoder to halt after reading the specified 
                        number of bytes from its input. The decoder may
                        also halt before that point if the destination
                        becomes full. Use method toGo() to monitor how 
                        much content has been read so far.

                ***************************************************************/

                void setLimit (uint limit)
                {
                        this.limit = limit;
                }

                /***************************************************************

                        Change the converter used for this decoder.

                ***************************************************************/

                void setConverter (UConverter cvt)
                in {
                   assert (cvt);
                   }
                body
                {
                        this.cvt = cvt;
                }

                /***************************************************************

                        Reset the converter and the input limit. The latter
                        defaults to being unlimited, causing the decoder to
                        read until the destination is full.

                ***************************************************************/

                void reset (uint limit = uint.max)
                {
                        setLimit  (limit);
                        cvt.reset ();
                }

                /***************************************************************

                        Return the number of bytes yet to be read

                ***************************************************************/

                protected uint toGo ()
                {
                        return limit;
                }

                /***************************************************************

                        Placeholder for subclasses to do something useful
                        when applied to an IReader. See UString for an 
                        example of such usage.

                ***************************************************************/

                protected void read (IReader r)
                {
                }

                /***************************************************************

                        Bind this StringDecoder to the specified IReader.
                        This is invoked by an IReader to install it as the 
                        default handler, and thus be used by all subsequent 
                        IReader.get() requests for the subclass type. 
                        
                        Note that the byte limit will be respected if 'limit' 
                        has been set, which can be useful when converting an 
                        unknown number of elements (a la HTTP).

                ***************************************************************/

                final void bind (IBuffer buffer)
                {
                        bound = buffer;
                }

                /***************************************************************

                        Decode IBuffer input until the delegate indicates
                        it is finished. Typically, that occurs when either
                        the destination is full, or the input 'limit' has
                        been reached.

                ***************************************************************/

                private final void decode (IBuffer buffer, uint delegate (void[]) dg)
                {
                        done = false;
                        while (limit && !done)
                              {
                              buffer.get  (1, false);
                              buffer.read (dg);
                              }
                }
        }


        /***********************************************************************

                Decode a byte stream into UTF16 wchars. This decoder can:

                - be used as the default wchar handler when attached to 
                  an IReader (see IReader.setDecoder).
                
                - be used directly to fill a provided destination array
                  with converted wchars.

                - be used in either of the prior two cases with a 'limit'
                  placed upon the number of input bytes converted (in 
                  addition to the destination capacity limit). This can
                  be useful when the number of raw bytes is known, but 
                  the number of wchar elements is not, and can be handy
                  for streaming conversions.

        ***********************************************************************/

        class StringDecoder16 : StringDecoder
        {
                /***************************************************************

                        Construct a decoder with the given UConverter, and
                        an optional 'limit' to the number of input bytes to
                        be converted.

                ***************************************************************/

                this (UConverter cvt, uint limit = uint.max)
                {
                        this.cvt = cvt;
                        super.reset (limit);
                }

                /***************************************************************

                        Construct a decoder of the given specification, and
                        an optional 'limit' to the number of input bytes to
                        be converted.

                ***************************************************************/

                this (char[] type, uint limit = uint.max)
                {
                        this (new UConverter (type), limit);
                }

                /***************************************************************

                        Return the type of this decoder

                ***************************************************************/

                uint type ()
                {
                        return Type.Utf16;
                }

                /***************************************************************

                        Signature for BufferDecoder handlers. These 
                        decoders are intended to be usable as the 
                        default handlers within the reader constructs. 
                        Use IReader.setDecoder() to set a decoder as 
                        the default handler.

                ***************************************************************/

                protected uint decoder (void* p, uint capacity, uint type)
                {       
                        // this ugly conversion/casting back and forth is
                        // a lot more efficient than the intrinsic array
                        // conversion generated via an array[] cast
                        return read (bound, (cast(wchar*) p)[0..capacity / wchar.sizeof]) * wchar.sizeof;
                }

                /***************************************************************

                        Decoders can be used to convert directly into a 
                        provided destination. The converter will try to 
                        fill the destination, up to the configured input 
                        'limit', and returns the number of elements thus
                        converted. This returned value will be less than
                        the destination capacity when either the 'limit'
                        was reached, or when a partial surrogate would  
                        have been placed at the tail.

                ***************************************************************/

                final uint read (IBuffer buffer, wchar[] dst)
                {
                        uint produced;

                        uint read (void[] x)
                        {
                                UAdjust adj;
                                uint    len = x.length;

                                // have we read enough from the source?
                                if (len > limit)
                                    len = limit;
                                
                                // do the conversion; test for overflow.
                                // There's an issue here with certain 
                                // conversion types (e.g. utf7) where byte
                                // combinations appear ambiguous. It is
                                // possible that the converter will cache
                                // such combinations until it determines 
                                // the result from subsequent input data. 
                                // However, if such a condition occurs at
                                // the tail end of an input stream, the
                                // conversion may stall whilst waiting on
                                // more input. There does not appear to
                                // be a means of identifying whether or
                                // not content has been cached, so there 
                                // is little one can do at this time ...
                                // Note that this issue does not exist
                                // when 'limit' is active
                                done = cvt.decode (x[0..len], dst[produced..length], adj, len == 0);

                                // adjust output. Note that we always clip
                                // the bytes read to match the output size
                                if ((produced += adj.output) >= dst.length)
                                     done = true;

                                // are we limiting input?
                                if (limit != uint.max)
                                    limit -= adj.input;                                

                                // say how much we consumed
                                return adj.input;
                        }

                        decode (buffer, &read);
                        return produced;
                }
        }



        /***********************************************************************

        ***********************************************************************/

        class StringEncoder : AbstractEncoder
        {
                private bool    more;
                private IBuffer bound;

                /***************************************************************

                ***************************************************************/

                abstract void reset ();

                /***************************************************************

                ***************************************************************/

                abstract uint type ();

                /***************************************************************

                ***************************************************************/

                abstract uint encoder (void* p, uint count, uint type);

                /***************************************************************

                        Bind this StringEncoder to the specified IWriter.
                        This is invoked by an IWriter to install it as the 
                        default handler, and thus be used by all subsequent 
                        IReader.put() requests for the subclass type. 
                        
                ***************************************************************/

                void bind (IBuffer buffer)
                {
                        bound = buffer;
                }

                /***************************************************************

                ***************************************************************/

                private final void encode (IBuffer b, uint delegate (void[]) dg)
                {
                        more = true;
                        b.write (dg);

                        while (more)
                              {
                              // this should be some 'realistic' number, but
                              // is needed to handle the case of a GrowBuffer
                              b.makeRoom (1024);
                              b.write (dg);
                              }
                }
        }


        /***********************************************************************

        ***********************************************************************/

        class StringEncoder8 : StringEncoder
        {
                private ITranscoder xcode;

                /***************************************************************

                        Construct an encoder for the given UConverter, 
                        where the source-content encoding is specified
                        by 'source'.

                        The default source-encoding is assumed to be utf8.

                ***************************************************************/

                this (UConverter cvt, char[] source = "utf8")
                {
                        xcode = (new UConverter(source)).createTranscoder (cvt);
                }

                /***************************************************************

                        Construct an encoder of the given output 'type',
                        where the source-content encoding is specified
                        by 'source'.

                        The default source-encoding is assumed to be utf8.

                ***************************************************************/

                this (char[] type, char[] source = "utf8")
                {
                        this (new UConverter(type), source);
                }

                /***************************************************************

                ***************************************************************/

                void encode (IBuffer b, char[] c)
                {
                        uint write (void[] x)
                        {
                                UAdjust adj;

                                more = xcode.convert (c, x, adj, c.length == 0);
                                c = c[adj.input..length];
                                return adj.output;
                        }

                        super.encode (b, &write);
                }

                /***************************************************************

                ***************************************************************/

                protected uint encoder (void* p, uint count, uint type)
                {
                        encode (bound, (cast(char*) p)[0..count/char.sizeof]);
                        return 0;
                }

                /***************************************************************

                ***************************************************************/

                uint type ()
                {
                        return Type.Utf8;
                }

                /***************************************************************

                ***************************************************************/

                void reset ()
                {
                        xcode.reset();
                }
        }


        /***********************************************************************

        ***********************************************************************/

        class StringEncoder16 : StringEncoder
        {
                private UConverter cvt;

                /***************************************************************

                ***************************************************************/

                this (UConverter cvt)
                {
                        this.cvt = cvt;
                }

                /***************************************************************

                        Construct an encoder of the given output 'type'.

                        The source-encoding is assumed to be utf16.

                ***************************************************************/

                this (char[] type)
                {
                        this (new UConverter(type));
                }

                /***************************************************************

                ***************************************************************/

                void encode (IBuffer b, wchar[] w)
                {
                        uint write (void[] x)
                        {
                                UAdjust adj;

                                more = cvt.encode (w, x, adj, w.length == 0);
                                w = w[adj.input..length];
                                return adj.output;
                        }

                        super.encode (b, &write);       
                }

                /***************************************************************

                ***************************************************************/

                protected uint encoder (void* p, uint count, uint type)
                {
                        encode (bound, (cast(wchar*) p)[0..count/wchar.sizeof]);
                        return 0;
                }

                /***************************************************************

                ***************************************************************/

                uint type ()
                {
                        return Type.Utf16;
                }

                /***************************************************************

                ***************************************************************/

                void reset ()
                {
                        cvt.reset();
                }
        }


        /***********************************************************************

        ***********************************************************************/

        class StringEncoder32 : StringEncoder
        {
                private ITranscoder xcode;

                /***************************************************************

                ***************************************************************/

                this (UConverter cvt)
                {
                        xcode = (new UConverter("utf32")).createTranscoder (cvt);
                }

                /***************************************************************

                        Construct an encoder of the given output 'type'.

                        The source-encoding is assumed to be utf32.

                ***************************************************************/

                this (char[] type)
                {
                        this (new UConverter(type));
                }

                /***************************************************************

                ***************************************************************/

                void encode (IBuffer b, dchar[] d)
                {
                        uint write (void[] x)
                        {
                                UAdjust adj;

                                more = xcode.convert (d, x, adj, d.length == 0);
                                d = d[adj.input..length];
                                return adj.output;
                        }

                        super.encode (b, &write);       
                }

                /***************************************************************

                ***************************************************************/

                protected uint encoder (void* p, uint count, uint type)
                {
                        encode (bound, (cast(dchar*) p)[0..count/dchar.sizeof]);
                        return 0;
                }

                /***************************************************************

                ***************************************************************/

                uint type ()
                {
                        return Type.Utf32;
                }

                /***************************************************************

                ***************************************************************/

                void reset ()
                {
                        xcode.reset();
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
