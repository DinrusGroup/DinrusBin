/*******************************************************************************

        @file AnonymousString.d
        
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


        class AnonymousString : UniString
        {
                //reset content
                void set (char[] content);
                void set (wchar[] content);
                void set (dchar[] content);
        }

         class UniString
        {
                // convert content
                abstract char[]  utf8  (char[]  dst = null);
                abstract wchar[] utf16 (wchar[] dst = null);
                abstract dchar[] utf32 (dchar[] dst = null);
        }


        @version        Initial version, December 2005
              
        @author         Kris

*******************************************************************************/

module mango.text.AnonymousString;

private import  mango.convert.Type,
                mango.convert.Unicode;

private import  mango.io.model.IWriter;

private import  mango.text.model.UniString;


/*******************************************************************************

        Anonymous string can used to pass encoding-agnostic content across
        contract boundaries

*******************************************************************************/

class AnonymousString : UniString
{
        private uint    type;
        private bool    local;
        private void[]  buffer;
        private void[]  content;

        /***********************************************************************
        
                Construct an AnonymousString ~ set up conversion buffer

        ***********************************************************************/

        this ()
        {
                buffer = new byte [256];
        }

        /***********************************************************************
        
                Get the encoding type

        ***********************************************************************/	

	uint getEncoding()
	{
		return type;
	}

        /***********************************************************************
        
                Set utf8 content

        ***********************************************************************/

        AnonymousString set (char[] content)
        {
                return set (content, Type.Utf8);
        }

        /***********************************************************************
        
                Set utf16 content

        ***********************************************************************/

        AnonymousString set (wchar[] content)
        {
                return set (content, Type.Utf16);
        }

        /***********************************************************************
        
                Set utf32 content

        ***********************************************************************/

        AnonymousString set (dchar[] content)
        {
                return set (content, Type.Utf32);
        }

        /***********************************************************************
        
                Emit content to the provided writer  (IWritable interface)

        ***********************************************************************/
       
        void write (IWriter write)
        {       
                switch (type)
                       {
                       case Type.Utf32:
                            write (cast(dchar[]) content);
                            break;

                       case Type.Utf16:
                            write (cast(wchar[]) content);
                            break;

                       case Type.Utf8:
                            write (cast(char[]) content);
                            break;

                       default:
                            assert(0);
                       }
        }

        /***********************************************************************
        
                Set content

        ***********************************************************************/

        private AnonymousString set (void[] content, uint type)
        {
                this.content = content;
                this.type = type;
                return this;
        }

        /***********************************************************************

                Convert to the UniString types. The optional argument
                dst will be resized as required to house the conversion. 
                To minimize heap allocation, use the following pattern:

                        String  string;

                        wchar[] buffer;
                        wchar[] result = string.toUtf16 (buffer);

                        if (result.length > buffer.length)
                            buffer = result;

               You can also provide a buffer from the stack, but the output 
               will be moved to the heap if said buffer is not large enough

        ***********************************************************************/

        char[] utf8 (char[] dst = null)
        {
                return cast(char[]) convert (dst, Type.Utf8, null);
        }

        wchar[] utf16 (wchar[] dst = null)
        {
                return cast(wchar[]) convert (dst, Type.Utf16, null);
        }

        dchar[] utf32 (dchar[] dst = null)
        {
                return cast(dchar[]) convert (dst, Type.Utf32, null);
        }

        /***********************************************************************

                Convert to the UniString types. Output buffer argument
                dst will be resized as required to house the conversion. 
                To minimize heap allocation, use the following pattern:

                        String  string;

                        wchar[] buffer;
                        wchar[] result = string.toUtf16 (buffer);

                        if (result.length > buffer.length)
                            buffer = result;

               You can also provide a buffer from the stack, but the output 
               will be moved to the heap if said buffer is not large enough

        ***********************************************************************/

        protected void[] convert (void[] dst, uint dstType, uint* ate)
        {
                enum  {char2char,  char2wchar,  char2dchar, 
                       wchar2char, wchar2wchar, wchar2dchar, 
                       dchar2char, dchar2wchar, dchar2dchar};

                const int[][3] router = [
                                        [char2char,  char2wchar,  char2dchar], 
                                        [wchar2char, wchar2wchar, wchar2dchar], 
                                        [dchar2char, dchar2wchar, dchar2dchar], 
                                        ];


                uint srcType = type;
                srcType -= Type.Utf8;
                dstType -= Type.Utf8;
                assert (srcType < 3);
                assert (dstType < 3);
               
                local = false;
                if (dst is null)
                   {
                   local = true;
                   dst = buffer;
                   }
                    
                switch (router[srcType][dstType])
                       {
                       case char2char: 
                            return content;

                       case char2wchar: 
                            return update (Unicode.toUtf16 (cast(char[]) content, cast(wchar[]) dst, ate));

                       case char2dchar: 
                            return update (Unicode.toUtf32 (cast(char[]) content, cast(dchar[]) dst, ate));


                       case wchar2char: 
                            return update(Unicode.toUtf8 (cast(wchar[]) content, cast(char[]) dst, ate));

                       case wchar2wchar:
                            return content; 

                       case wchar2dchar: 
                            return update (Unicode.toUtf32 (cast(wchar[]) content, cast(dchar[]) dst, ate));


                       case dchar2char: 
                            return update (Unicode.toUtf8 (cast(dchar[]) content, cast(char[]) dst, ate));

                       case dchar2wchar: 
                            return update (Unicode.toUtf16 (cast(dchar[]) content, cast(wchar[]) dst, ate));

                       case dchar2dchar: 
                            return content;

                       default:
                            break;
                       }
                return null;
        }

        /***********************************************************************

        ***********************************************************************/

        private void[] update (void[] ret)
        {
                if (local && ret.length > buffer.length)
                    buffer = ret;
                return ret;
        }
}       

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
