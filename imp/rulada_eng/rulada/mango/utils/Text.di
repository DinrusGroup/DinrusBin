/*******************************************************************************

        @file Text.d
        
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

module mango.utils.Text;

/******************************************************************************

        Placeholder for a variety of wee functions. Some of these are
        handy for Java programmers, but the primary reason for their
        existance is that they don't allocate memory ~ processing is 
        performed in-place.


        *** This module is now deprecated in favour of mango.text.Text ***

******************************************************************************/

struct TextTemplate(T)
{
        /**********************************************************************

                Replace all instances of one char with another (in place)

        **********************************************************************/

        deprecated final static T[] replace (T[] source, T match, T replacement)
        {
                T*  p;
                T*  scan = cast(T*) source;
                int length = source.length;

                while ((p = locate (scan, match, length)) != null)
                      {
                      *p = replacement;
                      length -= (p - scan);
                      scan = p;
                      }
                return source;
        }

        /**********************************************************************

                Return the index of the first instance of 'match', starting
                at position 'start'
                
        **********************************************************************/

        deprecated final static int indexOf (T[] source, T match, int start=0)
        {
                if (start < source.length)
                   {
                   T *p = locate (&source[start], match, source.length - start);
                   if (p)
                       return start + (p - &source[start]);
                   }
                return -1;
        }

        /**********************************************************************

                Return the index of the first instance of 'match', starting
                at position 'start'
                
        **********************************************************************/

        deprecated final static int indexOf (T[] source, T[] match, int start=0)
        {
                int length = match.length;
                int extent = source.length - length + 1;
                
                if (length)
                   {
                   T* p;
                   T  c = match[0];

                   for (; start < extent; ++start)
                          if ((p = locate (&source[start], c, extent-start)) != null)
                              if (equal (p, cast(char*) match, length))
                                  start = p - source.ptr;
                              else
                                 return start;
                    }
                return -1;
        }

        /**********************************************************************

                Is the argument a whitespace character?

        **********************************************************************/

        deprecated final static bool isSpace (T c)
        {
                return cast(bool) (c is ' ' || c is '\t' || c is '\r' || c is '\n');
        }

        /**********************************************************************

                Trim the provided string by stripping whitespace from 
                both ends. Returns a slice of the original content.

        **********************************************************************/

        deprecated final static T[] trim (T[] source)
        {
                if (source.length)
                   {
                   int  front,
                        back = source.length;

                   while (front < back && isSpace(source[front]))
                          ++front;

                   while (back > front && isSpace(source[back-1]))
                          --back;
                   
                   if (front > 0 || back < source.length)   
                       return source[front..back];
                   } 
                return source;
        }

        /**********************************************************************

                
        **********************************************************************/

        deprecated final static T[][] split (T[] src, T[] delim)
        {
                int     pos,
                        mark;
                T[][]   ret;

                assert (delim.length);
                while ((pos = indexOf (src, delim, pos)) >= 0)
                      { 
                      ret ~= src [mark..pos];
                      pos += delim.length;
                      mark = pos;
                      }

                if (mark < src.length)
                    ret ~= src [mark..src.length];
                return ret;                                      
        }

        /**********************************************************************

        **********************************************************************/

        version (X86)
        {
                static if (is(T == char))
                {
                        static char* locate (char* s, char match, int length)
                        {
                                asm 
                                {
                                mov   EDI, s;
                                mov   ECX, length; 
                                movzx EAX, match;

                                cld;
                                repnz;
                                scasb;
                                jz    ok;
                                xor   EAX, EAX;
                                jmp   fail;
                        ok:
                                lea   EAX, [EDI-1];
                        fail:;
                                }
                        }

                        static bool equal (char* s, char* d, int length)
                        {
                                asm 
                                {
                                mov   EDI, s;
                                mov   ESI, d;
                                mov   ECX, length; 
                                xor   EAX, EAX;

                                cld;
                                repz;
                                cmpsb;
                                jnz   fail;
                                inc   EAX;
                        fail:;
                                }
                        }
                }        

                static if (is(T == wchar))
                {
                        static wchar* locate (wchar* s, wchar match, int length)
                        {
                                asm 
                                {
                                mov   EDI, s;
                                mov   ECX, length; 
                                movzx EAX, match;

                                cld;
                                repnz;
                                scasw;
                                jz    ok;
                                xor   EAX, EAX;
                                jmp   fail;
                        ok:
                                lea   EAX, [EDI-2];
                        fail:;
                                }
                        }

                        static bool equal (wchar* s, wchar* d, int length)
                        {
                                asm 
                                {
                                mov   EDI, s;
                                mov   ESI, d;
                                mov   ECX, length; 
                                xor   EAX, EAX;

                                cld;
                                repz;
                                cmpsw;
                                jnz   fail;
                                inc   EAX;
                        fail:;
                                }
                        }
                }        

                static if (is(T == dchar))
                {
                        static dchar* locate (dchar* s, dchar match, int length)
                        {
                                asm 
                                {
                                mov   EDI, s;
                                mov   ECX, length; 
                                mov   EAX, match;

                                cld;
                                repnz;
                                scasd;
                                jz    ok;
                                xor   EAX, EAX;
                                jmp   fail;
                        ok:
                                lea   EAX, [EDI-4];
                        fail:;
                                }
                        }

                        static bool equal (dchar* s, dchar* d, int length)
                        {
                                asm 
                                {
                                mov   EDI, s;
                                mov   ESI, d;
                                mov   ECX, length; 
                                xor   EAX, EAX;

                                cld;
                                repz;
                                cmpsd;
                                jnz   fail;
                                inc   EAX;
                        fail:;
                                }
                        }
                }    
        }
        else
        {
                static T* locate (T* s, T match, int len)
                {
                        while (len--)
                               if (*s++ == match)
                                   return s-1;
                        return null;
                }
                
                static bool equal (T* s, T* d, int len)
                {
                        while (len--)
                               if (*s++ != *d++)
                                   return false;
                        return true;
                }
                
        }    
}


/******************************************************************************

        Placeholder for a variety of wee functions. Some of these are
        handy for Java programmers, but the primary reason for their
        existance is that they don't allocate memory ~ processing is 
        performed in-place.

******************************************************************************/

alias TextTemplate!(char) Text;



/******************************************************************************

******************************************************************************/

unittest
{
        try 
        {
        char[] test = "123456789";
        assert (Text.locate (test, 'a', test.length) == null);
        assert (Text.locate (test, '3', test.length) == &test[2]);
        assert (Text.locate (test, '1', test.length) == &test[0]);

        assert (Text.equal (test, test, test.length));
        assert (!Text.equal (test, "qwe", 3));
        } catch (Object o)
                 Cout (o.toString() ~ "\n");
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
