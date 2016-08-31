/*******************************************************************************

        @file UnicodeBom.d
        
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


        @version        Initial version; December 2005      

        @author         Kris

*******************************************************************************/

module mango.convert.UnicodeBom;

private import  mango.convert.Type;

private import  mango.sys.ByteSwap;

public  import  mango.convert.Unicode;

/*******************************************************************************

        Convert unicode content

        Unicode is an encoding of textual material. The purpose of this module 
        is to interface external-encoding with a programmer-defined internal-
        encoding. This internal encoding is declared via the template argument 
        T, whilst the external encoding is either specified or derived.

        Three internal encodings are supported: char, wchar, and dchar. The
        methods herein operate upon arrays of this type. That is, decode()
        returns an array of the type, while encode() expect an array of said 
        type.

        Supported external encodings are as follow (from Unicode.d):

                Unicode.Unknown 
                Unicode.UTF_8
                Unicode.UTF_8N
                Unicode.UTF_16
                Unicode.UTF_16BE
                Unicode.UTF_16LE 
                Unicode.UTF_32 
                Unicode.UTF_32BE
                Unicode.UTF_32LE 

        These can be divided into non-explicit and explicit encodings:

                Unicode.Unknown 
                Unicode.UTF_8
                Unicode.UTF_16
                Unicode.UTF_32 


                Unicode.UTF_8N
                Unicode.UTF_16BE
                Unicode.UTF_16LE 
                Unicode.UTF_32BE
                Unicode.UTF_32LE 
        
        The former group of non-explicit encodings may be used to 'discover'
        an unknown encoding, by examining the first few bytes of the content
        for a signature. This signature is optional, but is often written such 
        that the content is self-describing. When an encoding is unknown, using 
        one of the non-explicit encodings will cause the decode() method to look 
        for a signature and adjust itself accordingly. It is possible that a 
        ZWNBSP character might be confused with the signature; today's unicode 
        content is supposed to use the WORD-JOINER character instead.
       
        The group of explicit encodings are for use when the content encoding 
        is known. These *must* be used when converting back to external encoding, 
        since written content must be in a known format. It should be noted that, 
        during a decode() operation, the existence of a signature is in conflict 
        with these explicit varieties.


        See 
        $(LINK http://www.utf-8.com/)
        $(LINK http://www.hackcraft.net/xmlUnicode/)
        $(LINK http://www.unicode.org/faq/utf_bom.html/)
        $(LINK http://www.azillionmonkeys.com/qed/unicode.html/)
        $(LINK http://icu.sourceforge.net/docs/papers/forms_of_unicode/)

*******************************************************************************/

class UnicodeBomT(T) 
{
        static if (!is (T == char) && !is (T == wchar) && !is (T == dchar)) 
                    pragma (msg, "Template type must be char, wchar, or dchar");


        private int     encoding;       // the current encoding
        private Info*   settings;       // pointer to encoding configuration

        private Unicode.From!(T) from;
        private Unicode.Into!(T) into;

        private struct  Info
                {
                int     type;           // type of element (char/wchar/dchar)
                int     encoding;       // Unicode.xx encoding
                char[]  bom;            // pattern to match for signature
                bool    test,           // should we test for this encoding?
                        endian,         // this encoding have endian concerns?
                        bigEndian;      // is this a big-endian encoding?
                int     fallback;       // can this encoding be defaulted?
                };

        private const Info[] lookup =
        [
        {Type.Utf8,  Unicode.Unknown,  null,        true, false, false, Unicode.UTF_8N},
        {Type.Utf8,  Unicode.UTF_8,    null,        true, false, false, Unicode.UTF_8N},
        {Type.Utf8,  Unicode.UTF_8N,   x"efbbbf",   false},
        {Type.Utf16, Unicode.UTF_16,   null,        true, false, false, Unicode.UTF_16BE},
        {Type.Utf16, Unicode.UTF_16BE, x"feff",     false, true, true},
        {Type.Utf16, Unicode.UTF_16LE, x"fffe",     false, true},
        {Type.Utf32, Unicode.UTF_32,   null,        true, false, false, Unicode.UTF_32BE},
        {Type.Utf32, Unicode.UTF_32BE, x"0000feff", false, true, true},
        {Type.Utf32, Unicode.UTF_32LE, x"fffe0000", false, true},
        ];


        /***********************************************************************
        
                Construct a instance using the given external encoding ~ one 
                of the Unicode.xx types 

        ***********************************************************************/
                                  
        this (int encoding)
        {
                setup (encoding);
        }
        
        /***********************************************************************

                Return the current encoding. This is either the originally
                specified encoding, or a derived one obtained by inspecting
                the content for a BOM. The latter is performed as part of 
                the decode() method

        ***********************************************************************/

        final int getEncoding ()
        {
                return encoding;
        }
        
        /***********************************************************************

                Return the signature (BOM) of the current encoding

        ***********************************************************************/

        final void[] getSignature ()
        {
                return settings.bom;
        }

        /***********************************************************************

                Convert the provided content. The content is inspected 
                for a BOM signature, which is stripped. An exception is
                thrown if a signature is present when, according to the
                encoding type, it should not be. Conversely, An exception
                is thrown if there is no known signature where the current
                encoding expects one to be present

        ***********************************************************************/

        final T[] decode (void[] content, void[] dst=null, uint* ate=null)
        {
                // look for a BOM
                auto info = test (content);

                // are we expecting a BOM?
                if (lookup[encoding].test)
                    if (info)
                       {
                       // yep ~ and we got one
                       setup (info.encoding);

                       // strip BOM from content
                       content = content [info.bom.length .. length];
                       }
                    else
                       // can this encoding be defaulted?
                       if (settings.fallback)
                           setup (settings.fallback);
                       else
                          throw new Error ("UnicodeBom.decode :: unknown or missing BOM");
                else
                   if (info)
                       // found a BOM when using an explicit encoding
                       throw new Error ("UnicodeBom.decode :: explicit encoding does not permit BOM");   
                
                // convert it to internal representation
                return cast(T[]) into.convert (swapBytes(content), settings.type, dst, ate);
        }

        /***********************************************************************

                Perform encoding of content. Note that the encoding must be 
                of the explicit variety by the time we get here

        ***********************************************************************/

        final void[] encode (T[] content, void[] dst=null, uint* ate=null)
        {
                if (settings.test)
                    throw new Error ("UnicodeBom.encode :: cannot write to a non-specific encoding");

                // convert it to external representation, and write
               return swapBytes (from.convert (content, settings.type, dst, ate));
        }

        /***********************************************************************

                Scan the BOM signatures looking for a match. We scan in 
                reverse order to get the longest match first

        ***********************************************************************/

        private final Info* test (void[] content)
        {
                for (Info* info=lookup.ptr+lookup.length; --info >= cast(Info*) lookup;)
                     if (info.bom)
                        {
                        int len = info.bom.length;
                        if (len <= content.length)
                            if (content[0..len] == info.bom[0..len])
                                return info;
                        }
                return null;
        }
        
        /***********************************************************************

                Swap bytes around, as required by the encoding

        ***********************************************************************/

        private final void[] swapBytes (void[] content)
        {
                bool endian = settings.endian;
                bool swap   = settings.bigEndian;

                version (BigEndian)
                         swap = !swap;

                if (endian && swap)
                   {
                   if (settings.type == Type.Utf16)
                       ByteSwap.swap16 (cast(void*) content, content.length);
                   else
                       ByteSwap.swap32 (cast(void*) content, content.length);
                   }
                return content;
        }

        /***********************************************************************

                Configure this instance with unicode converters

        ***********************************************************************/

        public final void setup (int encoding)
        {
                assert (Unicode.isValid (encoding));

                this.settings = &lookup[encoding];
                this.encoding = encoding;
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
